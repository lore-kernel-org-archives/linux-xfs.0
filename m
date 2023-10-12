Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E33E3CDB46E
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Oct 2023 18:26:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234193AbjJLS0l (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 12 Oct 2023 14:26:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231566AbjJLS0l (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 12 Oct 2023 14:26:41 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50D3BC0
        for <linux-xfs@vger.kernel.org>; Thu, 12 Oct 2023 11:26:39 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFF54C433C7;
        Thu, 12 Oct 2023 18:26:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1697135199;
        bh=L1o33/RWGxKuyoF5245jAu5F9HyjDyJ+DCuuGxQbp/w=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=kFPZE5X83eoSRTv+/QeS9lUj6siTvqIqn3WyuwwGJTy+i/BFPHa6ha2weIpZKL2dY
         oidP9aW8XaIcVBYuHckeV9ocm0riUF7CMlfibAfzoemz0/2UkT8P28htGIddMu5GyT
         tdI1eXnXFH+XtX/bK1cbwIxYpZubsFi58i6njcr7g60+BPry6aysGcA2rcph7smh3B
         ZKUog+8G6MlbOokEFYXbGzVUUmYpT4usVgdwoLBXROTyy5cQ+/rzu/BYk3iQLhND5n
         bw7kMB2lv04q0R2DYGs/wVdn5GTgVOxdej12QQA3WLkAW6BXTGEm6IobGv68os+uVI
         EWx+bqhVc9qMg==
Date:   Thu, 12 Oct 2023 11:26:38 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org, osandov@osandov.com
Subject: Re: [PATCH 3/8] xfs: convert open-coded xfs_rtword_t pointer
 accesses to helper
Message-ID: <20231012182638.GM21298@frogsfrogsfrogs>
References: <169704721623.1773834.8031427054893583456.stgit@frogsfrogsfrogs>
 <169704721677.1773834.5979493182560391662.stgit@frogsfrogsfrogs>
 <20231012053954.GB2795@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231012053954.GB2795@lst.de>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Oct 12, 2023 at 07:39:54AM +0200, Christoph Hellwig wrote:
> On Wed, Oct 11, 2023 at 11:07:01AM -0700, Darrick J. Wong wrote:
> > +/* Return a pointer to a bitmap word within a rt bitmap block buffer. */
> > +static inline xfs_rtword_t *
> > +xfs_rbmbuf_wordptr(
> > +	void			*buf,
> > +	unsigned int		rbmword)
> > +{
> > +	xfs_rtword_t		*wordp = buf;
> > +
> > +	return &wordp[rbmword];
> 
> Superficial nitpick, I find the array dereference syntax here highly
> confusing as the passed in pointer is not an array at all.
> 
> In fact I wonder what the xfs_rbmbuf_wordptr helper is for?  Even
> looking at your full patch stack xfs_rbmblock_wordptr seems like
> the only user.

IIRC an earlier version of this patchset actually tried to use
xfs_rbmbuf_wordptr in the online repair code when it was building the
new rtbitmap file contents.  At some point I must've decided that it was
easier to access the xfile directly.

So, yes, this helper can be deleted.

> > +/* Return a pointer to a bitmap word within a rt bitmap block. */
> > +static inline xfs_rtword_t *
> > +xfs_rbmblock_wordptr(
> > +	struct xfs_buf		*bp,
> > +	unsigned int		rbmword)
> > +{
> > +	return xfs_rbmbuf_wordptr(bp->b_addr, rbmword);
> 
> So I'd much rather just open code this as:
> 
> 	xfs_rtword_t		*words = bp->b_addr;
> 
> 	return words + rbmword;
> 
> and if I want to get really fancy I'd maybe rename rbmword to
> something like index which feels more readable than rbmword.

Done.

> That beeing said the xfs_rbmblock_wordptr abstraction is very welcome.

Thanks!

--D

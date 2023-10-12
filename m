Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B3DCCDB46E
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Oct 2023 05:40:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235289AbjJLFj7 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 12 Oct 2023 01:39:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232808AbjJLFj7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 12 Oct 2023 01:39:59 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41633B7
        for <linux-xfs@vger.kernel.org>; Wed, 11 Oct 2023 22:39:58 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 05D9E6732D; Thu, 12 Oct 2023 07:39:55 +0200 (CEST)
Date:   Thu, 12 Oct 2023 07:39:54 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, osandov@osandov.com, hch@lst.de
Subject: Re: [PATCH 3/8] xfs: convert open-coded xfs_rtword_t pointer
 accesses to helper
Message-ID: <20231012053954.GB2795@lst.de>
References: <169704721623.1773834.8031427054893583456.stgit@frogsfrogsfrogs> <169704721677.1773834.5979493182560391662.stgit@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <169704721677.1773834.5979493182560391662.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Oct 11, 2023 at 11:07:01AM -0700, Darrick J. Wong wrote:
> +/* Return a pointer to a bitmap word within a rt bitmap block buffer. */
> +static inline xfs_rtword_t *
> +xfs_rbmbuf_wordptr(
> +	void			*buf,
> +	unsigned int		rbmword)
> +{
> +	xfs_rtword_t		*wordp = buf;
> +
> +	return &wordp[rbmword];

Superficial nitpick, I find the array dereference syntax here highly
confusing as the passed in pointer is not an array at all.

In fact I wonder what the xfs_rbmbuf_wordptr helper is for?  Even
looking at your full patch stack xfs_rbmblock_wordptr seems like
the only user.

> +/* Return a pointer to a bitmap word within a rt bitmap block. */
> +static inline xfs_rtword_t *
> +xfs_rbmblock_wordptr(
> +	struct xfs_buf		*bp,
> +	unsigned int		rbmword)
> +{
> +	return xfs_rbmbuf_wordptr(bp->b_addr, rbmword);

So I'd much rather just open code this as:

	xfs_rtword_t		*words = bp->b_addr;

	return words + rbmword;

and if I want to get really fancy I'd maybe rename rbmword to
something like index which feels more readable than rbmword.

That beeing said the xfs_rbmblock_wordptr abstraction is very welcome.

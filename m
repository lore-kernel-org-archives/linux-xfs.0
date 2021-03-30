Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88B11C433DB
	for <linux-xfs@archiver.kernel.org>; Tue, 30 Mar 2021 18:07:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 44A43619D4
	for <linux-xfs@archiver.kernel.org>; Tue, 30 Mar 2021 18:07:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232511AbhC3SHP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 30 Mar 2021 14:07:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:38908 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232419AbhC3SGy (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 30 Mar 2021 14:06:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D48FB619CA;
        Tue, 30 Mar 2021 18:06:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617127614;
        bh=ubQwnwOQfmHTNAeISB+nxbowEV+xFfFSZUmmweIz6lo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=CpfFlMjtBeQuNBE0b+nP/mCSKq2JHWVb36+JIHN7R2v0lTghyndk61a1wxCGLPTKl
         XwcQJaC7Vdfma22kTnabqV5Sc+hwx3UUgpAoWXqUxyhF/Na+bF1uv5Y8aYZhzzXkXb
         sWhJKegDJXzrVLh4KKV4F0VH7WV4sA4oN4o3I5ap7gZq/DFY6oJ4Jy5GKjlL6AbTTC
         8/xWlA8emetmtzAHsIFk9wh0bH/71ABW9jd08seo2dZuYxFOppPKYVh6OQRQ2eDhmn
         dh6CVLBjeOwxTYshEy6eHEV2akjX/cr948RBp15zGY3THni7RJTqYe8t9A6P6LOiYg
         LIw0o3OeytX+w==
Date:   Tue, 30 Mar 2021 11:06:51 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 20/20] xfs: merge _xfs_dic2xflags into xfs_ip2xflags
Message-ID: <20210330180651.GS4090233@magnolia>
References: <20210329053829.1851318-1-hch@lst.de>
 <20210329053829.1851318-21-hch@lst.de>
 <20210330152538.GP4090233@magnolia>
 <20210330173154.GA14827@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210330173154.GA14827@lst.de>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Mar 30, 2021 at 07:31:54PM +0200, Christoph Hellwig wrote:
> On Tue, Mar 30, 2021 at 08:25:38AM -0700, Darrick J. Wong wrote:
> > On Mon, Mar 29, 2021 at 07:38:29AM +0200, Christoph Hellwig wrote:
> > > Merge _xfs_dic2xflags into its only caller.
> > > 
> > > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > 
> > /me wonders if/how this will clash with Miklos' fileattr series, but eh,
> > whatever, I don't think it will, and if it does it's easy enough to fix.
> 
> Feel free to drop the patch for now, it is not in any way urgent.

I'll take it for now, since I have no idea if that fileattr series is
targeted for 5.13.

--D

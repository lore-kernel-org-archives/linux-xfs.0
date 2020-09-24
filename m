Return-Path: <SRS0=cWrc=DB=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9AD0C4346E
	for <linux-xfs@archiver.kernel.org>; Thu, 24 Sep 2020 05:40:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7D1A820BED
	for <linux-xfs@archiver.kernel.org>; Thu, 24 Sep 2020 05:40:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="c8rZgUwR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726788AbgIXFky (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 24 Sep 2020 01:40:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726773AbgIXFky (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 24 Sep 2020 01:40:54 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BE38C0613CE
        for <linux-xfs@vger.kernel.org>; Wed, 23 Sep 2020 22:40:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=wbvkbDdxpc9ZH4/SRr9SEvPtgWGFSLDhumdGe47f3mE=; b=c8rZgUwRBU08rKnn/sNCwCN5no
        iDpot6TQVaaz9vsoipd+V7CH8jpPZq482hFUzIdQJg1tUWmoVB92BAYM3STwhKOp/TTdkg8zECk1n
        4Hz4E5yAkxknVKcXb9Z3/hhNZEVhzFuRpvjdkYYWLzQs6XWEDDyQNPGC+mftH8UEOFxNk60rvLeKR
        BmTCSIaz/HyP6vljomSy78AuZL5ZofrtR1r8Kwjw6Ymcqdcljzw6FpFCuUsAbhF/BbZTl+oCJ3aRy
        on76AVLYM8XIUEnTPMCSPK9XDViYfaOo/pc+JbrsFZWYvhfjmhtIY943OnMekMTQdY4fAt62GNUSw
        g5Qw6xvQ==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kLJzl-0005bg-S1; Thu, 24 Sep 2020 05:40:41 +0000
Date:   Thu, 24 Sep 2020 06:40:41 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Eric Sandeen <sandeen@redhat.com>, xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs_repair: coordinate parallel updates to the rt bitmap
Message-ID: <20200924054041.GA21542@infradead.org>
References: <20200923182437.GW7955@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200923182437.GW7955@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Sep 23, 2020 at 11:24:37AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Actually take the rt lock before updating the bitmap from multiple
> threads.  This fixes an infrequent corruption problem when running
> generic/013 and rtinherit=1 is set on the root dir.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  repair/dinode.c |    4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/repair/dinode.c b/repair/dinode.c
> index 57013bf149b2..07f3f83aef8c 100644
> --- a/repair/dinode.c
> +++ b/repair/dinode.c
> @@ -184,6 +184,7 @@ process_rt_rec(
>  	xfs_rfsblock_t		*tot,
>  	int			check_dups)
>  {
> +	struct aglock		*lock = &ag_locks[(signed)NULLAGNUMBER];

Err, what is this weird cast doing here?

The rest looks sane.

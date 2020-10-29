Return-Path: <SRS0=cOuX=EE=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90AC5C2D0A3
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Oct 2020 09:47:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0B2DB20790
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Oct 2020 09:47:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="I+xbQP8q"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726666AbgJ2JrQ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 29 Oct 2020 05:47:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726572AbgJ2JrQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 29 Oct 2020 05:47:16 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4ACE9C0613CF
        for <linux-xfs@vger.kernel.org>; Thu, 29 Oct 2020 02:47:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=IJQ2FA42DuC14WXSqMctBlI/vDvOBlDcJsCt8FRD5Ek=; b=I+xbQP8qZI6DhCQhJlQLHxMXhz
        2JTEGbX/FisCKrbM7NRvuL/lAUqrdNWAcmhBtSlwgceycfWAEKztZDfbkiBUSSQN2LTG97cJHak5q
        69Xd5KmUHJ/wwbZikEkFA99WrKR4iVqjkh15zm5RZ4e84Pv7ypLmXylCSEk//mfv63s+BH149HgW2
        c+MtnAtWwXvu0vmKyzvI4p/nDTpinLm0yAHBxmnxoW99kc62lRnHEf3ZR3hhTesFASnODfYsvYy3b
        xx446HFWA9bKPEr/bVNvsMnIGMefeW8DhVaRZgtsDG1P6gNNydsQU4HTOzsAIFmpw7KDAg3Ixc6Pf
        92hZ99xw==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kY4WW-0001Wh-Vk; Thu, 29 Oct 2020 09:47:13 +0000
Date:   Thu, 29 Oct 2020 09:47:12 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 05/26] xfs_quota: convert time_to_string to use time64_t
Message-ID: <20201029094712.GI2091@infradead.org>
References: <160375524618.881414.16347303401529121282.stgit@magnolia>
 <160375527834.881414.2581158648212089750.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <160375527834.881414.2581158648212089750.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Oct 26, 2020 at 04:34:38PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Rework the time_to_string helper to be capable of dealing with 64-bit
> timestamps.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  quota/quota.c  |   16 ++++++++++------
>  quota/quota.h  |    2 +-
>  quota/report.c |   16 ++++++++++------
>  quota/util.c   |    5 +++--
>  4 files changed, 24 insertions(+), 15 deletions(-)
> 
> 
> diff --git a/quota/quota.c b/quota/quota.c
> index 9545cc430a93..8ba0995d9174 100644
> --- a/quota/quota.c
> +++ b/quota/quota.c
> @@ -48,6 +48,7 @@ quota_mount(
>  	uint		flags)
>  {
>  	fs_disk_quota_t	d;
> +	time64_t	timer;
>  	char		*dev = mount->fs_name;
>  	char		c[8], h[8], s[8];
>  	uint		qflags;
> @@ -100,6 +101,7 @@ quota_mount(
>  	}
>  
>  	if (form & XFS_BLOCK_QUOTA) {
> +		timer = d.d_btimer;
>  		qflags = (flags & HUMAN_FLAG);
>  		if (d.d_blk_hardlimit && d.d_bcount > d.d_blk_hardlimit)
>  			qflags |= LIMIT_FLAG;
> @@ -111,16 +113,17 @@ quota_mount(
>  				bbs_to_string(d.d_blk_softlimit, s, sizeof(s)),
>  				bbs_to_string(d.d_blk_hardlimit, h, sizeof(h)),
>  				d.d_bwarns,
> -				time_to_string(d.d_btimer, qflags));
> +				time_to_string(timer, qflags));

What do the local variables buy us over just relying on the implicit cast
to a larger integer type?

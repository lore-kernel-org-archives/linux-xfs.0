Return-Path: <SRS0=yXRu=2O=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 794BFC2D0CF
	for <linux-xfs@archiver.kernel.org>; Tue, 24 Dec 2019 08:45:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4ADC9206CB
	for <linux-xfs@archiver.kernel.org>; Tue, 24 Dec 2019 08:45:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="dqFhzp7S"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726068AbfLXIpS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 24 Dec 2019 03:45:18 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:36342 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726047AbfLXIpS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 24 Dec 2019 03:45:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=SBlyM3tWHI25Sz7v/cjt5Ay7mLJRoQCMkKNrRJl+b8I=; b=dqFhzp7SHFCKCb3kOeXdh4oGw
        OUvtYdUbJsWaVqkNeoxgXdMCNwBVAn59DF/2pPw5frxhBkta1Bht5bV66K0c7X7w65CXu3ei+Yeo/
        ytoGFG/rBZMG7MeirUKJAdJZm1jg+oFlbepQ86HUmelYYXnTbvUoQjJXyFaQtI/EvEeriKE4wyGsf
        vOgj3KprqUyCBr9AGL2FZI2vXWqn94s/DgK9pbggcsQsws3GMdD1OKZyThMJJpxu96uPsLqK3ev0Y
        q9ur/AMFMkrE/mRdCEzucCshDuIdfqFPLW6brLVJJ3XCPBq4KnLlNXMSBfCoe1lJYZ9Xn8OK2EUIN
        mBQEY87dw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1ijfoY-00041S-H6; Tue, 24 Dec 2019 08:45:14 +0000
Date:   Tue, 24 Dec 2019 00:45:14 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     "Darrick J . Wong" <darrick.wong@oracle.com>,
        linux-xfs@vger.kernel.org, y2038@lists.linaro.org,
        Brian Foster <bfoster@redhat.com>,
        Dave Chinner <dchinner@redhat.com>,
        Allison Collins <allison.henderson@oracle.com>,
        Jan Kara <jack@suse.cz>, Eric Sandeen <sandeen@sandeen.net>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] xfs: disallow broken ioctls without
 compat-32-bit-time
Message-ID: <20191224084514.GC1739@infradead.org>
References: <20191218163954.296726-1-arnd@arndb.de>
 <20191218163954.296726-2-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191218163954.296726-2-arnd@arndb.de>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Dec 18, 2019 at 05:39:29PM +0100, Arnd Bergmann wrote:
> +/* disallow y2038-unsafe ioctls with CONFIG_COMPAT_32BIT_TIME=n */
> +static bool xfs_have_compat_bstat_time32(unsigned int cmd)
> +{
> +	if (IS_ENABLED(CONFIG_COMPAT_32BIT_TIME))
> +		return true;
> +
> +	if (IS_ENABLED(CONFIG_64BIT) && !in_compat_syscall())
> +		return true;
> +
> +	if (cmd == XFS_IOC_FSBULKSTAT_SINGLE ||
> +	    cmd == XFS_IOC_FSBULKSTAT ||
> +	    cmd == XFS_IOC_SWAPEXT)
> +		return false;
> +
> +	return true;

I think the check for the individual command belongs into the callers,
which laves us with:

static inline bool have_time32(void)
{
	return IS_ENABLED(CONFIG_COMPAT_32BIT_TIME) ||
		(IS_ENABLED(CONFIG_64BIT) && !in_compat_syscall());
}

and that looks like it should be in a generic helper somewhere.


>  STATIC int
>  xfs_ioc_fsbulkstat(
>  	xfs_mount_t		*mp,
> @@ -637,6 +655,9 @@ xfs_ioc_fsbulkstat(
>  	if (!capable(CAP_SYS_ADMIN))
>  		return -EPERM;
>  
> +	if (!xfs_have_compat_bstat_time32(cmd))
> +		return -EINVAL;

Here we can simply check for cmd != XFS_IOC_FSINUMBERS before the call.

>  	if (XFS_FORCED_SHUTDOWN(mp))
>  		return -EIO;
>  
> @@ -1815,6 +1836,11 @@ xfs_ioc_swapext(
>  	struct fd	f, tmp;
>  	int		error = 0;
>  
> +	if (!xfs_have_compat_bstat_time32(XFS_IOC_SWAPEXT)) {
> +		error = -EINVAL;
> +		goto out;
> +	}

And for this one we just have one cmd anyway.  But I actually still
disagree with the old_time check for this one entirely, as voiced on
one of the last iterations.  For swapext the time stamp really is
only used as a generation counter, so overflows are entirely harmless.

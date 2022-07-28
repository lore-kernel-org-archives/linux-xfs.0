Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2361AC19F2B
	for <linux-xfs@archiver.kernel.org>; Thu, 28 Jul 2022 19:01:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232758AbiG1TBM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 28 Jul 2022 15:01:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232797AbiG1TBK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 28 Jul 2022 15:01:10 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9CBB20BD6;
        Thu, 28 Jul 2022 12:01:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=UafGw2EVkWf7xw0lCVVLweQzqXZTL2gbUMFOsuQlkes=; b=xlY0I8co6ewGazVIqw0Fep+N2z
        7xMFWU7u1lrqLByZojt5bWCPqDYTjILllTjI1Sm3dYGvOYVte7SUkItDfR9qR1TTGzr4lrIm/uSe+
        Uz2AgAehhECeuO+P7z4hzAR7wG1kjH4lJQJtHlPFbIbtNq1jhaG2oyNcP28RhoBOsYYMGRC/8qf8o
        TxU/l0SHzNc53fIL3iGXGuhTFkL3+rdmYkutiLWPIMwZNrpk5voeNGwN/SA8u/9WGZiiLOl1qYkwv
        W1suDmLvaL7KlbwJLg3Cn9+jy0EdDQaY4NX37a8JqhZR1BcpZt1UVLdUFmBIDsjMsueqiuTPSj7Mb
        xZumKV8Q==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1oH8kr-00DNNC-D9; Thu, 28 Jul 2022 19:01:05 +0000
Date:   Thu, 28 Jul 2022 12:01:05 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     guaneryu@gmail.com, zlang@redhat.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org, guan@eryu.me
Subject: Re: [PATCH 1/2] common: refactor fail_make_request boilerplate
Message-ID: <YuLc8eIfTXTIT/Ca@infradead.org>
References: <165886493457.1585218.32410114728132213.stgit@magnolia>
 <165886494011.1585218.15776043472701680079.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <165886494011.1585218.15776043472701680079.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jul 26, 2022 at 12:49:00PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Refactor the control functions from generic/019 into a common helper to
> be used by all three tests that use fail_make_requests.

There is btrfs/271 as well with similar boilerplate as well, which
is why I've been looking into refactoring it before.

> +_start_fail_scratch_dev()
> +{
> +    local SYSFS_BDEV=`_sysfs_dev $SCRATCH_DEV`
> +    echo "Force SCRATCH_DEV device failure"
> +    echo " echo 1 > $SYSFS_BDEV/make-it-fail" >> $seqres.full
> +    echo 1 > $SYSFS_BDEV/make-it-fail
> +}

.. and for that use cases we need to pass an explicit device here, and
not just default to $SCRATCH_DEV.  

>  enable_io_failure()
>  {
> +	_allow_fail_make_request 100 1000 > /dev/null
> +	_start_fail_scratch_dev > /dev/null
>  }
>  
>  disable_io_failure()
>  {
> +	_stop_fail_scratch_dev > /dev/null
> +	_disallow_fail_make_request > /dev/null
>  }

Let's just drop these wrappers.

Otherwise this looks really nice.

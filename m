Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 278C2C433E6
	for <linux-xfs@archiver.kernel.org>; Tue, 16 Feb 2021 01:05:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0034D64DAF
	for <linux-xfs@archiver.kernel.org>; Tue, 16 Feb 2021 01:05:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229807AbhBPBFJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 15 Feb 2021 20:05:09 -0500
Received: from sandeen.net ([63.231.237.45]:42250 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229710AbhBPBFI (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 15 Feb 2021 20:05:08 -0500
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 427C648C68A;
        Mon, 15 Feb 2021 19:04:20 -0600 (CST)
To:     Gao Xiang <hsiangkao@redhat.com>, linux-xfs@vger.kernel.org
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        Brian Foster <bfoster@redhat.com>,
        Eric Sandeen <sandeen@redhat.com>,
        Dave Chinner <david@fromorbit.com>
References: <20201013040627.13932-1-hsiangkao@redhat.com>
 <20201013040627.13932-4-hsiangkao@redhat.com>
From:   Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [PATCH v6 3/3] mkfs: make use of xfs_validate_stripe_geometry()
Message-ID: <320d0635-2fbf-dd44-9f39-eaea48272bc7@sandeen.net>
Date:   Mon, 15 Feb 2021 19:04:25 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20201013040627.13932-4-hsiangkao@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 10/12/20 11:06 PM, Gao Xiang wrote:
> Check stripe numbers in calc_stripe_factors() by using
> xfs_validate_stripe_geometry().
> 
> Signed-off-by: Gao Xiang <hsiangkao@redhat.com>

Hm, unless I have made a mistake, this seems to allow an invalid
stripe specification.

Without this patch, this fails:

# mkfs/mkfs.xfs -f -d su=4097,sw=1 /dev/loop0
data su must be a multiple of the sector size (512)

With the patch:

# mkfs/mkfs.xfs -f -d su=4097,sw=1 /dev/loop0
meta-data=/dev/loop0             isize=512    agcount=8, agsize=32768 blks
         =                       sectsz=512   attr=2, projid32bit=1
         =                       crc=1        finobt=1, sparse=1, rmapbt=0
         =                       reflink=1    bigtime=0
data     =                       bsize=4096   blocks=262144, imaxpct=25
         =                       sunit=1      swidth=1 blks
naming   =version 2              bsize=4096   ascii-ci=0, ftype=1
log      =internal log           bsize=4096   blocks=2560, version=2
         =                       sectsz=512   sunit=1 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0
Discarding blocks...Done.

When you are back from holiday, can you check? No big rush.

Thanks,
-Eric

> ---
>  libxfs/libxfs_api_defs.h |  1 +
>  mkfs/xfs_mkfs.c          | 23 +++++++----------------
>  2 files changed, 8 insertions(+), 16 deletions(-)
> 
> diff --git a/libxfs/libxfs_api_defs.h b/libxfs/libxfs_api_defs.h
> index e7e42e93..306d0deb 100644
> --- a/libxfs/libxfs_api_defs.h
> +++ b/libxfs/libxfs_api_defs.h
> @@ -188,6 +188,7 @@
>  #define xfs_trans_roll_inode		libxfs_trans_roll_inode
>  #define xfs_trans_roll			libxfs_trans_roll
>  
> +#define xfs_validate_stripe_geometry	libxfs_validate_stripe_geometry
>  #define xfs_verify_agbno		libxfs_verify_agbno
>  #define xfs_verify_agino		libxfs_verify_agino
>  #define xfs_verify_cksum		libxfs_verify_cksum
> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> index 8fe149d7..aec40c1f 100644
> --- a/mkfs/xfs_mkfs.c
> +++ b/mkfs/xfs_mkfs.c
> @@ -2305,12 +2305,6 @@ _("both data su and data sw options must be specified\n"));
>  			usage();
>  		}
>  
> -		if (dsu % cfg->sectorsize) {
> -			fprintf(stderr,
> -_("data su must be a multiple of the sector size (%d)\n"), cfg->sectorsize);
> -			usage();
> -		}
> -
>  		dsunit  = (int)BTOBBT(dsu);
>  		big_dswidth = (long long int)dsunit * dsw;
>  		if (big_dswidth > INT_MAX) {
> @@ -2322,13 +2316,9 @@ _("data stripe width (%lld) is too large of a multiple of the data stripe unit (
>  		dswidth = big_dswidth;
>  	}
>  
> -	if ((dsunit && !dswidth) || (!dsunit && dswidth) ||
> -	    (dsunit && (dswidth % dsunit != 0))) {
> -		fprintf(stderr,
> -_("data stripe width (%d) must be a multiple of the data stripe unit (%d)\n"),
> -			dswidth, dsunit);
> +	if (!libxfs_validate_stripe_geometry(NULL, BBTOB(dsunit), BBTOB(dswidth),
> +					     cfg->sectorsize, false))
>  		usage();
> -	}
>  
>  	/* If sunit & swidth were manually specified as 0, same as noalign */
>  	if ((cli_opt_set(&dopts, D_SUNIT) || cli_opt_set(&dopts, D_SU)) &&
> @@ -2344,11 +2334,12 @@ _("data stripe width (%d) must be a multiple of the data stripe unit (%d)\n"),
>  
>  	/* if no stripe config set, use the device default */
>  	if (!dsunit) {
> -		/* Ignore nonsense from device.  XXX add more validation */
> -		if (ft->dsunit && ft->dswidth == 0) {
> +		/* Ignore nonsense from device report. */
> +		if (!libxfs_validate_stripe_geometry(NULL, BBTOB(ft->dsunit),
> +				BBTOB(ft->dswidth), 0, true)) {
>  			fprintf(stderr,
> -_("%s: Volume reports stripe unit of %d bytes and stripe width of 0, ignoring.\n"),
> -				progname, BBTOB(ft->dsunit));
> +_("%s: Volume reports invalid stripe unit (%d) and stripe width (%d), ignoring.\n"),
> +				progname, BBTOB(ft->dsunit), BBTOB(ft->dswidth));
>  			ft->dsunit = 0;
>  			ft->dswidth = 0;
>  		} else {
> 

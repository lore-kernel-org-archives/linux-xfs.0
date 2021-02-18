Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7CDD9C433E0
	for <linux-xfs@archiver.kernel.org>; Thu, 18 Feb 2021 16:45:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 51A3064EB2
	for <linux-xfs@archiver.kernel.org>; Thu, 18 Feb 2021 16:45:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233710AbhBRQmY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 18 Feb 2021 11:42:24 -0500
Received: from sandeen.net ([63.231.237.45]:42940 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233785AbhBRQjH (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 18 Feb 2021 11:39:07 -0500
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 1D30B615D7B;
        Thu, 18 Feb 2021 10:38:09 -0600 (CST)
To:     Gao Xiang <hsiangkao@redhat.com>
Cc:     linux-xfs@vger.kernel.org,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Brian Foster <bfoster@redhat.com>,
        Eric Sandeen <sandeen@redhat.com>,
        Dave Chinner <david@fromorbit.com>
References: <20201013040627.13932-1-hsiangkao@redhat.com>
 <20201013040627.13932-4-hsiangkao@redhat.com>
 <320d0635-2fbf-dd44-9f39-eaea48272bc7@sandeen.net>
 <20210218024159.GA145146@xiangao.remote.csb>
 <20210218052454.GA161514@xiangao.remote.csb>
From:   Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [PATCH v6 3/3] mkfs: make use of xfs_validate_stripe_geometry()
Message-ID: <1f63b1b7-71ec-2a03-1053-58a1abd0088a@sandeen.net>
Date:   Thu, 18 Feb 2021 10:38:17 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210218052454.GA161514@xiangao.remote.csb>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 2/17/21 11:24 PM, Gao Xiang wrote:
> On Thu, Feb 18, 2021 at 10:41:59AM +0800, Gao Xiang wrote:
>> Hi Eric,
>>
>> On Mon, Feb 15, 2021 at 07:04:25PM -0600, Eric Sandeen wrote:
>>> On 10/12/20 11:06 PM, Gao Xiang wrote:
>>>> Check stripe numbers in calc_stripe_factors() by using
>>>> xfs_validate_stripe_geometry().
>>>>
>>>> Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
>>>
>>> Hm, unless I have made a mistake, this seems to allow an invalid
>>> stripe specification.
>>>
>>> Without this patch, this fails:
>>>
>>> # mkfs/mkfs.xfs -f -d su=4097,sw=1 /dev/loop0
>>> data su must be a multiple of the sector size (512)
>>>
>>> With the patch:
>>>
>>> # mkfs/mkfs.xfs -f -d su=4097,sw=1 /dev/loop0
>>> meta-data=/dev/loop0             isize=512    agcount=8, agsize=32768 blks
>>>          =                       sectsz=512   attr=2, projid32bit=1
>>>          =                       crc=1        finobt=1, sparse=1, rmapbt=0
>>>          =                       reflink=1    bigtime=0
>>> data     =                       bsize=4096   blocks=262144, imaxpct=25
>>>          =                       sunit=1      swidth=1 blks
>>> naming   =version 2              bsize=4096   ascii-ci=0, ftype=1
>>> log      =internal log           bsize=4096   blocks=2560, version=2
>>>          =                       sectsz=512   sunit=1 blks, lazy-count=1
>>> realtime =none                   extsz=4096   blocks=0, rtextents=0
>>> Discarding blocks...Done.
>>>
>>> When you are back from holiday, can you check? No big rush.
>>
>> I'm back from holiday today. I think the problem is in
>> "if (dsu || dsw) {" it turns into "dsunit  = (int)BTOBBT(dsu);" anyway,
>> and then if (!libxfs_validate_stripe_geometry(NULL, BBTOB(dsunit),
>> 					     BBTOB(dswidth), cfg->sectorsize, false))
>>
>> so dsu isn't checked with sectorsize in advance before it turns into BB.
>>
>> the fix seems simple though,
>> 1) turn dsunit and dswidth into bytes rather than BB, but I have no idea the range of
>>    these 2 varibles, since I saw "if (big_dswidth > INT_MAX) {" but the big_dswidth
>>    was also in BB as well, if we turn these into bytes, and such range cannot be
>>    guarunteed...
>> 2) recover the previous code snippet and check dsu in advance:
>> 		if (dsu % cfg->sectorsize) {
>> 			fprintf(stderr,
>> _("data su must be a multiple of the sector size (%d)\n"), cfg->sectorsize);
>> 			usage();
>> 		}

since we have this check already in xfs_validate_stripe_geometry, it seems best to
keep using it there, and not copy it ... which I think you accomplish below.

>> btw, do we have some range test about these variables? I could rearrange the code
>> snippet, but I'm not sure if it could introduce some new potential regression as well...
>>
>> Thanks,
>> Gao Xiang
> 
> Or how about applying the following incremental patch, although the maximum dswidth
> would be smaller I think, but considering libxfs_validate_stripe_geometry() accepts
> dswidth in 64-bit bytes as well. I think that would be fine. Does that make sense?
> 
> I've confirmed "# mkfs/mkfs.xfs -f -d su=4097,sw=1 /dev/loop0" now report:
> stripe unit (4097) must be a multiple of the sector size (512)
> 
> and xfs/191-input-validation passes now...
> 
> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> index f152d5c7..80405790 100644
> --- a/mkfs/xfs_mkfs.c
> +++ b/mkfs/xfs_mkfs.c
> @@ -2361,20 +2361,24 @@ _("both data su and data sw options must be specified\n"));
>  			usage();
>  		}

Just thinking through this... I think this is the right idea.

> -		dsunit  = (int)BTOBBT(dsu);
> -		big_dswidth = (long long int)dsunit * dsw;
> +		big_dswidth = (long long int)dsu * dsw;

dsu is in bytes; this would mean big_dswidth is now also in bytes...
the original goal here, I think, is to not overflow the 32-bit superblock value
for dswidth.

>  		if (big_dswidth > INT_MAX) {
>  			fprintf(stderr,
>  _("data stripe width (%lld) is too large of a multiple of the data stripe unit (%d)\n"),
>  				big_dswidth, dsunit);

so this used to test big_dswidth in BB (sectors); but now it tests in bytes.

Perhaps this should change to check and report sectors again:

  		if (BTOBBT(big_dswidth) > INT_MAX) {
  			fprintf(stderr,
  _("data stripe width (%lld) is too large of a multiple of the data stripe unit (%d)\n"),
  				BTOBBT(big_dswidth), dsunit);

I think the goal is to not overflow the 32-bit on-disk values, which would be
easy to do with "dsw" specified as a /multiplier/ of "dsu"

So I think that if we keep range checking the value in BB units, it will be
OK.

>  			usage();
>  		}
> -		dswidth = big_dswidth;
> -	}
>  
> -	if (!libxfs_validate_stripe_geometry(NULL, BBTOB(dsunit), BBTOB(dswidth),
> -					     cfg->sectorsize, false))
> +		if (!libxfs_validate_stripe_geometry(NULL, dsu, big_dswidth,
> +						     cfg->sectorsize, false))
> +			usage();
> +
> +		dsunit = BTOBBT(dsu);
> +		dswidth = BTOBBT(big_dswidth);
> +	} else if (!libxfs_validate_stripe_geometry(NULL, BBTOB(dsunit),
> +			BBTOB(dswidth), cfg->sectorsize, false)) {
>  		usage();
> +	}
Otherwise this looks reasonable to me; now it's basically:

1) If we got geometry in bytes, validate them directly
2) If we got geometry in BB, convert to bytes, and validate
3) If we got no geometry, validate the device-reported defaults

Thanks,
-Eric

>  	/* If sunit & swidth were manually specified as 0, same as noalign */
>  	if ((cli_opt_set(&dopts, D_SUNIT) || cli_opt_set(&dopts, D_SU)) &&
> 

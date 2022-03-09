Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12BF4C433F5
	for <linux-xfs@archiver.kernel.org>; Wed,  9 Mar 2022 21:19:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234599AbiCIVUH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 9 Mar 2022 16:20:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233133AbiCIVUH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 9 Mar 2022 16:20:07 -0500
Received: from mail104.syd.optusnet.com.au (mail104.syd.optusnet.com.au [211.29.132.246])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id CE75F818AE
        for <linux-xfs@vger.kernel.org>; Wed,  9 Mar 2022 13:19:07 -0800 (PST)
Received: from dread.disaster.area (pa49-186-150-27.pa.vic.optusnet.com.au [49.186.150.27])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 418B1531756;
        Thu, 10 Mar 2022 08:19:05 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nS3i4-003X9m-Qo; Thu, 10 Mar 2022 08:19:04 +1100
Date:   Thu, 10 Mar 2022 08:19:04 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     David Dal Ben <dalben@gmail.com>,
        Eric Sandeen <esandeen@redhat.com>, linux-xfs@vger.kernel.org
Subject: Re: Inconsistent "EXPERIMENTAL online shrink feature in use. Use at
 your own risk" alert
Message-ID: <20220309211904.GE661808@dread.disaster.area>
References: <CALwRca2+UsEZMPwiCtecM87HVVMs27SdawdWXns+PU7+S-DFaQ@mail.gmail.com>
 <CALwRca3yS2q4XYr5aFaPWxNcGsYRFDWeU9je1q31KGguTeX6Rw@mail.gmail.com>
 <YiYIO2lJf123LA2c@B-P7TQMD6M-0146.local>
 <CALwRca2bZD5tXmL5kzCdL97LpqWGVhYXMNSWSvqn=FkMuMrbjQ@mail.gmail.com>
 <9f957f7a-0f08-9cb4-d8ff-76440a488184@redhat.com>
 <CALwRca2Xdp8F_xjXSFXxO-Ra96W685o2qY1xoo=Ko9OWF4oRvw@mail.gmail.com>
 <20220307233132.GA661808@dread.disaster.area>
 <YiaajBcdSgOyIamT@B-P7TQMD6M-0146.local>
 <CALwRca0TqcKnBkLm=sOjQdvagBjd12m_7uYOhkMt8LjxsmiEtA@mail.gmail.com>
 <95ed03a8-e49b-d109-baba-86a190345102@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <95ed03a8-e49b-d109-baba-86a190345102@sandeen.net>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=VuxAv86n c=1 sm=1 tr=0 ts=622919ca
        a=sPqof0Mm7fxWrhYUF33ZaQ==:117 a=sPqof0Mm7fxWrhYUF33ZaQ==:17
        a=q2rpgJM3of3wzYv4:21 a=kj9zAlcOel0A:10 a=o8Y5sQTvuykA:10 a=7-415B0cAAAA:8
        a=trCeKJ6HQhbzLg0dFkkA:9 a=CjuIK1q_8ugA:10 a=aujFQpqGlDxcc9pqpD-7:22
        a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Mar 09, 2022 at 12:22:00PM -0600, Eric Sandeen wrote:
> So a weird thing here is that I think your logs show the xfs_growfs command
> happening immediately after mount, and it doesn't have any size specified, 
> so I can't tell if the intent was to shrink - but I don't think so:
> 
> Mar  6 19:59:21 tdm emhttpd: shcmd (81): mkdir -p /mnt/disk1
> Mar  6 19:59:21 tdm emhttpd: shcmd (82): mount -t xfs -o noatime /dev/md1 /mnt/disk1
> Mar  6 19:59:21 tdm kernel: SGI XFS with ACLs, security attributes, no debug enabled
> Mar  6 19:59:21 tdm kernel: XFS (md1): Mounting V5 Filesystem
> Mar  6 19:59:21 tdm kernel: XFS (md1): Ending clean mount
> Mar  6 19:59:21 tdm emhttpd: shcmd (83): xfs_growfs /mnt/disk1
> Mar  6 19:59:21 tdm kernel: xfs filesystem being mounted at /mnt/disk1 supports timestamps until 2038 (0x7fffffff)
> Mar  6 19:59:21 tdm root: xfs_growfs: XFS_IOC_FSGROWFSDATA xfsctl failed: No space left on device
> Mar  6 19:59:21 tdm root: meta-data=/dev/md1               isize=512  agcount=32, agsize=137330687 blks
> Mar  6 19:59:21 tdm root:          =                       sectsz=512  attr=2, projid32bit=1
> Mar  6 19:59:21 tdm root:          =                       crc=1  finobt=1, sparse=1, rmapbt=0
> Mar  6 19:59:21 tdm root:          =                       reflink=1  bigtime=0 inobtcount=0
> Mar  6 19:59:21 tdm root: data     =                       bsize=4096  blocks=4394581984, imaxpct=5
> Mar  6 19:59:21 tdm root:          =                       sunit=1  swidth=32 blks
> Mar  6 19:59:21 tdm root: naming   =version 2              bsize=4096  ascii-ci=0, ftype=1
> Mar  6 19:59:21 tdm root: log      =internal log           bsize=4096  blocks=521728, version=2
> Mar  6 19:59:21 tdm root:          =                       sectsz=512  sunit=1 blks, lazy-count=1
> Mar  6 19:59:21 tdm root: realtime =none                   extsz=4096  blocks=0, rtextents=0
> Mar  6 19:59:21 tdm emhttpd: shcmd (83): exit status: 1
> Mar  6 19:59:21 tdm kernel: XFS (md1): EXPERIMENTAL online shrink feature in use. Use at your own risk!
> 
> 
> We issue the EXPERIMENTAL message if the block delta is <= 0 (I'm not sure why
> it's done if delta == 0 and I wonder if it should instead be < 0).

Because if the growfs size is unchanged (i.e delta will be zero), we
don't even call xfs_growfs_data_private(), so the warning will not
be emitted:

        if (in->newblocks != mp->m_sb.sb_dblocks) {
		error = xfs_growfs_data_private(mp, in);
		if (error)
			goto out_error;
	}

If it is getting ENOSPC as an error then either the filesystem is
either:

- 100% full and xfs_trans_alloc() fails (unlikely)
- it is a single AG shrink, the remaining space is not contiguous
  and so fails allocation that removes it from the free space tree:

xfs_ag_shrink_space()
...
        /* internal log shouldn't also show up in the free space btrees */
        error = xfs_alloc_vextent(&args);
        if (!error && args.agbno == NULLAGBLOCK)
                error = -ENOSPC;

- after shrink of the AG, the call to xfs_ag_resv_init() fails
  because there isn't enough free space for metadata reservations
  in that AG anymore. i.e. it will only allow freeing from the last
  AG until reservation space has been regained.

So, yeah, a single AG shrink can give ENOSPC for several reasons,
which leads me to think that the unraid device underlying the
filesystem has changed size (for whatever reason) and growfs is just
saying "you haven't emptied the space at the end of the filesystem
before you tried to shrink the fs"...

> I'm wondering if we have some path through xfs_growfs_data_private() that calculates
> a delta < 0 unintentionally, or if we get there with delta == 0 and generate the
> warning message.

Nope, we're not even getting there for the delta == 0 case...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

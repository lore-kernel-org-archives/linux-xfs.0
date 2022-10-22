Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7FF5FC04A95
	for <linux-xfs@archiver.kernel.org>; Sat, 22 Oct 2022 21:16:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229535AbiJVVQV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 22 Oct 2022 17:16:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229819AbiJVVQU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 22 Oct 2022 17:16:20 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7068981E8
        for <linux-xfs@vger.kernel.org>; Sat, 22 Oct 2022 14:16:18 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id m6so5852299pfb.0
        for <linux-xfs@vger.kernel.org>; Sat, 22 Oct 2022 14:16:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=H5OcniYD2cqAVK4wFYLu1lCly/O54baSROgwrfJqBu4=;
        b=VC5jMee0EcE+0j6wVPBh8L1ZBu9K5kkCtn6f7sEmKNQSYmNHMW1eiZfU7dz84tyzEM
         VPGJRZmCbDUxFE/u+tJRY2QazxeonotAaH0SaAKqSRtLbG9u/Oq9GoIPy20bolAjlLpZ
         QPJuM34B508y8AY7JliIZ8jyLxo3Zx2A4aC7PAbyv48VrRLpQmwZxMPjogKVls3LYinN
         4gSrA9uBcfJsz+5vzVwOIyFXK36qZyKCa3q9Fvuyuyho+7HoXVHZTXsYMmnZRDhfENrB
         mfHIPeCBf5OJUPRWxY1XjXc6jvU80RTnyuSeOWH/J2P8SHf8T7ZmL7s3TTrBfzOXYmMY
         zqvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=H5OcniYD2cqAVK4wFYLu1lCly/O54baSROgwrfJqBu4=;
        b=O/95NuAe8aa96D0spaNUd/YxN8dr7AS6u7gpyOre+86XN2eKNVooaMGEIuvlUZOwK/
         dLqj0haWpPJaIN1T7QhOVoCA3/dHYpVwizGqCo/0+Q7anJtmm5LkRFUgDnJf3HOShLXl
         ad6q7/suaj26t8j6+O8E3iwRolZNR/A4IsqtZai0rJWj/fWzpOE/BOMLNtn7b0wVzoeg
         UPB4LYmmK8Nje7KCAG8+MvW7ILh2rxABVdn1FNk0cwslOhE3GZNrEkMYdpoZtjqJVTA/
         RJgq1POYo0G0E6RvjIgms22NwxyQkd7bAn3W2a5ZE8or9IaHsX33+Azhn37+5K+WJYCU
         inEQ==
X-Gm-Message-State: ACrzQf0j+DiRcJeth4AGUNI/upOPmZuiYo+kUv1kwkFTlSjNaC9Pk7WB
        qWlc7pRCvAEWz3h61PH/vK599w==
X-Google-Smtp-Source: AMsMyM60xtu4Bh7mgSss5J4PYX6nL0xcRevbgAvkh77vmciKC2EniF+xiTFud8wZt5lSzvaWVm4iGw==
X-Received: by 2002:a63:d241:0:b0:43c:474c:c6c6 with SMTP id t1-20020a63d241000000b0043c474cc6c6mr21932320pgi.523.1666473378420;
        Sat, 22 Oct 2022 14:16:18 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-106-210.pa.nsw.optusnet.com.au. [49.181.106.210])
        by smtp.gmail.com with ESMTPSA id m8-20020a170902db0800b00183c6784704sm17082009plx.291.2022.10.22.14.16.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 22 Oct 2022 14:16:17 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1omLqn-005BQC-Vn; Sun, 23 Oct 2022 08:16:14 +1100
Date:   Sun, 23 Oct 2022 08:16:13 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Long Li <leo.lilong@huawei.com>
Cc:     "Darrick J. Wong" <djwong@kernel.org>,
        Dave Chinner <dchinner@redhat.com>,
        Chandan Babu R <chandan.babu@oracle.com>,
        Eric Sandeen <sandeen@redhat.com>,
        Bill O'Donnell <billodo@redhat.com>, linux-xfs@vger.kernel.org,
        yi.zhang@huawei.com, houtao1@huawei.com, guoxuenan@huawei.com
Subject: Re: [PATCH v1] xfs: fix sb write verify for lazysbcount
Message-ID: <20221022211613.GW3600936@dread.disaster.area>
References: <20221022020345.GA2699923@ceph-admin>
 <Y1NSBMwgUYxhW4PE@magnolia>
 <20221022120125.GA2052581@ceph-admin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221022120125.GA2052581@ceph-admin>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Oct 22, 2022 at 08:01:25PM +0800, Long Li wrote:
> On Fri, Oct 21, 2022 at 07:14:28PM -0700, Darrick J. Wong wrote:
> > On Sat, Oct 22, 2022 at 10:03:45AM +0800, Long Li wrote:
> > > When lazysbcount is enabled, multiple threads stress test the xfs report
> > > the following problems:

We've had lazy sb counters for 15 years and just about every XFS
filesystem in production uses them, so providing us with some idea
of the scope of the problem and how to reproduce it would be greatly
appreciated.

What stress test are you running? What filesystem config does it
manifest on (other than lazysbcount=1)?  How long does the stress
test run for, and where/why does log recovery get run in this stress
test?

> > > XFS (loop0): SB summary counter sanity check failed
> > > XFS (loop0): Metadata corruption detected at xfs_sb_write_verify
> > > 	     +0x13b/0x460, xfs_sb block 0x0
> > > XFS (loop0): Unmount and run xfs_repair
> > > XFS (loop0): First 128 bytes of corrupted metadata buffer:
> > > 00000000: 58 46 53 42 00 00 10 00 00 00 00 00 00 28 00 00  XFSB.........(..
> > > 00000010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
> > > 00000020: 69 fb 7c cd 5f dc 44 af 85 74 e0 cc d4 e3 34 5a  i.|._.D..t....4Z
> > > 00000030: 00 00 00 00 00 20 00 06 00 00 00 00 00 00 00 80  ..... ..........
> > > 00000040: 00 00 00 00 00 00 00 81 00 00 00 00 00 00 00 82  ................
> > > 00000050: 00 00 00 01 00 0a 00 00 00 00 00 04 00 00 00 00  ................
> > > 00000060: 00 00 0a 00 b4 b5 02 00 02 00 00 08 00 00 00 00  ................
> > > 00000070: 00 00 00 00 00 00 00 00 0c 09 09 03 14 00 00 19  ................
> > > XFS (loop0): Corruption of in-memory data (0x8) detected at _xfs_buf_ioapply
> > > 	+0xe1e/0x10e0 (fs/xfs/xfs_buf.c:1580).  Shutting down filesystem.
> > > XFS (loop0): Please unmount the filesystem and rectify the problem(s)
> > > XFS (loop0): log mount/recovery failed: error -117
> > > XFS (loop0): log mount failed
> > > 
> > > The cause of the problem is that during the log recovery process, incorrect
> > > icount and ifree are recovered from the log and fail to pass the size check
> > 
> > Are you saying that the log contained a transaction in which ifree >
> > icount?
> 
> Yes, this situation is possible. For example consider the following sequence:
> 
>  CPU0				    CPU1
>  xfs_log_sb			    xfs_trans_unreserve_and_mod_sb
>  ----------			    ------------------------------
>  percpu_counter_sum(&mp->m_icount)
> 				    percpu_counter_add(&mp->m_icount, idelta)
> 				    percpu_counter_add_batch(&mp->m_icount,
> 						  idelta, XFS_ICOUNT_BATCH)
>  percpu_counter_sum(&mp->m_ifree)

What caused the xfs_log_sb() to be called? Very few things
actually log the superblock this way at runtime - it's generally
only logged directly like this when a feature bit changes during a
transaction (rare) or at a synchronisation point when everything
else is idle and there's no chance of a race like this occurring...

I can see a couple of routes to this occurring via feature bit
modification, but I don't see them being easy to hit or something
that would exist for very long in the journal. Hence I'm wondering
if there should be runtime protection for xfs_log_sb() to avoid
these problems....

> > > in xfs_validate_sb_write().
> > > 
> > > With lazysbcount is enabled, There is no additional lock protection for
> > > reading m_ifree and m_icount in xfs_log_sb(), if other threads modifies
> > > the m_ifree between the read m_icount and the m_ifree, this will make the
> > > m_ifree larger than m_icount and written to the log. If we have an unclean
> > > shutdown, this will be corrected by xfs_initialize_perag_data() rebuilding
> > > the counters from the AGF block counts, and the correction is later than
> > > log recovery. During log recovery, incorrect ifree/icount may be restored
> > > from the log and written to the super block, since ifree and icount have
> > > not been corrected at this time, the relationship between ifree and icount
> > > cannot be checked in xfs_validate_sb_write().
> > > 
> > > So, don't check the size between ifree and icount in xfs_validate_sb_write()
> > > when lazysbcount is enabled.
> > 
> > Um, doesn't that neuter a sanity check on all V5 filesystems?
>
> Yes, such modifications don't look like the best way, all sb write checks 
> will be affect. Maybe it can increase the judgment of clean mount and reduce
> the scope of influence, but this requires setting the XFS_OPSTATE_CLEAN after
> re-initialise incore superblock counters, like this:

I'm not sure that silencing the warning and continuing log recovery
with an invalid accounting state is the best way to proceed. We
haven't yet recovered unlinked inodes at the time this warning
fires. If ifree really is larger than icount, then we've got a
real problem at this point in log recovery.

Hence I suspect that we should be looking at fixing the runtime race
condition that leads to the problem, not trying to work around
inconsistency in the recovery code.

-Dave.
-- 
Dave Chinner
david@fromorbit.com

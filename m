Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8317BC636D6
	for <linux-xfs@archiver.kernel.org>; Fri, 17 Feb 2023 20:26:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229635AbjBQU0K (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 17 Feb 2023 15:26:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229489AbjBQU0I (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 17 Feb 2023 15:26:08 -0500
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 087C8193E7
        for <linux-xfs@vger.kernel.org>; Fri, 17 Feb 2023 12:25:42 -0800 (PST)
Received: by mail-pf1-x42a.google.com with SMTP id x8so1342039pfh.3
        for <linux-xfs@vger.kernel.org>; Fri, 17 Feb 2023 12:25:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=VN0HOfLmJcyYqEBS6eki1osL0U7pbkMbM5Ww97Y1n1k=;
        b=Pehwsm3NXu3gIfwxOn2+dcMuQbjkc06EdpNpqiRP64PbbiDxJskXqp9qathjltZ2GI
         hwzPJR7ynsq9pkzejp0L+gdutWzl9Hg53AyhjpcOIfyM8W+2mSbhy4WMb9bcZG3TBqaL
         YX6qNHLtzD84FxfcJ0dBKQVd3FAUJ5YQY5k5y/p9Y1XBIdYxRPIYOHiRZ7G+54kzTzKa
         gUDtkXLVb9TXhW3En0Iz2UPstbVW3/DZ27XC3K1WQeij8RS8cG63Fv+vYGt3F8kQ8ubT
         4nZa2PpY+2w03NnkCstkMy7Z+Jz47KMAtQixX2dYH/KBuiYLcCXCqC+jlCEtX+UFPBMo
         85IA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VN0HOfLmJcyYqEBS6eki1osL0U7pbkMbM5Ww97Y1n1k=;
        b=D/ykFFSHeKEsv9TxKfb9LtIS4oD31w3uYY70c9wYE97oS64Fy71saIoNFZ9snn9+sf
         7Zzbfcxi3MvE6JgwaJY8j6uai2v15en3fxo2uzb2BZvj17x8W6/qifRjmTY42AZWJrqn
         rseJO65tg9gGHgz6ovsv+NcXPx1G1voGDoxLU2N0axXJJehGpTWDSRGA+ynXuVWAxX9Z
         QvMY+clSK16QuEkDCynXx00IFgnlxRD2fQL0tkBzZG8ByJhtWUNcfdI/qctFYXI5qI3v
         Fo1oDi1MeMVuuMsKqQkVITE+FYJ5hxmsUN7hKiT4XN1Z29ruh0m3x/RcG5p6hfJd8lnI
         vdUw==
X-Gm-Message-State: AO0yUKW4GgXHcSuKv/CWX/ZI8JP5KzZ1r79kqpGOdykQSisBa5+7otlK
        JxNo0EM2kIm5QFy2LMCG7X6vpQ==
X-Google-Smtp-Source: AK7set+OGHwoldbCtRSLX1ms+b95r5Eosbzs87CSTAJTTHRysARJJaeJnSYjIS2H4fIeqB4hQrIizw==
X-Received: by 2002:a62:1581:0:b0:5a9:c942:7294 with SMTP id 123-20020a621581000000b005a9c9427294mr3942327pfv.34.1676665539621;
        Fri, 17 Feb 2023 12:25:39 -0800 (PST)
Received: from dread.disaster.area (pa49-181-4-128.pa.nsw.optusnet.com.au. [49.181.4.128])
        by smtp.gmail.com with ESMTPSA id g20-20020aa78754000000b005a9bf65b591sm2392401pfo.135.2023.02.17.12.25.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Feb 2023 12:25:39 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1pT7IV-00GWl0-Sh; Sat, 18 Feb 2023 07:25:35 +1100
Date:   Sat, 18 Feb 2023 07:25:35 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     shrikanth hegde <sshegde@linux.vnet.ibm.com>, dchinner@redhat.com,
        linux-xfs@vger.kernel.org,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        ojaswin@linux.ibm.com
Subject: Re: xfs: system fails to boot up due to Internal error
 xfs_trans_cancel
Message-ID: <20230217202535.GR360264@dread.disaster.area>
References: <e5004868-4a03-93e5-5077-e7ed0e533996@linux.vnet.ibm.com>
 <Y++xDBwXDgkaFUi9@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y++xDBwXDgkaFUi9@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Feb 17, 2023 at 08:53:32AM -0800, Darrick J. Wong wrote:
> On Fri, Feb 17, 2023 at 04:45:12PM +0530, shrikanth hegde wrote:
> > We are observing panic on boot upon loading the latest stable tree(v6.2-rc4) in 
> > one of our systems. System fails to come up. System was booting well 
> > with v5.17, v5.19 kernel. We started seeing this issue when loading v6.0 kernel.
> > 
> > Panic Log is below.
> > [  333.390539] ------------[ cut here ]------------
> > [  333.390552] WARNING: CPU: 56 PID: 12450 at fs/xfs/xfs_inode.c:1839 xfs_iunlink_lookup+0x58/0x80 [xfs]
> 
> Hmm, ok, so this is the same if (WARN_ON_ONCE(!ip || !ip->i_ino)) line
> in xfs_iunlink_lookup that I've been bonking my head on the past
> several days.  333 seconds uptime, so I guess this is a pretty recent
> mount.  You didn't post a full dmesg, so I can only assume there weren't
> any *other* obvious complaints from XFS when the fs was mounted...
> 
> > [  333.390615] Modules linked in: nft_fib_inet nft_fib_ipv4 nft_fib_ipv6 nft_fib nft_reject_inet nf_reject_ipv4 nf_reject_ipv6 nft_reject nft_ct nft_chain_nat nf_nat nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 ip_set nf_tables nfnetlink rfkill sunrpc pseries_rng xts vmx_crypto xfs libcrc32c sd_mod sg ibmvscsi ibmveth scsi_transport_srp nvme nvme_core t10_pi crc64_rocksoft crc64 dm_mirror dm_region_hash dm_log dm_mod
> > [  333.390645] CPU: 56 PID: 12450 Comm: rm Not tainted 6.2.0-rc4ssh+ #4
> > [  333.390649] Hardware name: IBM,9080-HEX POWER10 (raw) 0x800200 0xf000006 of:IBM,FW1010.22 (NH1010_122) hv:phyp pSeries
> > [  333.390652] NIP:  c0080000004bfa80 LR: c0080000004bfa4c CTR: c000000000ea28d0
> > [  333.390655] REGS: c0000000442bb8c0 TRAP: 0700   Not tainted  (6.2.0-rc4ssh+)
> > [  333.390658] MSR:  8000000000029033 <SF,EE,ME,IR,DR,RI,LE>  CR: 24002842  XER: 00000000
> > [  333.390666] CFAR: c0080000004bfa54 IRQMASK: 0
> > [  333.390666] GPR00: c00000003b69c0c8 c0000000442bbb60 c008000000568300 0000000000000000
> > [  333.390666] GPR04: 00000000002ec44d 0000000000000000 0000000000000000 c000000004b27d78
> > [  333.390666] GPR08: 0000000000000000 c000000004b27e28 0000000000000000 fffffffffffffffd
> > [  333.390666] GPR12: 0000000000000040 c000004afecc5880 0000000106620918 0000000000000001
> > [  333.390666] GPR16: 000000010bd36e10 0000000106620dc8 0000000106620e58 0000000106620e90
> > [  333.390666] GPR20: 0000000106620e30 c0000000880ba938 0000000000200000 00000000002ec44d
> > [  333.390666] GPR24: 000000000008170d 000000000000000d c0000000519f4800 00000000002ec44d
> > [  333.390666] GPR28: c0000000880ba800 c00000003b69c000 c0000000833edd20 000000000008170d
> > [  333.390702] NIP [c0080000004bfa80] xfs_iunlink_lookup+0x58/0x80 [xfs]
> > [  333.390756] LR [c0080000004bfa4c] xfs_iunlink_lookup+0x24/0x80 [xfs]
> > [  333.390810] Call Trace:
> > [  333.390811] [c0000000442bbb60] [c0000000833edd20] 0xc0000000833edd20 (unreliable)
> > [  333.390816] [c0000000442bbb80] [c0080000004c0094] xfs_iunlink+0x1bc/0x280 [xfs]
> > [  333.390869] [c0000000442bbc00] [c0080000004c3f84] xfs_remove+0x1dc/0x310 [xfs]
> > [  333.390922] [c0000000442bbc70] [c0080000004be180] xfs_vn_unlink+0x68/0xf0 [xfs]
> > [  333.390975] [c0000000442bbcd0] [c000000000576b24] vfs_unlink+0x1b4/0x3d0
> 
> ...that trips when rm tries to remove a file, which means that the call
> stack is
> 
> xfs_remove -> xfs_iunlink -> xfs_iunlink_insert_inode ->
> xfs_iunlink_update_backref -> xfs_iunlink_lookup <kaboom>
> 
> It looks as though "rm foo" unlinked foo from the directory and was
> trying to insert it at the head of one of the unlinked lists in the AGI
> buffer.  The AGI claims that the list points to an ondisk inode, so the
> iunlink code tries to find the incore inode to update the incore list,
> fails to find an incore inode, and this is the result...

This implies that unlinked inode recovery failed for some reason,
and we didn't clear the unlinked list from the AGI properly.

> > we did a git bisect between 5.17 and 6.0. Bisect points to commit 04755d2e5821 
> > as the bad commit.
> > Short description of commit:
> > commit 04755d2e5821b3afbaadd09fe5df58d04de36484 (refs/bisect/bad)
> > Author: Dave Chinner <dchinner@redhat.com>
> > Date:   Thu Jul 14 11:42:39 2022 +1000
> > 
> >     xfs: refactor xlog_recover_process_iunlinks()
> 
> ...which was in the middle of the series that reworked thev mount time
> iunlink clearing.  Oddly, I don't spot any obvious errors in /that/
> patch that didn't already exist.  But this does make me wonder, does
> xfs_repair -n have anything to say about unlinked or orphaned inodes?
> 
> The runtime code expects that every ondisk inode in an iunlink chain has
> an incore inode that is linked (via i_{next,prev}_unlinked) to the other
> incore inodes in that same chain.  If this requirement is not met, then
> the WARNings you see will trip, and the fs shuts down.
> 
> My hypothesis here is that one of the AGs has an unprocessed unlinked
> list.  At mount time, the ondisk log was clean, so mount time log
> recovery didn't invoke xlog_recover_process_iunlinks, and the list was
> not cleared.  The mount code does not construct the incore unlinked list
> from an existing ondisk iunlink list, hence the WARNing.  Prior to 5.17,
> we only manipulated the ondisk unlink list, and the code never noticed
> or cared if there were mystery inodes in the list that never went away.

Yup, that's what I'm thinking.

But, hmmm, why is xlog_recover_clear_agi_bucket() not actually
clearing the bucket head at that point?

Oh, because we don't (and never have) capture errors from inode
inactivation?  Or maybe the filesystem has shut down due to the
unlink failure?

I'd love to know how the filesystem got to this state in the first
place, but at the moment I'll settle for a metadata of a broken
filesystem....

> (Obviously, if something blew up earlier in dmesg, that would be
> relevant here.)
> 
> It's possible that we could end up in this situation (clean log,
> unlinked inodes) if a previous log recovery was only partially
> successful at clearing the unlinked list, since all that code ignores
> errors.  If that happens, we ... succeed at mounting and clean the log.
> 
> If you're willing to patch your kernels, it would be interesting
> to printk if the xfs_read_agi or the xlog_recover_iunlink_bucket calls
> in xlog_recover_iunlink_ag returns an error code.  It might be too late
> to capture that, hence my suggestion of seeing if xfs_repair -n will
> tell us anything else.
> 
> I've long thought that the iunlink recovery ought to complain loudly and
> fail the mount if it can't clear all the unlinked files.  Given the new
> iunlink design, I think it's pretty much required now.  The uglier piece
> is that now we either (a) have to clear iunlinks at mount time
> unconditionally as Eric has been saying for years; or (b) construct the
> incore list at a convenient time so that the incore list always exists.

Recovery does actually construct the incore list sufficient to
unlink it (i.e. that's what the next/prev reference looping does).
We could walk the entire list first and bring it into memory,
but the problem there, I think, is that we have to hold references
to all the inodes we bring into memory during recovery otherwise
they are immediately reclaimed once we drop the reference.

I suspect we need to work out why xlog_recover_clear_agi_bucket() is
not triggering and clearing the bucket on error, because that is
supposed to avoid this exact "could not process all unlinked inodes"
and it warns loudly when it triggers....

-Dave.
-- 
Dave Chinner
david@fromorbit.com

Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24CD8C433FE
	for <linux-xfs@archiver.kernel.org>; Wed, 26 Oct 2022 18:52:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234100AbiJZSwf (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 26 Oct 2022 14:52:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233972AbiJZSwe (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 26 Oct 2022 14:52:34 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AAB380BCD
        for <linux-xfs@vger.kernel.org>; Wed, 26 Oct 2022 11:52:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B8903B821D7
        for <linux-xfs@vger.kernel.org>; Wed, 26 Oct 2022 18:52:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54BE3C433C1;
        Wed, 26 Oct 2022 18:52:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666810350;
        bh=aJ+jy2B1NZnigijwJSrKGhf+PFdyGhqv2j/W54oxnmE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=j/UDzHP/E3TEzblEHGQoFbxWo3tM+VPT/Ad1FGbtlkHkXybNnVdHPbJnJ4z/Yg3OC
         FtX+wFhSar5Qa6QgzZqM/LGWC97Pz5NI5jkRGaOxY5hd6ehcelyjKxniC/fzgeKPx7
         xZF9J0+5fYC+DwdVD91Alci68iRU30uLZz/vZDQNselK7UMlbT2bGv7HqdDvIGSx6u
         QABwjCBvPSTQY6SlFsAEph5uxnh/M4af56X5dsfjdkwc0QQrW83DPjL/GupZ6hMuY9
         b+1UQ0XB6CoHz4gMST9FX62qbbe4s4XWMSS6uUn0L/X1myp6KVoNBlHhO0l1VIusmp
         /ipjBWOfHF3sw==
Date:   Wed, 26 Oct 2022 11:52:29 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Long Li <leo.lilong@huawei.com>
Cc:     billodo@redhat.com, chandan.babu@oracle.com, dchinner@redhat.com,
        guoxuenan@huawei.com, houtao1@huawei.com,
        linux-xfs@vger.kernel.org, sandeen@redhat.com, yi.zhang@huawei.com
Subject: Re: [PATCH v2] xfs: fix sb write verify for lazysbcount
Message-ID: <Y1mB7VfIOms3J2Rj@magnolia>
References: <20221022020345.GA2699923@ceph-admin>
 <20221025091527.377976-1-leo.lilong@huawei.com>
 <Y1goB8GfadlYSL9T@magnolia>
 <20221026091344.GA490040@ceph-admin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221026091344.GA490040@ceph-admin>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Oct 26, 2022 at 05:13:44PM +0800, Long Li wrote:
> On Tue, Oct 25, 2022 at 11:16:39AM -0700, Darrick J. Wong wrote:
> > On Tue, Oct 25, 2022 at 05:15:27PM +0800, Long Li wrote:
> > > When lazysbcount is enabled, fsstress and loop mount/unmount test report
> > > the following problems:
> > > 
> > > XFS (loop0): SB summary counter sanity check failed
> > > XFS (loop0): Metadata corruption detected at xfs_sb_write_verify+0x13b/0x460,
> > > 	xfs_sb block 0x0
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
> > > This will make the file system unmountable, the cause of the problem is
> > > that during the log recovery process, incorrect count (ifree > icount)
> > > are recovered from the log and fail to pass the boundary check in
> > > xfs_validate_sb_write(). The following script can reproduce the problem,
> > > but it may take a long time.
> > > 
> > > device=/dev/sda
> > > testdir=/mnt/test
> > > round=0
> > > 
> > > function fail()
> > > {
> > > 	echo "$*"
> > > 	exit 1
> > > }
> > > 
> > > mkdir -p $testdir
> > > while [ $round -lt 10000 ]
> > > do
> > > 	echo "******* round $round ********"
> > > 	mkfs.xfs -f $device
> > > 	mount $device $testdir || fail "mount failed!"
> > > 	fsstress -d $testdir -l 0 -n 10000 -p 4 >/dev/null &
> > 
> > What is the backtrace of the xfs_log_sb caller?  I speculate that it's
> > something along the lines of adding a superblock feature?  attr2 would
> > be my guess since this is fsstress.
> 
> The call trace that I reproduced:
>  Call Trace:
>   <TASK>
>   dump_stack_lvl+0x4d/0x66
>   xfs_log_sb.cold+0x2f/0x1af
>   xfs_bmap_add_attrfork+0x687/0xb40
>   ? get_reg+0x91/0x190
>   ? xfs_bmap_add_attrfork+0x0/0xb40
>   ? unwind_next_frame+0x115d/0x1b70
>   ? xfs_attr_calc_size+0x13c/0x2e0
>   xfs_attr_set+0xb51/0x1d50
>   ? __kernel_text_address-0xe/0x30
>   ? xfs_attr_set+0x0/0x1d50
>   ? __kernel_text_address+0xe/0x30
>   ? unwind_get_return_address+0x5f/0xa0
>   ? stack_trace_consume_entry+0x0/0x160
>   ? arch_stack_walk+0x98/0xf0
>   xfs_attr_change+0x22d/0x380
>   xfs_xattr_set+0xeb/0x160
>   ? xfs_xattr_set+0x0/0x160
>   ? vmemdup_user+0x27/0xa0
>   ? setxattr_copy+0x103/0x1a0
>   ? setxattr+0xd1/0x160
>   ? path_setxattr+0x168/0x190
>   ? __x64_sys_setxattr+0xc5/0x160
>   ? xattr_resolve_name+0x23d/0x360
>   ? xfs_xattr_set+0x0/0x160
>   __vfs_setxattr+0x100/0x160
>   ? __vfs_setxattr+0x0/0x160
>   __vfs_setxattr_noperm+0x104/0x320
>   __vfs_setxattr_locked+0x1ba/0x260
> 
> > 
> > So the other racing thread would be a thread that just freed an inode
> > cluster, committed the transaction, and now it's committing idelta and
> > ifreedelta into the incore percpu counters via:
> > 
> > 	if (idelta)
> > 		percpu_counter_add_batch(&mp->m_icount, idelta,
> > 					 XFS_ICOUNT_BATCH);
> > 
> > 	if (ifreedelta)
> > 		percpu_counter_add(&mp->m_ifree, ifreedelta);
> > 
> > > 	sleep 4
> > > 	killall -w fsstress
> > > 	umount $testdir
> > > 	xfs_repair -e $device > /dev/null
> > > 	if [ $? -eq 2 ];then
> > > 		echo "ERR CODE 2: Dirty log exception during repair."
> > > 		exit 1
> > > 	fi
> > > 	round=$(($round+1))
> > > done
> > > 
> > > With lazysbcount is enabled, There is no additional lock protection for
> > > reading m_ifree and m_icount in xfs_log_sb(), if other cpu modifies the
> > > m_ifree, this will make the m_ifree greater than m_icount and written to
> > > the log. For example consider the following sequence:
> > > 
> > >  CPU0				 CPU1
> > >  xfs_log_sb			 xfs_trans_unreserve_and_mod_sb
> > >  ----------			 ------------------------------
> > >  percpu_counter_sum(&mp->m_icount)
> > > 				 percpu_counter_add(&mp->m_icount, idelta)
> > 
> > This callsite does not exist ^^^^^^^^^^^ in the codebase, AFAICT.
> > 
> > > 				 percpu_counter_add_batch(&mp->m_icount,
> > > 						idelta, XFS_ICOUNT_BATCH)
> > >  percpu_counter_sum(&mp->m_ifree)
> 
> Sorry, the code I copied is wrong, as it should be:
> 
>  CPU0				 CPU1
>  xfs_log_sb			 xfs_trans_unreserve_and_mod_sb
>  ----------			 ------------------------------
>  percpu_counter_sum(&mp->m_icount)
> 				 percpu_counter_add_batch(&mp->m_icount,
> 						idelta, XFS_ICOUNT_BATCH)
> 				 percpu_counter_add(&mp->m_ifree, ifreedelta);
>  percpu_counter_sum(&mp->m_ifree)
> 
> > 
> > I think what's happening here is more like:
> > 
> > 1. CPU1 adds a negative idelta to m_icount.
> > 2. CPU0 sums m_icount.
> > 3. CPU0 sums m_ifree.
> > 4. CPU1 adds a negative ideltafree to m_ifree.
> 
> I tried to reproduce the situation that you said, but it hasn't been
> reproduced yet. Only the following sequence is reproduced:
> 
> 1. CPU0 sums m_icount.
> 2. CPU1 adds a positive idelta (e.g. 32) to m_icount.
> 3. CPU1 adds a positive ideltafree (e.g. 32) to m_ifree.
> 4. CPU0 sums m_ifree. 

Aha, that was my second guess as to what was really going on.

Either way, we're racing with updates to two percpu counters.
Now that the source of the bug has been clarified...

> > Now CPU0 has an ifree > icount, which it writes into the primary
> > superblock buffer.  Eventually the AIL writes the buffer to disk, only
> > the write verifier trips over icount < ifree and shuts down the fs.
> > 
> > > If we have an unclean shutdown, this will be corrected by
> > > xfs_initialize_perag_data() rebuilding the counters from the AGF block
> > > counts, and the correction is later than log recovery. During log recovery,
> > > incorrect ifree/icount may be restored from the log and written sb, since
> > > ifree and icount have not been corrected at this time, sb write check
> > > will fail due to ifree > icount.
> > > 
> > > Guaranteed that ifree will never be logged as being greater than icount.
> > > Neither icount or ifree will be accurate if we are racing with other
> > > updates, but it will guarantee that what we write to the journal
> > > won't trigger corruption warnings.
> > > 
> > > Fixes: 8756a5af1819 ("libxfs: add more bounds checking to sb sanity checks")
> > > Signed-off-by: Long Li <leo.lilong@huawei.com>
> > > ---
> > > v2:
> > > - Add scripts that could reproduce the problem
> > > - Guaranteed that ifree will never be logged as being greater than icount
> > > 
> > >  fs/xfs/libxfs/xfs_sb.c | 4 +++-
> > >  1 file changed, 3 insertions(+), 1 deletion(-)
> > > 
> > > diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
> > > index a20cade590e9..1eeecf2eb2a7 100644
> > > --- a/fs/xfs/libxfs/xfs_sb.c
> > > +++ b/fs/xfs/libxfs/xfs_sb.c
> > > @@ -972,7 +972,9 @@ xfs_log_sb(
> > >  	 */
> > >  	if (xfs_has_lazysbcount(mp)) {
> > >  		mp->m_sb.sb_icount = percpu_counter_sum(&mp->m_icount);
> > > -		mp->m_sb.sb_ifree = percpu_counter_sum(&mp->m_ifree);
> > > +		mp->m_sb.sb_ifree = min_t(uint64_t,
> > > +				percpu_counter_sum(&mp->m_ifree),
> > > +				mp->m_sb.sb_icount);
> > 
> > This part looks plausible, but I think xfs_unmountfs really ought to
> > check that m_ifree < m_icount after it's quiesced the rest of the
> > filesystem and freed the reserve block pool.  If ifree is still larger
> > than icount, someone has corrupted the incore counters, so we should not
> > write a clean unmount record.

...please update the patch to include this sanity check at unmount so
that I can get this bugfix moving towards upstream.

--D

> > 
> > --D
> > 
> > >  		mp->m_sb.sb_fdblocks = percpu_counter_sum(&mp->m_fdblocks);
> > >  	}
> > >  
> > > -- 
> > > 2.31.1
> > > 

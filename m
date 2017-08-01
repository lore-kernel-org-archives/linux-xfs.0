Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from cloud1-vm154.de-nserver.de ([178.250.10.56]:27287 "EHLO
        cloud1-vm154.de-nserver.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751737AbdHANuW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 1 Aug 2017 09:50:22 -0400
From: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
Subject: Re: metadata I/O error: block 0x575b6d70,("xfs_trans_read_buf_map")
 error 4 numblks 16
References: <e4606e43-468e-431c-1663-6b167cc5648b@profihost.ag>
 <20170801153548.15cf74ef@harpe.intellique.com>
Message-ID: <b29b31a1-edb9-47f4-a641-11ecfc289c99@profihost.ag>
Date: Tue, 1 Aug 2017 15:50:20 +0200
MIME-Version: 1.0
In-Reply-To: <20170801153548.15cf74ef@harpe.intellique.com>
Content-Type: text/plain; charset=utf-8
Content-Language: de-DE
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Emmanuel Florac <eflorac@intellique.com>
Cc: linux-xfs@vger.kernel.org

Hello Emmanuel,

yes there are bcache patches already applied:
0002-bcache-bch_writeback_thread-is-not-freezable.patch
0003-bcache-bch_allocator_thread-is-not-freezable.patch
0001-bcache-partition-support-add-16-minors-per-bcacheN-d.patch
0044-bcache-Remove-deprecated-create_workqueue.patch
0045-bcache-Remove-redundant-parameter-for-cache_alloc.patch
0046-bcache-update-document-info.patch
0047-bcache-Remove-redundant-block_size-assignment.patch
0048-bcache-register_bcache-call-blkdev_put-when-cache_al.patch
0049-bcache-pr_err-more-meaningful-error-message-when-nr_.patch
0071-bcache-switch-to-using-blk_queue_write_cache.patch
0092-bcache-use-op_is_write-instead-of-checking-for-REQ_W.patch
0110-bcache-use-bio-op-accessors.patch
0253-bcache-use-op_is_sync-to-check-for-synchronous-reque.patch
0344-bcache-debug-avoid-accessing-.bi_io_vec-directly.patch
0002-bcache-fix-calling-ida_simple_remove-with-incorrect-minor.patch
0001-bcache-force-trigger-gc.patch
0001-bcache-only-recovery-I-O-error-for-writethrough-mode.patch

There is no trace involved as there is no kernel bug triggered. That's
the whole output.

Greets,
Stefan
Am 01.08.2017 um 15:35 schrieb Emmanuel Florac:
> Le Tue, 1 Aug 2017 10:12:57 +0200
> Stefan Priebe - Profihost AG <s.priebe@profihost.ag> écrivait:
> 
>> Hello,
>>
>> under very high load i'm getting the following error on a bcache
>> device using XFS:
>> XFS (bcache1): metadata I/O error: block 0x575b6d70
>> ("xfs_trans_read_buf_map") error 4 numblks 16
>> XFS (bcache1): xfs_imap_to_bp: xfs_trans_read_buf() returned error -4.
>> XFS (bcache1): xfs_do_force_shutdown(0x8) called from line 3519 of
>> file fs/xfs/xfs_inode.c. Return address = 0xffffffff993441ff
>> XFS (bcache1): Corruption of in-memory data detected. Shutting down
>> filesystem
>> XFS (bcache1): Please umount the filesystem and rectify the problem(s)
>> XFS (bcache1): xfs_log_force: error -5 returned.
>> XFS (bcache1): xfs_log_force: error -5 returned.
>> XFS (bcache1): xfs_log_force: error -5 returned.
>>
>> The used kernel is 4.4.79 based while using an opensuses patchset. Is
>> this something which is a known problem or something suse has broken?
> 
> Do you know if the patchset includes Eric Wheeler's stability patches
> for bcache?
> 
> Also please post the output from dmesg with the complete trace.
> 

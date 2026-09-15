Received: from mta0.migadu.com (out-246.mta0.migadu.com [91.218.175.246])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6F1147CC92
	for <linux-xfs@vger.kernel.org>; Tue, 15 Sep 2026 10:01:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.246
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789466476; cv=none; b=eGHH+qR+UeZcovdYFbfunq/5E7Cbgh/CKKq/g7tXEVhCI6zVmjJp5dAIIcFSAECBXxbxuwxmczYqOlM7lszA4ALHU1wJhUAaFdl130t4l7uiTm4AWMdSBp3LfE/CTUhexTTfwIeuetss5IkDUm3hQyuq/XgjaJlEOogtgYulg8Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789466476; c=relaxed/simple;
	bh=zH1QUqXOJTQ+YkSx400tid2YhkRtUqIeyiDNB22tUsE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=bFjQRgtrYNEmcV2lR7inAmkq4mXS/coZqMWRJWVvG/0Lay5O0w8NC9yG/JxnZmBzPw9tdgMV/s9FWPKNilliS7N9H70u052SdUaFhgyrd31CJeMiBpYmztjvvz0ycG2gUY4ir56GHAWhbb5ZJ5kRMWSKQKYSN3T54XAOkfloDZI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Ba88bP2Q; arc=none smtp.client-ip=91.218.175.246
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Ba88bP2Q"
X-Envelope-To: linux-xfs@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=zH1QUqXOJTQ+YkSx400tid2YhkRtUqIeyiDNB22tUsE=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789466467; v=1; x=1790071267;
 b=Ba88bP2QZtxYOmYnfJHQtV2jqQvn30jd/oxnQkhcHFM1yVr9bVKiQ405J57tL8q4Ky0AgbHl
 825Cx5P7pNC5TMEvx9ePbJ47+Ga0i0wRyjwVM8ocH0CdD66vdp0YBXY+b6LJNg2Vbs5dPhy0Kby
 5uq/LK/sgkSda3Q0y/tTfoLk=
X-Envelope-To: linux-xfs@vger.kernel.org
Received: by mta11.migadu.com with ESMTPS id 05528fb4f7654bbb;
	Tue, 15 Sep 2026 10:01:07 +0000
X-Mizu-Trace-ID: 05528fb4f7654bbb
X-Migadu-Flow: FLOW_OUT
Message-ID: <98190f62-ccc3-49df-934d-f168e293c485@linux.dev>
Date: Tue, 15 Sep 2026 11:00:59 +0100
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [bug report] fstests generic/774 hang again
To: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
 "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>
References: <aqkP9CTUvlC2YCIb@shinmob>
Content-Language: en-US
From: John Garry <john.garry@linux.dev>
In-Reply-To: <aqkP9CTUvlC2YCIb@shinmob>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/15/26 10:34, Shin'ichiro Kawasaki wrote:
> I observe the fstests test case generic/774 hangs, when I run it for xfs on 8GiB
> TCMU fileio devices. Actually I once reported this hang symptom in last October,
> and Darrick and John kindly took some actions [1]. Since then, the hang
> disappeared and I have not observed the hang almost one year. However, my test
> system started reporting the hang again last week.
> 
> [1] https://lore.kernel.org/linux-xfs/cmk52aqexackyz65phxgme55a3tdrermo3o4skr4lo4pwvvvcp@jmcblnfikbp2/#t

This was the series to resolve, I think:
https://lore.kernel.org/fstests/176279908967.605950.2192923313361120314.stgit@frogsfrogsfrogs/T/#t

As an experiment, can you reduce the file size further, like:

--- a/tests/generic/774
+++ b/tests/generic/774
@@ -29,7 +29,7 @@ aw_bsize=$(_max "$awu_min_write" "$((awu_max_write/4))")
  fsbsize=$(_get_block_size $SCRATCH_MNT)

  threads=$(_min "$(($(nproc) * 2 * LOAD_FACTOR))" "100")
-filesize=$((aw_bsize * threads * 10))
+filesize=$((aw_bsize * threads))
  depth=$threads
  aw_io_size=$((filesize / threads))
  aw_io_inc=$aw_io_size


> 
> FYI, here I attache the kernel message [2]. 

Is mainline baseline hanging, i.e. v7.3-rc2?

> I observed the hang last week with
> the kernel on the xfs/for-next branch at the commit 0ca15a1a1151 ("xfs: remove
> an extra cast in xfs_file_compat_ioctl"). Today, I tried again with the kernel
> at current xfs/for-next branch tip 4266ffdfd7cb ("xfs: remove an extra cast in
> xfs_file_compat_ioctl"), and observed the hang again. The hang can be recreated
> in stable manner by repeating the test case 20 times or so.
> 
> I also tried other test cases in atmoicwrites group, and observed no failure.
> 
>   generic/765        [not run] write atomic not supported by this block device
>   generic/767         11s
>   generic/768         13s
>   generic/769         13s
>   generic/770         32s
>   generic/773        [not run] write atomic not supported by this block device
>   generic/774        (skipped)
>   generic/775         293s
>   generic/776        [notrun] write atomic not supported by this block device
>   generic/778         48s
>   xfs/838            [not run] External volumes not in use, skipped this test
>   xfs/839            [not run] XFS error injection requires CONFIG_XFS_DEBUG
>   xfs/840            [not run] write atomic not supported by this block device
> 
> Action for fix will be appreciated. If I can do anything on my test node, please
> let me know.
> 
> 
> [2] kernel message during generic/774
> 
> [144539.456849][T1634092] run fstests generic/774 at 2026-09-09 16:51:53
> [144539.691199][T3820710] MODE SENSE: unimplemented page/subpage: 0x0a/0x05
> [144543.436776][T3868062] MODE SENSE: unimplemented page/subpage: 0x0a/0x05
> [144543.648458][T3872722] XFS (sdg): Mounting V5 Filesystem 306fb2c4-6cd3-4cbd-b9ed-953c0bc0d3b8
> [144543.674712][T3872722] XFS (sdg): Ending clean mount
> [144544.328859][T3872774] XFS (sdg): Unmounting Filesystem 306fb2c4-6cd3-4cbd-b9ed-953c0bc0d3b8
> [144545.743530][T3795425] MODE SENSE: unimplemented page/subpage: 0x0a/0x05
> [144545.964812][T3872823] XFS (sdg): Mounting V5 Filesystem 91ee7431-7139-4d92-bea7-b7802c3f70d2
> [144545.990603][T3872823] XFS (sdg): Ending clean mount
> [144870.819650][  T172] INFO: task kworker/10:173:3785794 blocked for more than 122 seconds.
> [144870.821440][  T172]       Tainted: G        W           7.3.0-rc2-kts-xfs-g0ca15a1a115+ #1
> [144870.823252][  T172] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> [144870.825054][  T172] task:kworker/10:173  state:D stack:0     pid:3785794 tgid:3785794 ppid:2      task_flags:0x4248060 flags:0x00080000
> [144870.827098][  T172] Workqueue: dio/sdg iomap_dio_complete_work
> [144870.828170][  T172] Call Trace:
> [144870.829209][  T172]  <TASK>
> [144870.830154][  T172]  __schedule+0xc86/0x1b10
> [144870.831126][  T172]  ? trace_hardirqs_on+0x18/0x1a0
> [144870.832166][  T172]  ? __pfx___schedule+0x10/0x10
> [144870.833250][  T172]  ? _raw_spin_unlock_irq+0x28/0x50
> [144870.834400][  T172]  ? wq_worker_sleeping+0x213/0x280
> [144870.835559][  T172]  ? find_held_lock+0x2b/0x80
> [144870.836634][  T172]  ? __lock_release.isra.0+0x69/0x1a0
> [144870.837699][  T172]  schedule+0xe5/0x2e0
> [144870.838721][  T172]  ? _raw_spin_unlock_irq+0x28/0x50
> [144870.839915][  T172]  schedule_preempt_disabled+0x16/0x30
> [144870.841017][  T172]  rwsem_down_write_slowpath+0x4b4/0x1460
> [144870.842139][  T172]  ? __kasan_slab_alloc+0x7f/0x90
> [144870.843236][  T172]  ? __pfx_rwsem_down_write_slowpath+0x10/0x10
> [144870.844383][  T172]  ? __lock_acquire+0x691/0xd00
> [144870.845598][  T172]  ? lock_acquire.part.0+0xc8/0x240
> [144870.846840][  T172]  ? lock_acquire+0x11a/0x140
> [144870.848019][  T172]  down_write_nested+0x1c0/0x1f0
> [144870.849121][  T172]  ? __pfx_down_write_nested+0x10/0x10
> [144870.850284][  T172]  ? xfs_ilock+0x1e7/0x310 [xfs]
> [144870.852895][  T172]  xfs_reflink_end_atomic_cow+0x2f3/0x560 [xfs]
> [144870.855451][  T172]  ? __pfx_xfs_reflink_end_atomic_cow+0x10/0x10 [xfs]
> [144870.858004][  T172]  ? __lock_acquire+0x691/0xd00
> [144870.859160][  T172]  xfs_dio_write_end_io+0x4b7/0x650 [xfs]
> [144870.861775][  T172]  ? __pfx_xfs_dio_write_end_io+0x10/0x10 [xfs]
> [144870.864257][  T172]  iomap_dio_complete+0x140/0xb20
> [144870.865378][  T172]  ? __pfx_aio_complete_rw+0x10/0x10
> [144870.866570][  T172]  iomap_dio_complete_work+0x58/0x90
> [144870.867785][  T172]  process_one_work+0x947/0x1760
> [144870.868995][  T172]  ? __pfx_process_one_work+0x10/0x10
> [144870.870062][  T172]  ? lock_acquire.part.0+0xc8/0x240
> [144870.871227][  T172]  ? lock_is_held_type+0xb0/0x180
> [144870.872361][  T172]  worker_thread+0x601/0xff0
> [144870.873609][  T172]  ? __pfx_worker_thread+0x10/0x10
> [144870.874813][  T172]  kthread+0x361/0x460
> [144870.875873][  T172]  ? __pfx_kthread+0x10/0x10
> [144870.876881][  T172]  ret_from_fork+0x560/0x860
> [144870.878012][  T172]  ? __pfx_ret_from_fork+0x10/0x10
> [144870.879036][  T172]  ? __switch_to+0x473/0xd50
> [144870.880200][  T172]  ? __pfx_kthread+0x10/0x10
> [144870.881232][  T172]  ret_from_fork_asm+0x1a/0x30
> [144870.882353][  T172]  </TASK>
> [144870.883486][  T172] INFO: task kworker/10:173:3785794 <writer> blocked on an rw-semaphore likely owned by task kworker/1:2:3819893 <writer>
> [144870.885498][  T172] INFO: task kworker/18:2:3812136 blocked for more than 122 seconds.
> [144870.887038][  T172]       Tainted: G        W           7.3.0-rc2-kts-xfs-g0ca15a1a115+ #1
> [144870.888467][  T172] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> [144870.890050][  T172] task:kworker/18:2    state:D stack:0     pid:3812136 tgid:3812136 ppid:2      task_flags:0x4248060 flags:0x00080000
> [144870.892033][  T172] Workqueue: dio/sdg iomap_dio_complete_work
> [144870.893266][  T172] Call Trace:
> [144870.894349][  T172]  <TASK>
> [144870.895228][  T172]  __schedule+0xc86/0x1b10
> [144870.896439][  T172]  ? __pfx___schedule+0x10/0x10
> [144870.897500][  T172]  ? schedule+0x17e/0x2e0
> [144870.898441][  T172]  ? wq_worker_sleeping+0x65/0x280
> [144870.899427][  T172]  ? find_held_lock+0x2b/0x80
> [144870.900392][  T172]  ? __lock_release.isra.0+0x69/0x1a0
> [144870.901382][  T172]  schedule+0xe5/0x2e0
> [144870.902249][  T172]  ? _raw_spin_unlock_irq+0x28/0x50
> [144870.903287][  T172]  schedule_preempt_disabled+0x16/0x30
> [144870.904511][  T172]  rwsem_down_write_slowpath+0x4b4/0x1460
> [144870.905518][  T172]  ? lock_release.part.0+0x1c/0x50
> [144870.906482][  T172]  ? __pfx_rwsem_down_write_slowpath+0x10/0x10
> [144870.907575][  T172]  ? __lock_acquire+0x691/0xd00
> [144870.908506][  T172]  ? lock_acquire.part.0+0xc8/0x240
> [144870.939885][  T172]  ? lock_acquire+0x11a/0x140
> [144870.940681][  T172]  down_write_nested+0x1c0/0x1f0
> [144870.941553][  T172]  ? __pfx_down_write_nested+0x10/0x10
> [144870.942530][  T172]  ? xfs_ilock+0x1e7/0x310 [xfs]
> [144870.944492][  T172]  xfs_reflink_end_atomic_cow+0x2f3/0x560 [xfs]
> [144870.946365][  T172]  ? __pfx_xfs_reflink_end_atomic_cow+0x10/0x10 [xfs]
> [144870.948153][  T172]  ? __lock_acquire+0x691/0xd00
> [144870.949019][  T172]  xfs_dio_write_end_io+0x4b7/0x650 [xfs]
> [144870.950793][  T172]  ? __pfx_xfs_dio_write_end_io+0x10/0x10 [xfs]
> [144870.952653][  T172]  iomap_dio_complete+0x140/0xb20
> [144870.953439][  T172]  ? __pfx_aio_complete_rw+0x10/0x10
> [144870.954096][  T172]  iomap_dio_complete_work+0x58/0x90
> [144870.954877][  T172]  process_one_work+0x947/0x1760
> [144870.955644][  T172]  ? __pfx_process_one_work+0x10/0x10
> [144870.956399][  T172]  ? lock_acquire.part.0+0xc8/0x240
> [144870.957121][  T172]  ? lock_is_held_type+0xb0/0x180
> [144870.957949][  T172]  worker_thread+0x601/0xff0
> [144870.958860][  T172]  ? __pfx_worker_thread+0x10/0x10
> [144870.959586][  T172]  kthread+0x361/0x460
> [144870.960273][  T172]  ? __pfx_kthread+0x10/0x10
> [144870.960891][  T172]  ret_from_fork+0x560/0x860
> [144870.961610][  T172]  ? __pfx_ret_from_fork+0x10/0x10
> [144870.962503][  T172]  ? __switch_to+0x473/0xd50
> [144870.963250][  T172]  ? __pfx_kthread+0x10/0x10
> [144870.963930][  T172]  ret_from_fork_asm+0x1a/0x30
> [144870.964760][  T172]  </TASK>
> [144870.965444][  T172] INFO: task kworker/18:2:3812136 <writer> blocked on an rw-semaphore likely owned by task kworker/1:2:3819893 <writer>
> [144870.966764][  T172] INFO: task kworker/20:1:3814407 blocked for more than 123 seconds.
> [144870.967875][  T172]       Tainted: G        W           7.3.0-rc2-kts-xfs-g0ca15a1a115+ #1
> [144870.968920][  T172] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> [144870.970043][  T172] task:kworker/20:1    state:D stack:0     pid:3814407 tgid:3814407 ppid:2      task_flags:0x4248060 flags:0x00080000
> [144870.971395][  T172] Workqueue: dio/sdg iomap_dio_complete_work
> [144870.972198][  T172] Call Trace:
> [144870.972772][  T172]  <TASK>
> [144870.973279][  T172]  __schedule+0xc86/0x1b10
> [144870.973888][  T172]  ? trace_hardirqs_on+0x18/0x1a0
> [144870.974596][  T172]  ? __pfx___schedule+0x10/0x10
> [144870.975254][  T172]  ? _raw_spin_unlock_irq+0x28/0x50
> [144870.975899][  T172]  ? wq_worker_sleeping+0x213/0x280
> [144870.976689][  T172]  ? find_held_lock+0x2b/0x80
> [144870.977241][  T172]  ? __lock_release.isra.0+0x69/0x1a0
> [144870.977916][  T172]  schedule+0xe5/0x2e0
> [144870.978586][  T172]  ? _raw_spin_unlock_irq+0x28/0x50
> [144870.979182][  T172]  schedule_preempt_disabled+0x16/0x30
> [144870.979886][  T172]  rwsem_down_write_slowpath+0x4b4/0x1460
> [144870.980635][  T172]  ? __kasan_slab_alloc+0x7f/0x90
> [144870.981287][  T172]  ? __pfx_rwsem_down_write_slowpath+0x10/0x10
> [144870.982017][  T172]  ? __lock_acquire+0x691/0xd00
> [144870.982700][  T172]  ? lock_acquire.part.0+0xc8/0x240
> [144870.983391][  T172]  ? lock_acquire+0x11a/0x140
> [144870.984047][  T172]  down_write_nested+0x1c0/0x1f0
> [144870.984778][  T172]  ? __pfx_down_write_nested+0x10/0x10
> [144870.985569][  T172]  ? xfs_ilock+0x1e7/0x310 [xfs]
> [144870.987084][  T172]  xfs_reflink_end_atomic_cow+0x2f3/0x560 [xfs]
> [144870.988587][  T172]  ? __pfx_xfs_reflink_end_atomic_cow+0x10/0x10 [xfs]
> [144870.990093][  T172]  ? lock_is_held_type+0xb0/0x180
> [144870.990804][  T172]  ? __lock_acquire+0x691/0xd00
> [144870.991435][  T172]  xfs_dio_write_end_io+0x4b7/0x650 [xfs]
> [144870.992815][  T172]  ? __pfx_xfs_dio_write_end_io+0x10/0x10 [xfs]
> [144870.994256][  T172]  iomap_dio_complete+0x140/0xb20
> [144870.994897][  T172]  ? __pfx_aio_complete_rw+0x10/0x10
> [144870.995533][  T172]  iomap_dio_complete_work+0x58/0x90
> [144870.996229][  T172]  process_one_work+0x947/0x1760
> [144870.996919][  T172]  ? __pfx_process_one_work+0x10/0x10
> [144870.997519][  T172]  ? lock_acquire.part.0+0xc8/0x240
> [144870.998095][  T172]  ? lock_is_held_type+0xb0/0x180
> [144870.998755][  T172]  worker_thread+0x601/0xff0
> [144870.999262][  T172]  ? __pfx_worker_thread+0x10/0x10
> [144870.999854][  T172]  kthread+0x361/0x460
> [144871.000422][  T172]  ? __pfx_kthread+0x10/0x10
> [144871.000971][  T172]  ret_from_fork+0x560/0x860
> [144871.001596][  T172]  ? __pfx_ret_from_fork+0x10/0x10
> [144871.002150][  T172]  ? __switch_to+0x473/0xd50
> [144871.002764][  T172]  ? __pfx_kthread+0x10/0x10
> [144871.003268][  T172]  ret_from_fork_asm+0x1a/0x30
> [144871.003871][  T172]  </TASK>
> [144871.006437][  T172] INFO: task kworker/20:1:3814407 <writer> blocked on an rw-semaphore likely owned by task kworker/1:2:3819893 <writer>
> [144871.007488][  T172] INFO: task kworker/16:2:3814415 blocked for more than 123 seconds.
> [144871.008373][  T172]       Tainted: G        W           7.3.0-rc2-kts-xfs-g0ca15a1a115+ #1
> [144871.009098][  T172] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> [144871.009935][  T172] task:kworker/16:2    state:D stack:0     pid:3814415 tgid:3814415 ppid:2      task_flags:0x4248060 flags:0x00080000
> [144871.010908][  T172] Workqueue: dio/sdg iomap_dio_complete_work
> [144871.011529][  T172] Call Trace:
> [144871.011921][  T172]  <TASK>
> [144871.012338][  T172]  __schedule+0xc86/0x1b10
> [144871.012801][  T172]  ? trace_hardirqs_on+0x18/0x1a0
> [144871.013341][  T172]  ? __pfx___schedule+0x10/0x10
> [144871.013912][  T172]  ? _raw_spin_unlock_irq+0x28/0x50
> [144871.014491][  T172]  ? wq_worker_sleeping+0x213/0x280
> [144871.015122][  T172]  ? find_held_lock+0x2b/0x80
> [144871.015734][  T172]  ? __lock_release.isra.0+0x69/0x1a0
> [144871.016274][  T172]  schedule+0xe5/0x2e0
> [144871.016820][  T172]  ? _raw_spin_unlock_irq+0x28/0x50
> [144871.017430][  T172]  schedule_preempt_disabled+0x16/0x30
> [144871.017981][  T172]  rwsem_down_write_slowpath+0x4b4/0x1460
> [144871.018500][  T172]  ? __kasan_slab_alloc+0x7f/0x90
> [144871.019066][  T172]  ? __pfx_rwsem_down_write_slowpath+0x10/0x10
> [144871.019691][  T172]  ? __lock_acquire+0x691/0xd00
> [144871.020216][  T172]  ? lock_acquire.part.0+0xc8/0x240
> [144871.020806][  T172]  ? lock_acquire+0x11a/0x140
> [144871.021350][  T172]  down_write_nested+0x1c0/0x1f0
> [144871.021847][  T172]  ? __pfx_down_write_nested+0x10/0x10
> [144871.022365][  T172]  ? xfs_ilock+0x1e7/0x310 [xfs]
> [144871.023499][  T172]  xfs_reflink_end_atomic_cow+0x2f3/0x560 [xfs]
> [144871.024814][  T172]  ? __pfx_xfs_reflink_end_atomic_cow+0x10/0x10 [xfs]
> [144871.026064][  T172]  ? update_load_avg+0xb65/0x2c70
> [144871.026726][  T172]  ? __lock_acquire+0x691/0xd00
> [144871.027267][  T172]  xfs_dio_write_end_io+0x4b7/0x650 [xfs]
> [144871.028538][  T172]  ? __pfx_xfs_dio_write_end_io+0x10/0x10 [xfs]
> [144871.029728][  T172]  iomap_dio_complete+0x140/0xb20
> [144871.030224][  T172]  ? __pfx_aio_complete_rw+0x10/0x10
> [144871.030743][  T172]  iomap_dio_complete_work+0x58/0x90
> [144871.031190][  T172]  process_one_work+0x947/0x1760
> [144871.031764][  T172]  ? __pfx_process_one_work+0x10/0x10
> [144871.032294][  T172]  ? lock_acquire.part.0+0xc8/0x240
> [144871.032889][  T172]  ? lock_is_held_type+0xb0/0x180
> [144871.033502][  T172]  worker_thread+0x601/0xff0
> [144871.034040][  T172]  ? __pfx_worker_thread+0x10/0x10
> [144871.034640][  T172]  kthread+0x361/0x460
> [144871.035071][  T172]  ? __pfx_kthread+0x10/0x10
> [144871.035679][  T172]  ret_from_fork+0x560/0x860
> [144871.036162][  T172]  ? __pfx_ret_from_fork+0x10/0x10
> [144871.036758][  T172]  ? __switch_to+0x473/0xd50
> [144871.037334][  T172]  ? __pfx_kthread+0x10/0x10
> [144871.037914][  T172]  ret_from_fork_asm+0x1a/0x30
> [144871.038394][  T172]  </TASK>
> [144871.038867][  T172] INFO: task kworker/16:2:3814415 <writer> blocked on an rw-semaphore likely owned by task kworker/1:2:3819893 <writer>
> [144871.039846][  T172] INFO: task kworker/1:2:3819893 blocked for more than 123 seconds.
> [144871.040650][  T172]       Tainted: G        W           7.3.0-rc2-kts-xfs-g0ca15a1a115+ #1
> [144871.041422][  T172] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> [144871.042136][  T172] task:kworker/1:2     state:D stack:0     pid:3819893 tgid:3819893 ppid:2      task_flags:0x4248060 flags:0x00080000
> [144871.043104][  T172] Workqueue: dio/sdg iomap_dio_complete_work
> [144871.043712][  T172] Call Trace:
> [144871.044164][  T172]  <TASK>
> [144871.044651][  T172]  __schedule+0xc86/0x1b10
> [144871.045172][  T172]  ? __pfx___schedule+0x10/0x10
> [144871.045707][  T172]  ? schedule+0x17e/0x2e0
> [144871.046192][  T172]  ? wq_worker_sleeping+0x65/0x280
> [144871.046741][  T172]  ? find_held_lock+0x2b/0x80
> [144871.047186][  T172]  ? __lock_release.isra.0+0x69/0x1a0
> [144871.047796][  T172]  schedule+0xe5/0x2e0
> [144871.048299][  T172]  xlog_grant_head_wait+0x175/0xac0 [xfs]
> [144871.049471][  T172]  xlog_grant_head_check+0x312/0x3f0 [xfs]
> [144871.050717][  T172]  ? __pfx_xlog_grant_head_check+0x10/0x10 [xfs]
> [144871.051932][  T172]  xfs_log_regrant+0x380/0x7d0 [xfs]
> [144871.053059][  T172]  ? __pfx_xfs_log_regrant+0x10/0x10 [xfs]
> [144871.054192][  T172]  ? xfs_log_ticket_get+0x1b/0x30 [xfs]
> [144871.055259][  T172]  ? xfs_defer_trans_roll+0x11e/0x4b0 [xfs]
> [144871.056414][  T172]  xfs_trans_roll+0x2d9/0x420 [xfs]
> [144871.057517][  T172]  ? kmem_cache_alloc_noprof+0x45b/0x680
> [144871.058100][  T172]  ? xfs_defer_finish_noroll+0x460/0xe70 [xfs]
> [144871.059201][  T172]  xfs_defer_trans_roll+0x11e/0x4b0 [xfs]
> [144871.060341][  T172]  ? __pfx_xfs_defer_trans_roll+0x10/0x10 [xfs]
> [144871.061364][  T172]  ? xfs_defer_relog+0x3e7/0xb50 [xfs]
> [144871.062454][  T172]  xfs_defer_finish_noroll+0x460/0xe70 [xfs]
> [144871.063491][  T172]  ? __pfx_xfs_reflink_end_cow_extent_locked+0x10/0x10 [xfs]
> [144871.064782][  T172]  ? __pfx_xfs_defer_finish_noroll+0x10/0x10 [xfs]
> [144871.065859][  T172]  ? lock_acquire+0x11a/0x140
> [144871.066413][  T172]  xfs_trans_commit+0xfc/0x180 [xfs]
> [144871.067509][  T172]  ? __pfx_down_write_nested+0x10/0x10
> [144871.068046][  T172]  ? __pfx_xfs_trans_commit+0x10/0x10 [xfs]
> [144871.069143][  T172]  xfs_reflink_end_atomic_cow+0x3b2/0x560 [xfs]
> [144871.070340][  T172]  ? __pfx_xfs_reflink_end_atomic_cow+0x10/0x10 [xfs]
> [144871.071419][  T172]  ? __lock_acquire+0x691/0xd00
> [144871.089717][  T172]  xfs_dio_write_end_io+0x4b7/0x650 [xfs]
> [144871.090837][  T172]  ? __pfx_xfs_dio_write_end_io+0x10/0x10 [xfs]
> [144871.091794][  T172]  iomap_dio_complete+0x140/0xb20
> [144871.092194][  T172]  ? __pfx_aio_complete_rw+0x10/0x10
> [144871.092684][  T172]  iomap_dio_complete_work+0x58/0x90
> [144871.093251][  T172]  process_one_work+0x947/0x1760
> [144871.093761][  T172]  ? __pfx_process_one_work+0x10/0x10
> [144871.094406][  T172]  ? lock_acquire.part.0+0xc8/0x240
> [144871.095084][  T172]  ? lock_is_held_type+0xb0/0x180
> [144871.095679][  T172]  worker_thread+0x601/0xff0
> [144871.096234][  T172]  ? __pfx_worker_thread+0x10/0x10
> [144871.096820][  T172]  kthread+0x361/0x460
> [144871.097360][  T172]  ? __pfx_kthread+0x10/0x10
> [144871.098065][  T172]  ret_from_fork+0x560/0x860
> [144871.098693][  T172]  ? __pfx_ret_from_fork+0x10/0x10
> [144871.099175][  T172]  ? __switch_to+0x473/0xd50
> [144871.099709][  T172]  ? __pfx_kthread+0x10/0x10
> [144871.100275][  T172]  ret_from_fork_asm+0x1a/0x30
> [144871.100783][  T172]  </TASK>
> [144871.101203][  T172] INFO: task kworker/20:2:3824669 blocked for more than 123 seconds.
> [144871.102109][  T172]       Tainted: G        W           7.3.0-rc2-kts-xfs-g0ca15a1a115+ #1
> [144871.102813][  T172] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> [144871.103685][  T172] task:kworker/20:2    state:D stack:0     pid:3824669 tgid:3824669 ppid:2      task_flags:0x4248060 flags:0x00080000
> [144871.104588][  T172] Workqueue: dio/sdg iomap_dio_complete_work
> [144871.105360][  T172] Call Trace:
> [144871.105868][  T172]  <TASK>
> [144871.106339][  T172]  __schedule+0xc86/0x1b10
> [144871.106949][  T172]  ? trace_hardirqs_on+0x18/0x1a0
> [144871.107632][  T172]  ? __pfx___schedule+0x10/0x10
> [144871.108170][  T172]  ? _raw_spin_unlock_irq+0x28/0x50
> [144871.108600][  T172]  ? wq_worker_sleeping+0x213/0x280
> [144871.109207][  T172]  ? find_held_lock+0x2b/0x80
> [144871.109728][  T172]  ? __lock_release.isra.0+0x69/0x1a0
> [144871.110270][  T172]  schedule+0xe5/0x2e0
> [144871.110762][  T172]  ? _raw_spin_unlock_irq+0x28/0x50
> [144871.111328][  T172]  schedule_preempt_disabled+0x16/0x30
> [144871.111898][  T172]  rwsem_down_write_slowpath+0x4b4/0x1460
> [144871.112410][  T172]  ? __kasan_slab_alloc+0x7f/0x90
> [144871.112989][  T172]  ? __pfx_rwsem_down_write_slowpath+0x10/0x10
> [144871.113648][  T172]  ? __lock_acquire+0x691/0xd00
> [144871.114157][  T172]  ? lock_acquire.part.0+0xc8/0x240
> [144871.114665][  T172]  ? lock_acquire+0x11a/0x140
> [144871.115101][  T172]  down_write_nested+0x1c0/0x1f0
> [144871.115664][  T172]  ? __pfx_down_write_nested+0x10/0x10
> [144871.116122][  T172]  ? xfs_ilock+0x1e7/0x310 [xfs]
> [144871.117105][  T172]  xfs_reflink_end_atomic_cow+0x2f3/0x560 [xfs]
> [144871.118239][  T172]  ? __pfx_xfs_reflink_end_atomic_cow+0x10/0x10 [xfs]
> [144871.119389][  T172]  ? lock_is_held_type+0xb0/0x180
> [144871.119781][  T172]  ? __lock_acquire+0x691/0xd00
> [144871.120177][  T172]  xfs_dio_write_end_io+0x4b7/0x650 [xfs]
> [144871.121294][  T172]  ? __pfx_xfs_dio_write_end_io+0x10/0x10 [xfs]
> [144871.122391][  T172]  iomap_dio_complete+0x140/0xb20
> [144871.122770][  T172]  ? __pfx_aio_complete_rw+0x10/0x10
> [144871.123425][  T172]  iomap_dio_complete_work+0x58/0x90
> [144871.124051][  T172]  process_one_work+0x947/0x1760
> [144871.124445][  T172]  ? __pfx_process_one_work+0x10/0x10
> [144871.125017][  T172]  ? lock_acquire.part.0+0xc8/0x240
> [144871.125580][  T172]  ? lock_is_held_type+0xb0/0x180
> [144871.126138][  T172]  worker_thread+0x601/0xff0
> [144871.126680][  T172]  ? __pfx_worker_thread+0x10/0x10
> [144871.127126][  T172]  kthread+0x361/0x460
> [144871.127762][  T172]  ? __pfx_kthread+0x10/0x10
> [144871.128234][  T172]  ret_from_fork+0x560/0x860
> [144871.128772][  T172]  ? __pfx_ret_from_fork+0x10/0x10
> [144871.129337][  T172]  ? __switch_to+0x473/0xd50
> [144871.129842][  T172]  ? __pfx_kthread+0x10/0x10
> [144871.130364][  T172]  ret_from_fork_asm+0x1a/0x30
> [144871.130892][  T172]  </TASK>
> [144871.131250][  T172] INFO: task kworker/20:2:3824669 <writer> blocked on an rw-semaphore likely owned by task kworker/1:2:3819893 <writer>
> [144871.132261][  T172] INFO: task kworker/4:0:3824816 blocked for more than 123 seconds.
> [144871.133177][  T172]       Tainted: G        W           7.3.0-rc2-kts-xfs-g0ca15a1a115+ #1
> [144871.133912][  T172] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> [144871.134827][  T172] task:kworker/4:0     state:D stack:0     pid:3824816 tgid:3824816 ppid:2      task_flags:0x4248060 flags:0x00080000
> [144871.135724][  T172] Workqueue: dio/sdg iomap_dio_complete_work
> [144871.136356][  T172] Call Trace:
> [144871.136856][  T172]  <TASK>
> [144871.137342][  T172]  __schedule+0xc86/0x1b10
> [144871.137818][  T172]  ? __pfx___schedule+0x10/0x10
> [144871.138410][  T172]  ? schedule+0x17e/0x2e0
> [144871.138810][  T172]  ? wq_worker_sleeping+0x65/0x280
> [144871.139356][  T172]  ? find_held_lock+0x2b/0x80
> [144871.139817][  T172]  ? __lock_release.isra.0+0x69/0x1a0
> [144871.140631][  T172]  schedule+0xe5/0x2e0
> [144871.141220][  T172]  ? _raw_spin_unlock_irq+0x28/0x50
> [144871.141887][  T172]  schedule_preempt_disabled+0x16/0x30
> [144871.142473][  T172]  rwsem_down_write_slowpath+0x4b4/0x1460
> [144871.143026][  T172]  ? lock_release.part.0+0x1c/0x50
> [144871.143557][  T172]  ? __pfx_rwsem_down_write_slowpath+0x10/0x10
> [144871.144101][  T172]  ? __lock_acquire+0x691/0xd00
> [144871.144681][  T172]  ? lock_acquire.part.0+0xc8/0x240
> [144871.145057][  T172]  ? lock_acquire+0x11a/0x140
> [144871.145709][  T172]  down_write_nested+0x1c0/0x1f0
> [144871.146205][  T172]  ? __pfx_down_write_nested+0x10/0x10
> [144871.146885][  T172]  ? xfs_ilock+0x1e7/0x310 [xfs]
> [144871.147929][  T172]  xfs_reflink_end_atomic_cow+0x2f3/0x560 [xfs]
> [144871.148978][  T172]  ? __pfx_xfs_reflink_end_atomic_cow+0x10/0x10 [xfs]
> [144871.150061][  T172]  ? __lock_acquire+0x691/0xd00
> [144871.150641][  T172]  xfs_dio_write_end_io+0x4b7/0x650 [xfs]
> [144871.151842][  T172]  ? __pfx_xfs_dio_write_end_io+0x10/0x10 [xfs]
> [144871.152998][  T172]  iomap_dio_complete+0x140/0xb20
> [144871.153548][  T172]  ? __pfx_aio_complete_rw+0x10/0x10
> [144871.154099][  T172]  iomap_dio_complete_work+0x58/0x90
> [144871.154759][  T172]  process_one_work+0x947/0x1760
> [144871.155210][  T172]  ? __pfx_process_one_work+0x10/0x10
> [144871.155675][  T172]  ? lock_acquire.part.0+0xc8/0x240
> [144871.156336][  T172]  ? lock_is_held_type+0xb0/0x180
> [144871.156920][  T172]  worker_thread+0x601/0xff0
> [144871.157437][  T172]  ? __pfx_worker_thread+0x10/0x10
> [144871.157951][  T172]  kthread+0x361/0x460
> [144871.158466][  T172]  ? __pfx_kthread+0x10/0x10
> [144871.159012][  T172]  ret_from_fork+0x560/0x860
> [144871.159502][  T172]  ? __pfx_ret_from_fork+0x10/0x10
> [144871.160015][  T172]  ? __switch_to+0x473/0xd50
> [144871.160539][  T172]  ? __pfx_kthread+0x10/0x10
> [144871.161051][  T172]  ret_from_fork_asm+0x1a/0x30
> [144871.161685][  T172]  </TASK>
> [144871.162077][  T172] INFO: task kworker/4:0:3824816 <writer> blocked on an rw-semaphore likely owned by task kworker/1:2:3819893 <writer>
> [144871.162900][  T172] INFO: task kworker/12:0:3826849 blocked for more than 123 seconds.
> [144871.163697][  T172]       Tainted: G        W           7.3.0-rc2-kts-xfs-g0ca15a1a115+ #1
> [144871.164415][  T172] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> [144871.165277][  T172] task:kworker/12:0    state:D stack:0     pid:3826849 tgid:3826849 ppid:2      task_flags:0x4248060 flags:0x00080000
> [144871.166221][  T172] Workqueue: dio/sdg iomap_dio_complete_work
> [144871.166952][  T172] Call Trace:
> [144871.167283][  T172]  <TASK>
> [144871.167853][  T172]  __schedule+0xc86/0x1b10
> [144871.168439][  T172]  ? __pfx___schedule+0x10/0x10
> [144871.168914][  T172]  ? schedule+0x17e/0x2e0
> [144871.169451][  T172]  ? wq_worker_sleeping+0x65/0x280
> [144871.169927][  T172]  ? find_held_lock+0x2b/0x80
> [144871.170288][  T172]  ? __lock_release.isra.0+0x69/0x1a0
> [144871.170911][  T172]  schedule+0xe5/0x2e0
> [144871.171387][  T172]  ? _raw_spin_unlock_irq+0x28/0x50
> [144871.171939][  T172]  schedule_preempt_disabled+0x16/0x30
> [144871.172496][  T172]  rwsem_down_write_slowpath+0x4b4/0x1460
> [144871.173087][  T172]  ? lock_release.part.0+0x1c/0x50
> [144871.173702][  T172]  ? __pfx_rwsem_down_write_slowpath+0x10/0x10
> [144871.174226][  T172]  ? __lock_acquire+0x691/0xd00
> [144871.174891][  T172]  ? lock_acquire.part.0+0xc8/0x240
> [144871.175466][  T172]  ? lock_acquire+0x11a/0x140
> [144871.176164][  T172]  down_write_nested+0x1c0/0x1f0
> [144871.176754][  T172]  ? __pfx_down_write_nested+0x10/0x10
> [144871.177531][  T172]  ? xfs_ilock+0x1e7/0x310 [xfs]
> [144871.178526][  T172]  xfs_reflink_end_atomic_cow+0x2f3/0x560 [xfs]
> [144871.179662][  T172]  ? __pfx_xfs_reflink_end_atomic_cow+0x10/0x10 [xfs]
> [144871.180880][  T172]  ? lock_is_held_type+0xb0/0x180
> [144871.181342][  T172]  ? __lock_acquire+0x691/0xd00
> [144871.181872][  T172]  xfs_dio_write_end_io+0x4b7/0x650 [xfs]
> [144871.183071][  T172]  ? __pfx_xfs_dio_write_end_io+0x10/0x10 [xfs]
> [144871.184221][  T172]  iomap_dio_complete+0x140/0xb20
> [144871.184745][  T172]  ? __pfx_aio_complete_rw+0x10/0x10
> [144871.185338][  T172]  iomap_dio_complete_work+0x58/0x90
> [144871.185864][  T172]  process_one_work+0x947/0x1760
> [144871.186361][  T172]  ? __pfx_process_one_work+0x10/0x10
> [144871.186920][  T172]  ? lock_acquire.part.0+0xc8/0x240
> [144871.187381][  T172]  ? lock_is_held_type+0xb0/0x180
> [144871.187924][  T172]  worker_thread+0x601/0xff0
> [144871.188591][  T172]  ? __pfx_worker_thread+0x10/0x10
> [144871.189109][  T172]  kthread+0x361/0x460
> [144871.189647][  T172]  ? __pfx_kthread+0x10/0x10
> [144871.190131][  T172]  ret_from_fork+0x560/0x860
> [144871.190578][  T172]  ? __pfx_ret_from_fork+0x10/0x10
> [144871.191172][  T172]  ? __switch_to+0x473/0xd50
> [144871.191771][  T172]  ? __pfx_kthread+0x10/0x10
> [144871.192247][  T172]  ret_from_fork_asm+0x1a/0x30
> [144871.192760][  T172]  </TASK>
> [144871.193146][  T172] INFO: task kworker/12:0:3826849 <writer> blocked on an rw-semaphore likely owned by task kworker/1:2:3819893 <writer>
> [144871.202516][  T172] INFO: task kworker/21:1:3827095 blocked for more than 123 seconds.
> [144871.203182][  T172]       Tainted: G        W           7.3.0-rc2-kts-xfs-g0ca15a1a115+ #1
> [144871.203953][  T172] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> [144871.204755][  T172] task:kworker/21:1    state:D stack:0     pid:3827095 tgid:3827095 ppid:2      task_flags:0x4248060 flags:0x00080000
> [144871.205642][  T172] Workqueue: dio/sdg iomap_dio_complete_work
> [144871.206251][  T172] Call Trace:
> [144871.206793][  T172]  <TASK>
> [144871.207382][  T172]  __schedule+0xc86/0x1b10
> [144871.207815][  T172]  ? trace_hardirqs_on+0x18/0x1a0
> [144871.208402][  T172]  ? __pfx___schedule+0x10/0x10
> [144871.208871][  T172]  ? _raw_spin_unlock_irq+0x28/0x50
> [144871.209404][  T172]  ? wq_worker_sleeping+0x213/0x280
> [144871.209925][  T172]  ? find_held_lock+0x2b/0x80
> [144871.210492][  T172]  ? __lock_release.isra.0+0x69/0x1a0
> [144871.211050][  T172]  schedule+0xe5/0x2e0
> [144871.211527][  T172]  ? _raw_spin_unlock_irq+0x28/0x50
> [144871.212043][  T172]  schedule_preempt_disabled+0x16/0x30
> [144871.212786][  T172]  rwsem_down_write_slowpath+0x4b4/0x1460
> [144871.213398][  T172]  ? __kasan_slab_alloc+0x7f/0x90
> [144871.213975][  T172]  ? __pfx_rwsem_down_write_slowpath+0x10/0x10
> [144871.214563][  T172]  ? __lock_acquire+0x691/0xd00
> [144871.215009][  T172]  ? lock_acquire.part.0+0xc8/0x240
> [144871.215710][  T172]  ? lock_acquire+0x11a/0x140
> [144871.216164][  T172]  down_write_nested+0x1c0/0x1f0
> [144871.216688][  T172]  ? __pfx_down_write_nested+0x10/0x10
> [144871.217212][  T172]  ? xfs_ilock+0x1e7/0x310 [xfs]
> [144871.218301][  T172]  xfs_reflink_end_atomic_cow+0x2f3/0x560 [xfs]
> [144871.219411][  T172]  ? __pfx_xfs_reflink_end_atomic_cow+0x10/0x10 [xfs]
> [144871.220508][  T172]  ? __lock_acquire+0x691/0xd00
> [144871.221057][  T172]  xfs_dio_write_end_io+0x4b7/0x650 [xfs]
> [144871.222191][  T172]  ? __pfx_xfs_dio_write_end_io+0x10/0x10 [xfs]
> [144871.223292][  T172]  iomap_dio_complete+0x140/0xb20
> [144871.223820][  T172]  ? __pfx_aio_complete_rw+0x10/0x10
> [144871.224332][  T172]  iomap_dio_complete_work+0x58/0x90
> [144871.224792][  T172]  process_one_work+0x947/0x1760
> [144871.225354][  T172]  ? __pfx_process_one_work+0x10/0x10
> [144871.225861][  T172]  ? lock_acquire.part.0+0xc8/0x240
> [144871.226458][  T172]  ? lock_is_held_type+0xb0/0x180
> [144871.226982][  T172]  worker_thread+0x601/0xff0
> [144871.227454][  T172]  ? __pfx_worker_thread+0x10/0x10
> [144871.227993][  T172]  ? __kthread_parkme+0xbd/0x210
> [144871.228532][  T172]  ? __pfx_worker_thread+0x10/0x10
> [144871.229057][  T172]  ? __pfx_worker_thread+0x10/0x10
> [144871.229619][  T172]  kthread+0x361/0x460
> [144871.230083][  T172]  ? __pfx_kthread+0x10/0x10
> [144871.230578][  T172]  ret_from_fork+0x560/0x860
> [144871.231049][  T172]  ? __pfx_ret_from_fork+0x10/0x10
> [144871.231633][  T172]  ? __switch_to+0x473/0xd50
> [144871.232124][  T172]  ? __pfx_kthread+0x10/0x10
> [144871.232544][  T172]  ret_from_fork_asm+0x1a/0x30
> [144871.233081][  T172]  </TASK>
> [144871.233440][  T172] INFO: task kworker/21:1:3827095 <writer> blocked on an rw-semaphore likely owned by task kworker/1:2:3819893 <writer>
> [144871.234328][  T172] INFO: task kworker/10:0:3827669 blocked for more than 123 seconds.
> [144871.235091][  T172]       Tainted: G        W           7.3.0-rc2-kts-xfs-g0ca15a1a115+ #1
> [144871.235858][  T172] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> [144871.236582][  T172] task:kworker/10:0    state:D stack:0     pid:3827669 tgid:3827669 ppid:2      task_flags:0x4248060 flags:0x00080000
> [144871.237651][  T172] Workqueue: dio/sdg iomap_dio_complete_work
> [144871.238173][  T172] Call Trace:
> [144871.238946][  T172]  <TASK>
> [144871.239469][  T172]  __schedule+0xc86/0x1b10
> [144871.240084][  T172]  ? trace_hardirqs_on+0x18/0x1a0
> [144871.240642][  T172]  ? __pfx___schedule+0x10/0x10
> [144871.241088][  T172]  ? _raw_spin_unlock_irq+0x28/0x50
> [144871.241694][  T172]  ? wq_worker_sleeping+0x213/0x280
> [144871.242326][  T172]  ? find_held_lock+0x2b/0x80
> [144871.242813][  T172]  ? __lock_release.isra.0+0x69/0x1a0
> [144871.243379][  T172]  schedule+0xe5/0x2e0
> [144871.243881][  T172]  ? _raw_spin_unlock_irq+0x28/0x50
> [144871.244378][  T172]  schedule_preempt_disabled+0x16/0x30
> [144871.244920][  T172]  rwsem_down_write_slowpath+0x4b4/0x1460
> [144871.245543][  T172]  ? __kasan_slab_alloc+0x7f/0x90
> [144871.246066][  T172]  ? __pfx_rwsem_down_write_slowpath+0x10/0x10
> [144871.246662][  T172]  ? __lock_acquire+0x691/0xd00
> [144871.247131][  T172]  ? lock_acquire.part.0+0xc8/0x240
> [144871.247711][  T172]  ? lock_acquire+0x11a/0x140
> [144871.248149][  T172]  down_write_nested+0x1c0/0x1f0
> [144871.248724][  T172]  ? __pfx_down_write_nested+0x10/0x10
> [144871.249285][  T172]  ? xfs_ilock+0x1e7/0x310 [xfs]
> [144871.250297][  T172]  xfs_reflink_end_atomic_cow+0x2f3/0x560 [xfs]
> [144871.251346][  T172]  ? __pfx_xfs_reflink_end_atomic_cow+0x10/0x10 [xfs]
> [144871.252414][  T172]  ? __lock_acquire+0x691/0xd00
> [144871.252983][  T172]  xfs_dio_write_end_io+0x4b7/0x650 [xfs]
> [144871.254104][  T172]  ? __pfx_xfs_dio_write_end_io+0x10/0x10 [xfs]
> [144871.255189][  T172]  iomap_dio_complete+0x140/0xb20
> [144871.255756][  T172]  ? __pfx_aio_complete_rw+0x10/0x10
> [144871.256283][  T172]  iomap_dio_complete_work+0x58/0x90
> [144871.256814][  T172]  process_one_work+0x947/0x1760
> [144871.257211][  T172]  ? __pfx_process_one_work+0x10/0x10
> [144871.257962][  T172]  ? lock_acquire.part.0+0xc8/0x240
> [144871.258415][  T172]  ? lock_is_held_type+0xb0/0x180
> [144871.258907][  T172]  worker_thread+0x601/0xff0
> [144871.259454][  T172]  ? __pfx_worker_thread+0x10/0x10
> [144871.259949][  T172]  kthread+0x361/0x460
> [144871.260364][  T172]  ? __pfx_kthread+0x10/0x10
> [144871.260889][  T172]  ret_from_fork+0x560/0x860
> [144871.261384][  T172]  ? __pfx_ret_from_fork+0x10/0x10
> [144871.261926][  T172]  ? __switch_to+0x473/0xd50
> [144871.262448][  T172]  ? __pfx_kthread+0x10/0x10
> [144871.262968][  T172]  ret_from_fork_asm+0x1a/0x30
> [144871.263492][  T172]  </TASK>
> [144871.263903][  T172] INFO: task kworker/10:0:3827669 <writer> blocked on an rw-semaphore likely owned by task kworker/1:2:3819893 <writer>
> [144871.264856][  T172] Future hung task reports are suppressed, see sysctl kernel.hung_task_warnings
> [144871.265760][  T172]
> [144871.265760][  T172] Showing all locks held in the system:
> [144871.266766][  T172] locks held by pr/ttyS0/16: 2, last CPU#22:
> [144871.267407][  T172]  #0: ffffffff8c320658 (console_srcu){....}-{0:0}, at: console_srcu_read_lock+0x49/0x70
> [144871.268258][  T172]  #1: ffffffff9c3db638 (&port_lock_key){-.-.}-{3:3}, at: univ8250_console_device_lock+0x63/0xc0
> [144871.269176][  T172] locks held by khungtaskd/172: 1, last CPU#20:
> [144871.269752][  T172]  #0: ffffffff8c3369e0 (rcu_read_lock){....}-{1:3}, at: rcu_lock_acquire.constprop.0+0x7/0x30
> [144871.270692][  T172] locks held by kworker/10:173/3785794: 4, on CPU#10:
> [144871.271375][  T172]  #0: ff1100015b4ee940 ((wq_completion)dio/sdg){+.+.}-{0:0}, at: process_one_work+0x1111/0x1760
> [144871.272341][  T172]  #1: ff11000109407d10 ((work_completion)(&dio->aio.work)){+.+.}-{0:0}, at: process_one_work+0x8c3/0x1760
> [144871.273284][  T172]  #2: ff110002d3ad4650 (sb_internal#2){++++}-{0:0}, at: xfs_trans_alloc+0x7b/0x820 [xfs]
> [144871.274707][  T172]  #3: ff11000100bb16c0 (&xfs_nondir_ilock_class){++++}-{4:4}, at: xfs_reflink_end_atomic_cow+0x2f3/0x560 [xfs]
> [144871.276050][  T172] locks held by kworker/18:2/3812136: 4, on CPU#18:
> [144871.276811][  T172]  #0: ff1100015b4ee940 ((wq_completion)dio/sdg){+.+.}-{0:0}, at: process_one_work+0x1111/0x1760
> [144871.277696][  T172]  #1: ff1100018e71fd10 ((work_completion)(&dio->aio.work)){+.+.}-{0:0}, at: process_one_work+0x8c3/0x1760
> [144871.278634][  T172]  #2: ff110002d3ad4650 (sb_internal#2){++++}-{0:0}, at: xfs_trans_alloc+0x7b/0x820 [xfs]
> [144871.280090][  T172]  #3: ff11000100bb16c0 (&xfs_nondir_ilock_class){++++}-{4:4}, at: xfs_reflink_end_atomic_cow+0x2f3/0x560 [xfs]
> [144871.281626][  T172] locks held by kworker/20:1/3814407: 4, on CPU#20:
> [144871.282267][  T172]  #0: ff1100015b4ee940 ((wq_completion)dio/sdg){+.+.}-{0:0}, at: process_one_work+0x1111/0x1760
> [144871.283196][  T172]  #1: ff11000214267d10 ((work_completion)(&dio->aio.work)){+.+.}-{0:0}, at: process_one_work+0x8c3/0x1760
> [144871.284154][  T172]  #2: ff110002d3ad4650 (sb_internal#2){++++}-{0:0}, at: xfs_trans_alloc+0x7b/0x820 [xfs]
> [144871.285620][  T172]  #3: ff11000100bb16c0 (&xfs_nondir_ilock_class){++++}-{4:4}, at: xfs_reflink_end_atomic_cow+0x2f3/0x560 [xfs]
> [144871.287063][  T172] locks held by kworker/16:2/3814415: 4, on CPU#16:
> [144871.287789][  T172]  #0: ff1100015b4ee940 ((wq_completion)dio/sdg){+.+.}-{0:0}, at: process_one_work+0x1111/0x1760
> [144871.288637][  T172]  #1: ff1100019cc67d10 ((work_completion)(&dio->aio.work)){+.+.}-{0:0}, at: process_one_work+0x8c3/0x1760
> [144871.289792][  T172]  #2: ff110002d3ad4650 (sb_internal#2){++++}-{0:0}, at: xfs_trans_alloc+0x7b/0x820 [xfs]
> [144871.291054][  T172]  #3: ff11000100bb16c0 (&xfs_nondir_ilock_class){++++}-{4:4}, at: xfs_reflink_end_atomic_cow+0x2f3/0x560 [xfs]
> [144871.292462][  T172] locks held by kworker/1:2/3819893: 4, on CPU#1:
> [144871.293085][  T172]  #0: ff1100015b4ee940 ((wq_completion)dio/sdg){+.+.}-{0:0}, at: process_one_work+0x1111/0x1760
> [144871.294070][  T172]  #1: ff110001246d7d10 ((work_completion)(&dio->aio.work)){+.+.}-{0:0}, at: process_one_work+0x8c3/0x1760
> [144871.294991][  T172]  #2: ff110002d3ad4650 (sb_internal#2){++++}-{0:0}, at: xfs_trans_alloc+0x7b/0x820 [xfs]
> [144871.296348][  T172]  #3: ff11000100bb16c0 (&xfs_nondir_ilock_class){++++}-{4:4}, at: xfs_reflink_end_atomic_cow+0x2f3/0x560 [xfs]
> [144871.297789][  T172] locks held by kworker/20:2/3824669: 4, on CPU#20:
> [144871.298349][  T172]  #0: ff1100015b4ee940 ((wq_completion)dio/sdg){+.+.}-{0:0}, at: process_one_work+0x1111/0x1760
> [144871.299205][  T172]  #1: ff1100022fc77d10 ((work_completion)(&dio->aio.work)){+.+.}-{0:0}, at: process_one_work+0x8c3/0x1760
> [144871.300225][  T172]  #2: ff110002d3ad4650 (sb_internal#2){++++}-{0:0}, at: xfs_trans_alloc+0x7b/0x820 [xfs]
> [144871.301638][  T172]  #3: ff11000100bb16c0 (&xfs_nondir_ilock_class){++++}-{4:4}, at: xfs_reflink_end_atomic_cow+0x2f3/0x560 [xfs]
> [144871.303077][  T172] locks held by kworker/4:0/3824816: 4, on CPU#4:
> [144871.303744][  T172]  #0: ff1100015b4ee940 ((wq_completion)dio/sdg){+.+.}-{0:0}, at: process_one_work+0x1111/0x1760
> [144871.312636][  T172]  #1: ff11000424997d10 ((work_completion)(&dio->aio.work)){+.+.}-{0:0}, at: process_one_work+0x8c3/0x1760
> [144871.313372][  T172]  #2: ff110002d3ad4650 (sb_internal#2){++++}-{0:0}, at: xfs_trans_alloc+0x7b/0x820 [xfs]
> [144871.314586][  T172]  #3: ff11000100bb16c0 (&xfs_nondir_ilock_class){++++}-{4:4}, at: xfs_reflink_end_atomic_cow+0x2f3/0x560 [xfs]
> [144871.315921][  T172] locks held by kworker/12:0/3826849: 4, on CPU#12:
> [144871.316445][  T172]  #0: ff1100015b4ee940 ((wq_completion)dio/sdg){+.+.}-{0:0}, at: process_one_work+0x1111/0x1760
> [144871.317222][  T172]  #1: ff110001e71bfd10 ((work_completion)(&dio->aio.work)){+.+.}-{0:0}, at: process_one_work+0x8c3/0x1760
> [144871.318124][  T172]  #2: ff110002d3ad4650 (sb_internal#2){++++}-{0:0}, at: xfs_trans_alloc+0x7b/0x820 [xfs]
> [144871.319340][  T172]  #3: ff11000100bb16c0 (&xfs_nondir_ilock_class){++++}-{4:4}, at: xfs_reflink_end_atomic_cow+0x2f3/0x560 [xfs]
> [144871.320712][  T172] locks held by kworker/21:1/3827095: 4, on CPU#21:
> [144871.321339][  T172]  #0: ff1100015b4ee940 ((wq_completion)dio/sdg){+.+.}-{0:0}, at: process_one_work+0x1111/0x1760
> [144871.322330][  T172]  #1: ff11000172fefd10 ((work_completion)(&dio->aio.work)){+.+.}-{0:0}, at: process_one_work+0x8c3/0x1760
> [144871.323140][  T172]  #2: ff110002d3ad4650 (sb_internal#2){++++}-{0:0}, at: xfs_trans_alloc+0x7b/0x820 [xfs]
> [144871.324642][  T172]  #3: ff11000100bb16c0 (&xfs_nondir_ilock_class){++++}-{4:4}, at: xfs_reflink_end_atomic_cow+0x2f3/0x560 [xfs]
> [144871.326042][  T172] locks held by kworker/10:0/3827669: 4, on CPU#10:
> [144871.326655][  T172]  #0: ff1100015b4ee940 ((wq_completion)dio/sdg){+.+.}-{0:0}, at: process_one_work+0x1111/0x1760
> [144871.327575][  T172]  #1: ff11000122177d10 ((work_completion)(&dio->aio.work)){+.+.}-{0:0}, at: process_one_work+0x8c3/0x1760
> [144871.328366][  T172]  #2: ff110002d3ad4650 (sb_internal#2){++++}-{0:0}, at: xfs_trans_alloc+0x7b/0x820 [xfs]
> [144871.329889][  T172]  #3: ff11000100bb16c0 (&xfs_nondir_ilock_class){++++}-{4:4}, at: xfs_reflink_end_atomic_cow+0x2f3/0x560 [xfs]
> [144871.331476][  T172] locks held by kworker/17:1/3827670: 4, on CPU#17:
> [144871.332105][  T172]  #0: ff1100015b4ee940 ((wq_completion)dio/sdg){+.+.}-{0:0}, at: process_one_work+0x1111/0x1760
> [144871.332897][  T172]  #1: ff110001d0307d10 ((work_completion)(&dio->aio.work)){+.+.}-{0:0}, at: process_one_work+0x8c3/0x1760
> [144871.333703][  T172]  #2: ff110002d3ad4650 (sb_internal#2){++++}-{0:0}, at: xfs_trans_alloc+0x7b/0x820 [xfs]
> [144871.334981][  T172]  #3: ff11000100bb16c0 (&xfs_nondir_ilock_class){++++}-{4:4}, at: xfs_reflink_end_atomic_cow+0x2f3/0x560 [xfs]
> [144871.336354][  T172] locks held by kworker/16:1/3864132: 4, on CPU#16:
> [144871.337033][  T172]  #0: ff1100015b4ee940 ((wq_completion)dio/sdg){+.+.}-{0:0}, at: process_one_work+0x1111/0x1760
> [144871.337973][  T172]  #1: ff1100023211fd10 ((work_completion)(&dio->aio.work)){+.+.}-{0:0}, at: process_one_work+0x8c3/0x1760
> [144871.338641][  T172]  #2: ff110002d3ad4650 (sb_internal#2){++++}-{0:0}, at: xfs_trans_alloc+0x7b/0x820 [xfs]
> [144871.339966][  T172]  #3: ff11000100bb16c0 (&xfs_nondir_ilock_class){++++}-{4:4}, at: xfs_reflink_end_atomic_cow+0x2f3/0x560 [xfs]
> [144871.341388][  T172] locks held by kworker/8:1/3868486: 4, on CPU#8:
> [144871.342196][  T172]  #0: ff1100015b4ee940 ((wq_completion)dio/sdg){+.+.}-{0:0}, at: process_one_work+0x1111/0x1760
> [144871.343143][  T172]  #1: ff110001a24d7d10 ((work_completion)(&dio->aio.work)){+.+.}-{0:0}, at: process_one_work+0x8c3/0x1760
> [144871.344179][  T172]  #2: ff110002d3ad4650 (sb_internal#2){++++}-{0:0}, at: xfs_trans_alloc+0x7b/0x820 [xfs]
> [144871.345576][  T172]  #3: ff11000100bb16c0 (&xfs_nondir_ilock_class){++++}-{4:4}, at: xfs_reflink_end_atomic_cow+0x2f3/0x560 [xfs]
> [144871.347006][  T172] locks held by kworker/10:1/3872909: 4, on CPU#10:
> [144871.347626][  T172]  #0: ff1100015b4ee940 ((wq_completion)dio/sdg){+.+.}-{0:0}, at: process_one_work+0x1111/0x1760
> [144871.348518][  T172]  #1: ff110001606dfd10 ((work_completion)(&dio->aio.work)){+.+.}-{0:0}, at: process_one_work+0x8c3/0x1760
> [144871.349516][  T172]  #2: ff110002d3ad4650 (sb_internal#2){++++}-{0:0}, at: xfs_trans_alloc+0x7b/0x820 [xfs]
> [144871.350857][  T172]  #3: ff11000100bb16c0 (&xfs_nondir_ilock_class){++++}-{4:4}, at: xfs_reflink_end_atomic_cow+0x2f3/0x560 [xfs]
> [144871.352433][  T172] locks held by kworker/17:2/3872910: 4, on CPU#17:
> [144871.353061][  T172]  #0: ff1100015b4ee940 ((wq_completion)dio/sdg){+.+.}-{0:0}, at: process_one_work+0x1111/0x1760
> [144871.354161][  T172]  #1: ff1100041c1b7d10 ((work_completion)(&dio->aio.work)){+.+.}-{0:0}, at: process_one_work+0x8c3/0x1760
> [144871.354964][  T172]  #2: ff110002d3ad4650 (sb_internal#2){++++}-{0:0}, at: xfs_trans_alloc+0x7b/0x820 [xfs]
> [144871.356302][  T172]  #3: ff11000100bb16c0 (&xfs_nondir_ilock_class){++++}-{4:4}, at: xfs_reflink_end_atomic_cow+0x2f3/0x560 [xfs]
> [144871.357755][  T172] locks held by kworker/23:0/3872911: 4, on CPU#23:
> [144871.358527][  T172]  #0: ff1100015b4ee940 ((wq_completion)dio/sdg){+.+.}-{0:0}, at: process_one_work+0x1111/0x1760
> [144871.359329][  T172]  #1: ff110004b8c8fd10 ((work_completion)(&dio->aio.work)){+.+.}-{0:0}, at: process_one_work+0x8c3/0x1760
> [144871.360223][  T172]  #2: ff110002d3ad4650 (sb_internal#2){++++}-{0:0}, at: xfs_trans_alloc+0x7b/0x820 [xfs]
> [144871.361505][  T172]  #3: ff11000100bb16c0 (&xfs_nondir_ilock_class){++++}-{4:4}, at: xfs_reflink_end_atomic_cow+0x2f3/0x560 [xfs]
> [144871.363110][  T172] locks held by kworker/7:3/3872919: 4, on CPU#7:
> [144871.363803][  T172]  #0: ff1100015b4ee940 ((wq_completion)dio/sdg){+.+.}-{0:0}, at: process_one_work+0x1111/0x1760
> [144871.364639][  T172]  #1: ff1100019af97d10 ((work_completion)(&dio->aio.work)){+.+.}-{0:0}, at: process_one_work+0x8c3/0x1760
> [144871.365488][  T172]  #2: ff110002d3ad4650 (sb_internal#2){++++}-{0:0}, at: xfs_trans_alloc+0x7b/0x820 [xfs]
> [144871.366938][  T172]  #3: ff11000100bb16c0 (&xfs_nondir_ilock_class){++++}-{4:4}, at: xfs_reflink_end_atomic_cow+0x2f3/0x560 [xfs]
> [144871.368364][  T172] locks held by kworker/20:3/3872924: 4, on CPU#20:
> [144871.369008][  T172]  #0: ff1100015b4ee940 ((wq_completion)dio/sdg){+.+.}-{0:0}, at: process_one_work+0x1111/0x1760
> [144871.369969][  T172]  #1: ff110001aa42fd10 ((work_completion)(&dio->aio.work)){+.+.}-{0:0}, at: process_one_work+0x8c3/0x1760
> [144871.371118][  T172]  #2: ff110002d3ad4650 (sb_internal#2){++++}-{0:0}, at: xfs_trans_alloc+0x7b/0x820 [xfs]
> [144871.372518][  T172]  #3: ff11000100bb16c0 (&xfs_nondir_ilock_class){++++}-{4:4}, at: xfs_reflink_end_atomic_cow+0x2f3/0x560 [xfs]
> [144871.373983][  T172] locks held by kworker/3:2/3872925: 4, on CPU#3:
> [144871.374629][  T172]  #0: ff1100015b4ee940 ((wq_completion)dio/sdg){+.+.}-{0:0}, at: process_one_work+0x1111/0x1760
> [144871.375515][  T172]  #1: ff11000444b8fd10 ((work_completion)(&dio->aio.work)){+.+.}-{0:0}, at: process_one_work+0x8c3/0x1760
> [144871.376358][  T172]  #2: ff110002d3ad4650 (sb_internal#2){++++}-{0:0}, at: xfs_trans_alloc+0x7b/0x820 [xfs]
> [144871.377586][  T172]  #3: ff11000100bb16c0 (&xfs_nondir_ilock_class){++++}-{4:4}, at: xfs_reflink_end_atomic_cow+0x2f3/0x560 [xfs]
> [144871.378950][  T172] locks held by kworker/16:3/3872926: 4, on CPU#16:
> [144871.379685][  T172]  #0: ff1100015b4ee940 ((wq_completion)dio/sdg){+.+.}-{0:0}, at: process_one_work+0x1111/0x1760
> [144871.380610][  T172]  #1: ff11000682cdfd10 ((work_completion)(&dio->aio.work)){+.+.}-{0:0}, at: process_one_work+0x8c3/0x1760
> [144871.381567][  T172]  #2: ff110002d3ad4650 (sb_internal#2){++++}-{0:0}, at: xfs_trans_alloc+0x7b/0x820 [xfs]
> [144871.382968][  T172]  #3: ff11000100bb16c0 (&xfs_nondir_ilock_class){++++}-{4:4}, at: xfs_reflink_end_atomic_cow+0x2f3/0x560 [xfs]
> [144871.384263][  T172] locks held by kworker/17:3/3872927: 4, on CPU#17:
> [144871.384833][  T172]  #0: ff1100015b4ee940 ((wq_completion)dio/sdg){+.+.}-{0:0}, at: process_one_work+0x1111/0x1760
> [144871.385697][  T172]  #1: ff110001d3ca7d10 ((work_completion)(&dio->aio.work)){+.+.}-{0:0}, at: process_one_work+0x8c3/0x1760
> [144871.386411][  T172]  #2: ff110002d3ad4650 (sb_internal#2){++++}-{0:0}, at: xfs_trans_alloc+0x7b/0x820 [xfs]
> [144871.387778][  T172]  #3: ff11000100bb16c0 (&xfs_nondir_ilock_class){++++}-{4:4}, at: xfs_reflink_end_atomic_cow+0x2f3/0x560 [xfs]
> [144871.389139][  T172] locks held by kworker/16:4/3872929: 4, on CPU#16:
> [144871.389779][  T172]  #0: ff1100015b4ee940 ((wq_completion)dio/sdg){+.+.}-{0:0}, at: process_one_work+0x1111/0x1760
> [144871.390582][  T172]  #1: ff110003cb7efd10 ((work_completion)(&dio->aio.work)){+.+.}-{0:0}, at: process_one_work+0x8c3/0x1760
> [144871.391402][  T172]  #2: ff110002d3ad4650 (sb_internal#2){++++}-{0:0}, at: xfs_trans_alloc+0x7b/0x820 [xfs]
> [144871.392568][  T172]  #3: ff11000100bb16c0 (&xfs_nondir_ilock_class){++++}-{4:4}, at: xfs_reflink_end_atomic_cow+0x2f3/0x560 [xfs]
> [144871.394019][  T172] locks held by kworker/19:2/3872930: 4, on CPU#19:
> [144871.394685][  T172]  #0: ff1100015b4ee940 ((wq_completion)dio/sdg){+.+.}-{0:0}, at: process_one_work+0x1111/0x1760
> [144871.395449][  T172]  #1: ff1100021374fd10 ((work_completion)(&dio->aio.work)){+.+.}-{0:0}, at: process_one_work+0x8c3/0x1760
> [144871.396394][  T172]  #2: ff110002d3ad4650 (sb_internal#2){++++}-{0:0}, at: xfs_trans_alloc+0x7b/0x820 [xfs]
> [144871.397664][  T172]  #3: ff11000100bb16c0 (&xfs_nondir_ilock_class){++++}-{4:4}, at: xfs_reflink_end_atomic_cow+0x2f3/0x560 [xfs]
> [144871.399332][  T172] locks held by kworker/18:3/3872935: 3, on CPU#18:
> [144871.400131][  T172]  #0: ff1100015b4ee940 ((wq_completion)dio/sdg){+.+.}-{0:0}, at: process_one_work+0x1111/0x1760
> [144871.401110][  T172]  #1: ff110002862b7d10 ((work_completion)(&dio->aio.work)){+.+.}-{0:0}, at: process_one_work+0x8c3/0x1760
> [144871.402243][  T172]  #2: ff110002d3ad4650 (sb_internal#2){++++}-{0:0}, at: xfs_trans_alloc+0x7b/0x820 [xfs]
> [144871.403502][  T172] locks held by kworker/10:2/3872936: 4, on CPU#10:
> [144871.404186][  T172]  #0: ff1100015b4ee940 ((wq_completion)dio/sdg){+.+.}-{0:0}, at: process_one_work+0x1111/0x1760
> [144871.405139][  T172]  #1: ff110003d8e8fd10 ((work_completion)(&dio->aio.work)){+.+.}-{0:0}, at: process_one_work+0x8c3/0x1760
> [144871.406011][  T172]  #2: ff110002d3ad4650 (sb_internal#2){++++}-{0:0}, at: xfs_trans_alloc+0x7b/0x820 [xfs]
> [144871.407341][  T172]  #3: ff11000100bb16c0 (&xfs_nondir_ilock_class){++++}-{4:4}, at: xfs_reflink_end_atomic_cow+0x2f3/0x560 [xfs]
> [144871.408729][  T172] locks held by kworker/8:3/3872941: 3, on CPU#8:
> [144871.409141][  T172]  #0: ff1100015b4ee940 ((wq_completion)dio/sdg){+.+.}-{0:0}, at: process_one_work+0x1111/0x1760
> [144871.410067][  T172]  #1: ff110003df1e7d10 ((work_completion)(&dio->aio.work)){+.+.}-{0:0}, at: process_one_work+0x8c3/0x1760
> [144871.410799][  T172]  #2: ff110002d3ad4650 (sb_internal#2){++++}-{0:0}, at: xfs_trans_alloc+0x7b/0x820 [xfs]
> [144871.411989][  T172] locks held by kworker/1:3/3872953: 4, on CPU#1:
> [144871.412584][  T172]  #0: ff1100015b4ee940 ((wq_completion)dio/sdg){+.+.}-{0:0}, at: process_one_work+0x1111/0x1760
> [144871.413531][  T172]  #1: ff1100043f1bfd10 ((work_completion)(&dio->aio.work)){+.+.}-{0:0}, at: process_one_work+0x8c3/0x1760
> [144871.414464][  T172]  #2: ff110002d3ad4650 (sb_internal#2){++++}-{0:0}, at: xfs_trans_alloc+0x7b/0x820 [xfs]
> [144871.424444][  T172]  #3: ff11000100bb16c0 (&xfs_nondir_ilock_class){++++}-{4:4}, at: xfs_reflink_end_atomic_cow+0x2f3/0x560 [xfs]
> [144871.425808][  T172] locks held by kworker/4:4/3872955: 4, on CPU#4:
> [144871.426603][  T172]  #0: ff1100015b4ee940 ((wq_completion)dio/sdg){+.+.}-{0:0}, at: process_one_work+0x1111/0x1760
> [144871.427468][  T172]  #1: ff1100014de77d10 ((work_completion)(&dio->aio.work)){+.+.}-{0:0}, at: process_one_work+0x8c3/0x1760
> [144871.428336][  T172]  #2: ff110002d3ad4650 (sb_internal#2){++++}-{0:0}, at: xfs_trans_alloc+0x7b/0x820 [xfs]
> [144871.429615][  T172]  #3: ff11000100bb16c0 (&xfs_nondir_ilock_class){++++}-{4:4}, at: xfs_reflink_end_atomic_cow+0x2f3/0x560 [xfs]
> [144871.430975][  T172] locks held by fio/3872961: 3, on CPU#2:
> [144871.431620][  T172]  #0: ff11000100bb18d0 (&sb->s_type->i_mutex_key#28){++++}-{4:4}, at: xfs_ilock+0x181/0x310 [xfs]
> [144871.433089][  T172]  #1: ff110002d3ad4650 (sb_internal#2){++++}-{0:0}, at: xfs_trans_alloc+0x7b/0x820 [xfs]
> [144871.434279][  T172]  #2: ff11000100bb16c0 (&xfs_nondir_ilock_class){++++}-{4:4}, at: xfs_trans_alloc_inode+0x17b/0x340 [xfs]
> [144871.435797][  T172] locks held by fio/3872962: 3, on CPU#23:
> [144871.436291][  T172]  #0: ff11000100bb18d0 (&sb->s_type->i_mutex_key#28){++++}-{4:4}, at: xfs_ilock+0x181/0x310 [xfs]
> [144871.437618][  T172]  #1: ff110002d3ad4650 (sb_internal#2){++++}-{0:0}, at: xfs_trans_alloc+0x7b/0x820 [xfs]
> [144871.438845][  T172]  #2: ff11000100bb16c0 (&xfs_nondir_ilock_class){++++}-{4:4}, at: xfs_trans_alloc_inode+0x17b/0x340 [xfs]
> [144871.440124][  T172] locks held by fio/3872963: 3, on CPU#23:
> [144871.440772][  T172]  #0: ff11000100bb18d0 (&sb->s_type->i_mutex_key#28){++++}-{4:4}, at: xfs_ilock+0x181/0x310 [xfs]
> [144871.442297][  T172]  #1: ff110002d3ad4650 (sb_internal#2){++++}-{0:0}, at: xfs_trans_alloc+0x7b/0x820 [xfs]
> [144871.443694][  T172]  #2: ff11000100bb16c0 (&xfs_nondir_ilock_class){++++}-{4:4}, at: xfs_trans_alloc_inode+0x17b/0x340 [xfs]
> [144871.445025][  T172] locks held by fio/3872964: 3, on CPU#14:
> [144871.445514][  T172]  #0: ff11000100bb18d0 (&sb->s_type->i_mutex_key#28){++++}-{4:4}, at: xfs_ilock+0x181/0x310 [xfs]
> [144871.446890][  T172]  #1: ff110002d3ad4650 (sb_internal#2){++++}-{0:0}, at: xfs_trans_alloc+0x7b/0x820 [xfs]
> [144871.448097][  T172]  #2: ff11000100bb16c0 (&xfs_nondir_ilock_class){++++}-{4:4}, at: xfs_trans_alloc_inode+0x17b/0x340 [xfs]
> [144871.449466][  T172] locks held by fio/3872965: 3, on CPU#12:
> [144871.450120][  T172]  #0: ff11000100bb18d0 (&sb->s_type->i_mutex_key#28){++++}-{4:4}, at: xfs_ilock+0x181/0x310 [xfs]
> [144871.451359][  T172]  #1: ff110002d3ad4650 (sb_internal#2){++++}-{0:0}, at: xfs_trans_alloc+0x7b/0x820 [xfs]
> [144871.452681][  T172]  #2: ff11000100bb16c0 (&xfs_nondir_ilock_class){++++}-{4:4}, at: xfs_vn_update_time+0x27f/0x490 [xfs]
> [144871.454164][  T172] locks held by fio/3872966: 3, on CPU#16:
> [144871.454720][  T172]  #0: ff11000100bb18d0 (&sb->s_type->i_mutex_key#28){++++}-{4:4}, at: xfs_ilock+0x181/0x310 [xfs]
> [144871.455979][  T172]  #1: ff110002d3ad4650 (sb_internal#2){++++}-{0:0}, at: xfs_trans_alloc+0x7b/0x820 [xfs]
> [144871.457331][  T172]  #2: ff11000100bb16c0 (&xfs_nondir_ilock_class){++++}-{4:4}, at: xfs_vn_update_time+0x27f/0x490 [xfs]
> [144871.458737][  T172] locks held by fio/3872967: 3, on CPU#4:
> [144871.459369][  T172]  #0: ff11000100bb18d0 (&sb->s_type->i_mutex_key#28){++++}-{4:4}, at: xfs_ilock+0x181/0x310 [xfs]
> [144871.460809][  T172]  #1: ff110002d3ad4650 (sb_internal#2){++++}-{0:0}, at: xfs_trans_alloc+0x7b/0x820 [xfs]
> [144871.461990][  T172]  #2: ff11000100bb16c0 (&xfs_nondir_ilock_class){++++}-{4:4}, at: xfs_trans_alloc_inode+0x17b/0x340 [xfs]
> [144871.463126][  T172] locks held by fio/3872968: 3, on CPU#1:
> [144871.463662][  T172]  #0: ff11000100bb18d0 (&sb->s_type->i_mutex_key#28){++++}-{4:4}, at: xfs_ilock+0x181/0x310 [xfs]
> [144871.464985][  T172]  #1: ff110002d3ad4650 (sb_internal#2){++++}-{0:0}, at: xfs_trans_alloc+0x7b/0x820 [xfs]
> [144871.466188][  T172]  #2: ff11000100bb16c0 (&xfs_nondir_ilock_class){++++}-{4:4}, at: xfs_vn_update_time+0x27f/0x490 [xfs]
> [144871.467438][  T172] locks held by fio/3872969: 3, on CPU#6:
> [144871.468111][  T172]  #0: ff11000100bb18d0 (&sb->s_type->i_mutex_key#28){++++}-{4:4}, at: xfs_ilock+0x181/0x310 [xfs]
> [144871.469612][  T172]  #1: ff110002d3ad4650 (sb_internal#2){++++}-{0:0}, at: xfs_trans_alloc+0x7b/0x820 [xfs]
> [144871.471012][  T172]  #2: ff11000100bb16c0 (&xfs_nondir_ilock_class){++++}-{4:4}, at: xfs_vn_update_time+0x27f/0x490 [xfs]
> [144871.472352][  T172] locks held by fio/3872970: 3, on CPU#4:
> [144871.473018][  T172]  #0: ff11000100bb18d0 (&sb->s_type->i_mutex_key#28){++++}-{4:4}, at: xfs_ilock+0x181/0x310 [xfs]
> [144871.474395][  T172]  #1: ff110002d3ad4650 (sb_internal#2){++++}-{0:0}, at: xfs_trans_alloc+0x7b/0x820 [xfs]
> [144871.475759][  T172]  #2: ff11000100bb16c0 (&xfs_nondir_ilock_class){++++}-{4:4}, at: xfs_vn_update_time+0x27f/0x490 [xfs]
> [144871.477331][  T172] locks held by fio/3872971: 3, on CPU#14:
> [144871.477764][  T172]  #0: ff11000100bb18d0 (&sb->s_type->i_mutex_key#28){++++}-{4:4}, at: xfs_ilock+0x181/0x310 [xfs]
> [144871.479087][  T172]  #1: ff110002d3ad4650 (sb_internal#2){++++}-{0:0}, at: xfs_trans_alloc+0x7b/0x820 [xfs]
> [144871.480334][  T172]  #2: ff11000100bb16c0 (&xfs_nondir_ilock_class){++++}-{4:4}, at: xfs_vn_update_time+0x27f/0x490 [xfs]
> [144871.481548][  T172] locks held by fio/3872972: 2, on CPU#10:
> [144871.482113][  T172]  #0: ff11000100bb18d0 (&sb->s_type->i_mutex_key#28){++++}-{4:4}, at: xfs_ilock+0x181/0x310 [xfs]
> [144871.483336][  T172]  #1: ff11000100bb16c0 (&xfs_nondir_ilock_class){++++}-{4:4}, at: xfs_atomic_write_cow_iomap_begin.isra.0+0x31d/0xb60 [xfs]
> [144871.484625][  T172] locks held by fio/3872973: 3, on CPU#10:
> [144871.485350][  T172]  #0: ff11000100bb18d0 (&sb->s_type->i_mutex_key#28){++++}-{4:4}, at: xfs_ilock+0x181/0x310 [xfs]
> [144871.486616][  T172]  #1: ff110002d3ad4650 (sb_internal#2){++++}-{0:0}, at: xfs_trans_alloc+0x7b/0x820 [xfs]
> [144871.487949][  T172]  #2: ff11000100bb16c0 (&xfs_nondir_ilock_class){++++}-{4:4}, at: xfs_vn_update_time+0x27f/0x490 [xfs]
> [144871.489152][  T172] locks held by fio/3872974: 2, on CPU#18:
> [144871.489572][  T172]  #0: ff11000100bb18d0 (&sb->s_type->i_mutex_key#28){++++}-{4:4}, at: xfs_ilock+0x181/0x310 [xfs]
> [144871.491050][  T172]  #1: ff11000100bb16c0 (&xfs_nondir_ilock_class){++++}-{4:4}, at: xfs_atomic_write_cow_iomap_begin.isra.0+0x31d/0xb60 [xfs]
> [144871.492416][  T172] locks held by fio/3872975: 3, on CPU#8:
> [144871.493166][  T172]  #0: ff11000100bb18d0 (&sb->s_type->i_mutex_key#28){++++}-{4:4}, at: xfs_ilock+0x181/0x310 [xfs]
> [144871.494401][  T172]  #1: ff110002d3ad4650 (sb_internal#2){++++}-{0:0}, at: xfs_trans_alloc+0x7b/0x820 [xfs]
> [144871.495553][  T172]  #2: ff11000100bb16c0 (&xfs_nondir_ilock_class){++++}-{4:4}, at: xfs_vn_update_time+0x27f/0x490 [xfs]
> [144871.496938][  T172] locks held by fio/3872976: 3, on CPU#23:
> [144871.497422][  T172]  #0: ff11000100bb18d0 (&sb->s_type->i_mutex_key#28){++++}-{4:4}, at: xfs_ilock+0x181/0x310 [xfs]
> [144871.498613][  T172]  #1: ff110002d3ad4650 (sb_internal#2){++++}-{0:0}, at: xfs_trans_alloc+0x7b/0x820 [xfs]
> [144871.499903][  T172]  #2: ff11000100bb16c0 (&xfs_nondir_ilock_class){++++}-{4:4}, at: xfs_trans_alloc_inode+0x17b/0x340 [xfs]
> [144871.501249][  T172] locks held by fio/3872977: 3, on CPU#1:
> [144871.501945][  T172]  #0: ff11000100bb18d0 (&sb->s_type->i_mutex_key#28){++++}-{4:4}, at: xfs_ilock+0x181/0x310 [xfs]
> [144871.503238][  T172]  #1: ff110002d3ad4650 (sb_internal#2){++++}-{0:0}, at: xfs_trans_alloc+0x7b/0x820 [xfs]
> [144871.504494][  T172]  #2: ff11000100bb16c0 (&xfs_nondir_ilock_class){++++}-{4:4}, at: xfs_vn_update_time+0x27f/0x490 [xfs]
> [144871.505963][  T172] locks held by fio/3872978: 3, on CPU#12:
> [144871.506558][  T172]  #0: ff11000100bb18d0 (&sb->s_type->i_mutex_key#28){++++}-{4:4}, at: xfs_ilock+0x181/0x310 [xfs]
> [144871.508041][  T172]  #1: ff110002d3ad4650 (sb_internal#2){++++}-{0:0}, at: xfs_trans_alloc+0x7b/0x820 [xfs]
> [144871.509561][  T172]  #2: ff11000100bb16c0 (&xfs_nondir_ilock_class){++++}-{4:4}, at: xfs_vn_update_time+0x27f/0x490 [xfs]
> [144871.510975][  T172] locks held by fio/3872979: 3, on CPU#4:
> [144871.511616][  T172]  #0: ff11000100bb18d0 (&sb->s_type->i_mutex_key#28){++++}-{4:4}, at: xfs_ilock+0x181/0x310 [xfs]
> [144871.512986][  T172]  #1: ff110002d3ad4650 (sb_internal#2){++++}-{0:0}, at: xfs_trans_alloc+0x7b/0x820 [xfs]
> [144871.514342][  T172]  #2: ff11000100bb16c0 (&xfs_nondir_ilock_class){++++}-{4:4}, at: xfs_vn_update_time+0x27f/0x490 [xfs]
> [144871.515561][  T172] locks held by fio/3872980: 2, on CPU#2:
> [144871.516337][  T172]  #0: ff11000100bb18d0 (&sb->s_type->i_mutex_key#28){++++}-{4:4}, at: xfs_ilock+0x181/0x310 [xfs]
> [144871.517588][  T172]  #1: ff11000100bb16c0 (&xfs_nondir_ilock_class){++++}-{4:4}, at: xfs_atomic_write_cow_iomap_begin.isra.0+0x31d/0xb60 [xfs]
> [144871.518941][  T172] locks held by fio/3872981: 3, on CPU#5:
> [144871.519544][  T172]  #0: ff11000100bb18d0 (&sb->s_type->i_mutex_key#28){++++}-{4:4}, at: xfs_ilock+0x181/0x310 [xfs]
> [144871.520980][  T172]  #1: ff110002d3ad4650 (sb_internal#2){++++}-{0:0}, at: xfs_trans_alloc+0x7b/0x820 [xfs]
> [144871.522436][  T172]  #2: ff11000100bb16c0 (&xfs_nondir_ilock_class){++++}-{4:4}, at: xfs_trans_alloc_inode+0x17b/0x340 [xfs]
> [144871.523761][  T172] locks held by fio/3872982: 3, on CPU#7:
> [144871.524345][  T172]  #0: ff11000100bb18d0 (&sb->s_type->i_mutex_key#28){++++}-{4:4}, at: xfs_ilock+0x181/0x310 [xfs]
> [144871.525617][  T172]  #1: ff110002d3ad4650 (sb_internal#2){++++}-{0:0}, at: xfs_trans_alloc+0x7b/0x820 [xfs]
> [144871.526995][  T172]  #2: ff11000100bb16c0 (&xfs_nondir_ilock_class){++++}-{4:4}, at: xfs_vn_update_time+0x27f/0x490 [xfs]
> [144871.528345][  T172] locks held by fio/3872983: 2, on CPU#18:
> [144871.529013][  T172]  #0: ff11000100bb18d0 (&sb->s_type->i_mutex_key#28){++++}-{4:4}, at: xfs_ilock+0x181/0x310 [xfs]
> [144871.530159][  T172]  #1: ff11000100bb16c0 (&xfs_nondir_ilock_class){++++}-{4:4}, at: xfs_atomic_write_cow_iomap_begin.isra.0+0x31d/0xb60 [xfs]
> [144871.531658][  T172] locks held by fio/3872984: 3, on CPU#21:
> [144871.532344][  T172]  #0: ff11000100bb18d0 (&sb->s_type->i_mutex_key#28){++++}-{4:4}, at: xfs_ilock+0x181/0x310 [xfs]
> [144871.533662][  T172]  #1: ff110002d3ad4650 (sb_internal#2){++++}-{0:0}, at: xfs_trans_alloc+0x7b/0x820 [xfs]
> [144871.535127][  T172]  #2: ff11000100bb16c0 (&xfs_nondir_ilock_class){++++}-{4:4}, at: xfs_vn_update_time+0x27f/0x490 [xfs]
> [144871.536354][  T172] locks held by fio/3872985: 3, on CPU#14:
> [144871.536893][  T172]  #0: ff11000100bb18d0 (&sb->s_type->i_mutex_key#28){++++}-{4:4}, at: xfs_ilock+0x181/0x310 [xfs]
> [144871.538193][  T172]  #1: ff110002d3ad4650 (sb_internal#2){++++}-{0:0}, at: xfs_trans_alloc+0x7b/0x820 [xfs]
> [144871.539344][  T172]  #2: ff11000100bb16c0 (&xfs_nondir_ilock_class){++++}-{4:4}, at: xfs_vn_update_time+0x27f/0x490 [xfs]
> [144871.540565][  T172] locks held by fio/3872986: 3, on CPU#23:
> [144871.549064][  T172]  #0: ff11000100bb18d0 (&sb->s_type->i_mutex_key#28){++++}-{4:4}, at: xfs_ilock+0x181/0x310 [xfs]
> [144871.550342][  T172]  #1: ff110002d3ad4650 (sb_internal#2){++++}-{0:0}, at: xfs_trans_alloc+0x7b/0x820 [xfs]
> [144871.551412][  T172]  #2: ff11000100bb16c0 (&xfs_nondir_ilock_class){++++}-{4:4}, at: xfs_vn_update_time+0x27f/0x490 [xfs]
> [144871.552644][  T172] locks held by fio/3872987: 3, on CPU#9:
> [144871.553252][  T172]  #0: ff11000100bb18d0 (&sb->s_type->i_mutex_key#28){++++}-{4:4}, at: xfs_ilock+0x181/0x310 [xfs]
> [144871.554617][  T172]  #1: ff110002d3ad4650 (sb_internal#2){++++}-{0:0}, at: xfs_trans_alloc+0x7b/0x820 [xfs]
> [144871.555963][  T172]  #2: ff11000100bb16c0 (&xfs_nondir_ilock_class){++++}-{4:4}, at: xfs_vn_update_time+0x27f/0x490 [xfs]
> [144871.557289][  T172] locks held by fio/3872988: 2, on CPU#9:
> [144871.557983][  T172]  #0: ff11000100bb18d0 (&sb->s_type->i_mutex_key#28){++++}-{4:4}, at: xfs_ilock+0x181/0x310 [xfs]
> [144871.559251][  T172]  #1: ff11000100bb16c0 (&xfs_nondir_ilock_class){++++}-{4:4}, at: xfs_atomic_write_cow_iomap_begin.isra.0+0x31d/0xb60 [xfs]
> [144871.560650][  T172] locks held by fio/3872989: 3, on CPU#13:
> [144871.561148][  T172]  #0: ff11000100bb18d0 (&sb->s_type->i_mutex_key#28){++++}-{4:4}, at: xfs_ilock+0x181/0x310 [xfs]
> [144871.562620][  T172]  #1: ff110002d3ad4650 (sb_internal#2){++++}-{0:0}, at: xfs_trans_alloc+0x7b/0x820 [xfs]
> [144871.563966][  T172]  #2: ff11000100bb16c0 (&xfs_nondir_ilock_class){++++}-{4:4}, at: xfs_vn_update_time+0x27f/0x490 [xfs]
> [144871.565353][  T172] locks held by fio/3872990: 3, on CPU#22:
> [144871.566014][  T172]  #0: ff11000100bb18d0 (&sb->s_type->i_mutex_key#28){++++}-{4:4}, at: xfs_ilock+0x181/0x310 [xfs]
> [144871.567292][  T172]  #1: ff110002d3ad4650 (sb_internal#2){++++}-{0:0}, at: xfs_trans_alloc+0x7b/0x820 [xfs]
> [144871.568639][  T172]  #2: ff11000100bb16c0 (&xfs_nondir_ilock_class){++++}-{4:4}, at: xfs_vn_update_time+0x27f/0x490 [xfs]
> [144871.569912][  T172] locks held by fio/3872991: 3, on CPU#15:
> [144871.570643][  T172]  #0: ff11000100bb18d0 (&sb->s_type->i_mutex_key#28){++++}-{4:4}, at: xfs_ilock+0x181/0x310 [xfs]
> [144871.572074][  T172]  #1: ff110002d3ad4650 (sb_internal#2){++++}-{0:0}, at: xfs_trans_alloc+0x7b/0x820 [xfs]
> [144871.573526][  T172]  #2: ff11000100bb16c0 (&xfs_nondir_ilock_class){++++}-{4:4}, at: xfs_vn_update_time+0x27f/0x490 [xfs]
> [144871.574865][  T172] locks held by fio/3872992: 3, on CPU#19:
> [144871.575385][  T172]  #0: ff11000100bb18d0 (&sb->s_type->i_mutex_key#28){++++}-{4:4}, at: xfs_ilock+0x181/0x310 [xfs]
> [144871.576702][  T172]  #1: ff110002d3ad4650 (sb_internal#2){++++}-{0:0}, at: xfs_trans_alloc+0x7b/0x820 [xfs]
> [144871.577974][  T172]  #2: ff11000100bb16c0 (&xfs_nondir_ilock_class){++++}-{4:4}, at: xfs_vn_update_time+0x27f/0x490 [xfs]
> [144871.579176][  T172] locks held by fio/3872993: 2, on CPU#8:
> [144871.579776][  T172]  #0: ff11000100bb18d0 (&sb->s_type->i_mutex_key#28){++++}-{4:4}, at: xfs_ilock+0x181/0x310 [xfs]
> [144871.581296][  T172]  #1: ff11000100bb16c0 (&xfs_nondir_ilock_class){++++}-{4:4}, at: xfs_atomic_write_cow_iomap_begin.isra.0+0x31d/0xb60 [xfs]
> [144871.582823][  T172] locks held by fio/3872994: 2, on CPU#10:
> [144871.583327][  T172]  #0: ff11000100bb18d0 (&sb->s_type->i_mutex_key#28){++++}-{4:4}, at: xfs_ilock+0x181/0x310 [xfs]
> [144871.584824][  T172]  #1: ff11000100bb16c0 (&xfs_nondir_ilock_class){++++}-{4:4}, at: xfs_atomic_write_cow_iomap_begin.isra.0+0x31d/0xb60 [xfs]
> [144871.586338][  T172] locks held by fio/3872995: 2, on CPU#0:
> [144871.586746][  T172]  #0: ff11000100bb18d0 (&sb->s_type->i_mutex_key#28){++++}-{4:4}, at: xfs_ilock+0x181/0x310 [xfs]
> [144871.588065][  T172]  #1: ff11000100bb16c0 (&xfs_nondir_ilock_class){++++}-{4:4}, at: xfs_atomic_write_cow_iomap_begin.isra.0+0x31d/0xb60 [xfs]
> [144871.589592][  T172] locks held by fio/3872996: 3, on CPU#3:
> [144871.590228][  T172]  #0: ff11000100bb18d0 (&sb->s_type->i_mutex_key#28){++++}-{4:4}, at: xfs_ilock+0x181/0x310 [xfs]
> [144871.591624][  T172]  #1: ff110002d3ad4650 (sb_internal#2){++++}-{0:0}, at: xfs_trans_alloc+0x7b/0x820 [xfs]
> [144871.592955][  T172]  #2: ff11000100bb16c0 (&xfs_nondir_ilock_class){++++}-{4:4}, at: xfs_vn_update_time+0x27f/0x490 [xfs]
> [144871.594411][  T172] locks held by fio/3872997: 2, on CPU#9:
> [144871.594880][  T172]  #0: ff11000100bb18d0 (&sb->s_type->i_mutex_key#28){++++}-{4:4}, at: xfs_ilock+0x181/0x310 [xfs]
> [144871.596102][  T172]  #1: ff11000100bb16c0 (&xfs_nondir_ilock_class){++++}-{4:4}, at: xfs_atomic_write_cow_iomap_begin.isra.0+0x31d/0xb60 [xfs]
> [144871.597443][  T172] locks held by fio/3872998: 3, on CPU#11:
> [144871.598214][  T172]  #0: ff11000100bb18d0 (&sb->s_type->i_mutex_key#28){++++}-{4:4}, at: xfs_ilock+0x181/0x310 [xfs]
> [144871.599581][  T172]  #1: ff110002d3ad4650 (sb_internal#2){++++}-{0:0}, at: xfs_trans_alloc+0x7b/0x820 [xfs]
> [144871.600877][  T172]  #2: ff11000100bb16c0 (&xfs_nondir_ilock_class){++++}-{4:4}, at: xfs_vn_update_time+0x27f/0x490 [xfs]
> [144871.602277][  T172] locks held by fio/3872999: 2, on CPU#15:
> [144871.602933][  T172]  #0: ff11000100bb18d0 (&sb->s_type->i_mutex_key#28){++++}-{4:4}, at: xfs_ilock+0x181/0x310 [xfs]
> [144871.604171][  T172]  #1: ff11000100bb16c0 (&xfs_nondir_ilock_class){++++}-{4:4}, at: xfs_atomic_write_cow_iomap_begin.isra.0+0x31d/0xb60 [xfs]
> [144871.605502][  T172] locks held by fio/3873000: 2, on CPU#13:
> [144871.606086][  T172]  #0: ff11000100bb18d0 (&sb->s_type->i_mutex_key#28){++++}-{4:4}, at: xfs_ilock+0x181/0x310 [xfs]
> [144871.607446][  T172]  #1: ff11000100bb16c0 (&xfs_nondir_ilock_class){++++}-{4:4}, at: xfs_atomic_write_cow_iomap_begin.isra.0+0x31d/0xb60 [xfs]
> [144871.608891][  T172] locks held by fio/3873001: 2, on CPU#20:
> [144871.609629][  T172]  #0: ff11000100bb18d0 (&sb->s_type->i_mutex_key#28){++++}-{4:4}, at: xfs_ilock+0x181/0x310 [xfs]
> [144871.610941][  T172]  #1: ff11000100bb16c0 (&xfs_nondir_ilock_class){++++}-{4:4}, at: xfs_atomic_write_cow_iomap_begin.isra.0+0x31d/0xb60 [xfs]
> [144871.612536][  T172] locks held by fio/3873002: 2, on CPU#21:
> [144871.613261][  T172]  #0: ff11000100bb18d0 (&sb->s_type->i_mutex_key#28){++++}-{4:4}, at: xfs_ilock+0x181/0x310 [xfs]
> [144871.614548][  T172]  #1: ff11000100bb16c0 (&xfs_nondir_ilock_class){++++}-{4:4}, at: xfs_atomic_write_cow_iomap_begin.isra.0+0x31d/0xb60 [xfs]
> [144871.615849][  T172] locks held by fio/3873003: 2, on CPU#7:
> [144871.616466][  T172]  #0: ff11000100bb18d0 (&sb->s_type->i_mutex_key#28){++++}-{4:4}, at: xfs_ilock+0x181/0x310 [xfs]
> [144871.617936][  T172]  #1: ff11000100bb16c0 (&xfs_nondir_ilock_class){++++}-{4:4}, at: xfs_atomic_write_cow_iomap_begin.isra.0+0x31d/0xb60 [xfs]
> [144871.619512][  T172] locks held by fio/3873004: 3, on CPU#12:
> [144871.620084][  T172]  #0: ff11000100bb18d0 (&sb->s_type->i_mutex_key#28){++++}-{4:4}, at: xfs_ilock+0x181/0x310 [xfs]
> [144871.621559][  T172]  #1: ff110002d3ad4650 (sb_internal#2){++++}-{0:0}, at: xfs_trans_alloc+0x7b/0x820 [xfs]
> [144871.623035][  T172]  #2: ff11000100bb16c0 (&xfs_nondir_ilock_class){++++}-{4:4}, at: xfs_vn_update_time+0x27f/0x490 [xfs]
> [144871.624371][  T172] locks held by fio/3873005: 3, on CPU#2:
> [144871.624968][  T172]  #0: ff11000100bb18d0 (&sb->s_type->i_mutex_key#28){++++}-{4:4}, at: xfs_ilock+0x181/0x310 [xfs]
> [144871.626326][  T172]  #1: ff110002d3ad4650 (sb_internal#2){++++}-{0:0}, at: xfs_trans_alloc+0x7b/0x820 [xfs]
> [144871.627504][  T172]  #2: ff11000100bb16c0 (&xfs_nondir_ilock_class){++++}-{4:4}, at: xfs_vn_update_time+0x27f/0x490 [xfs]
> [144871.628825][  T172] locks held by fio/3873006: 2, on CPU#5:
> [144871.629555][  T172]  #0: ff11000100bb18d0 (&sb->s_type->i_mutex_key#28){++++}-{4:4}, at: xfs_ilock+0x181/0x310 [xfs]
> [144871.630924][  T172]  #1: ff11000100bb16c0 (&xfs_nondir_ilock_class){++++}-{4:4}, at: xfs_atomic_write_cow_iomap_begin.isra.0+0x31d/0xb60 [xfs]
> [144871.632295][  T172] locks held by fio/3873007: 3, on CPU#22:
> [144871.632986][  T172]  #0: ff11000100bb18d0 (&sb->s_type->i_mutex_key#28){++++}-{4:4}, at: xfs_ilock+0x181/0x310 [xfs]
> [144871.634247][  T172]  #1: ff110002d3ad4650 (sb_internal#2){++++}-{0:0}, at: xfs_trans_alloc+0x7b/0x820 [xfs]
> [144871.635569][  T172]  #2: ff11000100bb16c0 (&xfs_nondir_ilock_class){++++}-{4:4}, at: xfs_vn_update_time+0x27f/0x490 [xfs]
> [144871.636907][  T172] locks held by fio/3873008: 3, on CPU#16:
> [144871.637391][  T172]  #0: ff11000100bb18d0 (&sb->s_type->i_mutex_key#28){++++}-{4:4}, at: xfs_ilock+0x181/0x310 [xfs]
> [144871.638706][  T172]  #1: ff110002d3ad4650 (sb_internal#2){++++}-{0:0}, at: xfs_trans_alloc+0x7b/0x820 [xfs]
> [144871.639974][  T172]  #2: ff11000100bb16c0 (&xfs_nondir_ilock_class){++++}-{4:4}, at: xfs_trans_alloc_inode+0x17b/0x340 [xfs]
> [144871.641349][  T172] locks held by kworker/22:9/3873014: 4, on CPU#22:
> [144871.641954][  T172]  #0: ff1100015b4ee940 ((wq_completion)dio/sdg){+.+.}-{0:0}, at: process_one_work+0x1111/0x1760
> [144871.643046][  T172]  #1: ff1100075a3b7d10 ((work_completion)(&dio->aio.work)){+.+.}-{0:0}, at: process_one_work+0x8c3/0x1760
> [144871.643896][  T172]  #2: ff110002d3ad4650 (sb_internal#2){++++}-{0:0}, at: xfs_trans_alloc+0x7b/0x820 [xfs]
> [144871.645235][  T172]  #3: ff11000100bb16c0 (&xfs_nondir_ilock_class){++++}-{4:4}, at: xfs_reflink_end_atomic_cow+0x2f3/0x560 [xfs]
> [144871.646870][  T172] locks held by kworker/10:3/3873017: 4, on CPU#10:
> [144871.647514][  T172]  #0: ff1100015b4ee940 ((wq_completion)dio/sdg){+.+.}-{0:0}, at: process_one_work+0x1111/0x1760
> [144871.648341][  T172]  #1: ff110002411cfd10 ((work_completion)(&dio->aio.work)){+.+.}-{0:0}, at: process_one_work+0x8c3/0x1760
> [144871.649336][  T172]  #2: ff110002d3ad4650 (sb_internal#2){++++}-{0:0}, at: xfs_trans_alloc+0x7b/0x820 [xfs]
> [144871.650672][  T172]  #3: ff11000100bb16c0 (&xfs_nondir_ilock_class){++++}-{4:4}, at: xfs_reflink_end_atomic_cow+0x2f3/0x560 [xfs]
> [144871.652162][  T172] locks held by kworker/16:5/3873018: 4, on CPU#16:
> [144871.652872][  T172]  #0: ff1100015b4ee940 ((wq_completion)dio/sdg){+.+.}-{0:0}, at: process_one_work+0x1111/0x1760
> [144871.653694][  T172]  #1: ff1100019cfd7d10 ((work_completion)(&dio->aio.work)){+.+.}-{0:0}, at: process_one_work+0x8c3/0x1760
> [144871.654690][  T172]  #2: ff110002d3ad4650 (sb_internal#2){++++}-{0:0}, at: xfs_trans_alloc+0x7b/0x820 [xfs]
> [144871.656010][  T172]  #3: ff11000100bb16c0 (&xfs_nondir_ilock_class){++++}-{4:4}, at: xfs_reflink_end_atomic_cow+0x2f3/0x560 [xfs]
> [144871.657334][  T172] locks held by kworker/16:6/3873019: 4, on CPU#16:
> [144871.657807][  T172]  #0: ff1100015b4ee940 ((wq_completion)dio/sdg){+.+.}-{0:0}, at: process_one_work+0x1111/0x1760
> [144871.658834][  T172]  #1: ff110005ec73fd10 ((work_completion)(&dio->aio.work)){+.+.}-{0:0}, at: process_one_work+0x8c3/0x1760
> [144871.659987][  T172]  #2: ff110002d3ad4650 (sb_internal#2){++++}-{0:0}, at: xfs_trans_alloc+0x7b/0x820 [xfs]
> [144871.661147][  T172]  #3: ff11000100bb16c0 (&xfs_nondir_ilock_class){++++}-{4:4}, at: xfs_reflink_end_atomic_cow+0x2f3/0x560 [xfs]
> [144871.662392][  T172] locks held by kworker/16:7/3873020: 4, on CPU#16:
> [144871.662945][  T172]  #0: ff1100015b4ee940 ((wq_completion)dio/sdg){+.+.}-{0:0}, at: process_one_work+0x1111/0x1760
> [144871.663830][  T172]  #1: ff110004e58a7d10 ((work_completion)(&dio->aio.work)){+.+.}-{0:0}, at: process_one_work+0x8c3/0x1760
> [144871.664843][  T172]  #2: ff110002d3ad4650 (sb_internal#2){++++}-{0:0}, at: xfs_trans_alloc+0x7b/0x820 [xfs]
> [144871.674237][  T172]  #3: ff11000100bb16c0 (&xfs_nondir_ilock_class){++++}-{4:4}, at: xfs_reflink_end_atomic_cow+0x2f3/0x560 [xfs]
> [144871.675488][  T172] locks held by kworker/16:8/3873021: 4, on CPU#16:
> [144871.676270][  T172]  #0: ff1100015b4ee940 ((wq_completion)dio/sdg){+.+.}-{0:0}, at: process_one_work+0x1111/0x1760
> [144871.676948][  T172]  #1: ff110001e6617d10 ((work_completion)(&dio->aio.work)){+.+.}-{0:0}, at: process_one_work+0x8c3/0x1760
> [144871.677872][  T172]  #2: ff110002d3ad4650 (sb_internal#2){++++}-{0:0}, at: xfs_trans_alloc+0x7b/0x820 [xfs]
> [144871.679079][  T172]  #3: ff11000100bb16c0 (&xfs_nondir_ilock_class){++++}-{4:4}, at: xfs_reflink_end_atomic_cow+0x2f3/0x560 [xfs]
> [144871.680423][  T172] locks held by kworker/16:9/3873022: 4, on CPU#16:
> [144871.680913][  T172]  #0: ff1100015b4ee940 ((wq_completion)dio/sdg){+.+.}-{0:0}, at: process_one_work+0x1111/0x1760
> [144871.681864][  T172]  #1: ff11000156bbfd10 ((work_completion)(&dio->aio.work)){+.+.}-{0:0}, at: process_one_work+0x8c3/0x1760
> [144871.682805][  T172]  #2: ff110002d3ad4650 (sb_internal#2){++++}-{0:0}, at: xfs_trans_alloc+0x7b/0x820 [xfs]
> [144871.684009][  T172]  #3: ff11000100bb16c0 (&xfs_nondir_ilock_class){++++}-{4:4}, at: xfs_reflink_end_atomic_cow+0x2f3/0x560 [xfs]
> [144871.685395][  T172] locks held by kworker/16:10/3873023: 4, on CPU#16:
> [144871.685974][  T172]  #0: ff1100015b4ee940 ((wq_completion)dio/sdg){+.+.}-{0:0}, at: process_one_work+0x1111/0x1760
> [144871.686863][  T172]  #1: ff1100040bf57d10 ((work_completion)(&dio->aio.work)){+.+.}-{0:0}, at: process_one_work+0x8c3/0x1760
> [144871.687686][  T172]  #2: ff110002d3ad4650 (sb_internal#2){++++}-{0:0}, at: xfs_trans_alloc+0x7b/0x820 [xfs]
> [144871.689001][  T172]  #3: ff11000100bb16c0 (&xfs_nondir_ilock_class){++++}-{4:4}, at: xfs_reflink_end_atomic_cow+0x2f3/0x560 [xfs]
> [144871.690449][  T172] locks held by kworker/17:5/3873025: 4, on CPU#17:
> [144871.691061][  T172]  #0: ff1100015b4ee940 ((wq_completion)dio/sdg){+.+.}-{0:0}, at: process_one_work+0x1111/0x1760
> [144871.691966][  T172]  #1: ff1100013957fd10 ((work_completion)(&dio->aio.work)){+.+.}-{0:0}, at: process_one_work+0x8c3/0x1760
> [144871.692935][  T172]  #2: ff110002d3ad4650 (sb_internal#2){++++}-{0:0}, at: xfs_trans_alloc+0x7b/0x820 [xfs]
> [144871.694197][  T172]  #3: ff11000100bb16c0 (&xfs_nondir_ilock_class){++++}-{4:4}, at: xfs_reflink_end_atomic_cow+0x2f3/0x560 [xfs]
> [144871.695674][  T172] locks held by kworker/12:3/3873030: 4, on CPU#12:
> [144871.696301][  T172]  #0: ff1100015b4ee940 ((wq_completion)dio/sdg){+.+.}-{0:0}, at: process_one_work+0x1111/0x1760
> [144871.697143][  T172]  #1: ff110007b3e6fd10 ((work_completion)(&dio->aio.work)){+.+.}-{0:0}, at: process_one_work+0x8c3/0x1760
> [144871.698099][  T172]  #2: ff110002d3ad4650 (sb_internal#2){++++}-{0:0}, at: xfs_trans_alloc+0x7b/0x820 [xfs]
> [144871.699455][  T172]  #3: ff11000100bb16c0 (&xfs_nondir_ilock_class){++++}-{4:4}, at: xfs_reflink_end_atomic_cow+0x2f3/0x560 [xfs]
> [144871.700840][  T172]
> [144871.701294][  T172] =============================================


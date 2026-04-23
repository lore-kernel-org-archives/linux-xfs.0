Received: from relayaws-01.paragon-software.com (relayaws-01.paragon-software.com [35.157.23.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18A1C377EA1;
	Thu, 23 Apr 2026 15:14:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.157.23.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776957258; cv=none; b=mpHGPcO2+4w0zz5jcK+iH3Gw3bv1x5JdMrnnVV7D6rBkWujhgqyea5ZhxzfR0n1yVFsdGngUUz7r0Aatrsfa9TU4LFITdUD6ma+UJL44+1KLOiLkvK2I42MI7kavMv5UmoVccZFRDyTRAyG4w4gCr0TjePGt9ejmK6nNLrgxq3I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776957258; c=relaxed/simple;
	bh=au8BNLD5HjUZ5sFz0v3n007bPhbpfCg/t3Ct0YUVMjs=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=l1LGl0FmbEkieaXtCbetbxS7EAxsw02M4IXLH5cvM7sKMKyRrK7ypRoqEEcFiKttlhjqRzxJ9gsW6y8P3nyTpPXG0JJ5+ZzCsazhRWTfwNeHfFTmerTUObo1GIkPrOF4mxr6BsamlzHVKjrSds25r2WltTnVDg/oNmX3JtZ1ouo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=paragon-software.com; spf=pass smtp.mailfrom=paragon-software.com; dkim=pass (1024-bit key) header.d=paragon-software.com header.i=@paragon-software.com header.b=Kcki+cbH; arc=none smtp.client-ip=35.157.23.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=paragon-software.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=paragon-software.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=paragon-software.com header.i=@paragon-software.com header.b="Kcki+cbH"
Received: from relayfre-01.paragon-software.com (relayfre-01.paragon-software.com [176.12.100.13])
	by relayaws-01.paragon-software.com (Postfix) with ESMTPS id BD84B1D38;
	Thu, 23 Apr 2026 15:14:18 +0000 (UTC)
Authentication-Results: relayaws-01.paragon-software.com;
	dkim=pass (1024-bit key; unprotected) header.d=paragon-software.com header.i=@paragon-software.com header.b=Kcki+cbH;
	dkim-atps=neutral
Received: from dlg2.mail.paragon-software.com (vdlg-exch-02.paragon-software.com [172.30.1.105])
	by relayfre-01.paragon-software.com (Postfix) with ESMTPS id 8FE9A217E;
	Thu, 23 Apr 2026 15:14:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=paragon-software.com; s=mail; t=1776957249;
	bh=wfliO748I7UZBXmFt0WyX5ZOZ+VU8PgVTlgPqtv59XU=;
	h=Date:Subject:To:CC:References:From:In-Reply-To;
	b=Kcki+cbHXRKYEFVOOg1zNsPem90RuKrOxiI0Rpeno0CeNC68K/TW6PfYewmuhJLkD
	 yVkjReYdjAqdyS6okvnRBXparbQyJXERccPYkz4IA65yK2m2GhmXrce+HErnAyWQdn
	 hYqjvKig0MzfsRO6Y4brtmBQoEGeI+10N6gHhExM=
Received: from [192.168.95.128] (172.30.20.153) by
 vdlg-exch-02.paragon-software.com (172.30.1.105) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.7; Thu, 23 Apr 2026 18:14:08 +0300
Message-ID: <003a8f01-9e6f-4db2-9ed6-7601a5276251@paragon-software.com>
Date: Thu, 23 Apr 2026 17:14:05 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [syzbot] [iomap?] WARNING in iomap_zero_range
To: Brian Foster <bfoster@redhat.com>, syzbot
	<syzbot+9a51b5f7b9b484c57dd1@syzkaller.appspotmail.com>
CC: <brauner@kernel.org>, <djwong@kernel.org>,
	<linux-fsdevel@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-xfs@vger.kernel.org>, <syzkaller-bugs@googlegroups.com>,
	<ntfs3@lists.linux.dev>
References: <69e24438.050a0220.1de265.0026.GAE@google.com>
 <aeeQZ6EiEUB3G1Gb@bfoster>
Content-Language: en-US
From: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
In-Reply-To: <aeeQZ6EiEUB3G1Gb@bfoster>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: vdlg-exch-02.paragon-software.com (172.30.1.105) To
 vdlg-exch-02.paragon-software.com (172.30.1.105)

On 4/21/26 16:57, Brian Foster wrote:

> cc Konstantin, ntfs3 list
>
> On Fri, Apr 17, 2026 at 07:31:20AM -0700, syzbot wrote:
>> Hello,
>>
>> syzbot found the following issue on:
>>
>> HEAD commit:    028ef9c96e96 Linux 7.0
>> git tree:       upstream
>> console output: https://syzkaller.appspot.com/x/log.txt?x=11db9036580000
>> kernel config:  https://syzkaller.appspot.com/x/.config?x=d46eab0cfd31c214
>> dashboard link: https://syzkaller.appspot.com/bug?extid=9a51b5f7b9b484c57dd1
>> compiler:       Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8
>>
>> Unfortunately, I don't have any reproducer for this issue yet.
>>
>> Downloadable assets:
>> disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/d900f083ada3/non_bootable_disk-028ef9c9.raw.xz
>> vmlinux: https://storage.googleapis.com/syzbot-assets/f7fbf6f85efa/vmlinux-028ef9c9.xz
>> kernel image: https://storage.googleapis.com/syzbot-assets/2bc3ef5a9e1b/bzImage-028ef9c9.xz
>>
>> IMPORTANT: if you fix the issue, please add the following tag to the commit:
>> Reported-by: syzbot+9a51b5f7b9b484c57dd1@syzkaller.appspotmail.com
>>
>> loop0: detected capacity change from 0 to 4096
>> ntfs3(loop0): Different NTFS sector size (1024) and media sector size (512).
>> ------------[ cut here ]------------
>> folio_pos(folio) > iter->inode->i_size
>> WARNING: fs/iomap/buffered-io.c:1561 at iomap_zero_iter fs/iomap/buffered-io.c:1561 [inline], CPU#0: syz.0.0/5326
>> WARNING: fs/iomap/buffered-io.c:1561 at iomap_zero_range+0x8cf/0xd00 fs/iomap/buffered-io.c:1669, CPU#0: syz.0.0/5326
> FYI this warning basically means we're attempting to zero a folio that
> starts beyond EOF. It warns because if the folio starts beyond EOF,
> writeback may throw it away instead of submitting I/O, making the
> zeroing ineffective.
>
>> Modules linked in:
>> CPU: 0 UID: 0 PID: 5326 Comm: syz.0.0 Not tainted syzkaller #0 PREEMPT(full)
>> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
>> RIP: 0010:iomap_zero_iter fs/iomap/buffered-io.c:1561 [inline]
>> RIP: 0010:iomap_zero_range+0x8cf/0xd00 fs/iomap/buffered-io.c:1669
>> Code: 5d ff 4d 29 e6 4d 39 f7 4d 0f 42 f7 4c 89 74 24 78 4d 85 f6 0f 84 5a 02 00 00 e8 ec ee 5d ff e9 78 fc ff ff e8 e2 ee 5d ff 90 <0f> 0b 90 e9 41 fd ff ff e8 d4 ee 5d ff 90 0f 0b 90 e9 97 fd ff ff
>> RSP: 0018:ffffc9000e05f8e0 EFLAGS: 00010287
>> RAX: ffffffff8267f47e RBX: ffffea00015643c0 RCX: 0000000000100000
>> RDX: ffffc9000eb52000 RSI: 000000000000021a RDI: 000000000000021b
>> RBP: ffffc9000e05fc28 R08: ffffea00015643c7 R09: 1ffffd40002ac878
>> R10: dffffc0000000000 R11: fffff940002ac879 R12: 0000000000000008
>> R13: 1ffffd40002ac87c R14: ffffea00015643e0 R15: 0000000000001000
>> FS:  00007f1ef11d66c0(0000) GS:ffff88808ca49000(0000) knlGS:0000000000000000
>> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>> CR2: 00007f1ef05ec2e0 CR3: 0000000044745000 CR4: 0000000000352ef0
>> Call Trace:
>>   <TASK>
>>   ntfs_extend_initialized_size+0xcc/0x170 fs/ntfs3/file.c:236
>>   ntfs_fallocate+0xf21/0x1220 fs/ntfs3/file.c:668
>>   vfs_fallocate+0x669/0x7e0 fs/open.c:340
>>   ksys_fallocate fs/open.c:364 [inline]
>>   __do_sys_fallocate fs/open.c:369 [inline]
>>   __se_sys_fallocate fs/open.c:367 [inline]
>>   __x64_sys_fallocate+0xc0/0x110 fs/open.c:367
>>   do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>>   do_syscall_64+0x14d/0xf80 arch/x86/entry/syscall_64.c:94
>>   entry_SYSCALL_64_after_hwframe+0x77/0x7f
> I was poking through the code a bit out of curiosity and playing with
> Claude and I think it was able to come up with a reproducer. I don't
> know if this is the same circumstance as syzbot (we'll see if it
> eventually spits out its own reproducer), but it relies on formatting
> with a larger cluster size than page size.
>
> Basically what it's doing is creating a non-cluster aligned i_valid size
> based on completing some writes, a slightly larger also unaligned
> i_size, and then running fallocate up to the full i_size. AFAICS this
> means the falloc will leave i_size alone and fall into the
> is_supported_holes block, which will call into
> ntfs_extend_initialized_size() using the rounded up cluster end to zero
> the range from i_valid to the end of the cluster. If say the cluster
> size is 16k and i_size is not in the last 4k of the EOF cluster, then I
> suppose we're going to end up trying to zero a folio that starts beyond
> i_size. I'll append the script that Claude came up with that reproduces
> the warning for me.
>
> I'm not totally sure what the best fix is here. It seems like this is
> already playing games with i_size to handle the KEEP_SIZE case, so
> perhaps a quick hack might be to coopt that to handle this case as well.
> Maybe another option is to split the zeroing to only iomap zero through
> the end of the EOF folio and use another mechanism to zero the rest of
> the cluster, or zero it earlier at alloc time, etc. But anyways, I
> suspect NTFS3 developers will have a better handle on this than I..
>
> Brian
>
> --- 8< ---
>
> Claude generated reproducer script:
>
> #!/bin/bash
> #
> # NTFS3 fallocate bug reproducer
> #
> # Tests whether ntfs_fallocate() tries to zero folios beyond i_size
> # when using sparse files with cluster_size > PAGE_SIZE
> #
>
> set -e
>
> IMG=./ntfs_test.img
> MOUNT=/mnt
> FILE=$MOUNT/testfile
>
> echo "=== NTFS3 Fallocate Bug Test ==="
> echo ""
>
> # Check if running as root
> if [ "$EUID" -ne 0 ]; then
>      echo "ERROR: Must run as root"
>      exit 1
> fi
>
> # Check for mkfs.ntfs
> if ! command -v mkfs.ntfs &> /dev/null; then
>      echo "ERROR: mkfs.ntfs not found (install ntfs-3g)"
>      exit 1
> fi
>
> # Clear WARN_ON_ONCE state so we can see warnings on repeated runs
> echo "[1] Clearing WARN_ON_ONCE state..."
> if [ -f /sys/kernel/debug/clear_warn_once ]; then
>      echo 1 > /sys/kernel/debug/clear_warn_once
>      echo "    Cleared"
> else
>      echo "    /sys/kernel/debug/clear_warn_once not found (debugfs not mounted?)"
> fi
>
> # Create image file
> echo "[2] Creating 100M image file..."
> truncate -s 100M $IMG
>
> # Setup loop device
> echo "[3] Setting up loop device..."
> DEV=$(losetup -f)
> losetup $DEV $IMG
> echo "    Using $DEV"
>
> # Format
> echo "[4] Formatting with 16K clusters..."
> mkfs.ntfs -f -c 16384 -q $DEV
>
> # Mount
> echo "[5] Mounting with -o sparse to /mnt..."
> mount -t ntfs3 -o sparse $DEV $MOUNT
>
> # Create test file
> echo "[6] Creating file with i_valid=4995, i_size=4995..."
> dd if=/dev/urandom of=$FILE bs=999 count=1 seek=4 conv=notrunc status=none 2>/dev/null
> sync
>
> echo "[7] Extending i_size to 5000 (i_valid stays at 4995)..."
> truncate -s 5000 $FILE
>
> echo "[8] Running: fallocate -l 5000 $FILE"
> echo ""
> echo "Bug trigger: This should try to zero up to cluster boundary (16384)"
> echo "while i_size=5000, causing iomap to process folios at 8192 and 12288"
> echo "which start beyond EOF."
> echo ""
>
> if fallocate -l 5000 $FILE 2>&1; then
>      echo "-> fallocate completed"
> else
>      echo "-> fallocate failed: $?"
> fi
>
> # Cleanup
> echo ""
> echo "[9] Cleaning up..."
> umount $MOUNT
> losetup -d $DEV
> rm -f $IMG
>
> echo ""
> echo "Done. Check 'dmesg | tail' for kernel warnings."
>
Hello,

Thanks for the detailed analysis and the reproducer.

I will test the script and investigate the zeroing logic in
ntfs_extend_initialized_size(). I will follow up with findings and
post a fix for the issue.

Regards,
Konstantin


Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 5D8267CBF
	for <xfs@oss.sgi.com>; Sat, 13 Apr 2013 00:04:07 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id C5AE3AC004
	for <xfs@oss.sgi.com>; Fri, 12 Apr 2013 22:04:06 -0700 (PDT)
Received: from mail-yh0-f49.google.com (mail-yh0-f49.google.com
	[209.85.213.49]) by cuda.sgi.com with ESMTP id s8OrttaKLH8doGZb
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 12 Apr 2013 22:04:01 -0700 (PDT)
Received: by mail-yh0-f49.google.com with SMTP id i72so339551yha.36
	for <xfs@oss.sgi.com>; Fri, 12 Apr 2013 22:04:01 -0700 (PDT)
Message-ID: <5168E73A.50408@gmail.com>
Date: Sat, 13 Apr 2013 01:03:54 -0400
From: "Michael L. Semon" <mlsemon35@gmail.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfs: fix s_max_bytes to MAX_LFS_FILESIZE if needed
References: <5167E160.3020800@oracle.com>
In-Reply-To: <5167E160.3020800@oracle.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Jeff Liu <jeff.liu@oracle.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

I'll have to test this yet more, but preliminary results on a patched 
3.9-rc6-git-sgi-dave-crc kernel look good:

These were done on a 32-bit Pentium 4, BTW:

generic/308, in order of testing...

[F/F] CONFIG_LBDAF=n, without Liu MAX_LFS_FILESIZE patch: PASS

[T/F] CONFIG_LBDAF=y, without Liu patch: HANG, possible FS corruption

[T/T] CONFIG_LBDAF=y, with Liu patch: PASS

[F/T] CONFIG_LBDAF=n, with Liu patch: PASS

It was a surprise that the F/F case passed because it is somewhat in 
conflict with your write-up.  This will have to be tested more, though, 
on the original testing hardware, with the original generic/308, so it's 
not a full conflict yet.

The patch was first tested after the [T/F] case above, without creating 
a new XFS filesystem first, and I got a soft oops (captured) and had to 
do a SysRq reboot.  Attempts to mount the partition again led to another 
oops (not captured).

Tests on a new XFS filesystem came out fine.

This means I'll have to look at the aftermath of generic/308 a little 
bit more, and report on it, too.

Good job so far!

Michael

[  163.479270] ------------[ cut here ]------------
[  163.480027] kernel BUG at fs/xfs/xfs_message.c:100!
[  163.480027] invalid opcode: 0000 [#1]
[  163.480027] Pid: 1039, comm: rm Not tainted 3.9.0-rc6+ #3 Dell 
Computer Corporation Dimension 2350/07W080
[  163.480027] EIP: 0060:[<c11ad904>] EFLAGS: 00010292 CPU: 0
[  163.480027] EIP is at assfail+0x2b/0x2d
[  163.480027] EAX: 00000057 EBX: ed2c2c80 ECX: 00000000 EDX: c16fe980
[  163.480027] ESI: ecdcac00 EDI: 00000001 EBP: ea45deb4 ESP: ea45dea0
[  163.480027]  DS: 007b ES: 007b FS: 0000 GS: 00e0 SS: 0068
[  163.480027] CR0: 8005003b CR2: b765c000 CR3: 2ae8c000 CR4: 000007d0
[  163.480027] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[  163.480027] DR6: ffff0ff0 DR7: 00000400
[  163.480027] Process rm (pid: 1039, ti=ea45c000 task=eaca9810 
task.ti=ea45c000)
[  163.480027] Stack:
[  163.480027]  00000000 c167ee3c c166f028 c166efaa 00000159 ea45def0 
c11b157b 00000000
[  163.480027]  00000000 00000002 ea45def0 c118f229 00000000 ecad3000 
ed2c2c80 ed2c2db8
[  163.480027]  ea45def0 ee9cee10 ed2c2c80 ed2c2db8 ea45df04 c11aeb59 
ed2c2db8 c154b760
[  163.480027] Call Trace:
[  163.480027]  [<c11b157b>] xfs_inactive+0x3d6/0x4ea
[  163.480027]  [<c118f229>] ? ftrace_raw_event_xfs_inode_class+0x88/0x90
[  163.480027]  [<c11aeb59>] xfs_fs_evict_inode+0x6c/0x8f
[  163.480027]  [<c10cf8a6>] evict+0x7a/0x148
[  163.480027]  [<c10d0131>] iput+0xcd/0x129
[  163.480027]  [<c10c85e7>] do_unlinkat+0x121/0x177
[  163.480027]  [<c10c8660>] sys_unlinkat+0x23/0x34
[  163.480027]  [<c1521c3b>] sysenter_do_call+0x12/0x22
[  163.480027] Code: 55 89 e5 83 ec 14 3e 8d 74 26 00 89 4c 24 10 89 54 
24 0c 89 44 24 08 c7 44 24 04 3c ee 67 c1 c7 04 24 00 00 00 00 e8 e9 fd 
ff ff <0f> 0b 55 89 e5 83 ec 14 3e 8d 74 26 00 c7 44 24 10 01 00 00 00
[  163.480027] EIP: [<c11ad904>] assfail+0x2b/0x2d SS:ESP 0068:ea45dea0
[  163.514560] ---[ end trace 2a80fb79142bf578 ]---

Message from syslogd@plbearer at Fri Apr 12 23:23:10 2013 ...
plbearer kernel: [  163.478205] XFS: Assertion failed: 
ip->i_d.di_nextents == 0, file: fs/xfs/xfs_vnodeops.c, line: 345

Message from syslogd@plbearer at Fri Apr 12 23:23:10 2013 ...
plbearer kernel: [  163.480027] EIP: [<c11ad904>] assfail+0x2b/0x2d 
SS:ESP 0068:ea45dea0

Message from syslogd@plbearer at Fri Apr 12 23:23:10 2013 ...
plbearer kernel: [  163.480027] Code: 55 89 e5 83 ec 14 3e 8d 74 26 00 
89 4c 24 10 89 54 24 0c 89 44 24 08 c7 44 24 04 3c ee 67
c1 c7 04 24 00 00 00 00 e8 e9 fd ff ff <0f> 0b 55 89 e5 83 ec 14 3e 8d 
74 26 00 c7 44 24 10 01 00 00 00

Message from syslogd@plbearer at Fri Apr 12 23:23:10 2013 ...
plbearer kernel: [  163.480027] Call Trace:

Message from syslogd@plbearer at Fri Apr 12 23:23:10 2013 ...
plbearer kernel: [  163.480027] Stack:

Message from syslogd@plbearer at Fri Apr 12 23:23:10 2013 ...
plbearer kernel: [  163.480027] Process rm (pid: 1039, ti=ea45c000 
task=eaca9810 task.ti=ea45c000)
  - output mismatch (see /usr/src/xfs/xfstests/results/generic/308.out.bad)
     --- tests/generic/308.out   2013-04-05 16:00:27.879187036 -0400
     +++ /usr/src/xfs/xfstests/results/generic/308.out.bad 
2013-04-12 23:23:10.528872994 -0400
     @@ -1,2 +1,3 @@
      QA output created by 308
      Silence is golden
     +./tests/generic/308: line 33:  1039 Segmentation fault      exit
      ...
      (Run 'diff -u tests/generic/308.out 
/usr/src/xfs/xfstests/results/generic/308.out.bad' to see the entire diff)
umount: /tests/testdir: target is busy.
         (In some cases useful info about processes that use
          the device is found by lsof(8) or fuser(1))
_check_xfs_filesystem: filesystem on /dev/sda5 is inconsistent (c) (see 
/usr/src/xfs/xfstests/results/generic/308.full)
_check_xfs_filesystem: filesystem on /dev/sda5 is inconsistent (r) (see 
/usr/src/xfs/xfstests/results/generic/308.full)
Ran: generic/308
Failures: generic/308
Failed 1 of 1 tests

On 04/12/2013 06:26 AM, Jeff Liu wrote:
> From: Jie Liu <jeff.liu@oracle.com>
>
> On 32-bit machine, the s_maxbytes is larger than the MAX_LFS_FILESIZE limits if CONFIG_LBDAF is
> not enabled.  Hence it's possible to create a huge file via buffered-IO write with a given offset
> beyond this limitation. e.g.
>
> # block_size=4096
> # offset=$(((2**32 - 1) * $block_size))
> # xfs_io -f -c "pwrite $offset $block_size" /storage/test_file
>
> In this case, xfs_io will hang at the page writeback stage soon since the given offset would
> cause an overflow at xfs_vm_writepage():
>
> end_index = offset >> PAGE_CACHE_SHIFT;
> last_index = (offset - 1) >> PAGE_CACHE_SHIFT;
> if (page->index >= end_index) {
>                  unsigned offset_into_page = offset & (PAGE_CACHE_SIZE - 1);
>
>                  /*
>                   * Just skip the page if it is fully outside i_size, e.g. due
>                   * to a truncate operation that is in progress.
>                   */
>                  if (page->index >= end_index + 1 || offset_into_page == 0) {
> 		^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
>                          unlock_page(page);
>                          return 0;
>                  }
> end_index is unsigned long so that the max value is '2^32-1 = 4294967295', and it
> would be evaluated to the max value with the given offset(when writing the page offset
> up to s_max_bytes) for above test case.  As a result, (page->index >= end_index + 1) is
> ok as (end_index + 1) is overflowed to ZERO.
>
> Actually, create a file as above on 32-bit machine should be failed with EFBIG error returned
> because there has strict check up at generic_write_checks() against the given offset with a
> *correct* s_max_bytes.
>
> This patch fix the s_max_bytes to MAX_LFS_FILESIZE if the pre-calculated value is greater
> than it.
>
> Reported-by: Michael L. Semon <mlsemon35@gmail.com>
> Signed-off-by: Jie Liu <jeff.liu@oracle.com>
>
> ---
>   fs/xfs/xfs_super.c |    6 +++++-
>   1 file changed, 5 insertions(+), 1 deletion(-)
>
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index ea341ce..0644d61 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -585,6 +585,7 @@ xfs_max_file_offset(
>   {
>   	unsigned int		pagefactor = 1;
>   	unsigned int		bitshift = BITS_PER_LONG - 1;
> +	__uint64_t		offset;
>
>   	/* Figure out maximum filesize, on Linux this can depend on
>   	 * the filesystem blocksize (on 32 bit platforms).
> @@ -610,7 +611,10 @@ xfs_max_file_offset(
>   # endif
>   #endif
>
> -	return (((__uint64_t)pagefactor) << bitshift) - 1;
> +	offset = (((__uint64_t)pagefactor) << bitshift) - 1;
> +
> +	/* Check against VM & VFS exposed limits */
> +	return (offset > MAX_LFS_FILESIZE) ? MAX_LFS_FILESIZE : offset;
>   }
>
>   xfs_agnumber_t
>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

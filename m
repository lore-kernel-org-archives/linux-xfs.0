Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q0KCpcDq104273 for <xfs@oss.sgi.com>; Fri, 20 Jan 2012 06:51:38 -0600
Message-ID: <4F19634A.607@oracle.com>
Date: Fri, 20 Jan 2012 20:51:22 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: Re: [PATCH 10/11] xfs: always return with the iolock held from
	xfs_file_aio_write_checks
References: <20111218200003.557507716@bombadil.infradead.org>	<20111218200132.483776880@bombadil.infradead.org>
	<20120117201817.GG16581@sgi.com>
In-Reply-To: <20120117201817.GG16581@sgi.com>
Reply-To: jeff.liu@oracle.com
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Ben Myers <bpm@sgi.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On 01/18/2012 04:18 AM, Ben Myers wrote:

> On Sun, Dec 18, 2011 at 03:00:13PM -0500, Christoph Hellwig wrote:
>> While xfs_iunlock is fine with 0 lockflags the calling conventions are much
>> cleaner if xfs_file_aio_write_checks never returns without the iolock held.
>>
>> Reviewed-by: Dave Chinner <dchinner@redhat.com>
>> Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> Looks good.
> Reviewed-by: Ben Myers <bpm@sgi.com>
> 
>>
>> ---
>>  fs/xfs/xfs_file.c |    7 ++++---
>>  1 file changed, 4 insertions(+), 3 deletions(-)
>>
>> Index: xfs/fs/xfs/xfs_file.c
>> ===================================================================
>> --- xfs.orig/fs/xfs/xfs_file.c	2011-12-07 12:46:31.343897882 +0100
>> +++ xfs/fs/xfs/xfs_file.c	2011-12-07 12:48:33.309903801 +0100
>> @@ -636,7 +636,9 @@ out_lock:
>>  /*
>>   * Common pre-write limit and setup checks.
>>   *
>> - * Returns with iolock held according to @iolock.
>> + * Called with the iolocked held either shared and exclusive according to
>> + * @iolock, and returns with it held.  Might upgrade the iolock to exclusive
>> + * if called for a direct write beyond i_size.
>>   */
>>  STATIC ssize_t
>>  xfs_file_aio_write_checks(
>> @@ -653,8 +655,7 @@ xfs_file_aio_write_checks(
>>  restart:
>>  	error = generic_write_checks(file, pos, count, S_ISBLK(inode->i_mode));
>>  	if (error) {
>> -		xfs_rw_iunlock(ip, XFS_ILOCK_EXCL | *iolock);
>> -		*iolock = 0;
>> +		xfs_rw_iunlock(ip, XFS_ILOCK_EXCL);
>>  		return error;
>>  	}

Haha, I lucky to saw this patch, since I have triggered an Oops on 3.2.0-rc6 without it just now.

FYI, test code:

#define _GNU_SOURCE
#define _LARGEFILE64_SOURCE
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <unistd.h>
#include <ctype.h>
#include <errno.h>
#include <linux/falloc.h>

int
main(int argc, char **argv)
{
	off64_t ret = 0;
	char *path;
	int fd;

	if (argc != 2) {
		fprintf(stdout, "Usage: %s filename\n", argv[0]);
		return 1;
	}

	path = argv[1];		
	fd = open(path, O_WRONLY|O_CREAT|O_TRUNC, 0644);
	if (fd < 0) {
		perror("open");
		return fd;
	}

	ret = fallocate(fd, 0, 0, 1);
	if (ret < 0) {
		fprintf(stderr, "fallocate failed due to %s\n", strerror(errno));
		return ret;
	}

	ret = lseek64(fd, (off64_t)2947483650, SEEK_SET);
	if (ret < 0) {
		perror("lseek");
		return ret;
	}

	write(fd, "abc", 3);

	ret = lseek64(fd, (off64_t)2997483650, SEEK_SET);
	if (ret < 0) {
		perror("lseek");
		return ret;
	}

	write(fd, "abc", 3);

	close(fd);

	return ret;
}

[  135.592793] XFS: Assertion failed: lock_flags != 0, file: fs/xfs/xfs_iget.c, line: 652
[  135.592836] ------------[ cut here ]------------
[  135.596010] kernel BUG at fs/xfs/xfs_message.c:101!
[  135.596010] invalid opcode: 0000 [#1] SMP DEBUG_PAGEALLOC
[  135.596010] Modules linked in: xfs(O) binfmt_misc kvm_intel kvm ocfs2_dlmfs ocfs2_stack_o2cb ocfs2_dlm ocfs2_nodemanager ocfs2_stackglue configfs xt_TCPMSS xt_tcpmss xt_tcpudp iptable_mangle pppoe pppox nfsd exportfs nfs ipt_MASQUERADE iptable_nat nf_nat nf_conntrack_ipv4 lockd nf_conntrack nf_defrag_ipv4 parport_pc ppdev ip_tables x_tables fscache auth_rpcgss bridge nfs_acl sunrpc stp snd_hda_codec_analog arc4 snd_hda_intel snd_hda_codec snd_hwdep iwl4965 snd_pcm iwl_legacy thinkpad_acpi i915 snd_seq_midi snd_rawmidi pcmcia mac80211 joydev snd_seq_midi_event snd_seq drm_kms_helper btrfs snd_timer snd_seq_device zlib_deflate libcrc32c psmouse btusb yenta_socket pcmcia_rsrc drm cfg80211 bluetooth serio_raw pcmcia_core snd tpm_tis tpm tpm_bios nvram soundcore snd_page_alloc lp i2c_algo_bit parport video ext4 mbcache jbd2 firewire_ohci firewire_core crc_itu_t ahci libahci e1000e
[  135.596010] 
[  135.596010] Pid: 2313, comm: faa Tainted: G        W  O 3.2.0-rc6 #9 LENOVO 7661D43/7661D43
[  135.596010] EIP: 0060:[<f94ae5e8>] EFLAGS: 00010246 CPU: 1
[  135.596010] EIP is at assfail+0x47/0x57 [xfs]
[  135.596010] EAX: 00000060 EBX: e6674400 ECX: 00000000 EDX: 00000073
[  135.596010] ESI: 00000000 EDI: 00000000 EBP: e8d59e34 ESP: e8d59e20
[  135.596010]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
[  135.596010] Process faa (pid: 2313, ti=e8d58000 task=e919c6c0 task.ti=e8d58000)
[  135.596010] Stack:
[  135.596010]  00000000 f956b082 f956abbb f956a97f 0000028c e8d59e50 f94a3027 e8d59e4c
[  135.596010]  f949c2bd e6674400 00000000 f956171c e8d59e60 f949c2bd afaf0802 00000000
[  135.596010]  e8d59ed4 f949eb38 afaf0802 00000000 00000003 e8d59eb8 e8d59ec4 000021ef
[  135.596010] Call Trace:
[  135.596010]  [<f94a3027>] xfs_iunlock+0xe6/0x2c0 [xfs]
[  135.596010]  [<f949c2bd>] ? xfs_rw_iunlock+0x21/0x5f [xfs]
[  135.596010]  [<f949c2bd>] xfs_rw_iunlock+0x21/0x5f [xfs]
[  135.596010]  [<f949eb38>] xfs_file_aio_write+0x3cf/0x3e8 [xfs]
[  135.596010]  [<c1215c94>] do_sync_write+0xaa/0x12c
[  135.596010]  [<c12edddc>] ? security_file_permission+0x53/0x65
[  135.596010]  [<c12166a5>] ? rw_verify_area+0x1c4/0x1fe
[  135.596010]  [<c1215bea>] ? wait_on_retry_sync_kiocb+0x8c/0x8c
[  135.596010]  [<c1216af6>] vfs_write+0xf5/0x1a3
[  135.596010]  [<c1218dff>] ? fget_light+0x3e/0x130
[  135.596010]  [<c1216e59>] sys_write+0x6c/0xa9
[  135.596010]  [<c18178b4>] syscall_call+0x7/0xb
[  135.596010] Code: 10 89 54 24 0c 89 44 24 08 c7 44 24 04 82 b0 56 f9 c7 04 24 00 00 00 00 e8 ad fc ff ff 83 05 e0 45 59 f9 01 83 15 e4 45 59 f9 00 <0f> 0b 83 05 e8 45 59 f9 01 83 15 ec 45 59 f9 00 55 89 e5 83 ec 
[  135.596010] EIP: [<f94ae5e8>] assfail+0x47/0x57 [xfs] SS:ESP 0068:e8d59e20
[  135.833048] ---[ end trace 4af94dd273c5d0cb ]---

Call chains:
xfs_file_aio_write->xfs_file_buffered_aio_write->xfs_file_aio_write_checks()->generic_write_checks() failed due to -EFBIG, and the iolock was set to *ZERO* at that time. :-P.

Thanks,
-Jeff

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

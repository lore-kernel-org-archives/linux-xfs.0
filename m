Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 4B22B7F3F
	for <xfs@oss.sgi.com>; Thu, 27 Mar 2014 02:42:05 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id BC375AC003
	for <xfs@oss.sgi.com>; Thu, 27 Mar 2014 00:42:01 -0700 (PDT)
Received: from order.stressinduktion.org (order.stressinduktion.org
	[87.106.68.36]) by cuda.sgi.com with ESMTP id Qc5og3ogWaOMFE7I
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 27 Mar 2014 00:41:58 -0700 (PDT)
Date: Thu, 27 Mar 2014 08:41:56 +0100
From: Hannes Frederic Sowa <hannes@stressinduktion.org>
Subject: xfs errors while unlinking filenames with hash collisions
Message-ID: <20140327074156.GJ29498@order.stressinduktion.org>
Mime-Version: 1.0
Content-Disposition: inline
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Hello!

I wanted to break some network stack hashing, but while running the test
against my local xfs filesystem I got corruptions in rmdir:

[ 3856.245843] XFS (vda1): Internal error xfs_trans_cancel at line 966 of file fs/xfs/xfs_trans.c.  Caller 0xffffffffa01186bc
[ 3856.249049] CPU: 1 PID: 866 Comm: rm Not tainted 3.13.6-200.fc20.x86_64 #1
[ 3856.250966] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[ 3856.252615]  000000000000000c ffff8800d23a7d68 ffffffff8168730c ffff8800cf5462b8
[ 3856.254823]  ffff8800d23a7d80 ffffffffa00d00cb ffffffffa01186bc ffff8800d23a7da8
[ 3856.257241]  ffffffffa00e5459 ffff8800d9ac3400 ffff8800d23a7e30 ffff8800371b6800
[ 3856.259420] Call Trace:
[ 3856.260172]  [<ffffffff8168730c>] dump_stack+0x45/0x56
[ 3856.261717]  [<ffffffffa00d00cb>] xfs_error_report+0x3b/0x40 [xfs]
[ 3856.263472]  [<ffffffffa01186bc>] ? xfs_remove+0x1ac/0x370 [xfs]
[ 3856.270838]  [<ffffffffa00e5459>] xfs_trans_cancel+0xd9/0x100 [xfs]
[ 3856.272783]  [<ffffffffa01186bc>] xfs_remove+0x1ac/0x370 [xfs]
[ 3856.274531]  [<ffffffffa00db40b>] xfs_vn_unlink+0x4b/0x90 [xfs]
[ 3856.276286]  [<ffffffff811c61b8>] vfs_rmdir+0xa8/0x100
[ 3856.277821]  [<ffffffff811c638d>] do_rmdir+0x17d/0x1d0
[ 3856.281021]  [<ffffffff811ba7fe>] ? ____fput+0xe/0x10
[ 3856.285261]  [<ffffffff8108c11c>] ? task_work_run+0xac/0xe0
[ 3856.286952]  [<ffffffff81013a31>] ? do_notify_resume+0x61/0xa0
[ 3856.288693]  [<ffffffff811c9a65>] SyS_unlinkat+0x25/0x40
[ 3856.290407]  [<ffffffff816962e9>] system_call_fastpath+0x16/0x1b
[ 3856.292685] XFS (vda1): xfs_do_force_shutdown(0x8) called from line 967 of file fs/xfs/xfs_trans.c.  Return address = 0xffffffffa00e5472
[ 3856.627330] XFS (vda1): Corruption of in-memory data detected.  Shutting down filesystem
[ 3856.627332] XFS (vda1): Please umount the filesystem and rectify the problem(s)

I also tested this on a current linux net-next kernel, which is 3.14.0-rc6.

If I run the test code below in an directory for a while and after that
try to unlink the files in it (rm -rf testdir), I get above splat. Even
after running xfs_repair I cannot remove the directory. The system is
pretty unusable after that if this is done on a root filesystem.

I quickly extracted this simple test case below. It does not generate
perfect collisions, but they are enough to trigger the above described
problem.

Thanks,

  Hannes

---- >8 ----
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <stdbool.h>
#include <unistd.h>
#include <err.h>
#include <string.h>
#include <stdint.h>
#include <stdlib.h>
#include <stdio.h>
#include <limits.h>

static inline uint32_t rol32(uint32_t word, unsigned int shift)
{
	return (word << shift) | (word >> (32 - shift));
}

static uint32_t xfs_hash(const uint8_t *name, int namelen)
{
	uint32_t hash = 0;

	for (; namelen >= 4; namelen -= 4, name += 4)
		hash = (name[0] << 21) ^ (name[1] << 14) ^ (name[2] << 7) ^ (name[3] << 0) ^ rol32(hash, 7 * 4);

	if (namelen)
		abort();

	return hash;
}

static uint8_t gen_rand(void)
{
	uint8_t r;
	while (!(r = rand()));
	return r;
}

static uint8_t *round_one(uint8_t (*generator)())
{
	int idx;
	static uint8_t buffer[300] = {0};

	for (idx = 0; idx < 252-4; idx+=4) {
		buffer[idx + 0] = gen_rand();
		buffer[idx + 1] = gen_rand();
		buffer[idx + 2] = gen_rand();
		buffer[idx + 3] = gen_rand();
	}
	return buffer;
}

static uint8_t *round_two(uint8_t *buffer)
{
	static uint8_t a = 0, b = 0, c = 0;

	static const uint32_t target = ~0U;

	uint32_t hash = rol32(xfs_hash(buffer, 248), 7 * 4);

	a++, b++, c++;

	uint32_t last = hash ^ target;

	buffer[248] = (last >> 21) & 0xff;
	buffer[249] = (last >> 14) & 0xff;
	buffer[250] = (last >> 7) & 0xff;
	buffer[251] = last & 0xff;

	return buffer;
}

int main(int argc, char **argv)
{
	unsigned int cnt = 0;

	while (true)
		mkdir(round_two(round_one(gen_rand)), S_IRWXU);

	exploit();
}
--- >8 ----

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mB492MLg007984 for <xfs@oss.sgi.com>; Thu, 4 Dec 2008 03:02:24 -0600
Received: from monty.telenet-ops.be (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 87DE41690991
	for <xfs@oss.sgi.com>; Thu,  4 Dec 2008 01:02:18 -0800 (PST)
Received: from monty.telenet-ops.be (monty.telenet-ops.be [195.130.132.56]) by
	cuda.sgi.com with ESMTP id xn71vdVpA8jmprEc for
	<xfs@oss.sgi.com>; Thu, 04 Dec 2008 01:02:18 -0800 (PST)
Date: Thu, 4 Dec 2008 10:02:15 +0100 (CET)
From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: XFS breakage on m68k (was: Re: linux-next: Tree for December 3)
In-Reply-To: <20081203183602.c06f8c39.sfr@canb.auug.org.au>
Message-ID: <Pine.LNX.4.64.0812040956370.10635@anakin>
References: <20081203183602.c06f8c39.sfr@canb.auug.org.au>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
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
To: Eric Sandeen <sandeen@sandeen.net>, Christoph Hellwig <hch@lst.de>, Lachlan McIlroy <lachlan@sgi.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com

On Wed, 3 Dec 2008, Stephen Rothwell wrote:
> Status of my local build tests will be at
> http://kisskb.ellerman.id.au/linux-next .  If maintainers want to give
> advice about cross compilers/configs that work, we are always open to add
> more builds.

On m68k (32-bit only, no compat32), XFS fails to build in linux-next:

| fs/xfs/linux-2.6/xfs_ioctl32.h:50: error: syntax error before 'compat_time_t'
| fs/xfs/linux-2.6/xfs_ioctl32.h:52: error: syntax error before '}' token
| fs/xfs/linux-2.6/xfs_ioctl32.h:63: error: syntax error before 'compat_xfs_bstime_t'
| fs/xfs/linux-2.6/xfs_ioctl32.h:65: error: syntax error before 'bs_ctime'
| fs/xfs/linux-2.6/xfs_ioctl32.h:76: error: syntax error before '}' token
| fs/xfs/linux-2.6/xfs_ioctl32.h:79: error: syntax error before 'compat_uptr_t'
| fs/xfs/linux-2.6/xfs_ioctl32.h:81: error: syntax error before 'ubuffer'
| fs/xfs/linux-2.6/xfs_ioctl32.h:82: error: syntax error before 'ocount'
| fs/xfs/linux-2.6/xfs_ioctl32.h:94: error: syntax error before 'compat_uptr_t'
| fs/xfs/linux-2.6/xfs_ioctl32.h:96: error: syntax error before 'ihandle'
| fs/xfs/linux-2.6/xfs_ioctl32.h:98: error: syntax error before 'ohandle'
| fs/xfs/linux-2.6/xfs_ioctl32.h:99: error: syntax error before 'ohandlen'
| fs/xfs/linux-2.6/xfs_ioctl32.h:121: error: syntax error before 'compat_xfs_bstat_t'
| fs/xfs/linux-2.6/xfs_ioctl32.h:127: error: field 'hreq' has incomplete type
| fs/xfs/linux-2.6/xfs_ioctl32.h:131: error: syntax error before 'compat_uptr_t'
| fs/xfs/linux-2.6/xfs_ioctl32.h:142: error: syntax error before 'compat_uptr_t'
| fs/xfs/linux-2.6/xfs_ioctl32.h:146: error: syntax error before '}' token
| fs/xfs/linux-2.6/xfs_ioctl32.h:149: error: field 'hreq' has incomplete type
| fs/xfs/linux-2.6/xfs_ioctl32.h:152: error: syntax error before 'compat_uptr_t'
| fs/xfs/linux-2.6/xfs_ioctl32.h:159: error: field 'hreq' has incomplete type
| fs/xfs/linux-2.6/xfs_ioctl32.h:161: error: syntax error before 'compat_uptr_t'
| distcc[28223] ERROR: compile fs/xfs/linux-2.6/xfs_file.c on localhost failed

(http://kisskb.ellerman.id.au/kisskb/buildresult/58941/)

or (with a different compiler):

| In file included from fs/xfs/linux-2.6/xfs_file.c:39:
| fs/xfs/linux-2.6/xfs_ioctl32.h:50: error: expected specifier-qualifier-list before 'compat_time_t'
| fs/xfs/linux-2.6/xfs_ioctl32.h:79: error: expected specifier-qualifier-list before 'compat_uptr_t'
| fs/xfs/linux-2.6/xfs_ioctl32.h:94: error: expected specifier-qualifier-list before 'compat_uptr_t'
| make[2]: *** [fs/xfs/linux-2.6/xfs_file.o] Error 1

git bisect run says:

ffae263a640b736a7206a0d7bd14ab44eb58cd28 is first bad commit
commit ffae263a640b736a7206a0d7bd14ab44eb58cd28
Author: sandeen@sandeen.net <sandeen@sandeen.net>
Date:   Tue Nov 25 21:20:07 2008 -0600

    [XFS] Move compat ioctl structs & numbers into xfs_ioctl32.h

    This makes the c file less cluttered and a bit more
    readable.   Consistently name the ioctl number
    macros with "_32" and the compatibility stuctures
    with "_compat."  Rename the helpers which simply
    copy in the arg with "_copyin" for easy identification.

    Finally, for a few of the existing helpers, modify them
    so that they directly call the native ioctl helper
    after userspace argument fixup.

    Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
    Reviewed-by: Christoph Hellwig <hch@lst.de>
    Signed-off-by: Lachlan McIlroy <lachlan@sgi.com>

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

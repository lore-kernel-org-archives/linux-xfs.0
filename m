Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:45442 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751657AbdDORVR (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sat, 15 Apr 2017 13:21:17 -0400
Subject: Re: [PATCH] xfs: remove custom do_div implementations
References: <0c0a6e24-f5c9-7610-fa38-b61be6d7439a@redhat.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <009c2908-e023-4a62-2466-6fc6c59c49ab@sandeen.net>
Date: Sat, 15 Apr 2017 12:21:16 -0500
MIME-Version: 1.0
In-Reply-To: <0c0a6e24-f5c9-7610-fa38-b61be6d7439a@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>

On 4/7/17 4:42 PM, Eric Sandeen wrote:
> Long ago, all this gunk was added with a lament about problems
> with gcc's do_div, and a fun recommendation in the changelog:
> 
>  egcs-2.91.66 is the recommended compiler version for building XFS.
> 
> All this special stuff was needed to work around an old gcc bug,
> apparently, and it's been there ever since.
> 
> There should be no need for this anymore, so remove it.
> 
> Remove the special 32-bit xfs_do_mod as well; just let the
> kernel's do_div() handle all this.

Sooo this makes parisc unhappy, but I don't know why:

  CC [M]  fs/xfs/libxfs/xfs_bmap_btree.o
In file included from ./arch/parisc/include/generated/asm/div64.h:1:0,
                 from ./include/linux/kernel.h:147,
                 from ./arch/parisc/include/asm/bug.h:4,
                 from ./include/linux/bug.h:4,
                 from ./include/linux/mmdebug.h:4,
                 from ./include/linux/gfp.h:4,
                 from ./include/linux/slab.h:14,
                 from fs/xfs/kmem.h:21,
                 from fs/xfs/xfs_linux.h:43,
                 from fs/xfs/xfs.h:32,
                 from fs/xfs/xfs_trace.c:18:
fs/xfs/xfs_mount.h: In function 'xfs_daddr_to_agno':
./include/asm-generic/div64.h:207:28: warning: comparison of distinct pointer types lacks a cast
  (void)(((typeof((n)) *)0) == ((uint64_t *)0)); \
                            ^
fs/xfs/xfs_mount.h:315:2: note: in expansion of macro 'do_div'
  do_div(ld, mp->m_sb.sb_agblocks);
  ^
fs/xfs/xfs_mount.h: In function 'xfs_daddr_to_agbno':
./include/asm-generic/div64.h:207:28: warning: comparison of distinct pointer types lacks a cast
  (void)(((typeof((n)) *)0) == ((uint64_t *)0)); \
                            ^
fs/xfs/xfs_mount.h:323:25: note: in expansion of macro 'do_div'
  return (xfs_agblock_t) do_div(ld, mp->m_sb.sb_agblocks);
                         ^

ld is an xfs_daddr_t in this call.

so passing an xfs_daddr_t (__s64) to do_div triggers the type check
warning above.  On parisc, we typedef things like this:

typedef __s64 xfs_daddr_t;
__extension__ typedef __signed__ long long __s64;

if # make.cross ARCH=parisc fs/xfs/xfs_bmap_util.i
is to be believed.

On x86_64 the typedefs are the same:

typedef __s64 xfs_daddr_t;
__extension__ typedef __signed__ long long __s64;

so I can't figure out why this is triggering...

-Eric

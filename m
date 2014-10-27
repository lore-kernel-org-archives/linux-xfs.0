Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 40C2F7F4E
	for <xfs@oss.sgi.com>; Sun, 26 Oct 2014 22:21:08 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id CCFA7AC003
	for <xfs@oss.sgi.com>; Sun, 26 Oct 2014 20:21:07 -0700 (PDT)
Received: from mail-qg0-f41.google.com (mail-qg0-f41.google.com
	[209.85.192.41]) by cuda.sgi.com with ESMTP id 69uejaYZ6zqtLTqA
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Sun, 26 Oct 2014 20:21:06 -0700 (PDT)
Received: by mail-qg0-f41.google.com with SMTP id q107so1134741qgd.28
	for <xfs@oss.sgi.com>; Sun, 26 Oct 2014 20:21:05 -0700 (PDT)
Received: from yholen.ds (rrcs-97-76-23-49.se.biz.rr.com. [97.76.23.49])
	by mx.google.com with ESMTPSA id
	107sm10188821qgi.19.2014.10.26.20.21.05 for <xfs@oss.sgi.com>
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
	Sun, 26 Oct 2014 20:21:05 -0700 (PDT)
Message-ID: <544DBA20.5040206@gmail.com>
Date: Sun, 26 Oct 2014 23:21:04 -0400
From: "Michael L. Semon" <mlsemon35@gmail.com>
MIME-Version: 1.0
Subject: xfs_setattr_size is mid-stack during log-flooding stack traces
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
To: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

Hi!  I was having fantastic luck with v5/finobt XFS and kernel
3.18.0-rc1, so I decided to disable quota support and debug support
in XFS...

[    0.000000] Linux version 3.18.0-rc1+ (root@kyhorse) (gcc version 4.8.3 (GCC) ) #5 SMP Sun Oct 26 14:43:09 EDT 2014
# i686 Pentium 4, BTW.
[    0.857655] SGI XFS with ACLs, security attributes, no debug enabled

Some other debug items were shut off as well.

Now, my logs are getting pelted with items that look like this (first trace,
on boot):

[   14.549583] XFS (sda1): Mounting V5 Filesystem
[   14.810908] XFS (sda1): Ending clean mount
[   14.826918] mount (155) used greatest stack depth: 6056 bytes left
[   15.139152] rc.S (64) used greatest stack depth: 5948 bytes left
[   29.443780] ------------[ cut here ]------------
[   29.443801] WARNING: CPU: 0 PID: 387 at mm/truncate.c:758 pagecache_isize_extended+0x124/0x129()
[   29.443809] CPU: 0 PID: 387 Comm: gtk-query-immod Not tainted 3.18.0-rc1+ #5
[   29.443813] Hardware name: Gateway                         E-2000                         /D845GRG                        , BIOS RG84510A.15A.0009.P03.020
[   29.443817]  00000000 00000000 ee1e9e20 c144939c 00000000 ee1e9e50 c1031b03 c154f66c
[   29.443828]  00000000 00000183 c1553739 000002f6 c1098458 c1098458 e849ed54 00000000
[   29.443838]  00001000 ee1e9e60 c1031bb8 00000009 00000000 ee1e9e98 c1098458 efd69100
[   29.443848] Call Trace:
[   29.443858]  [<c144939c>] dump_stack+0x41/0x52
[   29.443867]  [<c1031b03>] warn_slowpath_common+0x6f/0x86
[   29.443873]  [<c1098458>] ? pagecache_isize_extended+0x124/0x129
[   29.443878]  [<c1098458>] ? pagecache_isize_extended+0x124/0x129
[   29.443884]  [<c1031bb8>] warn_slowpath_null+0x1d/0x1f
[   29.443889]  [<c1098458>] pagecache_isize_extended+0x124/0x129
[   29.443895]  [<c1098494>] truncate_setsize+0x37/0x50
[   29.443902]  [<c117c534>] xfs_setattr_size+0x13d/0x3d6
[   29.443909]  [<c116a2ed>] ? __xfs_get_blocks+0x5ff/0x5ff
[   29.443916]  [<c1172c13>] xfs_file_fallocate+0x2fe/0x340
[   29.443922]  [<c1444ccc>] ? kmemleak_free+0x20/0x43
[   29.443931]  [<c10ba00d>] ? kmem_cache_free+0x76/0xc4
[   29.443938]  [<c10bd802>] do_fallocate+0x111/0x18a
[   29.443943]  [<c10bd8cb>] SyS_fallocate+0x50/0x70
[   29.443950]  [<c144f6ef>] syscall_call+0x7/0x7
[   29.443954] ---[ end trace 281f0f955c16f86c ]---

In an xfstests run, it seemed to start with generic/012 and hit a
great many tests after that.  The actual BUG_ON is somewhere in
mm/truncate.c, though...

         WARN_ON(!mutex_is_locked(&inode->i_mutex));

Is this an XFS issue at all?  Or is there some kind of extra
precaution that has to be taken on the XFS side?  Feel free to toss
me over to mm to ask, "What is this?"

Thanks!

Michael

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

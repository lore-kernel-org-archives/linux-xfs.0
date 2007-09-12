Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 12 Sep 2007 18:26:56 -0700 (PDT)
Received: from nz-out-0506.google.com (nz-out-0506.google.com [64.233.162.234])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l8D1Qn4p027176
	for <xfs@oss.sgi.com>; Wed, 12 Sep 2007 18:26:51 -0700
Received: by nz-out-0506.google.com with SMTP id x3so254352nzd
        for <xfs@oss.sgi.com>; Wed, 12 Sep 2007 18:26:52 -0700 (PDT)
Message-ID: <64de4d610709121638s6a8a92c4qec2c4b70de9d955e@mail.gmail.com>
Date: Wed, 12 Sep 2007 16:38:16 -0700
From: "Kevin Mullican" <kevin@mullican.com>
Subject: compile fails
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Greetings,

I am attempting to build the XFS kernel, but the compile is failing. I
downloaded the source from the CVS repository today, and I generated a
relatively generic .config. I am using gcc-3.2.3-52, libgcc-3.2.3-52,
and glibc-2.3.2-95.33. During the kernel compile, I am getting the
following errors:

make -C xfs
make[2]: Entering directory `/usr/src/linux-2.4-xfs/fs/xfs'
make -C linux-2.4
make[3]: Entering directory `/usr/src/linux-2.4-xfs/fs/xfs/linux-2.4'
make all_targets
make[4]: Entering directory `/usr/src/linux-2.4-xfs/fs/xfs/linux-2.4'
gcc -D__KERNEL__ -I/usr/src/linux-2.4-xfs/include -Wall
-Wstrict-prototypes -Wno-trigraphs -O2 -fno-strict-aliasing
-fno-common -fomit-frame-pointer -pipe -mpreferred-stack-boundary=2
-march=i686   -I.. -I. -funsigned-char -nostdinc -iwithprefix include
-DKBUILD_BASENAME=xfs_stats  -c -o xfs_stats.o xfs_stats.c
In file included from ../xfs.h:48,
                 from xfs_stats.c:19:
../linux-2.4/xfs_linux.h:35:18: warning: extra tokens at end of #undef
directive../linux-2.4/xfs_linux.h:96:24: linux/log2.h: No such file or
directory
In file included from ../linux-2.4/xfs_linux.h:110,
                 from ../xfs.h:48,
                 from xfs_stats.c:19:
xfs_vfs.h:46: syntax error before "bhv_head_t"
xfs_vfs.h:46: warning: no semicolon at end of struct or union
xfs_vfs.h:55: syntax error before '}' token
xfs_vfs.h:55: warning: type defaults to `int' in declaration of `bhv_vfs_t'
xfs_vfs.h:55: warning: data definition has no type or storage class
xfs_vfs.h:109: syntax error before '*' token
xfs_vfs.h:110: warning: function declaration isn't a prototype
xfs_vfs.h:111: syntax error before '*' token
xfs_vfs.h:112: warning: function declaration isn't a prototype
xfs_vfs.h:113: syntax error before '*' token
xfs_vfs.h:113: warning: function declaration isn't a prototype
xfs_vfs.h:114: syntax error before '*' token
xfs_vfs.h:114: warning: function declaration isn't a prototype
xfs_vfs.h:115: syntax error before '*' token
xfs_vfs.h:116: warning: function declaration isn't a prototype
xfs_vfs.h:117: syntax error before '*' token
xfs_vfs.h:117: warning: function declaration isn't a prototype
xfs_vfs.h:118: syntax error before '*' token
xfs_vfs.h:119: warning: function declaration isn't a prototype
xfs_vfs.h:120: syntax error before '*' token
xfs_vfs.h:120: warning: function declaration isn't a prototype
xfs_vfs.h:121: syntax error before '*' token
xfs_vfs.h:121: warning: function declaration isn't a prototype
xfs_vfs.h:122: syntax error before '*' token
xfs_vfs.h:122: warning: function declaration isn't a prototype
xfs_vfs.h:123: syntax error before '*' token
xfs_vfs.h:123: warning: function declaration isn't a prototype
xfs_vfs.h:124: syntax error before '*' token
xfs_vfs.h:125: warning: function declaration isn't a prototype
xfs_vfs.h:126: syntax error before '*' token
xfs_vfs.h:126: warning: function declaration isn't a prototype
xfs_vfs.h:127: syntax error before '*' token
xfs_vfs.h:127: warning: function declaration isn't a prototype
xfs_vfs.h:128: syntax error before '*' token
xfs_vfs.h:128: warning: function declaration isn't a prototype
xfs_vfs.h:131: syntax error before "bhv_position_t"
xfs_vfs.h:131: warning: no semicolon at end of struct or union
xfs_vfs.h:147: syntax error before '}' token
xfs_vfs.h:147: warning: type defaults to `int' in declaration of `bhv_vfsops_t'
xfs_vfs.h:147: warning: data definition has no type or storage class
xfs_vfs.h:188: syntax error before '*' token
xfs_vfs.h:188: warning: function declaration isn't a prototype
xfs_vfs.h:188: `vfs_mount' redeclared as different kind of symbol
xfs_vfs.h:132: previous declaration of `vfs_mount'
xfs_vfs.h:189: syntax error before '*' token
xfs_vfs.h:189: warning: function declaration isn't a prototype
xfs_vfs.h:189: `vfs_parseargs' redeclared as different kind of symbol
xfs_vfs.h:133: previous declaration of `vfs_parseargs'
xfs_vfs.h:190: syntax error before '*' token
xfs_vfs.h:190: warning: function declaration isn't a prototype
xfs_vfs.h:190: `vfs_showargs' redeclared as different kind of symbol
xfs_vfs.h:134: previous declaration of `vfs_showargs'
xfs_vfs.h:191: syntax error before '*' token
xfs_vfs.h:191: warning: function declaration isn't a prototype
xfs_vfs.h:191: `vfs_unmount' redeclared as different kind of symbol
xfs_vfs.h:135: previous declaration of `vfs_unmount'
xfs_vfs.h:192: syntax error before '*' token
xfs_vfs.h:192: warning: function declaration isn't a prototype
xfs_vfs.h:192: `vfs_mntupdate' redeclared as different kind of symbol
xfs_vfs.h:136: previous declaration of `vfs_mntupdate'
xfs_vfs.h:193: syntax error before '*' token
xfs_vfs.h:193: warning: function declaration isn't a prototype
xfs_vfs.h:193: `vfs_root' redeclared as different kind of symbol
xfs_vfs.h:137: previous declaration of `vfs_root'
xfs_vfs.h:194: syntax error before '*' token
xfs_vfs.h:194: warning: function declaration isn't a prototype
xfs_vfs.h:194: `vfs_statvfs' redeclared as different kind of symbol
xfs_vfs.h:138: previous declaration of `vfs_statvfs'
xfs_vfs.h:195: syntax error before '*' token
xfs_vfs.h:195: warning: function declaration isn't a prototype
xfs_vfs.h:195: `vfs_sync' redeclared as different kind of symbol
xfs_vfs.h:139: previous declaration of `vfs_sync'
xfs_vfs.h:196: syntax error before '*' token
xfs_vfs.h:196: warning: function declaration isn't a prototype
xfs_vfs.h:196: `vfs_vget' redeclared as different kind of symbol
xfs_vfs.h:140: previous declaration of `vfs_vget'
xfs_vfs.h:197: syntax error before '*' token
xfs_vfs.h:197: warning: function declaration isn't a prototype
xfs_vfs.h:197: `vfs_dmapiops' redeclared as different kind of symbol
xfs_vfs.h:141: previous declaration of `vfs_dmapiops'
xfs_vfs.h:198: syntax error before '*' token
xfs_vfs.h:198: warning: function declaration isn't a prototype
xfs_vfs.h:198: `vfs_quotactl' redeclared as different kind of symbol
xfs_vfs.h:142: previous declaration of `vfs_quotactl'
xfs_vfs.h:199: syntax error before '*' token
xfs_vfs.h:199: warning: function declaration isn't a prototype
xfs_vfs.h:199: `vfs_get_inode' redeclared as different kind of symbol
xfs_vfs.h:143: previous declaration of `vfs_get_inode'
xfs_vfs.h:200: syntax error before '*' token
xfs_vfs.h:200: warning: function declaration isn't a prototype
xfs_vfs.h:200: `vfs_init_vnode' redeclared as different kind of symbol
xfs_vfs.h:144: previous declaration of `vfs_init_vnode'
xfs_vfs.h:201: syntax error before '*' token
xfs_vfs.h:201: warning: function declaration isn't a prototype
xfs_vfs.h:201: `vfs_force_shutdown' redeclared as different kind of symbol
xfs_vfs.h:145: previous declaration of `vfs_force_shutdown'
xfs_vfs.h:202: syntax error before '*' token
xfs_vfs.h:202: warning: function declaration isn't a prototype
xfs_vfs.h:202: `vfs_freeze' redeclared as different kind of symbol
xfs_vfs.h:146: previous declaration of `vfs_freeze'
xfs_vfs.h:216: syntax error before "bhv_vfsops_t"
xfs_vfs.h:216: warning: no semicolon at end of struct or union
xfs_vfs.h:218: syntax error before '}' token
xfs_vfs.h:218: warning: type defaults to `int' in declaration of
`bhv_module_vfsops_t'
xfs_vfs.h:218: warning: data definition has no type or storage class
xfs_vfs.h:221: syntax error before "bhv_desc_t"
xfs_vfs.h:221: warning: no semicolon at end of struct or union
xfs_vfs.h:223: syntax error before '*' token
xfs_vfs.h:223: warning: type defaults to `int' in declaration of `bm_ops'
xfs_vfs.h:223: warning: data definition has no type or storage class
xfs_vfs.h:224: syntax error before '}' token
xfs_vfs.h:224: warning: type defaults to `int' in declaration of `bhv_module_t'
xfs_vfs.h:224: warning: data definition has no type or storage class
xfs_vfs.h:231: syntax error before '*' token
xfs_vfs.h:231: warning: type defaults to `int' in declaration of `vfs_allocate'
xfs_vfs.h:231: warning: data definition has no type or storage class
xfs_vfs.h:232: syntax error before '*' token
xfs_vfs.h:232: warning: type defaults to `int' in declaration of `vfs_from_sb'
xfs_vfs.h:232: warning: data definition has no type or storage class
xfs_vfs.h:233: syntax error before '*' token
xfs_vfs.h:233: warning: function declaration isn't a prototype
xfs_vfs.h:234: syntax error before '*' token
xfs_vfs.h:234: warning: function declaration isn't a prototype
In file included from ../linux-2.4/xfs_linux.h:112,
                 from ../xfs.h:48,
                 from xfs_stats.c:19:
xfs_vnode.h:43: syntax error before "bhv_vfs_t"
xfs_vnode.h:43: warning: no semicolon at end of struct or union
xfs_vnode.h:45: syntax error before "v_bh"
xfs_vnode.h:45: warning: type defaults to `int' in declaration of `v_bh'
xfs_vnode.h:45: warning: data definition has no type or storage class
xfs_vnode.h:52: syntax error before '}' token
xfs_vnode.h:52: warning: type defaults to `int' in declaration of `bhv_vnode_t'
xfs_vnode.h:52: warning: data definition has no type or storage class
xfs_vnode.h: In function `vn_from_inode':
xfs_vnode.h:92: syntax error before ')' token
xfs_vnode.h:92: syntax error before ')' token
xfs_vnode.h:92: syntax error before ')' token
xfs_vnode.h: In function `vn_to_inode':
xfs_vnode.h:96: dereferencing pointer to incomplete type
xfs_vnode.h: At top level:
xfs_vnode.h:132: syntax error before '*' token
xfs_vnode.h:132: warning: function declaration isn't a prototype
xfs_vnode.h:133: syntax error before '*' token
xfs_vnode.h:133: warning: function declaration isn't a prototype
xfs_vnode.h:134: syntax error before '*' token
xfs_vnode.h:135: warning: function declaration isn't a prototype
xfs_vnode.h:136: syntax error before '*' token
xfs_vnode.h:137: warning: function declaration isn't a prototype
xfs_vnode.h:138: syntax error before '*' token
xfs_vnode.h:139: warning: function declaration isn't a prototype
xfs_vnode.h:140: syntax error before '*' token
xfs_vnode.h:141: warning: function declaration isn't a prototype
xfs_vnode.h:142: syntax error before '*' token
xfs_vnode.h:143: warning: function declaration isn't a prototype
xfs_vnode.h:144: syntax error before '*' token
xfs_vnode.h:144: warning: function declaration isn't a prototype
xfs_vnode.h:145: syntax error before '*' token
xfs_vnode.h:146: warning: function declaration isn't a prototype
xfs_vnode.h:147: syntax error before '*' token
xfs_vnode.h:148: warning: function declaration isn't a prototype
xfs_vnode.h:149: syntax error before '*' token
xfs_vnode.h:149: warning: function declaration isn't a prototype
xfs_vnode.h:150: syntax error before '*' token
xfs_vnode.h:151: warning: function declaration isn't a prototype
xfs_vnode.h:152: syntax error before '*' token
xfs_vnode.h:153: warning: function declaration isn't a prototype
xfs_vnode.h:154: syntax error before '*' token
xfs_vnode.h:155: warning: function declaration isn't a prototype
xfs_vnode.h:156: syntax error before '*' token
xfs_vnode.h:156: warning: function declaration isn't a prototype
xfs_vnode.h:157: syntax error before '*' token
xfs_vnode.h:158: warning: function declaration isn't a prototype
xfs_vnode.h:159: syntax error before '*' token
xfs_vnode.h:160: warning: function declaration isn't a prototype
xfs_vnode.h:161: syntax error before '*' token
xfs_vnode.h:162: warning: function declaration isn't a prototype
xfs_vnode.h:163: syntax error before '*' token
xfs_vnode.h:164: warning: function declaration isn't a prototype
xfs_vnode.h:165: syntax error before '*' token
xfs_vnode.h:165: warning: function declaration isn't a prototype
xfs_vnode.h:166: syntax error before '*' token
xfs_vnode.h:166: warning: function declaration isn't a prototype
xfs_vnode.h:167: syntax error before '*' token
xfs_vnode.h:167: warning: function declaration isn't a prototype
xfs_vnode.h:168: syntax error before '*' token
xfs_vnode.h:168: warning: function declaration isn't a prototype
xfs_vnode.h:169: syntax error before '*' token
xfs_vnode.h:169: warning: function declaration isn't a prototype
xfs_vnode.h:170: syntax error before '*' token
xfs_vnode.h:171: warning: function declaration isn't a prototype
xfs_vnode.h:172: syntax error before '*' token
xfs_vnode.h:173: warning: function declaration isn't a prototype
xfs_vnode.h:174: syntax error before '*' token
xfs_vnode.h:174: warning: function declaration isn't a prototype
xfs_vnode.h:175: syntax error before '*' token
xfs_vnode.h:176: warning: function declaration isn't a prototype
xfs_vnode.h:177: syntax error before '*' token
xfs_vnode.h:178: warning: function declaration isn't a prototype
xfs_vnode.h:179: syntax error before '*' token
xfs_vnode.h:180: warning: function declaration isn't a prototype
xfs_vnode.h:181: syntax error before '*' token
xfs_vnode.h:182: warning: function declaration isn't a prototype
xfs_vnode.h:183: syntax error before '*' token
xfs_vnode.h:183: warning: function declaration isn't a prototype
xfs_vnode.h:184: syntax error before '*' token
xfs_vnode.h:184: warning: function declaration isn't a prototype
xfs_vnode.h:185: syntax error before '*' token
xfs_vnode.h:185: warning: function declaration isn't a prototype
xfs_vnode.h:186: syntax error before '*' token
xfs_vnode.h:186: warning: function declaration isn't a prototype
xfs_vnode.h:187: syntax error before '*' token
xfs_vnode.h:188: warning: function declaration isn't a prototype
xfs_vnode.h:189: syntax error before '*' token
xfs_vnode.h:189: warning: function declaration isn't a prototype
xfs_vnode.h:192: syntax error before "bhv_position_t"
xfs_vnode.h:192: warning: no semicolon at end of struct or union
xfs_vnode.h:230: syntax error before '}' token
xfs_vnode.h:230: warning: type defaults to `int' in declaration of
`bhv_vnodeops_t'
xfs_vnode.h:230: warning: data definition has no type or storage class
xfs_vnode.h:421: syntax error before '*' token
xfs_vnode.h:421: warning: type defaults to `int' in declaration of
`vn_initialize'
xfs_vnode.h:421: warning: data definition has no type or storage class
xfs_vnode.h:438: syntax error before '*' token
xfs_vnode.h:438: warning: type defaults to `int' in declaration of `vn_hold'
xfs_vnode.h:438: warning: data definition has no type or storage class
xfs_vnode.h: In function `vn_flagset':
xfs_vnode.h:473: dereferencing pointer to incomplete type
xfs_vnode.h:474: dereferencing pointer to incomplete type
xfs_vnode.h:475: dereferencing pointer to incomplete type
xfs_vnode.h: In function `vn_flagclr':
xfs_vnode.h:482: dereferencing pointer to incomplete type
xfs_vnode.h:483: dereferencing pointer to incomplete type
xfs_vnode.h:484: dereferencing pointer to incomplete type
xfs_vnode.h:485: dereferencing pointer to incomplete type
xfs_vnode.h: In function `vn_atime_to_bstime':
xfs_vnode.h:515: dereferencing pointer to incomplete type
xfs_vnode.h: In function `vn_atime_to_timespec':
xfs_vnode.h:521: dereferencing pointer to incomplete type
xfs_vnode.h: In function `vn_atime_to_time_t':
xfs_vnode.h:527: dereferencing pointer to incomplete type
In file included from ../linux-2.4/xfs_linux.h:115,
                 from ../xfs.h:48,
                 from xfs_stats.c:19:
xfs_iops.h: At top level:
xfs_iops.h:35: warning: `struct bhv_desc' declared inside parameter list
xfs_iops.h:35: warning: its scope is only this definition or
declaration, which is probably not what you want
In file included from ../linux-2.4/xfs_linux.h:116,
                 from ../xfs.h:48,
                 from xfs_stats.c:19:
xfs_super.h:79: syntax error before '*' token
xfs_super.h:79: warning: function declaration isn't a prototype
xfs_super.h:80: syntax error before '*' token
xfs_super.h:80: warning: function declaration isn't a prototype
In file included from ../linux-2.4/xfs_linux.h:118,
                 from ../xfs.h:48,
                 from xfs_stats.c:19:
xfs_fs_subr.h:25: syntax error before '*' token
xfs_fs_subr.h:25: warning: function declaration isn't a prototype
xfs_fs_subr.h:26: syntax error before '*' token
xfs_fs_subr.h:26: warning: function declaration isn't a prototype
xfs_fs_subr.h:27: syntax error before '*' token
xfs_fs_subr.h:27: warning: function declaration isn't a prototype
xfs_stats.c:24: syntax error before "int"
make[4]: *** [xfs_stats.o] Error 1
make[4]: Leaving directory `/usr/src/linux-2.4-xfs/fs/xfs/linux-2.4'
make[3]: *** [first_rule] Error 2
make[3]: Leaving directory `/usr/src/linux-2.4-xfs/fs/xfs/linux-2.4'
make[2]: *** [_subdir_linux-2.4] Error 2
make[2]: Leaving directory `/usr/src/linux-2.4-xfs/fs/xfs'
make[1]: *** [_subdir_xfs] Error 2
make[1]: Leaving directory `/usr/src/linux-2.4-xfs/fs'
make: *** [_dir_fs] Error 2

I hope you can help,
Kevin

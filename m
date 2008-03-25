Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 25 Mar 2008 10:56:13 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m2PHtabl011175
	for <xfs@oss.sgi.com>; Tue, 25 Mar 2008 10:55:37 -0700
Received: from smtp7-g19.free.fr (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1667F6E644D
	for <xfs@oss.sgi.com>; Tue, 25 Mar 2008 10:56:05 -0700 (PDT)
Received: from smtp7-g19.free.fr (smtp7-g19.free.fr [212.27.42.64]) by cuda.sgi.com with ESMTP id e0a8obzoC1NGlECw for <xfs@oss.sgi.com>; Tue, 25 Mar 2008 10:56:05 -0700 (PDT)
Received: from smtp7-g19.free.fr (localhost [127.0.0.1])
	by smtp7-g19.free.fr (Postfix) with ESMTP id 26880322842
	for <xfs@oss.sgi.com>; Tue, 25 Mar 2008 18:56:04 +0100 (CET)
Received: from galadriel.home (pla78-1-82-235-234-79.fbx.proxad.net [82.235.234.79])
	by smtp7-g19.free.fr (Postfix) with ESMTP id AA6B532288C
	for <xfs@oss.sgi.com>; Tue, 25 Mar 2008 18:55:43 +0100 (CET)
Date: Tue, 25 Mar 2008 18:54:53 +0100
From: Emmanuel Florac <eflorac@intellique.com>
Subject: Serious XFS crash
Message-ID: <20080325185453.3a1957dd@galadriel.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com


Here is the setup : Debian sarge running kernel 2.6.18.8 smp (clean
build), xfsprogs version 2.6.20 (not used). An 8TB xfs filesystem broke
apart losing roughly 2TB of data in about 350 (big) files :

Mar 22 12:38:18 system3 kernel: 0x0: c0 49 00 35 6a bc c3 80 fd d4 64
f8 16 ec b9 85 
Mar 22 12:38:18 system3 kernel: Filesystem "md0": XFS internal error
xfs_da_do_buf(2) at line 2084 of file fs/xfs/xfs_da_btree.c.  Caller
0xc0214fe8
Mar 22 12:38:18 system3 kernel:  [xfs_da_do_buf+958/2144]
xfs_da_do_buf+0x3be/0x860
Mar 22 12:38:18 system3 kernel:  [xfs_da_read_buf+72/96]
xfs_da_read_buf+0x48/0x60
Mar 22 12:38:18 system3 kernel:  [xfs_da_read_buf+72/96]
xfs_da_read_buf+0x48/0x60
Mar 22 12:38:18 system3 kernel:  [_atomic_dec_and_lock+59/96]
_atomic_dec_and_lock+0x3b/0x60
Mar 22 12:38:18 system3 kernel:  [xfs_da_read_buf+72/96]
xfs_da_read_buf+0x48/0x60
Mar 22 12:38:18 system3 kernel:  [xfs_dir2_leaf_getdents+934/3072]
xfs_dir2_leaf_getdents+0x3a6/0xc00
Mar 22 12:38:18 system3 kernel:  [xfs_dir2_leaf_getdents+934/3072]
xfs_dir2_leaf_getdents+0x3a6/0xc00
Mar 22 12:38:18 system3 kernel:  [xfs_dir_getdents+242/320]
xfs_dir_getdents+0xf2/0x140
Mar 22 12:38:18 system3 kernel:  [xfs_dir2_put_dirent64_direct+0/144]
xfs_dir2_put_dirent64_direct+0x0/0x90
Mar 22 12:38:18 system3 kernel:  [xfs_dir2_put_dirent64_direct+0/144]
xfs_dir2_put_dirent64_direct+0x0/0x90
Mar 22 12:38:18 system3 kernel:  [xfs_readdir+72/112]
xfs_readdir+0x48/0x70
Mar 22 12:38:18 system3 kernel:  [xfs_file_readdir+256/528]
xfs_file_readdir+0x100/0x210
Mar 22 12:38:18 system3 kernel:  [filldir64+0/240] filldir64+0x0/0xf0
Mar 22 12:38:18 system3 kernel:  [filldir64+0/240] filldir64+0x0/0xf0
Mar 22 12:38:18 system3 kernel:  [vfs_readdir+129/160]
vfs_readdir+0x81/0xa0
Mar 22 12:38:18 system3 kernel:  [sys_getdents64+105/192]
sys_getdents64+0x69/0xc0
Mar 22 12:38:18 system3 kernel:  [syscall_call+7/11]
syscall_call+0x7/0xb
Mar 22 12:38:18 system3 kernel: 0x0: c0 49 00 35 6a bc c3 80 fd d4 64
f8 16 ec b9 85 

At that point, the filesystem was completely unreadable. However, df
reported about 2TB used.

As a precaution, I booted with a live CD with xfsprogs 2.8.11. I first
ran xfs_repair -n :

No modify flag set, skipping phase 5
Phase 1 - find and verify superblock...
Phase 2 - using internal log
        - scan filesystem freespace and inode maps...
bad magic # 0x7c6999f7 for agf 0
bad version # 270461846 for agf 0
bad sequence # -506160237 for agf 0
bad length 1130385756 for agf 0, should be 68590288
flfirst 260475029 in agf 0 too large (max = 128)
fllast -1448142937 in agf 0 too large (max = 128)
bad magic # 0xfffde400 for agi 0
bad version # -1469688457 for agi 0
bad sequence # 2021095287 for agi 0
bad length # 2004318207 for agi 0, should be 68590288
would reset bad agf for ag 0
would reset bad agi for ag 0
bad uncorrected agheader 0, skipping ag...
root inode chunk not found
Phase 3 - for each AG...
        - scan (but don't clear) agi unlinked lists...
error following ag 0 unlinked list
        - process known inodes and perform inode discovery...
        - agno = 0
bad magic number 0xeb51 on inode 288
bad version number 0x0 on inode 288
bad (negative) size -4597490693634830737 on inode 288
bad magic number 0xf162 on inode 289
bad version number 0x21 on inode 289
bad inode format in inode 289
bad magic number 0x1c02 on inode 290
bad version number 0xffffff80 on inode 290
bad (negative) size -1479238237238013911 on inode 290
bad magic number 0xdd on inode 291
bad version number 0xffffffe3 on inode 291
bad (negative) size -3643988304669136675 on inode 291
bad magic number 0xf884 on inode 292
bad version number 0xffffffd9 on inode 292
bad inode format in inode 292
bad magic number 0x181f on inode 293
bad version number 0xfffffff4 on inode 293
bad inode format in inode 293
bad magic number 0x970 on inode 294
bad version number 0xffffffa3 on inode 294
bad (negative) size -445852040749451058 on inode 294
bad magic number 0x3cde on inode 295
bad version number 0xffffff99 on inode 295
bad inode format in inode 295
bad magic number 0x396 on inode 296
bad version number 0xffffffc0 on inode 296
bad inode format in inode 296
bad magic number 0xe27b on inode 297
bad version number 0x11 on inode 297
bad inode format in inode 297
bad magic number 0xde24 on inode 298
bad version number 0xffffff80 on inode 298
bad (negative) size -4386485681027605669 on inode 298
bad magic number 0xe0c0 on inode 299
bad version number 0xfffffff6 on inode 299
bad inode format in inode 299
bad magic number 0x18f on inode 300
bad version number 0x6d on inode 300
bad inode format in inode 300
bad magic number 0x2fa6 on inode 301
bad version number 0xffffffe0 on inode 301
bad inode format in inode 301
bad magic number 0x874 on inode 302
bad version number 0x17 on inode 302
bad inode format in inode 302
bad magic number 0xc020 on inode 303
bad version number 0xffffffad on inode 303
bad (negative) size -2828235057529281131 on inode 303
bad magic number 0xdb62 on inode 304
bad version number 0xffffffb4 on inode 304
bad inode format in inode 304
bad magic number 0x1ec8 on inode 305
bad version number 0x1f on inode 305
bad inode format in inode 305
bad magic number 0x1ece on inode 306
bad version number 0xffffff80 on inode 306
bad (negative) size -4841365767938555696 on inode 306
bad magic number 0x2174 on inode 307
bad version number 0xffffff80 on inode 307
bad (negative) size -5167479495107527569 on inode 307
bad magic number 0x42ff on inode 308
bad version number 0x2e on inode 308
bad inode format in inode 308
bad magic number 0x2300 on inode 309
bad version number 0x13 on inode 309
bad inode format in inode 309
bad magic number 0xd009 on inode 310
bad version number 0x41 on inode 310
bad inode format in inode 310
bad magic number 0xde60 on inode 311
bad version number 0xfffffff3 on inode 311
bad (negative) size -667991506409959991 on inode 311
bad magic number 0x29ad on inode 312
bad version number 0x2e on inode 312
bad (negative) size -7260113882208003448 on inode 312
bad magic number 0x4b6a on inode 313
bad version number 0x3c on inode 313
bad (negative) size -1729319129454037310 on inode 313
bad magic number 0xcf81 on inode 314
bad version number 0x38 on inode 314
bad inode format in inode 314
bad magic number 0xa003 on inode 315
bad version number 0xfffffff1 on inode 315
bad inode format in inode 315
bad magic number 0x8c04 on inode 316
bad version number 0xfffffff3 on inode 316
bad (negative) size -3070587920707903991 on inode 316
bad magic number 0x3438 on inode 317
bad version number 0xffffffb9 on inode 317
bad (negative) size -8696290035356641328 on inode 317
bad magic number 0x44c on inode 318
bad version number 0xffffff9e on inode 318
bad (negative) size -8776495047018275686 on inode 318
bad magic number 0xe213 on inode 319
bad version number 0x32 on inode 319
bad (negative) size -8318616862220032662 on inode 319
bad directory block magic # 0xe409793 in block 0 for directory inode 256
corrupt block 0 in directory inode 256
	would junk block
no . entry for directory 256
no .. entry for root directory 256
problem with directory contents in inode 256
would clear root inode 256
bad directory block magic # 0xfe95b7b4 in block 0 for directory inode
259 corrupt block 0 in directory inode 259
	would junk block
bad directory block magic # 0xe600e5c0 in block 1 for directory inode
259 corrupt block 1 in directory inode 259
	would junk block
bad directory block magic # 0xc0490035 in block 2 for directory inode
259 corrupt block 2 in directory inode 259
	would junk block
bad directory block magic # 0xc079afae in block 3 for directory inode
259 corrupt block 3 in directory inode 259
	would junk block
no . entry for directory 259
no .. entry for directory 259
problem with directory contents in inode 259
would have cleared inode 259
imap claims in-use inode 260 is free, would correct imap
bad directory block magic # 0x7acda06 in block 0 for directory inode 261
corrupt block 0 in directory inode 261
	would junk block
no . entry for directory 261
no .. entry for directory 261
problem with directory contents in inode 261
would have cleared inode 261
imap claims in-use inode 262 is free, would correct imap
imap claims in-use inode 263 is free, would correct imap
imap claims in-use inode 264 is free, would correct imap
imap claims in-use inode 265 is free, would correct imap
imap claims in-use inode 266 is free, would correct imap
imap claims in-use inode 267 is free, would correct imap
imap claims in-use inode 268 is free, would correct imap
imap claims in-use inode 269 is free, would correct imap
imap claims in-use inode 270 is free, would correct imap
imap claims in-use inode 271 is free, would correct imap
imap claims in-use inode 272 is free, would correct imap
imap claims in-use inode 273 is free, would correct imap
imap claims in-use inode 274 is free, would correct imap
imap claims in-use inode 275 is free, would correct imap
imap claims in-use inode 276 is free, would correct imap
imap claims in-use inode 277 is free, would correct imap
imap claims in-use inode 278 is free, would correct imap
imap claims in-use inode 279 is free, would correct imap
imap claims in-use inode 280 is free, would correct imap
imap claims in-use inode 281 is free, would correct imap
imap claims in-use inode 282 is free, would correct imap
imap claims in-use inode 283 is free, would correct imap
imap claims in-use inode 284 is free, would correct imap
imap claims in-use inode 285 is free, would correct imap
imap claims in-use inode 286 is free, would correct imap
imap claims in-use inode 287 is free, would correct imap
bad magic number 0xeb51 on inode 288, would reset magic number
bad version number 0x0 on inode 288, would reset version number
bad (negative) size -4597490693634830737 on inode 288
would have cleared inode 288
bad magic number 0xf162 on inode 289, would reset magic number
bad version number 0x21 on inode 289, would reset version number
bad inode format in inode 289
would have cleared inode 289
bad magic number 0x1c02 on inode 290, would reset magic number
bad version number 0xffffff80 on inode 290, would reset version number
bad (negative) size -1479238237238013911 on inode 290
would have cleared inode 290
bad magic number 0xdd on inode 291, would reset magic number
bad version number 0xffffffe3 on inode 291, would reset version number
bad (negative) size -3643988304669136675 on inode 291
would have cleared inode 291
bad magic number 0xf884 on inode 292, would reset magic number
bad version number 0xffffffd9 on inode 292, would reset version number
bad inode format in inode 292
would have cleared inode 292
bad magic number 0x181f on inode 293, would reset magic number
bad version number 0xfffffff4 on inode 293, would reset version number
bad inode format in inode 293
would have cleared inode 293
bad magic number 0x970 on inode 294, would reset magic number
bad version number 0xffffffa3 on inode 294, would reset version number
bad (negative) size -445852040749451058 on inode 294
would have cleared inode 294
bad magic number 0x3cde on inode 295, would reset magic number
bad version number 0xffffff99 on inode 295, would reset version number
bad inode format in inode 295
would have cleared inode 295
bad magic number 0x396 on inode 296, would reset magic number
bad version number 0xffffffc0 on inode 296, would reset version number
bad inode format in inode 296
would have cleared inode 296
bad magic number 0xe27b on inode 297, would reset magic number
bad version number 0x11 on inode 297, would reset version number
bad inode format in inode 297
would have cleared inode 297
bad magic number 0xde24 on inode 298, would reset magic number
bad version number 0xffffff80 on inode 298, would reset version number
bad (negative) size -4386485681027605669 on inode 298
would have cleared inode 298
bad magic number 0xe0c0 on inode 299, would reset magic number
bad version number 0xfffffff6 on inode 299, would reset version number
bad inode format in inode 299
would have cleared inode 299
bad magic number 0x18f on inode 300, would reset magic number
bad version number 0x6d on inode 300, would reset version number
bad inode format in inode 300
would have cleared inode 300
bad magic number 0x2fa6 on inode 301, would reset magic number
bad version number 0xffffffe0 on inode 301, would reset version number
bad inode format in inode 301
would have cleared inode 301
bad magic number 0x874 on inode 302, would reset magic number
bad version number 0x17 on inode 302, would reset version number
bad inode format in inode 302
would have cleared inode 302
bad magic number 0xc020 on inode 303, would reset magic number
bad version number 0xffffffad on inode 303, would reset version number
bad (negative) size -2828235057529281131 on inode 303
would have cleared inode 303
bad magic number 0xdb62 on inode 304, would reset magic number
bad version number 0xffffffb4 on inode 304, would reset version number
bad inode format in inode 304
would have cleared inode 304
bad magic number 0x1ec8 on inode 305, would reset magic number
bad version number 0x1f on inode 305, would reset version number
bad inode format in inode 305
would have cleared inode 305
bad magic number 0x1ece on inode 306, would reset magic number
bad version number 0xffffff80 on inode 306, would reset version number
bad (negative) size -4841365767938555696 on inode 306
would have cleared inode 306
bad magic number 0x2174 on inode 307, would reset magic number
bad version number 0xffffff80 on inode 307, would reset version number
bad (negative) size -5167479495107527569 on inode 307
would have cleared inode 307
bad magic number 0x42ff on inode 308, would reset magic number
bad version number 0x2e on inode 308, would reset version number
bad inode format in inode 308
would have cleared inode 308
bad magic number 0x2300 on inode 309, would reset magic number
bad version number 0x13 on inode 309, would reset version number
bad inode format in inode 309
would have cleared inode 309
bad magic number 0xd009 on inode 310, would reset magic number
bad version number 0x41 on inode 310, would reset version number
bad inode format in inode 310
would have cleared inode 310
bad magic number 0xde60 on inode 311, would reset magic number
bad version number 0xfffffff3 on inode 311, would reset version number
bad (negative) size -667991506409959991 on inode 311
would have cleared inode 311
bad magic number 0x29ad on inode 312, would reset magic number
bad version number 0x2e on inode 312, would reset version number
bad (negative) size -7260113882208003448 on inode 312
would have cleared inode 312
bad magic number 0x4b6a on inode 313, would reset magic number
bad version number 0x3c on inode 313, would reset version number
bad (negative) size -1729319129454037310 on inode 313
would have cleared inode 313
bad magic number 0xcf81 on inode 314, would reset magic number
bad version number 0x38 on inode 314, would reset version number
bad inode format in inode 314
would have cleared inode 314
bad magic number 0xa003 on inode 315, would reset magic number
bad version number 0xfffffff1 on inode 315, would reset version number
bad inode format in inode 315
would have cleared inode 315
bad magic number 0x8c04 on inode 316, would reset magic number
bad version number 0xfffffff3 on inode 316, would reset version number
bad (negative) size -3070587920707903991 on inode 316
would have cleared inode 316
bad magic number 0x3438 on inode 317, would reset magic number
bad version number 0xffffffb9 on inode 317, would reset version number
bad (negative) size -8696290035356641328 on inode 317
would have cleared inode 317
bad magic number 0x44c on inode 318, would reset magic number
bad version number 0xffffff9e on inode 318, would reset version number
bad (negative) size -8776495047018275686 on inode 318
would have cleared inode 318
bad magic number 0xe213 on inode 319, would reset magic number
bad version number 0x32 on inode 319, would reset version number
bad (negative) size -8318616862220032662 on inode 319
would have cleared inode 319
        - agno = 1
        - agno = 2
        - agno = 3
        - agno = 4
        - agno = 5
        - agno = 6
        - agno = 7
        - agno = 8
        - agno = 9
        - agno = 10
        - agno = 11
        - agno = 12
        - agno = 13
        - agno = 14
        - agno = 15
        - agno = 16
        - agno = 17
        - agno = 18
        - agno = 19
        - agno = 20
        - agno = 21
        - agno = 22
        - agno = 23
        - agno = 24
        - agno = 25
        - agno = 26
        - agno = 27
        - agno = 28
        - agno = 29
        - agno = 30
        - agno = 31
        - process newly discovered inodes...
Phase 4 - check for duplicate blocks...
        - setting up duplicate extent list...
root inode would be lost
        - check for inodes claiming duplicate blocks...
        - agno = 0
bad directory block magic # 0xe409793 in block 0 for directory inode 256
corrupt block 0 in directory inode 256
	would junk block
no . entry for directory 256
no .. entry for root directory 256
problem with directory contents in inode 256
would clear root inode 256
bad directory block magic # 0xfe95b7b4 in block 0 for directory inode
259 corrupt block 0 in directory inode 259
	would junk block
bad directory block magic # 0xe600e5c0 in block 1 for directory inode
259 corrupt block 1 in directory inode 259
	would junk block
bad directory block magic # 0xc0490035 in block 2 for directory inode
259 corrupt block 2 in directory inode 259
	would junk block
bad directory block magic # 0xc079afae in block 3 for directory inode
259 corrupt block 3 in directory inode 259
	would junk block
no . entry for directory 259
no .. entry for directory 259
problem with directory contents in inode 259
would have cleared inode 259
bad directory block magic # 0x7acda06 in block 0 for directory inode 261
corrupt block 0 in directory inode 261
	would junk block
no . entry for directory 261
no .. entry for directory 261
problem with directory contents in inode 261
would have cleared inode 261
bad magic number 0xeb51 on inode 288, would reset magic number
bad version number 0x0 on inode 288, would reset version number
bad (negative) size -4597490693634830737 on inode 288
would have cleared inode 288
bad magic number 0xf162 on inode 289, would reset magic number
bad version number 0x21 on inode 289, would reset version number
bad inode format in inode 289
would have cleared inode 289
bad magic number 0x1c02 on inode 290, would reset magic number
bad version number 0xffffff80 on inode 290, would reset version number
bad (negative) size -1479238237238013911 on inode 290
would have cleared inode 290
bad magic number 0xdd on inode 291, would reset magic number
bad version number 0xffffffe3 on inode 291, would reset version number
bad (negative) size -3643988304669136675 on inode 291
would have cleared inode 291
bad magic number 0xf884 on inode 292, would reset magic number
bad version number 0xffffffd9 on inode 292, would reset version number
bad inode format in inode 292
would have cleared inode 292
bad magic number 0x181f on inode 293, would reset magic number
bad version number 0xfffffff4 on inode 293, would reset version number
bad inode format in inode 293
would have cleared inode 293
bad magic number 0x970 on inode 294, would reset magic number
bad version number 0xffffffa3 on inode 294, would reset version number
bad (negative) size -445852040749451058 on inode 294
would have cleared inode 294
bad magic number 0x3cde on inode 295, would reset magic number
bad version number 0xffffff99 on inode 295, would reset version number
bad inode format in inode 295
would have cleared inode 295
bad magic number 0x396 on inode 296, would reset magic number
bad version number 0xffffffc0 on inode 296, would reset version number
bad inode format in inode 296
would have cleared inode 296
bad magic number 0xe27b on inode 297, would reset magic number
bad version number 0x11 on inode 297, would reset version number
bad inode format in inode 297
would have cleared inode 297
bad magic number 0xde24 on inode 298, would reset magic number
bad version number 0xffffff80 on inode 298, would reset version number
bad (negative) size -4386485681027605669 on inode 298
would have cleared inode 298
bad magic number 0xe0c0 on inode 299, would reset magic number
bad version number 0xfffffff6 on inode 299, would reset version number
bad inode format in inode 299
would have cleared inode 299
bad magic number 0x18f on inode 300, would reset magic number
bad version number 0x6d on inode 300, would reset version number
bad inode format in inode 300
would have cleared inode 300
bad magic number 0x2fa6 on inode 301, would reset magic number
bad version number 0xffffffe0 on inode 301, would reset version number
bad inode format in inode 301
would have cleared inode 301
bad magic number 0x874 on inode 302, would reset magic number
bad version number 0x17 on inode 302, would reset version number
bad inode format in inode 302
would have cleared inode 302
bad magic number 0xc020 on inode 303, would reset magic number
bad version number 0xffffffad on inode 303, would reset version number
bad (negative) size -2828235057529281131 on inode 303
would have cleared inode 303
bad magic number 0xdb62 on inode 304, would reset magic number
bad version number 0xffffffb4 on inode 304, would reset version number
bad inode format in inode 304
would have cleared inode 304
bad magic number 0x1ec8 on inode 305, would reset magic number
bad version number 0x1f on inode 305, would reset version number
bad inode format in inode 305
would have cleared inode 305
bad magic number 0x1ece on inode 306, would reset magic number
bad version number 0xffffff80 on inode 306, would reset version number
bad (negative) size -4841365767938555696 on inode 306
would have cleared inode 306
bad magic number 0x2174 on inode 307, would reset magic number
bad version number 0xffffff80 on inode 307, would reset version number
bad (negative) size -5167479495107527569 on inode 307
would have cleared inode 307
bad magic number 0x42ff on inode 308, would reset magic number
bad version number 0x2e on inode 308, would reset version number
bad inode format in inode 308
would have cleared inode 308
bad magic number 0x2300 on inode 309, would reset magic number
bad version number 0x13 on inode 309, would reset version number
bad inode format in inode 309
would have cleared inode 309
bad magic number 0xd009 on inode 310, would reset magic number
bad version number 0x41 on inode 310, would reset version number
bad inode format in inode 310
would have cleared inode 310
bad magic number 0xde60 on inode 311, would reset magic number
bad version number 0xfffffff3 on inode 311, would reset version number
bad (negative) size -667991506409959991 on inode 311
would have cleared inode 311
bad magic number 0x29ad on inode 312, would reset magic number
bad version number 0x2e on inode 312, would reset version number
bad (negative) size -7260113882208003448 on inode 312
would have cleared inode 312
bad magic number 0x4b6a on inode 313, would reset magic number
bad version number 0x3c on inode 313, would reset version number
bad (negative) size -1729319129454037310 on inode 313
would have cleared inode 313
bad magic number 0xcf81 on inode 314, would reset magic number
bad version number 0x38 on inode 314, would reset version number
bad inode format in inode 314
would have cleared inode 314
bad magic number 0xa003 on inode 315, would reset magic number
bad version number 0xfffffff1 on inode 315, would reset version number
bad inode format in inode 315
would have cleared inode 315
bad magic number 0x8c04 on inode 316, would reset magic number
bad version number 0xfffffff3 on inode 316, would reset version number
bad (negative) size -3070587920707903991 on inode 316
would have cleared inode 316
bad magic number 0x3438 on inode 317, would reset magic number
bad version number 0xffffffb9 on inode 317, would reset version number
bad (negative) size -8696290035356641328 on inode 317
would have cleared inode 317
bad magic number 0x44c on inode 318, would reset magic number
bad version number 0xffffff9e on inode 318, would reset version number
bad (negative) size -8776495047018275686 on inode 318
would have cleared inode 318
bad magic number 0xe213 on inode 319, would reset magic number
bad version number 0x32 on inode 319, would reset version number
bad (negative) size -8318616862220032662 on inode 319
would have cleared inode 319
        - agno = 1
entry "S0045230.mpg" in shortform directory 2147483905 references
non-existent inode 505 would have junked entry "S0045230.mpg" in
directory inode 2147483905
        - agno = 2
        - agno = 3
        - agno = 4
        - agno = 5
        - agno = 6
        - agno = 7
        - agno = 8
        - agno = 9
        - agno = 10
        - agno = 11
        - agno = 12
        - agno = 13
        - agno = 14
        - agno = 15
        - agno = 16
        - agno = 17
        - agno = 18
        - agno = 19
        - agno = 20
        - agno = 21
        - agno = 22
        - agno = 23
        - agno = 24
        - agno = 25
        - agno = 26
        - agno = 27
        - agno = 28
        - agno = 29
        - agno = 30
        - agno = 31
No modify flag set, skipping phase 5
Phase 6 - check inode connectivity...
would reinitialize root directory
        - root inode lost, cannot make new one in no modify mode ... 
        - skipping filesystem traversal from / ... 
        - traversing all unattached subtrees ... 
entry "S0045230.mpg" in shortform directory 2147483905 references
non-existent inode 505 would junk entry
entry "S0045230.mpg" in shortform directory 2147483905 references
non-existent inode 505 would junk entry
        - traversals finished ... 
        - moving disconnected inodes to lost+found ... 
disconnected dir inode 260, would move to lost+found
disconnected dir inode 262, would move to lost+found
disconnected inode 263, would move to lost+found
disconnected inode 264, would move to lost+found
disconnected inode 265, would move to lost+found
disconnected inode 266, would move to lost+found
disconnected inode 267, would move to lost+found
disconnected inode 268, would move to lost+found
disconnected inode 269, would move to lost+found
disconnected inode 270, would move to lost+found
disconnected inode 271, would move to lost+found
disconnected inode 272, would move to lost+found
disconnected inode 273, would move to lost+found
disconnected inode 274, would move to lost+found
disconnected inode 275, would move to lost+found
disconnected inode 276, would move to lost+found
disconnected inode 277, would move to lost+found
disconnected inode 278, would move to lost+found
disconnected inode 279, would move to lost+found
disconnected inode 280, would move to lost+found
disconnected inode 281, would move to lost+found
disconnected inode 282, would move to lost+found
disconnected inode 283, would move to lost+found
disconnected inode 284, would move to lost+found
disconnected inode 285, would move to lost+found
disconnected inode 286, would move to lost+found
disconnected inode 287, would move to lost+found
disconnected dir inode 2147483904, would move to lost+found
disconnected dir inode 2147483905, would move to lost+found
disconnected dir inode 2147483906, would move to lost+found
disconnected inode 2147483907, would move to lost+found
disconnected inode 2147483908, would move to lost+found
disconnected dir inode 2147483913, would move to lost+found
Phase 7 - verify link counts...
No modify flag set, skipping filesystem flush and exiting.

Pretty ominous, however I had nothing better to try at the time, So
I've ran the repair (output follows). The result is miserable : only
110GB of data remain in 43 files (more than 300 files missing), all in
lost+found, and the filesystem is still inconsistent ( there is a
circular directory inside :
lost+found/256/lost+found/256/lost+found/256/... ).

Is there any hope to get it repair somewhat more that this (and lose
less data) ?

Here is the actual xfs_repair output:
Phase 1 - find and verify superblock...
Phase 2 - using internal log
        - zero log...
        - scan filesystem freespace and inode maps...
bad magic # 0x7c6999f7 for agf 0
bad version # 270461846 for agf 0
bad sequence # -506160237 for agf 0
bad length 1130385756 for agf 0, should be 68590288
flfirst 260475029 in agf 0 too large (max = 128)
fllast -1448142937 in agf 0 too large (max = 128)
bad magic # 0xfffde400 for agi 0
bad version # -1469688457 for agi 0
bad sequence # 2021095287 for agi 0
bad length # 2004318207 for agi 0, should be 68590288
reset bad agf for ag 0
reset bad agi for ag 0
bad agbno 2884332844 in agfl, agno 0
freeblk count 1 != flcount -1553133201 in ag 0
bad agbno 2555134669 for btbno root, agno 0
bad agbno 613251981 for btbcnt root, agno 0
bad agbno 1073741824 for inobt root, agno 0
root inode chunk not found
Phase 3 - for each AG...
        - scan and clear agi unlinked lists...
error following ag 0 unlinked list
        - process known inodes and perform inode discovery...
        - agno = 0
bad magic number 0xeb51 on inode 288
bad version number 0x0 on inode 288
bad (negative) size -4597490693634830737 on inode 288
bad magic number 0xf162 on inode 289
bad version number 0x21 on inode 289
bad inode format in inode 289
bad magic number 0x1c02 on inode 290
bad version number 0xffffff80 on inode 290
bad (negative) size -1479238237238013911 on inode 290
bad magic number 0xdd on inode 291
bad version number 0xffffffe3 on inode 291
bad (negative) size -3643988304669136675 on inode 291
bad magic number 0xf884 on inode 292
bad version number 0xffffffd9 on inode 292
bad inode format in inode 292
bad magic number 0x181f on inode 293
bad version number 0xfffffff4 on inode 293
bad inode format in inode 293
bad magic number 0x970 on inode 294
bad version number 0xffffffa3 on inode 294
bad (negative) size -445852040749451058 on inode 294
bad magic number 0x3cde on inode 295
bad version number 0xffffff99 on inode 295
bad inode format in inode 295
bad magic number 0x396 on inode 296
bad version number 0xffffffc0 on inode 296
bad inode format in inode 296
bad magic number 0xe27b on inode 297
bad version number 0x11 on inode 297
bad inode format in inode 297
bad magic number 0xde24 on inode 298
bad version number 0xffffff80 on inode 298
bad (negative) size -4386485681027605669 on inode 298
bad magic number 0xe0c0 on inode 299
bad version number 0xfffffff6 on inode 299
bad inode format in inode 299
bad magic number 0x18f on inode 300
bad version number 0x6d on inode 300
bad inode format in inode 300
bad magic number 0x2fa6 on inode 301
bad version number 0xffffffe0 on inode 301
bad inode format in inode 301
bad magic number 0x874 on inode 302
bad version number 0x17 on inode 302
bad inode format in inode 302
bad magic number 0xc020 on inode 303
bad version number 0xffffffad on inode 303
bad (negative) size -2828235057529281131 on inode 303
bad magic number 0xdb62 on inode 304
bad version number 0xffffffb4 on inode 304
bad inode format in inode 304
bad magic number 0x1ec8 on inode 305
bad version number 0x1f on inode 305
bad inode format in inode 305
bad magic number 0x1ece on inode 306
bad version number 0xffffff80 on inode 306
bad (negative) size -4841365767938555696 on inode 306
bad magic number 0x2174 on inode 307
bad version number 0xffffff80 on inode 307
bad (negative) size -5167479495107527569 on inode 307
bad magic number 0x42ff on inode 308
bad version number 0x2e on inode 308
bad inode format in inode 308
bad magic number 0x2300 on inode 309
bad version number 0x13 on inode 309
bad inode format in inode 309
bad magic number 0xd009 on inode 310
bad version number 0x41 on inode 310
bad inode format in inode 310
bad magic number 0xde60 on inode 311
bad version number 0xfffffff3 on inode 311
bad (negative) size -667991506409959991 on inode 311
bad magic number 0x29ad on inode 312
bad version number 0x2e on inode 312
bad (negative) size -7260113882208003448 on inode 312
bad magic number 0x4b6a on inode 313
bad version number 0x3c on inode 313
bad (negative) size -1729319129454037310 on inode 313
bad magic number 0xcf81 on inode 314
bad version number 0x38 on inode 314
bad inode format in inode 314
bad magic number 0xa003 on inode 315
bad version number 0xfffffff1 on inode 315
bad inode format in inode 315
bad magic number 0x8c04 on inode 316
bad version number 0xfffffff3 on inode 316
bad (negative) size -3070587920707903991 on inode 316
bad magic number 0x3438 on inode 317
bad version number 0xffffffb9 on inode 317
bad (negative) size -8696290035356641328 on inode 317
bad magic number 0x44c on inode 318
bad version number 0xffffff9e on inode 318
bad (negative) size -8776495047018275686 on inode 318
bad magic number 0xe213 on inode 319
bad version number 0x32 on inode 319
bad (negative) size -8318616862220032662 on inode 319
bad directory block magic # 0xe409793 in block 0 for directory inode 256
corrupt block 0 in directory inode 256
	will junk block
no . entry for directory 256
no .. entry for root directory 256
problem with directory contents in inode 256
cleared root inode 256
bad directory block magic # 0xfe95b7b4 in block 0 for directory inode
259 corrupt block 0 in directory inode 259
	will junk block
bad directory block magic # 0xe600e5c0 in block 1 for directory inode
259 corrupt block 1 in directory inode 259
	will junk block
bad directory block magic # 0xc0490035 in block 2 for directory inode
259 corrupt block 2 in directory inode 259
	will junk block
bad directory block magic # 0xc079afae in block 3 for directory inode
259 corrupt block 3 in directory inode 259
	will junk block
no . entry for directory 259
no .. entry for directory 259
problem with directory contents in inode 259
cleared inode 259
imap claims in-use inode 260 is free, correcting imap
bad directory block magic # 0x7acda06 in block 0 for directory inode 261
corrupt block 0 in directory inode 261
	will junk block
no . entry for directory 261
no .. entry for directory 261
problem with directory contents in inode 261
cleared inode 261
imap claims in-use inode 262 is free, correcting imap
imap claims in-use inode 263 is free, correcting imap
imap claims in-use inode 264 is free, correcting imap
imap claims in-use inode 265 is free, correcting imap
imap claims in-use inode 266 is free, correcting imap
imap claims in-use inode 267 is free, correcting imap
imap claims in-use inode 268 is free, correcting imap
imap claims in-use inode 269 is free, correcting imap
imap claims in-use inode 270 is free, correcting imap
imap claims in-use inode 271 is free, correcting imap
imap claims in-use inode 272 is free, correcting imap
imap claims in-use inode 273 is free, correcting imap
imap claims in-use inode 274 is free, correcting imap
imap claims in-use inode 275 is free, correcting imap
imap claims in-use inode 276 is free, correcting imap
imap claims in-use inode 277 is free, correcting imap
imap claims in-use inode 278 is free, correcting imap
imap claims in-use inode 279 is free, correcting imap
imap claims in-use inode 280 is free, correcting imap
imap claims in-use inode 281 is free, correcting imap
imap claims in-use inode 282 is free, correcting imap
imap claims in-use inode 283 is free, correcting imap
imap claims in-use inode 284 is free, correcting imap
imap claims in-use inode 285 is free, correcting imap
imap claims in-use inode 286 is free, correcting imap
imap claims in-use inode 287 is free, correcting imap
bad magic number 0xeb51 on inode 288, resetting magic number
bad version number 0x0 on inode 288, resetting version number
bad (negative) size -4597490693634830737 on inode 288
cleared inode 288
bad magic number 0xf162 on inode 289, resetting magic number
bad version number 0x21 on inode 289, resetting version number
bad inode format in inode 289
cleared inode 289
bad magic number 0x1c02 on inode 290, resetting magic number
bad version number 0xffffff80 on inode 290, resetting version number
bad (negative) size -1479238237238013911 on inode 290
cleared inode 290
bad magic number 0xdd on inode 291, resetting magic number
bad version number 0xffffffe3 on inode 291, resetting version number
bad (negative) size -3643988304669136675 on inode 291
cleared inode 291
bad magic number 0xf884 on inode 292, resetting magic number
bad version number 0xffffffd9 on inode 292, resetting version number
bad inode format in inode 292
cleared inode 292
bad magic number 0x181f on inode 293, resetting magic number
bad version number 0xfffffff4 on inode 293, resetting version number
bad inode format in inode 293
cleared inode 293
bad magic number 0x970 on inode 294, resetting magic number
bad version number 0xffffffa3 on inode 294, resetting version number
bad (negative) size -445852040749451058 on inode 294
cleared inode 294
bad magic number 0x3cde on inode 295, resetting magic number
bad version number 0xffffff99 on inode 295, resetting version number
bad inode format in inode 295
cleared inode 295
bad magic number 0x396 on inode 296, resetting magic number
bad version number 0xffffffc0 on inode 296, resetting version number
bad inode format in inode 296
cleared inode 296
bad magic number 0xe27b on inode 297, resetting magic number
bad version number 0x11 on inode 297, resetting version number
bad inode format in inode 297
cleared inode 297
bad magic number 0xde24 on inode 298, resetting magic number
bad version number 0xffffff80 on inode 298, resetting version number
bad (negative) size -4386485681027605669 on inode 298
cleared inode 298
bad magic number 0xe0c0 on inode 299, resetting magic number
bad version number 0xfffffff6 on inode 299, resetting version number
bad inode format in inode 299
cleared inode 299
bad magic number 0x18f on inode 300, resetting magic number
bad version number 0x6d on inode 300, resetting version number
bad inode format in inode 300
cleared inode 300
bad magic number 0x2fa6 on inode 301, resetting magic number
bad version number 0xffffffe0 on inode 301, resetting version number
bad inode format in inode 301
cleared inode 301
bad magic number 0x874 on inode 302, resetting magic number
bad version number 0x17 on inode 302, resetting version number
bad inode format in inode 302
cleared inode 302
bad magic number 0xc020 on inode 303, resetting magic number
bad version number 0xffffffad on inode 303, resetting version number
bad (negative) size -2828235057529281131 on inode 303
cleared inode 303
bad magic number 0xdb62 on inode 304, resetting magic number
bad version number 0xffffffb4 on inode 304, resetting version number
bad inode format in inode 304
cleared inode 304
bad magic number 0x1ec8 on inode 305, resetting magic number
bad version number 0x1f on inode 305, resetting version number
bad inode format in inode 305
cleared inode 305
bad magic number 0x1ece on inode 306, resetting magic number
bad version number 0xffffff80 on inode 306, resetting version number
bad (negative) size -4841365767938555696 on inode 306
cleared inode 306
bad magic number 0x2174 on inode 307, resetting magic number
bad version number 0xffffff80 on inode 307, resetting version number
bad (negative) size -5167479495107527569 on inode 307
cleared inode 307
bad magic number 0x42ff on inode 308, resetting magic number
bad version number 0x2e on inode 308, resetting version number
bad inode format in inode 308
cleared inode 308
bad magic number 0x2300 on inode 309, resetting magic number
bad version number 0x13 on inode 309, resetting version number
bad inode format in inode 309
cleared inode 309
bad magic number 0xd009 on inode 310, resetting magic number
bad version number 0x41 on inode 310, resetting version number
bad inode format in inode 310
cleared inode 310
bad magic number 0xde60 on inode 311, resetting magic number
bad version number 0xfffffff3 on inode 311, resetting version number
bad (negative) size -667991506409959991 on inode 311
cleared inode 311
bad magic number 0x29ad on inode 312, resetting magic number
bad version number 0x2e on inode 312, resetting version number
bad (negative) size -7260113882208003448 on inode 312
cleared inode 312
bad magic number 0x4b6a on inode 313, resetting magic number
bad version number 0x3c on inode 313, resetting version number
bad (negative) size -1729319129454037310 on inode 313
cleared inode 313
bad magic number 0xcf81 on inode 314, resetting magic number
bad version number 0x38 on inode 314, resetting version number
bad inode format in inode 314
cleared inode 314
bad magic number 0xa003 on inode 315, resetting magic number
bad version number 0xfffffff1 on inode 315, resetting version number
bad inode format in inode 315
cleared inode 315
bad magic number 0x8c04 on inode 316, resetting magic number
bad version number 0xfffffff3 on inode 316, resetting version number
bad (negative) size -3070587920707903991 on inode 316
cleared inode 316
bad magic number 0x3438 on inode 317, resetting magic number
bad version number 0xffffffb9 on inode 317, resetting version number
bad (negative) size -8696290035356641328 on inode 317
cleared inode 317
bad magic number 0x44c on inode 318, resetting magic number
bad version number 0xffffff9e on inode 318, resetting version number
bad (negative) size -8776495047018275686 on inode 318
cleared inode 318
bad magic number 0xe213 on inode 319, resetting magic number
bad version number 0x32 on inode 319, resetting version number
bad (negative) size -8318616862220032662 on inode 319
cleared inode 319
        - agno = 1
        - agno = 2
        - agno = 3
        - agno = 4
        - agno = 5
        - agno = 6
        - agno = 7
        - agno = 8
        - agno = 9
        - agno = 10
        - agno = 11
        - agno = 12
        - agno = 13
        - agno = 14
        - agno = 15
        - agno = 16
        - agno = 17
        - agno = 18
        - agno = 19
        - agno = 20
        - agno = 21
        - agno = 22
        - agno = 23
        - agno = 24
        - agno = 25
        - agno = 26
        - agno = 27
        - agno = 28
        - agno = 29
        - agno = 30
        - agno = 31
        - process newly discovered inodes...
Phase 4 - check for duplicate blocks...
        - setting up duplicate extent list...
root inode lost
        - clear lost+found (if it exists) ...
        - check for inodes claiming duplicate blocks...
        - agno = 0
        - agno = 1
entry "S0045230.mpg" in shortform directory 2147483905 references
non-existent inode 505 junking entry "S0045230.mpg" in directory inode
2147483905
        - agno = 2
        - agno = 3
        - agno = 4
        - agno = 5
        - agno = 6
        - agno = 7
        - agno = 8
        - agno = 9
        - agno = 10
        - agno = 11
        - agno = 12
        - agno = 13
        - agno = 14
        - agno = 15
        - agno = 16
        - agno = 17
        - agno = 18
        - agno = 19
        - agno = 20
        - agno = 21
        - agno = 22
        - agno = 23
        - agno = 24
        - agno = 25
        - agno = 26
        - agno = 27
        - agno = 28
        - agno = 29
        - agno = 30
        - agno = 31
Phase 5 - rebuild AG headers and trees...
        - reset superblock...
Phase 6 - check inode connectivity...
reinitializing root directory
        - resetting contents of realtime bitmap and summary inodes
        - ensuring existence of lost+found directory
        - traversing filesystem starting at / ... 
        - traversal finished ... 
        - traversing all unattached subtrees ... 
        - traversals finished ... 
        - moving disconnected inodes to lost+found ... 
disconnected inode 256, moving to lost+found
disconnected dir inode 260, moving to lost+found
disconnected dir inode 262, moving to lost+found
disconnected inode 263, moving to lost+found
disconnected inode 264, moving to lost+found
disconnected inode 265, moving to lost+found
disconnected inode 266, moving to lost+found
disconnected inode 267, moving to lost+found
disconnected inode 268, moving to lost+found
disconnected inode 269, moving to lost+found
disconnected inode 270, moving to lost+found
disconnected inode 271, moving to lost+found
disconnected inode 272, moving to lost+found
disconnected inode 273, moving to lost+found
disconnected inode 274, moving to lost+found
disconnected inode 275, moving to lost+found
disconnected inode 276, moving to lost+found
disconnected inode 277, moving to lost+found
disconnected inode 278, moving to lost+found
disconnected inode 279, moving to lost+found
disconnected inode 280, moving to lost+found
disconnected inode 281, moving to lost+found
disconnected inode 282, moving to lost+found
disconnected inode 283, moving to lost+found
disconnected inode 284, moving to lost+found
disconnected inode 285, moving to lost+found
disconnected inode 286, moving to lost+found
disconnected inode 287, moving to lost+found
disconnected dir inode 2147483904, moving to lost+found
disconnected dir inode 2147483905, moving to lost+found
disconnected dir inode 2147483906, moving to lost+found
disconnected inode 2147483907, moving to lost+found
disconnected dir inode 2147483913, moving to lost+found
Phase 7 - verify and correct link counts...
done


-- 
--------------------------------------------------
Emmanuel Florac               www.intellique.com   
--------------------------------------------------

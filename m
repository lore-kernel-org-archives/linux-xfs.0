Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 20 Oct 2006 19:34:45 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k9L2YaaG008452
	for <xfs@oss.sgi.com>; Fri, 20 Oct 2006 19:34:37 -0700
Received: from razor.csbnet.se (razor.csbnet.se [193.11.251.99])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3AFD34B9596
	for <xfs@oss.sgi.com>; Fri, 20 Oct 2006 18:34:52 -0700 (PDT)
Received: from [127.0.0.1] (localhost.localdomain [127.0.0.1])
	by razor.csbnet.se (8.13.8/8.13.8) with ESMTP id k9L1YXKl014527
	for <xfs@oss.sgi.com>; Sat, 21 Oct 2006 03:34:33 +0200
Message-ID: <45397929.8050704@kjellander.com>
Date: Sat, 21 Oct 2006 03:34:33 +0200
From: Carl-Johan Kjellander <carljohan@kjellander.com>
MIME-Version: 1.0
Subject: XFS_WANT_CORRUPTED_GOTO at line 4528 of file fs/xfs/xfs_bmap.c
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

I've been hit by a bug installing FC6test4. It will hold us back upgrading
since we use XFS for our home-dirs at work.

Here is the link to the bug report at redhat's bugzilla:
https://bugzilla.redhat.com/bugzilla/show_bug.cgi?id=211086

Here is dmesg when I try to read the file /var/lib/rpm/Packages:

XFS internal error XFS_WANT_CORRUPTED_GOTO at line 4528 of file
fs/xfs/xfs_bmap.c.  Caller 0xeeb4e6ba
  [<c040571a>] dump_trace+0x69/0x1af
  [<c0405878>] show_trace_log_lvl+0x18/0x2c
  [<c0405e18>] show_trace+0xf/0x11
  [<c0405e47>] dump_stack+0x15/0x17
  [<eeb3128a>] xfs_bmap_read_extents+0x448/0x462 [xfs]
  [<eeb4e6ba>] xfs_iread_extents+0xa0/0xbb [xfs]
  [<eeb2e692>] xfs_bmapi+0x23a/0x1f83 [xfs]
  [<eeb50e1d>] xfs_iomap+0x2e1/0x78d [xfs]
  [<eeb6c52e>] __xfs_get_blocks+0x72/0x237 [xfs]
  [<eeb6c748>] xfs_get_blocks+0x28/0x2d [xfs]
  [<c0484fa9>] do_mpage_readpage+0x282/0x5e2
  [<c048581c>] mpage_readpages+0xac/0x114
  [<c044d03f>] __do_page_cache_readahead+0x124/0x1c8
  [<c044d12f>] blockable_page_cache_readahead+0x4c/0x9f
  [<c044d2da>] page_cache_readahead+0xbf/0x196
  [<c044793b>] do_generic_mapping_read+0x13d/0x49b
  [<c0448573>] __generic_file_aio_read+0x18c/0x1d1
  [<eeb73b3c>] xfs_read+0x294/0x2fc [xfs]
  [<eeb707b7>] xfs_file_aio_read+0x70/0x78 [xfs]
  [<c0465c3a>] do_sync_read+0xc1/0xfb
  [<c04665bc>] vfs_read+0xa6/0x157
  [<c0466a2b>] sys_read+0x41/0x67
  [<c0404ea7>] syscall_call+0x7/0xb
DWARF2 unwinder stuck at syscall_call+0x7/0xb

I have the actual partition bzip:ed.
http://razor.csbnet.se/varfucked.bz2

Unpack it and dd to a 4GB logical volume and try to read from
/var/lib/rpm/Packages

/cjk
-- 
begin 644 carljohan_at_kjellander_dot_com.gif
Y1TE&.#=A(0`F`(```````/___RP`````(0`F```"@XR/!\N<#U.;+MI`<[U(>\!UGQ9BGT%>'D2I
Y*=NX,2@OUF2&<827ILW;^822C>\7!!Z1,!K'B5(6H<SH-"E*TJ3%*/>QI6:7"A>Y?):D2^*U@NCV
R<MOQ=]V(B6>LZYD-_T1U<@3W]A4(^$-W4]A#V")W6#.R"$;IR'@).46BN7$9>5D``#L`

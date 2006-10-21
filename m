Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 21 Oct 2006 10:25:19 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k9LHP7aG003992
	for <xfs@oss.sgi.com>; Sat, 21 Oct 2006 10:25:08 -0700
Received: from ext.agami.com (64.221.212.177.ptr.us.xo.net [64.221.212.177])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1C2C94C1977
	for <xfs@oss.sgi.com>; Sat, 21 Oct 2006 10:24:19 -0700 (PDT)
Received: from agami.com ([192.168.168.146])
	by ext.agami.com (8.12.5/8.12.5) with ESMTP id k9LHOFBF018872
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <xfs@oss.sgi.com>; Sat, 21 Oct 2006 10:24:19 -0700
Received: from mx1.agami.com (mx1.agami.com [10.123.10.30])
	by agami.com (8.12.11/8.12.11) with ESMTP id k9LHO99e012108
	for <xfs@oss.sgi.com>; Sat, 21 Oct 2006 10:24:09 -0700
MIME-Version: 1.0
Subject: RE: XFS_WANT_CORRUPTED_GOTO at line 4528 of file fs/xfs/xfs_bmap.c
Date: Sat, 21 Oct 2006 10:29:12 -0700
Message-ID: <F6C06450CC3FDD46A8E3A711BEF172BE347D0D@mx1.ddns.agami.com>
References: <45397929.8050704@kjellander.com>
From: "Shailendra Tripathi" <stripathi@agami.com>
Content-Type: text/plain
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Carl-Johan Kjellander <carljohan@kjellander.com>, xfs@oss.sgi.com

Hi Carl,
           The best way to see what is going on is to see what log thinks it has. You must have got a message indicating the inode number and other details of the extent as indicated by the source.
 
         if(!rt && !gotp->br_startblock && (*lastxp != NULLEXTNUM <http://fxr.watson.org/fxr/ident?v=linux-2.6.11.8;i=NULLEXTNUM> )) {
               cmn_err <http://fxr.watson.org/fxr/ident?v=linux-2.6.11.8;i=cmn_err> (CE_PANIC <http://fxr.watson.org/fxr/ident?v=linux-2.6.11.8;i=CE_PANIC> ,"Access to block zero: fs: <%s> inode: %lld "
                        "start_block : %llx start_off : %llx blkcnt : %llx "
                       "extent-state : %x \n",
                        (ip <http://fxr.watson.org/fxr/ident?v=linux-2.6.11.8;i=ip> ->i_mount)->m_fsname,(long long)ip <http://fxr.watson.org/fxr/ident?v=linux-2.6.11.8;i=ip> ->i_ino,
                         gotp->br_startblock, gotp->br_startoff,
                         gotp->br_blockcount,gotp->br_state);
        }

 
 
Can you attach the hex dump of complete log with inode and extent information ? I want to see what has gone into the log for the operations on this inode. It could be that the extent map was corrupted just before shutdown or something in recovery screwed up. 
-shailendra
 
From: xfs-bounce@oss.sgi.com on behalf of Carl-Johan Kjellander
Sent: Fri 10/20/2006 6:34 PM
To: xfs@oss.sgi.com
Subject: XFS_WANT_CORRUPTED_GOTO at line 4528 of file fs/xfs/xfs_bmap.c



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






[[HTML alternate version deleted]]

Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id C9786801F
	for <xfs@oss.sgi.com>; Sat, 16 Feb 2013 21:47:21 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 48A8FAC002
	for <xfs@oss.sgi.com>; Sat, 16 Feb 2013 19:47:18 -0800 (PST)
Received: from mail-pa0-f52.google.com (mail-pa0-f52.google.com
	[209.85.220.52]) by cuda.sgi.com with ESMTP id A3e2AuJVRnsuxMto
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Sat, 16 Feb 2013 19:47:16 -0800 (PST)
Received: by mail-pa0-f52.google.com with SMTP id fb1so2321065pad.39
	for <xfs@oss.sgi.com>; Sat, 16 Feb 2013 19:47:16 -0800 (PST)
From: Daniel Browning <db@kavod.com>
Subject: [solved] xfsrestore segfault (was: Re: xfsdump segfault)
Date: Sat, 16 Feb 2013 19:47:13 -0800
References: <201302152220.46756.db@kavod.com> <20130216065111.GV26694@dastard>
	<201302161606.02693.db@kavod.com>
In-Reply-To: <201302161606.02693.db@kavod.com>
MIME-Version: 1.0
Message-Id: <201302161947.13836.db@kavod.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Saturday 16 February 2013 4:06:02 pm Daniel Browning wrote:
> So it appears that a socket is causing the problem. What should I
> try next?

Turns out it was already fixed in git HEAD, so take this email as
my personal vote for releasing 3.1.3 sooner rather than later,
for whatever that's worth. :)

commit 59ad060e8f8c39406838c37360efb5f6c09a9041
Author: Alex Elder <elder@inktank.com>
Date:   Thu Dec 27 08:10:14 2012 -0600

    xfsdump: fix format string in restore_spec()
    
    Nigel Tamplin reported getting a seg fault in xfsrestore when a path
    name was too long.  He correctly diagnosed that the problem was due
    to an extra "%s" format specifier in the format value passed to a
    call to mlog().  This patch corrects that.
    
    Signed-off-by: Alex Elder <elder@inktank.com>
    Reported-by: Nigel Tamplin <ntamplin@codefaber.co.uk>
    Tested-by: Nigel Tamplin <ntamplin@codefaber.co.uk>
    Signed-off-by: Ben Myers <bpm@sgi.com>

diff --git a/restore/content.c b/restore/content.c
index edd00ed..54d933c 100644
--- a/restore/content.c
+++ b/restore/content.c
@@ -7796,7 +7796,7 @@ restore_spec( filehdr_t *fhdrp, rv_t *rvp, char *path )
            if ( strlen( path ) >= sizeof( addr.sun_path )) {
                mlog( MLOG_VERBOSE | MLOG_WARNING, _(
                      "pathname too long for bind of "
-                     "%s ino %llu %s: %s: discarding\n"),
+                     "%s ino %llu %s: discarding\n"),
                      printstr,
                      fhdrp->fh_stat.bs_ino,
                      path );


Dave Chinner helped me further on IRC and suggested gdb. When I
got the stacktrace, Nathan Scott on the channel used it to find
the problem area and the commit that fixed it. I applied just
that one commit to 3.1.2, recompiled, and confirmed that it is
fixed.

For the sake of completeness I'll post the stacktrace anyway
(with a few ellipsis for anonymization).

Thanks again everyone,
--
DB

/sbin/xfsrestore: truncating secondary/[...]/mod_interchange.html from 0 to 22744
/sbin/xfsrestore: drive_simple read( want 32 )
/sbin/xfsrestore: drive_simple return_read_buf( returning 32 )
/sbin/xfsrestore: xlate_extenthdr
/sbin/xfsrestore: read extent hdr size 23040 offset 0 type 4 flags 00000001
/sbin/xfsrestore: read extent hdr type DATA offset 0 sz 23040 flags 1
/sbin/xfsrestore: drive_simple read( want 23040 )
/sbin/xfsrestore: drive_simple return_read_buf( returning 23040 )
/sbin/xfsrestore: drive_simple read( want 32 )
/sbin/xfsrestore: drive_simple return_read_buf( returning 32 )
/sbin/xfsrestore: xlate_extenthdr
/sbin/xfsrestore: read extent hdr size 0 offset 0 type 0 flags 00000001
/sbin/xfsrestore: read extent hdr type LAST offset 0 sz 0 flags 1
/sbin/xfsrestore: drive_simple get_mark( )
/sbin/xfsrestore: drive_simple read( want 256 )
/sbin/xfsrestore: drive_simple return_read_buf( returning 256 )
/sbin/xfsrestore: xlate_bstat
/sbin/xfsrestore: xlate_bstat: pre-xlate
	bs_ino 1705965962454368256
	bs_mode  20060200000
/sbin/xfsrestore: xlate_bstat: post-xlate
	bs_ino 98814635031
	bs_mode  140600
/sbin/xfsrestore: xlate_filehdr: pre-xlate
	fh_offset 0
	fh_flags 33554432
	fh_checksum 3550492224
/sbin/xfsrestore: xlate_filehdr: post-xlate
	fh_offset 0
	fh_flags 2
	fh_checksum 1077321939
/sbin/xfsrestore: read file hdr off 0 flags 0x2 ino 98814635031 mode 0x0000c180
/sbin/xfsrestore: restoring secondary/[...]/etc/socket (98814635031 2812586625)
/sbin/xfsrestore: restoring UNIX domain socket ino 98814635031 secondary/[...]/etc/socket

Program received signal SIGSEGV, Segmentation fault.
[Switching to Thread 0x7ffff211e700 (LWP 23393)]
0x00000033fd8478de in vfprintf () from /lib64/libc.so.6
Missing separate debuginfos, use: debuginfo-install glibc-2.12-1.80.el6_3.6.x86_64 glibc-2.12-1.80.el6_3.7.x86_64 libattr-2.4.44-7.el6.x86_64 
libuuid-2.17.2-12.7.el6_3.x86_64
(gdb) backtrace
#0  0x00000033fd8478de in vfprintf () from /lib64/libc.so.6
#1  0x000000000041b462 in mlog_va (levelarg=<value optimized out>, 
    fmt=0x448068 "pathname too long for bind of %s ino %llu %s: %s: discarding\n", args=0x7ffff211b530) at mlog.c:453
#2  0x000000000041b696 in mlog (levelarg=<value optimized out>, 
    fmt=<value optimized out>) at mlog.c:365
#3  0x000000000042a1dd in restore_spec (cp=<value optimized out>, 
    linkpr=<value optimized out>, 
    path1=0x7fffec0008c0 "secondary/[...]/etc/socket", 
    path2=<value optimized out>) at content.c:7797
#4  restore_file_cb (cp=<value optimized out>, linkpr=<value optimized out>, 
    path1=0x7fffec0008c0 "secondary/[...]/etc/socket", 
    path2=<value optimized out>) at content.c:7299
#5  0x0000000000439d10 in tree_cb_links (ino=98814635031, gen=2812586625, 
    ctime=1358666583, mtime=1322084463, funcp=0x429560 <restore_file_cb>, 
    contextp=0x7ffff211cca0, 
    path1=0x7fffec0008c0 "secondary/[...]/etc/socket", 
    path2=0x7fffec0028d0 "../custom") at tree.c:1870
#6  0x0000000000430f50 in restore_file (thrdix=0) at content.c:7219
#7  applynondirdump (thrdix=0) at content.c:3459
#8  content_stream_restore (thrdix=0) at content.c:2543
#9  0x0000000000418ee6 in childmain (arg1=<value optimized out>) at main.c:1443
#10 0x0000000000407680 in cldmgr_entry (arg1=0x657420) at cldmgr.c:235
#11 0x00000033fdc07851 in start_thread () from /lib64/libpthread.so.0
#12 0x00000033fd8e811d in clone () from /lib64/libc.so.6

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

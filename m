Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id C564E7CA0
	for <xfs@oss.sgi.com>; Sun, 21 Feb 2016 21:17:42 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 3746BAC00F
	for <xfs@oss.sgi.com>; Sun, 21 Feb 2016 19:17:35 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id NwIsHyDmPQXhxNH9 (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Sun, 21 Feb 2016 19:03:11 -0800 (PST)
Date: Mon, 22 Feb 2016 11:03:04 +0800
From: Eryu Guan <eguan@redhat.com>
Subject: xfstests configure error with xfsprogs v4.5-rc1
Message-ID: <20160222030304.GV11419@eguan.usersys.redhat.com>
MIME-Version: 1.0
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
Cc: fstests@vger.kernel.org

Hi,

After upgrading to xfsprogs v4.5-rc1 version, xfstests failed to built
because of configure error:

    checking xfs/xfs.h usability... no
    checking xfs/xfs.h presence... yes
    configure: WARNING: xfs/xfs.h: present but cannot be compiled
    configure: WARNING: xfs/xfs.h:     check for missing prerequisite headers?
    configure: WARNING: xfs/xfs.h: see the Autoconf documentation
    configure: WARNING: xfs/xfs.h:     section "Present But Cannot Be Compiled"
    configure: WARNING: xfs/xfs.h: proceeding with the compiler's result
    checking for xfs/xfs.h... no
    
    FATAL ERROR: cannot find a valid <xfs/xfs.h> header file.
    Run "make install-qa" from the xfsprogs source.

and config.log showed:

    configure:4543: checking xfs/xfs.h usability
    configure:4543: ccache gcc -c -g -O2  conftest.c >&5
    In file included from /usr/include/xfs/xfs.h:37:0,
    		 from conftest.c:73:
    /usr/include/xfs/linux.h:145:1: error: unknown type name 'off64_t'
     typedef off64_t  xfs_off_t;
     ^
    configure:4543: $? = 1

It's the change made by commit cb898f157f84 ("linux.h: Use off64_t
instead of loff_t") introduced this error. If I do the following
modifications xfstests compiles without errors:

diff --git a/include/linux.h b/include/linux.h
index cc0f70c..d66436c 100644
--- a/include/linux.h
+++ b/include/linux.h
@@ -142,7 +142,7 @@ platform_discard_blocks(int fd, uint64_t start, uint64_t len)
 #define EFSCORRUPTED   EUCLEAN /* Filesystem is corrupted */
 #define EFSBADCRC      EBADMSG /* Bad CRC detected */
 
-typedef off64_t                xfs_off_t;
+typedef __off64_t              xfs_off_t;
 typedef __uint64_t     xfs_ino_t;
 typedef __uint32_t     xfs_dev_t;
 typedef __int64_t      xfs_daddr_t;

But I'm not sure if it's a proper fix.

Thanks,
Eryu

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

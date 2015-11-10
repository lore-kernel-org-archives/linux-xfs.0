Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 60EAF7F50
	for <xfs@oss.sgi.com>; Tue, 10 Nov 2015 10:45:11 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id CE33FAC009
	for <xfs@oss.sgi.com>; Tue, 10 Nov 2015 08:45:10 -0800 (PST)
Received: from buxtehude.debian.org (buxtehude.debian.org [140.211.166.26]) by
	cuda.sgi.com with ESMTP id 3FFotjZeRqqoEmWI (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 10 Nov 2015 08:45:07 -0800 (PST)
Subject: Bug#804255: Please update initramfs in postinst
Resent-To: debian-bugs-dist@lists.debian.org
Resent-Message-ID: <handler.804255.B804255.144717373620517@bugs.debian.org>
Date: Tue, 10 Nov 2015 16:41:15 +0000
From: Steve McIntyre <steve@einval.com>
Message-ID: <20151110164115.GG13015@einval.com>
References: <20151106161941.15248.86048.reportbug@tack.local>
	<1822095565.6959319.1447027220334.JavaMail.zimbra@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="2fHTh5uZTiUOsy+g"
Content-Disposition: inline
In-Reply-To: <1822095565.6959319.1447027220334.JavaMail.zimbra@redhat.com>
Reply-To: Steve McIntyre <steve@einval.com>, 804255@bugs.debian.org
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Nathan Scott <nathans@debian.org>
Cc: 804255@bugs.debian.org


--2fHTh5uZTiUOsy+g
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Control: tag -1 +patch

On Sun, Nov 08, 2015 at 07:00:20PM -0500, Nathan Scott wrote:
>Hi Steve,
>
>----- Original Message -----
>> Package: xfsprogs
>> Version: 3.2.1
>> Severity: important
>> Tags: d-i
>> 
>> To make this work well, all filesystem tools packages for filesystems
>> that are likely to be used for / and/or /usr should call
>> "update-initramfs -u" in their postinst. This will
>
>OK.
>
>> I've checked your package and I don't see any update-initramfs
>> calls.
>
>(yep, xfsprogs has no postinst at all IIRC)
>
>> Please add one. If you'd like help doing that postinst work, I
>> can supply a patch - just ask!
>
>That would be great, if you don't mind Steve?  Many thanks!

Here's a debdiff of what I've just built. Ignore the NMU version in
the changelog...

-- 
Steve McIntyre, Cambridge, UK.                                steve@einval.com
The two hard things in computing:
 * naming things
 * cache invalidation
 * off-by-one errors                  -- Stig Sandbeck Mathisen

--2fHTh5uZTiUOsy+g
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="xfsprogs_4.2.0.1.debdiff"

diff -Nru xfsprogs-4.2.0/debian/changelog xfsprogs-4.2.0.1/debian/changelog
--- xfsprogs-4.2.0/debian/changelog	2015-09-11 01:51:36.000000000 +0000
+++ xfsprogs-4.2.0.1/debian/changelog	2015-11-10 16:35:45.000000000 +0000
@@ -1,3 +1,11 @@
+xfsprogs (4.2.0.1) unstable; urgency=low
+
+  * NMU
+  * * Add a postinst to update the initramfs on install/upgrade.
+    (Closes: #804255)
+
+ -- Steve McIntyre <93sam@debian.org>  Tue, 10 Nov 2015 16:33:59 +0000
+
 xfsprogs (4.2.0) unstable; urgency=low
 
   * New upstream release
diff -Nru xfsprogs-4.2.0/debian/postinst xfsprogs-4.2.0.1/debian/postinst
--- xfsprogs-4.2.0/debian/postinst	1970-01-01 00:00:00.000000000 +0000
+++ xfsprogs-4.2.0.1/debian/postinst	2015-11-10 16:35:20.000000000 +0000
@@ -0,0 +1,25 @@
+#!/bin/sh
+
+set -e
+
+case "${1}" in
+	configure)
+		if [ -x /usr/sbin/update-initramfs ] && [ -e /etc/initramfs-tools/initramfs.conf ]
+		then
+			update-initramfs -u
+		fi
+		;;
+
+	abort-upgrade|abort-remove|abort-deconfigure)
+
+		;;
+
+	*)
+		echo "postinst called with unknown argument \`${1}'" >&2
+		exit 1
+		;;
+esac
+
+#DEBHELPER#
+
+exit 0

--2fHTh5uZTiUOsy+g
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--2fHTh5uZTiUOsy+g--

Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o2GMZS8f212402 for <xfs@oss.sgi.com>; Tue, 16 Mar 2010 17:35:28 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 48D3624C9D3
	for <xfs@oss.sgi.com>; Tue, 16 Mar 2010 15:37:04 -0700 (PDT)
Received: from mail.sandeen.net (64-131-60-146.usfamily.net [64.131.60.146])
	by cuda.sgi.com with ESMTP id tXwkBW49BT3Dc5ZK for
	<xfs@oss.sgi.com>; Tue, 16 Mar 2010 15:37:04 -0700 (PDT)
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.4])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mail.sandeen.net (Postfix) with ESMTP id 8E05BA4D3F9
	for <xfs@oss.sgi.com>; Tue, 16 Mar 2010 17:37:03 -0500 (CDT)
Message-ID: <4BA0080F.4030608@sandeen.net>
Date: Tue, 16 Mar 2010 17:37:03 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH] repair: check repair message printflike arguments
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: quoted-printable
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs-oss <xfs@oss.sgi.com>

Unfortunately this lights up warnings like a christmas tree,
but it does catch a few gems like:

scan.c:567: warning: format =91%d=92 expects type =91int=92, but argument 4=
 has type =91const char *=92

passing a string to a %d :(

Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
---

diff --git a/repair/err_protos.h b/repair/err_protos.h
index 6944950..2e3bf97 100644
--- a/repair/err_protos.h
+++ b/repair/err_protos.h
@@ -17,10 +17,12 @@
  */
 =

 /* abort, internal error */
-void  __attribute__((noreturn)) do_abort(char const *, ...);
+void do_abort(char const *, ...)
+	__attribute__((format (printf, 1, 2))) __attribute__((noreturn));
 /* abort, system error */
-void  __attribute__((noreturn)) do_error(char const *, ...);
+void do_error(char const *, ...) __attribute__((noreturn));
+	__attribute__((format (printf, 1, 2))) __attribute__((noreturn));
 /* issue warning */
-void do_warn(char const *, ...);
+void do_warn(char const *, ...) __attribute__ ((format (printf, 1, 2)));
 /* issue log message */
-void do_log(char const *, ...);
+void do_log(char const *, ...) __attribute__ ((format (printf, 1, 2)));

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p44985cf066652 for <xfs@oss.sgi.com>; Wed, 4 May 2011 04:08:07 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id CD0A042CD4F
	for <xfs@oss.sgi.com>; Wed,  4 May 2011 02:11:43 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id ItBvwVgXcjp8R2BI for
	<xfs@oss.sgi.com>; Wed, 04 May 2011 02:11:43 -0700 (PDT)
Date: Wed, 4 May 2011 05:11:41 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: xfs_repair crashing (versions 3.1.4 and 3.1.5)
Message-ID: <20110504091141.GA30330@infradead.org>
References: <BANLkTikh1i3aYgXNZut+AGT-1kz=aqv-Eg@mail.gmail.com>
	<20110419082705.GI23985@dastard>
	<20110419130737.45beb611@destiny.ordissimo>
	<4DB084CE.8020600@sandeen.net>
	<20110422130920.7be686c6@destiny.ordissimo>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110422130920.7be686c6@destiny.ordissimo>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Anisse Astier <anisse@astier.eu>
Cc: Eric Sandeen <sandeen@sandeen.net>, xfs@oss.sgi.com

On Fri, Apr 22, 2011 at 01:09:20PM +0200, Anisse Astier wrote:
> Yep, I figured that much, it just took me a while to get up & running
> another system capable of building xfsprogs.
> 
> Now that I have that, and that I commented the do_warn, xfs_repair is
> still running after the previous failing point:
> [???]
>         - agno = 17
> bad key in bmbt root (is 73434, would reset to 74194) in inode 2283178100 data fork
> bad fwd (right) sibling pointer (saw 145202888 should be NULLDFSBNO)
> bad data fork in inode 2283178100
> would have cleared inode 2283178100
>         - agno = 18
> [???] (ongoing)
> 
> Once this is done, I'll test with %llu instead of %u.
> 
> But please be patient, it's a 900GB filesystem (half-full) with just an 800
> MHz ARM9 processor doing the work, so xfs_repair takes hours to complete.
> Plus I won't have time to do many tests before next week.
> 
> To be continued.

Any updates?

In the meantime I cooked up a little patch (below) to add format string
checking to the repair-internal varargs printing helpers, which produces
a lot of warnings.  A lot of that is different underlying types for
fixes-size 64-bit types, but there's quite a few legit errors there as
well.


Index: xfsprogs-dev/repair/err_protos.h
===================================================================
--- xfsprogs-dev.orig/repair/err_protos.h	2011-04-22 12:45:25.018475622 +0200
+++ xfsprogs-dev/repair/err_protos.h	2011-04-22 12:47:22.014508467 +0200
@@ -17,10 +17,14 @@
  */
 
 /* abort, internal error */
-void  __attribute__((noreturn)) do_abort(char const *, ...);
+void  __attribute__((noreturn)) do_abort(char const *, ...)
+	__attribute__((format(printf,1,2)));
 /* abort, system error */
-void  __attribute__((noreturn)) do_error(char const *, ...);
+void  __attribute__((noreturn)) do_error(char const *, ...)
+	__attribute__((format(printf,1,2)));
 /* issue warning */
-void do_warn(char const *, ...);
+void do_warn(char const *, ...)
+	__attribute__((format(printf,1,2)));
 /* issue log message */
-void do_log(char const *, ...);
+void do_log(char const *, ...)
+	__attribute__((format(printf,1,2)));

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

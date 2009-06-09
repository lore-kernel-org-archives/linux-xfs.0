Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n5903FO3258970 for <xfs@oss.sgi.com>; Mon, 8 Jun 2009 19:03:15 -0500
Received: from postoffice2.aconex.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1CD8D2DEDF5
	for <xfs@oss.sgi.com>; Mon,  8 Jun 2009 17:03:34 -0700 (PDT)
Received: from postoffice2.aconex.com (mail.aconex.com [203.89.202.182]) by
	cuda.sgi.com with ESMTP id KYoQPAbk2P6gdjKv for
	<xfs@oss.sgi.com>; Mon, 08 Jun 2009 17:03:34 -0700 (PDT)
Date: Tue, 9 Jun 2009 10:03:28 +1000 (EST)
From: Nathan Scott <nscott@aconex.com>
Message-ID: <1001284815.6030901244505808497.JavaMail.root@mail-au.aconex.com>
In-Reply-To: <Pine.LNX.4.62.0906051023170.19804@sci.felk.cvut.cz>
Subject: Fwd: Bug#531950: attr: FTBFS on GNU/kFreeBSD
MIME-Version: 1.0
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
To: xfs@oss.sgi.com, agruen@suse.de

Could someone verify and merge this patch?  It looks OK to
me.

thanks!

----- Forwarded Message -----
From: "Petr Salinger" <Petr.Salinger@seznam.cz>
To: submit@bugs.debian.org
Sent: Friday, June 5, 2009 6:45:33 PM GMT +10:00 Canberra / Melbourne / Sydney
Subject: Bug#531950: attr: FTBFS on GNU/kFreeBSD

Package: attr
Severity: important
Version: 1:2.4.43-2
Tags: patch
User: glibc-bsd-devel@lists.alioth.debian.org
Usertags: kfreebsd

Hi,

the current version fails to build on GNU/kFreeBSD.
It is kind of reopen of #414232.
Please use the patch bellow instead of the patch in #414232.

It might look surprisingly, but it is correct for all architectures.

The Linux uses ENODATA and does not define ENOATTR,
the GNU/kFreeBSD uses ENOATTR and does not define ENODATA
in errno.h (similarly as original SGI code).
Therefore the code in attr mainly uses ENOATTR,
see also include/xattr.h.

It would also be nice if you can ask upstream
to include this change.

Thanks in advance


Petr

only in patch2:
unchanged:
--- attr-2.4.43.orig/getfattr/getfattr.c
+++ attr-2.4.43/getfattr/getfattr.c
@@ -93,7 +93,7 @@

  const char *strerror_ea(int err)
  {
-       if (err == ENODATA)
+       if (err == ENOATTR)
                 return _("No such attribute");
         return strerror(err);
  }
only in patch2:
unchanged:
--- attr-2.4.43.orig/setfattr/setfattr.c
+++ attr-2.4.43/setfattr/setfattr.c
@@ -66,7 +66,7 @@

  const char *strerror_ea(int err)
  {
-       if (err == ENODATA)
+       if (err == ENOATTR)
                 return _("No such attribute");
         return strerror(err);
  }




-- 
Nathan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

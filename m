Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n59BCP0f033368 for <xfs@oss.sgi.com>; Tue, 9 Jun 2009 06:12:25 -0500
Received: from relay.felk.cvut.cz (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 737322E09A1
	for <xfs@oss.sgi.com>; Tue,  9 Jun 2009 04:12:44 -0700 (PDT)
Received: from relay.felk.cvut.cz (relay.felk.cvut.cz [147.32.80.7]) by
	cuda.sgi.com with ESMTP id dXN8s4BzOAloD8D8 for
	<xfs@oss.sgi.com>; Tue, 09 Jun 2009 04:12:44 -0700 (PDT)
Date: Tue, 9 Jun 2009 13:35:58 +0200 (CEST)
From: Petr Salinger <Petr.Salinger@seznam.cz>
Subject: Re: Bug#531950: attr: FTBFS on GNU/kFreeBSD
In-Reply-To: <364917872.6081221244543493694.JavaMail.root@mail-au.aconex.com>
Message-ID: <Pine.LNX.4.62.0906091328270.31325@sci.felk.cvut.cz>
References: <364917872.6081221244543493694.JavaMail.root@mail-au.aconex.com>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: agruen@suse.de, Christoph Hellwig <hch@infradead.org>
Cc: 531950-quiet@bugs.debian.org, Nathan Scott <nscott@aconex.com>, xfs@oss.sgi.com

Hello.

>> Andreas now takes care ot attr.  Btw, the submitter should stop that
>> stupid GNU wanking - errnos are defined by the kernel so it's a
>> FreeBSD issues and has nothing to do with their glibc abuse.
>
> Hmm, I'm not sure what you mean there.  AIUI, this code
> (strerror_ea) is working around Linux's lack of an ENOATTR
> error code ... and on FreeBSD there really is an ENOATTR
> (and no ENODATA?)  Perhaps a better fix in this case may be
> to map strerror_ea directly to strerror for all platforms
> except Linux?

The problem is that there is no ENODATA errno value defined
on GNU/kFreeBSD. The errno values are determined by kernel,
they are the same as on plain FreeBSD, used libc
implementation does not change it.

Another possibility is to use patch bellow.
Does it looks acceptable for you ?

Thanks
 	Petr


only in patch2:
unchanged:
--- attr-2.4.43.orig/getfattr/getfattr.c
+++ attr-2.4.43/getfattr/getfattr.c
@@ -93,8 +93,10 @@

  const char *strerror_ea(int err)
  {
+#ifdef ENODATA
         if (err == ENODATA)
                 return _("No such attribute");
+#endif
         return strerror(err);
  }

only in patch2:
unchanged:
--- attr-2.4.43.orig/setfattr/setfattr.c
+++ attr-2.4.43/setfattr/setfattr.c
@@ -66,8 +66,10 @@

  const char *strerror_ea(int err)
  {
+#ifdef ENODATA
         if (err == ENODATA)
                 return _("No such attribute");
+#endif
         return strerror(err);
  }

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n5FA5l0Q098566 for <xfs@oss.sgi.com>; Mon, 15 Jun 2009 05:05:49 -0500
Received: from hall.aurel32.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id EA9332F6F79
	for <xfs@oss.sgi.com>; Mon, 15 Jun 2009 03:06:10 -0700 (PDT)
Received: from hall.aurel32.net (hall.aurel32.net [88.191.82.174]) by
	cuda.sgi.com with ESMTP id wcQSit3BTS2mH95c for
	<xfs@oss.sgi.com>; Mon, 15 Jun 2009 03:06:10 -0700 (PDT)
Date: Mon, 15 Jun 2009 12:05:58 +0200
From: Aurelien Jarno <aurelien@aurel32.net>
Subject: Re: Bug#531950: attr: FTBFS on GNU/kFreeBSD
Message-ID: <20090615100558.GA23442@volta.aurel32.net>
References: <364917872.6081221244543493694.JavaMail.root@mail-au.aconex.com>
	<Pine.LNX.4.62.0906091328270.31325@sci.felk.cvut.cz>
	<20090609121042.GA28666@infradead.org>
	<20090614163517.GA19259@volta.aurel32.net>
	<20090614203309.GA1929@infradead.org>
	<20090614205628.GB25535@hall.aurel32.net>
	<20090615094244.GA4793@infradead.org>
	<Pine.LNX.4.62.0906151211550.15794@sci.felk.cvut.cz>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.62.0906151211550.15794@sci.felk.cvut.cz>
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
To: Petr Salinger <Petr.Salinger@seznam.cz>
Cc: Christoph Hellwig <hch@infradead.org>, 531950-quiet@bugs.debian.org, Nathan Scott <nscott@aconex.com>, xfs@oss.sgi.com

On Mon, Jun 15, 2009 at 12:26:12PM +0200, Petr Salinger wrote:
>> On Sun, Jun 14, 2009 at 10:56:28PM +0200, Aurelien Jarno wrote:
>>> Would such a patch be accepted more easily than the ENODATA patch?
>>
>> I don't think it's an except but in addition.  Wherever we do a strerror
>> in the attr code we will have to special case ENODATA on Linux and only
>> there.  Independent of that I think we would better of using the raw
>> syscalls in platforms already using binary namespaces rather than double
>> translation.  Note that this is only applicable for the IRIX-heritage
>> attr_* routines exports by libattr, not the *xattr routines it also
>> exports.
>
> We would really appreciate to have either "#ifdef ENODATA" or
> "#ifdef __linux__" applied to current debian version of package.
> The debian maintainer does not want to diverge from (future) upstream,
> which is quite understandable.
>

> Would be possible to special case ENODATA as 1st step and postpone
> adding of syscall support later ?

Fully agreed.

Please find below the __linux_ version of the patch.

--- attr-2.4.43.orig/getfattr/getfattr.c
+++ attr-2.4.43/getfattr/getfattr.c
@@ -93,8 +93,10 @@
 
 const char *strerror_ea(int err)
 {
+#ifdef __linux__
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
+#ifdef __linux__
 	if (err == ENODATA)
 		return _("No such attribute");
+#endif
 	return strerror(err);
 }
 
-- 
Aurelien Jarno	                        GPG: 1024D/F1BCDB73
aurelien@aurel32.net                 http://www.aurel32.net

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

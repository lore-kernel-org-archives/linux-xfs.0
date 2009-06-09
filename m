Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n59AVLpn031867 for <xfs@oss.sgi.com>; Tue, 9 Jun 2009 05:31:21 -0500
Received: from postoffice2.aconex.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 558312E0518
	for <xfs@oss.sgi.com>; Tue,  9 Jun 2009 03:31:40 -0700 (PDT)
Received: from postoffice2.aconex.com (mail.aconex.com [203.89.202.182]) by
	cuda.sgi.com with ESMTP id Dgz8alqlO9b4RA8D for
	<xfs@oss.sgi.com>; Tue, 09 Jun 2009 03:31:40 -0700 (PDT)
Date: Tue, 9 Jun 2009 20:31:33 +1000 (EST)
From: Nathan Scott <nscott@aconex.com>
Message-ID: <364917872.6081221244543493694.JavaMail.root@mail-au.aconex.com>
In-Reply-To: <1450746396.6081061244543230576.JavaMail.root@mail-au.aconex.com>
Subject: Re: Bug#531950: attr: FTBFS on GNU/kFreeBSD
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
To: Christoph Hellwig <hch@infradead.org>, Petr Salinger <Petr.Salinger@seznam.cz>, agruen@suse.de
Cc: xfs@oss.sgi.com


----- "Christoph Hellwig" <hch@infradead.org> wrote:

> On Tue, Jun 09, 2009 at 10:03:28AM +1000, Nathan Scott wrote:
> > Could someone verify and merge this patch?  It looks OK to
> > me.
> 
> Andreas now takes care ot attr.  Btw, the submitter should stop that
> stupid GNU wanking - errnos are defined by the kernel so it's a
> FreeBSD issues and has nothing to do with their glibc abuse.

Hmm, I'm not sure what you mean there.  AIUI, this code
(strerror_ea) is working around Linux's lack of an ENOATTR
error code ... and on FreeBSD there really is an ENOATTR
(and no ENODATA?)  Perhaps a better fix in this case may be
to map strerror_ea directly to strerror for all platforms
except Linux?

  const char *strerror_ea(int err)
  {
-       if (err == ENODATA)
+       if (err == ENOATTR)
                 return _("No such attribute");
         return strerror(err);
  }


BTW, which git tree is the canonical acl/attr tree now Andreas?
Is it one of the kernel.org ones (which path?)?  thanks.

cheers.

-- 
Nathan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oBD1fZvf149097 for <xfs@oss.sgi.com>; Sun, 12 Dec 2010 19:41:35 -0600
Received: from mx4-phx2.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3EEDB1CBC39A
	for <xfs@oss.sgi.com>; Sun, 12 Dec 2010 17:43:25 -0800 (PST)
Received: from mx4-phx2.redhat.com (mx4-phx2.redhat.com [209.132.183.25]) by
	cuda.sgi.com with ESMTP id Va2ZhS1OmCQGEquU for
	<xfs@oss.sgi.com>; Sun, 12 Dec 2010 17:43:25 -0800 (PST)
Date: Sun, 12 Dec 2010 20:43:11 -0500 (EST)
From: Lachlan McIlroy <lmcilroy@redhat.com>
Message-ID: <1853857220.660151292204591887.JavaMail.root@zmail05.collab.prod.int.phx2.redhat.com>
In-Reply-To: <996570405.660111292204469269.JavaMail.root@zmail05.collab.prod.int.phx2.redhat.com>
Subject: Re: [PATCH] xfs: prevent NMI timeouts in cmn_err
MIME-Version: 1.0
Reply-To: Lachlan McIlroy <lmcilroy@redhat.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com


----- "Dave Chinner" <david@fromorbit.com> wrote:

> On Fri, Dec 10, 2010 at 08:29:35AM -0500, Christoph Hellwig wrote:
> > On Fri, Dec 03, 2010 at 03:38:46PM +1100, Dave Chinner wrote:
> > > FWIW, while these macros are the best way to make a simple
> backport
> > > is possible, I just discovered that mainline has a %pV format
> > > operator that allows an implementation like:
> > > 
> > > void
> > > xfs_fs_cmn_err(
> > > 	const char              *lvl,
> > > 	struct xfs_mount        *mp,
> > > 	const char              *fmt,
> > > 	...)
> > > {
> > > 	struct va_format        vaf;
> > > 	va_list                 args;
> > > 
> > > 	va_start(args, fmt);
> > > 	vaf.fmt = fmt;
> > > 	vaf.va = &args;
> > > 
> > > 	printk("%sFilesystem %s: %pV", lvl, mp->m_fsname, &vaf);
> > > 	va_end(args);
> > > 
> > > 	BUG_ON(strncmp(lvl, KERN_EMERG, strlen(KERN_EMERG)) == 0);
> > > }
> > 
> > With this we can also keep the existing integer-based CE_ values
> > and do trivial array lookup.  That also avoids having to do a strcmp
> for
> > every message printed.
> 
> Very true.
> 
> Ok, so how do we want to process for this? I'm happy to drop the
> macro-ised patch and only use it as a backportable fix for old
> kernels - mainline appears to have a lot more functionality in this
> area than even recent distro kernels. Lachlan - is that an
> acceptable approach for you?

Yes, that works for me.  We don't have much choice for RHEL4/5 and
there's no reason that should compromise a better solution upstream.

> 
> It seems to me that the above is a much better way to start cleaning
> up the mainline code base, in the following way:
> 
> 	1. the above patch to remove the local message buffer +
> 	   lock.
> 	2. rationalise all the differences in error reporting down
> 	   to a common interface
> 	3. convert the common interface to use kernel log levels
> 	   directly.
> 
> The current trend seems to be to move towards logging interfaces
> with the following template:
> 
> 	{sub_sys}_pr_{level}(priv, fmt, ...)
> 
> Which in this case would give us:
> 
> 	xfs_pr_debug(struct xfs_mount *mp, char *fmt, ...);
> 	xfs_pr_note(struct xfs_mount *mp, char *fmt, ...);
> 	....
> 	xfs_pr_alert(struct xfs_mount *mp, char *fmt, ...);
> 	xfs_pr_emergency(struct xfs_mount *mp, char *fmt, ...);
> 
> And a variant for the panic mask tagged version of xfs_pr_alert()
> of:
> 
> 	xfs_pr_alert_tag(struct xfs_mount *mp, int tag, char *fmt, ...);
> 
> I can't see any particular reason for needing to keep the separate
> parameter for the log level, nor for keeping all the different
> logging variants we currently have.

Wont you need to reintroduce the log level parameter when each of these
new functions calls the common interface?  ie most of the above functions
will just be wrappers that convert the function name to a log level.

> 
> I'm open to other ideas on the best way to rationalise all the
> logging we currently have - the above is just my current thoughts on
> what to do. I'm pushing this out as a proposal for discussion before
> I change anything as I don't relish the idea of iterating different
> logging APIs through patches...
> 
> Cheers,
> 
> Dave.
> 
> > 
> > 
> 
> -- 
> Dave Chinner
> david@fromorbit.com
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

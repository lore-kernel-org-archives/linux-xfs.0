Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oBD3gqfi155755 for <xfs@oss.sgi.com>; Sun, 12 Dec 2010 21:42:52 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9DFDD1E3128
	for <xfs@oss.sgi.com>; Sun, 12 Dec 2010 19:44:40 -0800 (PST)
Received: from mail.internode.on.net (bld-mail19.adl2.internode.on.net
	[150.101.137.104]) by cuda.sgi.com with ESMTP id
	ewdKzoebVzuYWuWI for <xfs@oss.sgi.com>;
	Sun, 12 Dec 2010 19:44:40 -0800 (PST)
Date: Mon, 13 Dec 2010 14:44:16 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: prevent NMI timeouts in cmn_err
Message-ID: <20101213034416.GD9925@dastard>
References: <996570405.660111292204469269.JavaMail.root@zmail05.collab.prod.int.phx2.redhat.com>
	<1853857220.660151292204591887.JavaMail.root@zmail05.collab.prod.int.phx2.redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1853857220.660151292204591887.JavaMail.root@zmail05.collab.prod.int.phx2.redhat.com>
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
To: Lachlan McIlroy <lmcilroy@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Sun, Dec 12, 2010 at 08:43:11PM -0500, Lachlan McIlroy wrote:
> 
> ----- "Dave Chinner" <david@fromorbit.com> wrote:
> 
> > On Fri, Dec 10, 2010 at 08:29:35AM -0500, Christoph Hellwig wrote:
> > > On Fri, Dec 03, 2010 at 03:38:46PM +1100, Dave Chinner wrote:
> > > > FWIW, while these macros are the best way to make a simple
> > backport
> > > > is possible, I just discovered that mainline has a %pV format
> > > > operator that allows an implementation like:
> > > > 
> > > > void
> > > > xfs_fs_cmn_err(
> > > > 	const char              *lvl,
> > > > 	struct xfs_mount        *mp,
> > > > 	const char              *fmt,
> > > > 	...)
> > > > {
> > > > 	struct va_format        vaf;
> > > > 	va_list                 args;
> > > > 
> > > > 	va_start(args, fmt);
> > > > 	vaf.fmt = fmt;
> > > > 	vaf.va = &args;
> > > > 
> > > > 	printk("%sFilesystem %s: %pV", lvl, mp->m_fsname, &vaf);
> > > > 	va_end(args);
> > > > 
> > > > 	BUG_ON(strncmp(lvl, KERN_EMERG, strlen(KERN_EMERG)) == 0);
> > > > }
> > > 
> > > With this we can also keep the existing integer-based CE_ values
> > > and do trivial array lookup.  That also avoids having to do a strcmp
> > for
> > > every message printed.
> > 
> > Very true.
> > 
> > Ok, so how do we want to process for this? I'm happy to drop the
> > macro-ised patch and only use it as a backportable fix for old
> > kernels - mainline appears to have a lot more functionality in this
> > area than even recent distro kernels. Lachlan - is that an
> > acceptable approach for you?
> 
> Yes, that works for me.  We don't have much choice for RHEL4/5 and
> there's no reason that should compromise a better solution upstream.

Ok, I'll get that ball moving...

> > It seems to me that the above is a much better way to start cleaning
> > up the mainline code base, in the following way:
> > 
> > 	1. the above patch to remove the local message buffer +
> > 	   lock.
> > 	2. rationalise all the differences in error reporting down
> > 	   to a common interface
> > 	3. convert the common interface to use kernel log levels
> > 	   directly.
> > 
> > The current trend seems to be to move towards logging interfaces
> > with the following template:
> > 
> > 	{sub_sys}_pr_{level}(priv, fmt, ...)
> > 
> > Which in this case would give us:
> > 
> > 	xfs_pr_debug(struct xfs_mount *mp, char *fmt, ...);
> > 	xfs_pr_note(struct xfs_mount *mp, char *fmt, ...);
> > 	....
> > 	xfs_pr_alert(struct xfs_mount *mp, char *fmt, ...);
> > 	xfs_pr_emergency(struct xfs_mount *mp, char *fmt, ...);
> > 
> > And a variant for the panic mask tagged version of xfs_pr_alert()
> > of:
> > 
> > 	xfs_pr_alert_tag(struct xfs_mount *mp, int tag, char *fmt, ...);
> > 
> > I can't see any particular reason for needing to keep the separate
> > parameter for the log level, nor for keeping all the different
> > logging variants we currently have.
> 
> Wont you need to reintroduce the log level parameter when each of these
> new functions calls the common interface?

Ah, what I meant was that the above xfs_pr_*() functions form the
common logging interface, instead of cmn_err, xfs_cmn_err,
xfs_fs_cmn_err, etc.  So the second step above would be to convert
all the existing logging calls to use this, but still using the
current cmn_err() back end for the custom XFS log messages. i.e. the
callers change API, but they still use the same CE_* levels.

> ie most of the above functions
> will just be wrappers that convert the function name to a log level.

The third step is to change the implementation to something like
the dev_<level>() printk implementation, or possibly even using the 
pr_<level> macros directly via creative abuse of the pr_fmt() macro.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

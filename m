Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oB38ZJOl073215 for <xfs@oss.sgi.com>; Fri, 3 Dec 2010 02:35:20 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7A74C1E90C16
	for <xfs@oss.sgi.com>; Fri,  3 Dec 2010 00:37:01 -0800 (PST)
Received: from mail.internode.on.net (bld-mail12.adl6.internode.on.net
	[150.101.137.97]) by cuda.sgi.com with ESMTP id
	Ullid87kvhgdvJIZ for <xfs@oss.sgi.com>;
	Fri, 03 Dec 2010 00:37:01 -0800 (PST)
Date: Fri, 3 Dec 2010 19:36:59 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: prevent NMI timeouts in cmn_err
Message-ID: <20101203083659.GE23339@dastard>
References: <121488966.359171291347997519.JavaMail.root@zmail05.collab.prod.int.phx2.redhat.com>
	<275948151.359301291348292101.JavaMail.root@zmail05.collab.prod.int.phx2.redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <275948151.359301291348292101.JavaMail.root@zmail05.collab.prod.int.phx2.redhat.com>
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
Cc: xfs@oss.sgi.com

On Thu, Dec 02, 2010 at 10:51:32PM -0500, Lachlan McIlroy wrote:
> Dave, overall it looks good - just a few minor points below.
> Thanks for doing this.
> 
> ----- "Dave Chinner" <david@fromorbit.com> wrote:

[snip]

> > -void
> > -cmn_err(register int level, char *fmt, ...)
> > -{
> > -	char	*fp = fmt;
> > -	int	len;
> > -	ulong	flags;
> > -	va_list	ap;
> > -
> > -	level &= XFS_ERR_MASK;
> > -	if (level > XFS_MAX_ERR_LEVEL)
> > -		level = XFS_MAX_ERR_LEVEL;
> > -	spin_lock_irqsave(&xfs_err_lock,flags);
> > -	va_start(ap, fmt);
> > -	if (*fmt == '!') fp++;
> > -	len = vsnprintf(message, sizeof(message), fp, ap);
> > -	if (len >= sizeof(message))
> > -		len = sizeof(message) - 1;
> > -	if (message[len-1] == '\n')
> > -		message[len-1] = 0;
        ^^^^^^^^^^^^^^^^^^^^^^^^^^^

> > -	printk("%s%s\n", err_level[level], message);
> > -	va_end(ap);
> > -	spin_unlock_irqrestore(&xfs_err_lock,flags);
> > -	BUG_ON(level == CE_PANIC);
> > -}

[snip]

> > +#define CE_DEBUG        KERN_DEBUG
> > +#define CE_CONT         KERN_INFO
> > +#define CE_NOTE         KERN_NOTICE
> > +#define CE_WARN         KERN_WARNING
> > +#define CE_ALERT        KERN_ALERT
> > +#define CE_PANIC        KERN_EMERG
> > +
> > +#define cmn_err(lvl, fmt, args...)	\
> > +	do { \
> > +		printk(lvl fmt, ## args); \
> 
> The old cmn_err() routine would append a newline if one was not supplied.
> As far as I know printk() will not do the same so either we need to fix
> all calls to cmn_err() to supply a '\n' or add it here (at the risk of
> having two newlines) - maybe:

See above - I think you have it the wrong way around - it looks to
me like the old cmn_err() stripped the newline character if it
existed, then added one itself.

> printk(lvl fmt "\n", ## args);

printk() is actually pretty tolerant of missing newlines - if it
detects the previous printk() was not newline terminated and the
next one starts with a log level that is not KERN_CONT, it will
print the new message on a new line automatically. This is the code
in vprintk() that handles it:

        /* Do we have a loglevel in the string? */
        if (p[0] == '<') {
                unsigned char c = p[1];
                if (c && p[2] == '>') {
                        switch (c) {
                        case '0' ... '7': /* loglevel */
                                current_log_level = c - '0';
                        /* Fallthrough - make sure we're on a new line */
                        case 'd': /* KERN_DEFAULT */
                                if (!new_text_line) {
                                        emit_log_char('\n');
                                        new_text_line = 1;
                                }
                        /* Fallthrough - skip the loglevel */
                        case 'c': /* KERN_CONT */
                                p += 3;
                                break;
                        }
                }
        }

So we are probably OK not to need additional newlines. Indeed, I
didn't notice the output being screwed up without them. ;)

I can add them if you want, though.

> 
> > +		BUG_ON(strncmp(lvl, KERN_EMERG, strlen(KERN_EMERG)) == 0); \
> > +	} while (0)
> > +
> > +#define xfs_fs_cmn_err(lvl, mp, fmt, args...)	\
> > +	do { \
> > +		printk(lvl "Filesystem %s: " fmt, (mp)->m_fsname, ## args); \
> 
> printk(lvl "Filesystem %s: " fmt "\n", (mp)->m_fsname, ## args);
> 
> > +		BUG_ON(strncmp(lvl, KERN_EMERG, strlen(KERN_EMERG)) == 0); \
> > +	} while (0)
> > +
> > +/* All callers to xfs_cmn_err use CE_ALERT, so don't bother testing
> > lvl */
> > +#define xfs_cmn_err(panic_tag, lvl, mp, fmt, args...)	\
> > +	do { \
> > +		int	panic = 0; \
> > +		if (xfs_panic_mask && (xfs_panic_mask & panic_tag)) { \
> > +			printk(KERN_ALERT "XFS: Transforming an alert into a BUG."); \
> > +			panic = 1; \
> > +		} \
> > +		printk(KERN_ALERT "Filesystem %s: " fmt, (mp)->m_fsname, ## args);
> > \
> > +		BUG_ON(panic); \
> > +	} while (0)
> 
> I think we can simplify this case a bit and remove the panic variable,
> like this:
> 
> 	do { \
> 		printk(KERN_ALERT "Filesystem %s: " fmt "\n", (mp)->m_fsname, ## args);
> 		if (xfs_panic_mask && (xfs_panic_mask & panic_tag)) { \
> 			printk(KERN_ALERT "XFS: Transforming an alert into a BUG.\n"); \
> 			BUG_ON(1); \
> 		} \
> 	} while (0)
> 
> This also reorders the messages which I think makes more sense.

Definitely. That's a vast improvement. ;)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

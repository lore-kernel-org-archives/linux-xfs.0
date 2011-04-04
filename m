Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with SMTP id
	p34NnEJm205614 for <xfs@oss.sgi.com>; Mon, 4 Apr 2011 18:49:14 -0500
Received: from twin.jikos.cz (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5D35939FD6A
	for <xfs@oss.sgi.com>; Mon,  4 Apr 2011 16:52:28 -0700 (PDT)
Received: from twin.jikos.cz (twin.jikos.cz [89.185.236.188]) by cuda.sgi.com
	with ESMTP id qEppLttYJUzJ8Yst for <xfs@oss.sgi.com>;
	Mon, 04 Apr 2011 16:52:28 -0700 (PDT)
Received: from twin.jikos.cz (dave@localhost [127.0.0.1])
	by twin.jikos.cz (8.13.6/8.13.6) with ESMTP id p34NqRBU020592
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Tue, 5 Apr 2011 01:52:27 +0200
Received: (from dave@localhost)
	by twin.jikos.cz (8.13.6/8.13.6/Submit) id p34NqRGQ020591
	for xfs@oss.sgi.com; Tue, 5 Apr 2011 01:52:27 +0200
Date: Tue, 5 Apr 2011 01:52:27 +0200
From: David Sterba <dave@jikos.cz>
Subject: Re: [PATCH] xfs: fix variable set but not used warnings
Message-ID: <20110404235226.GC31675@twin.jikos.cz>
References: <20110404125544.GA726@infradead.org>
	<1301941280.2630.61.camel@doink>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1301941280.2630.61.camel@doink>
Reply-To: dave@jikos.cz
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
To: xfs@oss.sgi.com

Hi,

I've seen this one too and I think this may not be a trivialy removable one, at
least not without some analysis.

On Mon, Apr 04, 2011 at 01:21:20PM -0500, Alex Elder wrote:
> > Index: linux-2.6/fs/xfs/quota/xfs_qm_syscalls.c
> > ===================================================================
> > --- linux-2.6.orig/fs/xfs/quota/xfs_qm_syscalls.c	2011-04-03 06:40:45.399789765 -0700
> > +++ linux-2.6/fs/xfs/quota/xfs_qm_syscalls.c	2011-04-03 06:43:00.219782939 -0700
> > @@ -313,14 +313,12 @@ xfs_qm_scall_quotaon(
> >  {
> >  	int		error;
> >  	uint		qf;
> > -	uint		accflags;
> >  	__int64_t	sbflags;
> >  
> >  	flags &= (XFS_ALL_QUOTA_ACCT | XFS_ALL_QUOTA_ENFD);
> >  	/*
> >  	 * Switching on quota accounting must be done at mount time.
> >  	 */
> > -	accflags = flags & XFS_ALL_QUOTA_ACCT;
> >  	flags &= ~(XFS_ALL_QUOTA_ACCT);
> 
> Unrelated, but isn't the effect of this line plus the one a few
> lines up the same as this?
> 
> 	flags &= XFS_ALL_QUOTA_ENFD;

yes it its, but then why was the separate accflags there? That's why I'm not
sure it should go away so easily.

> 
> >  
> >  	sbflags = 0;

and not only this, a few lines below:

        if (((flags & XFS_UQUOTA_ACCT) == 0 &&
              ^^^^^^^^^^^^^^^^^^^^^^^

            (mp->m_sb.sb_qflags & XFS_UQUOTA_ACCT) == 0 &&
            (flags & XFS_UQUOTA_ENFD))
             ^^^^^^^^^^^^^^^^^^^^^^^

            ||
            ((flags & XFS_PQUOTA_ACCT) == 0 &&
              ^^^^^^^^^^^^^^^^^^^^^^^

            (mp->m_sb.sb_qflags & XFS_PQUOTA_ACCT) == 0 &&
            (flags & XFS_GQUOTA_ACCT) == 0 &&
             ^^^^^^^^^^^^^^^^^^^^^^^

            (mp->m_sb.sb_qflags & XFS_GQUOTA_ACCT) == 0 &&
            (flags & XFS_OQUOTA_ENFD))) {

                xfs_debug(mp,
                        "%s: Can't enforce without acct, flags=%x sbflags=%x\n",
                        __func__, flags, mp->m_sb.sb_qflags);
                return XFS_ERROR(EINVAL);
        }

(the GQUOTA/PQUOTA/UQUOTA are covered by XFS_ALL_QUOTA_ACCT, masked above)

all the underlined expressions will be always zero, leading to a true ==
condition and leaving only the superblock flags to be checked.

Callchain of xfs_qm_scall_quotaon() goes up to

quotactl
  do_quotactl
    quota_setxstate
      .set_xstate
        xfs_fs_set_xstate
          xfs_qm_scall_quotaon

where the final flags/accflags are passed from ioctl uflags and then
converted to XFS quota flags. Ie., the caller of the quotactl has to set
the ACCT flags, therefore I'd say the checked flags should state

      accflags & XFS_GQUOTA_ACCT        (...etc)

else, if the ACCT flags are not specified via superblock, the quotaon
sysctl will always fail with "Can't enforce without acct", even when
the accounting flags are specified via a mount option (speculated and
not tested myself).

The code is there since ages so I wonder whether anybody hit this bug or
if I misunderstood xfs/quota documentation.

Besides, there are more cleanups and fixups in this function:

line 331:
        /* No fs can turn on quotas with a delayed effect */
	ASSERT((flags & XFS_ALL_QUOTA_ACCT) == 0);

seems to be broken too:
* the acct flags are masked out -> always asserts true
* doing s/flags/accflags/ does not make sense

line 374:
        if ((error = xfs_qm_write_sb_changes(mp, sbflags)))
	                return (error);

convert to:

	error = xfs_qm_...
	if (error) ...

line 395:
        mp->m_qflags |= (flags & XFS_ALL_QUOTA_ENFD);

->

        mp->m_qflags |= flags;

I could send a patch, but I want to be clear on the accounting flags.


I'd like to ask maintainers to be cautious when accepting these
simply looking cleanups, they may actually hide bugs.


dave

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

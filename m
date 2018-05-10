Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wr0-f196.google.com ([209.85.128.196]:43329 "EHLO
        mail-wr0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S966492AbeEJRNa (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 10 May 2018 13:13:30 -0400
Received: by mail-wr0-f196.google.com with SMTP id v15-v6so2732721wrm.10
        for <linux-xfs@vger.kernel.org>; Thu, 10 May 2018 10:13:30 -0700 (PDT)
Date: Thu, 10 May 2018 19:13:27 +0200
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH V2] xfs_io: Document shutdown -f
Message-ID: <20180510171327.niicyposszvzhrra@odin.usersys.redhat.com>
References: <20180510091030.15619-1-cmaiolino@redhat.com>
 <20180510163317.GD11261@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180510163317.GD11261@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Thu, May 10, 2018 at 09:33:17AM -0700, Darrick J. Wong wrote:
> On Thu, May 10, 2018 at 11:10:30AM +0200, Carlos Maiolino wrote:
> > Add help and manpage information for xfs_io shutdown -f
> > 
> > Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
> > ---
> > 
> > V2:
> > 	Add more detailed information about what shutdown command does
> > 
> >  io/shutdown.c     | 16 ++++++++++++++++
> >  man/man8/xfs_io.8 | 16 +++++++++++++++-
> >  2 files changed, 31 insertions(+), 1 deletion(-)
> > 
> > diff --git a/io/shutdown.c b/io/shutdown.c
> > index 022a0e9a..8ac64d63 100644
> > --- a/io/shutdown.c
> > +++ b/io/shutdown.c
> > @@ -47,6 +47,21 @@ shutdown_f(
> >  	return 0;
> >  }
> >  
> > +static void
> > +shutdown_help(void)
> > +{
> > +	printf(_(
> > +"\n"
> > +" Shuts down the filesystem and prevents any further IO from occurring.\n"
> > +"\n"
> > +" With no arguments, shutdown will not attempt to flush completed transactions\n"
> > +" to disk before marking the log as being shut down. Simulating an IO error\n"
> 
> "This simulates an IO error behavior." ?
> 
> Might also be worth mentioning that this simulates a system crash too?
> 

Not sure, I don't see it as a system crash, after all, the system doesn't crash
at all?

I may be seeing it in different way though.

> > +" behavior.\n"
> > +"\n"
> > +" -f -- Flush completed transactions to disk before shut down.\n"
> > +"\n"));
> > +}
> > +
> >  void
> >  shutdown_init(void)
> >  {
> > @@ -56,6 +71,7 @@ shutdown_init(void)
> >  	shutdown_cmd.argmax = 1;
> >  	shutdown_cmd.flags = CMD_NOMAP_OK | CMD_FLAG_ONESHOT | CMD_FLAG_FOREIGN_OK;
> >  	shutdown_cmd.args = _("[-f]");
> > +	shutdown_cmd.help = shutdown_help;
> >  	shutdown_cmd.oneline =
> >  		_("shuts down the filesystem where the current file resides");
> >  
> > diff --git a/man/man8/xfs_io.8 b/man/man8/xfs_io.8
> > index c3ab532d..d4c28a0a 100644
> > --- a/man/man8/xfs_io.8
> > +++ b/man/man8/xfs_io.8
> > @@ -1007,8 +1007,22 @@ Note \-\- this can be useful for exercising out of space behavior.
> >  Only available in expert mode and requires privileges.
> >  .TP
> >  .BR shutdown " [ " \-f " ]"
> > -Force the filesystem to shutdown (with or without flushing the log).
> > +Force a shutdown of the filesystem, but keep consistency. It does not unmount
> 
> I would've thought we maintain metadata consistency no matter if we
> flush the log or not, at least if the log is working correctly.
> 

Sorry, I thought that's exactly what I meant there.

"Force a shutdown of the filesystem, but keep consistency (whether -f is used or
not).

I thought the parenthesis were implicit there.

> Perhaps shorten this to 'Force the filesystem to shut down.'?

Can be too, I think it could be important to say 'keep consistency', but well,
not sure how important it would be if somebody is actually using shutdown

> 
> --D
> 
> > +the filesystem, but prevents any other IO to happen on it.
> >  Only available in expert mode and requires privileges.
> > +.PP
> > +.RS
> > +By default, XFS will not attempt to flush completed transactions to disk before
> > +marking the log as being shut down.
> > +.RE
> > +.RS 1.0i
> > +.PD 0
> > +.TP 0.4i
> > +.B \-f
> > +Force XFS to flush all completed transactions to disk before marking the log as
> > +shut down.
> > +.PD
> > +.RE
> >  .TP
> >  .BR stat " [ " \-v "|" \-r " ]"
> >  Selected statistics from
> > -- 
> > 2.14.3
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Carlos

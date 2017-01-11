Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:33743 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934300AbdAKRpi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 11 Jan 2017 12:45:38 -0500
Date: Wed, 11 Jan 2017 09:45:30 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] xfs_repair: update the manual content about xfs_repair
 exit status
Message-ID: <20170111174530.GT14038@birch.djwong.org>
References: <1484111908-12558-1-git-send-email-zlang@redhat.com>
 <9c965d34-9242-394a-490d-9825ac3ff918@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9c965d34-9242-394a-490d-9825ac3ff918@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Zorro Lang <zlang@redhat.com>, linux-xfs@vger.kernel.org

On Wed, Jan 11, 2017 at 07:47:41AM -0600, Eric Sandeen wrote:
> 
> 
> On 1/10/17 11:18 PM, Zorro Lang wrote:
> > The man 8 xfs_repair said "xfs_repair run without the -n option will
> > always return a status code of 0". That's not correct.
> > 
> > xfs_repair will return 2 if it finds a fs log which needs to be
> > replayed or cleared, 1 if runtime error is encountered, and 0 for
> > all other cases.
> > 
> > Signed-off-by: Zorro Lang <zlang@redhat.com>
> > ---
> > 
> > Hi,
> > 
> > This patch has been stayed in my local xfsprogs repo for a long
> > time. So I'm sending it out again :)
> 
> Yep, sorry about that.  Last comment on it was that the sentence
> had become a run-on sentence ...
> 
> How about:
> 
> .B xfs_repair
> run without the -n option will always return a status code of 0 if it
> runs without problems, regardless of whether filesystem corruption was
> detected.  If an unexpected runtime error is encountered, it will return
> a status code of 1, and xfs_repair should be restarted.  If a dirty
> log is encountered which prevents it from continuing, it will return a
> status code of 2.
> 
> (I think that the right place to document mount/unmount and/or -L is
> /not/ in the status code docs - if we need that info, it should go
> elsewhere.)

We sort of mumble about needing to mount and umount to clear a dirty log
in the BUGS section, but I think we should just add a section about
dirty logs and what to do with them, then link to it from the status
code section and the -L option section.

"DIRTY LOGS

"Due to the design of the XFS log, a dirty log can only be replayed on a
machine having the same CPU architecture as the machine which was
writing to the log.  xfs_repair cannot replay a dirty log and will
return a status code of 2 when it detects a dirty log.

"In this situation, the log can be replayed by mounting and immediately
unmounting the filesystem on the same class of machine that crashed.
Please make sure that the machine's hardware is reliable before
replaying to avoid compounding the problems.

"If mounting fails, the log can be erased by running xfs_repair with
the -L option.  All metadata updates in progress at the time of the
crash will be lost, which may cause significant filesystem damage.  This
should only be used as a last resort."

(If you decide to add that paragraph,
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>)

Though I wonder why don't just fix the endianness issues with the log,
and teach xfs_repair how to replay them...

--D

> 
> -eric
> 
> > Thanks,
> > Zorro
> > 
> >  man/man8/xfs_repair.8 | 10 ++++++++--
> >  1 file changed, 8 insertions(+), 2 deletions(-)
> > 
> > diff --git a/man/man8/xfs_repair.8 b/man/man8/xfs_repair.8
> > index 1b4d9e3..314f2c2 100644
> > --- a/man/man8/xfs_repair.8
> > +++ b/man/man8/xfs_repair.8
> > @@ -504,12 +504,18 @@ that is known to be free. The entry is therefore invalid and is deleted.
> >  This message refers to a large directory.
> >  If the directory were small, the message would read "junking entry ...".
> >  .SH EXIT STATUS
> > +.TP
> >  .B xfs_repair \-n
> > -(no modify node)
> > +(no modify mode)
> >  will return a status of 1 if filesystem corruption was detected and
> >  0 if no filesystem corruption was detected.
> > +.TP
> >  .B xfs_repair
> > -run without the \-n option will always return a status code of 0.
> > +run without the \-n option will return a status code of 2 if it finds a
> > +filesystem log which needs to be replayed (by a mount/umount cycle) or
> > +cleared (by -L option), 1 if a runtime error is encountered, filesystem
> > +may be even more broken than before, so repair needs to be run again,
> > +and 0 in all other cases, whether or not filesystem corruption was detected.
> >  .SH BUGS
> >  The filesystem to be checked and repaired must have been
> >  unmounted cleanly using normal system administration procedures
> > 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

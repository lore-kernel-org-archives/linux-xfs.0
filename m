Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 4E45E7F3F
	for <xfs@oss.sgi.com>; Wed, 13 Mar 2013 13:24:36 -0500 (CDT)
Date: Wed, 13 Mar 2013 13:24:35 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: XFS filesystem on EC2 instance corrupts and shuts down
Message-ID: <20130313182435.GU22182@sgi.com>
References: <CAOdS1h=7X4O1O7X8YOwxtLm7G=fc+J+6hJxJ1RKbDmfTZXTpeg@mail.gmail.com>
	<51373DB8.2020707@redhat.com>
	<CAOdS1hnXGj9puaHxeToqmpK40A-3WvJnM7=5HckpyyZYqZTvEQ@mail.gmail.com>
	<51373FC1.6010101@redhat.com>
	<CAOurMUeasru6ekDYcvVR1QnaWVJFV+-coZsUG5SgG6LnENBvXg@mail.gmail.com>
	<513751F2.2060109@redhat.com>
	<CAOdS1hngSuHn_HiremLyUS7Qd9eZ68=8arfBuHnEpwXQaBw9Wg@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAOdS1hngSuHn_HiremLyUS7Qd9eZ68=8arfBuHnEpwXQaBw9Wg@mail.gmail.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Shrinath M <shrinath.m@webyog.com>
Cc: Sabyasachi Ruj <sabyasachi.ruj@webyog.com>, Vivek Goel <vivek.goel@webyog.com>, Supratik Goswami <supratik.goswami@webyog.com>, Ric Wheeler <rwheeler@redhat.com>, xfs@oss.sgi.com

Hey Shrinath,

On Wed, Mar 13, 2013 at 11:37:52PM +0530, Shrinath M wrote:
> Sorry to be asking in dev thread, but Amazon seems to be clueless in this
> case :(
> Can someone tell me where can we find the logs/output of xfs repair after
> this runs?

xfs_repair doesn't keep a separate log file.  All the output is on the command
line.  You'll need to either redirect the output of stdout and stderr to a
file, or keep a screen or console log.

>	We just reboot the machine when we see this and the
> /var/log/messages or dmesg seems to know nothing about what it repaired.

The contents of /var/log/messages could help you to understand why xfs might
have forced shutdown, but won't help you with xfs_repair.

Since you're getting IO errors, it sounds like you have a problem lower in the
stack than the filesystem.  At the filesystem level there isn't much we can do
with a block device that is giving IO errors so we just shut down.  Consider
copying the remote block device to a local one ('dd' might be a good choice for
this) and see if you can get a clean copy.  Then it's time to see about the
filesystem.

Regards,
Ben

> On Wed, Mar 6, 2013 at 7:55 PM, Ric Wheeler <rwheeler@redhat.com> wrote:
> 
> > I would suggest contacting Amazon's customer support channel (or the
> > vendor you paid for the Linux instance you are running).
> >
> > XFS developer list is probably not the correct forum to help you debug
> > this :)
> >
> > Good luck!
> >
> > Ric
> >
> >
> >
> > On 03/06/2013 08:12 AM, Supratik Goswami wrote:
> >
> >> Have we created a ticket with AWS ?
> >>
> >> It could be an EBS issue who knows, we need to confirm that first.
> >>
> >> --
> >> Warm Regards
> >>
> >> Supratik
> >>
> >>
> >> On Wed, Mar 6, 2013 at 6:38 PM, Ric Wheeler <rwheeler@redhat.com <mailto:
> >> rwheeler@redhat.com>> wrote:
> >>
> >>     On 03/06/2013 08:03 AM, Shrinath M wrote:
> >>
> >>
> >>         On Wed, Mar 6, 2013 at 6:29 PM, Ric Wheeler <rwheeler@redhat.com
> >>         <mailto:rwheeler@redhat.com> <mailto:rwheeler@redhat.com
> >>
> >>         <mailto:rwheeler@redhat.com>>> wrote:
> >>
> >>             I think that you would need to verify that the Amazon storage
> >> is not
> >>             throwing errors - do your logs show IO errors or issues
> >> before XFS
> >>         hits an
> >>             issue?
> >>
> >>
> >>         No IO errors in /var/log/messages.
> >>         Where else should I be looking?
> >>
> >>
> >>
> >>     Feb 12 19:47:18 ip-100-0-100-1 kernel: [2541168.023638] XFS (md0): I/O
> >>     Error Detected. Shutting down filesystem
> >>
> >>     Is an IO error from MD.
> >>
> >>     I would suggest trying to reproduce without MD in the picture first -
> >>     always best to try to reproduce with the simplest setup first and work
> >>     your way up the complexity ladder,
> >>
> >>     Ric
> >>
> >>
> >>
> >>
> >> ______________________________**_________________
> >> xfs mailing list
> >> xfs@oss.sgi.com
> >> http://oss.sgi.com/mailman/**listinfo/xfs<http://oss.sgi.com/mailman/listinfo/xfs>
> >>
> >
> >
> 
> 
> -- 
> Regards
> *Shrinath.M*

> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

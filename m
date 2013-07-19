Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 59EA47F53
	for <xfs@oss.sgi.com>; Fri, 19 Jul 2013 14:53:18 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 45C8E304062
	for <xfs@oss.sgi.com>; Fri, 19 Jul 2013 12:53:18 -0700 (PDT)
Received: from mail.ud10.udmedia.de (ud10.udmedia.de [194.117.254.50]) by
	cuda.sgi.com with ESMTP id pv7WcPHW0kRlDzJQ (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 19 Jul 2013 12:53:13 -0700 (PDT)
Date: Fri, 19 Jul 2013 21:53:12 +0200
From: Markus Trippelsdorf <markus@trippelsdorf.de>
Subject: Re: [Bisected] Corruption of root fs during git bisect of drm system
	hang
Message-ID: <20130719195312.GA360@x4>
References: <20130713090523.GA362@x4> <20130712070721.GA359@x4>
	<20130715022841.GH5228@dastard> <20130715064734.GA361@x4>
	<20130719122235.GA360@x4>
	<CAAxjCExBi-4Qgf6-=MBzdkzBmMtu=GTURu46DoD2CzpnF2dinw@mail.gmail.com>
	<20130719125149.GB360@x4> <51E9630A.3070201@sandeen.net>
	<20130719163220.GA363@x4> <51E99216.9060609@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <51E99216.9060609@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Stefan Ring <stefanrin@gmail.com>, Ben Myers <bpm@sgi.com>, Mark Tinguely <tinguely@sgi.com>, Stan Hoeppner <stan@hardwarefreak.com>, Linux fs XFS <xfs@oss.sgi.com>

On 2013.07.19 at 14:23 -0500, Eric Sandeen wrote:
> On 7/19/13 11:32 AM, Markus Trippelsdorf wrote:
> > On 2013.07.19 at 11:02 -0500, Eric Sandeen wrote:
> >> On 7/19/13 7:51 AM, Markus Trippelsdorf wrote:
> >>> On 2013.07.19 at 14:41 +0200, Stefan Ring wrote:
> >>>>> I've bisected this issue to the following commit:
> >>>>>
> >>>>>  commit cca9f93a52d2ead50b5da59ca83d5f469ee4be5f
> >>>>>  Author: Dave Chinner <dchinner@redhat.com>
> >>>>>  Date:   Thu Jun 27 16:04:49 2013 +1000
> >>>>>
> >>>>>      xfs: don't do IO when creating an new inode
> >>>>>
> >>>>> Reverting this commit on top of the Linus tree "solves" all problems for
> >>>>> me. IOW I no longer loose my KDE and LibreOffice config files during a
> >>>>> crash. Log recovery now works fine and xfs_repair shows no issues.
> >>>>>
> >>>>> So users of 3.11.0-rc1 beware. Only run this version if you have
> >>>>> up-to-date backups handy.
> >>
> >> Are you certain about that bisection point?  All that does is
> >> say:  When we allocate a new inode, assign it a random generation
> >> number, rather than reading it from disk & incrementing the
> >> older generation number, AFAICS.  So it simply avoids a read IO.
> > 
> > Yes, I'm sure. 
> > As I wrote above I also double-checked by reverting the commit on top of
> > the current Linus tree.
> > 
> >> I wonder if simply changing IO patterns on the SSD changes how
> >> it's doing caching & destaging <handwave>.
> > 
> > No. The corruption also happens on my conventional (spinning) drives.
> > 
> >>>> What I miss in this thread is a distinction between filesystem
> >>>> corruption on the one hand and a few zeroed files on the other. The
> >>>> latter may be a nuisance, but it is expected behavior, while the
> >>>> former should never happen, period, if I'm not mistaken.
> >>>
> >>> Well, it is natural that fs developers at first try to blame userspace.
> >>
> >> I disagree with that, we just need to be clear about your scenarios,
> >> and what integrity guarantees should apply.
> >>
> >>> Unfortunately it turned out that in this case there is filesystem
> >>> corruption. (Fortunately this normally happens only very rarely on rc1
> >>> kernels).
> >>
> >> Corruption is when you get back data that you did not write,
> >> or metadata which is inconsistent or unreadable even after a proper
> >> log replay.
> >>
> >> Corruption is _not_ unsynced, buffered data that was lost on a
> >> crash or poweroff.
> >>
> >> But I might not have followed the thread properly, and I might
> >> misunderstand your situation.
> >>
> >> When you experience this lost file [data] scenario, was it after an
> >> orderly reboot, or after a crash and/or system reset?
> > 
> > To reproduce this issue simply boot into your desktop and then hit
> > sysrq-c and reboot. 
> 
> Ok, a crash, so at a minimum, some buffered data loss is 100% expected.

Sure.

> > After log replay without error messages, the
> > filesystem is in an inconsistent state
> 
> What exactly do you mean by inconsistent state?  Sorry to be pedantic here.

By inconsistent state I mean a filesystem state that forces you to run
xfs_repair to get back to normal.

> > and many small config files are
> > lost. 
> 
> Written how long ago?  Were they fsynced?
> I suppose you are unsure about that, if they're app-written.

I hit sysrq-c ~10 seconds after the KDE session is fully functional.
As I've wrote above I added an fsync to the KDE config file handler. So
the files should be fsynced.

> > There are also undeletable files.
> 
> What happens when you try to delete them?

They show up as "?????? ??????" in "ls -l" and I get an error when I
try to delete them. (I don't recall the exact error message)
See for example the /tmp/.X0-lock file that I mentioned earlier in this
thread.

> > You need to run xfs_repair
> > manually to bring the filesystem back to normal.
> 
> And what is the repair output?

See the outputs I've posted in this thread before. It's always a
variation thereof.

> Can you show an exact sequence of events, capturing all relevant output from repair and/or dmesg, etc, just so we see exactly what you see?

I already did that. 

-- 
Markus

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

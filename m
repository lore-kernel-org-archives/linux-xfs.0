Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q17Gst7G243879 for <xfs@oss.sgi.com>; Tue, 7 Feb 2012 10:54:56 -0600
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id vaHwPYoykGkdnGid (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 07 Feb 2012 08:54:54 -0800 (PST)
Date: Tue, 7 Feb 2012 17:54:52 +0100
From: Jan Kara <jack@suse.cz>
Subject: Re: Soft lockup problem
Message-ID: <20120207165452.GA1043@quack.suse.cz>
References: <CAOgv-ziomS-+ML0Xb4oSoWTjzkG8BBBQcMjXwn7rjQV2pFtQ6Q@mail.gmail.com>
	<20120206225122.GF24840@quack.suse.cz>
	<CAOgv-zjjwoTnN7=a1kRHL_yVRzc5w3BfUfsY0_X61-rjzJJ2Hg@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAOgv-zjjwoTnN7=a1kRHL_yVRzc5w3BfUfsY0_X61-rjzJJ2Hg@mail.gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Gerard Saraber <gsaraber@gmail.com>
Cc: Jan Kara <jack@suse.cz>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

On Tue 07-02-12 10:35:37, Gerard Saraber wrote:
> On Mon, Feb 6, 2012 at 4:51 PM, Jan Kara <jack@suse.cz> wrote:
> > On Mon 06-02-12 09:40:45, Gerard Saraber wrote:
> >> Greetings everyone,
> >> I've been having a bit of a problem since upgrading to the linux 3.x
> >> series, I have a machine that we're using as a NAS that runs various
> >> rsync processes (mostly at night), lately after a day or two, I will
> >> come in in the morning to a load average of 49, but the machine not
> >> really doing anything, when trying to run 'dstat' the command just
> >> hung with no output at all. there were no errors in the logs, or even
> >> anything that would vaguely point at anything I could work with.
> >> So needing to get the machine back to work I attempted to reboot it
> >> "shutdown -r now" on console... it gives a nice message saying it's
> >> going to reboot, but nothing ever happens.. the only way to reboot it
> >> is by using ctrl + alt + sysrq + b. after which the machine reboots
> >> and the raid array comes back clean.
> >>
> >> I'm not sure how to troubleshoot this, any pointers would be appreciat=
ed.
> >>
> >> I'm compiling 3.2.4 at the moment and found a bunch of possibly useful
> >> options in the kernel debugging section:
> >> detect hard/soft lockups and detect hung tasks, maybe it'll give me
> >> something more to go on.
> >>
> >> Some details about the machine:
> >> Linux xenbox 3.2.2 #1 SMP Sun Jan 29 10:28:22 CST 2012 x86_64 Intel(R)
> >> Xeon(R) CPU 5140 @ 2.33GHz GenuineIntel GNU/Linux
> >> It has 3 software raid arrays (2 x 5 drives and 1 x 4 drives) LVM'ed
> >> together into a 23TB XFS filesystem.
> >> 6GB memory and a pair of Intel Gigabit ethernet controllers bonded tog=
ether.
> > =A0Hmm, might be some deadlock in the filesystem. Adding XFS guys to CC.
> > Can you run 'echo w >/proc/sysrq-trigger' and post output of dmesg here?
> >
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0Honza
> > --
> > Jan Kara <jack@suse.cz>
> > SUSE Labs, CR
> =

> Thanks for the quick reply,
> the machine is running good at the moment so I'm not sure if the
> output helps, but here it is:
> [I'll also be sure to grab this log the next time it locks]
  Yeah. Sorry, I was not clear but I meant you should grab the traces when
the machine locks up again...
								Honza

-- =

Jan Kara <jack@suse.cz>
SUSE Labs, CR

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

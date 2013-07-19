Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 37FB47F58
	for <xfs@oss.sgi.com>; Fri, 19 Jul 2013 14:13:35 -0500 (CDT)
Date: Fri, 19 Jul 2013 14:13:31 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [Bisected] Corruption of root fs during git bisect of drm
	system hang
Message-ID: <20130719191331.GG3572@sgi.com>
References: <20130713090523.GA362@x4> <20130712070721.GA359@x4>
	<20130715022841.GH5228@dastard> <20130715064734.GA361@x4>
	<20130719122235.GA360@x4>
	<CAAxjCExBi-4Qgf6-=MBzdkzBmMtu=GTURu46DoD2CzpnF2dinw@mail.gmail.com>
	<20130719125149.GB360@x4> <51E9630A.3070201@sandeen.net>
	<20130719163220.GA363@x4>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130719163220.GA363@x4>
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
To: Markus Trippelsdorf <markus@trippelsdorf.de>
Cc: Stefan Ring <stefanrin@gmail.com>, Eric Sandeen <sandeen@sandeen.net>, Mark Tinguely <tinguely@sgi.com>, Stan Hoeppner <stan@hardwarefreak.com>, Linux fs XFS <xfs@oss.sgi.com>

Hey Markus,

On Fri, Jul 19, 2013 at 06:32:20PM +0200, Markus Trippelsdorf wrote:
> On 2013.07.19 at 11:02 -0500, Eric Sandeen wrote:
> > > Unfortunately it turned out that in this case there is filesystem
> > > corruption. (Fortunately this normally happens only very rarely on rc1
> > > kernels).
> > 
> > Corruption is when you get back data that you did not write,
> > or metadata which is inconsistent or unreadable even after a proper
> > log replay.
> > 
> > Corruption is _not_ unsynced, buffered data that was lost on a
> > crash or poweroff.
> > 
> > But I might not have followed the thread properly, and I might
> > misunderstand your situation.
> > 
> > When you experience this lost file [data] scenario, was it after an
> > orderly reboot, or after a crash and/or system reset?
> 
> To reproduce this issue simply boot into your desktop and then hit
> sysrq-c and reboot. After log replay without error messages, the
> filesystem is in an inconsistent state and many small config files are
> lost. There are also undeletable files. You need to run xfs_repair
> manually to bring the filesystem back to normal.
> 
> When cca9f93a52d is reverted, you don't loose your config files and the
> filesystem is OK after log replay. xfs_repair reports no issues at all.

I'm a bit late to the party, but I wanted to give this a try.

On the machine I tried, I was not able to reproduce any corruption with a

echo b > /proc/sysrq-trigger

xfs_repair -n found no problems at all.  I'll try it on a few more.

Could you post some of your latest xfs_repair output?  And, have you been able
to reproduce this on more than one machine?  I may have missed that detail
earlier in the thread.

Thanks much,
	Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

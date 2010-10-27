Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o9RKwfpf198201 for <xfs@oss.sgi.com>; Wed, 27 Oct 2010 15:58:42 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id AD2FB136162D
	for <xfs@oss.sgi.com>; Wed, 27 Oct 2010 14:15:37 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail13.adl6.internode.on.net
	[150.101.137.98]) by cuda.sgi.com with ESMTP id
	O5XDjWJKehxwE529 for <xfs@oss.sgi.com>;
	Wed, 27 Oct 2010 14:15:37 -0700 (PDT)
Date: Thu, 28 Oct 2010 07:59:55 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Pid: 8345, comm: rsync Not tainted 2.6.32.22intel #1
Message-ID: <20101027205955.GB2715@dastard>
References: <4CC67450.9020602@profihost.ag> <201010270124.44846@zmi.at>
	<20101027035548.GD32255@dastard> <201010271258.45965@zmi.at>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <201010271258.45965@zmi.at>
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
To: Michael Monnerie <michael.monnerie@is.it-management.at>
Cc: xfs@oss.sgi.com

On Wed, Oct 27, 2010 at 12:58:45PM +0200, Michael Monnerie wrote:
> On Mittwoch, 27. Oktober 2010 Dave Chinner wrote:
> > I'd suggest that people learn how to tweak udev hotplug rules so
> > that when the device is first created (i.e. during hotplug) the
> > scheduler, queue depth and readahead are set automatically. That way
> > you don't have to rely on devices being discovered before your script
> > runs...
> > 
> > Another benefit of doing it this way is that it is easy to set
> > default rules for different types of devices based on regex matching
> > e.g. different configs for "sd*" vs "dm*" vs "vd*" are trivial to
> > set up.
> 
> Sounds very nice. But the script I use will still work when upgrading 
> the server from openSUSE 11.2 to 11.3, and is therefore the preferred 
> choice for me.
> 
> Also, I'd need to find information and learn how to tweak udev hotplug 
> rules.

GIYF.

> I want to implement this on about 30 VMs on 2 different hosts, 
> with 3 different release states of servers (openSUSE 11.1, 11.2 and 
> 11.3).

The udev rule format hasn't changed in a long while. The same rule
set should work on all of these.

> The chance is high that I'd need two or three different udev 
> tweaks for the different releases, so I don't see the benefit of udev 
> for me. I wrote the script in about the same time I wrote this mail.

You'd need one regex per device type you want to tweak with
different values.

> That's always the problem between developers ("ah, cool new stuff") and 
> admins ("i need this on 500 servers with least possible work for me, and 
> it must still work after any updates/upgrades").

This is not "cool new stuff" - I've seen it used for exactly this
purpose for _several years_ by distros. e.g. pulling the identifier
string from the device to set hardware device specific tunables,
changing default dm/md readahead, etc. It's not new, and is easy to
configure generically so it works on a wide array of different machines.

And if you hotplug devices, it just works automatically - you don't
need to rerun a script after every hotplug...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

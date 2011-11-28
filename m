Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pASFQu9r239590 for <xfs@oss.sgi.com>; Mon, 28 Nov 2011 09:26:57 -0600
Received: from campbell-lange.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id DCD1012800DC
	for <xfs@oss.sgi.com>; Mon, 28 Nov 2011 07:26:53 -0800 (PST)
Received: from campbell-lange.net (campbell-lange.net [93.191.37.68]) by
	cuda.sgi.com with ESMTP id FAjzoMlwhkY5mwCP for
	<xfs@oss.sgi.com>; Mon, 28 Nov 2011 07:26:53 -0800 (PST)
Date: Mon, 28 Nov 2011 15:26:52 +0000
From: Jon Marshall <jon@campbell-lange.net>
Subject: Re: XFS on CoRAID errors with SMB
Message-ID: <20111128152652.GD1795@campbell-lange.net>
References: <20111128135518.GA1232@campbell-lange.net>
	<4ED39EBE.2070206@scalableinformatics.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4ED39EBE.2070206@scalableinformatics.com>
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
To: Joe Landman <landman@scalableinformatics.com>
Cc: xfs@oss.sgi.com

Hi Joe,

Thanks for the rapid response.

Is this something that has been reported often in relation to AoE? Is
there any chance you could point us in the direction of some more
background on the issue? I am checking the AoE mailing list, but if you know
of something specific that would be very helpful.

I am also looking into the ethernet drivers we have in place on the
system in question.

Again, thanks for the quick and informative response.

Jon

On Mon, Nov 28, 2011 at 09:46:22AM -0500, Joe Landman wrote:
> On 11/28/2011 08:55 AM, Jon Marshall wrote:
> >Hi,
> >
> >We have recently experienced what appear to be XFS filesystem errors on
> >a samba share. The actual filesystem resides on a network attached
> >storage device, a Coraid. The attached server locked up totally, and we
> >forced to hard reset it.
> 
> This is (from our past experience working with these units and the
> AoE system), more likely the AoE driver crashing (or something on
> the underlying network failing).  From there, the file system
> eventually dies.
> 
> This isn't an xfs problem per se, xfs is sort of an uwilling
> participant in a slow motion crash.
> 
> >I have the following trace from the kernel logs:
> >
> >[6128798.051868] smbd: page allocation failure. order:4, mode:0xc0d0
> >[6128798.051872] Pid: 16908, comm: smbd Not tainted 2.6.32-5-amd64 #1
> >[6128798.051874] Call Trace:
> >[6128798.051882]  [<ffffffff810ba5d6>] ? __alloc_pages_nodemask+0x592/0x5f4
> >[6128798.051885]  [<ffffffff810b959c>] ? __get_free_pages+0x9/0x46
> >[6128798.051889]  [<ffffffff810e7ea1>] ? __kmalloc+0x3f/0x141
> 
> If you note the failed kmalloc, something ran you out of memory.
> What we've run into in the past with this has been a driver memory
> leak (usually older model e1000 or similar drivers)
> 
> [...]
> 
> >smbd seems to throw these errors for about 15 minutes, then sshd starts
> >throwing errors and shortly after the system became unresponsive.
> >
> >Just wondering if anyone had any experience of similar results, with XFS
> >on a CoRAID device or XFS SMB shares?
> 
> This is what you see when the AoE stack collapses due to a crash of
> one of the lower block rungs.  XFS can't run if it can't allocate
> memory for itself.  smbd dies when the underlying filesystem goes
> away.  sshd probably gets unresponsive in part, due to all the IOs
> queuing up that the scheduler can't do anything with.  Before sshd
> stops working, user load winds up past 5x number of CPUs, then past
> 10x, then ...
> 
> Once you see this happening, its time to kill the upper level stacks
> if possible, and unmount the file system as rapidly as possible.  If
> you can't kill the stuff above it, a 'umount -l ' is your friend.
> You *may* be able to regain enough control for a non-crash based
> reboot.  Even with this, I'd recommend changing / to sync before
> either forcing a reboot
> 
>    mount -o remount,sync /
> 
> to preserve the integrity of the OS drive.
> 
> Then reboot (or if the user load is too high, and a reboot command
> will just hang ... hopefully you have IPMI on you unit so you can do
> an 'ipmitool -I open chassis power cycle' hard bounce)
> 
> 
> 
> 
> 
> >
> >Thanks
> >Jon
> >
> 
> 
> -- 
> Joseph Landman, Ph.D
> Founder and CEO
> Scalable Informatics Inc.
> email: landman@scalableinformatics.com
> web  : http://scalableinformatics.com
>        http://scalableinformatics.com/sicluster
> phone: +1 734 786 8423 x121
> fax  : +1 866 888 3112
> cell : +1 734 612 4615
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

-- 
Jon Marshall
Technical Officer
jon@campbell-lange.net
.
Campbell-Lange Workshop
www.campbell-lange.net
0207 6311 555
3 Tottenham Street London W1T 2AF
Registered in England No. 04551928

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

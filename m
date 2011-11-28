Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pASEjiC8238373 for <xfs@oss.sgi.com>; Mon, 28 Nov 2011 08:45:44 -0600
Received: from crunch.scalableinformatics.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C9868652DE2
	for <xfs@oss.sgi.com>; Mon, 28 Nov 2011 06:45:36 -0800 (PST)
Received: from crunch.scalableinformatics.com
	(173-10-54-97-Michigan.hfc.comcastbusiness.net [173.10.54.97])
	by cuda.sgi.com with ESMTP id q6UvPgQv1tqOOyom for
	<xfs@oss.sgi.com>; Mon, 28 Nov 2011 06:45:36 -0800 (PST)
Received: from crunch.scalableinformatics.com (localhost [127.0.0.1])
	by crunch.scalableinformatics.com (Postfix) with ESMTP id 7F70580AC9FF
	for <xfs@oss.sgi.com>; Mon, 28 Nov 2011 09:45:35 -0500 (EST)
Received: from [192.168.1.171] (metal.scalableinformatics.com [192.168.1.171])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by crunch.scalableinformatics.com (Postfix) with ESMTPSA id
	75D138055E47
	for <xfs@oss.sgi.com>; Mon, 28 Nov 2011 09:45:35 -0500 (EST)
Message-ID: <4ED39EBE.2070206@scalableinformatics.com>
Date: Mon, 28 Nov 2011 09:46:22 -0500
From: Joe Landman <landman@scalableinformatics.com>
MIME-Version: 1.0
Subject: Re: XFS on CoRAID errors with SMB
References: <20111128135518.GA1232@campbell-lange.net>
In-Reply-To: <20111128135518.GA1232@campbell-lange.net>
Reply-To: landman@scalableinformatics.com
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

On 11/28/2011 08:55 AM, Jon Marshall wrote:
> Hi,
>
> We have recently experienced what appear to be XFS filesystem errors on
> a samba share. The actual filesystem resides on a network attached
> storage device, a Coraid. The attached server locked up totally, and we
> forced to hard reset it.

This is (from our past experience working with these units and the AoE 
system), more likely the AoE driver crashing (or something on the 
underlying network failing).  From there, the file system eventually dies.

This isn't an xfs problem per se, xfs is sort of an uwilling participant 
in a slow motion crash.

> I have the following trace from the kernel logs:
>
> [6128798.051868] smbd: page allocation failure. order:4, mode:0xc0d0
> [6128798.051872] Pid: 16908, comm: smbd Not tainted 2.6.32-5-amd64 #1
> [6128798.051874] Call Trace:
> [6128798.051882]  [<ffffffff810ba5d6>] ? __alloc_pages_nodemask+0x592/0x5f4
> [6128798.051885]  [<ffffffff810b959c>] ? __get_free_pages+0x9/0x46
> [6128798.051889]  [<ffffffff810e7ea1>] ? __kmalloc+0x3f/0x141

If you note the failed kmalloc, something ran you out of memory.  What 
we've run into in the past with this has been a driver memory leak 
(usually older model e1000 or similar drivers)

[...]

> smbd seems to throw these errors for about 15 minutes, then sshd starts
> throwing errors and shortly after the system became unresponsive.
>
> Just wondering if anyone had any experience of similar results, with XFS
> on a CoRAID device or XFS SMB shares?

This is what you see when the AoE stack collapses due to a crash of one 
of the lower block rungs.  XFS can't run if it can't allocate memory for 
itself.  smbd dies when the underlying filesystem goes away.  sshd 
probably gets unresponsive in part, due to all the IOs queuing up that 
the scheduler can't do anything with.  Before sshd stops working, user 
load winds up past 5x number of CPUs, then past 10x, then ...

Once you see this happening, its time to kill the upper level stacks if 
possible, and unmount the file system as rapidly as possible.  If you 
can't kill the stuff above it, a 'umount -l ' is your friend.  You *may* 
be able to regain enough control for a non-crash based reboot.  Even 
with this, I'd recommend changing / to sync before either forcing a reboot

    mount -o remount,sync /

to preserve the integrity of the OS drive.

Then reboot (or if the user load is too high, and a reboot command will 
just hang ... hopefully you have IPMI on you unit so you can do an 
'ipmitool -I open chassis power cycle' hard bounce)





>
> Thanks
> Jon
>


-- 
Joseph Landman, Ph.D
Founder and CEO
Scalable Informatics Inc.
email: landman@scalableinformatics.com
web  : http://scalableinformatics.com
        http://scalableinformatics.com/sicluster
phone: +1 734 786 8423 x121
fax  : +1 866 888 3112
cell : +1 734 612 4615

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

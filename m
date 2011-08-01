Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p714kwAL244964 for <xfs@oss.sgi.com>; Sun, 31 Jul 2011 23:46:58 -0500
Received: from a.mail.sonic.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 78261B0126
	for <xfs@oss.sgi.com>; Sun, 31 Jul 2011 21:46:57 -0700 (PDT)
Received: from a.mail.sonic.net (a.mail.sonic.net [64.142.16.245]) by
	cuda.sgi.com with ESMTP id WDBTLrNjw2c5bjr7 for
	<xfs@oss.sgi.com>; Sun, 31 Jul 2011 21:46:57 -0700 (PDT)
Received: from localhost.localdomain (wombat.san-francisco.ca.us
	[75.101.60.64])
	by a.mail.sonic.net (8.13.8.Beta0-Sonic/8.13.7) with ESMTP id
	p714kus2007689 for <xfs@oss.sgi.com>; Sun, 31 Jul 2011 21:46:56 -0700
Date: Sun, 31 Jul 2011 21:46:54 -0700
From: Keith Keller <kkeller@sonic.net>
Subject: Re: xfs_growfs doesn't resize (partial resolution)
Message-ID: <20110801044654.GA1853@sonic.net>
References: <20110707182532.GA31319@sonic.net> <4E160A34.20902@sandeen.net>
	<20110707222350.GA776@sonic.net> <4E163396.2010707@sandeen.net>
	<20110720190819.GA14910@sonic.net>
	<20110725182851.GA30626@sonic.net>
Mime-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110725182851.GA30626@sonic.net>
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

Hello again everyone,

I was able to perform the steps I proposed last week:

On Mon, Jul 25, 2011 at 11:28:51AM -0700, Keith Keller wrote:
> --take another backup
> --umount all XFS filesystems (the OS filesystems are ext3)
> --remove the kmod-xfs CentOS package
> --update to the latest CentOS kernel and reboot, making sure
>   the target XFS fs does not have a mount attempted
> --run xfs_repair from xfsprogs-3.1.5
> --cross fingers :)
> --mount and check what's in lost+found

For posterity sake, I thought I should post my results.  Everything went
very smoothly, actually--even though the repair of the metadump I took
reported errors, when I worked with the actual filesystem, it fixed
superblock 0 but otherwise found no errors.  The xfs_repair took about
42 minutes, compared to about 35-40 minutes to operate (on similar but
different hardware) on the metadump.  That's really nice performance--I
had to e2fsck a ~5TB filesystem the other day, and it took about 5 hours
total.

> --if all seems well, attempt another xfs_growfs using xfsprogs-3.1.5

I haven't yet attempted this final step.  I am going to wait till I
return from another vacation to do so.  :)  But I am hopeful that with
the latest kernel available from the CentOS repos that I should be fine.
Is there a way to directly query the running module for version
information, so that I can try to verify that I have a version that will
work?  Here's my uname, if it's helpful:

Linux xxxxxxxxxx 2.6.18-238.19.1.el5 #1 SMP Fri Jul 15 07:31:24 EDT 2011 x86_64 x86_64 x86_64 GNU/Linux

--keith

-- 
kkeller@wombat.san-francisco.ca.us

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

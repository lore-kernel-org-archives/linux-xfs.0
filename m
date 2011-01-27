Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p0RNdUXL051152 for <xfs@oss.sgi.com>; Thu, 27 Jan 2011 17:39:31 -0600
Received: from ipmail06.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 10DB0297ED5
	for <xfs@oss.sgi.com>; Thu, 27 Jan 2011 15:41:54 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	NqSX9fdwJ9QsnGMX for <xfs@oss.sgi.com>;
	Thu, 27 Jan 2011 15:41:54 -0800 (PST)
Date: Fri, 28 Jan 2011 10:41:52 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfs: very slow after mount, very slow at umount
Message-ID: <20110127234152.GN21311@dastard>
References: <4D40C8D1.8090202@teksavvy.com> <20110127033011.GH21311@dastard>
	<4D40EB2F.2050809@teksavvy.com> <4D418B57.1000501@teksavvy.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4D418B57.1000501@teksavvy.com>
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
To: Mark Lord <kernel@teksavvy.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com, Linux Kernel <linux-kernel@vger.kernel.org>, Stan Hoeppner <stan@hardwarefreak.com>, Alex Elder <aelder@sgi.com>

On Thu, Jan 27, 2011 at 10:12:23AM -0500, Mark Lord wrote:
> On 11-01-27 12:30 AM, Stan Hoeppner wrote:
> > Mark Lord put forth on 1/26/2011 9:49 PM:
> > 
> >> agcount=7453
> > 
> > That's probably a bit high Mark, and very possibly the cause of your problems.
> > :)  Unless the disk array backing this filesystem has something like 400-800
> > striped disk drives.  You said it's a single 2TB drive right?
> > 
> > The default agcount for a single drive filesystem is 4 allocation groups.  For
> > mdraid (of any number of disks/configuration) it's 16 allocation groups.
> > 
> > Why/how did you end up with 7452 allocation groups?  That can definitely cause
> > some performance issues due to massively excessive head seeking, and possibly
> > all manner of weirdness.
> 
> This is great info, exactly the kind of feedback I was hoping for!
> 
> The filesystem is about a year old now, and I probably used agsize=nnnnn
> when creating it or something.
> 
> So if this resulted in what you consider to be many MANY too MANY ags,
> then I can imagine the first new file write wanting to go out and read
> in all of the ag data to determine the "best fit" or something.
> Which might explain some of the delay.
> 
> Once I get the new 2TB drive, I'll re-run mkfs.xfs and then copy everything
> over onto a fresh xfs filesystem.
> 
> Can you recommend a good set of mkfs.xfs parameters to suit the characteristics
> of this system? 

http://xfs.org/index.php/XFS_FAQ#Q:_I_want_to_tune_my_XFS_filesystems_for_.3Csomething.3E

And perhaps you want to consider the allocsize mount option, though
that shouldn't be necessary for 2.6.38+...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

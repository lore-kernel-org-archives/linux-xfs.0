Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p0RFA0Wd234327 for <xfs@oss.sgi.com>; Thu, 27 Jan 2011 09:10:00 -0600
Received: from ironport2-out.pppoe.ca (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1EF001DC3AC7
	for <xfs@oss.sgi.com>; Thu, 27 Jan 2011 07:12:24 -0800 (PST)
Received: from ironport2-out.pppoe.ca (ironport2-out.teksavvy.com
	[206.248.154.181]) by cuda.sgi.com with ESMTP id
	T7iQusgxPid355ZQ for <xfs@oss.sgi.com>;
	Thu, 27 Jan 2011 07:12:24 -0800 (PST)
Message-ID: <4D418B57.1000501@teksavvy.com>
Date: Thu, 27 Jan 2011 10:12:23 -0500
From: Mark Lord <kernel@teksavvy.com>
MIME-Version: 1.0
Subject: Re: xfs: very slow after mount, very slow at umount
References: <4D40C8D1.8090202@teksavvy.com> <20110127033011.GH21311@dastard>
	<4D40EB2F.2050809@teksavvy.com>
In-Reply-To: <4D40EB2F.2050809@teksavvy.com>
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
To: Stan Hoeppner <stan@hardwarefreak.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com, Linux Kernel <linux-kernel@vger.kernel.org>, Alex Elder <aelder@sgi.com>

On 11-01-27 12:30 AM, Stan Hoeppner wrote:
> Mark Lord put forth on 1/26/2011 9:49 PM:
> 
>> agcount=7453
> 
> That's probably a bit high Mark, and very possibly the cause of your problems.
> :)  Unless the disk array backing this filesystem has something like 400-800
> striped disk drives.  You said it's a single 2TB drive right?
> 
> The default agcount for a single drive filesystem is 4 allocation groups.  For
> mdraid (of any number of disks/configuration) it's 16 allocation groups.
> 
> Why/how did you end up with 7452 allocation groups?  That can definitely cause
> some performance issues due to massively excessive head seeking, and possibly
> all manner of weirdness.

This is great info, exactly the kind of feedback I was hoping for!

The filesystem is about a year old now, and I probably used agsize=nnnnn
when creating it or something.

So if this resulted in what you consider to be many MANY too MANY ags,
then I can imagine the first new file write wanting to go out and read
in all of the ag data to determine the "best fit" or something.
Which might explain some of the delay.

Once I get the new 2TB drive, I'll re-run mkfs.xfs and then copy everything
over onto a fresh xfs filesystem.

Can you recommend a good set of mkfs.xfs parameters to suit the characteristics
of this system?  Eg. Only a few thousand active inodes, and nearly all files are
in the 600MB -> 20GB size range.  The usage pattern it must handle is up to
six concurrent streaming writes at the same time as up to three streaming reads,
with no significant delays permitted on the reads.

That's the kind of workload that I find XFS handles nicely,
and EXT4 has given me trouble with in the past.

Thanks

-ml

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

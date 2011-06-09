Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p59IOXaK191518 for <xfs@oss.sgi.com>; Thu, 9 Jun 2011 13:24:33 -0500
Received: from greer.hardwarefreak.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6C5524B0619
	for <xfs@oss.sgi.com>; Thu,  9 Jun 2011 11:24:31 -0700 (PDT)
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id mZ94QC7HKvVYDV57
	for <xfs@oss.sgi.com>; Thu, 09 Jun 2011 11:24:31 -0700 (PDT)
Message-ID: <4DF10FDF.1090508@hardwarefreak.com>
Date: Thu, 09 Jun 2011 13:24:31 -0500
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: Defragging XFS File Systems
References: <BANLkTi=40mmE+DCbLcSWBwNQtWpP=N=tXw@mail.gmail.com>
	<201106090749.37745@zmi.at> <4DF080AC.2090507@hardwarefreak.com>
	<201106091212.36227@zmi.at>
In-Reply-To: <201106091212.36227@zmi.at>
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
Cc: Kenneth Emerson <kenneth.emerson@gmail.com>, xfs@oss.sgi.com

On 6/9/2011 5:12 AM, Michael Monnerie wrote:
> On Donnerstag, 9. Juni 2011 Stan Hoeppner wrote:
>> When is running xfs_fsr recommended?
> 
> Good question. One case that comes to my mind is a filesystem that was 
> used a long time when filled >85%, which has now either been expanded or 
> files removed so you have a lot of space again, and you want to defrag 
> all those files that have been badly fragmented.
>  
>> I scheduled it twice a week some time ago due to a filesystem
>> containing active mbox files.  I did so because they became so
>> heavily fragmented in short order, especially those swallowing
>> copious amounts of list mail.  Before cron'ing xfs_fsr I was seeing
>> mbox files with over 1000 fragmented extents, and increasing MUA
>> latency as the files became more fragmented.  The filesystem is
>> currently 90% free.
> 
> This is also an example where defrag may help. You have 10% usage, so 
> there's enough space. Maybe your usage fits the mount option 
> "allocsize", 

I tried allocsize=1m but it didn't seem to help already existing files.
 I simply don't think there's much that can be done in filesystem logic
to keep long lived constantly appended files from fragmenting, short of
the log rotation method, which isn't really suitable for large mbox
files.  Maildir is obviously an option to combat fragmentation, but it
has downsides as well, mainly much higher small file IOPS during normal
operation.  Using mbox I can 'hide the IO' by running xfs_fsr at night
and/or on weekends.

> so that you keep room for file append. But newer kernels 
> changed behaviour of XFS, so I'm not sure up to which kernel version its 
> good. Maybe Dave Chinner can chime in here. BTW, maybe this behaviour 
> should be documented in the FAQ so we can reference it.

My current method seems to work well for now.  This filesystem will
likely not even be half full by the time this server is replaced in a
few years, so I probably don't need to worry about xfs_fsr efficiency
WRT free space.  Due to the low cost of today's gargantuan platters, I'm
guessing there are likely many admins in a similar position.  Four 600GB
SAS drives in RAID10 yields ~1.2TB of mail storage.  That's a lot of
space, and performance, for small/medium organization's mailboxes...

-- 
Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

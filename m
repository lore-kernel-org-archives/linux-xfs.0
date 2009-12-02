Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nB2EmxQO006129 for <xfs@oss.sgi.com>; Wed, 2 Dec 2009 08:48:59 -0600
Received: from lucidpixels.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 617BF14EFA67
	for <xfs@oss.sgi.com>; Wed,  2 Dec 2009 06:49:28 -0800 (PST)
Received: from lucidpixels.com (lucidpixels.com [75.144.35.66]) by
	cuda.sgi.com with ESMTP id Kr3nbWEjhJRoAy0v for
	<xfs@oss.sgi.com>; Wed, 02 Dec 2009 06:49:28 -0800 (PST)
Date: Wed, 2 Dec 2009 09:49:27 -0500 (EST)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: Performance problem with multiple parallel rm -rf's
In-Reply-To: <4B163B20.6030808@syseleven.de>
Message-ID: <alpine.DEB.2.00.0912020948270.30441@p34.internal.lan>
References: <4B163B20.6030808@syseleven.de>
MIME-Version: 1.0
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
To: Jens Rosenboom <j.rosenboom@syseleven.de>
Cc: xfs@oss.sgi.com



On Wed, 2 Dec 2009, Jens Rosenboom wrote:

> On a large 13TB XFS volume that is being used for backups, I am seeing bad 
> performance if multiple "rm -rf" processes are running in parallel. The 
> backups are being done with rsnapshot and the first operation it does is 
> removing the oldest snapshot. A single rsnapshot does this in reasonable 
> time, but if four jobs are started at the same time, all their rm processes 
> run for hours without making much progress.
>
> This seems to be related to the planned optimizations in
>
> http://xfs.org/index.php/Improving_Metadata_Performance_By_Reducing_Journal_Overhead
>
> Are there any other tuning options I might try? I'm already using 
> "noatime,nodiratime,nobarrier,logbufs=8,logbsize=256k" as mount options and 
> did enable lazy_counters for the fs.
>
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
>

For faster rm performance you need a bigger log (128m-256mb), that is 
shown to increase delete performance.  But I am not sure there is a way to 
change the size of it once the array has been created.  An alternative may 
be creating another volume for a log.

Also: nodiratime is not needed, as it is implied by noatime.

Justin.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

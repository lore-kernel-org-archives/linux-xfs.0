Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p5R3XTKq029144
	for <linux-xfs@oss.sgi.com>; Sun, 26 Jun 2011 22:33:30 -0500
Received: from greer.hardwarefreak.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id DF0F61670F57
	for <linux-xfs@oss.sgi.com>; Sun, 26 Jun 2011 20:33:28 -0700 (PDT)
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id FMWlsk2y3kR69hFH
	for <linux-xfs@oss.sgi.com>; Sun, 26 Jun 2011 20:33:28 -0700 (PDT)
Message-ID: <4E07FA07.4050907@hardwarefreak.com>
Date: Sun, 26 Jun 2011 22:33:27 -0500
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: mkfs.xfs error creating large agcount an raid
References: <4E063BC6.9000801@task.com.br>
	<4E0694CC.8050003@hardwarefreak.com>	<4E06C967.2060107@task.com.br>
	<20110626235959.GC32466@dastard>
In-Reply-To: <20110626235959.GC32466@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@oss.sgi.com, Marcus Pereira <marcus@task.com.br>

On 6/26/2011 6:59 PM, Dave Chinner wrote:
> On Sun, Jun 26, 2011 at 02:53:43AM -0300, Marcus Pereira wrote:

>> There is already insane head seeking at this server, hundreds of
>> simultaneous users reading their mailboxes.

I missed this part of the reply probably due to the reply formatting
style used.

> Perhaps you should just usethe defaults first and only consider
> changes if there is an obvious problem,?
> 
>> In fact I was trying to
>> reduce the head seeking with larger agcounts.
> 
> AGs are not for reducing seeking - they are for increasing
> allocation parallelism and scaling freespace indexes to extremely
> large filesystem sizes.
> 
> In fact, trying to use more than a few hundred AGs will hit internal
> AG indexing scalability limitations, especially as you start to fill
> up AGs and have to scan for AGs with free space in them.
> 
> IOWs, using large numbers of AGs are inadvisable for many reasons.

Marcus, if you are seeing excessive head seeking with this maildir
workload, the problem isn't the number of AGs.  The problem is that
you're using striping for a small file high random IOPS workload, and
you don't have enough spindles, thus not enough seek bandwidth.

I recommend 3 changes, one of which I previously mentioned:

1.  Use 8 mirror pairs instead of 4
2.  Don't use striping.  Make an mdraid --linear device of the 8 mirrors
3.  Format with '-d agcount=32' which will give you 4 AGs per spindle

With striping, each file IO will generate multiple head seeks per
spindle across all spindles.  With a linear array each file IO will
typically only generate seeks on a single spindle, as the metadata and
file data should be within the same AG.

Test this configuration and post your results.

-- 
Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

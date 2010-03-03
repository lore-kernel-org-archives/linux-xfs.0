Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o230h2A7027452 for <xfs@oss.sgi.com>; Tue, 2 Mar 2010 18:43:02 -0600
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2D93D1D0CE6C
	for <xfs@oss.sgi.com>; Tue,  2 Mar 2010 16:44:29 -0800 (PST)
Received: from mail.sandeen.net (64-131-60-146.usfamily.net [64.131.60.146])
	by cuda.sgi.com with ESMTP id V8aKEAYFr5oFmdXr for
	<xfs@oss.sgi.com>; Tue, 02 Mar 2010 16:44:29 -0800 (PST)
Message-ID: <4B8DB0ED.5040109@sandeen.net>
Date: Tue, 02 Mar 2010 18:44:29 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: Stalled xfs_repair on 100TB filesystem
References: <DD534F7C25BFA14FB18E6D603135D7EA0A11E82ECB@sbapexch05>
	<4B8DAECA.50701@hardwarefreak.com>
In-Reply-To: <4B8DAECA.50701@hardwarefreak.com>
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
Cc: xfs@oss.sgi.com

Stan Hoeppner wrote:
> Jason Vagalatos put forth on 3/2/2010 11:22 AM:
>> Hello,
>> On Friday 2/26 I started an xfs_repair on a 100TB filesystem:
>>
>> #> nohup xfs_repair -v -l /dev/logfs-sessions/logdev /dev/logfs-sessions/sessions > /root/xfs_repair.out.logfs1.sjc.02262010 &
>>
>> I've been monitoring the process with 'top' and tailing the output file from the redirect above.  I believe the repair has "stalled".  When the process was running 'top' showed almost all physical memory consumed and 12.6G of virt memory consumed by xfs_repair.  It made it all the way to Phase 6 and has been sitting at agno = 14 for almost 48 hours.  The memory consumption of xfs_repair has ceased but the process is still "running" and consuming 100% CPU:
> 
> Here's how another user solved this xfs_repair "hanging" problem.  I say
> "hang" because "stall" didn't return the right Google results.
> 
> http://marc.info/?l=linux-xfs&m=120600321509730&w=2
> 
> Excerpt:
> 
> "In betwenn I created a test filesystem 360GB with 120million inodes on it.
> xfs_repair without options is unable to complete. If I run xfs_repair -o
> bhash=8192 the repair process terminates normally (the filesystem is
> actually ok)."
> 
> Unfortunately it appears you'll have to start the repair over again.
> 

FWIW, Jason - which xfsprogs version are you running?  This patch went in a while back:

> [PATCH] libxfs: increase hash chain depth when we run out of slots

> A couple people reported xfs_repair hangs after
> "Traversing filesystem ..." in xfs_repair.  This happens
> when all slots in the cache are full and referenced, and the
> loop in cache_node_get() which tries to shake unused entries
> fails to find any - it just keeps upping the priority and goes
> forever.
> 
> This can be worked around by restarting xfs_repair with
> -P and/or "-o bhash=<largersize>" for older xfs_repair.
> 
> I started down the path of increasing the number of hash buckets
> on the fly, but Barry suggested simply increasing the max allowed
> depth which is much simpler (thanks!)
> 
> Resizing the hash lengths does mean that cache_report ends up with
> most things in the "greater-than" category:
> 
> ...
> Hash buckets with  23 entries      3 (  3%)
> Hash buckets with  24 entries      3 (  3%)
> Hash buckets with >24 entries     50 ( 85%)
> 
> but I think I'll save that fix for another patch unless there's
> real concern right now.
> 
> I tested this on the metadump image provided by Tomek.
> 
> Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
> Reported-by: Tomek Kruszona <bloodyscarion@gmail.com>
> Reported-by: Riku Paananen <riku.paananen@helsinki.fi>
> ---


-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

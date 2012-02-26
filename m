Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q1Q4ZTDn208130 for <xfs@oss.sgi.com>; Sat, 25 Feb 2012 22:35:29 -0600
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id 1pVAckEigp1jktv5
	for <xfs@oss.sgi.com>; Sat, 25 Feb 2012 20:35:27 -0800 (PST)
Message-ID: <4F49B693.4080309@hardwarefreak.com>
Date: Sat, 25 Feb 2012 22:35:31 -0600
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: mount: Structure needs cleaning
References: <33393100.post@talk.nabble.com>
In-Reply-To: <33393100.post@talk.nabble.com>
Reply-To: stan@hardwarefreak.com
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
To: MikeJeezy <forums@mgaccess.net>
Cc: xfs@oss.sgi.com

On 2/25/2012 9:15 PM, MikeJeezy wrote:
> 
> I have two 2TB xfs volumes and earlier today the /var/log/messages shows
> "xfs_force_shutdown" after many errors (attached) 
> http://old.nabble.com/file/p33393100/var-log-message.txt var-log-message.txt
> .  Are there any options to try before running "xfs_repair -L"?   The
> volumes contain several millions files so that I my last resort.  I'm a
> novice at best in Linux.

Googling "XFS_WANT_CORRUPTED_RETURN at line 280" turns up a whole lot of
information on this.  This is an Oct 2008 response to another user with
this problem, from XFS developer Dave Chinner, one of the resident
experts on this list:

"The freespace btrees are getting out of sync for some reason.

That is, when we go to allocate an extent, we have to update two
free space btrees. This shutdown:

> XFS internal error XFS_WANT_CORRUPTED_RETURN at line 280 of file
fs/xfs/xfs_alloc.c.  Caller 0xf88e0018

Indicates the extent being allocated was not found in one of the
two trees.

This corruption could have happened a long time ago in the past, and
it may simply be coincidental that you've tripped over this at
roughly the same time you upgraded the kernel.

Can you run xfs_check on the filesystem to determine if a freespace
tree is corrupted (post the output if it is), then run xfs_repair
to rebuild them?"

So, run "xfs_check /dev/sde1" and post the output here.  Then await
further instructions.  Don't flush the log as that's probably not the
problem.  Doing so will delete pending metadata changes and could cause
you more headaches.

-- 
Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

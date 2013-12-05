Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 49EA37F3F
	for <xfs@oss.sgi.com>; Wed,  4 Dec 2013 21:40:42 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id BE402AC003
	for <xfs@oss.sgi.com>; Wed,  4 Dec 2013 19:40:41 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	DhiwZXVTyl8QFxFR for <xfs@oss.sgi.com>;
	Wed, 04 Dec 2013 19:40:39 -0800 (PST)
Date: Thu, 5 Dec 2013 14:40:34 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Sudden File System Corruption
Message-ID: <20131205034034.GI8803@dastard>
References: <CAPd9ww_qT9J_Rt04g7+OApoBeggNOyWNwD+57DiDTuUvz-O-0g@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAPd9ww_qT9J_Rt04g7+OApoBeggNOyWNwD+57DiDTuUvz-O-0g@mail.gmail.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Mike Dacre <mike.dacre@gmail.com>
Cc: xfs@oss.sgi.com

On Wed, Dec 04, 2013 at 06:55:05PM -0800, Mike Dacre wrote:
> Hi Folks,
> 
> Apologies if this is the wrong place to post or if this has been answered
> already.
> 
> I have a 16 2TB drive RAID6 array powered by an LSI 9240-4i.  It has an XFS
> filesystem and has been online for over a year.  It is accessed by 23
> different machines connected via Infiniband over NFS v3.  I haven't had any
> major problems yet, one drive failed but it was easily replaced.
> 
> However, today the drive suddenly stopped responding and started returning
> IO errors when any requests were made.  This happened while it was being
> accessed by  5 different users, one was doing a very large rm operation (rm
> *sh on thousands on files in a directory).  Also, about 30 minutes before
> we had connected the globus connect endpoint to allow easy file transfers
> to SDSC.

So, you had a drive die and at roughly the same time XFS started
reporting corruption problems and shut down? Chances are that the
drive returned garbage to XFS before died completely and that's what
XFS detected and shut down on. If you are unlucky in this situation,
the corruption can get propagated into the log by changes that are
adjacent to the corrupted region, and then you have problems with log
recovery failing because the corruption gets replayed....

> I have attached the complete log from the time it died until now.
> 
> In the end, I successfully repaired the filesystem with `xfs_repair -L
> /dev/sda1`.  However, I am nervous that some files may have been corrupted.
> 
> Do any of you have any idea what could have caused this problem?

When corruption appears at roughly the same time a drive dies, it's
almost always caused by the drive that failed. RAID doesn't repvent
disks from returning crap to the OS because nobody configures the
arrays to do read-verify cycles that would catch such a condition.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

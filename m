Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with SMTP id
	p3BLdM0c113414
	for <linux-xfs@oss.sgi.com>; Mon, 11 Apr 2011 16:39:23 -0500
Received: from ipmail05.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 460471E0B37C
	for <linux-xfs@oss.sgi.com>; Mon, 11 Apr 2011 14:42:42 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	Oa69WOJExzAg0QjP for <linux-xfs@oss.sgi.com>;
	Mon, 11 Apr 2011 14:42:42 -0700 (PDT)
Date: Tue, 12 Apr 2011 07:42:38 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: 2 question about XFS fragmentation and _fsr
Message-ID: <20110411214238.GE21395@dastard>
References: <DFA094D472104424BEA7AA9060DE0D6F@myXP>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <DFA094D472104424BEA7AA9060DE0D6F@myXP>
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
To: Janos Haar <janos.haar@netcenter.hu>
Cc: linux-xfs@oss.sgi.com

On Mon, Apr 11, 2011 at 07:39:07PM +0200, Janos Haar wrote:
> Hello list,
> 
> First, please CC me because i am not on the list.
> 
> Question 1:
> I am working in a data recovery company, and we are using one 3TB
> RAID storage with XFS to store the recovery cases in image files.
> For spare a lot of space, usually we are imaging only the used
> spaces of the filesystems. (for example 1TB system drive wich have
> only 80GB data inside but needs to be bootable, the image is similar
> like Ghost images)
> But this makes a lot of sparse files, wich right should be this way.
> Some cases are done and we are closed (image can be deleted), and
> some needs to store for long time.
> In the result, actually we have >6TB images on the 3TB disk, wich is
> 97.9% fragmented.

How are you determining that figure?

> Basically the sparse RAW disk images should be more faster
> accessible than the original drive, because this is 4disk raid,
> instead of one, AND the head don't need to travel through the empty
> space of the drive...
> But actually we are proud if we can read or write in 8-10MB/s! :-D
> I have started to read about xfs_fsr but there is almost none
> information, how it is _really_ working, and i am doubt about this
> will try to fill up all of my images, and therefore fail to do any
> improvement, or this will do the right job and will re-organize the
> sparse files again.
> The XFS_FSR can be good for me or not?

xfs_fsr preserves the layout of sparse files, so it is unlikely to
help you at all here. Remember, sparse files only reduce the amount
of space used by a file - they don't magically reduce the number of
seeks needed to read data from the files...

> If not, i suggest to implement an option to do sparse fles on the
> result or not in the next releases...
> I will say a huge thanks in the end. :-)
> 
> Question 2:
> One of our customers have one storage wich is exactly the same like
> the one wich is described on the Q1, but only used for samba storage
> for storing media files (big files.)
> I am sure, there is no torrent or similar, and i have told to the
> customers on the beginning "don't write more files parallel, to
> avoid fragmentation", but today the storage is >95% fragmented.

Once again, what does 95% fragmented mean?

> The customer sad, he only does file write one by one, and nothing more.
> How can this be?

Depends on your samba configuration to how it does writes. If it is
conigured to do sync writes then it will have all sorts of
fragmentation problems. So without more details about the workload,
the kernel that is being used, the fragmentation occurring (xfs_bmap
is your friend) and the samba config, there's little that can be
suggested here.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

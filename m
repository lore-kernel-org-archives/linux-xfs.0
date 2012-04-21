Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q3L0WLdw035261 for <xfs@oss.sgi.com>; Fri, 20 Apr 2012 19:32:21 -0500
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	wS0GiDcCfaUObTxp for <xfs@oss.sgi.com>;
	Fri, 20 Apr 2012 17:32:20 -0700 (PDT)
Date: Sat, 21 Apr 2012 10:32:18 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS restored to lost and found
Message-ID: <20120421003218.GH9541@dastard>
References: <4F90F45F.2010507@neulion.com> <20120420082127.GF9541@dastard>
	<4F919A63.7080101@neulion.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4F919A63.7080101@neulion.com>
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
To: Nick Hollingsworth <nick.hollingsworth@neulion.com>
Cc: xfs@oss.sgi.com

On Fri, Apr 20, 2012 at 10:18:27AM -0700, Nick Hollingsworth wrote:
> 
> 
> On 20/04/2012 01:21, Dave Chinner wrote:
> >On Thu, Apr 19, 2012 at 10:30:07PM -0700, Nick Hollingsworth wrote:
> >>Hi all,
> >>
> >>So I've managed to corrupt an XFS files system running on software
> >>RAID. How exactly I'm not sure....it may have been when using CentOS
> >>rescue when trying to get the system to boot.
> >>
> >>Using xfs_repair with various options I've managed to get the FS to
> >>a state where it'll mount but there are no directories only inode
> >>numbers in the lost and found directory.
> >Sounds like the root directory got corrupted/overwritten by
> >something and so the entire directory heirarchy got moved into
> >lost+found.  The inode numbers are used because the names are held
> >in the directory blocks and they couldn't be found.
> >
> >>Is there any way to remap these back to directories?
> >You'll need to examine the contents of every directory and file in
> >lost+found to work out where they cames from. if you are lucky,
> >it'll only be the root directory entries that are in lost_found and
> >the rest of the directories heirarchy will still be intact....
>
> I examined a few of the directories and could find some intact sub
> directories & files. Is this now a matter of manually recreating the
> original directories and moving lost+found pieces back into it as
> best I can or is there a more sophisticated way to put it back
> together?

Yes, a manual process, unfortunately. There are recovery tools out
there that can help identify types of files (e.g. images, videos,
etc) and reconstruct file names based on information within the
specific format. Google will help you find them....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

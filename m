Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id D36AB7F37
	for <xfs@oss.sgi.com>; Fri, 20 Mar 2015 17:28:56 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id A36E830404E
	for <xfs@oss.sgi.com>; Fri, 20 Mar 2015 15:28:53 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	V3z4mPoDPHMPA7Dg for <xfs@oss.sgi.com>;
	Fri, 20 Mar 2015 15:28:49 -0700 (PDT)
Date: Sat, 21 Mar 2015 09:28:43 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: inconsistent timestamp update in rename() of
	xfs/fat/gfs2/ramfs/jffs2...
Message-ID: <20150320222843.GK28621@dastard>
References: <20150320202339.GK25797@taesoo.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150320202339.GK25797@taesoo.org>
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
To: Taesoo Kim <taesoo@gatech.edu>
Cc: cmaiolino@redhat.com, sanidhya@gatech.edu, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, blee@gatech.edu, linux-fsdevel@vger.kernel.org, lczerner@redhat.com, csong84@gatech.edu, changwoo@gatech.edu

On Fri, Mar 20, 2015 at 04:23:39PM -0400, Taesoo Kim wrote:
> Hi all,
> 
> We've cross-checking patches from ext3/ext4, and found out
> inconsistent implementations of other fs. We want to ask whether this
> is intended or unexpected behavior. We will be able to send patches as
> soon as confirmed/acknowledged.
> 
> Ref.
> 
> (ext4) 53b7e9f6807c1274eee19201396b4c2b5f721553
> (ext3) 0b23076988b44b2c165e060248345de6f2337387
> 
>  | ext3/4: fix update of mtime and ctime on rename
> 
> ---------------------------------------------------------------------
> We summarized our finding:
>   (* means what we believe is correct beahvoir)
> 
> <Linux 4.0-rc2>
>                                         ramfs   affs    fsplus
>                         vfs xfs fat gfs2    jffs2   hfsh
> operation          | * |   |   |   |   |   |   |   |   |
> ===========================================================
> new_inode->i_ctime | V | - | - | V | V | - | - | V | - | -

This timestamp behaviour is undefined by posix, therefore all
filesystems are behaving "correctly" according to the POSIX
specification regardless of whether this timestamp is updated or
not.

http://pubs.opengroup.org/onlinepubs/9699919799/functions/rename.html

....
Upon successful completion, rename() shall mark for update the last data
modification and last file status change timestamps of the parent directory of
each file.
....
APPLICATION USAGE

Some implementations mark for update the last file status change timestamp of
renamed files and some do not. Applications which make use of the last file
status change timestamp may behave differently with respect to renamed files
unless they are designed to allow for either behavior.
....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id B031D7F56
	for <xfs@oss.sgi.com>; Tue,  2 Dec 2014 15:44:09 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 8102B304039
	for <xfs@oss.sgi.com>; Tue,  2 Dec 2014 13:44:09 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	L5aqMBFuGsQWIh8H for <xfs@oss.sgi.com>;
	Tue, 02 Dec 2014 13:44:06 -0800 (PST)
Received: from dave by dastard with local (Exim 4.80)
	(envelope-from <david@fromorbit.com>) id 1XvvEf-0006ee-7p
	for xfs@oss.sgi.com; Wed, 03 Dec 2014 08:43:53 +1100
Date: Wed, 3 Dec 2014 08:43:53 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/2] Add support to RENAME_EXCHANGE flag V8
Message-ID: <20141202214353.GB18131@dastard>
References: <20141202141341.GA15157@hades.localdomain>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20141202141341.GA15157@hades.localdomain>
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
To: xfs@oss.sgi.com

On Tue, Dec 02, 2014 at 12:13:42PM -0200, Carlos Maiolino wrote:
> Hi Dave,
> 
> 
> >> +			error = xfs_dir_replace(tp, ip2, &xfs_name_dotdot,
> >> +						dp1->i_ino, first_block,
> >> +						free_list, spaceres);
> >> +			if (error)
> >> +				goto out;
> 
> >now ip2 is modified, so it ctime/mtime dirty.
> 
> >> +
> >> +			/* transfer target ".." reference to dp1 */
> >> +			if (!S_ISDIR(ip1->i_d.di_mode)) {
> >> +				error = xfs_droplink(tp, dp2);
> >> +				if (error)
> >> +					goto out;
> >> +				error = xfs_bumplink(tp, dp1);
> >> +				if (error)
> >> +					goto out;
> >> +			}
> >> +			xfs_trans_ichgtime(tp, ip1, XFS_ICHGTIME_CHG);
> >> +			xfs_trans_ichgtime(tp, ip2,
> >> +					   XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
> >> +			xfs_trans_log_inode(tp, ip2, XFS_ILOG_CORE);
> 
> >But now you're unconditionally changing ctime on ip1 without it
> >having been modified and you aren't logging the change. Why is the
> >ctime changing (comments, please!)?
> 
> Ok, so, I can see that I didn't understand what we should do with
> logging here, for the moment, I thought we should bump the ip1 to
> notify userspace that changes has actually taken place here, even
> though we are not changing it anyway.

Comments are for explaining why you did something. If you are using
the same reasoning as xfs_rename (i.e. the "We always want to hit
the ctime on the source inode" comment), then the comment should be
present here explaining the reason for the ctime change.


> I'm not sure if I should log it too (and add a xfs_trans_log_inode for
> ip1).

If the code modifies the inode, it also needs to log it.

> So, should we also log it here together with ip1, or bumping ctime of ip1
> here is wrong?
> In this case, a more correct way to write it would be to not bump ip1 here but
> only in the next block, where we actually touches it?
> And regarding dp2 and dp1, we drop/bump its link counts here, should I care
> about logging them in this code block? My xfs logging knowledge is shallow by
> now :-(

You only need to log them once in a transaction, hence my
suggestion of using variables to track the timstamp changes required
by the cross rename followed by function exit logic that takes
action on all those modifications.

....

> >	int	ip1_flags = 0;
> >	int	ip2_flags = 0;
> >	int	dp2_flags = 0;
> >
> >	if (dp1 != dp2)
> >		dp2_flags = XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG;
> >
> >		if (S_ISDIR(ip1)) {
> >			ip1_flags |= XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG;
> >			ip2_flags |= XFS_ICHGTIME_CHG; /* because ... */
> >			.....
> >		}
> >
> >		if (S_ISDIR(ip2)) {
> >			ip1_flags |= XFS_ICHGTIME_CHG; /* because ... */
> >			ip2_flags |= XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG;
> >			.....
> >		}
> >	}
> >
> >	if (ip1_flags) {
> >		xfs_trans_ichgtime(tp, ip1, ip1_flags);
> >		xfs_trans_log_inode(tp, ip1);
> >	}
> >	if (ip2_flags) {
> >		xfs_trans_ichgtime(tp, ip2, ip2_flags);
> >		xfs_trans_log_inode(tp, ip2);
> >	}
> >	if (dp2_flags) {
> >		xfs_trans_ichgtime(tp, dp2, ip2_flags);
> >		xfs_trans_log_inode(tp, dp2);
> >	}
> >	xfs_trans_ichgtime(tp, dp2, XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
> >	xfs_trans_log_inode(tp, dp2);
> 
> I don't think that these extra variables will actually clear the code and make
> it more readable IMHO, calling xfs_trans_ichgtime with the flags directly looks
> more clear and readable to me.

I find it much more informative that a random smattering of repeated
calls to xfs_trans_ichgtime/xfs_trans_log_inode throughout the
function. There's a clear separation of intent (i.e. what needs to
be changed in what branch) from action (the actual timestamp
changes and logging) and so is going to be much easier to understand
in a couple of years time. It's also more efficient code because we
only update timestamps once for each inode.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

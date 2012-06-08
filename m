Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q58H34PI236650 for <xfs@oss.sgi.com>; Fri, 8 Jun 2012 12:03:04 -0500
Date: Fri, 8 Jun 2012 12:09:43 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: Still seeing hangs in xlog_grant_log_space
Message-ID: <20120608170943.GO4721@sgi.com>
References: <CAH4wwdGWHSZoveLJMxu5pjr22NEEeW7oG8TS+snoM8RY=ZeRmg@mail.gmail.com>
	<CADLDEKsGtsw-rrSOE7gY4T81u+p41b34ixv0B7Dh07afJ73n2w@mail.gmail.com>
	<CAH4wwdFu7DEkHFZ5Bf7_PtLPsG0hUyUDoov03q=82R6t+QkERg@mail.gmail.com>
	<20120605235447.GF22848@dastard> <4FCF5DB9.2000808@redhat.com>
	<20120607013531.GP22848@dastard> <4FD0B7B6.3000704@redhat.com>
	<20120608002826.GV4347@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120608002826.GV4347@dastard>
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
Cc: Brian Foster <bfoster@redhat.com>, xfs@oss.sgi.com

On Fri, Jun 08, 2012 at 10:28:26AM +1000, Dave Chinner wrote:
...
> And because the inodes pin the tail of the AIL, there's not enough
> space in the log for the xfs_sync_worker to trigger a log force via
> the dummy transaction, and hence we deadlock.
>
> FWIW, there's an argument that can be made here for an unconditional
> log force in xfs_sync_worker() to provide a "get out gaol free" card
> here. 

No kidding!
http://oss.sgi.com/archives/xfs/2012-05/msg00312.html

> The thing is, I would prefer that the filesystems hang so that
> we find out about these issues and have to understand them and fix
> them. IMO, there is nothing harder to detect and debug than short
> duration, temporary stalls of the filesystem...

I agree.. such a patch is not for general consumption.  We want to fix the
actual problem, not work around it with a prod on a timer.  ;)

Regards,
	Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

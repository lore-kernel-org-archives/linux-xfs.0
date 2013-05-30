Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 31DCE7F37
	for <xfs@oss.sgi.com>; Thu, 30 May 2013 12:07:52 -0500 (CDT)
Date: Thu, 30 May 2013 12:07:48 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH 7/9] xfs: kill suid/sgid through the truncate path.
Message-ID: <20130530170748.GA20932@sgi.com>
References: <1369636707-15150-1-git-send-email-david@fromorbit.com>
	<1369636707-15150-8-git-send-email-david@fromorbit.com>
	<51A75F7A.6040302@redhat.com> <20130530155208.GD20028@sgi.com>
	<51A77820.2070804@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <51A77820.2070804@redhat.com>
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
To: Brian Foster <bfoster@redhat.com>
Cc: xfs@oss.sgi.com

On Thu, May 30, 2013 at 12:02:40PM -0400, Brian Foster wrote:
> On 05/30/2013 11:52 AM, Ben Myers wrote:
> > Hey Brian,
> > 
> > On Thu, May 30, 2013 at 10:17:30AM -0400, Brian Foster wrote:
> >> On 05/27/2013 02:38 AM, Dave Chinner wrote:
> >>> From: Dave Chinner <dchinner@redhat.com>
> >>>
> >>> XFS has failed to kill suid/sgid bits correctly when truncating
> >>> files of non-zero size since commit c4ed4243 ("xfs: split
> >>> xfs_setattr") introduced in the 3.1 kernel. Fix it.
> >>>
> >>
> >> The code makes sense and I can easily hit an assert when truncating
> >> (extending) a suid file on a debug kernel without this patch (and I see
> >> the suid dropped with the patch).
> > 
> > What commands did you use?  It seems like this is dealing with S_ISGID, correct?
> > 
> 
> Hi Ben,
> 
> Yeah, that confused me at first as well. I believe the vfs interprets
> the ATTR_KILL_SUID/SGIT bits prior to the setattr call and wipes out the
> associated mode bits if necessary.
> 
> What I did was basically create a zero sized file as root, chmod to a+s
> and a+rwx and then as a regular user, truncate that file to something
> larger than zero. Without the patch I hit the assert and with the patch
> the assert doesn't fire and the setuid bit is dropped.

Perfect, thanks.  I'm able to hit this on 3.10-rc3, but not 3.10-rc1.
Interesting.

-Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 98E257FB6
	for <xfs@oss.sgi.com>; Thu,  7 Mar 2013 06:13:42 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 27A83AC004
	for <xfs@oss.sgi.com>; Thu,  7 Mar 2013 04:13:39 -0800 (PST)
Received: from fftw.org (216.119.142.145.static.a2webhosting.com
	[216.119.142.145]) by cuda.sgi.com with ESMTP id
	v4ig3bM99sEpOMnP (version=TLSv1 cipher=AES128-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Thu, 07 Mar 2013 04:13:37 -0800 (PST)
From: Matteo Frigo <athena@fftw.org>
Subject: Re: [dm-devel] [BUG] pvmove corrupting XFS filesystems (was Re: [BUG]
	Internal error xfs_dir2_data_reada_verify)
References: <87d2vnc34r.fsf@fftw.org> <20130226044039.GM5551@dastard>
	<20130227010414.GD1514@agk.fab.redhat.com>
	<20130227014900.GY5551@dastard> <87y5eah4xz.fsf@fftw.org>
Date: Thu, 07 Mar 2013 07:13:27 -0500
In-Reply-To: <87y5eah4xz.fsf@fftw.org> (Matteo Frigo's message of "Tue, 26 Feb
	2013 21:21:44 -0500")
Message-ID: <87k3pjs908.fsf@fftw.org>
MIME-Version: 1.0
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
To: Dave Chinner <david@fromorbit.com>
Cc: dm-devel@redhat.com, xfs@oss.sgi.com

Matteo Frigo <athena@fftw.org> writes:

> Well, I don't really know anything about this topic, so I may be
> completely off the mark, but dm-raid1.c:mirror_map() does indeed return
> EWOULDBLOCK, and EWOULDBLOCK is #define'd to be EAGAIN, so it seems to
> me that dm-raid1 does indeed return EAGAIN for "rw == READA" (which I
> assume is read-ahead) if the "region is not in-sync":
>
> 	/*
> 	 * If region is not in-sync queue the bio.
> 	 */
> 	if (!r || (r == -EWOULDBLOCK)) {
> 		if (rw == READA)
> 			return -EWOULDBLOCK;
>
> 		queue_bio(ms, bio, rw);
> 		return DM_MAPIO_SUBMITTED;
> 	}

Dave (and others),

do you have any suggestion on what should be done to fix this bug?

I have tried returning -EIO instead of -EWOULDBLOCK, but xfs does not
like that.  dm-zero.c:zero_map() appears to return -EIO too, so this is
another potential issue.

I have verified that removing the READA special case, treating READA
like READ, fixes the problem:

 		if(0) if (rw == READA)
 			return -EWOULDBLOCK;

Of course this "fix" throws away the baby with the bath water.

I am willing to write and submit a patch, but I would appreciate
directions as to what the correct protocol between xfs and dm is
supposed to be.

Regards,
MF

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

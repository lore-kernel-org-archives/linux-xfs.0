Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pAU0Jx5m119186 for <xfs@oss.sgi.com>; Tue, 29 Nov 2011 18:20:00 -0600
Received: from ipmail05.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1944C19EFDBA
	for <xfs@oss.sgi.com>; Tue, 29 Nov 2011 16:19:30 -0800 (PST)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	xC8H0o4zhENgBeOL for <xfs@oss.sgi.com>;
	Tue, 29 Nov 2011 16:19:30 -0800 (PST)
Date: Wed, 30 Nov 2011 11:19:27 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] libxfs: Get Physical Sector Size instead of Logical
	Sector size
Message-ID: <20111130001927.GU7046@dastard>
References: <1322162451-17036-1-git-send-email-cmaiolino@redhat.com>
	<20111124195042.GA3671@andromeda.usersys.redhat.com>
	<20111127010643.GU2386@dastard> <4ED2C233.8010104@sandeen.net>
	<20111127235051.GX2386@dastard>
	<yq1vcq4grgi.fsf@sermon.lab.mkp.net> <4ED3B2BC.1060609@sandeen.net>
	<yq1r50qhmte.fsf@sermon.lab.mkp.net> <4ED51899.7000706@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4ED51899.7000706@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Carlos Maiolino <cmaiolino@redhat.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, xfs@oss.sgi.com

On Tue, Nov 29, 2011 at 11:38:33AM -0600, Eric Sandeen wrote:
> On 11/29/11 11:15 AM, Martin K. Petersen wrote:
> >>>>>> "Eric" == Eric Sandeen <sandeen@sandeen.net> writes:
> > 
> > Eric> It seems that we should be checking for any alignment offsets in
> > Eric> libxfs then, too; if there IS an offset, then perhaps 4k is the
> > Eric> wrong answer, (perhaps there is no right answer) but if there is
> > Eric> NO offset, 4k should be the right choice, yes?
> > 
> > In most cases the partitioning/DM tools should give you a 0 offset. But
> > it would a good idea to at least print a warning if lbs != pbs and
> > offset > 0.
> 
> Right, Dave's concern was for when the partitioning tools didn't do the
> job, we don't want to break fs consistency guarantees...
> 
> Dave, does checking for an offset before choosing 4k sectors seem
> sufficient to you?

Yes, especially if combined with Christoph's comments about ensure
the "-f" flag is needed to make a filesystem on an unaligned config.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

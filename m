Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 581767CA1
	for <xfs@oss.sgi.com>; Wed, 22 Jun 2016 17:23:37 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 19F0F8F8035
	for <xfs@oss.sgi.com>; Wed, 22 Jun 2016 15:23:37 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	qmSeFZkIHGcWdndC for <xfs@oss.sgi.com>;
	Wed, 22 Jun 2016 15:23:30 -0700 (PDT)
Date: Thu, 23 Jun 2016 08:23:28 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Bug (?) : cumulative xfsrestore does not restore files and
	folders in a directory which was renamed
Message-ID: <20160622222328.GW12670@dastard>
References: <a08ae222-7654-4a6f-d9ba-f70017784f74@recia.fr>
	<20160622220959.GV12670@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160622220959.GV12670@dastard>
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
To: Damien Gombault <damien.gombault@recia.fr>
Cc: xfs@oss.sgi.com

On Thu, Jun 23, 2016 at 08:09:59AM +1000, Dave Chinner wrote:
> But it seems that dirb hasn't been created before the file in it
> is being restored. THis can happen because the inventory is not
> correct, whichmay in fact be a problem with dump rather than
> restore...
> 
> I'll have a bit of a play around here, see if I can reproduce it.

Yes, i can reproduce it, so I'll have a deeper look.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

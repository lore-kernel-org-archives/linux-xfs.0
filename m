Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p5A0t1wZ212668 for <xfs@oss.sgi.com>; Thu, 9 Jun 2011 19:55:01 -0500
Received: from pyre.virge.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0E60DD9C81C
	for <xfs@oss.sgi.com>; Thu,  9 Jun 2011 17:54:59 -0700 (PDT)
Received: from pyre.virge.net (24-246-28-70.cable.teksavvy.com [24.246.28.70])
	by cuda.sgi.com with ESMTP id 1PdXsJpq7QWfTzhT for
	<xfs@oss.sgi.com>; Thu, 09 Jun 2011 17:54:59 -0700 (PDT)
Date: Thu, 9 Jun 2011 20:54:57 -0400
From: Norbert Veber <nveber@pyre.virge.net>
Subject: Re: Small files perform much faster on newly formatted fs?
Message-ID: <20110610005457.GN28625@pyre.virge.net>
References: <20110607163742.GH28625@pyre.virge.net> <201106080911.11286@zmi.at>
	<20110608122638.GQ28625@pyre.virge.net>
	<20110609012907.GR32466@dastard>
	<20110609134811.GI28625@pyre.virge.net>
	<20110609211731.GT32466@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110609211731.GT32466@dastard>
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
Cc: Michael Monnerie <michael.monnerie@is.it-management.at>, xfs@oss.sgi.com

On Fri, Jun 10, 2011 at 07:17:31AM +1000, Dave Chinner wrote:
> The mount options are only there to cahnge the alignment that
> already exists, and there are significant limitations on those
> changes.

Oh I see.  I will reformat and set sunit/swidth for my current 3 disk
raid5 (2 data disks).  What if I later add a 4th disk (3 data disks),
would using the mount option to specify the new swidth have any
performance hit?  

I assume old files might work slower but any new data that is written
would be aligned across all the drives?  Or should I just reformat again
at that point?

Thanks,

Norbert

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

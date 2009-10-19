Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n9J1Snid016920 for <xfs@oss.sgi.com>; Sun, 18 Oct 2009 20:28:50 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id CBF9115238
	for <xfs@oss.sgi.com>; Sun, 18 Oct 2009 18:30:21 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail13.adl6.internode.on.net
	[150.101.137.98]) by cuda.sgi.com with ESMTP id
	eWVjeckjdSdHcJ5H for <xfs@oss.sgi.com>;
	Sun, 18 Oct 2009 18:30:21 -0700 (PDT)
Date: Mon, 19 Oct 2009 12:30:18 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS mount failuer on RAID5
Message-ID: <20091019013018.GQ9464@discord.disaster>
References: <389deec70910152009i7656aaf2s9d929b8b68e4e740@mail.gmail.com>
	<200910161019.10286@zmi.at> <4AD890D1.4010208@sandeen.net>
	<200910172327.05122@zmi.at>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <200910172327.05122@zmi.at>
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
To: Michael Monnerie <michael.monnerie@is.it-management.at>
Cc: xfs@oss.sgi.com

On Sat, Oct 17, 2009 at 11:27:04PM +0200, Michael Monnerie wrote:
> On Freitag 16 Oktober 2009 Eric Sandeen wrote:
> > Actually -ssize=4k is just fine even on 512 sector disks.
> 
> Oh funny. So what's the meaning of this argument then? Or why would one 
> set it to 4k? What's the diff with 512b?

A hardware sector is the atomic unit of IO. 4k sectors on 512b
hardware sectors means that a single 4k filesystem sector write is
not necessarily atomic. This can lead to problems with torn writes
at power loss or sub-filesystem-sector data loss/corruption when a
hardware sector goes bad. In general, these are detected no
differently to the same sector loss on a 512b filesystem sector
filesystem.

IIRC, the main reason for 4k sectors on MD RAID5/6 is that changing
the IO alignment from 4k to 512 byte IOs (i.e. sub-page sized)
causes MD to flush and invalidate the stripe cache. Hence every
time XFS writes a super block, AGF, AGFL or AGI, things go much
slower because of this flush/invalidate. By setting the sector size
to 4k, the SB/AGF/AGFL/AGI are all 4k in size and hence IO alignment
never changes and hence performance remains good.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

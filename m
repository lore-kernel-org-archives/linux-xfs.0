Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 415407F3F
	for <xfs@oss.sgi.com>; Wed, 18 Jun 2014 18:07:42 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id E37D0AC003
	for <xfs@oss.sgi.com>; Wed, 18 Jun 2014 16:07:38 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	ZFoE9KX95NYn06OF for <xfs@oss.sgi.com>;
	Wed, 18 Jun 2014 16:07:36 -0700 (PDT)
Date: Thu, 19 Jun 2014 09:07:21 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: log record CRC mismatch: found 0x10a71f1d, expected 0xe012d25f
Message-ID: <20140618230721.GD4453@dastard>
References: <alpine.DEB.2.19.4.1406180224150.4757@trent.utfs.org>
	<20140618120124.GR9508@dastard>
	<e2537966-9b06-45eb-b2c7-dd5cffa968dd@email.android.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <e2537966-9b06-45eb-b2c7-dd5cffa968dd@email.android.com>
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
To: Christian Kujau <lists@nerdbynature.de>
Cc: xfs@oss.sgi.com

On Wed, Jun 18, 2014 at 10:13:23AM -0700, Christian Kujau wrote:
> 
> 
> On June 18, 2014 5:01:24 AM PDT, Dave Chinner
> <david@fromorbit.com> wrote:
> >Yes, that's the only way to safely move a filesystem between
> >machines of different endianness - a clean log has nothing to
> >replay, so no endian problems and all new records will be written
> >according to the endianness of the host the filesystem is
> >currently mounted on.
> 
> OK, thanks for explaining that.
> 
> When the PowerPC box crashed there should not have been any i/o on
> the file system - so, if there was nothing to commit, clearing the
> log with "xfs_repair -L" should not lose any data, right?

In theory. use xfs_logprint to check the log is empty...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

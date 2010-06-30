Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o5U1E5fp100694 for <xfs@oss.sgi.com>; Tue, 29 Jun 2010 20:14:05 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D2B33419722
	for <xfs@oss.sgi.com>; Tue, 29 Jun 2010 18:16:50 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail14.adl6.internode.on.net
	[150.101.137.99]) by cuda.sgi.com with ESMTP id
	THPkRHw1LSkjsZMO for <xfs@oss.sgi.com>;
	Tue, 29 Jun 2010 18:16:50 -0700 (PDT)
Date: Wed, 30 Jun 2010 11:16:47 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfs file system in process of becoming corrupt; though
	xfs_repair	thinks it's fine! ; -/ (was xfs_dump problem...)
Message-ID: <20100630011647.GD24712@dastard>
References: <4C26A51F.8020909@tlinx.org> <20100628022744.GX6590@dastard>
	<4C2A749E.4060006@tlinx.org> <20100629232532.GA24712@dastard>
	<4C2A87FF.7090804@dermichi.com> <4C2A92DA.1020202@tlinx.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4C2A92DA.1020202@tlinx.org>
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
To: "Linda A. Walsh" <xfs@tlinx.org>
Cc: Michael Weissenbacher <mw@dermichi.com>, xfs-oss <xfs@oss.sgi.com>

On Tue, Jun 29, 2010 at 05:42:02PM -0700, Linda A. Walsh wrote:
> Do I need >32 bit inodes if the filesystem size is > 2T?

No. inode64 is recommended for multi-terabyte filesystems, but is
not mandatory.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

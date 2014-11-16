Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 53CEE29DF7
	for <xfs@oss.sgi.com>; Sun, 16 Nov 2014 16:36:43 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 2AB458F8033
	for <xfs@oss.sgi.com>; Sun, 16 Nov 2014 14:36:39 -0800 (PST)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	3ICrdNOCnIx5Tdx6 for <xfs@oss.sgi.com>;
	Sun, 16 Nov 2014 14:36:33 -0800 (PST)
Date: Mon, 17 Nov 2014 09:36:30 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Virtual Block device resize corrupts XFS
Message-ID: <20141116223630.GH23575@dastard>
References: <5468FC60.10901@web.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <5468FC60.10901@web.de>
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
To: Markus Rhonheimer <markus.rhonheimer@web.de>
Cc: xfs@oss.sgi.com

On Sun, Nov 16, 2014 at 08:34:56PM +0100, Markus Rhonheimer wrote:
> Hi,
> 
> I am running Centos 7 and have created a virtual block device with
> ZFS (ZVOL). I put XFS onto the block device without partitioning it.
> 
> This worked very well as storage disk for a VM.
>
> A few days ago I wanted to increase the size of the block device,
> but accidently decreased it by 1 TB (from 7 to 6). I found out about
> it and immediately increased the size of the drive to 8 TB
> afterward.

If that was a normal LVM block device, there would have been no
trouble. But you're using something special, unusual and completely
untested, so the most likely outcome is going to be that you still
have a pile of broken bits.

> The XFS partition can still be mounted and I can list the files on
> it, but xfs_repair -n says: "/Sorry/, /could not find valid
> secondary superblock"

Full output, please, as well as the version of xfs_repair you are
using...

http://xfs.org/index.php/XFS_FAQ#Q:_What_information_should_I_include_when_reporting_a_problem.3F

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

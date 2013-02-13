Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 24ECE7FA9
	for <xfs@oss.sgi.com>; Wed, 13 Feb 2013 02:02:04 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 0F8D8304039
	for <xfs@oss.sgi.com>; Wed, 13 Feb 2013 00:02:01 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id Ydy2ESHRcOa0i9bE for
	<xfs@oss.sgi.com>; Wed, 13 Feb 2013 00:02:00 -0800 (PST)
Date: Wed, 13 Feb 2013 09:01:54 +0100
From: Karel Zak <kzak@redhat.com>
Subject: Re: [PATCH] xfs_mkfs: wipe old signatures from the device
Message-ID: <20130213080154.GC18597@x2.net.home>
References: <1360667215-14701-1-git-send-email-lczerner@redhat.com>
	<20130212202753.GC26694@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130212202753.GC26694@dastard>
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
Cc: Lukas Czerner <lczerner@redhat.com>, sandeen@redhat.com, xfs@oss.sgi.com

On Wed, Feb 13, 2013 at 07:27:53AM +1100, Dave Chinner wrote:
> Isn't 128k of zeroing enough to kill existing filesystem signatures?

Really no.

> If not how much is, and why can't we just change WHACK_SIZE to
> reflect the size that will kill those signatures that are further
> offset into the device?

btrfs: first superblock at 64KB, second at 64MB, third at 256GB.

zfs has at least 4 blocks at the begin and end of the device.

GPT has the backup table at the end of the device.

RAIDs have signatures also at the end of the device, etc.


    Karel

-- 
 Karel Zak  <kzak@redhat.com>
 http://karelzak.blogspot.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

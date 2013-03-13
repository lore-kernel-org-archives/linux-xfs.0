Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 9B83B7F37
	for <xfs@oss.sgi.com>; Wed, 13 Mar 2013 18:42:18 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 6D62C30405F
	for <xfs@oss.sgi.com>; Wed, 13 Mar 2013 16:42:18 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	JugUWjIxjEL0J3GZ for <xfs@oss.sgi.com>;
	Wed, 13 Mar 2013 16:42:16 -0700 (PDT)
Date: Thu, 14 Mar 2013 10:42:13 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS filesystem on EC2 instance corrupts and shuts down
Message-ID: <20130313234213.GW21651@dastard>
References: <CAOdS1h=7X4O1O7X8YOwxtLm7G=fc+J+6hJxJ1RKbDmfTZXTpeg@mail.gmail.com>
	<51373DB8.2020707@redhat.com>
	<CAOdS1hnXGj9puaHxeToqmpK40A-3WvJnM7=5HckpyyZYqZTvEQ@mail.gmail.com>
	<51373FC1.6010101@redhat.com>
	<CAOurMUeasru6ekDYcvVR1QnaWVJFV+-coZsUG5SgG6LnENBvXg@mail.gmail.com>
	<513751F2.2060109@redhat.com>
	<CAOdS1hngSuHn_HiremLyUS7Qd9eZ68=8arfBuHnEpwXQaBw9Wg@mail.gmail.com>
	<5140CBE3.80705@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <5140CBE3.80705@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Shrinath M <shrinath.m@webyog.com>, Sabyasachi Ruj <sabyasachi.ruj@webyog.com>, Vivek Goel <vivek.goel@webyog.com>, xfs@oss.sgi.com, Supratik Goswami <supratik.goswami@webyog.com>, Ric Wheeler <rwheeler@redhat.com>

On Wed, Mar 13, 2013 at 01:56:35PM -0500, Eric Sandeen wrote:
> XFS (md0): xfs_iunlink_remove: xfs_itobp() returned error 117.

Corrupted unlinked inode list. You need to run xfs_repair to fix
this.

Chers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

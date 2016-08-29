Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id AEB657CA0
	for <xfs@oss.sgi.com>; Mon, 29 Aug 2016 18:26:19 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 3E916AC004
	for <xfs@oss.sgi.com>; Mon, 29 Aug 2016 16:26:19 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id UI0Hmv4ikOPZk7on (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 29 Aug 2016 16:26:18 -0700 (PDT)
Date: Mon, 29 Aug 2016 18:26:15 -0500
From: "Bill O'Donnell" <billodo@redhat.com>
Subject: Re: [PATCH] xfsprogs: don't populate fs table with foreign fs paths
	unless foreign_allowed
Message-ID: <20160829232615.GA29648@redhat.com>
References: <1472478012-23627-1-git-send-email-billodo@redhat.com>
	<20160829231205.GO19025@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160829231205.GO19025@dastard>
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
Cc: xfs@oss.sgi.com

On Tue, Aug 30, 2016 at 09:12:06AM +1000, Dave Chinner wrote:
> On Mon, Aug 29, 2016 at 08:40:12AM -0500, Bill O'Donnell wrote:
> > Commits b20b6c2 and 29647c8 modified xfs_quota for use on
> > non-XFS filesystems. One modification in fs_initialise_mounts
> > (paths.c) resulted in an xfstest fail (xfs/261), due to foreign
> > fs paths entering the fs table.
> 
> What's the failure? I'm not seeing it here on any of my test
> machines...

On my box, there are a few ext4 mounts, and test xfs/261 
populates the fs table with those paths. So when xfs_quota commands
in 261 are executed, a "foreign filesystem" message is thrown.
My first notion was to add a -f to the xfs_quota command in 261,
but then I decided it was better to change the xfsprogs code back
to the old behavior.

> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

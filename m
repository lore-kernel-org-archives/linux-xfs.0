Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p2M5B8bN261076
	for <linux-xfs@oss.sgi.com>; Tue, 22 Mar 2011 00:11:13 -0500
Received: from ipmail04.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8D33714A6BCE
	for <linux-xfs@oss.sgi.com>; Mon, 21 Mar 2011 22:13:56 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	O5LENJN8b6cQfAoi for <linux-xfs@oss.sgi.com>;
	Mon, 21 Mar 2011 22:13:56 -0700 (PDT)
Date: Tue, 22 Mar 2011 16:13:53 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: umount fails with device is busy
Message-ID: <20110322051353.GA15270@dastard>
References: <31199414.post@talk.nabble.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <31199414.post@talk.nabble.com>
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
To: stress_buster <leo1783@yahoo.com>
Cc: linux-xfs@oss.sgi.com

On Mon, Mar 21, 2011 at 03:53:04AM -0700, stress_buster wrote:
> 
> I'm trying to run xfs_repair on my filesystem:

Why do you need to do this?

> Firstly to unmount the fs
> 
> Quote:
> umount /myfs
> umount: /myfs: device is busy
> umount: /myfs: device is busy  
> 
> Quote:
> lsof /dev/sda  
> 
> -show none ie nothing seems to be 'touching' the disk.
> confused why its still showing device is busy

Did you have an oops or a filesystem shutdown? i.e. anything in
syslog of note?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id CB1B27F37
	for <xfs@oss.sgi.com>; Tue, 25 Aug 2015 06:54:34 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 6580FAC004
	for <xfs@oss.sgi.com>; Tue, 25 Aug 2015 04:54:31 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	sHqBCSgu6YDskiJ3 for <xfs@oss.sgi.com>;
	Tue, 25 Aug 2015 04:54:25 -0700 (PDT)
Date: Tue, 25 Aug 2015 21:54:12 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Cant mount xfs lvm. Experimental Features?
Message-ID: <20150825115412.GI714@dastard>
References: <8a6d5afa8829aec73d911f35815d7b92@zbfmail.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <8a6d5afa8829aec73d911f35815d7b92@zbfmail.de>
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
To: weber@zbfmail.de
Cc: Xfs <xfs@oss.sgi.com>

On Tue, Aug 25, 2015 at 10:25:16AM +0200, Marko Weber|8000 wrote:
> 
> Hello List, Hello Dave...
> 
> 
> i try to mount on my backup server an Lvm Partition and get errors
> in stdout and log:
> 
> /var/log/messages:
> 
> Aug 25 10:20:31 backupserver kernel: XFS (dm-2): Version 5
> superblock detected. This kernel has EXPERIMENTAL support enabled!
> Aug 25 10:20:31 backupserver kernel: Use of these features in this
> kernel is at your own risk!
> Aug 25 10:20:31 backupserver kernel: XFS (dm-2): Superblock has
> unknown read-only compatible features (0x1) enabled.
> Aug 25 10:20:31 backupserver kernel: XFS (dm-2): Attempted to mount
> read-only compatible filesystem read-write.
> Aug 25 10:20:31 backupserver kernel: Filesystem can only be safely
> mounted read only.
> Aug 25 10:20:31 backupserver kernel: XFS (dm-2): SB validate failed
> with error 22.

You need to run the same version kernel on both servers. The primary
has a more recent kernel and feature set than your older backup
server is running.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

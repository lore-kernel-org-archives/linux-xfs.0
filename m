Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oB22EapY246391 for <xfs@oss.sgi.com>; Wed, 1 Dec 2010 20:14:36 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id ABCC7160ADB3
	for <xfs@oss.sgi.com>; Wed,  1 Dec 2010 18:16:18 -0800 (PST)
Received: from mail.internode.on.net (bld-mail20.adl6.internode.on.net
	[150.101.137.105]) by cuda.sgi.com with ESMTP id
	DssgHF5xm04GlEHr for <xfs@oss.sgi.com>;
	Wed, 01 Dec 2010 18:16:18 -0800 (PST)
Date: Thu, 2 Dec 2010 13:16:09 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS file system corruption(Return Bad Transaction) kernel - 2.6.34
Message-ID: <20101202021609.GV16922@dastard>
References: <AANLkTikzCpQ1j9uWGSTY9TEguVDvAB5AVYtbDtdePFci@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <AANLkTikzCpQ1j9uWGSTY9TEguVDvAB5AVYtbDtdePFci@mail.gmail.com>
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
To: Amit Sahrawat <amit.sahrawat83@gmail.com>
Cc: sandeen-xfs@sandeen.net, Eric Sandeen <sandeen@sandeen.net>, xfs@oss.sgi.com

On Wed, Dec 01, 2010 at 12:44:58PM +0530, Amit Sahrawat wrote:
> Dear Member,
> 
> I am getting following corruption on XFS formatted disk during a simple copy
> operation:
> sd 9:0:0:0: Attached scsi removable disk sdc
> sd 9:0:0:0: Attached scsi generic sg2 type 0
> XFS mounting filesystem sdc2
> Starting XFS recovery on filesystem: sdc2 (logdev: internal)
> XFS: xlog_recover_process_data: bad transaction
> XFS: log mount/recovery failed: error 5
> XFS: log mount failed
> [root@localhost TEGRA]#

"TEGRA" - You're running on an ARM device? If so, what kernel are
you running? i.e. does it have the VIVT cache aliasing fixes in it?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oB24Bn5c251500 for <xfs@oss.sgi.com>; Wed, 1 Dec 2010 22:11:50 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3867C160B415
	for <xfs@oss.sgi.com>; Wed,  1 Dec 2010 20:13:31 -0800 (PST)
Received: from mail.internode.on.net (bld-mail18.adl2.internode.on.net
	[150.101.137.103]) by cuda.sgi.com with ESMTP id
	wCGnQxD6bHUsRVZq for <xfs@oss.sgi.com>;
	Wed, 01 Dec 2010 20:13:31 -0800 (PST)
Date: Thu, 2 Dec 2010 15:13:12 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS file system corruption(Return Bad Transaction) kernel - 2.6.34
Message-ID: <20101202041312.GX16922@dastard>
References: <AANLkTikzCpQ1j9uWGSTY9TEguVDvAB5AVYtbDtdePFci@mail.gmail.com>
	<4CF661C7.2020103@sandeen.net>
	<AANLkTimiST8VNVsV49mniKLBudSxFj+O883Mwwe7ucac@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <AANLkTimiST8VNVsV49mniKLBudSxFj+O883Mwwe7ucac@mail.gmail.com>
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

On Thu, Dec 02, 2010 at 09:10:08AM +0530, Amit Sahrawat wrote:
> While the copy operation is in progress, simply unplug the usb device and
> then replug.

That's pretty much a guaranteed recipe for data and filesystem
corruption regardless of the filesystem you are using. Even if you
are lucky enough that there was is no IO being issued while the
device is unplugged, what guarantee is there that the device even
comes back with the same device name? Further, if the device is usb
powered, there is no guarantee that the drive caches were
flushed correctly before the unplug so random log and metadata
corruptions are definitely possible.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

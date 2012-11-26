Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qAQ1bR3Y132944 for <xfs@oss.sgi.com>; Sun, 25 Nov 2012 19:37:27 -0600
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	CI2ZnUmYygEl9ZwS for <xfs@oss.sgi.com>;
	Sun, 25 Nov 2012 17:39:40 -0800 (PST)
Date: Mon, 26 Nov 2012 12:39:31 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: How to run xfstests against btrfs on multipath disks on SuSE?
Message-ID: <20121126013931.GN32450@dastard>
References: <CAPxxNQ=SRZ33U8nLjK8a3+MPfy3Qz98ALcALXWK_x=dmW9+BoA@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAPxxNQ=SRZ33U8nLjK8a3+MPfy3Qz98ALcALXWK_x=dmW9+BoA@mail.gmail.com>
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
To: Ryan Wang <openspace.wang@gmail.com>
Cc: linux-xfs@vger.kernel.org, linux-btrfs@vger.kernel.org, xfs@oss.sgi.com

On Mon, Nov 26, 2012 at 09:26:31AM +0800, Ryan Wang wrote:
> Hello,
> 
> I tried to kick off xfstests against btrfs on multipath device,
> e.g I set TEST_DEV="/dev/mapper/mpatha", which is a
> symlink to "/dev/dm-0". I mkfs.btrfs mpatha beforehand.
> 
> When I run "./check 001", it said:
> "
> common.rc: Error: $TEST_DEV (/dev/dm-0) is not a MOUNTED btrfs filesystem
> "
> 
> The I checked the script common.rc, and found that it uses
> df to determine the filesystem type and it uses the realpath
> "/dev/dm-0" instead of "/dev/mapper/mpatha", while df always
> shows "devtmpfs" instead of "btrfs" for /dev/dm-0.
> 
> I run "mount" and found that devtmpfs is mount on /dev/ ***by default***
> in SuSE.
> Even though  I run "mount -t btrfs /dev/dm-0 /somedir", df still showed
> devtmpfs.
> 
> Any ideas to kick off the xfstests?

seeing as you've now sent this to 3 lists that the xfstests
maintainers are likely not to read, I've added the proper list to
the cc list. i.e. xfs@oss.sgi.com.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

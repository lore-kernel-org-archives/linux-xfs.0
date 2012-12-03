Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qB3LWb5r026458 for <xfs@oss.sgi.com>; Mon, 3 Dec 2012 15:32:37 -0600
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	baLoVXMzE7WFDgKr for <xfs@oss.sgi.com>;
	Mon, 03 Dec 2012 13:34:59 -0800 (PST)
Date: Tue, 4 Dec 2012 08:34:57 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfsdump INTERRUPT issue
Message-ID: <20121203213457.GA32450@dastard>
References: <50BAB19F.1010808@hardwarefreak.com>
	<CCE2425A.B0475%jellis@dhnet.us>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CCE2425A.B0475%jellis@dhnet.us>
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
To: "J. Ellis" <jellis@dhnet.us>
Cc: stan@hardwarefreak.com, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Mon, Dec 03, 2012 at 11:49:46AM -0500, J. Ellis wrote:
> Thank you to Stan and Dave for helping me through this.
> 
> Ok, here's the file, printed below.
> 
> Basically, I'm running the following commands under Ubuntu 12.10:
> 
> Type mkdir /mnt/fp
> Type mkdir /mnt/hr20
> Type mount -t xfs -o rtdev=/dev/sda3 /dev/sda2 /mnt/fp
> Type mount -t xfs -o rtdev=/dev/sdb3 /dev/sdb2 /mnt/hr20
> Type xfsdump -J - /mnt/hr20 | xfsrestore -J - /mnt/fp
> 
> When run, I get this as my output:
> 
> xfsdump: WARNING: write to stdio failed: 32 (Broken pipe)

FWIW, this implies that xfsrestore failed. What is the output from
xfsrestore? Can you just run xfsdump to a file?

Also, the dmesg output is missing - can you attach it?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

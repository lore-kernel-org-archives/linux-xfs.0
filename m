Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mB5E0Rha019904 for <xfs@oss.sgi.com>; Fri, 5 Dec 2008 08:00:29 -0600
Received: from lucidpixels.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2B23B16B6477
	for <xfs@oss.sgi.com>; Fri,  5 Dec 2008 06:00:25 -0800 (PST)
Received: from lucidpixels.com (lucidpixels.com [75.144.35.66]) by
	cuda.sgi.com with ESMTP id sHPjhFqyOGjIXVfj for
	<xfs@oss.sgi.com>; Fri, 05 Dec 2008 06:00:25 -0800 (PST)
Date: Fri, 5 Dec 2008 08:59:54 -0500 (EST)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: Velociraptor drive related to the use of NCQ.
In-Reply-To: <alpine.DEB.1.10.0812050602400.3188@p34.internal.lan>
Message-ID: <alpine.DEB.1.10.0812050855140.4713@p34.internal.lan>
References: <alpine.DEB.1.10.0812050602400.3188@p34.internal.lan>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
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
To: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, xfs@oss.sgi.com, smartmontools-support@lists.sourceforge.net
Cc: Alan Piszcz <ap@solarrain.com>



On Fri, 5 Dec 2008, Justin Piszcz wrote:

> I swapped out my power supply, changed ALL cables and bought a $1000 raid
> controller with BBU, the drives are still having problems, when writing to
> them in a RAID10 configuration, it locks up the card:
>
> SMART shows the same thing on many of the disks in the RAID10:
>
> Error 1 occurred at disk power-on lifetime: 3708 hours (154 days + 12 hours)
>  When the command that caused the error occurred, the device was active or 
> idle.

I spoke to soon, turning off NCQ helped dramatically, it worked three times!

writing to raid10
dd: writing `file2': No space left on device
1430328+0 records in
1430327+0 records out
1499806973952 bytes (1.5 TB) copied, 3914.51 s, 383 MB/s
Fri Dec  5 06:00:25 EST 2008
writing to raid10
dd: writing `file2': No space left on device
1430328+0 records in
1430327+0 records out
1499806973952 bytes (1.5 TB) copied, 4063.25 s, 369 MB/s
Fri Dec  5 07:08:11 EST 2008
writing to raid10
dd: writing `file2': No space left on device
1430328+0 records in
1430327+0 records out
1499806973952 bytes (1.5 TB) copied, 3926.71 s, 382 MB/s
Fri Dec  5 08:13:41 EST 2008

Then it crashed again, with NCQ enabled, it would not even complete one test,
So basically a new system, new PSU, new cables, its on a new APC UPS and the 
problem persists even when all disks are on a RAID card, SW raid, it does not 
matter, Velociraptors have problems, I think its time for me to get regular
1TiB disks and be done with it.

Justin.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

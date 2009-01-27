Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n0R1kjJ7007081 for <xfs@oss.sgi.com>; Mon, 26 Jan 2009 19:46:45 -0600
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2AED7BBBD9
	for <xfs@oss.sgi.com>; Mon, 26 Jan 2009 17:46:02 -0800 (PST)
Received: from mail.sandeen.net (sandeen.net [209.173.210.139]) by
	cuda.sgi.com with ESMTP id jSdtVvuXU1RDJGxM for
	<xfs@oss.sgi.com>; Mon, 26 Jan 2009 17:46:02 -0800 (PST)
Message-ID: <497E6759.3060300@sandeen.net>
Date: Mon, 26 Jan 2009 19:46:01 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: Disable journaling
References: <b211fe280901261723h6dd1db69t9d24c8d6774b18bc@mail.gmail.com>
In-Reply-To: <b211fe280901261723h6dd1db69t9d24c8d6774b18bc@mail.gmail.com>
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
To: Iuri Diniz <iuridiniz@gmail.com>
Cc: xfs@oss.sgi.com

Iuri Diniz wrote:
> BACKGOUND:
> I'm looking for a filesystem for linux with these features:
> 
> * Fast Sequential Read (FSR)
> * Optional: copy on write support (COW)
> 
> I think that Ext4 and XFS are the best options. (ZFS too, but current ZFS
> implementation is not GPL, maybe brtfs when ready).
> 
> why do I want this? because I have a SSD.FSQ will reduce the boot time and
> COW will reduce writes on the same sector while allowing snapshots
> 
> I've found that XFS has a FSQ support (good job)[1], so I it will be very
> fast on SSD (random read == sequential read).
> 
> FAIK xfs doesn't support COW, it's ok because ext4 doesn't too.
> 
> MY PROBLEM:
> 
> I know that my SSD drive supports wearing level on hardware, but anyway I
> want to reduce unnecessary writes on my device, so I want to disable
> journaling on my filesytem.
> 
> Maybe, the ext4 (like ext3 does) will support it by doing this:
> 
> tune2fs -O ^has_journal /dev/sda1
> 
> Is possible to disable journaling on XFS too?

No, it's not right possible today.  There used to be a sort of config
option that disabled journaling ages ago, but it's gone now.  Not sure
it ever worked on Linux.

Ext4 does have an option to disable journaling now, which is
interesting.  If I ever have any time I'd like to see how hard it might
be to allow a mount option to xfs to also make journaling a no-op.

> Thanks in advance
> 
> [1] http://www.phoronix.com/scan.php?page=article&item=ext4_benchmarks&num=4

Fatally flawed article FWIW, their bonnie++ results are comically bad
(you try deleting 8G files on ext3, see if you can do 200 per second)  I
alerted them to the bonnie++ problems, and explained what they had done
wrong in the results parsing, and although they link to my email, they
leave the ridiculous graphs in place.  The iozone results may be better,
but I'd be very inclined to do my own testing rather than use those
results right now.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

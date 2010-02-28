Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o1SMa8WX120336 for <xfs@oss.sgi.com>; Sun, 28 Feb 2010 16:36:08 -0600
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 791912013BC
	for <xfs@oss.sgi.com>; Sun, 28 Feb 2010 14:37:32 -0800 (PST)
Received: from mail.sandeen.net (64-131-60-146.usfamily.net [64.131.60.146])
	by cuda.sgi.com with ESMTP id sRCJzrlL5w0BCPbh for
	<xfs@oss.sgi.com>; Sun, 28 Feb 2010 14:37:32 -0800 (PST)
Message-ID: <4B8AF02C.3070904@sandeen.net>
Date: Sun, 28 Feb 2010 16:37:32 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: Small change for mkfs.xfs?
References: <alpine.DEB.2.00.1002270628120.17433@p34.internal.lan>
In-Reply-To: <alpine.DEB.2.00.1002270628120.17433@p34.internal.lan>
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
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: xfs@oss.sgi.com

Justin Piszcz wrote:
> Hi,
> 
> # mkfs.xfs /dev/md0
> mkfs.xfs: /dev/md0 appears to contain an existing filesystem (ext3).
> mkfs.xfs: Use the -f option to force overwrite.
> 
> This occurs if the filesystem is ext4.  Need to differentiate between
> the two FS if possible?

Why, you're just overwriting it anyway ;)

FWIW, recent xfsprogs built against recent libblkid will detect ext4 correctly.

libdisk could be patched if anyone really cared enough but that's deprecated
going forward...

-Eric
 
> Justin.
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

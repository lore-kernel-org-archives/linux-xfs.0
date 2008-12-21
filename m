Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mBLL34B8017629 for <xfs@oss.sgi.com>; Sun, 21 Dec 2008 15:03:04 -0600
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6938D176BF7F
	for <xfs@oss.sgi.com>; Sun, 21 Dec 2008 13:03:02 -0800 (PST)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com
	with ESMTP id 1EiRZU03zAKck6pR for <xfs@oss.sgi.com>;
	Sun, 21 Dec 2008 13:03:02 -0800 (PST)
Message-ID: <494EAF05.5020901@sandeen.net>
Date: Sun, 21 Dec 2008 15:03:01 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: Big filesystem > (4TiB) recommendations (mkfs parameter tuning?)
References: <alpine.DEB.1.10.0812211551170.24116@p34.internal.lan>
In-Reply-To: <alpine.DEB.1.10.0812211551170.24116@p34.internal.lan>
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
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: xfs@oss.sgi.com

Justin Piszcz wrote:
> Often, on this list, there are issues where there is not enough memory, 
> etc, to repair a large filesystem.
> 
> If one is going to create a 10-16TiB filesystem (for example), should one 
> use the mkfs.xfs defaults, or should there be special tuning for 
> filesystems of this size, so they will be less susceptible to failure for 
> one reason or another?
> 
> Justin.

Memory to repair will depend more on total inodes on the system etc, not
so much the absolute size of the filesystem.

The defaults are defaults for a reason; they are updated when warranted,
and unless you have a specific issue with them, it's best to just stick
with that.

IOW, if best practices warranted different tuning for a generic 10-16TiB
filesystem, then the defaults would need to be updated, rather than
offering hints 'n' tips on mailing lists.  :)

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

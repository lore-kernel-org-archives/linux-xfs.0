Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mBQIagTE009562 for <xfs@oss.sgi.com>; Fri, 26 Dec 2008 12:36:42 -0600
Received: from mx2.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 95008178C84D
	for <xfs@oss.sgi.com>; Fri, 26 Dec 2008 10:36:40 -0800 (PST)
Received: from mx2.redhat.com (mx2.redhat.com [66.187.237.31]) by cuda.sgi.com
	with ESMTP id JVGPFvptEU7ZGAC3 for <xfs@oss.sgi.com>;
	Fri, 26 Dec 2008 10:36:40 -0800 (PST)
Message-ID: <49551073.5090704@redhat.com>
Date: Fri, 26 Dec 2008 11:12:19 -0600
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: Re: xfs_db 2.9.8: coredump
References: <alpine.DEB.1.10.0812260931490.11656@p34.internal.lan>
In-Reply-To: <alpine.DEB.1.10.0812260931490.11656@p34.internal.lan>
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
Cc: Alan Piszcz <ap@solarrain.com>, esandeen@redhat.com, xfs@oss.sgi.com

Justin Piszcz wrote:
> # xfs_db -V
> xfs_db version 2.9.8
> 
> p34:~# xfs_db -c frag -f /dev/sda1
> Segmentation fault (core dumped)
> p34:~# xfs_db -c frag -r /dev/sda1
> Segmentation fault (core dumped)
> 
> (It was working BEFORE I ran xfs_fsr on it, it was at 16% fragmentation).
> 
> Now it can no longer check it?
> 

Or, get an xfs_metadump of the fs and see if db segfaults on that too.

I'd be curious  to know if xfs_repair -n flaggs any problems, as well.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

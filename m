Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mBQJJCJe011633 for <xfs@oss.sgi.com>; Fri, 26 Dec 2008 13:19:13 -0600
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 12EAF1BF68EF
	for <xfs@oss.sgi.com>; Fri, 26 Dec 2008 11:19:11 -0800 (PST)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com
	with ESMTP id QSY7RsLUxB6aG5FG for <xfs@oss.sgi.com>;
	Fri, 26 Dec 2008 11:19:11 -0800 (PST)
Message-ID: <49552E0D.1030809@sandeen.net>
Date: Fri, 26 Dec 2008 13:18:37 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: xfs_db 2.9.8: coredump
References: <alpine.DEB.1.10.0812260931490.11656@p34.internal.lan>	<49551073.5090704@redhat.com>
	<alpine.DEB.1.10.0812261243550.18703@p34.internal.lan>
In-Reply-To: <alpine.DEB.1.10.0812261243550.18703@p34.internal.lan>
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
Cc: Eric Sandeen <sandeen@redhat.com>, Alan Piszcz <ap@solarrain.com>, esandeen@redhat.com, xfs@oss.sgi.com

Justin Piszcz wrote:
> 
> On Fri, 26 Dec 2008, Eric Sandeen wrote:


>> Or, get an xfs_metadump of the fs and see if db segfaults on that too.
>>
>> I'd be curious  to know if xfs_repair -n flaggs any problems, as well.
>>
>> -Eric
>>
> 
> # xfs_metadump -g /dev/sda1  /root/sda1.metadump
> Copied 300096 of 426176 inodes (0 of 12 AGs)
> Copying log
> #
> 
> p34:~# xfs_db -c frag -f sda1.metadump
> xfs_db: unexpected XFS SB magic number 0x5846534d
> xfs_db: read failed: Invalid argument
> xfs_db: data size check failed
> cache_node_purge: refcount was 1, not zero (node=0x1ce4b80)
> xfs_db: cannot read root inode (22)
> cache_node_purge: refcount was 1, not zero (node=0x1ce4cd0)
> xfs_db: cannot read realtime bitmap inode (22)
> Segmentation fault (core dumped)

well, you have to xfs_mdrestore that to a sparse file before pointing db
at it for it to be valid (still, should not dump).

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

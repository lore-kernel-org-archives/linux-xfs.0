Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 6DB697F3F
	for <xfs@oss.sgi.com>; Wed, 30 Oct 2013 04:59:17 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id EA920AC0A5
	for <xfs@oss.sgi.com>; Wed, 30 Oct 2013 02:59:13 -0700 (PDT)
Received: from awesome.dsw2k3.info (awesome.dsw2k3.info [217.188.63.246]) by
	cuda.sgi.com with ESMTP id G6ar3IVDRgkkSNIV (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 30 Oct 2013 02:59:12 -0700 (PDT)
Date: Wed, 30 Oct 2013 10:59:03 +0100
From: Matthias Schniedermeyer <ms@citd.de>
Subject: Re: agsize and performance
Message-ID: <20131030095903.GA8077@citd.de>
References: <CALtWs4-q==CXVZ=jjRnrZGANP98y2Gyot_DV_hGTgxQoRF25UA@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CALtWs4-q==CXVZ=jjRnrZGANP98y2Gyot_DV_hGTgxQoRF25UA@mail.gmail.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: K T <mailkarthikt@gmail.com>
Cc: xfs@oss.sgi.com

On 29.10.2013 18:10, K T wrote:
> Hi,
> 
> I have a 1 TB SATA disk(WD1003FBYX) with XFS. In my tests, I preallocate a
> bunch of 10GB files and write data to the files one at a time. I have
> observed that the default mkfs setting(4 AGs) gives very low throughput.
> When I reformat the disk with a agsize of 256mb(agcount=3726), I see better
> throughput. I thought with a bigger agsize, the files will be made of fewer
> extents and hence perform better(due to lesser entries in the extent map
> getting updated). But, according to my tests, the opposite seems to be
> true. Can you please explain why this the case? Am I missing something?
> 
> My test parameters:
> 
> mkfs.xfs -f /dev/sdbf1
> mount  -o inode64 /dev/sdbf1 /mnt/test
> fallocate -l 10G fname
> dd if=/dev/zero of=fname bs=2M count=64 oflag=direct,sync conv=notrunc seek=0

I get the same bad performance with your dd statement.

fallocate -l 10G fname
time dd if=/dev/zero of=fname bs=2M count=64 oflag=direct,sync conv=notrunc seek=0
64+0 records in
64+0 records out
134217728 bytes (134 MB) copied, 4,24088 s, 31,6 MB/s

After pondering the really hard to read dd-man-page.
Sync is for 'synchronized' I/O. aka REALLY BAD PERFORMANCE. And i assume 
you don't really that.

I think what you meant is fsync. (a.k.a. File (and Metadata) has hit 
stable-storage before dd exits).
That is: conv=fsync

So:
time dd if=/dev/zero of=fname bs=2M count=64 oflag=direct conv=notrunc,fsync seek=0
64+0 records in
64+0 records out
134217728 bytes (134 MB) copied, 1,44088 s, 93,2 MB/s

That gets much better performance, and in my case it can't get any 
better because the HDD (and encryption) just can't go any faster.




-- 

Matthias

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

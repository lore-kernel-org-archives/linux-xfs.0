Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 1ACED7F7C
	for <xfs@oss.sgi.com>; Thu, 23 Jul 2015 10:39:32 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id C6643304039
	for <xfs@oss.sgi.com>; Thu, 23 Jul 2015 08:39:28 -0700 (PDT)
Received: from mail-wi0-f173.google.com (mail-wi0-f173.google.com
	[209.85.212.173]) by cuda.sgi.com with ESMTP id
	nHm8XQmPCCadgKXb (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Thu, 23 Jul 2015 08:39:26 -0700 (PDT)
Received: by wibud3 with SMTP id ud3so30136114wib.1
	for <xfs@oss.sgi.com>; Thu, 23 Jul 2015 08:39:24 -0700 (PDT)
Message-ID: <7792DA2A464640B1BC7220973CED41AE@alyakaslap>
From: "Alex Lyakas" <alex@zadarastorage.com>
References: <20150629222651.GG7943@dastard>
	<F1A27B6A9FB048488A388EC4D9FD71F7@alyakaslap>
	<20150707000911.GT7943@dastard>
	<20150707090511.GA21863@infradead.org>
In-Reply-To: <20150707090511.GA21863@infradead.org>
Subject: Re: xfs_iext_realloc_indirect and "XFS: possible memory allocation
	deadlock"
Date: Thu, 23 Jul 2015 17:39:28 +0200
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>, Dave Chinner <david@fromorbit.com>
Cc: Danny Shavit <danny@zadarastorage.com>, bfoster@redhat.com, Yair Hershko <yair@zadarastorage.com>, Shyam Kaushik <shyam@zadarastorage.com>, xfs@oss.sgi.com

Hi Dave,
Just for completeness,  XFS speculative preallocation (that is based now 
upon the size of the last extent) can still grow up to 4Gb-8Gb (depending on 
which patches we are pulling). As a result, xfs_iozero can still sometimes 
trigger 1-2GB writes of zeros in one shot. This turns out to be a bit 
unfriendly to the drives in some configurations. So we have applied a custom 
patch to limit the speculative preallocation to 32Mb.

Final code will be in the same place.

Thanks,
Alex.

-----Original Message----- 
From: Christoph Hellwig
Sent: 07 July, 2015 11:05 AM
To: Dave Chinner
Cc: Alex Lyakas ; Danny Shavit ; bfoster@redhat.com ; Yair Hershko ; Shyam 
Kaushik ; xfs@oss.sgi.com
Subject: Re: xfs_iext_realloc_indirect and "XFS: possible memory allocation 
deadlock"

On Tue, Jul 07, 2015 at 10:09:11AM +1000, Dave Chinner wrote:
> server crash. i.e. the client side commit is an "fsync" to the
> server, and until the server responds with a success to the client
> commit RPC the client side will continue to retry sending the data
> to the server.
>
> For the persepctive of metadata (i.e. directory entries) the use of
> the "dirsync" mount option is sufficient for HA failover servers to
> work correctly as it ensures that directory structure changes are always
> committed to disk before the RPC response is sent back to the
> client.
>
> i.e. the "sync" mount option doesn't actually improve data integrity
> of an NFS server when you look at the end-to-end NFS protocol
> handling of async write data....


You don't need dirsync either.  NFS does the right sync usin the
commit_metadata export operation without using that big hammer.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

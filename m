Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 0F9BE7F56
	for <xfs@oss.sgi.com>; Fri, 13 Jun 2014 06:08:23 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id E627C8F8050
	for <xfs@oss.sgi.com>; Fri, 13 Jun 2014 04:08:22 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id wyWJC7utmqzFK0BC for
	<xfs@oss.sgi.com>; Fri, 13 Jun 2014 04:08:19 -0700 (PDT)
Date: Fri, 13 Jun 2014 07:08:16 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: how to locate the file through blktrace with xfs
Message-ID: <20140613110816.GA55850@bfoster.bfoster>
References: <CAF7cUg2QOZ+_nPmdb_jiy0Bip=ggSKE5Bs_pUCT9CmOcGjnYQQ@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAF7cUg2QOZ+_nPmdb_jiy0Bip=ggSKE5Bs_pUCT9CmOcGjnYQQ@mail.gmail.com>
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
To: xinxin shu <xinxin.shu5040@gmail.com>
Cc: xfs@oss.sgi.com

On Fri, Jun 13, 2014 at 04:21:09PM +0800, xinxin shu wrote:
> Hi all,
> 
> 
> 
> Recently , I collect blktrace data for xfs ,  I want to find the
> corresponding file/directory through the offset ,  is there any way to do
> this ? any tips will appreciate. thx

There isn't any easy way that I'm aware of to take a raw block number
and map it back to the owner. The global space trees account for free
space only and all allocated space is tracked in the block maps of
individual inodes.

You can obtain the extent mappings for a file via xfs_bmap, but that
alone isn't useful if you don't know what file you're looking for. You
could run a find/xfs_bmap through the entire fs and sift through the
output. If that's a lot of data and this is something you need to do
repeatedly, a supporting script might be a good idea. For example, you
could probably create a program that creates a sorted index of every
allocated extent mapped to inode number. Alternatively, a script that
takes a block number parameter and searches through the extents for a
range that includes it might be more simple.

You'll also want to be cognizant of various metadata blocks (i.e., inode
xattr blocks, btree blocks, internal md for ag's, log blocks if
internal, etc.).

Brian

> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

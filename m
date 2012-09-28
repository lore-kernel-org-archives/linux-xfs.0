Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q8SKf2ke049142 for <xfs@oss.sgi.com>; Fri, 28 Sep 2012 15:41:02 -0500
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id fAjnEh3QoByL3TzB for
	<xfs@oss.sgi.com>; Fri, 28 Sep 2012 13:42:22 -0700 (PDT)
Message-ID: <50660B4C.9060604@redhat.com>
Date: Fri, 28 Sep 2012 16:40:44 -0400
From: Brian Foster <bfoster@redhat.com>
MIME-Version: 1.0
Subject: Re: [PATCH v4 1/8] xfs: add EOFBLOCKS inode tagging/untagging
References: <1348767952-24229-1-git-send-email-bfoster@redhat.com>
	<1348767952-24229-2-git-send-email-bfoster@redhat.com>
	<20120928070401.GH25626@dastard>
In-Reply-To: <20120928070401.GH25626@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On 09/28/2012 03:04 AM, Dave Chinner wrote:
> On Thu, Sep 27, 2012 at 01:45:45PM -0400, Brian Foster wrote:
>> Add the XFS_ICI_EOFBLOCKS_TAG inode tag to identify inodes with
>> speculatively preallocated blocks beyond EOF. An inode is tagged
>> when speculative preallocation occurs and untagged either via
>> truncate down or when post-EOF blocks are freed via release or
>> reclaim.
>>
>> The tag management is intentionally not aggressive to prefer
>> simplicity over the complexity of handling all the corner cases
>> under which post-EOF blocks could be freed (i.e., forward
>> truncation, fallocate, write error conditions, etc.). This means
>> that a tagged inode may or may not have post-EOF blocks after a
>> period of time. The tag is eventually cleared when the inode is
>> released or reclaimed.
>>
>> Signed-off-by: Brian Foster <bfoster@redhat.com>
> 
> Apart from the fact this conflicts with my xfssyncd killing patchset
> and xfs_sync.c no longer exists, it looks fine.
> 
> Can you rebase this on top of my patch series? Mostly it is simply
> making your changes to xfs_icache.c rather than xfs_sync.c as that's
> where all this inode cache radix tree walking code is now.....
> 

Sure. I skimmed through the first set and it didn't seem like a major
conflict. I'll rebase against the v3 xfssyncd set for my next version.

Brian

> Cheers,
> 
> Dave.
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

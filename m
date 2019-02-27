Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:55034 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729432AbfB0XLf (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 27 Feb 2019 18:11:35 -0500
Subject: Re: [ANNOUNCE] xfsprogs for-next updated to bb83d20
References: <e1bd5016-cef2-c61b-7540-cf75d960c16d@sandeen.net>
 <65344cb3-31af-2f5c-3d1f-fb45bc609b77@sandeen.net>
 <20190227230302.GL21626@magnolia>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <a1d6bd13-5e7d-f53e-6de6-cdde486f9a82@sandeen.net>
Date: Wed, 27 Feb 2019 17:11:33 -0600
MIME-Version: 1.0
In-Reply-To: <20190227230302.GL21626@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>

On 2/27/19 5:03 PM, Darrick J. Wong wrote:
> On Wed, Feb 27, 2019 at 04:19:03PM -0600, Eric Sandeen wrote:
>> On 2/27/19 3:39 PM, Eric Sandeen wrote:
>>> Hi folks,
>>>
>>> The xfsprogs repository at:
>>>
>>> 	git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git
>>>
>>> has just been updated.
>>>
>>> This contains only the sync to the kernel's libxfs updates for v5.0.
>>>
>>> The new head of the for-next branch is commit:
>>
>> Fixed a thinko stray ; caught by coverity and did a forced push on
>> these branches right quick before anyone but djwong pulled it down. ;)
> 
> Hmmm, I still some discrepancies...
> 
> diff -Naurp xfsprogs/libxfs/xfs_ialloc.c kernel/libxfs/xfs_ialloc.c
> --- xfsprogs/libxfs/xfs_ialloc.c	2019-02-27 14:58:30.286319523 -0800
> +++ kernel/libxfs/xfs_ialloc.c	2019-02-27 14:58:48.512355119 -0800
> @@ -34,7 +34,7 @@ xfs_ialloc_cluster_alignment(
>  	struct xfs_mount	*mp)
>  {
>  	if (xfs_sb_version_hasalign(&mp->m_sb) &&
> -	    mp->m_sb.sb_inoalignmt >= mp->m_blocks_per_cluster)
> +	    mp->m_sb.sb_inoalignmt >= xfs_icluster_size_fsb(mp))
>  		return mp->m_sb.sb_inoalignmt;
>  	return 1;
>  }
> 
> 
> Over on the kernel side we're still using xfs_icluster_size_fsb in the
> comparison test.  TBH I don't remember whether this is actually required
> on the kernel side or not, but in any case this ought to go through the
> kernel.

That was a mistake, I was searching for direct users of xfs_icluster_size_fsb
elsewhere and converting them to the precalculated value, and accidentally
hit libxfs. I can change it back.

> I /think/ the reason is that I didn't want the initializer functions for
> the xfs_mount inode goemetry fields to depend on them being set in any
> particular order.

I'll fix it regardless.

> 
> 
> diff -Naurp xfsprogs/libxfs/xfs_types.h kernel/libxfs/xfs_types.h
> --- xfsprogs/libxfs/xfs_types.h	2019-02-27 14:58:30.287319525 -0800
> +++ kernel/libxfs/xfs_types.h	2019-02-27 14:58:48.516355127 -0800
> @@ -114,8 +114,8 @@ typedef enum {
>  	{ XFS_LOOKUP_GEi,	"ge" }
>  
>  /*
> - * This enum is used in string mapping in xfs_trace.h; please keep the
> - * TRACE_DEFINE_ENUMs for it up to date.
> + * This enum is used in string mapping in xfs_trace.h and scrub/trace.h;
> + * please keep the TRACE_DEFINE_ENUMs for it up to date.
>   */
>  typedef enum {
>  	XFS_BTNUM_BNOi, XFS_BTNUM_CNTi, XFS_BTNUM_RMAPi, XFS_BTNUM_BMAPi,
> 
> I think you're missing "xfs: stringify scrub types in ftrace output".

forgot to guilt push it on prior to the re-push.  :/

> 
> --D
> 
>> Now we're at:
>>
>> bb83d20 xfs: stringify btree cursor types in ftrace output
>>
>> New Commits:
>>
>> Darrick J. Wong (11):
>>       [5afb131] xfs: idiotproof defer op type configuration
>>       [5a23b29] xfs: streamline defer op type handling
>>       [c2d5dd0] xfs: const-ify xfs_owner_info arguments
>>       [9ef0cb4] xfs: remove xfs_rmap_ag_owner and friends
>>       [09c23f4] xfs: add a block to inode count converter
>>       [ad5eff9] xfs: precalculate inodes and blocks per inode cluster
>>       [6180d69] xfs: precalculate cluster alignment in inodes and blocks
>>       [ef1b0a2] xfs: fix symbolic enum printing in ftrace output
>>       [a97fc90] xfs: move XFS_AG_BTREE_CMP_FORMAT_STR mappings to libxfs
>>       [e01dc40] xfs: move XFS_INODE_FORMAT_STR mappings to libxfs
>>       [bb83d20] xfs: stringify btree cursor types in ftrace output
>>
>> Dave Chinner (1):
>>       [7ab21d5] xfs: zero length symlinks are not valid
>>
>> Omar Sandoval (1):
>>       [6890a4c] xfs: cache minimum realtime summary level
>>
>> Pan Bian (1):
>>       [972ca59] xfs: libxfs: move xfs_perag_put late
>>
>>
> 
> 
> 

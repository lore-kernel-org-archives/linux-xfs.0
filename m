Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id B509429E1A
	for <xfs@oss.sgi.com>; Tue,  5 Nov 2013 16:03:23 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id A8E7D8F8059
	for <xfs@oss.sgi.com>; Tue,  5 Nov 2013 14:03:20 -0800 (PST)
Received: from mail-qa0-f52.google.com (mail-qa0-f52.google.com
	[209.85.216.52]) by cuda.sgi.com with ESMTP id X2u5LEIqMEqO7pAX
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 05 Nov 2013 14:03:19 -0800 (PST)
Received: by mail-qa0-f52.google.com with SMTP id ii20so918444qab.18
	for <xfs@oss.sgi.com>; Tue, 05 Nov 2013 14:03:19 -0800 (PST)
Message-ID: <52796B21.5080706@gmail.com>
Date: Tue, 05 Nov 2013 17:03:13 -0500
From: "Michael L. Semon" <mlsemon35@gmail.com>
MIME-Version: 1.0
Subject: Re: How to use increased number of ACL entries?
References: <20131103081704.GE9974@fit.vutbr.cz>
	<20131104003915.GN6188@dastard> <5277086E.6030905@sandeen.net>
	<52771FFE.8030009@gmail.com> <5277AE19.0@sandeen.net>
	<20131104151050.GS9974@fit.vutbr.cz>
	<20131104204647.GO6188@dastard>
In-Reply-To: <20131104204647.GO6188@dastard>
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
To: Dave Chinner <david@fromorbit.com>, Kasparek Tomas <kasparek@fit.vutbr.cz>
Cc: Eric Sandeen <sandeen@sandeen.net>, xfs@oss.sgi.com

On 11/04/2013 03:46 PM, Dave Chinner wrote:
> On Mon, Nov 04, 2013 at 04:10:50PM +0100, Kasparek Tomas wrote:
>> On Mon, Nov 04, 2013 at 08:24:25AM -0600, Eric Sandeen wrote:
>>>> However, it should be dirent (ftype=1 in the above output) that keeps a 
>>>> vanilla 3.10.17 kernel from mounting the resulting filesystem:
>>>
>>> I'm sorry, you are right - it hit kernel v3.11:
>>>
>>> 5c87d4bc1a86bd6e6754ac3d6e111d776ddcfe57 xfs: increase number of ACL entries for V5 superblocks
>>>
>>> $ git describe --contains 5c87d4bc1a86bd6e6754ac3d6e111d776ddcfe57
>>> v3.11-rc1~18^2~41
>>
>> And get to stable 3.10 later.
>>
>> https://git.kernel.org/cgit/linux/kernel/git/stable/linux-stable.git/commit/?id=0a8aa1939777dd114479677f0044652c1fd72398
> 
> No, that never went into the 3.10 stable tree, and nor should it.
> 
> Cheers,
> 
> Dave.
> 

>From the patch in the link above, I get this snippet from 3.10.17's 
xfs_acl.c...

	/*
	 * If we have a cached ACLs value just return it, not need to
	 * go out to the disk.
	 */
	len = XFS_ACL_MAX_SIZE(ip->i_mount);
	xfs_acl = kzalloc(len, GFP_KERNEL);
	if (!xfs_acl)
		return ERR_PTR(-ENOMEM);

...and this from 3.10.17's xfs_acl.h...

/*
 * The number of ACL entries allowed is defined by the on-disk format.
 * For v4 superblocks, that is limited to 25 entries. For v5 superblocks, it is
 * limited only by the maximum size of the xattr that stores the information.
 */
#define XFS_ACL_MAX_ENTRIES(mp)	\
	(xfs_sb_version_hascrc(&mp->m_sb) \
		?  (XATTR_SIZE_MAX - sizeof(struct xfs_acl)) / \
						sizeof(struct xfs_acl_entry) \
		: 25)

#define XFS_ACL_MAX_SIZE(mp) \
	(sizeof(struct xfs_acl) + \
		sizeof(struct xfs_acl_entry) * XFS_ACL_MAX_ENTRIES((mp)))

...so that patch seems to have made it into vanilla 3.10.17 somehow.  
I checked the Changelogs for 3.10.x but don't know how to check a 
Changelog for just 3.10 stable.  Therefore, I unpacked a kernel.org 3.10 
tarball, and these changes are in there as well.

For lack of skills, I can point only to this in the kernel git, where 
this is the master branch.  xfs-oss/master is downloaded but not merged:

commit e6395b68ad09a835f058da31bad0fe23d3882659
Merge: 29eb778 0a8aa19
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Thu Jun 6 16:15:25 2013 -0700

    Merge tag 'for-linus-v3.10-rc5' of git://oss.sgi.com/xfs/xfs

    Pull more xfs updates from Ben Myers:
     "Here are several fixes for filesystems with CRC support turned on:
      fixes for quota, remote attributes, and recovery.  There is also some
      feature work related to CRCs: the implementation of CRCs for the inode
      unlinked lists, disabling noattr2/attr2 options when appropriate, and
      bumping the maximum number of ACLs.

Maybe somebody with a git of stable could shed some light...

Thanks for reading!

Michael

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

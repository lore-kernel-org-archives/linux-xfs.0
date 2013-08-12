Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 6A6E27F87
	for <xfs@oss.sgi.com>; Mon, 12 Aug 2013 08:25:24 -0500 (CDT)
Message-ID: <5208E243.9080403@sgi.com>
Date: Mon, 12 Aug 2013 08:25:23 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: ***** SUSPECTED SPAM ***** Re: [PATCH 48/49] xfs: Add read-only
	support for dirent filetype field
References: <1374215120-7271-1-git-send-email-david@fromorbit.com>
	<1374215120-7271-49-git-send-email-david@fromorbit.com>
	<51F80FA8.4060304@sgi.com> <20130812005905.GK12779@dastard>
In-Reply-To: <20130812005905.GK12779@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On 08/11/13 19:59, Dave Chinner wrote:
> On Tue, Jul 30, 2013 at 02:10:32PM -0500, Mark Tinguely wrote:
>> On 07/19/13 01:25, Dave Chinner wrote:
>>> From: Dave Chinner<dchinner@redhat.com>
>>>
>>> Add support for the file type field in directory entries so that
>>> readdir can return the type of the inode the dirent points to to
>>> userspace without first having to read the inode off disk.
>>>
>>> The encoding of the type field is a single byte that is added to the
>>> end of the directory entry name length. For all intents and
>>> purposes, it appends a "hidden" byte to the name field which
>>> contains the type information. As the directory entry is already of
>>> dynamic size, helpers are already required to access and decode the
>>> direct entry structures.
>>>
>>> Hence the relevent extraction and iteration helpers are updated to
>>> understand the hidden byte.  Helpers for reading and writing the
>>> filetype field from the directory entries are also added. Only the
>>> read helpers are used by this patch.  It also adds all the code
>>> necessary to read the type information out of the dirents on disk.
>>>
>>> Further we add the superblock feature bit and helpers to indicate
>>> that we understand the on-disk format change. This is not a
>>> compatible change - existing kernels cannot read the new format
>>> successfully - so an incompatible feature flag is added. We don't
>>> yet allow filesystems to mount with this flag yet - that will be
>>> added once write support is added.
>>>
>>> Finally, the code to take the type from the VFS, convert it to an
>>> XFS on-disk type and put it into the xfs_name structures passed
>>> around is added, but the directory code does not use this field yet.
>>> That will be in the next patch.
>>>
>>> Signed-off-by: Dave Chinner<dchinner@redhat.com>
>>> ---
>>>
>>
>>> +static inline int xfs_sb_version_hasftype(struct xfs_sb *sbp)
>>> +{
>>> +	return XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5&&
>>> +		xfs_sb_has_incompat_feature(sbp, XFS_SB_FEAT_INCOMPAT_FTYPE);
>>>   }
>>>
>>
>> This feature should support inode version 2 and 3.
>
> Has nothing to do with the inode version number - it has to do with
> the directory structure being modified.
>
> We're changing the directory structure for CRCs, and this builds on
> top of that. It is essentially part of the V3 directory format, and
> should be treated as such. Suggesting that we retrofit and support a
> modified v2 directory format is close to insane - instead of only
> having to test v2 vs v3 directory formats, you're suggesting we
> support v2 vs v2+dtype vs v3 vs v3+dtype. We simply do not have the
> resources to adequately test and support such an explosion of
> filesystem configurations.
>
> We've had this discussion before - new on-disk features go into the
> v5 superblock format - the v4 superblock format from this point
> onwards is essentially legacy support from an upstream development
> perspective.  Upstream development is about moving forward as
> quickly and cleanly as possible - quadrupling the test matrix for
> every minor on-disk change is simply not something we can sustain,
> and that's why I'm pushing back *hard* on any suggestion that we
> shoul dbe supporting new on-disk format changes on both v4 and v5
> superblocks formats. v5 is the future and so all new features need
> to target v5 filesystem formats and ignore the restrictions that v4
> filesystem formats might place on them.
>
> That said, there's nothing to stop anyone from backporting such a
> feature to an older kernel and maintaining it themselves - it's open
> source software. But the idea that development should be constrained
> by having to support both old and new formats is wrong - the old v4
> format should be considered stable and we need think very hard about
> changing it at all now, especially as much of the development focus
> is now shifting to taking advantage of the additions to the v5
> format....
>
> Cheers,
>
> Dave.

I guess we need more time to argue this out. It is not going into Linux 
3.12 as a crc feature only.

--Mark.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

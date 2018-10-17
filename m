Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:39402 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727101AbeJRHBY (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 18 Oct 2018 03:01:24 -0400
Subject: Re: [PATCH] xfs: reject per-inode dax flag on reflink filesystems
From: Eric Sandeen <sandeen@sandeen.net>
References: <c1ad993d-5330-88c3-b859-06e33dcd75d8@redhat.com>
 <20181017223047.GR28243@magnolia>
 <7ea6bd8c-fcda-e1bc-0438-1d741a575e75@sandeen.net>
Message-ID: <38b1c213-e8a3-6785-264f-b84c7ed2b2f9@sandeen.net>
Date: Wed, 17 Oct 2018 18:03:27 -0500
MIME-Version: 1.0
In-Reply-To: <7ea6bd8c-fcda-e1bc-0438-1d741a575e75@sandeen.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>, Eric Sandeen <sandeen@redhat.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>, Jeff Moyer <jmoyer@redhat.com>



On 10/17/18 5:49 PM, Eric Sandeen wrote:
> 
> 
> On 10/17/18 5:30 PM, Darrick J. Wong wrote:
>> On Wed, Oct 17, 2018 at 05:20:56PM -0500, Eric Sandeen wrote:
>>> Today we reject this flag on an already-reflinked inode, but we really
>>> need to reject it for any inode on a reflink-capable filesystem until
>>> reflink+dax is supported.
>>>
>>> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
>>> ---
>>>
>>> (um, do we need to catch this when reading from disk as well?  If we
>>> found a dax-flagged inode on a reflinked fs, then what would we do with it?)
>>
>> Ignore the DAX flag.  See xfs_inode_supports_dax.
> 
> Oh, ok.
> 
> Hohum, by that measure shouldn't we allow mount -o dax on reflink filesystems,
> and just ignore/reject dax behavior on actually reflinked inodes?
> 
>>> diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
>>> index 0ef5ece5634c..63d579c652f2 100644
>>> --- a/fs/xfs/xfs_ioctl.c
>>> +++ b/fs/xfs/xfs_ioctl.c
>>> @@ -1031,8 +1031,9 @@ xfs_ioctl_setattr_xflags(
>>>  	if ((fa->fsx_xflags & FS_XFLAG_REALTIME) && xfs_is_reflink_inode(ip))
>>>  		ip->i_d.di_flags2 &= ~XFS_DIFLAG2_REFLINK;
>>>  
>>> -	/* Don't allow us to set DAX mode for a reflinked file for now. */
>>> -	if ((fa->fsx_xflags & FS_XFLAG_DAX) && xfs_is_reflink_inode(ip))
>>> +	/* Don't allow us to set DAX mode on a reflink filesystem for now. */
>>> +	if ((fa->fsx_xflags & FS_XFLAG_DAX) &&
>>> +	    xfs_sb_version_hasreflink(&ip->i_mount->m_sb))
>>>  		return -EINVAL;
>>
>> Not sure we need this, since DAX always loses to REFLINK, whether it's
>> at inode loading time or if someone's trying to set it in the ioctl.
> 
> loses to a reflinked /inode/ but not to a reflink-capable fs, like
> mount does.
> 
>> Ofc it's hard to say what the behavior should be since the dax iflag
>> semantics are poorly defined (it's been more or less advisory this whole
>> time)...
>>
>> ...but I gather you're sending this patch because you don't like this
>> wishy washy "ok you change this flag but it doesn't tell you if that had
>> any effect and there's no way to find out either" behavior? :)
> 
> Just aiming for some semblance of consistency.  Today we have:
> 
> mount -o dax + xfs_sb_version_hasreflink =>
> 	ignore mount option, disable dax for all inodes regardless of reflinked status
> 
> chattr +x + xfs_sb_version_hasreflink =>
> 	inode is dax until it gets reflinked, then it's ignored
> 
> right?
> 
> (and what happens if we have a daxified inode that gets reflinked later?)

              Bit 15 (0x8000) - XFS_XFLAG_DAX
                        If the filesystem lives on directly accessible persistent  mem‐
                        ory, reads and writes to this file will go straight to the per‐
                        sistent memory, bypassing the page cache.   A  file  cannot  be
                        reflinked  and  have  the  XFS_XFLAG_DAX  set at the same time.
                        That is to say that DAX files cannot share blocks.

# xfs_io -c "lsattr" /mnt/test/dax
--------------x- /mnt/test/dax 

# cp --reflink=always /mnt/test/dax /mnt/test/reflink

# xfs_io -c "lsattr" /mnt/test/reflink 
---------------- /mnt/test/reflink 

# xfs_bmap -v /mnt/test/dax /mnt/test/reflink
/mnt/test/dax:
 EXT: FILE-OFFSET      BLOCK-RANGE      AG AG-OFFSET        TOTAL
   0: [0..7]:          104..111          0 (104..111)           8 100000
/mnt/test/reflink:
 EXT: FILE-OFFSET      BLOCK-RANGE      AG AG-OFFSET        TOTAL
   0: [0..7]:          104..111          0 (104..111)           8 100000

# xfs_io -c "lsattr" /mnt/test/dax
--------------x- /mnt/test/dax 

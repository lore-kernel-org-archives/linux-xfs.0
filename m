Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 09 Oct 2006 18:46:56 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id k9A1knaG030188
	for <xfs@oss.sgi.com>; Mon, 9 Oct 2006 18:46:51 -0700
Date: Tue, 10 Oct 2006 11:45:55 +1000
From: Timothy Shimmin <tes@sgi.com>
Subject: Re: xfs vs. lockdep
Message-ID: <C013892BDA68824F76A0474A@boing.melbourne.sgi.com>
In-Reply-To: <20061010004726.GO11034@melbourne.sgi.com>
References: <452A8DE2.4000608@sandeen.net>
 <20061010004726.GO11034@melbourne.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>, Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com

--On 10 October 2006 10:47:26 AM +1000 David Chinner <dgc@sgi.com> wrote:

> On Mon, Oct 09, 2006 at 12:58:58PM -0500, Eric Sandeen wrote:
>> FC6 kernels are oopsing when lockdep & memory debugging are turned on,
>> looks like due to this code:
>>
>> xfs_ireclaim(xfs_inode_t *ip)
>> {
>>    ...
>>         /*
>>          * Here we do a spurious inode lock in order to coordinate with
>>          * xfs_sync().  This is because xfs_sync() references the inodes
>>          * in the mount list without taking references on the
>>          corresponding * vnodes.  We make that OK here by ensuring that
>>          we wait until * the inode is unlocked in xfs_sync() before we
>>          go ahead and * free it.  We get both the regular lock and the
>>          io lock because * the xfs_sync() code may need to drop the
>>          regular one but will * still hold the io lock.
>>          */
>>         xfs_ilock(ip, XFS_ILOCK_EXCL | XFS_IOLOCK_EXCL);
>> ...
>>         /*
>>          * Free all memory associated with the inode.
>>          */
>>         xfs_idestroy(ip);
>> }
>>
>> So, lock & free.  This frees memory that lockdep is still pointing to,
>> and tries to use later.
>>
>> Calling xfs_iunlock(ip, XFS_ILOCK_EXCL | XFS_IOLOCK_EXCL); just before
>> xfs_idestroy seems to solve it, but is this safe...?
>
> It should be - we call xfs_iextract() before the xfs_ilock() call
> shown above. That means the inode has been removed from the mount
> list when we take the locks. Once the inode has been removed
> from the mount list, the only possible current user is xfs_sync_inodes(),
> and it will only be referencing the inode if it is currently working
> on the inode. If it is working on the inode, then it will be holding
> at least one of the inode locks.
>
> Hence by the time we have the lock here in xfs_ireclaim we have guaranteed
> that there are no other outstanding references and no new references
> can occur. Therefore it should be safe to drop the lock before destroying
> it.
>
Yeah, there really seems like something would be wrong if you can't
unlock it before destroying it.
I would have thought you'd need to guarantee that you are the only
one with access to it before destroying it otherwise there'd be problems :)
(Which as you say we do)

This one rings a bell. I seem to recall multiple places where we destroy
without releasing the lock first.
And I vaguely remember Nathan mentioning that this was causing grief
for lockdep:)

--Tim

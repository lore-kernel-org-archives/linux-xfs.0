Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:39012 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750962AbeEAWUE (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 1 May 2018 18:20:04 -0400
Subject: Re: [PATCH 4/5] xfs: implement online get/set fs label
References: <eb592fc3-3165-5ec7-3896-b798fc7f6502@redhat.com>
 <698bd41a-9281-83a2-ff51-64547025442a@sandeen.net>
 <20180501221113.GW23861@dastard>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <044aeb24-e11a-9d51-9d7e-81868ed83f69@sandeen.net>
Date: Tue, 1 May 2018 17:20:03 -0500
MIME-Version: 1.0
In-Reply-To: <20180501221113.GW23861@dastard>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>

On 5/1/18 5:11 PM, Dave Chinner wrote:
> On Mon, Apr 30, 2018 at 10:46:37AM -0500, Eric Sandeen wrote:
>> The GET ioctl is trivial, just return the current label.
>>
>> The SET ioctl is more involved:
>> It transactionally modifies the superblock to write a new filesystem
>> label to the primary super.
>>
>> It then also checkpoints the log to disk so that the change lands in
>> block 0, invalidates any page cache that userspace might have previously
>> read, and updates all secondary superblocks as userspace relable does.
>>
>> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
>> ---
> 
> Just to close the loop on what Eric and I just talked about on
> IRC....

Gracias.

>> +xfs_ioc_setlabel(
>> +	struct file		*filp,
>> +	struct xfs_mount	*mp,
>> +	char			__user *newlabel)
>> +{
>> +	struct address_space	*mapping;
>> +	struct xfs_sb		*sbp = &mp->m_sb;
>> +	char			label[FSLABEL_MAX];
>> +	size_t			len;
>> +	int			error;
>> +
>> +	if (!capable(CAP_SYS_ADMIN))
>> +		return -EPERM;
>> +
>> +	if (copy_from_user(label, newlabel, FSLABEL_MAX))
>> +		return -EFAULT;
>> +	/*
>> +	 * The generic ioctl allows up to FSLABEL_MAX chars, but xfs is much
>> +	 * smaller, at 12 bytes.
>> +	 * NB: The on disk label doesn't need to be null terminated.
>> +	 */
>> +	len = strnlen(label, FSLABEL_MAX);
>> +	if (len > sizeof(sbp->sb_fname)) {
>> +		xfs_warn(mp, "label %s is too long, max %zu chars",
>> +			label, sizeof(sbp->sb_fname));
>> +		return -EINVAL;
>> +	}
>> +
>> +	error = mnt_want_write_file(filp);
>> +	if (error)
>> +		return error;
>> +
>> +	spin_lock(&mp->m_sb_lock);
>> +	memset(sbp->sb_fname, 0, sizeof(sbp->sb_fname));
>> +	strncpy(sbp->sb_fname, label, sizeof(sbp->sb_fname));
>> +	spin_unlock(&mp->m_sb_lock);
>> +
>> +	error = xfs_sync_sb(mp, true);
>> +	if (error)
>> +		goto out;
> 
> This is all good up to here. We want a synchronous transaction to
> force the change to the log and *unpin the superblock buffer* at the
> same time.
> 
> However, we want to also write the superblock buffer, and so we
> really should have a function that does this directly: i.e.
> 
> 	/* Force superblock label changes to disk */
> 	error = xfs_sync_sb_buf(mp);
> 	if (error)
> 		goto out;
> 
> which does:
> 
> xfs_sync_sb_buf()
> {
> 	/* same transaction preamble and logging as xfs_sync_sb() */
> 	.....
> 
> 	xfs_trans_bhold(tp, bp);
> 	xfs_trans_set_sync(tp);
> 	error = xfs_trans_commit(tp);
> 	if (error)
> 		goto out;
> 
> 	/*
> 	 * write out the sb buffer to get the changes to disk
> 	 */
> 	error = xfs_bwrite(bp);
> 	xfs_buf_relse(bp);
> 	return error;
> }

Thank you thank you thank you :)  That looks awesome, let me try this.

> 
>> +	/* checkpoint the log to update primary super in fs itself */
>> +	error = xfs_log_checkpoint(mp);
>> +	if (error)
>> +		goto out;
>> +
>> +	/* invalidate any cached bdev page for userspace visibility */
>> +	mapping = mp->m_ddev_targp->bt_bdev->bd_inode->i_mapping;
>> +	error = invalidate_inode_pages2_range(mapping, 0, 0);
>> +	if (error)
>> +		goto out;
> 
> invalidate_bdev()? We don't use this block device
> mapping, so just invalidating it completely is probably appropriate.
> FWIW, ISTR that userspace points at a different address space
> mapping and we can't invalidate that directly ourselves? Worth
> checking...

I thought the same thing.  :)  But it doesn't seem to be the case; the
above really does work, and it really is the same address space as verified
by a couple printks.  ;)

I guess invalidating the whole device is fine, but is there any real reason
to?  Maybe we would like xfs_db to see the secondaries as well?  *Shrug*
invalidate_bdev() is easier to call, I'll try it.

> 
>> +	/* update the backup superblocks like userspace does */
>> +	if (mutex_trylock(&mp->m_growlock)) {
>> +		error = xfs_update_secondary_supers(mp, mp->m_sb.sb_agcount, 0);
>> +		mutex_unlock(&mp->m_growlock);
>> +	}
> 
> Why not just block here?

Yeah, I'll change it.

Thanks!
-Eric

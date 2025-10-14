Received: from mx0.herbolt.com (mx0.herbolt.com [5.59.97.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19633299949
	for <linux-xfs@vger.kernel.org>; Tue, 14 Oct 2025 08:11:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=5.59.97.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760429466; cv=none; b=ad7Laaf7FHpvYt1gE2548wb3Yo8pepdjLSuZ8pWBJl5cx4cjJs59UFQUlXaRTxKEKCKIRuvC7bNigkL6jqD85A2KycKAtFrsW8fJjXyezwx2422TiHx4BUDgHajkYCBTPNyRUlCdqUjdS+Bvs/yWfDPCEthPhYUF7ulsWy2KRRc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760429466; c=relaxed/simple;
	bh=cIUxYCg0pNE3HGytQFII5b8dMd6p7IyJjqRO9zMn5G0=;
	h=MIME-Version:Date:From:To:Cc:Subject:In-Reply-To:References:
	 Message-ID:Content-Type; b=ctGf0Js6rY9ubbpCm6aqISqSJBP37Oj0/H3QxWOXJu2K9q2G7K+0UufpzpOFn4vPIiGcaaUUMyKhbXAc4QvYOO/nFZkySBr3bZBw+bfPwbcCTUvZ/78oAeHgL9lz7Bajsv6B12UsyySKJezDHTODj1Aed5gNIsP7n0mGQwNb1IM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=herbolt.com; spf=pass smtp.mailfrom=herbolt.com; arc=none smtp.client-ip=5.59.97.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=herbolt.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=herbolt.com
Received: from mx0.herbolt.com (localhost [127.0.0.1])
	by mx0.herbolt.com (Postfix) with ESMTP id ED844180FCC2;
	Tue, 14 Oct 2025 10:10:51 +0200 (CEST)
Received: from mail.herbolt.com ([172.168.31.10])
	by mx0.herbolt.com with ESMTPSA
	id gUxTOYsF7miAPRIAKEJqOA
	(envelope-from <lukas@herbolt.com>); Tue, 14 Oct 2025 10:10:51 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Tue, 14 Oct 2025 10:10:51 +0200
From: lukas@herbolt.com
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH RFC] xfs: add FALLOC_FL_WRITE_ZEROES to XFS code base
In-Reply-To: <aOCfus7PgLl812qf@infradead.org>
References: <20251002122823.1875398-2-lukas@herbolt.com>
 <aN-Aac7J7xjMb_9l@infradead.org> <20251004040020.GC8096@frogsfrogsfrogs>
 <aOCfus7PgLl812qf@infradead.org>
Message-ID: <dee6b75856d013f8aa6de1c17ff0f20a@herbolt.com>
X-Sender: lukas@herbolt.com
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit

On 2025-10-04 06:16, Christoph Hellwig wrote:
> On Fri, Oct 03, 2025 at 09:00:20PM -0700, Darrick J. Wong wrote:
>> > > -	error = xfs_alloc_file_space(XFS_I(inode), offset, len);
>> > > +	if (mode & FALLOC_FL_WRITE_ZEROES) {
>> > > +		if (!bdev_write_zeroes_unmap_sectors(inode->i_sb->s_bdev))
>> 
>>      		                         not correct ^^^^^^^^^^^^^^^^^^^
>> 
>> You need to find the block device associated with the file because XFS
>> is a multi-device filesystem.
> 
> Indeed. xfs_inode_buftarg will do the work, but we'll need to ensure

Thanks for xfs_inode_buftarg pointer.

> the RT bit doesn't get flipped, i.e. it needs to hold a lock between
> that check and allocation the blocks if there were none yet.

I am having bit of trouble with that. If I get it right we should hold
the XFS_ILOCK_EXCL but this lock is then grabbed in the 
xfs_trans_alloc_inode.

So I would need to release before and there would be again a small 
window
where the RT flag can be flipped.

Looking at the xfs_alloc_file_space, there is also check for the RT bit 
without
lock, so this also need an attention.
     rt = XFS_IS_REALTIME_INODE(ip);
     extsz = xfs_get_extsz_hint(ip);

Or the xfs_trans_alloc_inode would need to check if we are a;ready 
holding the
lock Is there a way how to check the current thread is the owner of the
xfs_ilock rw_sem?

Something like?
---
static inline bool is_current_writer(struct rw_semaphore *sem)
{
     /* The rwsem_owner() helper can be used to get the owner */
     return sem->owner == current;
}
---

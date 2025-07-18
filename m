Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A3E516DEB3
	for <linux-xfs@vger.kernel.org>; Fri, 18 Jul 2025 19:38:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752867533; cv=none; b=LTlrIFf0q2B3J7PuU1KzdasnlENAtK5zK47xthidgxD4rJ0cygxquAMJxuqkHzXzrn6Is/vYzdKkuA9WRbOSwzol8lj4JuptqSA91Iya56BvG2OhhAzSnY8+xrYwQJ60EUPrursqRmMv4az2uRiJBWlpWbjGwgwbHj7HDt5NW7Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752867533; c=relaxed/simple;
	bh=uiBj5hwBBOcB7BnZ+zEonlGQIHVs0sW7CScoEY4D3Z0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UCakkzYcKHTi/UsX8+qskbtU1kmN5ptTuvdjQSQ6xfLA7aFiOwW95kbliwWHUKuZRJXMx4xNbS+LuiXAbrUzmGTZnOTB1bhGMLwLUPDILzRSZg6sueTkCPMXHOBrZFzRfaGSRPBBTb07IWGBCsi4e9b1BIsBH4I8D3cFZrSff6E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DjwG+fMK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DjwG+fMK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51147C4CEEB;
	Fri, 18 Jul 2025 19:38:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1752867533;
	bh=uiBj5hwBBOcB7BnZ+zEonlGQIHVs0sW7CScoEY4D3Z0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=DjwG+fMKFgRA2nT0PJXMMKIbZK+yL8nmSwIsxP35UvOVnqIDfiis3+aZi3N0If6N1
	 vuf5r86KLpPWZZlaMf+cMil/b7Xvenr6vDY2oCrarFxhNs3hFio2WpeuFun1T3sgTy
	 0/dr1T/05kANU7QBs6rIbZArNzlhYfXA2osj88akiD87V1Gkv9/ijXxQTTSsQ3KPzh
	 /wkFCIxvsAz5fDtJU87EGBK7LMeOfYmlevyS1JDHpiMbC18o2Az2XU1s1dkTX734VV
	 QHU6q+ZZfn6ebZ3O6R+JY9uTTaMySKvyIZNpKLh17xjxeT+tR+O5FOGbX+5wHzg+pr
	 gdOu6d20gCMUw==
Date: Fri, 18 Jul 2025 12:38:52 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: John Garry <john.g.garry@oracle.com>
Cc: hch@lst.de, cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: disallow atomic writes on DAX
Message-ID: <20250718193852.GR2672070@frogsfrogsfrogs>
References: <20250717151900.1362655-1-john.g.garry@oracle.com>
 <20250717160255.GP2672049@frogsfrogsfrogs>
 <1b61ffa1-870d-4b30-9ba8-014a9ca5d33f@oracle.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1b61ffa1-870d-4b30-9ba8-014a9ca5d33f@oracle.com>

On Fri, Jul 18, 2025 at 09:15:07AM +0100, John Garry wrote:
> On 17/07/2025 17:02, Darrick J. Wong wrote:
> > On Thu, Jul 17, 2025 at 03:19:00PM +0000, John Garry wrote:
> > > Atomic writes are not currently supported for DAX, but two problems exist:
> > > - we may go down DAX write path for IOCB_ATOMIC, which does not handle
> > >    IOCB_ATOMIC properly
> > > - we report non-zero atomic write limits in statx (for DAX inodes)
> > > 
> > > We may want atomic writes support on DAX in future, but just disallow for
> > > now.
> > > 
> > > For this, ensure when IOCB_ATOMIC is set that we check the write size
> > > versus the atomic write min and max before branching off to the DAX write
> > > path. This is not strictly required for DAX, as we should not get this far
> > > in the write path as FMODE_CAN_ATOMIC_WRITE should not be set.
> > > 
> > > In addition, due to reflink being supported for DAX, we automatically get
> > > CoW-based atomic writes support being advertised. Remedy this by
> > > disallowing atomic writes for a DAX inode for both sw and hw modes.
> > 
> > ...because it's fsdax and who's really going to test/use software atomic
> > writes there ?
> 
> Right
> 
> > 
> > > Finally make atomic write size and DAX mount always mutually exclusive.
> > 
> > Why?  You could have a rt-on-pmem filesystem with S_DAX files, and still
> > want to do atomic writes to files on the data device.
> 
> How can I test that, i.e. put something on data device?
> 
> I tried something like this:
> 
> $mkfs.xfs -f -m rmapbt=0,reflink=1 -d rtinherit=1 -r rtdev=/dev/pmem0
> /dev/pmem1
> $mount /dev/pmem1 mnt -o dax=always,rtdev=/dev/pmem0  -o
> max_atomic_write=16k
> $mkdir mnt/non_rt
> $xfs_io -c "chattr -t" mnt/non_rt/ #make non-rt
> $touch mnt/non_rt/file
> $xfs_io -c "lsattr -v" mnt/non_rt/file
> [has-xattr] mnt/non_rt/file
> $xfs_io -c "statx -r -m 0x10000" mnt/non_rt/file
> ---
> stat.atomic_write_unit_min = 0
> stat.atomic_write_unit_max = 0
> stat.atomic_write_segments_max = 0
> ---
> 
> I thought that losing the rtinherit flag would put the file on the data
> device. From adding some kernel debug, it seems that this file is still
> IS_DAX() == true

The data device should be a regular scsi disk, not pmem.

--D

> > 
> > > Reported-by: "Darrick J. Wong" <djwong@kernel.org>
> > > Fixes: 9dffc58f2384 ("xfs: update atomic write limits")
> > > Signed-off-by: John Garry <john.g.garry@oracle.com>
> > > 
> > > diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> > > index db21b5a4b881..84876f41da93 100644
> > > --- a/fs/xfs/xfs_file.c
> > > +++ b/fs/xfs/xfs_file.c
> > > @@ -1102,9 +1102,6 @@ xfs_file_write_iter(
> > >   	if (xfs_is_shutdown(ip->i_mount))
> > >   		return -EIO;
> > > -	if (IS_DAX(inode))
> > > -		return xfs_file_dax_write(iocb, from);
> > > -
> > >   	if (iocb->ki_flags & IOCB_ATOMIC) {
> > >   		if (ocount < xfs_get_atomic_write_min(ip))
> > >   			return -EINVAL;
> > > @@ -1117,6 +1114,9 @@ xfs_file_write_iter(
> > >   			return ret;
> > >   	}
> > > +	if (IS_DAX(inode))
> > > +		return xfs_file_dax_write(iocb, from);
> > > +
> > >   	if (iocb->ki_flags & IOCB_DIRECT) {
> > >   		/*
> > >   		 * Allow a directio write to fall back to a buffered
> > > diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
> > > index 07fbdcc4cbf5..b142cd4f446a 100644
> > > --- a/fs/xfs/xfs_inode.h
> > > +++ b/fs/xfs/xfs_inode.h
> > > @@ -356,11 +356,22 @@ static inline bool xfs_inode_has_bigrtalloc(const struct xfs_inode *ip)
> > >   	(XFS_IS_REALTIME_INODE(ip) ? \
> > >   		(ip)->i_mount->m_rtdev_targp : (ip)->i_mount->m_ddev_targp)
> > > -static inline bool xfs_inode_can_hw_atomic_write(const struct xfs_inode *ip)
> > > +static inline bool xfs_inode_can_hw_atomic_write(struct xfs_inode *ip)
> > 
> > Why drop const here?  VFS_IC() should be sufficient, I think.
> > 
> 
> I dropped that const as I got a complaint about ignoring the const when
> passing to VFS_I(). But, as you say, I can use VFS_IC()
> 
> Thanks,
> John

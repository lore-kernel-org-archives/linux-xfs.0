Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794834119;
	b=IWJLN02QXlBEyXGiBuPzz23CxCBfyc2iCCp87w+v6LzomEjIQh/SVF2Iu7YMy5hPCJVE
	 7sTUXPqnRH5HJM7seQ2CC/7oAkSQQBc8NTEUKy8awMmkuDcCqIAFmDV1EFLhvs8M+wczK
	 8Fv7xESkMEsc5yzpQCetkVPQjfYO3Pgb4KaXpTrhx7aBKlVL7bXFR5rjaDiLux7/FXqAV
	 Bnwy9HvzHTWEM3KIC1F3cHRaXHVSMbAbyjW2XjlTgM7ZUCAZAIfdJRdzx4kDT0j8mAmgt
	 noI//RBjExTfLbmBENurWmaZ7PZtKNyHlxWF0o1u7VhFPN+MWT3Z/KDomFsljwx0YwA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794834119;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:DKIM-Signature:
	 DKIM-Signature:Received:Received:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-Spamd-Result:X-Spam-Score:X-Spam-Level:X-Spam-Flag;
	bh=8hoH9IiMClrhIYBlChM8QXxExxezUhUuWXttxdmFZd0=;
	b=TSzKpnGqEGFeHvxzudV2WABVYUtnCn2utEdGtwa1GcqcWeFN+tBxuXOIqMsk5GxdSHK4
	 a+pRQulS0KfdEQQ28RvDWJedS3RYdtxtBU6OMr2qLA6j/mpn97kM3eD/WqI4xq2hpoY3A
	 kPSBJ2mntKj89Wbh0xe8H53gBfiicXzPzNf8iHwJQw2d9lH2MY5qO0+9GQrzPZdxpxybP
	 +LyxyfPXZr3LemCLWh7qHuPq3OLARlah9pupJRXmgTZSpfV1caMrelTb4L/udiQ3Eu4E4
	 xWVIMqu4L5PeRHmElf9OUDmdmH0FWM0l0VqHW6oeNvrLL9W9qMxXfLAHjPagf0Hb8Sg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=suse.cz;
	spf=pass smtp.mailfrom=suse.cz;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=eM0QG5J3;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=nFTu75P6;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=eM0QG5J3;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=nFTu75P6;
	arc=none smtp.remote-ip=195.135.223.131
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27331606A31C;
	Mon, 16 Nov 2026 13:01:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 27331606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=eM0QG5J3;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=nFTu75P6;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=eM0QG5J3;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=nFTu75P6
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 6BB9B1F7DC;
	Mon, 16 Nov 2026 13:01:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1794834116; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=8hoH9IiMClrhIYBlChM8QXxExxezUhUuWXttxdmFZd0=;
	b=eM0QG5J3Ar/OVjoYH6swhmg6PKuxZgUUR1IHIk43PrM2A69lkei/rWWc3kwcwUbBDqXw8S
	QdvBdc4NCdthG0uBFU/zIGI5J1Mm9Y7DZOEEAxmMB3uLeAsL2spf0QvibifkOPSJWCfyly
	fJ/ckF9SV0Ob5fYDpnOl33Pi/4/cnm0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1794834116;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=8hoH9IiMClrhIYBlChM8QXxExxezUhUuWXttxdmFZd0=;
	b=nFTu75P6K5wj0EArRmSK26ssY0+ylZtWHcmtzvUewC22sXsLJqxnzJTnrOGcObUSEdlmWm
	jxJq6udjPa3EjwCw==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1794834116; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=8hoH9IiMClrhIYBlChM8QXxExxezUhUuWXttxdmFZd0=;
	b=eM0QG5J3Ar/OVjoYH6swhmg6PKuxZgUUR1IHIk43PrM2A69lkei/rWWc3kwcwUbBDqXw8S
	QdvBdc4NCdthG0uBFU/zIGI5J1Mm9Y7DZOEEAxmMB3uLeAsL2spf0QvibifkOPSJWCfyly
	fJ/ckF9SV0Ob5fYDpnOl33Pi/4/cnm0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1794834116;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=8hoH9IiMClrhIYBlChM8QXxExxezUhUuWXttxdmFZd0=;
	b=nFTu75P6K5wj0EArRmSK26ssY0+ylZtWHcmtzvUewC22sXsLJqxnzJTnrOGcObUSEdlmWm
	jxJq6udjPa3EjwCw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 4B39A1334C;
	Mon, 16 Nov 2026 13:01:56 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 8wKuCcT++mowDAAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 16 Nov 2026 13:01:56 +0000
Received: by quack.suse.cz (Postfix, from userid 1000)
	id D12C824DFF; Mon, 16 Nov 2026 14:01:51 +0100 (CET)
Date: Mon, 16 Nov 2026 14:01:51 +0100
From: Jan Kara <jack@suse.cz>
To: Carlos Maiolino <cem@kernel.org>
Cc: Chris Mason <mason@kernel.org>, tytso@mit.edu, david@fromorbit.com, 
	jack@suse.cz, djwong@kernel.org, josef@toxicpanda.com, hch@lst.de, 
	linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, 
	tz2294@columbia.edu, brauner@kernel.org
Subject: Re: [PATCH v9 05/14] fs: validate atomic writes after O_APPEND and
 limits
Message-ID: <m5dhonfzqplecjhldeaws2frc4dzemayru4itnudhdlwhkxld6@5ps7o7uspt7h>
References: <20261112214604.67875-1-mason@kernel.org>
 <20261112214604.67875-6-mason@kernel.org>
 <avrjDb576l8Eup5s@nidhogg.toxiclabs.cc>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <avrjDb576l8Eup5s@nidhogg.toxiclabs.cc>
X-Spamd-Result: default: False [-12.80 / 50.00];
	SUSE_INTERNAL_BYPASS(-9.00)[];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[13];
	MISSING_XM_UA(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[3];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	URIBL_BLOCKED(0.00)[suse.cz:email,suse.com:email,imap1.dmz-prg2.suse.org:helo];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCVD_TLS_LAST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,imap1.dmz-prg2.suse.org:helo,suse.cz:email]
X-Spam-Score: -12.80
X-Spam-Level: 
X-Spam-Flag: NO

On Mon 16-11-26 12:05:26, Carlos Maiolino wrote:
> On Thu, Nov 12, 2026 at 04:46:09PM -0500, Chris Mason wrote:
> > An RWF_ATOMIC write on XFS with reflink can expose stale disk contents
> > if O_APPEND or RLIMIT_FSIZE leaves it sector aligned but not block
> > aligned.
> > 
> > XFS and ext4 call generic_atomic_write_valid() on the range that the
> > caller passed. But generic_write_checks() changes the range later:
> > O_APPEND moves the position, and RLIMIT_FSIZE cuts the length. XFS can
> > then fill only a part of a new block, and still map the whole block into
> > the file:
> > 
> >     block size 4096, i_size 512, O_APPEND
> >     validated:        0 to 4095
> >     written:          512 to 4607
> >     new blocks:       0 to 8191
> >     stale below EOF:  0 to 511
> > 
> > The fix used here is to validate an atomic write in
> > generic_write_checks(), after its range is final, and to refuse one that
> > was cut. XFS no longer picks the path of an atomic write by the
> > alignment of the range that the caller passed.
> > 
> > Fixes: f096207d3276 ("xfs: Validate atomic writes")
> > Fixes: 43c696f9d094 ("ext4: Check for atomic writes support in write iter")
> > Signed-off-by: Chris Mason <mason@kernel.org>
> 
> FWIW, this is another patch that would normally go through Brauner's
> branch, so just in case once we get it settled...
> 
> Chris, Ted, Jan. Are you guys fine if I merge this patch through xfs's
> tree?

Yes. For the VFS and ext4 bits feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> 
> 
> > ---
> > 
> > Notes:
> >     v6->v9: no change
> > 
> >  fs/ext4/file.c    |  4 ----
> >  fs/read_write.c   | 13 +++++++++++++
> >  fs/xfs/xfs_file.c | 17 +++++++++++------
> >  3 files changed, 24 insertions(+), 10 deletions(-)
> > 
> > diff --git a/fs/ext4/file.c b/fs/ext4/file.c
> > index 50d3c92709c8..e301d4faf1c3 100644
> > --- a/fs/ext4/file.c
> > +++ b/fs/ext4/file.c
> > @@ -802,10 +802,6 @@ ext4_file_write_iter(struct kiocb *iocb, struct iov_iter *from)
> >  		if (len < EXT4_SB(inode->i_sb)->s_awu_min ||
> >  		    len > EXT4_SB(inode->i_sb)->s_awu_max)
> >  			return -EINVAL;
> > -
> > -		ret = generic_atomic_write_valid(iocb, from);
> > -		if (ret)
> > -			return ret;
> >  	}
> >  
> >  	if (iocb->ki_flags & IOCB_DIRECT)
> > diff --git a/fs/read_write.c b/fs/read_write.c
> > index 676728310899..1b34b7382619 100644
> > --- a/fs/read_write.c
> > +++ b/fs/read_write.c
> > @@ -1775,6 +1775,19 @@ ssize_t generic_write_checks(struct kiocb *iocb, struct iov_iter *from)
> >  	if (ret)
> >  		return ret;
> >  
> > +	/*
> > +	 * O_APPEND has moved the position and the file size limits have
> > +	 * shortened the write by now, so this is the range to validate.  An
> > +	 * atomic write is all or nothing, so refuse it if it got shorter.
> > +	 */
> > +	if (iocb->ki_flags & IOCB_ATOMIC) {
> > +		if (count != iov_iter_count(from))
> > +			return -EINVAL;
> > +		ret = generic_atomic_write_valid(iocb, from);
> > +		if (ret)
> > +			return ret;
> > +	}
> > +
> >  	iov_iter_truncate(from, count);
> >  	return iov_iter_count(from);
> >  }
> > diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> > index be1f775128d1..153f53f964b9 100644
> > --- a/fs/xfs/xfs_file.c
> > +++ b/fs/xfs/xfs_file.c
> > @@ -926,12 +926,21 @@ xfs_file_dio_write(
> >  	if ((iocb->ki_pos | count) & target->bt_logical_sectormask)
> >  		return -EINVAL;
> >  
> > +	/*
> > +	 * An atomic write is at least one block long, and generic_write_checks()
> > +	 * refuses it unless its final position is a multiple of its length.  So
> > +	 * there is no unaligned case to handle for it.
> > +	 */
> > +	if (iocb->ki_flags & IOCB_ATOMIC) {
> > +		if (xfs_is_zoned_inode(ip))
> > +			return xfs_file_dio_write_zoned(ip, iocb, from);
> > +		return xfs_file_dio_write_atomic(ip, iocb, from);
> > +	}
> > +
> >  	if ((iocb->ki_pos | count) & ip->i_mount->m_blockmask)
> >  		return xfs_file_dio_write_unaligned(ip, iocb, from);
> >  	if (xfs_is_zoned_inode(ip))
> >  		return xfs_file_dio_write_zoned(ip, iocb, from);
> > -	if (iocb->ki_flags & IOCB_ATOMIC)
> > -		return xfs_file_dio_write_atomic(ip, iocb, from);
> >  	return xfs_file_dio_write_aligned(ip, iocb, from,
> >  			&xfs_direct_write_iomap_ops, &xfs_dio_write_ops, NULL);
> >  }
> > @@ -1128,10 +1137,6 @@ xfs_file_write_iter(
> >  
> >  		if (ocount > xfs_get_atomic_write_max(ip))
> >  			return -EINVAL;
> > -
> > -		ret = generic_atomic_write_valid(iocb, from);
> > -		if (ret)
> > -			return ret;
> >  	}
> >  
> >  	if (IS_DAX(inode))
> > -- 
> > 2.55.0
> > 
> > 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

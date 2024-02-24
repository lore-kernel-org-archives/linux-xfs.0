Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 531713A29B
	for <linux-xfs@vger.kernel.org>; Sat, 24 Feb 2024 14:11:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708783867; cv=none; b=YbJACxfuXtMmTT+HLidzfbQdJTZRx6DbOkVWPxq8lJ7x+xyki1JuiNTFFBsz6NXudFGwpFI0VVdWjo7rLGZrPxLjUTWRoOXifs/BWjiyrkJOF9c6dKe+8L0aCBeDPMyzxoluC4AYQMwMjKcaRK87dd3BjsJWM5B8PwyMKgDvcJY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708783867; c=relaxed/simple;
	bh=wAQeGIpU/b8zq/c8phVMxTlln1DrdldGBZvQmeoDpLs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iuJJXUdz/8p0VcOtEqictAjbGtnxYEOEGjl5SGTa+f/j2E2NKRSx1YsL637DskWQJcF7Zvdf4T5LzBAIOwUM2npWAbTP1ekRtr0HmjGQvNDt4Gvbf0o/aw8QT1TNUgKoi3jOV1XLCF3UTbZsiQB2I80YuQEhtxwcA9al+I8gxxo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=RZzG7qP2; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="RZzG7qP2"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1708783864;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=AmvOSjy0MC5pHW1g/j3NOZPW4U2msOE708+NWPvQghI=;
	b=RZzG7qP2TQwk8W6aqNqT1QF0Da0aMI5t8JKM2p7ndUpGh4rQd2ruYQBWUc1zDUs5fnIPhy
	S3dkmm49uQvPWCnxlyKg3Ntkd36vI0q+nv1pr5aH6HtaCT6YM3JBvsu4rZ96PMs8omE/HT
	BYWqJXScBK3y0stAKKYrfOdz1Xg7fes=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-479-N2qq2qwLMGq7ryS2_BYpsA-1; Sat, 24 Feb 2024 09:11:01 -0500
X-MC-Unique: N2qq2qwLMGq7ryS2_BYpsA-1
Received: by mail-ed1-f72.google.com with SMTP id 4fb4d7f45d1cf-559555e38b0so1476803a12.3
        for <linux-xfs@vger.kernel.org>; Sat, 24 Feb 2024 06:11:00 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708783860; x=1709388660;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AmvOSjy0MC5pHW1g/j3NOZPW4U2msOE708+NWPvQghI=;
        b=eap/7Sbuep6DnTspiwnIQZw7nbs7HQCYacKX1S+f0JWv6l2402CKd2NdkJ98w/27gW
         lYaOel9e84ZKBd7TfS/Ux/gawEErBwi2whIbqN3t0SsARe7fL0Uu9fwIAlfRwf2nDIBc
         i3KXrEsR6QF+WKXBjuEeds5GQYmAfpKWsB7UXAaagTkkj0Zj4wAxZs3586fhcvEHMjUZ
         x9jRXr4IgAJe3p6PX5v2PdN4dVGrbCZvcXKnpnNvkgY+4JA0peAOOAIdGHd2MLaoJ6ho
         SCSCcLg9pSZV4iCXqO8nZlgUTvh97AfOrRKHMhyxzSHZIWLjcxiZE1R8MTUrETkPuU2X
         Jzrg==
X-Forwarded-Encrypted: i=1; AJvYcCWO/SQOfWVR4/63wHJ1WG+bNNc57lG0o8UYMkhdjzAUQcmsyeIOplf1ID/JD3jRYd85eGxmWyE2jqU/Av2vuD1pmqyRROc+kBki
X-Gm-Message-State: AOJu0YyD2HJZCtNF7RJI5jRCp9oTHz9bWWcxkrdahT2+LiguzV7nDiqI
	hYolBbIvGwdqQ/ngGdMp1dNDL9DFJrtDfQV0RXqWWUFJ8HCZmy6+xGIWeBcQV+CjZzfB1DKuxGf
	3E8lpwvy+ofMMz1dvdUfH5SDkc/xcwU321cYYakLj4LcOTchO/ZT2EcY7
X-Received: by 2002:aa7:d349:0:b0:565:be3f:bc4e with SMTP id m9-20020aa7d349000000b00565be3fbc4emr140216edr.29.1708783859901;
        Sat, 24 Feb 2024 06:10:59 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGew91maGa6l3f9rKld2WFHMZa748gpse/xrdGzF3S87LGuem4A2sqelzLeBZShQmbV+ViTJw==
X-Received: by 2002:aa7:d349:0:b0:565:be3f:bc4e with SMTP id m9-20020aa7d349000000b00565be3fbc4emr140209edr.29.1708783859588;
        Sat, 24 Feb 2024 06:10:59 -0800 (PST)
Received: from thinky ([109.183.6.197])
        by smtp.gmail.com with ESMTPSA id r26-20020aa7cb9a000000b00565b8f955b8sm209020edt.57.2024.02.24.06.10.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 24 Feb 2024 06:10:59 -0800 (PST)
Date: Sat, 24 Feb 2024 15:10:58 +0100
From: Andrey Albershteyn <aalbersh@redhat.com>
To: Eric Biggers <ebiggers@kernel.org>
Cc: fsverity@lists.linux.dev, linux-xfs@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, chandan.babu@oracle.com, djwong@kernel.org
Subject: Re: [PATCH v4 07/25] fsverity: support block-based Merkle tree
 caching
Message-ID: <brwo67ff3o3tvkswlgbjselabvhh5hbsagg47hiiogpltkrcr7@yff2orlvntvs>
References: <20240212165821.1901300-1-aalbersh@redhat.com>
 <20240212165821.1901300-8-aalbersh@redhat.com>
 <20240223052459.GC25631@sol.localdomain>
 <qojmht7l3lgx5hy7sqh5tru7u3uuowl5siszzcj3futgyqtbtv@pth44gm7ueog>
 <20240223180732.GC1112@sol.localdomain>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240223180732.GC1112@sol.localdomain>

On 2024-02-23 10:07:32, Eric Biggers wrote:
> On Fri, Feb 23, 2024 at 05:02:45PM +0100, Andrey Albershteyn wrote:
> > > > +void fsverity_drop_block(struct inode *inode,
> > > > +		struct fsverity_blockbuf *block)
> > > > +{
> > > > +	if (inode->i_sb->s_vop->drop_block)
> > > > +		inode->i_sb->s_vop->drop_block(block);
> > > > +	else {
> > > > +		struct page *page = (struct page *)block->context;
> > > > +
> > > > +		/* Merkle tree block size == PAGE_SIZE; */
> > > > +		if (block->verified)
> > > > +			SetPageChecked(page);
> > > > +
> > > > +		kunmap_local(block->kaddr);
> > > > +		put_page(page);
> > > > +	}
> > > > +}
> > > 
> > > I don't think this is the logical place for the call to SetPageChecked().
> > > verity_data_block() currently does:
> > > 
> > >         if (vi->hash_block_verified)
> > >                 set_bit(hblock_idx, vi->hash_block_verified);
> > >         else
> > >                 SetPageChecked(page);
> > > 
> > > You're proposing moving the SetPageChecked() to fsverity_drop_block().  Why?  We
> > > should try to do things in a consistent place.
> > > 
> > > Similarly, I don't see why is_hash_block_verified() shouldn't keep the
> > > PageChecked().
> > > 
> > > If we just keep PG_checked be get and set in the same places it currently is,
> > > then adding fsverity_blockbuf::verified wouldn't be necessary.
> > > 
> > > Maybe you intended to move the awareness of PG_checked out of fs/verity/ and
> > > into the filesystems?
> > 
> > yes
> > 
> > > Your change in how PG_checked is get and set is sort of a
> > > step towards that, but it doesn't complete it.  It doesn't make sense to leave
> > > in this half-finished state.
> > 
> > What do you think is missing? I didn't want to make too many changes
> > to fs which already use fs-verity and completely change the
> > interface, just to shift page handling stuff to middle layer
> > functions. So yeah kinda "step towards" only :)
> 
> In your patchset, PG_checked is get and set by fsverity_drop_block() and
> fsverity_read_merkle_tree_block(), which are located in fs/verity/ and called by
> other code in fs/verity/.  I don't see this as being a separate layer from the
> rest of fs/verity/.  If it was done by the individual filesystems (e.g.
> fs/ext4/) that would be different, but it's not.  I think keeping fs/verity/
> aware of PG_checked is the right call, and it's not necessary to do the half-way
> move that sort of moves it to a different place in the stack but not really.
> 
> - Eric
> 

I see, thanks! I will move back

-- 
- Andrey


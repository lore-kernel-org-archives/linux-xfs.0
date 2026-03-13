Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3322538B14E
	for <linux-xfs@vger.kernel.org>; Fri, 13 Mar 2026 11:17:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773400645; cv=none; b=jCm37eKQRjjn0YEm5z+fyo9k9ZUv5MmEPptmj8RQnRVaiDL/tqgR+B/grjJHy/5aEwMmeMo9mcgSzJs7P9zTMgMvHd94uE6Q4hoNujIa2XB3XNEMZSa5zH0uNQPTiEYTw+qyRGc/UbGLtJJ9FE6jUs8ewIt046xvzmu4rNLDJkA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773400645; c=relaxed/simple;
	bh=2ocLF+6gDlSJ0COpbZ4Q1YW8LyldVKS8d2Q/lZFZfic=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GdgzgX3UvKChGPZwBXPTfbOcrZAB/eFe6nd+C85xGelXRK6id4htElzqHaQKSGDxoIzUg1nGmVMzPV4XsRumHN4nzKEV7RiRyKyCbc6cJbhhVYedA8QEbNWSu6aQe/kmAFrs+CGMnaxLxgqQajCs96qPYQGaQ9WROgBnM/vEfRY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=UVzIQZKQ; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=UK3vPB4M; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UVzIQZKQ";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="UK3vPB4M"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1773400641;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=G3aAJby17/qDvpdgHW3BwLZTyLi3K99yUle4/tTAV/E=;
	b=UVzIQZKQ/MQXvfRrITd3YREFefC16rSlLaZjUXSRlmyZfDYBiWoIOcDDztBKOBKaqMdgk3
	Bd6NKGDFM84hZXGE2QZOvfmaPNfPnUxE39HXxaEVLDvaJZOZmFp+lpVQV3jMxpJYNIghWw
	I/gkRYzP/cqxMXlip5xUjbyMEM4+jXk=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-383-gHfdNRkfO4Gu4zA2tvyGXQ-1; Fri, 13 Mar 2026 07:17:20 -0400
X-MC-Unique: gHfdNRkfO4Gu4zA2tvyGXQ-1
X-Mimecast-MFC-AGG-ID: gHfdNRkfO4Gu4zA2tvyGXQ_1773400639
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-439fbfd93e8so1269790f8f.0
        for <linux-xfs@vger.kernel.org>; Fri, 13 Mar 2026 04:17:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1773400638; x=1774005438; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=G3aAJby17/qDvpdgHW3BwLZTyLi3K99yUle4/tTAV/E=;
        b=UK3vPB4MSDCHkPA4jY4bB4yUOPaA7qwwS1LXEuynBfO59zoai/l5X8o2xCWclGXV9g
         4smlqXR4kVAEJKriI1vdp3grxQvUKsV2of3/gf1PzJ27aS7trVLjTDcEitb0F2CgO2Yt
         J9xA0neDom/pRM5O0V3MZO/y5APXFxyJjq7zXfFo9X9JuGZ1yMVtRJEAI7AiSG4eBclz
         0vRL2PiokHB9CoCR1ecOeHpJAWdzUMQX03jiFgSyeMorFmcYq7l2K4q9A9LC+cQ46KND
         LMU6DKVZ6zW1K2U7I+KLgkC+dp+pEhcNz/IR0XTeFQzcac/qO14FXgQ5g/+47jbD7jur
         JDjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773400638; x=1774005438;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=G3aAJby17/qDvpdgHW3BwLZTyLi3K99yUle4/tTAV/E=;
        b=CAzQccsHsudyn+Q/HXZxl/FUkQtcTZ7AdBJaRozMHHQ+bG8gREhkFOsAX6ubhuQ8T/
         85azDn5ZWAC+zfNTGS9a4XE5gFWyyHS2zwyEvbmX4ukVLNFw0h3e/F3V2IiLtq2vDH0L
         4PzmMJ9GjDVNaywpyUvYQHxf+Eev+CEr/J/B9nO0/F7pzxvUu/aBGS9F1IDMX5GOV8k4
         V968VRogCQ6ISUrmNkqcpXst2v9es4yjoVUjqJtHs597POGbR/jb9FHWLQVhxaRYf+ef
         0UWbf7O9dV3hXlojTAocabLvJ6lkW5sZ6hR3TbqJelufJxczmcvw9pcKiw7l4lGQbiuD
         CvNw==
X-Forwarded-Encrypted: i=1; AJvYcCUfkG9eGVxzRgtO9WMyuOlGfsS6bbh2EFfinGoBhHLRZ7fNMV/6HNA4FtO7u4Mi3ug8/bUdR1MPDNE=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz2EW9dTYP08T1Z4GeIqhPYBSjffLAC+SFCbZ7yiwtFQqzhb6Mc
	oLxyBRzG0RTvi/NW1eMs4erSgWfp4cFb4R2YXXP/MberT9/nDtYsriJ+r9FK2slJT+Bb4M3sDrG
	VhL0Utc7gxM+AGi5WCwCZJmrHSYSn95R2xEy109qFgWIbKKVMJGt3Hblku4xKhUoGhBP+
X-Gm-Gg: ATEYQzyrGC9qo72R7Gs8bnIix/mLxDChc71rlcDY2n9qaBhhsIWrsqFSMLAYtD3GPoz
	3BIWottl/0LnS7VAU9C+iicaw9nPmPmCnNB3CM5ELg5IRqtYRSwO4CC3lwmbuyyo++Bs2nNoDR9
	a2mhtxbNNl8D04ziKtcIy1j/PmBZBpmSdvbdNJ86f+Yf9VYbD8Q9PyME/jhQSScz52b+qxnqmKr
	UhJcy/UT+sA1S5459IUposUlRGmpoZzyI9pC103JCicwhMiEJLMEzUJ9WqXg96LGPOl2u0p23FE
	opz8vUaASHpHgyqmpXlDOVpcF6Cl79pFV90r7aCIJusOzEKhTd9fzz9lxbGgd/IrBAGW5lFbeVo
	3M7M9Ms+3D8s=
X-Received: by 2002:a05:6000:2010:b0:439:ddc0:4bee with SMTP id ffacd0b85a97d-43a04d86228mr5317853f8f.16.1773400637592;
        Fri, 13 Mar 2026 04:17:17 -0700 (PDT)
X-Received: by 2002:a05:6000:2010:b0:439:ddc0:4bee with SMTP id ffacd0b85a97d-43a04d86228mr5317761f8f.16.1773400636834;
        Fri, 13 Mar 2026 04:17:16 -0700 (PDT)
Received: from thinky ([217.30.74.39])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43a03cfd18fsm8558495f8f.36.2026.03.13.04.17.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Mar 2026 04:17:16 -0700 (PDT)
Date: Fri, 13 Mar 2026 12:17:15 +0100
From: Andrey Albershteyn <aalbersh@redhat.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Andrey Albershteyn <aalbersh@kernel.org>, linux-xfs@vger.kernel.org, 
	fsverity@lists.linux.dev, linux-fsdevel@vger.kernel.org, ebiggers@kernel.org, hch@lst.de, 
	linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, 
	linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v4 19/25] xfs: remove unwritten extents after
 preallocations in fsverity metadata
Message-ID: <dz3va7indkh4to2pingopyndck737qvyxvlfomkqqothzj4pdk@wu26ba5stnf6>
References: <20260309192355.176980-1-aalbersh@kernel.org>
 <20260309192355.176980-20-aalbersh@kernel.org>
 <20260310012914.GG1105363@frogsfrogsfrogs>
 <ymisdrze3ohdnxa4inqfwp4riaz4qk5nmtil33adn5ukhngq7v@f3tcv3hbzobz>
 <20260312145250.GE6069@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260312145250.GE6069@frogsfrogsfrogs>

On 2026-03-12 07:52:50, Darrick J. Wong wrote:
> On Thu, Mar 12, 2026 at 02:50:57PM +0100, Andrey Albershteyn wrote:
> > On 2026-03-09 18:29:14, Darrick J. Wong wrote:
> > > > XFS preallocates spaces during writes. In normal I/O this space, if
> > > > unused, is removed by truncate. For files with fsverity, XFS does not
> > > > use truncate as fsverity metadata is stored past EOF.
> > > > 
> > > > After we're done with writing fsverity metadata iterate over extents in
> > > > that region and remove any unwritten ones. These would be preallocation
> > > > leftovers in the merkle tree holes and past fsverity descriptor.
> > > > 
> > > > Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
> > > > ---
> > 
> > > There's an upper limit on the number of blocks you can unmap/free in a
> > > single transaction.  Maybe move the xfs_trans_{alloc,commit} into the
> > > loop body?
> > > 
> > > Oh wait, you skip the written extents.  Ok, so maybe just roll it after
> > > you've done a bunmapi.
> > 
> > I see, I will add a rolling transaction. Btw, why skipping the
> > written extents let's us use rolling here?
> 
> Hrmm.  At first I thought: why can't xfs_fsverity_cancel_unwritten
> allocate (and commit) the transaction inside the loop body?  Then I
> thought "well, it's only conditionally unmapping things, and it's sort
> of a pain to allocate a transaction only then to find out if you
> actually want to run one".
> 
> OTOH there could be billions of extents in the data fork, so holding the
> ILOCK for that many transactions isn't a good thing because tr_write
> only preallocates space for a certain number of transaction rolls.
> fsverity already holds IOLOCK_EXCL so there can't be any other programs
> using the file.
> 
> So now I arrive back at "The transaction allocation and commit/cancel
> should be inside the loop body, since crashing midway through wouldn't
> result in user-visible changes to the file data".
> 
> > > Do you need to purge the cow fork too?
> > 
> > hmm, what case are you thinking about here? The fsverity is written
> > in past EOF region, I don't see how COW extent could be left there.
> > Can they somehow be left mapped for blocks past i_size?
> 
> I was talking about speculative cow fork preallocations below i_size.
> They'll eventually get purged by blockgc, but you could give the space
> back once you've committed enabling the fsverity file flag.

hmm, if they're purged by blockgc, then why to do it here? I'm
iterating and removing unwritten extents here only because
xfs_inode_free_eofblocks() will skip fsverity inodes, the check in
xfs_can_free_eofblocks():

	if (IS_VERITY(VFS_I(ip)))
		return false;

The skipping is done to not remove all the fsverity metadata
extents. With preallocations enabled there could be unwritten
extents left in the metadata.

Am I missing something?

-- 
- Andrey


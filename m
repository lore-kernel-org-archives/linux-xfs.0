Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7938119307F
	for <linux-xfs@vger.kernel.org>; Mon, 17 Jun 2024 09:34:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718616862; cv=none; b=sUl5RTsHUZP/zZ/S4GxG+wQItZnnfj6PcDTM5NFAAQlWg5gOFLzH+lpVFT0MKmfGeyBu67IfuaDlNo5eG+T4fRg+IL0X7POxf3xkiICUdT9ekLBgPjx9IVmL+ISy48Dxg5z8dNzIdjLTQjH+jXV9rs6LZ435oLyG0Vj5SYzQm18=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718616862; c=relaxed/simple;
	bh=GhvOab+mCRok04/yA9hiMIiPytkHb/9U93weDvXdevw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TdqnEGkbRjatubkS3UMK5CjMDqvnlhkzs+DDyx+wW0hqzDL8MoBXFfA+mbFtjOYoKdOWRD8aIcEgmfyWTQK+3M0bfT5moYOI4vtxYZeC+cJookz5h5flN3/tc/03BUrnDgODksq8NkQhXixFFcrMi1tfH6Lq54a4UL2e90MH6IE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=S1F1UKsM; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="S1F1UKsM"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1718616858;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=roSRF/l+UjSsOxWpFV+d4iz/3ho6cXj+v4kuJWoKNWI=;
	b=S1F1UKsMK3HlJdOWNiR55dVAIMWY1upY3p75PJz+3WHTGHizNN+HQZhWGTOzHCCrCw3aZd
	sfXKmn9XMUuZBRUBu0mPo38J0/vxB9kyB9jFjnW8FBU4NgEuNpaiy2nnm1EEzC7hn/3nSJ
	gSYZpBCtPdtjwjjvoVx6vjTQmsQo4Fs=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-80-0evKAn0XPKCelfP6xvODCA-1; Mon, 17 Jun 2024 05:34:17 -0400
X-MC-Unique: 0evKAn0XPKCelfP6xvODCA-1
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-421292df2adso25647445e9.3
        for <linux-xfs@vger.kernel.org>; Mon, 17 Jun 2024 02:34:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718616856; x=1719221656;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=roSRF/l+UjSsOxWpFV+d4iz/3ho6cXj+v4kuJWoKNWI=;
        b=ZLkUgYDe7KLlcJ6B5H4d7chM66mPsvMmPoLw25oMGswlqmDWl4UiSwu3lGOsJsynZO
         u4cIeNgviEpKZGBWI64vOROStep/m34Qjk0rYqQBVe/v8ckxNOHaICj+JTD0W/I3sb8Z
         NS9xSOWq6a4xcGoK47XeWzusqB8IMxIlUC4KSxFpYYnq7Oekm66lUCTrYiHmAvkgs3+v
         cZlqKxUlpCddj38zbZHJoHju5n7oYAWiGOwmZxH++AsCTcT3MQItQzABWJcDkaaWV17O
         EN1Lymb3nsRHUgN6HjOKbU7Uh20FC1WdqpQN5Wn5BCM/Ip3HPIicAPsPoXXwLQagtoNS
         th1A==
X-Forwarded-Encrypted: i=1; AJvYcCX+vQwE7aDIB+hXRbLLFa51xQyaXb+Mji254bJoh2O3iCNtXBO2UcD6E8Jt+hUS8FPMkoNY+Angb7d7q0sfFFnuS0XJs3HL9sb1
X-Gm-Message-State: AOJu0Yx36NZwxgo5Xk+4Bw8Fg4gvRAUQp/Pjv1eh9oAmnRez22J3mEcO
	XQO9O/oTC/beJsPNGAK/vEzKw8vGHmHKXxRYL9/1LYGzMQG2BJXgZoM5axNNKFkfJqvujNkGiLI
	SecpypXU06PGFdXGZQDISXu2t75Jph0VEM6ntyMH/hzZ4hWeAZ89qhIhn
X-Received: by 2002:a05:600c:4b23:b0:422:47a:15c8 with SMTP id 5b1f17b1804b1-42304820d71mr75071065e9.12.1718616855765;
        Mon, 17 Jun 2024 02:34:15 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IG1T8BzPKLN6V32qh0IOTwR3BvWw2RR4kRiN/3ni0sUSBYk+kKMtHY4PTXjTwDBDi9nWAHssQ==
X-Received: by 2002:a05:600c:4b23:b0:422:47a:15c8 with SMTP id 5b1f17b1804b1-42304820d71mr75070745e9.12.1718616855122;
        Mon, 17 Jun 2024 02:34:15 -0700 (PDT)
Received: from thinky ([109.183.6.197])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4246bddc59bsm17147185e9.5.2024.06.17.02.34.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Jun 2024 02:34:14 -0700 (PDT)
Date: Mon, 17 Jun 2024 11:34:13 +0200
From: Andrey Albershteyn <aalbersh@redhat.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Dave Chinner <david@fromorbit.com>, 
	Christoph Hellwig <hch@infradead.org>, Eric Biggers <ebiggers@kernel.org>, 
	xfs <linux-xfs@vger.kernel.org>, Sweet Tea Dorminy <sweettea-kernel@dorminy.me>, 
	Matthew Wilcox <willy@infradead.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, 
	fsverity@lists.linux.dev, Eric Sandeen <sandeen@redhat.com>, 
	Shirley Ma <shirley.ma@oracle.com>
Subject: Re: Handing xfs fsverity development back to you
Message-ID: <vg3n7rusjj2cnkdfm45bnsgf4jacts5elc2umbyxcfhcatmtvc@z7u64a5n4wc6>
References: <20240612190644.GA3271526@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240612190644.GA3271526@frogsfrogsfrogs>

On 2024-06-12 12:06:44, Darrick J. Wong wrote:
> Hi Andrey,
> 
> Yesterday during office hours I mentioned that I was going to hand the
> xfs fsverity patchset back to you once I managed to get a clean fstests
> run on my 6.10 tree.  I've finally gotten there, so I'm ready to
> transfer control of this series back to you:
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git/log/?h=fsverity_2024-06-12
> https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=fsverity_2024-06-12
> https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfstests-dev.git/log/?h=fsverity_2024-06-12
> 
> At this point, we have a mostly working implementation of fsverity
> that's still based on your original design of stuffing merkle data into
> special ATTR_VERITY extended attributes, and a lightweight buffer cache
> for merkle data that can track verified status.  No contiguously
> allocated bitmap required, etc.  At this point I've done all the design
> and coding work that I care to do, EXCEPT:
> 
> Unfortunately, the v5.6 review produced a major design question that has
> not been resolved, and that is the question of where to store the ondisk
> merkle data.  Someone (was it hch?) pointed out that if xfs were to
> store that fsverity data in some post-eof range of the file (ala
> ext4/f2fs) then the xfs fsverity port wouldn't need the large number of
> updates to fs/verity; and that a future xfs port to fscrypt could take
> advantage of the encryption without needing to figure out how to encrypt
> the verity xattrs.
> 
> On the other side of the fence, I'm guessing you and Dave are much more
> in favor of the xattr method since that was (and still is) the original
> design of the ondisk metadata.  I could be misremembering this, but I
> think willy isn't a fan of the post-eof pagecache use either.
> 
> I don't have the expertise to make this decision because I don't know
> enough (or anything) about cryptography to know just how difficult it
> actually would be to get fscrypt to encrypt merkle tree data that's not
> simply located in the posteof range of a file.  I'm aware that btrfs
> uses the pagecache for caching merkle data but stores that data
> elsewhere, and that they are contemplating an fscrypt implementation,
> which is why Sweet Tea is on the cc list.  Any thoughts?
> 
> (This is totally separate from fscrypt'ing regular xattrs.)
> 
> If it's easy to adapt fscrypt to encrypt fsverity data stored in xattrs
> then I think we can keep the current design of the patchset and try to
> merge it for 6.11.  If not, then I think the rest of you need to think
> hard about the tradeoffs and make a decision.  Either way, the depth of
> my knowledge about this decision is limited to thinking that I have a
> good enough idea about whom to cc.
> 
> Other notes about the branches I linked to:
> 
> I think it's safe to skip all the patches that mention disabling
> fsverity because that's likely DOA anyway.
> 
> Christoph also has a patch to convert the other fsverity implementations
> (btrfs/ext4/f2fs) to use the read/drop_merkle_tree_block interfaces:
> https://lore.kernel.org/linux-xfs/ZjMZnxgFZ_X6c9aB@infradead.org/
> 
> I'm not sure if it actually handles PageChecked for the case that the
> merkle tree block size != base page size.
> 
> If you prefer I can patchbomb the list with this v5.7 series.
> 
> --Darrick
> 

Thanks, I will look into fscrypt and if it's feasible to make it
work with xattrs in XFS or not.

-- 
- Andrey


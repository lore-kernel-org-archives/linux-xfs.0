Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCF083B8BB2
	for <linux-xfs@vger.kernel.org>; Tue, 20 Jan 2026 11:44:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768909467; cv=none; b=cOuXrkMXdGD7ZU7+1b741V2BFz32gZLACs4+6fiSAuL32iCKwr9x9tDuj5oOSqq2FyPgb0XXCU1iGVkj2eTZ6kg13zizkaAgtsNpvzK5Zfip+HzDwB2SAgsFOZwO4FYX6qCScVZuF8xB1yENeuXF/MhoeR8BgkkCVvWCeprIjgM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768909467; c=relaxed/simple;
	bh=TiiXYzQUqQAZpwrQs2Qyyc4v41VwLgKHuTM7jdyKi+Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TY/ahQcVMie3NLecUX0fXyyU9rWUwWvi2yv4lCxaB8MR9T0A4Fjix3CBstYit+KHVJriXKcpRUq09gViCbgWrVKDMV4HWuWGQXX/XU3YCtA3WZSGovtrj8FH9wF/3JSZNbO2slb06dFg00q0ZQcuvpmTS94gokrh5M5pKkmItSw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Kj03KAvz; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=Jlhb9xlL; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Kj03KAvz";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="Jlhb9xlL"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1768909464;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=VXQVvpxNNsGjingzXc9wZFJEzzxIAdMJuzmc45mqLJ4=;
	b=Kj03KAvzSwftwjUz/cwETMU66pUwRmPJRxUyPX4IxMQ1SnSJ1R7jqT4nwn6pXbmW2ZgQPf
	8I67/qddsRY+GXxsAyhf968qWb3Ouu4rH/tlxJA8OKQP3VuguU+75oQtKsxKE5y7OAifLP
	Z+t3miqekuQSoLnjcoM91dOhKWEeM58=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-629-waCrCArEP1mDJagJInZ2oA-1; Tue, 20 Jan 2026 06:44:22 -0500
X-MC-Unique: waCrCArEP1mDJagJInZ2oA-1
X-Mimecast-MFC-AGG-ID: waCrCArEP1mDJagJInZ2oA_1768909462
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-47ee8808ffbso39904945e9.2
        for <linux-xfs@vger.kernel.org>; Tue, 20 Jan 2026 03:44:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1768909462; x=1769514262; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=VXQVvpxNNsGjingzXc9wZFJEzzxIAdMJuzmc45mqLJ4=;
        b=Jlhb9xlLSsTj8aJQQ7cCewi2PV+zlb+TPM6H/HSJO9rSv3SNJ9zeUMEJhwLSsf17Oo
         hVavBbjxarROty7oHmlmdahE6Vpf+IgFmoKqD43GFNBqZBWZEt3jzrtYBQVyr/i0+oRF
         YD56el9nyAb8+5nukkqpRXaw+t1VgiEytE7kKVnpgZjwr3PPRb/IBejOX4xXNILTISVP
         AM/mMtF/J9MP9Bx4fwFhe7idzyX3Sg67l+5DTQfDzI8XsaQ0q9LOITgZanoU7MR0CiQ2
         t4cmfmAvg9PTXZsSKM4H0yQ02CeiFYmxY9GUbvY+C4RBuoXgwMX0H008aKaSVhyW51Ez
         5NHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768909462; x=1769514262;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VXQVvpxNNsGjingzXc9wZFJEzzxIAdMJuzmc45mqLJ4=;
        b=qs0g8Fa9DzExogW1oXuzf3aIlycJzAh0PEkEzaMASJYroCmzAeQvBixPSpTRdPbtTb
         CFHfvXhMPZRzsKjfbEprYBw83UmUOo0dryGILV6IZ4HRYwyH2Q2C4L71XKkwjrFmDljV
         +SHH1V8y6vTz6A5EdoGJ9mvr7JH4iTBVQiXoW/lyRIA354Es7A7MjF9udoVIarqo/E16
         9nMHKNwFOTtSx2jKfOEsiyeTMG9DF3SWArHHUJu/mxcaoX+ip8f77CsKpQcfxhOd//9h
         w09uSWOFiWK3C2f2A3uSyhNi4gHLcUJhrnNE4UTFtggNN+dmmLkOqYmhhM7sjMAsNEDf
         4dQw==
X-Forwarded-Encrypted: i=1; AJvYcCWrGkoF2Wm2d8D3brLEdUgWWiTYHguRvRyRBOqP1V9w/dR2uz/H+Hwcrm/mQ64MLl9a1cL1MZMR9r4=@vger.kernel.org
X-Gm-Message-State: AOJu0YzrrlCxvs02Rq1Zqna6ADNfmJRuVipLWQCJ+J1vJSasV76GscjF
	uvdaOLSNROQ9rczwPU2v6JvqjfaGJxojVOvK1yhj/uqal5K0K1ydbxyFx11Uod+xf1MfHvcefDY
	OH7OD1rikGhzAyIvawTccz5JTug7d5BjKoAmhg6mWz8yvGQXNK8BDF7odUBuv
X-Gm-Gg: AY/fxX60y0KSJukZszuuaJvdqNRYijWdaPcqP+/ZPb/sb/tgWNn1sRGTYVfhJ3NnZmw
	XZPsSWlOH2kqXYrPZFnKs1QQEZUxxKAOrUd167U5dSAHjEWM8eRUmmDe84Tb3B+ylS0hRWlzyFR
	Kkty5ADDsUhxc10m7u7r8nqe+obNfgVxYTEnuFWWDL7jIA4BnvSbj5aBRee3Q6RddRbyxF2G44F
	NI6N5X9xhBX5s+tZQ5z7yvnRtI5tBDPkt9p6FTJTO+eYFidkiFpmAT/t1/NlfnZvbdYqAI8gwc7
	e7C4juc//1Or/DLyvkWqLvOrSfXN1nGVLT2qGoJqzDIH0/GdzZyARg1FBs4ZiRjNyAOOwO7i2Hg
	=
X-Received: by 2002:a05:600c:4448:b0:47e:e20e:bbb4 with SMTP id 5b1f17b1804b1-4801e345c8amr179356665e9.26.1768909461628;
        Tue, 20 Jan 2026 03:44:21 -0800 (PST)
X-Received: by 2002:a05:600c:4448:b0:47e:e20e:bbb4 with SMTP id 5b1f17b1804b1-4801e345c8amr179356335e9.26.1768909461124;
        Tue, 20 Jan 2026 03:44:21 -0800 (PST)
Received: from thinky ([217.30.74.39])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47f42907141sm300491595e9.9.2026.01.20.03.44.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Jan 2026 03:44:20 -0800 (PST)
Date: Tue, 20 Jan 2026 12:44:19 +0100
From: Andrey Albershteyn <aalbersh@redhat.com>
To: Christoph Hellwig <hch@lst.de>
Cc: "Darrick J. Wong" <djwong@kernel.org>, 
	Eric Biggers <ebiggers@kernel.org>, Matthew Wilcox <willy@infradead.org>, fsverity@lists.linux.dev, 
	linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, aalbersh@kernel.org, 
	david@fromorbit.com, tytso@mit.edu, linux-ext4@vger.kernel.org, jaegeuk@kernel.org, 
	chao@kernel.org, linux-f2fs-devel@lists.sourceforge.net
Subject: Re: fsverity metadata offset, was: Re: [PATCH v2 0/23] fs-verity
 support for XFS with post EOF merkle tree
Message-ID: <5tse47xskuaofuworccgwhyftyymx5xj3mc6opwz7nfxa225u6@uvbk4gc2rktd>
References: <aWZ0nJNVTnyuFTmM@casper.infradead.org>
 <op5poqkjoachiv2qfwizunoeg7h6w5x2rxdvbs4vhryr3aywbt@cul2yevayijl>
 <aWci_1Uu5XndYNkG@casper.infradead.org>
 <20260114061536.GG15551@frogsfrogsfrogs>
 <5z5r6jizgxqz5axvzwbdmtkadehgdf7semqy2oxsfytmzzu6ik@zfvhexcp3fz2>
 <6r24wj3o3gctl3vz4n3tdrfjx5ftkybdjmmye2hejdcdl6qseh@c2yvpd5d4ocf>
 <20260119063349.GA643@lst.de>
 <20260119193242.GB13800@sol>
 <20260119195816.GA15583@frogsfrogsfrogs>
 <20260120073218.GA6757@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260120073218.GA6757@lst.de>

On 2026-01-20 08:32:18, Christoph Hellwig wrote:
> On Mon, Jan 19, 2026 at 11:58:16AM -0800, Darrick J. Wong wrote:
> > > >  a) not all architectures are reasonable.  As Darrick pointed out
> > > >     hexagon seems to support page size up to 1MiB.  While I don't know
> > > >     if they exist in real life, powerpc supports up to 256kiB pages,
> > > >     and I know they are used for real in various embedded settings
> > 
> > They *did* way back in the day, I worked with some seekrit PPC440s early
> > in my career.  I don't know that any of them still exist, but the code
> > is still there...
> 
> Sorry, I meant I don't really know how real the hexagon large page
> sizes are.  I know about the ppcs one personally, too.
> 
> > > If we do need to fix this, there are a couple things we could consider
> > > doing without changing the on-disk format in ext4 or f2fs: putting the
> > > data in the page cache at a different offset than it exists on-disk, or
> > > using "small" pages for EOF specifically.
> > 
> > I'd leave the ondisk offset as-is, but change the pagecache offset to
> > roundup(i_size_read(), mapping_max_folio_size_supported()) just to keep
> > file data and fsverity metadata completely separate.
> 
> Can we find a way to do that in common code and make ext4 and f2fs do
> the same?

hmm I don't see what else we could do except providing common offset
and then use it to map blocks

loff_t fsverity_metadata_offset(struct inode *inode)
{
	return roundup(i_size_read(), mapping_max_folio_size_supported());
}

-- 
- Andrey


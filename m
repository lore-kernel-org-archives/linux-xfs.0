Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD2B826CE2A
	for <linux-xfs@vger.kernel.org>; Mon, 11 Aug 2025 19:06:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754939169; cv=none; b=QNga7xXLd865LKeuDwf5NaLIjmjquIyP6yHDMs3A7pnXjNja9tnpZoBqxKBI3CtDQ5nOzGXOyd45JQ2RnuDjkJ2dd5Lcl50vYA/K4dPAj5UMG7AWqbfKWWw8UZohMKrP74mezHgXwD6N63d9f7+u7h9bS5l7S1OR9EWvxpZCoXw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754939169; c=relaxed/simple;
	bh=1Eh6AfaqADOLJGJXwjA9U3lQXOkdRiv6lgOQOZnuybo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kSwjncfV7QDz8i/LlcB/qvDJJlX0nAoQ/p0u++Oo4tSGNOrY0cotDmLO6bwjve2AmDvzi78qEsVrhfjFcTRNzK4C32rBEQilyDEyjfh9+5WfhQQ+4++CQMwcz5tXA4HQSjM1BoYOtmN6Y86dSk4cL/QnO/zL9N6qUdMz+abhfls=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=a6bs1QgU; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="a6bs1QgU"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1754939166;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=j0jNbqiZoXF2tqZs49Auc8aumYER/PfldpxEEm7lIrE=;
	b=a6bs1QgUJOGhLYP+nV0MKTprywP6bOh86CXr6+/zdsr/YdjPIjyTmrdv0sLKofvSGPTv95
	sopZQbCjGQtp6uDSso93R8Awokmtkvmy8JlvD+DLPZE6A1uRznTX9HcxreJfikZPq0tTLj
	ffBEk4Ir7zaGQ27li9yvbyYpBc7kdmQ=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-137-6idz48gmMJqC_97Z51_ygw-1; Mon, 11 Aug 2025 15:06:05 -0400
X-MC-Unique: 6idz48gmMJqC_97Z51_ygw-1
X-Mimecast-MFC-AGG-ID: 6idz48gmMJqC_97Z51_ygw_1754939164
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-3b79629bd88so2019549f8f.0
        for <linux-xfs@vger.kernel.org>; Mon, 11 Aug 2025 12:06:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754939164; x=1755543964;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=j0jNbqiZoXF2tqZs49Auc8aumYER/PfldpxEEm7lIrE=;
        b=eqFmQ3Q76RciZ5w7vocgoFxP4zyH0/sf79cFQ6teXXBEz2tF7SdW/O2ehIAor+Kucc
         G2Da3Wud3l2RxhBdcqErXfpltrA5za/kXN+mORNcXV6+Ug6ZrLkgxgKaROprkkB8JUru
         X7E+sCDy1So7oS6EOXlvm5c6JjptktR6LMzShWu3+lc2UuqMZ/rl7gwogCmbPJZs59gR
         hROm0Beq4TWsxsuVKw+dUmrSO0Kd3CTYLqv2vinnunQSVQbppENVculsiYpq/Q/nGOLC
         swqBepKVa2a4mU8I8G+mrasYch9Lb4ouDSUzv5axQ4DhrOeo9f0SCIKp9+7uhO6bQh3t
         AgtQ==
X-Forwarded-Encrypted: i=1; AJvYcCVuuxesDJto8cBgtED/ooX1W6LHeYe8NLpWw6rDGmngKBHwR9kixtN6tZL/DH38UyQM5LhRNQqyPbM=@vger.kernel.org
X-Gm-Message-State: AOJu0YyFPbucinSRv7XnsF3kDhQjrepKArj3j9r9hV7nM1VufvowyM2L
	xpn4xXVfYWmoDzrJoiSkkQTwAsH4ZlHPfhv8dEbRO6HuXNR8ddVQg7GeBY93ZlooEvOMQeXpknR
	6HdsgX7eN/ueE778KbHn0zwe85CLxlef7ueggAzt3DJsFkpeNtTjmvScKg7D/
X-Gm-Gg: ASbGncuunI0p2IZz2aEvreBzC+b8IVv55bQWwFknAEqq0ju2OeRZJO0OFw7Wq6XIhLL
	tPxJs8ISG73pWq6n3N+LEWxqrUO7n0c0FonYaChMdQ/uScHVg4qNOjwZUpVXrzCRqXd6xtzt9aC
	+4XBG0UfvfnBkl/v8itD3phw5HMsSpCYOAGDYVKfWR7HX7PICtPX/nDlcBLEH8xdukDxL0sTc5w
	mTPnaHH/aWY5EXb5oOSBt9QBVdvoENRt5DVJNa7k3g3SQWLZYNPQuuTZBpsHTongfagw4Sz3iJw
	laQqnjisKAM60EVSao+vcozEg0YgB1iVmykzFNJxx27Q3FWyXzyq9KxLm1c=
X-Received: by 2002:a05:6000:26cd:b0:3b7:6d94:a032 with SMTP id ffacd0b85a97d-3b910fdb7b4mr751817f8f.3.1754939163927;
        Mon, 11 Aug 2025 12:06:03 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHvt+eTJyu4t855O5qiCAOPraEsgDNT9X12Nh+utFT63/nKwS5zbJvlreALiUXMuzbjfYxWJA==
X-Received: by 2002:a05:6000:26cd:b0:3b7:6d94:a032 with SMTP id ffacd0b85a97d-3b910fdb7b4mr751800f8f.3.1754939163533;
        Mon, 11 Aug 2025 12:06:03 -0700 (PDT)
Received: from thinky (ip-217-030-074-039.aim-net.cz. [217.30.74.39])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b79c3c51e2sm40405921f8f.32.2025.08.11.12.06.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Aug 2025 12:06:03 -0700 (PDT)
Date: Mon, 11 Aug 2025 21:06:02 +0200
From: Andrey Albershteyn <aalbersh@redhat.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, fsverity@lists.linux.dev, 
	linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org, david@fromorbit.com, 
	ebiggers@kernel.org
Subject: Re: [PATCH RFC 12/29] fsverity: expose merkle tree geometry to
 callers
Message-ID: <smswj23kbrrku7q4spkqyfudzynbyh6cgi5ro5vrmo2hin7q22@5ege2lpzd2wh>
References: <20250728-fsverity-v1-0-9e5443af0e34@kernel.org>
 <20250728-fsverity-v1-12-9e5443af0e34@kernel.org>
 <20250811114813.GC8969@lst.de>
 <20250811153822.GK7965@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250811153822.GK7965@frogsfrogsfrogs>

On 2025-08-11 08:38:22, Darrick J. Wong wrote:
> On Mon, Aug 11, 2025 at 01:48:13PM +0200, Christoph Hellwig wrote:
> > On Mon, Jul 28, 2025 at 10:30:16PM +0200, Andrey Albershteyn wrote:
> > > From: "Darrick J. Wong" <djwong@kernel.org>
> > > 
> > > Create a function that will return selected information about the
> > > geometry of the merkle tree.  Online fsck for XFS will need this piece
> > > to perform basic checks of the merkle tree.
> > 
> > Just curious, why does xfs need this, but the existing file systems
> > don't?  That would be some good background information for the commit
> > message.
> 
> Hrmmm... the last time I sent this RFC, online fsck used it to check the
> validity of the merkle tree xattrs.
> 
> I think you could also use it to locate the merkle tree at the highest
> possible offset in the data fork, though IIRC Andrey decided to pin it
> at 1<<53.

I also use it in a few places to get tree_size which used to adjust
the read size (xfs_fsverity_adjust_read and
iomap_fsverity_tree_end_align).

> 
> (I think ext4 just opencodes the logic everywhere...)
> 
> > > +	if (!IS_VERITY(inode))
> > > +		return -ENODATA;
> > > +
> > > +	error = ensure_verity_info(inode);
> > > +	if (error)
> > > +		return error;
> > > +
> > > +	vi = inode->i_verity_info;
> > 
> > Wouldn't it be a better interface to return the verity_ino from
> > ensure_verity_info (NULL for !IS_VERITY, ERR_PTR for real error)
> > and then just look at the fields directly?
> 
> They're private to fsverity_private.h.
> 
> --D
> 

-- 
- Andrey


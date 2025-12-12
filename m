Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32AFE30BB80
	for <linux-xfs@vger.kernel.org>; Fri, 12 Dec 2025 08:10:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765527002; cv=none; b=gLlk7t+q1Hs23l3AuG8zm77nto/xfHkjs7SYntxrqYBhj4h+gMM82Qr3dpMy4ZmwqXgHRlZNRkqBnQVRjaS8vhsDTqCYTJ86ROv6Zf8BzfYe10GAgoN+MnQ8RttA3/2k9yVeDBH2Im5bkBno9Rb0q+LRzAYtXx+eg5+A2zp4MJM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765527002; c=relaxed/simple;
	bh=hZdSfrK9AXbbgPtPvtw6wVb32S06ZxplLFrSJ8FZ/yA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IApgZa0og2rCf/0M4g7gYo0XMbobmam/PN9TBnnULJ36dEUgYLkClwENchDkobG8GMOYVgwW4qnoJr8V3GphWdfig/Mo0Vbjo3cr2VWNhQrzrKrDmrooxb/Zl0S3rjAVNBLnaGVLlfb3kiQcc2RW/+eD/24YQ/fQrwvC0nzijJE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Dt8i+GqZ; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Dt8i+GqZ"
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-4779aa4f928so10692735e9.1
        for <linux-xfs@vger.kernel.org>; Fri, 12 Dec 2025 00:10:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765526999; x=1766131799; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Wg5bldFK1KkaVj/IcuiUAaKUXmLUzq8e0bEvKi0UcSo=;
        b=Dt8i+GqZt8BVIf3PE+UuNKUIbo143w+/nWUlOy1SIswVQYa/cI1q+FbNfr5fMvqcmM
         7h0iBHbCyBfqSUaZOchDwNw83TxSo64VSXIzFHt/plYE0q4jAKvBfN7DLXC1saIVkPkL
         uQsdwDvVHqNav+WWJ82x2BSZ1Wrwlu+Bsn+oL8TkjB0/cFYkAw8eMObCwfJv/T0UqJd4
         zOa/+1N82RlCsEXQJ4kerdtrxeM6EJPif3fouXKd0S6uqfGTbN0iW89lXy4BYhlaXae2
         eMn8c8ZDr9LRDjvCCbtiQHPQWtQkFaSbJ4/XQphoTp1/WpwjjtzOx0naZ/IMfW8B1Q7K
         hQiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765526999; x=1766131799;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Wg5bldFK1KkaVj/IcuiUAaKUXmLUzq8e0bEvKi0UcSo=;
        b=Lv9furUEglkJFcAD+zpxkbAyvjpJ3rqz+PeyM/U+FcDTnx47uDCBPzu+I/JgVbdNVV
         kQ3nGT0nimKpK9I5PRJVb49dnxJXlfIIo4gUt4dVS0LlvRGpCb8ISUs8Jp+44KaCL1Ps
         1msO1tSqcMHLj9VYzb8XxHbzi8JrGRU6cwPbLvg9n5qNJ+htIxWUm54stdfIdFz0Tkg/
         7CQpNa3psB6+l2mjTbdMa/gB11Za+ogCfnMKEvv5DuWzPW9s30hE5esiGJXj5Jxxl0Wu
         7kxCqNXQcblHX4MJ4wcFcqm41X6OBKbQSvfTat1FhWoC4HAUW9qk5lCX+1j1oXT98TXN
         TT8g==
X-Gm-Message-State: AOJu0YwRE/pkvdWXdRmBAk+AGFlwvDzgeAlC/nFgFntvZleUHxevy6iu
	W6MTKC8F1T12nJRMYB+aXHyB3MHQF4IL5ivck17O2WMZXeeFscuzNd8s
X-Gm-Gg: AY/fxX5MwQZuCXbRyhHXLD7els/EoRPex+fOA8zKbsbU1KWTxQZh2JqgZpLyeI1GlIX
	8j9kOUVKZttrorP/tPiT1nChEfT7234st5KGtuCJPbWJH8I1snfN6FNoU0xFmez1muJlp0UJX9h
	7d7d93A1X2R//4UVt/ByZgR8vx5ZwCo/N2pblcdE3FtXxjXDsmHJxop4xrPDK/G9mhb5U6UtQi9
	5hvORwm2ifRHEcNXAcQg8J3xTdZastNsFW2VaHdFD1SqPxcVADC88FSOWTCRZ9XPSInwi6Q85jz
	BO7QJMNsvCoBo1rKlNsqW25VbOMkNWEXkL4T56uEI7V1VbB2CHLtGdLW5zCGO8AIuYsVveptrSx
	NesVSlCzzWBn6s2JXUIuUFHc3Rpk0UNhbDWnP1V5Q7MrzsVH1cIlHYjaAtwYHEz2blAcsBf4Rob
	2fxyU=
X-Google-Smtp-Source: AGHT+IHM7xZVeT2kI16VoEtez1d6+U1sdIml9YLwFUqbA+WRJ+9foC3D/OvRwu88ncg4eals5nbHvw==
X-Received: by 2002:a05:600c:3486:b0:46e:4a30:2b0f with SMTP id 5b1f17b1804b1-47a8f90c46dmr11629395e9.29.1765526999223;
        Fri, 12 Dec 2025 00:09:59 -0800 (PST)
Received: from f13 ([2a01:e11:3:1ff0:dd42:7144:9aa4:2bfc])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47a8f737ed8sm7175045e9.8.2025.12.12.00.09.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Dec 2025 00:09:58 -0800 (PST)
Date: Fri, 12 Dec 2025 09:09:56 +0100
From: Luca Di Maio <luca.dimaio1@gmail.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org, dimitri.ledkov@chainguard.dev, 
	smoser@chainguard.dev, djwong@kernel.org
Subject: Re: [PATCH v1] xfs: test reproducible builds
Message-ID: <hxcrjuiglg4qjn4qzgnwdtxpcv6v47rpjrkxaxhmanhxvvwzpx@rz4ytlnsjlcm>
References: <20251211172531.334474-1-luca.dimaio1@gmail.com>
 <aTun4Qs_X1NpNoij@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aTun4Qs_X1NpNoij@infradead.org>

On Thu, Dec 11, 2025 at 09:28:01PM -0800, Christoph Hellwig wrote:
> On Thu, Dec 11, 2025 at 06:25:31PM +0100, Luca Di Maio wrote:
> > With the addition of the `-p` populate option, SOURCE_DATE_EPOCH and
> > DETERMINISTIC_SEED support, it is possible to create fully reproducible
> > pre-populated filesystems. We should test them here.
> 
> Cool, thanks a lot!
> 
> > +#
> > +# parent pointer inject test
> > +#
> 
> I don't think that is correct :)
>

Copied over from 640 :) Will fix this 

> > +. ./common/preamble
> > +_begin_fstest auto quick parent
> 
> Same for the parent here.  Instead of parent mkfs is a good group here.

Ack

> > +
> > +# get standard environment, filters and checks
> 
> This is kinda redundand.

Ack

> > +IMG_SIZE="512M"
> > +IMG_FILE="$TEST_DIR/xfs_reproducible_test.img"
> > +PROTO_DIR="$(dirname "$0")"
> 
> So this is basically packing up tests/generic/ in xfstests
> directory.  Is that the best choice?  It won't really have non-regular
> files, so the exercise might be a bit limited vs creating a directory
> in $TEST_DIR and adding all file types there.

Ack

> > +	# - DETERMINISTIC_SEED: uses fixed seed (0x53454544) instead of getrandom()
> 
> overly long line.

Ack

> > +# Compute hash of the image file
> > +_hash_image()
> > +{
> > +	md5sum "$1" | awk '{print $1}'
> 
> md5sum is pretty outdated.  But we're using it in all kinds of other
> places in xfstests, so I think for now this is the right thing to use
> here.  Eventually we should switch everything over to a more modern
> checksum.

Will move to sha256sum

Thanks for the review
L.

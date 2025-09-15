Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5376F2ED174
	for <linux-xfs@vger.kernel.org>; Mon, 15 Sep 2025 09:12:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757927531; cv=none; b=eZkBJyj1NYG6xu0h0ZrjxHKthS3Qdqh2nVbbaQ46FlV3WUPXHEhS0qROMI/RVxtkMBmvpgqOKTCBKpR7g3gHE/uUC30GISLlENH8dmcPHydzBBAYAZVv6SqlQABJ3VCfEPMu3G0Ht0KHK6MoIkh7hbH5F+fRVNpAp2vxUpE23oI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757927531; c=relaxed/simple;
	bh=YMyUO4ZSxSVOsCD3A/Ao02x8ck9F7ZcDeav94TcyBQs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E7JkydBgPzbRCQLxAf+BPsIJFTzIRbc5wetcSyCP4hjXWGMFNO8SKNdjeBH0e2w4LHm5JDCjpYcTAwC2JJCwmFcAF0WLxJpfATLZDJFAOLNzE24SqiDevHWDeWZJD2q24XlcUg0R46d3V/i4O1dYmXxj+tqiax2ORXw73AwruCE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HyC8Qm9t; arc=none smtp.client-ip=209.85.216.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HyC8Qm9t"
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-32e715cbad3so482639a91.3
        for <linux-xfs@vger.kernel.org>; Mon, 15 Sep 2025 02:12:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757927530; x=1758532330; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Z912WmA+67ALWSaIKEWQEm3fb/lfEWHjZZbHUaxsCYg=;
        b=HyC8Qm9tNP270pXki8zd3sjk8GmeiJx5fivPGSky/i4Vj5T8ZcS3qIa6w364xsGVvb
         9KHCrRMplCGsoL+J9PtwD8FmyfICubAqNeQ2azLbWSsen/Mx7sHPZO4FebC4hk18QkCG
         vq6Kn7nnEhdrXwU9eXHrdJhiwhuLofb/tF9HZM+8Pq1OiBvXN8MsvMHRbOBNI8e0dU/7
         oBS6ZDyNTJ14gqlGTl/W2FBLQgbBDzi9UzLjoFIjb1AXxwwws6klcfeAXYBK4nsnyufs
         JNNl7wrbe3WqmoR2r706u+k6tisI5qMNNwnnovD50vvjeObplqVB0zClP7YJ5euqyVMs
         3mFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757927530; x=1758532330;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Z912WmA+67ALWSaIKEWQEm3fb/lfEWHjZZbHUaxsCYg=;
        b=aUlKZOpKik94Fg/D5WSzLQLvkP9BxVH8d2u2frTd6xBzzomC1/Tx9DI6JcusapCTtw
         mVMXtfCFnWkGdONObuLKu9Q4wJKaBwU1Epd6MV/gx/UElYcRiEUC+E5PNCXI2ydw9H61
         QVuvAE0QxEzCm56rmVyAxRDkkpKEPQBWBrh3vr2yT3p+jMg7KDMYrdm4aniqtAIPrnby
         ECsmMseAPvHTZAQnQ+cL0JDh7GPvZPz5KEGd/PRw4SDBtKroZHBGJnn9KJlvifHw8RBE
         Pl65w7lJPYCeHICaJmxw1puqKa2J5eg/wNKywTQOS9aNVGkjLRipDqtxcUAmb80hAId5
         0oIg==
X-Forwarded-Encrypted: i=1; AJvYcCW5MJMpDJxCLPL6uhUexTocT3DdeKewPzT9y5TWlTI2FEIU4GQGE2cRPq1si7Hx172D5Tl4DLgalYw=@vger.kernel.org
X-Gm-Message-State: AOJu0YxO6fofN9mMSv1mv78VmUO5SvC5mg6sQJI+rpKGLWD+W/tfINl/
	rxP5EjVSmPo6RKqjKCouQGzZUgY1FstFApO98v/OohdGYFFdko8AMwOW
X-Gm-Gg: ASbGnctnLMFZ9qAlBf6KHflEassLxrPvQ+nq9an0Yg7Kh5kfb5AGIcyMDZFbkUGIqo3
	BYnifLjgQKf596bPVM/9FZu5EUElmsCmXZzo3GPSwyN04Lm/VYZPqEVRgoxneIISE8a+++kw0Fx
	F6utQ+ys4/iRBs6TLHUaiFMzJeSdl96EnqGC81DAP88C/hXuTs/atoY9+kaiILbHZOIogqpv2Bz
	jOF9t983VaomPvritmCxz0LCShuACr6tda3WhfQozLwEhrzdwtIaBR1DDRJSdBluKazMFI9bTGz
	9jO6P+NF8jziD4gfzRYIiqgNSEg0JGPhr3CKA4dAcJZeA0dXIwfYya+oFzPbmGceaRkqbfd/OVt
	kpIRf0TUyobKhTn0RklTi855P2X0bX8kaDw==
X-Google-Smtp-Source: AGHT+IHUHoRnBUAizNQ0Y7bS8vqoAmmxVHF9oFrvfp8wcyILr5tPIdrCluwCWQp30ooP5fOFV+uolA==
X-Received: by 2002:a17:90b:5110:b0:32e:4194:52a with SMTP id 98e67ed59e1d1-32e41940830mr4235639a91.9.1757927529654;
        Mon, 15 Sep 2025 02:12:09 -0700 (PDT)
Received: from VM-16-24-fedora.. ([43.153.32.141])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-32e0f101943sm6901264a91.1.2025.09.15.02.12.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Sep 2025 02:12:09 -0700 (PDT)
From: Jinliang Zheng <alexjlzheng@gmail.com>
X-Google-Original-From: Jinliang Zheng <alexjlzheng@tencent.com>
To: kernel@pankajraghav.com
Cc: alexjlzheng@gmail.com,
	alexjlzheng@tencent.com,
	brauner@kernel.org,
	djwong@kernel.org,
	hch@infradead.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	yi.zhang@huawei.com
Subject: Re: [PATCH 1/4] iomap: make sure iomap_adjust_read_range() are aligned with block_size
Date: Mon, 15 Sep 2025 17:12:07 +0800
Message-ID: <20250915091207.4094376-1-alexjlzheng@tencent.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <eyyshgzsxupyen6ms3izkh45ydh3ekxycpk5p4dbets6mpyhch@q4db2ayr4g3r>
References: <eyyshgzsxupyen6ms3izkh45ydh3ekxycpk5p4dbets6mpyhch@q4db2ayr4g3r>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Mon, 15 Sep 2025 10:54:00 +0200, kernel@pankajraghav.com wrote:
> On Sun, Sep 14, 2025 at 08:40:06PM +0800, Jinliang Zheng wrote:
> > On Sun, 14 Sep 2025 13:45:16 +0200, kernel@pankajraghav.com wrote:
> > > On Sat, Sep 14, 2025 at 11:37:15AM +0800, alexjlzheng@gmail.com wrote:
> > > > From: Jinliang Zheng <alexjlzheng@tencent.com>
> > > > 
> > > > iomap_folio_state marks the uptodate state in units of block_size, so
> > > > it is better to check that pos and length are aligned with block_size.
> > > > 
> > > > Signed-off-by: Jinliang Zheng <alexjlzheng@tencent.com>
> > > > ---
> > > >  fs/iomap/buffered-io.c | 3 +++
> > > >  1 file changed, 3 insertions(+)
> > > > 
> > > > diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
> > > > index fd827398afd2..0c38333933c6 100644
> > > > --- a/fs/iomap/buffered-io.c
> > > > +++ b/fs/iomap/buffered-io.c
> > > > @@ -234,6 +234,9 @@ static void iomap_adjust_read_range(struct inode *inode, struct folio *folio,
> > > >  	unsigned first = poff >> block_bits;
> > > >  	unsigned last = (poff + plen - 1) >> block_bits;
> > > >  
> > > > +	WARN_ON(*pos & (block_size - 1));
> > > > +	WARN_ON(length & (block_size - 1));
> > > Any reason you chose WARN_ON instead of WARN_ON_ONCE?
> > 
> > I just think it's a fatal error that deserves attention every time
> > it's triggered.
> > 
> 
> Is this a general change or does your later changes depend on these on
> warning to work correctly?

No, there is no functional change.

I added it only because the correctness of iomap_adjust_read_range() depends on
it, so it's better to hightlight it now.

```
	/* move forward for each leading block marked uptodate */
	for (i = first; i <= last; i++) {
		if (!ifs_block_is_uptodate(ifs, i))
			break;
		*pos += block_size; <-------------------- if not aligned, ...
		poff += block_size;
		plen -= block_size;
		first++;
	}
```

> 
> > > 
> > > I don't see WARN_ON being used in iomap/buffered-io.c.
> > 
> > I'm not sure if there are any community guidelines for using these
> > two macros. If there are, please let me know and I'll be happy to
> > follow them as a guide.
> 
> We typically use WARN_ON_ONCE to prevent spamming.

If you think it's better, I will send a new version.

thanks,
Jinliang Zheng. :)

> 
> --
> Pankaj

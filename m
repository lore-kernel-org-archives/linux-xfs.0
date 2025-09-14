Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0C01134BD
	for <linux-xfs@vger.kernel.org>; Sun, 14 Sep 2025 12:40:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757853611; cv=none; b=VMqSWdKQ1yiZWWw+b5h4Z5RoCdirzEJIm6qem+s6Vbq3JQTPtzCova35OCa44YZtfHqOnOvfn3I0GirYbZ0Q5Av1n7MrWEiNfxRYUUPMhxtyeZrm4UNoh6r0AFr1xgiFgzNwgBa+DglGvfpkFiCsL8rRuGYxYZ7TXGNlzt3HcHM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757853611; c=relaxed/simple;
	bh=Dh+wk2yoqrWCD8TB+uPwRbLtPIr4/5QsJ+QbZo4yO/g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I9y5Xqw22j6UahOk8BSV4MIEt8dDse1cyvStcAPYR3hEEXSUv2Xf4b5xF8zkrVk7vdPPvIrYTf5CnpV93g4lWJPW+fwAXzsx7GqsO2arGhL1O0LxGKrk/PwDalTh2EYopYyeu/5tqJZ7MFtLNQv8115Wenr4dwRBCIdx7Xxvc3w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=cQuRA5o2; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cQuRA5o2"
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-244582738b5so26899645ad.3
        for <linux-xfs@vger.kernel.org>; Sun, 14 Sep 2025 05:40:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757853608; x=1758458408; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FQf2AGsnl6vclYwp9c3+fOFIkP4apfGdDfRnsEWxb3w=;
        b=cQuRA5o2MTkN4YKbYLM3zCEfwS4QWMKylpaAOPTH1jHZXCQsyFSE7fIE/rGGaRdTX+
         BYGXZBQNRZo2qOY9g1Sz2RKD4QniFAuXUC0nJoU8OUfGwjhPdFLp0eM17IT5wJ6pnBJt
         56dY+s98IWWfFybwKywcKLcx5AqYBQzxRp2mRZnz0Y5iXgav8wuMeiMjY1qSz/M5kxyy
         0eMPi3lxWPPM0Kchfl7XEYUViR0fe34WTIZaqnYxQcgGuQufC2N0MPSCQJCViOW4UeVN
         u/P3YEHyr48v72K+ihyj9gTSJlEQeRvVnWwq9Tnq+nQIXZVB4nJk8WOqa3gKQx/NIV+D
         3cuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757853608; x=1758458408;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FQf2AGsnl6vclYwp9c3+fOFIkP4apfGdDfRnsEWxb3w=;
        b=ij41wZQ1JZDR1nJV9dMVjdRz9586zQHBkHD2Tk7ZCki4Q/3jSexxqIvJZtjjr/6bYi
         pwIVXwXkgouzn889hHM96NZDEQPP/m/5wl6AtMWJWr3lacnzII7HzCcZngOGYi3gE7gD
         pFz/UCO+09qpmF91p3b/HTPBkHApvKclukwVMjQnuaSlBW1L5cH4h5vJoS3TbSpr9ZQJ
         VNX5TQjaORzvUEgEf3KAZuzbvJe4p+F+saX1QxomtXY3GAaC3M92JeUEEat3Piz+ISxu
         EdzrKSuDjF/P6/i6G4C+lpIX8BucZtWPDlyFqjGcHPNZ8tsWa0OuRVw9B2L5s5NaLxqZ
         E/MA==
X-Forwarded-Encrypted: i=1; AJvYcCU/wD0veuouG1tgPj0DvKy1bw+JqbvM7EsRGkFyt/9Jmcdn/MsOOAK+Pzb4Y22lSlRW/kWAdk4YY70=@vger.kernel.org
X-Gm-Message-State: AOJu0YzmIx2wqdgPOV0kLKXvozEeijCBlROMVLlRTtC1Kn5fL/Zsgmaq
	uMOXT9/qfEKo5d8duAah3y7bIYGAiacVospJ/+sUCMYtyOp58S2bvb14
X-Gm-Gg: ASbGncsT3p4kuAzp/uhys3nU+YQRlC0D8ibfIhF2p7u5ESvBiXAcii2NlU45zdiC2pb
	ka4m8hw7QxCTYgoohDIurtzw+TxigegRlKaz0JiDid4rHjI9H+Pp1XlEhYmXbmFulSAK233K8Oo
	E4majThh2bmRSQZhAvphnpLLKd7/BcJDn636e0eCMOE9MUO1q7GPuwbE4mT4zwLGiKmB8U0WBsg
	aXGFxO4GgMBmZ8gwkZqDojYAZkOV3jBR5jvgDRmbW/dtpQLfsytLjzDQRQIltvYgLHhWEF8g8Gg
	caM/XZlKadycekw/Yt+t2ylWAhy374SNnSM+C6PC128eR9JlBnSbxvnNzXDOnqGWKRV6b2jb9+I
	t1Epbc0zHD/vkGEx0Bh4NPnOFsRjQBl0A3joUTZnGKPIVrMWmKHt5KC8=
X-Google-Smtp-Source: AGHT+IEqALl6Dr8zeTny4Ila1tLRwXJarsJ+CPNRvQ0gp8DtgtwVdOv93ajULAIsNdfEu/GQETTTtg==
X-Received: by 2002:a17:902:ced2:b0:23f:fa79:15d0 with SMTP id d9443c01a7336-25d27142f24mr114645185ad.46.1757853607940;
        Sun, 14 Sep 2025 05:40:07 -0700 (PDT)
Received: from VM-16-24-fedora.. ([43.153.32.141])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-25fc8285639sm49876965ad.134.2025.09.14.05.40.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 14 Sep 2025 05:40:07 -0700 (PDT)
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
Date: Sun, 14 Sep 2025 20:40:06 +0800
Message-ID: <20250914124006.3597588-1-alexjlzheng@tencent.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <vath6pctmyay5ruk43zwj3jd274sx2kqbjkfgvhg3bnmn75oar@373wvrue5pal>
References: <vath6pctmyay5ruk43zwj3jd274sx2kqbjkfgvhg3bnmn75oar@373wvrue5pal>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Sun, 14 Sep 2025 13:45:16 +0200, kernel@pankajraghav.com wrote:
> On Sat, Sep 14, 2025 at 11:37:15AM +0800, alexjlzheng@gmail.com wrote:
> > From: Jinliang Zheng <alexjlzheng@tencent.com>
> > 
> > iomap_folio_state marks the uptodate state in units of block_size, so
> > it is better to check that pos and length are aligned with block_size.
> > 
> > Signed-off-by: Jinliang Zheng <alexjlzheng@tencent.com>
> > ---
> >  fs/iomap/buffered-io.c | 3 +++
> >  1 file changed, 3 insertions(+)
> > 
> > diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
> > index fd827398afd2..0c38333933c6 100644
> > --- a/fs/iomap/buffered-io.c
> > +++ b/fs/iomap/buffered-io.c
> > @@ -234,6 +234,9 @@ static void iomap_adjust_read_range(struct inode *inode, struct folio *folio,
> >  	unsigned first = poff >> block_bits;
> >  	unsigned last = (poff + plen - 1) >> block_bits;
> >  
> > +	WARN_ON(*pos & (block_size - 1));
> > +	WARN_ON(length & (block_size - 1));
> Any reason you chose WARN_ON instead of WARN_ON_ONCE?

I just think it's a fatal error that deserves attention every time
it's triggered.

> 
> I don't see WARN_ON being used in iomap/buffered-io.c.

I'm not sure if there are any community guidelines for using these
two macros. If there are, please let me know and I'll be happy to
follow them as a guide.

thanks,
Jinliang Zheng. :)

> --
> Pankaj

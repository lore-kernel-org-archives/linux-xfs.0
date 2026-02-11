Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3485A346AF5
	for <linux-xfs@vger.kernel.org>; Wed, 11 Feb 2026 03:31:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770780683; cv=none; b=CLS8EeEw8Ii/SIMaJpSQ8modUJsmSCITstjO/z+EdCHgWa4Y6IvBuKZZ5mCTnIgFQqHU0NpT5g/vo+QmmM8Rmj5fKMRJxZm8zMTb80nyWL9d9lCv2wf8DjZe1GhYTy9PFiqtJJDqRFUXBVfLRDRLQbnHKfwRxkpQZ5VzYyOhVJ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770780683; c=relaxed/simple;
	bh=kOKImVrwx74w4JAgLh1XqCZTCzZvDUq6NyV98ul3sTg=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=bZDDvJ/yTgR8VAmGx90iiP0HL5iWBAWBYoOUjB7soc/6E2JmYRAlh6r/Bb/4vE/EVhVZoVn1/QCd5bzzDOFUFcl3iuEGlStAprFwW4E0Ewhs7yEhsgrAMsQ6vuGaUS+vr9A4TmpbTe5QKcLQYKFDxC/8KXIeZEcf0VWbn5y5gxY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=E9SZzjyz; arc=none smtp.client-ip=209.85.216.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="E9SZzjyz"
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-354c16d83b2so2099853a91.3
        for <linux-xfs@vger.kernel.org>; Tue, 10 Feb 2026 19:31:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770780681; x=1771385481; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=kOKImVrwx74w4JAgLh1XqCZTCzZvDUq6NyV98ul3sTg=;
        b=E9SZzjyzjd62aONPuax2pkSJIpl+8T7KlPv1CinGUhIh/zKcmIzE2UtCHXGi/5Nmwj
         ODJwYLCA9F1nLE3lp+ae+YYNmXRNXtHrgPxLBjWUL1ihVMmblnuWp/QJBVUl9la1qQmi
         FHAiL1kfxMJcXZOfzUc6ZwnQWNcsdzJogWw2TbhsTxo3PnIA45DPHQo8pWvTJXd0Lm41
         fMQlG4mDyU44Dm6V7woJlMykgTbtgNs+RcvpVpINoKXf/At5zaLnkYknG1XgxWnwFMAW
         hlaYFJzFVMM3BZVUw3A5dyMebvH8E1cGiTt8bbxBPn2c7BRJS+mcUQuiCNKP4sG51+l8
         2Yuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770780681; x=1771385481;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=kOKImVrwx74w4JAgLh1XqCZTCzZvDUq6NyV98ul3sTg=;
        b=aPWttG0PnSygEy4UAFQP7+2/QHqd0dzvcb4m2T149Z+Y31b3KZx1t+J/wJZa14uClI
         ice2Cl9DeJ22RJKfmnVd4a1WOkTAK58u8NHamZAtdmoypK9nzHs5R6rUby7wozWYDD1Q
         rm7Rf0mrsYh+XlSufBcBwbo3o1GT09HE041thX/zBkeFaZvzt1afjuPSWKdrCAsAKMRQ
         8bXJDrAEyP6KMIPNQAjx6yGgtAgAXOqNBNVWkl4o9iXErNHqDPa8/5K4Y8lZneKRm0tv
         vl50+vZhEfuoNEAR7G3Vbh7D8hbMOmHi9f/deHjVllaYeIpfk/eVO6Q+TGqWzCe23LPC
         E5Gg==
X-Forwarded-Encrypted: i=1; AJvYcCUP8ywVUzG7XgK1iQYXtWF92TpfgY7SbNRKm2EnZ5C+raljVuHC02JF8jgNHlrMpJkLJeCyBAG9UDc=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx/jd8jBy371v4UwAyKa8WbjoMTAEgiQQYvTDsc6JwX/bXrHN8R
	BJsaG6y8kGIGaXbcKjHKrj6Ue72ovIseKSrzqCg8OnyieImw2wu43dH4
X-Gm-Gg: AZuq6aKd5Muy8BnRt66wRuuTDxrUY22B7Ec4GaIDqQwYnWdUdYdjJ+1213xE/ZD/diR
	UAHGoJ6kytWwi4Zd2Z5UPiUyQjmmoyVZ2EoEofPTMbqFzs5Hjtq5RNxRw80Mdpgj2bw3ruYrzNT
	2xFb6u6o0Gexcmg8ibQuLI1QWbu0+Z6Y11yE9YbiXSrkzauEmx/jxS1D0lyXgg87ABOG7dyZzcn
	NUGOzCme6yVqIBJgTAqnHs0kWPgV6gE5inka32UGXgjXrK/Hv2sY5Vu2bXVwFoPWo2s3KFKVnL6
	peKsffNkKsKx1e359Ilk/tywDJnvFh5KkgqBmbb9YkqvC3HgLxXknWF3Dx7nl4O0I04lOOuijhn
	RedCyR/a5v3HwpjErRt12UXLrXGwqh/xVMcLKXzfdLkryMEqw4GapMVCix6VpS0FllBiVXg+TKc
	QzTzpOjIX9E1fcEu1Sep9Unz0QjTY0ez3MKzMwN7vz1n2CLNFcKOsifCNf4M+JPCE+ajUa9Q==
X-Received: by 2002:a17:90b:350c:b0:356:268f:508 with SMTP id 98e67ed59e1d1-3567f8a17a6mr515278a91.35.1770780681443;
        Tue, 10 Feb 2026 19:31:21 -0800 (PST)
Received: from [192.168.0.27] ([159.196.5.243])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-35662e531desm4467329a91.2.2026.02.10.19.31.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Feb 2026 19:31:20 -0800 (PST)
Message-ID: <92ef85fe29b9e64766d8a901661a0a848cb73bf8.camel@gmail.com>
Subject: Re: [PATCH v2 2/2] xfs: add static size checks for ioctl UABI
From: Wilfred Mallawa <wilfred.opensource@gmail.com>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, "Darrick J . Wong"
 <djwong@kernel.org>, 	linux-xfs@vger.kernel.org,
 linux-kernel@vger.kernel.org
Date: Wed, 11 Feb 2026 13:31:16 +1000
In-Reply-To: <20260210153559.GB31245@lst.de>
References: <20260210055942.2844783-2-wilfred.opensource@gmail.com>
	 <20260210055942.2844783-5-wilfred.opensource@gmail.com>
	 <20260210153559.GB31245@lst.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.56.2 (3.56.2-2.fc42) 
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Tue, 2026-02-10 at 16:35 +0100, Christoph Hellwig wrote:
> On Tue, Feb 10, 2026 at 03:59:44PM +1000, Wilfred Mallawa wrote:
> > From: Wilfred Mallawa <wilfred.mallawa@wdc.com>
> >=20
> > The ioctl structures in libxfs/xfs_fs.h are missing static size
> > checks.
> > It is useful to have static size checks for these structures as
> > adding
> > new fields to them could cause issues (e.g. extra padding that may
> > be
> > inserted by the compiler). So add these checks to xfs/xfs_ondisk.h.
> >=20
> > Due to different padding/alignment requirements across different
> > architectures, to avoid build failures, some structures are ommited
> > from
> > the size checks. For example, structures with "compat_" definitions
> > in
> > xfs/xfs_ioctl32.h are ommited.
>=20
> Looks good:
>=20
> Reviewed-by: Christoph Hellwig <hch@lst.de>
>=20
> I couldn't spot any whitespace issues either, although I'd personally
> drop the last empty line if I had to nitpick.

Fixed in V3, Thanks for the review!

Wilfred


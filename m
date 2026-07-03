Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00AF020ADF8
	for <linux-xfs@vger.kernel.org>; Fri,  3 Jul 2026 01:09:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783040954; cv=pass; b=dhDQoMZqxlghlZebg1qqEFjGDi0pCg7GU6PZHZi+AFBVgf+xWqzqb/+0jRrJyVvhkIIhS7p/NNiTPS11uqKghzOEDWVCOI9VtkgStnWIcvxZFFuy91sE178PrQWvNeja60Uk2elTf2S670ZmikiGfk4QKBBjyIAomDj8IaYPt8E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783040954; c=relaxed/simple;
	bh=+PeQLIUmmmMgIHSXGFK8qpsgRcvLGFGUUJJHkFN2P34=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=iaZTSw0V/QXGCKpxKHCBYvVO0f8UzhemDjWcBgy1II61YE6vl4ycI0Uci7+S/PzTsF/on5SeEB9OMrYoxpjImkhFZfc6NdikS9w0TXhsWMvp4G5kzCRm8wql+aNzwo8boRkbCMrTtmnXJKeinvlB3AC5l1VxCGx8SsECDTym2rI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YaW6y+B1; arc=pass smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YaW6y+B1"
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-493b61b52b6so28305e9.1
        for <linux-xfs@vger.kernel.org>; Thu, 02 Jul 2026 18:09:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1783040951; cv=none;
        d=google.com; s=arc-20260327;
        b=oP//PcCJATdC4Zk5vm3vZBBwEWnotWwA0VwogT6fxhuXN3IAQhkiOs7LL76LpBtYt3
         Xlx3XTtS7YVnhAaCkmfp5c6ZRtm2H5S2DK6Ym+zeSkePsFr2rQO8hltkl2vLsVHVcDBI
         KgqXSvs5LxG1W+oKbb3wVIWHTydniFLfe41LaJVyK8DoZ9n5jCyOYqvlnN1Hyctok/ix
         dkE0YKGMwgsL8ujPfAU9HCFN7TvYMDDW0xKilBwPI4/FyTltgHhrWnKULI49rEdIVEp6
         SsorUK+tGVi/w+nXFeYVU4jb9aSVp3b4fX49lENNWL0olJGP1ua9AZDMAyHTnpY2C4Et
         5Xdw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=mKtUjpcLEtae9EYATJ2n3P73/k/uWxtMsjVu1YWxYyc=;
        fh=okzjo6UQQIaqRoE3PwcYLQ/zAYSHZG/4vIgrwTG42hU=;
        b=KNXCjDQe6YtnKzNi8IGg+7F90CvU+5QTxf2gl+cK9LAxWnYSXHkim2xMIX1IGIXXjx
         HCcmJZJUaIQr42z4hZJ6GgQl5HEtGZ0WsMjgn3D+DgqOPajn+07QSCeQ3ZUl9A+8D30l
         I0sTwhBOTlp9rhStUO5ZltjKVCnowckeCLCSlGZnw8ercJ2ZKsbtwvB91cc83SqjkLyH
         EMH9heUG100ZptzOstUzM+cS7xcJoGsoG89GSTk2mqAXfch8g1X7+wJaEmQEbP1qTbrA
         03Yyq/WJSSe4ywM/VWln1/oXyh6Ty7xaVCOYA83QMWScngtcNgHUWBtBSFtZSa9wzXJX
         i+cA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783040951; x=1783645751; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=mKtUjpcLEtae9EYATJ2n3P73/k/uWxtMsjVu1YWxYyc=;
        b=YaW6y+B1f0dDuqfUYmvofIB/SSkroGSQTUh4VfJRbYVTEi8dzX8L7iNQ00YXWCY9nw
         CJ3UmSwQMeFvC5HoMrOHsjaq0Yxqb0APyjZnC0y9el9e5JkkuAGwKzdQyUpJRIDFkyf9
         e9yTuGExnyNHOZnmDEsKxUyb5RfV9WbK7Qi0D6WFu+eU5XGe3d08VGpBs22Cf64UJyDy
         /L9JvAmOu4WYOZZMUGvCbnCZ1wChP3ls+f8tYAQI5S2m8zD3cGEjCaVVkHh1fihLxHYP
         dXFDfP2drv2GcDqTUdTXVLIzxxE9KZRqg4pNG4Pd4z+qZAWIgfxE4PTtIpeGar3GrOJv
         zGlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783040951; x=1783645751;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=mKtUjpcLEtae9EYATJ2n3P73/k/uWxtMsjVu1YWxYyc=;
        b=tRGUixWvp0jhRusZJ31hoAr2LF3fCioIBZ4abLzI+OKM6t4AwccSyKEnL7pGxD6qKx
         lpZ5qbhn7duNvV7buSiIMGu8RtaJXaG2kxekYTDduaNZt+xtZCwpmVe6769HHm387GSA
         ir54OW5mRQeRItLzvo3fL0bAAsoaEFRYeF/M+7RGEmVJajMvyDGSviD+JSDpUeUuEUn/
         RepWrGsJtRID5StfU+Qiz0IThip/MAxW88RKokxjdfl5HIb+R2B3hq0mB9StOZUIDWxw
         jmytnScU7BUIGGFfyBKqqPvsmNRA5BWY2FVPLKfLO8zh8bf+ktakPttpHY0z7xqu3uvu
         HFuw==
X-Forwarded-Encrypted: i=1; AFNElJ+ypDWai9OSUQpMXfKTvaN/Pb+KX1fvGpGhDAk8wNgYdYzWNKaZcagaWf8sYO2K6E1M5jN1zry2srM=@vger.kernel.org
X-Gm-Message-State: AOJu0YzME4I/y5ngsLHqVQOKgZyxk6ch0l0DeKtkYePEX5DdrHmw4p/o
	ECaXELp6/RAovJzxLF2tIPMM+S3ZaEXHUqzSqRCu3FakY6g2RDnp7vSFMXZjvBpFLejUxRxd3wH
	/HTT6RydcXOgkjE6UMhTFLRgLiAicxMPXpnfDQV8=
X-Gm-Gg: AfdE7cmiAyX4zFCdV2vp9Y1ZT5uDcXes2JvroupXAgQNuXPMpX1wtIBBgyDoVEwkFqR
	6k3qcbKOXXQzpe4MR5lQQL157DfSIR84Bp5WrZj+/74s/QXMT6G8FfUa1+mOs33Zx281csw//dQ
	tL6/sohHDhQPxrme93n9JFKBdqWWtFeNHjcSshwC+Thfn3+PKnm0MhXJyC373l40dtqZW/CnXLB
	GF0v/429CGeELjyy7C4AnQwSm8ymS3v9UAe1kcMijgta+tfwRuY/cOSK1gkpJsfrO6bCOCRej2u
	v04Tu+77vnd6pVQzdQCyNNFTK1iKIWvoamfXjKPO/ID2Vp/QY4Jw
X-Received: by 2002:a05:600c:35d2:b0:493:c3f9:65a2 with SMTP id
 5b1f17b1804b1-493c3f9664bmr124524785e9.5.1783040951341; Thu, 02 Jul 2026
 18:09:11 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260701000949.1666714-1-joannelkoong@gmail.com> <akZsZ2KV_-jsNZl9@infradead.org>
In-Reply-To: <akZsZ2KV_-jsNZl9@infradead.org>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Thu, 2 Jul 2026 18:08:57 -0700
X-Gm-Features: AVVi8CcMR_tmj_vpU84RWRMXO0CqEvDgbM61sr0zCq5c_sRYQUpWHXFzI5ZJoX8
Message-ID: <CAJnrk1ZZCBexaYUCe0s2_kfbAZVKrdhSXFCRv=cy1ggcxRhSPw@mail.gmail.com>
Subject: Re: [PATCH v2 00/18] iomap: convert to in-iter iomap_next() model
To: Christoph Hellwig <hch@infradead.org>
Cc: brauner@kernel.org, hch@lst.de, djwong@kernel.org, willy@infradead.org, 
	hsiangkao@linux.alibaba.com, linux-fsdevel@vger.kernel.org, 
	linux-xfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 2, 2026 at 6:49=E2=80=AFAM Christoph Hellwig <hch@infradead.org=
> wrote:
>
> What tree does this apply to?  I tried 7.2-rc1, Linus current
> master, vfs/vfs.fixes and had slightly different failures to apply
> with each one.

This is on top of Christian's vfs iomap tree (vfs-7.3.iomap) on top of
commit f2727952b21d1.

>
> On Tue, Jun 30, 2026 at 05:09:15PM -0700, Joanne Koong wrote:
> > This series implements a suggestion by Christoph for finishing the conv=
ersion
> > of iomap to an iterator model. This revives Matthew's previous RFC [1],=
 which
> > had the same intention.
>
> Btw, this evolved from my original suggestion to something that actually
> looks much better, so don't give me too much credit :)

This definitely wouldn't have existed without your suggestion and
guidance :) Thanks for reviewing the series!

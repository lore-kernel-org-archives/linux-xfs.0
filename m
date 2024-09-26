Received: from mail-yw1-f175.google.com (mail-yw1-f175.google.com [209.85.128.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FCC41591EA;
	Thu, 26 Sep 2024 00:58:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727312339; cv=none; b=dmu8aSXxSkDFMdl8Mt8/7HM/xuTYsqhGQdvBwva4mhhaXe42HvQQ5vTHhaaLR+7lfHuNQHaWqrgF01vW7fo9C+qxsxLHcUj9H38wjg+G5A5LwwrNqMunQrNeNx2x//idSasmKbi3eqPjgnS9VTKWHs1PBj8BeOtb9RHChcVl/fI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727312339; c=relaxed/simple;
	bh=C8dnDRKX/425nySvjD8Am05y6IONl60+SgSXKzq5Vgw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Pww5R7lfKkkxlj/eC95T0+5xYgBLiq0vGv03yn8tt9d12NaSyW/wklR2+dIulp5ILK2G4mEKej+yfDxVCZZbjG6GZv/6tlkAhu1gZD3yrQ8fWayFeMrui9Pe38gKxixb6luLrAIFsChMVGyhmoFbgM2Io0oN+ZmaakevahZzHVM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YrOcAw3s; arc=none smtp.client-ip=209.85.128.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YrOcAw3s"
Received: by mail-yw1-f175.google.com with SMTP id 00721157ae682-6dbb24ee34dso4811067b3.2;
        Wed, 25 Sep 2024 17:58:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1727312336; x=1727917136; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=C8dnDRKX/425nySvjD8Am05y6IONl60+SgSXKzq5Vgw=;
        b=YrOcAw3stpq9xOvetNHl90J9Me96xB3TLYBOJxgO26rFiy3RTxdnyo3/hrlSppCWBQ
         QniWnOyz8R1zy+yGlwjaUK+TMKKggzUK8kwGDhc3021Z1FxLk9n3bum5naEZ3EsK8HuC
         T7OPC+YvQmTc9DGaJJ7SyIARja1CYi+2XS6/6uuGD7Ktnd96iyHWyK4Si1fvHWK/cgNH
         0PAVByHt7/XTEv4T7oI04dDn/rnL0RRugStKH9/B+TBCNpl6jtHHoMv5zoKOaV8S4gDV
         aNf/GsWiKfGh9HC0pTebUUacO83MX/gh/k50em48wH/yDupvVy9jIdNWUdSjx8n4QAKj
         dmAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727312336; x=1727917136;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=C8dnDRKX/425nySvjD8Am05y6IONl60+SgSXKzq5Vgw=;
        b=DCBHf7lb9JPZpuDuKdg+1HKQQ+3+fnILV1l0zRnNOenZ0hxVw+PWb+OZHLwDi9z/zh
         x6OVUzRYpY/HN7pRxpz0pZhQy30sYlyR5cCOJZHCWbsPoatVYQ5s9/QaMEsySaYhsBiS
         BMtOufpqt302LXuaMBUnvud4pW0Qf9zKk65IP3A480P8cqVLUpBbtfP0zqCAIlvT1QIe
         BEYGcNPTp4yU20Ak9IPjjAU/j3IJwfGsI2V8+jXql1wCWnwlEr8HYSbPydKjtfqNFtTd
         GmIjaQaY729XupLFIAsIvUBKRo2rsyJKiFZZU/xqRKMBgo0nlGSCwSmONQo4/CCsnvKg
         CbJg==
X-Forwarded-Encrypted: i=1; AJvYcCX89F7i5Qhzyzw7MI/87yXq09+g8FuzPKHu56WtCTlj3fdP538Wibkkpuw4OR+PAhAu3YL0xrLuzPA=@vger.kernel.org
X-Gm-Message-State: AOJu0YxCT/o8kIgrt3NmoBeMzPBW8CdNADJAc3ZBd3IR8HNKUsbd1W3s
	Dt8xYZ36WdZd/MTQpwnDxvV4b6xiOmV5zngWlMv3p+5y8Tv0oMCF+AijoP1M+xSYy/ftl5N2V4f
	WjUtnbNDl30DeOuK+uwze6Rfmypo=
X-Google-Smtp-Source: AGHT+IHAUYDTr/7RqOp4RPqij+QDEXIo3VNN3JiAy1DLmc4hBL6OydG1Haxfrj8B551qJEU2A2DvxpYGNR8uOJM1vnk=
X-Received: by 2002:a05:690c:f87:b0:64a:f237:e0b0 with SMTP id
 00721157ae682-6e21d6bf7a3mr50889557b3.5.1727312336465; Wed, 25 Sep 2024
 17:58:56 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240924183851.1901667-1-leah.rumancik@gmail.com> <ZvM3RhJxJuMeARbV@dread.disaster.area>
In-Reply-To: <ZvM3RhJxJuMeARbV@dread.disaster.area>
From: Leah Rumancik <leah.rumancik@gmail.com>
Date: Wed, 25 Sep 2024 17:58:45 -0700
Message-ID: <CACzhbgQwjgweYPNHqgRR46Tev4=4YAuLb724CN8_xouH1nNGqg@mail.gmail.com>
Subject: Re: [PATCH 6.1 00/26] xfs backports to catch 6.1.y up to 6.6
To: Dave Chinner <david@fromorbit.com>
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org, amir73il@gmail.com, 
	chandan.babu@oracle.com, cem@kernel.org, catherine.hoang@oracle.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Sure, just sent it as [PATCH 6.1 27/26]

- leah

On Tue, Sep 24, 2024 at 3:03=E2=80=AFPM Dave Chinner <david@fromorbit.com> =
wrote:
>
> On Tue, Sep 24, 2024 at 11:38:25AM -0700, Leah Rumancik wrote:
> > Hello again,
> >
> > Here is the next set of XFS backports, this set is for 6.1.y and I will
> > be following up with a set for 5.15.y later. There were some good
> > suggestions made at LSF to survey test coverage to cut back on
> > testing but I've been a bit swamped and a backport set was overdue.
> > So for this set, I have run the auto group 3 x 8 configs with no
> > regressions seen. Let me know if you spot any issues.
> >
> > This set has already been ack'd on the XFS list.
>
> Hi Leah, can you pick up this recently requested fix for the series,
> too?
>
> https://lore.kernel.org/linux-xfs/20240923155752.8443-1-kalachev@swemel.r=
u/T/
>
> -Dave.
> --
> Dave Chinner
> david@fromorbit.com

Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 952552FF672
	for <linux-xfs@vger.kernel.org>; Thu,  6 Aug 2026 12:06:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786018016; cv=pass; b=TT3X7Q4R5N8RRiRrK8mlSD/KXth5NUl3i32oczE90DF2RSN9OZYwz1JCcSDdZL0z1lpSBi+CdZtng6wyDURqFJTLGuIaAZguhU586K5VdVSnDTnz8yTa9flytUq6KbEq2FOghMngxUx2V2tP+WuI+Vt5lA3x094UIPxsyciu4ww=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786018016; c=relaxed/simple;
	bh=gm1y3HjSbfjetP2qj6SkQ/PvAerOiP935sq/jHQIUpg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=n04lUrHeLyWQxi3CnlB7fx8ym9rADWgaMtCvtBG1nWP+121IsOk0ztAHQe5QLy6PZePqkSIv3k/2Sux8D9WwR3N1Owt5SmHUwaPZ3IYhSqoTtH1tA1B/Y56kS090RBo7ZoBKsHdGaQJmw9uDCxKDCY8yvcVbXhXqMJ5FBmxRVPE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Vb9OcfD2; arc=pass smtp.client-ip=209.85.208.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Vb9OcfD2"
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-69c108fee7fso3114649a12.3
        for <linux-xfs@vger.kernel.org>; Thu, 06 Aug 2026 05:06:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1786018013; cv=none;
        d=google.com; s=arc-20260327;
        b=CvE4sLAqX61bMu8CqN7KG8ZG8vjGwT9u1wR4v9VwBbSaLzvaxax0F+31WRUhkp5lKW
         vEfHywMsch8sqX9jstI5q4FhcagCBgBy+LUYVnBt+4wQy9TmzsRwHx31uaXKfUBeyMlj
         mvMNHHsMbAEenKd6PIIdf8TdHDcwW4n8zMN8PgbxOKyIPrRM8TE96pht9Wg9HknuoYTG
         zTxgSd4yg+/c14YN/xoN1L/OtGm1Oj8pSG+8Fs7Auik8DXcNFM3AlwCOga5O1mjENyeA
         9o8YtXTuMWR76Bz677Q9jGwj8a4UbO62EoEXG8Lxac/w+nnPpy3ZXuRnjFqEmXG7SkDp
         dW3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=gm1y3HjSbfjetP2qj6SkQ/PvAerOiP935sq/jHQIUpg=;
        fh=0ntakmSOf9fdJXnxC5FYskb1A8qbAsBZTpsfs/8UG8Q=;
        b=aUEaJTKz+hz2ZY7v+EjhDeAU5e/2ZQQGDnRm3i4KCf/wvGysxx7BTxXrZ1Eaf5hpLN
         V3X6Q25Kca2Nd0i+TO3SCbJGiwFYIOuU//CzIZPUKXfhAX/NAMgZA9QScQAolTVULlqU
         oc/5nONxOWfFM1Z8KW6U5BR2BuIkd2vtPVPq6HYlzX+GtckNB1phlBi0IM6r/GjMsXuz
         of54HQ9O16VZEkRqVDvfxu73iXTHKz6ukbQPKD/T8zTUO/LabAS6S0y4Xg5aFpeKn4K9
         w9jfKsuu7iZLtcWibQbTkElg37xArqEUAm8GaZd+2/j0IVR2XnWOcJjkXQMZ1iOw55rC
         UknQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786018013; x=1786622813; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=gm1y3HjSbfjetP2qj6SkQ/PvAerOiP935sq/jHQIUpg=;
        b=Vb9OcfD2g8B7FhOXE/AxFlnYBkhDF183dFcMzXv2kuf1SS8I37i+IFfOe6S77yUMmG
         Emb8Z55urXxFw6EGHGXqyCyuNbDatEtz0PzWVtbfWAVSiTE8Drm+dkL5MMzUvPqWoBrg
         WJ4mWq46MmIk2PRXcAo2wJy+mIBEB3LW1jQI1mjEnZ4sD3ZCFpgLZhBWFKpokwslMwzN
         cR2dS7YkiNUoyCkJ9mMhbC+D+04BiyzgG5RE9sGtMJhSfKbwXgHCgpCu71ishch9hCYv
         ReORnkzajc9hfut/s2k+uFlFL9aThR4q36GlVmapzaALmIxbhlTRQdN5hJjhUYYP/Yva
         rF+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786018013; x=1786622813;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=gm1y3HjSbfjetP2qj6SkQ/PvAerOiP935sq/jHQIUpg=;
        b=LdHbjThCkh0ejNqQCwKgn+D7IdiBsSitoenBn1bxGImQ2q/YRENN8kMs9OxLpKHDqS
         kRbaSoetTwIIkZlqP3RPIKkwW+isVQExOUVDcdeF818TSbOkm3zZhwF4k+xKTx47ITcU
         DZCdpZ1nYBbK92a7guRLdnhCyEj3gFQfcpmfLJDuPCpRq+ERmpnwNgIMbevhV9ad6nhH
         arpDSJz+QWVYycqwIw4jQqyH2Ffxya/zB60egxA2TPb6Mq6o5kZPzS0DsSLh0/cuqLCX
         eF7uYLYgmdXoWkA17NB4YjFMDz0BaVWi79Mxokrxssn2tquF+Fcmd3ZWqLwmSZ016yXi
         D55A==
X-Forwarded-Encrypted: i=1; AHgh+RpMHFjxGYyg6hxEXjsBQa+rxH9irs9uN+gN1Tu5jnc1Vv7W4v4K32/64xHfnYRCn18kFe0vpUodIKM=@vger.kernel.org
X-Gm-Message-State: AOJu0YzK7L6Lji/LSypOrM0kdAyn0ot/toU1b79nIgucPBiIRjPQEWdp
	j58PDUGtJ7Fhh7DTMD96dir6T72aakAtNQE3uU6aXYepKnbOy1/x9EcjEC4V1wOOVEOMxIE9Ynw
	JEpO4UNXZSedF24plybynUTn11muiNw==
X-Gm-Gg: AR+sD12giG11v0SPjWBvyF9wsgW2JzRjQUGffMVg23pk6eN0rSJM6ucIeae8OIxbvG+
	gIn7hMlkofjck7szwvhZfhuYCj4DT+32UZYf4AgRCOeg+IKcsAjVWT2XYeC3AVvrggB1CGEButm
	VKITIuA2lsbRD8SiDKrtsrj+/o9C0R7CJbAvLTUejerQ2JOBd2vEnmfOjifVTUubcStbWG/ZI90
	Zn8wuHPoqMH32Sj+SFf8Zii8TQUF1j4sqMWc4vAI08BYeyE/VlIsOwIo53N+lVELhTjzGtupmkN
	HHy7h7dY8yxDCuT4DDcoQwa14WAUByObDhBBAtIxOUnZiUHhx/hyJy5LsxcHjIEojBTM7Xc9OR4
	wT5+bSmFvBRUP6Xjt8g==
X-Received: by 2002:a05:6402:42c3:b0:696:8f45:4ae7 with SMTP id
 4fb4d7f45d1cf-6a14f138aa8mr7034271a12.13.1786018012568; Thu, 06 Aug 2026
 05:06:52 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260804124404.737145-1-hch@lst.de> <20260804124404.737145-3-hch@lst.de>
In-Reply-To: <20260804124404.737145-3-hch@lst.de>
From: Anuj gupta <anuj1072538@gmail.com>
Date: Thu, 6 Aug 2026 17:36:14 +0530
X-Gm-Features: AUfX_mwpy12o3SwOUSv8lriL-YCkBG9LDIBCAyExEhQS8ZsJ_vNr_t-bxK4FRbA
Message-ID: <CACzX3AvRWQ1qGwmQxvH8xeZB7cyky9k716PO8MgSM9tvOo=KYQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] iomap: iomap_bio_read_folio_range_sync is missing a
 call to bio_uninit
To: Christoph Hellwig <hch@lst.de>
Cc: Christian Brauner <brauner@kernel.org>, "Darrick J. Wong" <djwong@kernel.org>, 
	Anuj Gupta <anuj20.g@samsung.com>, Kanchan Joshi <joshi.k@samsung.com>, linux-xfs@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Reviewed-by: Anuj Gupta <anuj20.g@samsung.com>

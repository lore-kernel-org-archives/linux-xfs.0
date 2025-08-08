Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5F6B26560A
	for <linux-xfs@vger.kernel.org>; Fri,  8 Aug 2025 19:28:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754681337; cv=none; b=aqHVob0Of+PhgNogBwDThXZtmdEBZ64zbnh/HbaI4sYu5nMTRQd93nRPvksICKFyaWp/k7SqsOa+NR2Qzp8MUJbk7bWNsuYoPYYFS9Zy+DfIZjeBlyzmSXII79IIw+JlEwDLgUyYIEHnsLLCru58Au9ZWhAvLwh/Pwt+DtXRZa0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754681337; c=relaxed/simple;
	bh=QEXhxovWYUHVgBkEl/gTdcNOIaqUcKQWivj1PPJZ8ak=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=EFltjYmtG8ujTSUSHtIP/g0h5z6gyOGsKB1Who8SApMfcQC2gK2ujl4mtYMFQyD/qgAK6M1wSAAnQ4tqR/XKzLPwoAEEpKderJN5k2pDpdzX99kM8cMfql+R4p0Uz4xWEmSBWcoQbu7lr//85DSm/eHBbwZ3TpfdY+owqslwZsg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=i8Ds0GrW; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="i8Ds0GrW"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1754681334;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type;
	bh=z+VJfc5dyu/GsDQ2jOZqvhe7ZEO+uEqdgkyy6rtOglw=;
	b=i8Ds0GrWWtWj1ZzQsMhIDi0fca0ri/eQ/vlyPG+4nyNpr0og6pT9IuOyGT/BjZI/vyPK8T
	1vjKwlug9bNwkz5jSzaMjvCQOuy5yv9+Axn/UsWoZeNT9mLndJqOM3F+iWLkyrCOAJi2a7
	xBokkdZc4EyUmBaKYZxbtt919H6wC7w=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-608-N3p7ITGXPOeSrlcn8YyemQ-1; Fri, 08 Aug 2025 15:28:53 -0400
X-MC-Unique: N3p7ITGXPOeSrlcn8YyemQ-1
X-Mimecast-MFC-AGG-ID: N3p7ITGXPOeSrlcn8YyemQ_1754681332
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-3b8d62a680bso1371466f8f.0
        for <linux-xfs@vger.kernel.org>; Fri, 08 Aug 2025 12:28:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754681331; x=1755286131;
        h=content-disposition:mime-version:message-id:subject:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=z+VJfc5dyu/GsDQ2jOZqvhe7ZEO+uEqdgkyy6rtOglw=;
        b=aGpKP4h+d6CYR/HyjYM4Y86QhBW5MkTPgvWOvdeXNfqT74qZ0tvl0ntvruAWaILqhL
         AeFYGH2EIXOp4wx3wk9iIizS48hDuNOnTTRgnes8jlAjF9VoCiKFJp9zMgY+rRDU+yoT
         Sb5zJW9hR4jShnCaIdcvrhpAKWjoHp8nBhIFWB/dqx9J2fOWw5JYbFNZJJKV8Q/gVu7k
         klwOIOWB/CQMPXIMOkHKQ7cpxkJsVBo7QeVH/KdEV7L+il4DkRKKsOgfLvZuZCY9mTpG
         JdouH3E3W1992XyPxfQps7P4BoZl5FMkOcVV9KlJYfSpaeJ/sMRrkyzcWQly1c8psOJx
         vHTA==
X-Gm-Message-State: AOJu0YzAhcCM6fvKpMzPFupAzk57PU50ntfxMw3mCe5eGynPLbtKhaEw
	ywWnkbW59aEbysbjgbWYNQAZB4YKPNP/M+YL10urmdTdtZcMwB9TThjJq1nMz6voK0T3FYVYCi2
	8XOqp0j3O01+3MzVvblYusJ88uPgAI0ANWtTubiU08sjpOuTT1QDY2N82A22V0mwMYHLf+MddiJ
	LOSjsINTMzNVV1g7awxKs87gimmBfD7a1HWGMVP7/v7jB1
X-Gm-Gg: ASbGnctI4Bni5sjJSrXV7lwPCI7vbyeeZIb1QcXbdCU8SGRxpXiBYQnbT6ZcrmeNXUd
	YhcynqF7cxW/0aBV1VL+/YoUUISsBYG2HmrOpr34OwsdXq42Tt7RmQTCsMKNvPAUPzVY0AuF17p
	k+Y3NKvVE96FLr7tHCSL/HmLhI935yuL+4upfGl14JfaDSrBQArKzPuVk54APtmR+wqe5HYU3rJ
	H9mWpxqAPJMlA3cypNORUFnAlTNopkYJg2W8MxlzpTl3mlKU2ZvGHFt+8ONqFVFKQPCPsXFNz/l
	hUjEYkbZ6MrmoHS1hHVXEDAL5Up0yrTgB/yNWdHmjnk3J5hXle44FXc7yRc=
X-Received: by 2002:a05:6000:2209:b0:3a4:cec5:b59c with SMTP id ffacd0b85a97d-3b8f97f4ba4mr8240468f8f.25.1754681331252;
        Fri, 08 Aug 2025 12:28:51 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFI9xY/6Qpbd5IKobjzePxeB3jT7K8h08kAJrvDGyK5ww5Cu3HFMUyCZu/kR3Zamj5WJ7zjng==
X-Received: by 2002:a05:6000:2209:b0:3a4:cec5:b59c with SMTP id ffacd0b85a97d-3b8f97f4ba4mr8240451f8f.25.1754681330861;
        Fri, 08 Aug 2025 12:28:50 -0700 (PDT)
Received: from thinky (ip-217-030-074-039.aim-net.cz. [217.30.74.39])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b79c3ad803sm31036606f8f.6.2025.08.08.12.28.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Aug 2025 12:28:50 -0700 (PDT)
Date: Fri, 8 Aug 2025 21:28:44 +0200
From: Andrey Albershteyn <aalbersh@redhat.com>
To: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	fstests@vger.kernel.org
Subject: Tests for file_getattr()/file_setattr() and xfsprogs update
Message-ID: <lgivc7qosvmmqzcq7fzhij74smpqlgnoosnbnooalulhv4spkj@fva6erttoa4d>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi all,

This two patchsets are update to xfsprogs to utilize recently added
file_getattr() and file_setattr() syscalls.

The second patchset adds two tests to fstests, one generic one on
these syscals and second one is for XFS's original usecase for these
syscalls (projects quotas).

-- 
- Andrey


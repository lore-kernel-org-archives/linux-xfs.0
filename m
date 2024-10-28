Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E19EC52F9B;
	Mon, 28 Oct 2024 10:33:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730111619; cv=none; b=N71Uoz7RhqmikznWT9ja8lHjDLM95eVKz17eBZoTQGsGfFNc5mxDfxc7YHWVKgQV6yJhca/tvOmE7igkls7c/qmH8yGwu9FtAys5jii48xWrjV4qIyYanLIH5rXMAvCYNgX7iHh9XeQfh4tV+3YAa1T1tJT/pMsNihTzL+E88Ko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730111619; c=relaxed/simple;
	bh=JROHXBIeZdt3db7N5COy1zG+pjgiCF8B9N7N0nSjH0M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YjzcsHAEU6n61fUzyF/D8DfG8tSDxbbrSHYb8CX68iPxPsqpsqz17kzw7JZURg57LdRAz8CEJxbDXY8m1SpSiFDe4TYIoorJxvI6nmOaRLSmLizKUEVSaX8o4YonRtLRfdrliHy6NWd5qHrVNzDEVtGFD+0vCH8gLTY7jgR0IP8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UQkyS3uZ; arc=none smtp.client-ip=209.85.210.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UQkyS3uZ"
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-71e5a62031aso2937728b3a.1;
        Mon, 28 Oct 2024 03:33:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1730111617; x=1730716417; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vDtpeCsUULnDX/AGBcUbQD0iiRBGAC9oEPoVEF4zK+c=;
        b=UQkyS3uZlCNNMJHGh0iVwCReRRkGJrBx9q2AXpOBQZXJkRieK9kUcWIhi8E4XpNsxP
         r6Q2IMSTylLBwnJZ7p1B7GTAtPUjuLc+brT5Ky7AgtcDlLYTg1M6xODDmkiHXFAWSIbR
         2J5fybAvTAQV6dHY11Nz62NOMcTRXD32/R2cccSLsDpOuKId+7zkKiwz51jobBc7V2bp
         GmjdUXy3bAgO5dWljRh6NIzi0ZikTFnqqaD3Sn67TYH5pU/OXT1f33r/uSW1+GYO+mKN
         dM3wqCIV7+lRsUDqagytqQ/E5Zq4WmudaljiRRoOmRtOYARUjx2hFY1kOKMqLptaMiwU
         hD7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730111617; x=1730716417;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vDtpeCsUULnDX/AGBcUbQD0iiRBGAC9oEPoVEF4zK+c=;
        b=vGEyHC964rTyeJ6b90ljkBCmkSOv6CkMFP5GMPZT7y/kqFS3V6PLEbH99tazSjj8zT
         bkpqn60rjTUkvHOoKJm9UkdZ5mdwf9T/0B6iAknHmnNrvAHl+QW99bkJUdlA3oUzhGx8
         D+qLze5xVnRFsOU1QkC2ek03+TyMIrSiFS4cG/Pigg9JEYgqxydE5Qjhb6r2cAVSBTWS
         eYO6Yz2MaqIEZfqMx5bEzw8K84r/95oQWpDTeiBN+Vo2iomUsPAs0x/m2jzECyGNPc0k
         KgJJH+/v2neq3fRHw9Hj2mgoB+jXd9dcUN/UWMR827DKvfKJ633xlXgRwUhpM9nsfghk
         /DUw==
X-Forwarded-Encrypted: i=1; AJvYcCU3LMehC575ckADI5DidfUzkleq5MajQFgr5uilxtUk6J+Sf9yTEz/uf99/usJmXtsIrF6JA9bdkNjT+/s=@vger.kernel.org, AJvYcCUPrddWsJsfidSyl3Nyq8sr6W8ynwiA/7lxev6Qw0gruPkFEjM7UobU/gOFgj12X+cKB4x6f7tLln18@vger.kernel.org
X-Gm-Message-State: AOJu0YxWDJGB//j/XmGu0mIgw+K1jrNMjw+W44v1D/8fFeJoqH1Fs95O
	ui0REh5LB7WLOF4AowmETL/MfN8Plw310riCFIwaaBPPJDrhLZN1
X-Google-Smtp-Source: AGHT+IF+G5SIfouuYelc2e74bWDnZ8aTqiM2MpOhtiKcPZntnoHBitZewarYJ0C/nn0f80ejGh23QQ==
X-Received: by 2002:a05:6a00:b1d:b0:71e:148c:4611 with SMTP id d2e1a72fcca58-72062f4bee2mr9131361b3a.6.1730111616957;
        Mon, 28 Oct 2024 03:33:36 -0700 (PDT)
Received: from localhost.localdomain ([119.28.17.178])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-720757322d5sm2569179b3a.91.2024.10.28.03.33.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Oct 2024 03:33:36 -0700 (PDT)
From: Jinliang Zheng <alexjlzheng@gmail.com>
X-Google-Original-From: Jinliang Zheng <alexjlzheng@tencent.com>
To: alexjlzheng@gmail.com
Cc: alexjlzheng@tencent.com,
	cem@kernel.org,
	chandanbabu@kernel.org,
	dchinner@redhat.com,
	djwong@kernel.org,
	linux-kernel@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	zhangjiachen.jaycee@bytedance.com
Subject: Re: [PATCH] xfs: fix the judgment of whether the file already has extents
Date: Mon, 28 Oct 2024 18:33:32 +0800
Message-ID: <20241028103332.1108203-1-alexjlzheng@tencent.com>
X-Mailer: git-send-email 2.41.1
In-Reply-To: <20241026180116.10536-1-alexjlzheng@tencent.com>
References: <20241026180116.10536-1-alexjlzheng@tencent.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Mon, 28 Oct 2024 02:41:01 -0700, hch@infradead.org wrote:
> On Sun, Oct 27, 2024 at 02:01:16AM +0800, alexjlzheng@gmail.com wrote:
> > From: Jinliang Zheng <alexjlzheng@tencent.com>
> > 
> > When we call create(), lseek() and write() sequentially, offset != 0
> > cannot be used as a judgment condition for whether the file already
> > has extents.
> > 
> > This patch uses prev.br_startoff instead of offset != 0.
>
> This changed the predicate from "are we at offset 0" to "are there
> any allocations before that".  That's a pretty big semantic change.
> Maybe a good one, maybe not.  Can you explain what workload it helps
> you with?


Thanks for your reply.

I noticed this because I was confused when reading the code here. The code
comment here says:

/*
 * If there are already extents in the file, try an exact EOF block
 * allocation to extend the file as a contiguous extent. If that fails,
 * or it's the first allocation in a file, just try for a stripe aligned
 * allocation.
 */

But as you said, the semantics of the current code is "are we at offset 0",
not "are there any allocations before that".

Therefore, I think it is better to use "prev.br_startoff != NULLFILEOFF"
instead of the current "offset != 0", at least its semantics are more
consistent with the intention in the code comment and reduce confusion.

But if the semantics here have indeed changed to the point where it is
inconsistent with the code comment, my suggestion is to update the code
comment here.

Thank you. :)
Jinliang Zheng

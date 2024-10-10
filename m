Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53FC27462
	for <linux-xfs@vger.kernel.org>; Thu, 10 Oct 2024 16:48:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728578912; cv=none; b=U0PLBA0PTW3Ki45jy7wzKu+87tuZXvlXrnrm6MeQCp30zrKhx3Ew7rRXNAca6BCxE0lTQz5/Q1ETkzGXjvdIO1ZjOf2SEqxmlqaiVIyXLS+hDIIOgfCgB/SB1zo2V8vQw0OtP7EH6rupf0C/9DuUEcCAetZnOsT1It+dNmY77Kw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728578912; c=relaxed/simple;
	bh=amuvSHtAg+Zgcqz2unwr5rolbrAlfKA4J5EC3jCDA+U=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=OqkT1+A+okfC/FAuAutuNb66B3u9cHhFpeRzUI+MTBuTnrPcNT9wllJS7gPQZCn4BH+QpjJ2/OIiCEIeBt1lnAbQnNX5MAHe4bsgr+8Op4RcMQ0xabdDBdKBmr3ZBu+bHHtElqA6IqXx/Aks03JUR+uj3XHDKGTBQ+aXZa+MKVM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=TO0MoFQl; arc=none smtp.client-ip=209.85.218.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="TO0MoFQl"
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-a9960371b62so126520766b.3
        for <linux-xfs@vger.kernel.org>; Thu, 10 Oct 2024 09:48:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1728578908; x=1729183708; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=JQiBNBCGQr4DG/5Y4cFeaMzRBxYQ2OiJzW//b3dghb8=;
        b=TO0MoFQlrfS4+2kmnMyyG5Jz3x7ZQj0p/cjIZ2FIT/BBaPF0Zm8AFZTfzvhGOKFlys
         YGaXaFuhEX9IbqWD4WxUhpAb5j+8tU22FmKokDTyZjGBYB2rTBOwcIjX3ixPCeaflk+j
         7W+8sgwpWlvVCG8cxB2cTZNzqnFB6mHYdADiQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728578908; x=1729183708;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=JQiBNBCGQr4DG/5Y4cFeaMzRBxYQ2OiJzW//b3dghb8=;
        b=ZT38DaZd7/w9fYQUgAiUiSrfd20+EpZcUZ39RdtnF8uus87aaxruHmy8xW7Q0JuOyr
         MiWpv+wylaN0j26rxo54Y7Zbc98HZaOY80LMIgNhiI5KUGoRi0n/iqWhTRj8h8kMGWr+
         c0uO6E1zEEvufGpuzMJA5rZIMfJ09/PnlaAI2FFtOA0PLxvI/aQKt3NtuLQOMvwFX3Oz
         IcM+g79BzuRubHt9cqwbuT9BLNm3KwgAd9l0qxenBUkq6KeOiFTmCEo/Okxtk35CzjxF
         UFHqX/GLkfUfJsOna0DS5OdcXhOmyPATFFRX36ykfxP+4kPoFzBzWKig3GHUEjtQv6CX
         T88g==
X-Forwarded-Encrypted: i=1; AJvYcCUYhrejQUqH4PNwtziz8gnoVx1HiNZXVUgtOcSlIhCV0fijUpLtCt9PLI4mg/t+IWbyOGsBGGoUI3o=@vger.kernel.org
X-Gm-Message-State: AOJu0YydJTe00GeZr25D/k7Qh/ZTEet0V8Q6JG4w3EgyXcrsD98eaxB2
	HYHi4kNUZsi0Na3fuO5pH88VYylpjrReFljdvAMQ4oNTBVojdLrGVCIIkdiiQpIyUveqtAHJ7Ha
	GhIY=
X-Google-Smtp-Source: AGHT+IFGGaZg4kDlZEiJcLyIHOgLU8F68K4nU3H9tD/7fHCrwfDkdZ1wGu7FhnKMZ2GV6jZK3l91pA==
X-Received: by 2002:a17:907:d861:b0:a99:4ecc:f535 with SMTP id a640c23a62f3a-a998d117e15mr642330966b.11.1728578908330;
        Thu, 10 Oct 2024 09:48:28 -0700 (PDT)
Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com. [209.85.218.42])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a99a7ec536dsm112248866b.43.2024.10.10.09.48.27
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Oct 2024 09:48:27 -0700 (PDT)
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-a9952ea05c5so188966866b.2
        for <linux-xfs@vger.kernel.org>; Thu, 10 Oct 2024 09:48:27 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCXnwJ74XcglxfFV+ScO0t1XB3HyljpCjIC299PmefwRjhsZtBa/nfWpvKuKv7VPSlrzqBci/h855e0=@vger.kernel.org
X-Received: by 2002:a17:907:f75a:b0:a99:4987:8878 with SMTP id
 a640c23a62f3a-a998d1a2576mr630672766b.15.1728578907436; Thu, 10 Oct 2024
 09:48:27 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <ftxj7acikfuwhh2spky4jlnqdob7vjxxxtoibq5ekiriirrxy2@uer37e2phsit>
In-Reply-To: <ftxj7acikfuwhh2spky4jlnqdob7vjxxxtoibq5ekiriirrxy2@uer37e2phsit>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 10 Oct 2024 09:48:11 -0700
X-Gmail-Original-Message-ID: <CAHk-=wgBmW4hs+6PwKNDx8uwhOE2arV9FhuwSOp3_mBuL6wnSw@mail.gmail.com>
Message-ID: <CAHk-=wgBmW4hs+6PwKNDx8uwhOE2arV9FhuwSOp3_mBuL6wnSw@mail.gmail.com>
Subject: Re: [GIT PULL] xfs: bug fixes for 6.12-rc3
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Thu, 10 Oct 2024 at 04:35, Carlos Maiolino <cem@kernel.org> wrote:
>
> These patches are in linux-next for a couple days, already, and nothing got
> reported so far, other than a short hash on a Fixes tag, which I fixed and
> rebased the tree today before submitting the patches.

Pulled.

However, please don't rebase over unimportant stylistic issues. Keep
last-minute rebasing for MAJOR things - bad bugs that cause active
huge issues. Not some pointless cleanliness warning.

               Linus

Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F14A33E51E2
	for <linux-xfs@vger.kernel.org>; Wed,  8 Jul 2026 20:40:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783543252; cv=pass; b=us+K2NVKLYKnk1WCLYS9dQNQxVk+IYPVjnHizPYT8DoC1k+5Qe0XZVCoYySJdAERMxx4jvXMSyXds/+WYreUcKfBKeOaeYLYOnF/J8w9afo4UIOfLkwYD7FWa3iNsUT34nxirXMYwS1gDgXJZESk4vxcqRUG2XYTYsVsaYvs+LQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783543252; c=relaxed/simple;
	bh=eg8AbooWrchGP+5vFOVL+ntc126BYRP3715RVKn8f0A=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=FXtBEdpqbA1csypbt4ux9G5veXtoQA7+Fqn7dX44aWiUcEaYeWXrC3KgPwSw/m/sdk9OE8897RN105RbP4OArRHeiI+pjBPtwJJmEJGc06hgGpswaCdx1TuMzakjli6OQBI5xDUrTQEHF3JsgSrQpVqhpadu8+Q1AuD/x2e2RGw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lQ+cZroD; arc=pass smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lQ+cZroD"
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-493c1950518so1506945e9.1
        for <linux-xfs@vger.kernel.org>; Wed, 08 Jul 2026 13:40:49 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1783543248; cv=none;
        d=google.com; s=arc-20260327;
        b=dJAaKb2xeNUVhGaJDdZeHYMzIn6/bjMZf78uIiwz6vQXLn6EUiGHxNBxoRgHtNaUr2
         KGIgSLD5Q44HHmSbeFICuXQsJyFfssN/TjVGXTodJLNf/NPcY1fpDiMnE0WCZBCLpEwu
         RG4LA7DCpAh4pQWiVSEO7aOPye0c5yTz4yeJjPMlR6bBdbKXb4qEU6AX16Cdn5oXDSLe
         IuL71OcFrEmepW00+s8dDTrj0qGTcU7SYA1aqW+STElPvQaG7VGDkfaFOnPq9V6WxXAO
         KjK2KHTsx57vQnejtBwlhMDNMxBIQXfp5XCF0w6iDgqpHDgzn/tx6mmTFn3RIGiXII8H
         TTXg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=HV9dnVAAaywBkhcRiF+JFXkn347nONXaAEt0CLNpRQI=;
        fh=oK94SiHxZ1AdH1w6/gypCCzXRj5BznQdpyewGpsN0oQ=;
        b=WHYgnUEDFjOOsNKJWSkLE+Z3n/NQiujAiG0HeDuJJvqpUrJ60B/vMEdDXqQt5G+JHi
         F2VuhhsEfryMH+1sX05Vx5NyWItqgtkE0tGo+COvtSoqqFF/mTeZ/7bctjoinbjBpWHU
         2rHK5Vm6LFZ1gN2oiGwKUgXvRWTIOzEzfZR1gUUa2i5hXItB3n4werhPcwV7d4SkY4Rl
         uBUVjCQ1tCK6bLuKv+8xT9aChY8Rd9AuG0lEkip3IgDoozf3GhA+tFKRZFDxtMIKEitx
         2Gde1uXUY2MqCkYIKjBjBlZjZAlIw4MNXR5z2rybFgFzm0vDx0BWb1BHuk0uFSwQyyZS
         tY8A==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783543248; x=1784148048; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=HV9dnVAAaywBkhcRiF+JFXkn347nONXaAEt0CLNpRQI=;
        b=lQ+cZroD0jZkScclfjtWa00kCjT+PAxETGJyEK7+MoJOgGcJfOBwrgUTGSH11L1ZOe
         JQmuiQ3lAyVZSLg8RH8T5Ry6no97tde53KzCbFfeiQU38p76utIP5b5/jerLTgEmMtio
         OPwiSKZeQwIOz9toPfuJ8CNEp+AyhddX0/DivgP++tTSKhrSYxKKsOajD02y//9R63I0
         twlBY3cXsJ1W8dHhCHwWqXvAt+Tx2hse5BzZBkPiPPW0MATnPGnCwTOD8jhhSHNSJxrC
         dERfkOhqyDcn3kCkxlXO7sKzhe4vZEP9p/DFZwjtTtnpxzvUPiMmdpx17RC/AOWxlcOd
         TDRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783543248; x=1784148048;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=HV9dnVAAaywBkhcRiF+JFXkn347nONXaAEt0CLNpRQI=;
        b=pliY/pgJc6VfWMuQ8DESh2U6ZOLx5LXOfpB5kQCmUKo99MEzL/eMcQ4thZgU5QyLkN
         SxIR8cmqU/fjWplrfms4FsMpEiiJA65LAXpNqS5Q7cnsm5Zg5NsHx8YBykwN4L29hkIT
         zPlDhmoE6IYTg0YIydLnQBiIeNyGMD0FZnR9KwFoBfoH9iUEBYzk0mPALs6W/ezEVjgY
         6a/VTB0JuxkgIT4+7SIimUSswSJGpGJoLLuHbNnrFxHtHDDaWrtI39NtFvkMyeFd3pPP
         QtEW2Mz1V2jTXEacQDxfyzMXA1uMKi75cgjbrHHyJ43AeVE87q+/E0nETf3eDAIg8uDw
         b8Sw==
X-Forwarded-Encrypted: i=1; AHgh+RpJMksehUW/UMYvQBIHFK/lGyAxebm3scicW5JNF7anp0orFWopm+0x1L+3x/ECV+U5WzlEWGC+BXY=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw5jXBctAdgjJdCHb54KLECrRoLCFQzzfeyOdj6l/Vac5buBJx3
	gXWusB2182plhcbwYmz6bOnbQi4yLwNUa3fSdGf8LN0EzIx+gjFjTUcl0dqKjBhu7hbqRKSKBKy
	7wj3sefd6+XgUitGr+pcunsi3KwNKtfM=
X-Gm-Gg: AfdE7ckCrmcCDDLECwCofLhixnPaa6ErxeHO1CD/H0Yp8LMyuipw45aVf3Y+aKN2BIf
	PhWNhntah2SGk8OU2YyyQem7KoGjhAq+//Lrg/ipdYPTTkQb0I7/cqcs5Y8Zm5r1kfg2rRP13DA
	6vX/0SLmS8PQXeauefCSYNIyvMu7nJ/jtpRDZKXrQJzO4PyPPEKgoXTnX7cZsoN3dGdZFFw6zkg
	iZZyc7SpKARL8AlChWM+xqa9QcWIRPJd914WDd+TyeC+iJOEA/+ULzhGIOtOwI+X+2ROKUt6Ewo
	hKDJaQoKibZ562vJSeWpzXxBUU7FHLB6VA8mzfIUN/ULo1OwSmWk7uKWMmTeWhc=
X-Received: by 2002:a05:600c:34ce:b0:47d:52ef:c572 with SMTP id
 5b1f17b1804b1-493e1008fb8mr97418115e9.1.1783543248191; Wed, 08 Jul 2026
 13:40:48 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260520030357.679687-1-yi.zhang@huaweicloud.com> <20260520030357.679687-5-yi.zhang@huaweicloud.com>
In-Reply-To: <20260520030357.679687-5-yi.zhang@huaweicloud.com>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Wed, 8 Jul 2026 13:40:36 -0700
X-Gm-Features: AUfX_mxh6mA1e0Oybe36TV4asjWw4ulMFew2ORY6N1hqoUi0VoqQJD26mBrzs8g
Message-ID: <CAJnrk1aBgAFu15wp3L-V34OU3i+AtMiDqjvhHtO=+ZMJ4yvfLQ@mail.gmail.com>
Subject: Re: [PATCH v2 4/5] iomap: fix out-of-bounds bitmap_set() with
 zero-length range
To: Zhang Yi <yi.zhang@huaweicloud.com>
Cc: linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org, 
	linux-ext4@vger.kernel.org, brauner@kernel.org, djwong@kernel.org, 
	hch@infradead.org, yi.zhang@huawei.com, yizhang089@gmail.com, 
	yangerkun@huawei.com, yukuai@fnnas.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, May 19, 2026 at 8:14=E2=80=AFPM Zhang Yi <yi.zhang@huaweicloud.com>=
 wrote:
>
> From: Zhang Yi <yi.zhang@huawei.com>
>
> ifs_set_range_dirty() and ifs_set_range_uptodate() compute last_blk
> as (off + len - 1) >> i_blkbits.  When off is 0 and len is 0, the
> unsigned subtraction underflows to SIZE_MAX, producing a huge
> last_blk and nr_blks value that causes bitmap_set() to write far
> beyond the ifs->state allocation.
>
> Regarding ifs_set_range_uptodate(), it is temporarily safe because len
> cannot be passed in as 0. However, for ifs_set_range_dirty() this is
> reachable from __iomap_write_end(): when copy_folio_from_iter_atomic()
> returns 0 (e.g. user buffer fault) and the folio is already uptodate,
> the guard at the top of __iomap_write_end() does not trigger because
> !folio_test_uptodate() is false, and iomap_set_range_dirty() is called
> with copied =3D=3D 0.
>
> Add a !len guard to both functions before the computation, so that a
> zero-length range is a no-op.
>
> Fixes: 4ce02c679722 ("iomap: Add per-block dirty state tracking to improv=
e performance")
> Cc: <stable@vger.kernel.org> # v6.6
> Signed-off-by: Zhang Yi <yi.zhang@huawei.com>

Reviewed-by: Joanne Koong <joannelkoong@gmail.com>

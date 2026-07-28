Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FFB045A285
	for <linux-xfs@vger.kernel.org>; Tue, 28 Jul 2026 19:07:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785265646; cv=pass; b=CsoKONivzczDE18leXC83/WFFxodJmIbFppigUfPg1VRppgvaxPc4GfQCrGs1oKk2QrXK66S3ut6b9yksnlFktxmOUlJhy9ijcmqnvZTomZBjNbXOJLZ3FwC4mzuFvWoduOnbSNUKVdlZ/BipWlOl9liZe9jMq9hp8LP1/W3g6s=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785265646; c=relaxed/simple;
	bh=SH2IHLDio+NDuaGDNJz4MlNmJaY2jeiniMqmqafc/Kg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=V6joZq/4Qd6Nl4etc+YY61TVYa4DUYVQiTxNhFx6dBYjINCKlL6QIaBsumJBrCogZfqF2TPrmVKkM+SKHHR0SeR05PVIvew+RWxY8b2Bj6Ui8sgjMMO0AhiuE9xzl2DILbTxUoY+iiohqVWhcjm8Za+ZkHnBTSpTJ2TdE2d1pSg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mTlZ0aDI; arc=pass smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mTlZ0aDI"
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-495590dde14so2238825e9.0
        for <linux-xfs@vger.kernel.org>; Tue, 28 Jul 2026 12:07:23 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785265642; cv=none;
        d=google.com; s=arc-20260327;
        b=pMgZ58yq1AAb3Gb6Mw5N9IFcD27jSMYh722RHbjFaTse5XRIF1wMiKjHtGgHEddM9u
         JEeI5k11S+1kk5p6p/AZfGdqKvZzxVNIEoEpeSbU6cTehqiwgHr4odiDVOALxysxqwYh
         ozG2kYSx6sMXt1u1JJzTp9TuCkemCYu7SO5BaUWR9Pf6r9uXZBVhundgWkUfrVQgQcLU
         uhx3h5MwUR1ThS2vHoPCCU3Z29czRWoHRmlbbdHk/HCHwMi6Hlojqi6ed26vULqjTd7R
         WawjDadfAH815/bbQIE/3d0FO4mpnqUDCIvh2yOMi9OJw6RrKJDhE3hMzGMfwLl1ds2c
         5NiQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=SH2IHLDio+NDuaGDNJz4MlNmJaY2jeiniMqmqafc/Kg=;
        fh=/tfSrTeBfVm9AX0XXKwvoBpr4MBGmpZGANVhR5aCOqQ=;
        b=JdMznrDortKCjjMUh2pHOZLl6yO+fbnhopzERhCk4ZwZnlZeep5GVnz2K6Y/fBBFvA
         /dTMAvcjF8W3CJtsBRvWyqzeavPSDx4q4fKv+Lh0SRlp27AxO1eOyLB1sOzFr7TJxKuA
         EUYLBChoJPwO426LWRwDey9+Z3634kSVCLRP3NNFdWDST3ccdIJeuaQmykwb46lbm+op
         cSrcAr7nRnLycYTx4o0RWk31OsWH5DKDB/1tFeX0NCToqWM1jIeo8yZRjejjmVcgrH/L
         VJN/neKawI7Sc96hhb0ejqOR8XliuiJCq7qEpce2Z9r88O/Zl3QxpBGPTM6pO7AIO028
         DFBA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785265642; x=1785870442; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=SH2IHLDio+NDuaGDNJz4MlNmJaY2jeiniMqmqafc/Kg=;
        b=mTlZ0aDIPeSlD5uBkRFD1KhBaSmjGdptcbegN+U/970FFglW+eF51LqYEuuCVhL8fS
         cfZwPSOgKwolHtF10TwsfD7/COTlj+DtC6Cj3gRJUCf/uUX6JCLd7tVJI887nb769U0D
         wGys03GeNCNPl8HzxAfvVKl6ab1ilSuJVCbptObQSsXOf6lyeqjt7mBNgnjcmjzTmHJk
         4kLdccyYVS/inDYC8hliydwJJeaR/v3KkZcBEc7vQVLo+6dJ+pcZxTbpfv5jjphuAK93
         NcE/+9zb/kNR7y47rQxMz8/R62kKXvMciadtm034lpKXOt+dhX2826x2arIrWdBEmBrn
         FKyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785265642; x=1785870442;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=SH2IHLDio+NDuaGDNJz4MlNmJaY2jeiniMqmqafc/Kg=;
        b=Ietgv0mciAHFKFDwJwhfEnVtLYMY8dU3R4xAYjg0UnMLM0N0uVv3hWdSMTyN+guGBq
         YREDQ6uVEieygbEAIcIPu6WVUqi3i15DpLXkYDXBRL/Hjr+7YP9srexts3e/HEudj0Jv
         dw2XC2+VWe+l687QGwByGFhmoqPDu2DNsFMmpMauP0Ry3b535SKitKcBeaEtkIXEq+bS
         TXLde+UqsezRK8IvBYH81sI8OHcDGPqz+Jc9qcZX8xp/fqklIQ2qIdQEITDNKW5iNNHp
         8dHaQ05AnTLsNeMH4qYt7dzkl/mgZEYN+Amg/OCiroHDB30n9+4nY7ZyUJjS0BnA2FYU
         PUPA==
X-Forwarded-Encrypted: i=1; AHgh+RpWpCSuOdAdDgQB6IBY8V+Pw27gbYc8+Z6MuDfrxawT26NFmj+2sNUqMpAhQwQFbjsM5v2RGxsl5Rg=@vger.kernel.org
X-Gm-Message-State: AOJu0YxZ52VTVWLK1cQoUU5E+oIyQ5TGYtcFA1TKzUCKMUZZuApfEXuj
	O3IpgA3pdjoUSDZXVve9uCDpfkuMF0EzsY35OLouHaE3cQx+AC7C6Br322VFLrzweIJNuLIWlQn
	puGsHcrnCD6aYHOYq6wZDsJq7WwqT3sg=
X-Gm-Gg: AR+sD115rRrD6cSrvjVTq7jzYJG4ka3c0tPK7dmqn2+X/6Lv0lDMO9pNXqJZgX1KKQ2
	UItIb3NxOMQpkOfn+6Zt4ojkEDfDZFSznBj/tRAVDckYrpSmcOI8i4r7BLU4fCKHv/SM94EKzWz
	NlUaLDR7vweHZhuVJBj7X+9rFJnhPU20jR5d7JQiSjYuJPi/ItYL/tEnLdNXeYt2b5Sh6LlF+kt
	T4WQ/p+tkxkcnO5q2EushmcC5nhG+FkJiTnvFpgKCpZFDQy2AlqWBaAOiAkr0SYvq6ykXjx5dqo
	eHJi0FDKFFOi6XZyx7Bj7p/K3m/5MeJnlyUiDW5WNw==
X-Received: by 2002:a05:600c:470d:b0:496:c249:dd9b with SMTP id
 5b1f17b1804b1-496c6431be1mr40349165e9.13.1785265641769; Tue, 28 Jul 2026
 12:07:21 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260728183005.92395-1-bfoster@redhat.com>
In-Reply-To: <20260728183005.92395-1-bfoster@redhat.com>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Tue, 28 Jul 2026 12:07:10 -0700
X-Gm-Features: AUfX_mxVO9lB7sxDP3N-Wyk1cZUT_me-dSPmxEW5UopG3XjcAk33ZqkzbDUJiQs
Message-ID: <CAJnrk1Z=qohEjesFFn-YbmU0mqSPkMH_Jy+E6qSCw4pM8niPhw@mail.gmail.com>
Subject: Re: [PATCH] iomap: release the folio batch on iomap callback failures
To: Brian Foster <bfoster@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org, hch@lst.de, 
	djwong@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 28, 2026 at 11:30=E2=80=AFAM Brian Foster <bfoster@redhat.com> =
wrote:
>
> A sashiko review of an unrelated patch points out that the folio
> batch mechanism used for iomap zero range fails to release the batch
> in a couple error scenarios. If either calls to ->iomap_end() or
> ->iomap_begin() fail, the direct return paths bypass the batch
> cleanup.
>
> The ->iomap_end() case is not a practical issue at the moment
> because there is no user of the mechanism that returns an error from
> this path. The ->iomap_begin() case is theoretically possible
> because XFS can invoke the fill helper and error out at various
> points thereafter. This subtly complicates things because XFS does
> not transfer iomap_flags to the iomap data structure in the error
> path.
>
> To deal with both of these issues, first make sure to invoke the
> cleanup helper in the error path for either fs callback. Second,
> update the helper to clear the flag unconditionally and release the
> batch so long as it is populated. This more clearly delineates the
> purpose of the flag to control the I/O path and not necessarily the
> status of the fbatch, so add a comment around this as well.
>
> Reported-by: Sashiko <sashiko-bot@kernel.org>
> Assisted-by: LLM
> Fixes: 395ed1ef0012 ("iomap: optional zero range dirty folio processing")
> Signed-off-by: Brian Foster <bfoster@redhat.com>
> ---
>
> As noted here[1], I'm aware this conflicts with the outstanding iomap
> iter rework. I'm happy to rebase onto that if that is ultimately
> preferred. I've got at least one vote to get this in sooner, so this
> version is based on 7.2-rc5.
>

Hi Brian,

As I understand your analysis of the bug in [1], given that it's an
unlikely / second-order scenario nobody is hitting in reality, maybe
it'd be easiest if I fold this patch into the iomap iter rework series
as a preparatory patch (keeping your authorship and Fixes: tag), make
the needed changes in the iomap iter series to be compatible with your
patch, and then submit everything together to the vfs-7.3.iomap branch
as v5 of the series? I think that avoids the nontrivial merge conflict
Christian/Stephen would have to deal with.

Alternatively, if you prefer to have this as part of 7.2, I can send a
v5 of the series to try minimizing the conflict, and then send
Christian or Stephen a diff for how to resolve the merge when they hit
it.

Thanks,
Joanne

[1] https://lore.kernel.org/linux-fsdevel/amjztG-DisHYbV9W@bfoster/

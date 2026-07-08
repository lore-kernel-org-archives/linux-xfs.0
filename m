Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CA293D093B
	for <linux-xfs@vger.kernel.org>; Wed,  8 Jul 2026 20:57:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.221.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783544247; cv=pass; b=u14xazAaaEOl6B/GlnV8oGnwfAuCk8qQOx4tmteQjzx4+vxLPuPjALa7uyAXT4HHSjLr0uowvmp26dDgchkJUL26jIEg5MTSW85uIm46RO3S98eVLZsZrscT1dekB4R2FR+DHgyNaPjpoztw9VBmj1wXxat0QXgDrfuf4sg1n/A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783544247; c=relaxed/simple;
	bh=fQxqZpmVN2OjS/KTdRomuIujK83Xx3uJi3ZT6vlrZ5Q=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=dOvhXPkx2yr9rsOcqBlGlblqZFaS/pxeYdrEA8w3dz6FKETBXbzJVhG9GVawXk/8Ym6++mCU47CDbw8LerME17lgkWvlbi3460UXqBkfJ7uNLh04XrBTCJMhGka53q1RwVqUMm9v1MxilCHnXhceD+P2mlj2EiASWHr+sQ5uCPU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VRGL3DYF; arc=pass smtp.client-ip=209.85.221.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VRGL3DYF"
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-4759b4f0897so689046f8f.1
        for <linux-xfs@vger.kernel.org>; Wed, 08 Jul 2026 13:57:25 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1783544244; cv=none;
        d=google.com; s=arc-20260327;
        b=aSfljyfxLU7Vje9xKPKgn+eSBaTcaNuVLyUK7cN50cEjn8Qo9qAzEMkVQ6na1pfUle
         0qpG+1+M6nzy2Np/ci476O00I8+79BKvfiki4WwzqFsVSWdv1uu98IrLnOjVUBHwm46p
         z9xGiH4G2nInj+Svb3yZ/pmoOPUMAkUeLp801U1YTtPZNklMnR0MaAWc/XHfoZDb5oUy
         AAcsm5WLjjLWsAlB9CzHSGgAEi88FlbFRlHHajy81vYdiQFm+4sw8/jjvkOe6vXJw7Eh
         IHqfc/BcICKpoa+K+cZg9g6aB8i0p+o/cZQ9/ltdCCiV4gVFqmXmyU/a4LpLHERxlakU
         Uocg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=fQxqZpmVN2OjS/KTdRomuIujK83Xx3uJi3ZT6vlrZ5Q=;
        fh=TKXNRPH1SdQxNaruGIZyaYy23b46rq7/dxTx6UJnMEk=;
        b=rGqApKkkUCItlgxlyCONY6eoQwa8aGVScKxwEUpaLWA/H8tAPYQEyrdIZFHGUpr91m
         Amqu116a4zqeiwzzjlvDoz2SzZFtvgCbSjCh014DkiV6qvJLdM0pVSu7QtXfpMcPmsZC
         Lb73kw51DZH3LPBU8oVytS1lyG/U74SMphV+W7f+pbjKSKziAgsSVMDGNM7ApC6lfXuR
         kFV0algbXNS21Tee0aSv7kZv+AtMZ7ROeWatI5dXSudiyZkfN9+b49PvhGJmn8DVl5b1
         HQ94yzn+T+L+bsD+bQcin4ubdAe38egIgO/bLGc4HtuoTyuRo2Bjv+Y4rtkLhoz5X0jh
         o88Q==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783544244; x=1784149044; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=fQxqZpmVN2OjS/KTdRomuIujK83Xx3uJi3ZT6vlrZ5Q=;
        b=VRGL3DYF3/HWVEPQi7js832v1iGwNNDxbVIjK2dD/vjclbwE7Q+2/dIWXK/OovusOG
         zS5AKlAaNWBdp785L5E0BUmEy2qVjTMdECIWVBy9b4MuZijB8M4srfZlOx59GhblSRse
         4mHQ/wfv9+5p34DqzI/Vygjgonp5w3jF3xtaGDtGEoT2oz6bAM/BO8NQ1Ywx90EdbnR3
         1vvIbj9Kj/7tVK0XcKg8X3s2403H1aGOHVBtIMrmA/gzhnd6GEmW/nVUOjnMsxb/qn29
         5UWPHdpFL37BJWWrnrGpwQWuGKUCC7VSyRnM0wrTiGDsgjw7wEJQSudH1V+cqA/2v9fW
         13vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783544244; x=1784149044;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=fQxqZpmVN2OjS/KTdRomuIujK83Xx3uJi3ZT6vlrZ5Q=;
        b=F9R9x9/p+YjXaMtddhWu4khuzSvBBOVmnTz5AdlRCY6cAqzXQ+NYLazIOITRA5adAi
         8J5y720uVKQ8bRyjpn3jtiZGP/pqUQQ7MJnE6kqpa20pL4ngmnEr5L5NhKPLOAU42SlB
         Kme7M5oQvpw1DLR1AVWWqlRNWDg0ZCYJABbzLH/JsMfq4XzT3lo2OzfjfCYBXG5js7SL
         X6tqlSrGIvAIVBIPdjbu5isPDwmXUdYieOJKbO7nh21tK85gNaO+xMEchwVZ3yl3VRK4
         rhBn62fxJgAcP2qcp6h9dYPk8QkF9Kju88JKkKgYgmsWePBM/OwQHhTVURvrpTHP6QRe
         A/AQ==
X-Forwarded-Encrypted: i=1; AHgh+RoDiBsI5JU+A4EtuASx3oW7ViJT/NZwcQ8WDLgSy1BZjK2a6RtZmuBe1GvcIuijHt1PG/yGcbj0tgw=@vger.kernel.org
X-Gm-Message-State: AOJu0YzIdRToF0n6es8VVTa1IBGOr0Q7UtqQ/VLBUnlGf6ByFy+OUres
	uCux9Fc7st0aBGxwnrtAhsaaHG4xceZErp2A1rUZGK/MyPOGEEqI4pijugA8URT/gRp1BSxUQY3
	EAqYV2Gpxrr3tFw++2zEyi9j2DsCB3xQ=
X-Gm-Gg: AfdE7cnP4UnRvez1QxBkFC3Qtwxb3XoOUk1h04Uxk3/v0Z6HdxG22Qa7ygz6GQlLyEn
	nh4Dd+GiAdgW0hjDMXFOknYbLze1t/32QevapvqO2qbGe9uK/iy1wTGk52PQN8t/iSwmnxE85WA
	fcJXoW2Eqb8Ou9DNFcFqLQrTOqCFSA0KnLabLXGAUbDPUGDppt3d3jVz2QBRoUEYdTeqPpcFREx
	AmLKTRK2Gsmft6AxeQ5a9ij3Z82yHEgYDYZIlMv1MK4DYJdPb9iLAIta4wC83EzHgkymTL0R5S4
	isPpZpYwJsQilS4338FAF2H8FjxxbQ6MVao1dW5pYqWBAOaUqlK3
X-Received: by 2002:a05:6000:2004:b0:47a:c103:8a2e with SMTP id
 ffacd0b85a97d-47df0808ff0mr4522829f8f.45.1783544244470; Wed, 08 Jul 2026
 13:57:24 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260520030357.679687-1-yi.zhang@huaweicloud.com> <20260520030357.679687-2-yi.zhang@huaweicloud.com>
In-Reply-To: <20260520030357.679687-2-yi.zhang@huaweicloud.com>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Wed, 8 Jul 2026 13:57:12 -0700
X-Gm-Features: AUfX_myQ8YTw0YdCEbZNt9d5CTUFLRbMZHIi911QIv69S8S5We_R1LPqmYg6pLQ
Message-ID: <CAJnrk1ZnO50z7C_e0y-0SVUXtd5S39VMsWfzuwD4LEHmuZw_wg@mail.gmail.com>
Subject: Re: [PATCH v2 1/5] iomap: correct the range of a partial dirty clear
To: Zhang Yi <yi.zhang@huaweicloud.com>
Cc: linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org, 
	linux-ext4@vger.kernel.org, brauner@kernel.org, djwong@kernel.org, 
	hch@infradead.org, yi.zhang@huawei.com, yizhang089@gmail.com, 
	yangerkun@huawei.com, yukuai@fnnas.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, May 19, 2026 at 8:09=E2=80=AFPM Zhang Yi <yi.zhang@huaweicloud.com>=
 wrote:
>
> From: Zhang Yi <yi.zhang@huawei.com>
>
> The block range calculation in ifs_clear_range_dirty() is incorrect when
> partially clearing a range in a folio. We cannot clear the dirty bit of
> the first block or the last block if the start or end offset is not
> blocksize-aligned. This has not yet caused any issues since we always
> clear a whole folio in iomap_writeback_folio().

If this isn't currently reachable, does this still need the stable@
tag? My understanding from the stable document [1] is that "it must
either fix a real bug that bothers people or just add a device ID"?
[1]

>
> Fix this by rounding up the first block to blocksize alignment, and
> calculate the last block by rounding down (using truncation). Correct
> the nr_blks calculation accordingly.
>
> Fixes: 4ce02c679722 ("iomap: Add per-block dirty state tracking to improv=
e performance")
> Cc: <stable@vger.kernel.org> # v6.6
> Signed-off-by: Zhang Yi <yi.zhang@huawei.com>

Reviewed-by: Joanne Koong <joannelkoong@gmail.com>

Thanks,
Joanne

[1] https://www.kernel.org/doc/Documentation/process/stable-kernel-rules.rs=
t

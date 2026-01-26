Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86CEA29DB65
	for <linux-xfs@vger.kernel.org>; Mon, 26 Jan 2026 10:59:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769425185; cv=pass; b=JtoFZMW382w08az9uWNwalpsJKeq5BdVSNl/1ywTyqp6zxSOMspNSg1uBAKptH3YTS7deKxwQMbzc4Fqg88ElMv9xRn9YaZ7YtxQTAbCjnBVV6uA5j9noxeVIS+7aF+0Q5+r5TMH/eauHnyE2Z4Nr2+L/RfwtVTnTO++02jo7cQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769425185; c=relaxed/simple;
	bh=2XstvkdlueVaAOIoVw3LWY83uMKUvGOF/yUUwA5uchQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=e2leX7YSVP2ATAuQVM1tPfJY54CqKsLnPLDrXL6yTl3XRj0ae4j1HXdwBZkTdfAbnJzTX8TU2Ancktnyb8EoYE1H0LclO0+iSfcW5TY4AI9+vfrEuHavlxSkwtd9e7KPVygtcc6KXlU/KdtCjt43hqxC20nI0BBCF3d8uieSvfw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UvLUkCn+; arc=pass smtp.client-ip=209.85.208.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UvLUkCn+"
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-64bea6c5819so6529921a12.3
        for <linux-xfs@vger.kernel.org>; Mon, 26 Jan 2026 02:59:44 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769425183; cv=none;
        d=google.com; s=arc-20240605;
        b=EOyco3VwrBzPSC6FEVTPRjtuf5WkEuXpDmZf5qFJAlj2r7brG66EMATcvzpsU5hYXl
         GW9ray537OZozV4Y7hi4kag3Iz3R3RYe5/WwVPTOxCm1k20gPgdp1f6Ad7tJxhE8+6Va
         6DTGcJS2D3zTPb0zsXGrJZFU3bBBIs6jgRfZollaEWpbtkNvvnhYX7FqegS/Dd1oDOPk
         y58e+bSxRBuKtZA8Kug6uhWrXQA3QD/sFdmXQ74e+06fOgZsRbtC0FrbzQiZ0qwUfUqd
         AbyaPNTyaEGhh8IRsChs460ygk4JaBs1A177RYQCUSdvT1Oqu5gJUwoVJJflM6rBMQ8s
         KnrA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=2XstvkdlueVaAOIoVw3LWY83uMKUvGOF/yUUwA5uchQ=;
        fh=+XikQZOP5ZpnqCueRjKaRpqfw68lCVzIGuYoqlmuNVY=;
        b=fAZGFSTAV9j4hLWh5V+iSpXq4Q06Q6Bjw6At6e+ERdXgE5S9kFDQs50I2v88P6Q8vQ
         ZH6W+D2AghCFBrVgfaddZne6eRqWAdPUcWeSo/1iU0r/9ITuswrDqHQ7jmT9GB7S8y71
         LcVyixUxQObxGz+AE21TmDvQYmVDWusQ6pNjoBLQOifZ9ipgb6o1oBfGvlSVuFh+cWdM
         gDB0WoQe/akG5jnE82R+pZNt/ccW7wp4Eq/67k2tErBoPCJi9jtIw16Cr5aFnFUmXUmh
         SqOBWPBi/HlPQ69vfClPPKmD+OvVWs249ZfAqLynnTW6acOeeyB1JBNO/nxxFuP80GBH
         Z4Aw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769425183; x=1770029983; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=2XstvkdlueVaAOIoVw3LWY83uMKUvGOF/yUUwA5uchQ=;
        b=UvLUkCn+h2NnvsEy0eDGcNyPBej95rmaEmrsJr53oY+ZfBVQiN7XREwoA9lZxCDveE
         g/K4Y51QQq8hD1fkFvRHAjCTbTw81EvzbtGuF/lbdGOaALWPu0sT5g8yG+aLQk3XqYSW
         vNJsxnGS46f+VvoLSokq+IELkEC/mIvjgC0ZKM2Gr0GR2De89gW7HaFyYobZvdCuKP2x
         CjoqVVK6y1Rzmk79ME6vEbt0ZV0NXJvX4zp8RXJPVM7cEpDGCPcE4nwa8LyL5f6r8YwG
         C4fMaxg9xAcRDLJ53HDJLDAU6i8L72NPTR0xhoKFV6koPs3g+ZJVnn5p7zCvXLmZnhfO
         M/4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769425183; x=1770029983;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2XstvkdlueVaAOIoVw3LWY83uMKUvGOF/yUUwA5uchQ=;
        b=Nm3xzegyM7XdxVuR3b+nUs1AV4DR+Zyj++67hS0KhXKkGGwOjVKPZkYswuKPZ5NGdU
         Nmij7PSuWSBIuC8zkpC/QaIlz9x8M0p3GeyTWzEdE63PtTmieiP9LX9h+WzkamVuVkVu
         xPKdB4d4xOg+rrvjIRtO9W8EdUdM2wrt5hGzqm/Znfhqmrbs2W3zWvxOiV3cVPKz7bZo
         cNrjfiY6E0y59QCZdhUyztcfmlkzm0pS3e6YDTCTixhG6hP3B65EuTEVMTwAs8F4/n7+
         ym1F0u/I82iQksjr2LnyK3nh/+SzSkkLjhf7WVB4crJfKSdJOEoWHolF7jLSucjOBWXk
         LmhQ==
X-Forwarded-Encrypted: i=1; AJvYcCUyqpHzwlSJUkM/8fT4ZM9+Nw360gTLHuaZzNA80vZoRDqH1Axt+HbXXR8d+dmzWNyyg4D5SAdHMdM=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywy7J4U9wHtSDkhkkpkcKmfajEMEyVVqPVfNEur4IFr8ruetzv/
	qBR05diTgryB58u7v2xbqgz4eJ62Dj16XCYokckVqKci/3Tt/4GejvCenyWuHwWlgjqMBnB2crQ
	1LSEBX6cV4koR13zJMnU5j8RTZoRSog==
X-Gm-Gg: AZuq6aI6hzy95wdgDGgt2CgA8K2yZ1dI/oN3D8DIPWaLaoxQKKMX7D3Y6UQ4nq9Kt/b
	muvCOk/k4QkJDtX7JdDAhZrwXiYMeToDxrMCD9qrMawnmHTuln9/KYm6naJzRyAfTCNT5VD7sQq
	ACoSsM7Vt1tnx/bLgbMChB3Tg+tLTlpvP7gEd3a6MAQD599NIuLkIbq0tbquiciAJjHUrRQP9PS
	7/3+hF9PYtKKoM5hmDx/atSm29iz+qE4PayMxObcss6LVEoCvt+sGLv0b0fB/06JLckQyaAOk7S
	Ohn03HGXM69RSeq74Gss3svbBYvEVtjb3k8ZJyhUr+TtAAP7+xP6fxtAL4X2qDX4Fnh5
X-Received: by 2002:a05:6402:4415:b0:64d:1fcf:3eda with SMTP id
 4fb4d7f45d1cf-658706c6cb7mr2343964a12.22.1769425182768; Mon, 26 Jan 2026
 02:59:42 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260126055406.1421026-1-hch@lst.de> <20260126055406.1421026-3-hch@lst.de>
In-Reply-To: <20260126055406.1421026-3-hch@lst.de>
From: Anuj gupta <anuj1072538@gmail.com>
Date: Mon, 26 Jan 2026 16:29:04 +0530
X-Gm-Features: AZwV_QiJFF4lmS5bLHeIfBkzmZWxYPcftNw7YhZNZGQ56W_tH3yW56RnEjWskS0
Message-ID: <CACzX3Au+grRcDxYp1Kwd418+OgJdN8=mdB_DrSRvphP9KqW3LQ@mail.gmail.com>
Subject: Re: [PATCH 02/15] block: refactor get_contig_folio_len
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, Christian Brauner <brauner@kernel.org>, 
	"Darrick J. Wong" <djwong@kernel.org>, Carlos Maiolino <cem@kernel.org>, Qu Wenruo <wqu@suse.com>, 
	Al Viro <viro@zeniv.linux.org.uk>, linux-block@vger.kernel.org, 
	linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	Damien Le Moal <dlemoal@kernel.org>, Johannes Thumshirn <johannes.thumshirn@wdc.com>, 
	Anuj Gupta <anuj20.g@samsung.com>
Content-Type: text/plain; charset="UTF-8"

I sent this on the previous version, but FWIW
Reviewed-by: Anuj Gupta <anuj20.g@samsung.com>

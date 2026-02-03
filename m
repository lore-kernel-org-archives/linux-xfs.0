Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A327E201113
	for <linux-xfs@vger.kernel.org>; Tue,  3 Feb 2026 10:05:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770113153; cv=none; b=XIsDdUz9zBM98z/90k3r2cZrGerZhbxSwf3k+vr2tAfWOf2U/8bTVTGhdNJaNfu6LGVnBrm2jvl5hynYm6ySy3Rq8AHcuPL56A8hnySdr11bwzoe4hgJtKBKe2QJnmXuSM51XsppCnnyLq/X1cTrRLPiDlgg3S+K+S2t54kyQ/I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770113153; c=relaxed/simple;
	bh=OItMYGPQqHUE+urHop5qPqb1i6vjQEt+fmTKE7EtbcE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VuipV8qi0TGKU9UuffOpUi6HqhQiSEQ7ULhGrMI+Fb6Vewes/Iwz1erj/V12dzD1q7bcz6giNrXK5SiDRrzWxnStUsEuR/jaTvnIi7b/2vwU0BJdPSHu9rKmGiHKcX73PfTWsJhCCan0DGodKyOHk+CHQ0FCdLpKJbuu1Fcj+1I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RndNtDqa; arc=none smtp.client-ip=209.85.208.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RndNtDqa"
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-65814266b08so10739340a12.3
        for <linux-xfs@vger.kernel.org>; Tue, 03 Feb 2026 02:05:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770113150; x=1770717950; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GvrluIg2iCtRBY994OY5LcLdBsBGupkAkPLQLUuiFys=;
        b=RndNtDqacyDLzRJzsl8DE573zX9PCb4NpjT6mSbEQ7bRSlYs5IIbPTrsKr95rA/BZs
         +RYbEEaaqDc777HIHSyCHhfv+1d1xWzzBFepbmh9exIhwZzRhifmBsyf6H+hwI7O+lF5
         pSP+nJTmk+YMZX6wJsfzYKrhsVAH7DbYX3rF6P0mGUdwoG3N5US5zPWrcRGIylfjKP7f
         Lr6BeM0xveqR/hTecI0OQSgXkSQNO++j+TlexdyCTeU7SNACJhJ7+udbL4HZV+KQixnO
         WkDm2GNWjWKfEm98fY3HeLAIPssYyyP9P3kPRUsdzL/j5OZTqXTCKVAmMKE/EVmZv2Z1
         9E+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770113150; x=1770717950;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=GvrluIg2iCtRBY994OY5LcLdBsBGupkAkPLQLUuiFys=;
        b=ZI0WhmuKZhiOEHd1GVyDdj64nLdr7awkklGC+5IBi/rwFukeHxoiik5ssChGfDMf4U
         ag94ExmSlo3UjBMbwyogUFNxmqxio1FLG6Q+n0N8DjRmCzCGbx8BSimI82m5OZWmj+bk
         rCH/kmR6V2QVs9Vk3PChdt/MwKW2fN+ZWt1Lmna9fNvy3cvqa8CKOJayDkmzRmJUkmvD
         BWJFC+dBxmsGtYOvy2r8vAkLEdg33ibED3OxhVyDY8fKQVDKWssRR0KzZDjlcxg2GeQD
         ijXIi1ouwRx+i26Ed6llJAmQ4eT3NfD/IHXL+m+c5VUGHTw9JyBBN/6O+JKwX1SSuAIO
         fAKw==
X-Forwarded-Encrypted: i=1; AJvYcCUuu9SMdb9KG4AMkrZWq1CCiS72fA1Pt2YJb+ZVP884S++9V2WkbycpuKkOww7T8YZfLLN8fdlRK30=@vger.kernel.org
X-Gm-Message-State: AOJu0YyCtPYPYXtCkHIYGcY9090vaFxIOAEfhNrrM2KlNqUWtvkB6Pjq
	OePOuXzK9IJtnj5+lI2rgPw2UlaiatvOHM+ecHmybTw8VKqSypArBlRReOLFug==
X-Gm-Gg: AZuq6aKAipUP8tprOiQoxEzJRuEZbEa1IpHt8M8StBiMd0AWXVzyj6QmWTnfHYMjJ4f
	GSuF+RxdTwdT06PYYAPjsz3Sq8Z8hWBi9jgSp8g2C/VvTexbW5Ly7Lwn6PcTJhYAUVbiTy3G90t
	+J0EpG8qP8GrY70LEwCdhadYQ3DatAsKVS2FEKxHSH7mPx/83zf9ZnMmYmev4gGih4NsZDc3YI5
	cH97lMXe/5TeliZJbrhSC1dxQD3AowDG/GHavgv/fhgYz6gI9/5dnVZaVhB9oEmAYBmTBAFcidr
	LEHZvmWvOkuS70CwBy6VSAQF4TrlJM0Tgd1cd1fNvs0plgpdoQs89cuHmLKXVs3oLThchlWR6zA
	Tf1E7uFPkIPozSIqtGd89x526y3Uzn2pz05KYCZNK6qWfXQVMDvu3r3cycgi2yZHDfRayFZWYO6
	d/4L88vq4=
X-Received: by 2002:a05:600c:628c:b0:47e:e8de:7420 with SMTP id 5b1f17b1804b1-482db47ce23mr183596905e9.22.1770106824499;
        Tue, 03 Feb 2026 00:20:24 -0800 (PST)
Received: from localhost ([212.73.77.104])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-483051286e0sm47463035e9.5.2026.02.03.00.20.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Feb 2026 00:20:22 -0800 (PST)
From: Askar Safin <safinaskar@gmail.com>
To: dhowells@redhat.com
Cc: axboe@kernel.dk,
	brauner@kernel.org,
	cem@kernel.org,
	djwong@kernel.org,
	hch@lst.de,
	kundan.kumar@samsung.com,
	linux-block@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	viro@zeniv.linux.org.uk,
	willy@infradead.org,
	wqu@suse.com
Subject: Re: [PATCH 03/14] iov_iter: extract a iov_iter_extract_bvecs helper from bio code
Date: Tue,  3 Feb 2026 11:20:16 +0300
Message-ID: <20260203082016.2824493-1-safinaskar@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <1763225.1769180226@warthog.procyon.org.uk>
References: <1763225.1769180226@warthog.procyon.org.uk>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

David Howells <dhowells@redhat.com>:
> vmsplice from there into process address
> space

You mean vmsplice from pipe? According to this comment
(but I didn't read actual code) vmsplice *from* pipe
(as opposed to vmsplice *to* pipe) is equivalent to
normal readv:

https://elixir.bootlin.com/linux/v6.19-rc5/source/fs/splice.c#L1500


-- 
Askar Safin

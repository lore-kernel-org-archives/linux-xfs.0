Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2387B192B8A
	for <linux-xfs@vger.kernel.org>; Mon, 23 Dec 2024 09:43:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734947000; cv=none; b=rzM88TLoI3gLZb1VxTRt2iBFe/EkWPqmv6gs/C0sm/4cyiHYDEh5sE43U0LE1Shx4hpj43k0c8HXEwTPq3vBYXvVws+rmRbQ53qlOtM+/oo7lUM/GEZELEDNDPMveeStTDon32XVAk0TFWoH0YJTdUH3l8yf1UBNMCJ5+FN3+7w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734947000; c=relaxed/simple;
	bh=wDO1tW8vNaRgTY4gSj5Zd7dokLz+ySdSBNTj4LgY3UA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=CM9LWsgI6dQi239UKddYinQTVcEduOx4muaYIJsQgDF/nNJDj90jWedhf5pCK15m4W2NnGfIgkbolnxRVFGzOxmqL7GG0CJzbn+sHRcUI5mmGgCBlUBaXNJHSxSgpwsyL7vHnCHC7y7TeKjv+hY6mFsDmY8eNRSpzxXhvKoyi0Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GnjM4pCh; arc=none smtp.client-ip=209.85.216.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GnjM4pCh"
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-2eed82ca5b4so3457265a91.2
        for <linux-xfs@vger.kernel.org>; Mon, 23 Dec 2024 01:43:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1734946997; x=1735551797; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=o7zPaUzkmvhvmtavStlS6RJm5v6XAlnwyMkzLIEpBUY=;
        b=GnjM4pChgI4JHnNWcAfJtiw+XiyMyfLKHXQE3zQWpOK7Wu+QKo15Sl8ErLbd4/RBKY
         XjlYL7yanScDSDPLetCBj+N15OZLF6pK8A5km79cE4PoVOzZIQiFtJ0uHiJAnvDj0go4
         nZQn5E4zswzB1mfo07Z8WFq3OqNU9YGjtLSODhBgGjk5XKMCIeqhlo4K+N+xGEfXkv9S
         UZ1XD95HBsIZBSA9iueD4C2iWCE+JMZYaJdF1kMXSu6L1mdOi67q43RA9nQ2iTHC+UBV
         RyHV3O5cxTb6Kt4Putyrg6tlkU1rhpiD8QCTalbK0W8Q1sgPd7pc3FXwOA0GXLfuh0S2
         NcJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734946997; x=1735551797;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=o7zPaUzkmvhvmtavStlS6RJm5v6XAlnwyMkzLIEpBUY=;
        b=oDD/elyDsoZT2v2O+xgKj3pPBKcvoctmiiIF9lxDyR7DyHsitAfVCv/QBNPiJRChHU
         lAEvF0HUjdPqwEGX7zpLS9V+ns4cMeMUWHLJFl+1q6O89HeUc9w/BYfwVwxj5qONcfe7
         2GWsO7v6tXvZ52gZ1/ztaSlnDsjVI+3nCtVhVLv0ZJWnD+urNwWkzDmaQhVylosyQHRN
         GJMZ6+ZTIZli5jBh3L03uxzLuwYqGPhcGbOZo80Sq/y6K2CDKnS2Zy7DJrLjzv3gGtM/
         9T50/0DT3v/Cuh9zmrHAMVxFSpquW7g4m9wUbwZB4FsWiyXhosRQ3iYe5z6PQ5dMrpLo
         dbaw==
X-Gm-Message-State: AOJu0YzMhBGmlecT8Km/DGlttZulrMQ6U39HLb2Qh6p1OrlkoIYMe9o0
	pPcv3yiIq8K0ZIJdfFUuz3an6upTFS2rvjkRC1cmtDtBh2DjzwUWua05lQ==
X-Gm-Gg: ASbGncsICAH5me/UTxGKerTuFMPhhWDYvHluZ96R85+FcP7/gsqmmpl3gt9W7iNCGSo
	3Qgn94QvKZZVAV9zQ9hGQIVftY5ZaaD62Te+OWGMjPmzKlTl4Z+cNVo0P6LVne1YTXo4j8ye0YL
	jbXI+7ecdiaDNkkk9PpC9rOi66o4JljZ9t3IxddewOh2+9gA1XDjCR+Ur1Z1FFtdkWlN3dGvxx5
	fiVFRQrKXjYrK4f4ahNmWprw7FVbnzoD29rOKU8oRFE2/UnovFEaq+yKHnKcCPiJ2gKDX1Q7JDo
	fgUF1kkjj86QBw==
X-Google-Smtp-Source: AGHT+IH6jT4JFvzAY6RnpqCrnNDJ46Xy40qPE5OxPqAyJztortF09SVVBFy5H/MrhjAP2mZZc+Ja7w==
X-Received: by 2002:a17:90b:2dc1:b0:2ea:8d1e:a85f with SMTP id 98e67ed59e1d1-2f452e4963bmr19294143a91.17.1734946997091;
        Mon, 23 Dec 2024 01:43:17 -0800 (PST)
Received: from TXPENG-MC0.tencent.com ([43.132.141.24])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2f2ed644846sm10930995a91.28.2024.12.23.01.43.15
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 23 Dec 2024 01:43:16 -0800 (PST)
From: luminosity1999@gmail.com
X-Google-Original-From: txpeng@tencent.com
To: david@fromorbit.com
Cc: linux-xfs@vger.kernel.org,
	allexjlzheng@tencent.com,
	flyingpeng@tencent.com
Subject: Re: [PATCH 01/42] xfs: fix low space alloc deadlock
Date: Mon, 23 Dec 2024 17:43:12 +0800
Message-Id: <20241223094312.39933-1-txpeng@tencent.com>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20230118224505.1964941-2-david@fromorbit.com>
References: <20230118224505.1964941-2-david@fromorbit.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Suppose there are two threads doing delayed allocation and both of them
trigger the btree splitting. Due to delayed allocation, thread A holds
the lock of AGF 1, thread B holds the lock of AGF 3:

agno(low -> high): 1  3
                   A  B

Then both of them initiate a btree split work(AS from A and BS from B), 
but due to memory pressure described by commit
c85007e2e3942da1f9361e4b5a9388ea3a8dcc5b ("xfs: don't use BMBT btree
split workers for IO completion"), the two works are processed by the 
rescuer thread, AS first, then BS. After trying each AG with the TRYLOCK
flag but failing all, AS retries with blocking allocation, until it
reaches AG 3, then deadlocks there: AGF 3 lock was held by thread B, but 
its split work BS was queued after AS and has no chance to be processed.
Locking order is followed, but still deadlock occurs.

We didn't actually trigger such deadlock, but encountered a similar
hungtask reported by commit c85007e2e3942da1f9361e4b5a9388ea3a8dcc5b
("xfs: don't use BMBT btree split workers for IO completion"). That
commit has fixed our hungtask. But while analyzing the vmcore, we found
there are some other btree split works queued on the rescuer thread,
initiated from delayed allocation threads, each of which has held an AGF
lock. That leads us to this patch and thinking about such a case.

So is this possible? It seems currently once queued into the rescuer
thread, a split work has no way to know whether there is another
concurrent split work initiator holding the lock it requires.

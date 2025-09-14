Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 265162747B
	for <linux-xfs@vger.kernel.org>; Sun, 14 Sep 2025 13:30:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757856614; cv=none; b=Yf8jJ4H3vxAx3mJjFebeOiKHJOVOM+BgdLUgdOP/mzQRT5LcVF9qv3/s6HWO58R9Ljy6tmtLNHp8BycaROxnyPB2W2iAoyjstc4eoCELBtXQZIUMTQ51jSC1PXEb1ex0Dw1kipPiXefrByiw7+lji1iZ6cckNeKvh7r0xbSr48A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757856614; c=relaxed/simple;
	bh=sdfxBxt4mURTAIPeCtfkcBrYZDH9reEz+rlyUwKcLO8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gtw+ywposYEfB2oc3lxXMLRGzGAYiqLyqowx0MYt+NZtQ6gCTy+vtG7Ai52BEKR9WPo/9qp7xnGEHg8O7O2EMl05Rh4CHC5Xhz2lAqzVcslWn0Zijp/f7JJa2MOxA6MZ/pNwBjGRhMyIJjzm058PsjwHyB5dvagaxNT/VkXWPCE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=AuO8uVNJ; arc=none smtp.client-ip=209.85.216.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AuO8uVNJ"
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-32da88701c7so3549081a91.0
        for <linux-xfs@vger.kernel.org>; Sun, 14 Sep 2025 06:30:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757856612; x=1758461412; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+v/bwFXPYi1A/E+v0RDwAlOzUIE6ZiAt0F/hgL23dj4=;
        b=AuO8uVNJ2yHCxIRXFS6yenjTZ6W8YBUIzZuDCXifsarijcBqtAbBlv3NLMheaZj0JG
         +EAbFOVC6IAtIXtEBJsT2tMqTokADEwfJWJov1ZdB2hxkai/Ohrg0CzqvGUSSFDeLNFK
         C2hAV2d63msAERiAxAFcZZ4G4rKgwqTkEo69q9RdjdvgFT0iyMy/qGDVV3MylGGMPnna
         HZdaKdUn2QvWKkrBrvfvJL/0aQ/kLMr+XvlPENne7fg1MxbC/jwqq3G6D7w+7o37+oPa
         J8xYcjP6GkNZU1N6gYJWyXKt5sSwlwhekfmgRyhp983r93apb+u6MyWh+SR4TFiw6/gb
         gzsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757856612; x=1758461412;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+v/bwFXPYi1A/E+v0RDwAlOzUIE6ZiAt0F/hgL23dj4=;
        b=cEs3c4EuEUMcz7FJDylgHJFDhW59BtzXq4xNKyyf5cvHqudVhUHds/WfL4eaQOk/fO
         ypoiT7gUS13tx331tePZqnOMAHWJjazjg1rnZzLG4mBoBdVM898MxPLhAd1/aY9c46zy
         eY0R2vcl/ch0krByQutWVKDGM8Z9oIUHj3HbJYqWZLKybJyzkJ850iYECU17p3fPcuJU
         OhcP++zsfQao89uKxAdKIbZJKU4jl+V1OMaQ9arZmkxS2jeSWrksfHq4UsoxPSLwh4zB
         +dsrkwqSBWke8FKh4FwyS7lHu+4qvYgLPxR7C1YhGz1uM5rBAj7qBRTDhqTLdvxuYCIh
         absA==
X-Forwarded-Encrypted: i=1; AJvYcCVajeZB1lt3eVwpccGPBSPZ8kzDKtxLv1b0m2wKo1wl92oN+Brrp8wPdoVOsuqsl7oBjtAeGQSjKsI=@vger.kernel.org
X-Gm-Message-State: AOJu0YwV9PWJm4I7QibqKsMu0gcTgacYOrYN7Y3IuwZPdjK4mRrxwiL4
	xPsDflo+FsVF8msVGzHsSbBKBP46CHhHC/jFsQdcCRe8MMXPfUYSN8ij
X-Gm-Gg: ASbGncvmbd3zJeKte876CuSHHC3UfhpWhqjdxxDYoi8q5QtdMnmgcsIQCHi3So+ThZA
	+E7NyhDxT/XETyUwmc+wpPirpbgY582k4/iiqWejhm2DKYfD4f1bbtPIVSAr3XHtOr/SIjicH8y
	P0pq8BmF+4vfQxrR2T3JZQWguHy456ugr5yyS4YIVUz3pxturSqFP85ncPIBrxtu7YnW9BSlVed
	WOY2kDyesKXTrm3E8LX2bSNJVq3/Lzz67wdBw/H8yNNIefxWjWEsOarAM5bj+nUUC29DpWgqd/0
	+0zkKq3TYX5ue2sa44qGrtn4mgr78pPs8D2PA69+8IPm9RuRfw/4rE2t5UjgBhr7ckZTiozr9kA
	NZspSuXa9f3Tb52Q0jCVHbcmNh/VSF1IWbvs9//XLlRaZ
X-Google-Smtp-Source: AGHT+IF1KcNJt3UWmfwSpwE/UpWBqDtmNxg4KMzYyF8MLuCAmlCdngCBSBEjT/SyGByGhBx68l8iVA==
X-Received: by 2002:a17:90a:e184:b0:329:ca48:7090 with SMTP id 98e67ed59e1d1-32de4fb254emr11960351a91.37.1757856610930;
        Sun, 14 Sep 2025 06:30:10 -0700 (PDT)
Received: from VM-16-24-fedora.. ([43.153.32.141])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b54a36c78b5sm9622382a12.21.2025.09.14.06.30.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 14 Sep 2025 06:30:09 -0700 (PDT)
From: Jinliang Zheng <alexjlzheng@gmail.com>
X-Google-Original-From: Jinliang Zheng <alexjlzheng@tencent.com>
To: kernel@pankajraghav.com
Cc: alexjlzheng@gmail.com,
	alexjlzheng@tencent.com,
	brauner@kernel.org,
	djwong@kernel.org,
	hch@infradead.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	yi.zhang@huawei.com
Subject: Re: [PATCH v4 0/4] allow partial folio write with iomap_folio_state
Date: Sun, 14 Sep 2025 21:30:07 +0800
Message-ID: <20250914133007.3618448-1-alexjlzheng@tencent.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <mbs6h3gfntcyuumccrrup3ifb2dzmpsikvccu7ovrnsebuammy@if4p7zbtvees>
References: <mbs6h3gfntcyuumccrrup3ifb2dzmpsikvccu7ovrnsebuammy@if4p7zbtvees>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Sun, 14 Sep 2025 13:40:30 +0200, kernel@pankajraghav.com wrote:
> On Sat, Sep 14, 2025 at 11:37:14AM +0800, alexjlzheng@gmail.com wrote:
> > This patchset has been tested by xfstests' generic and xfs group, and
> > there's no new failed cases compared to the lastest upstream version kernel.
> 
> Do you know if there is a specific test from generic/ or xfs/ in
> xfstests that is testing this path?

It seems not. But there is a chance that the existing buffer write will hit.

thanks,
Jinliang Zheng. :)

> 
> As this is slightly changing the behaviour of a partial write, it would
> be nice to either add a test or highlight which test is hitting this
> path in the cover letter.
> 
> --
> Pankaj

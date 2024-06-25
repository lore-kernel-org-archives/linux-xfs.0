Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 847716CDBA;
	Tue, 25 Jun 2024 11:24:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719314685; cv=none; b=XPPk+OpZ+QUuz00qwaWxL7nisxuZ+X4opejRJajl08j95fAMBarRAqCT2D4r2BIs2ro2vN8pWuhEDI1Ts5cHNCacML7YRMXqM3qQoyJRp+d6jZMZQ7NvzYAmLIsUE/O+h9NzIJ9yaVq+lV7HLD4NEUrTdL3VmBQG9N0mSdCOC0g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719314685; c=relaxed/simple;
	bh=LKP6RXiMnEv9kVExew7sviGUj81OPem65IPxes96aI4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=epeMCOAOFMM4p/LmAv5Py8zxXcnBl9i2ivgOQa2nj6Ptkg/ZUi7r/e7OCFtpdLiV7FuyTA0qr50xBfJzKKlltmU9Nyn6JwT4BXNsd7i9qjT/ZbvqtH2sjg7jt/60d7dW5ecoWbNX0rIAzLrRp641MPj0TAmTqDJyQlnNh6k67J0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=b9V8QrP0; arc=none smtp.client-ip=209.85.210.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="b9V8QrP0"
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-7066f68e22cso1989420b3a.2;
        Tue, 25 Jun 2024 04:24:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1719314684; x=1719919484; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gKa1ZN3bQlg/inBlj3ZFVGmHoMWwCTwmF7Xq369yhZ4=;
        b=b9V8QrP0Z/E7u+RZqRxfBm/OCKWuDqk7M381Q/4aBr+fwAkD/luX1tIorq9yKgMUWw
         vjOkMTsJJxEsmuktDvRZdYtgLJp7820UcXm98o/hHoPHSjMr4Oty1rYhjUGEwTZK2kXV
         urc4Z7f233wSzk2Bp1ZrFUlP5ADkix56eSKEWl0xHzhC4h4RhRVmB1CYdjdCQf+eCTTB
         z3GXvhuB+wpWEXzWvwI12Cjcw0YdsbpMUsTYGQ1L/WRDZkuWnYw1O15lR7TRcCLj8+m7
         IakbxpHn9gW1aL9kGh9/XL3YYf7BqK0qbnzxFVJ5fSx7Ms4ps2h2JLsK7ib2+RAT3zCu
         4/CA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719314684; x=1719919484;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gKa1ZN3bQlg/inBlj3ZFVGmHoMWwCTwmF7Xq369yhZ4=;
        b=PZXOWJQ1cOTuWeiHZn3gYH9y8+GeMV/4gVUbyQddsyZJB9uf03gabz9hmrHff4zpls
         nDKVb9TDUA6fiiVC+ok/zpC5DCXKOj9Ycz3COKb5vFDgJQU4Ssug9v/inN6CdPpCoTZ/
         dCN9T9XYKia7TyHwiDE/yrn8KU2Nq68uGnK8/EY8T2U4YXs58agqzL6x70sKFNbvM8Qd
         dxFfM26YiMlRQRZXl+W/ng/a5i3EToVmwQ0lT2ojxLBDtd7OqJ0wTXUGIIhxkIz4xvCT
         MgCLUoNS5KhuPLhGqvBmc1eaqFUgDTzcWUAM0HMQUmKD7IIv8qgr6bt3d1QJM0cIn3RL
         KgUg==
X-Forwarded-Encrypted: i=1; AJvYcCUKfjF+TuE8DD0M+XM6Uiko08MDC4qkNej+KX7hwBuP/3Ri5YtD1WjtXITF9vKBxkMn5sw1zF+K40/tadCUUv3RPqX1obUBz0J5D3wstDhiU8PBAETSRZve5mFmQn9jjnZLGYlHoRE9
X-Gm-Message-State: AOJu0YzZyXUuG0CsI5BYWg7LVeaXax8jK7l6p4QIhhSmZ3+edWixVML1
	Xungmwn65bxtmr265ICVDohjl5gN7621zjiR5mmNhGxEirLIInMf
X-Google-Smtp-Source: AGHT+IGrckFeV1YgkM6eCdXhhJGQfsC9cohM3aWPkJo2/QLcDFiB+wUIsp5rjyk7Uqsowo9Af5LMMg==
X-Received: by 2002:a05:6a20:3b20:b0:1b5:bc67:b9fa with SMTP id adf61e73a8af0-1bcf449d18bmr6352715637.20.1719314683546;
        Tue, 25 Jun 2024 04:24:43 -0700 (PDT)
Received: from localhost.localdomain ([14.22.11.162])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-70679725094sm4368690b3a.166.2024.06.25.04.24.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Jun 2024 04:24:43 -0700 (PDT)
From: alexjlzheng@gmail.com
X-Google-Original-From: alexjlzheng@tencent.com
To: hch@infradead.org
Cc: alexjlzheng@gmail.com,
	alexjlzheng@tencent.com,
	chandan.babu@oracle.com,
	david@fromorbit.com,
	djwong@kernel.org,
	linux-kernel@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: make xfs_log_iovec independent from xfs_log_vec and release it early
Date: Tue, 25 Jun 2024 19:24:38 +0800
Message-Id: <20240625112438.1925184-1-alexjlzheng@tencent.com>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <Znqmr3Iki4Q8BkxJ@infradead.org>
References: <Znqmr3Iki4Q8BkxJ@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Tue, 25 Jun 2024 04:14:55 -0700, Christoph Hellwig wrote:
> On Tue, Jun 25, 2024 at 12:06:14AM +0800, Jinliang Zheng wrote:
> > xfs_log_iovec is where all log data is saved. Compared to xfs_log_vec itself,
> > xfs_log_iovec occupies a larger memory space.
> > 
> > When their memory spaces are allocated together, the memory occupied by
> > xfs_log_iovec can only be released after iclog is written to the disk log
> > space. But when xfs_log_iovec is written to iclog, its existence becomes
> > meaningless, because a copy of its content is already saved in iclog at this
> > time.
> > 
> > And if they are separated, we can release its memory when the data in
> > xfs_log_iovec is written to iclog. The interval between these two time points
> > is not too small.
> > 
> > Since xfs_log_iovec is the area that currently uses the most memory in
> > xfs_log_vec, this means that we have released quite a lot of memory. Freeing
> > memory that occupies a larger size earlier means smaller memory usage.
> 
> This all needs to go into the commit log.  Preferably including the
> actual quantity of memory saved for a useful workload.

I am sorry, but I didn't get your point. May I ask if you could clarify your
viewpoint more clearly?

Thank you very much. :)
Jinliang Zheng

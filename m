Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AC07230274
	for <linux-xfs@vger.kernel.org>; Fri, 10 Oct 2025 02:05:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760061909; cv=none; b=Cry9BzMRqS9iKAVCUxQC7hztJNWb032EzCqHAaqSH9BwcrNmjyB44VRcl599J3yP2LlAEdtYuHM6NTA97Iv8zOwVow09s7baEY3VrosL8goZmech+KzEDbVW7HNkJX+bJ9W4aA3ky0By9Cb3cRuadwyXi30vPeNz2d8lQLrdIK0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760061909; c=relaxed/simple;
	bh=4TBHId0bMm9CdTNvUN5XuLKY3sjRAw7vbQwPUrCIGvE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ruU5j8IAr3FZe4PqShonQlHQ5JvDHrFc7jgv91lldj3SR8n/mio9jSH3IEsEAAFXlDsh8mP3UHx5r4A+LgAWdCarCM6fplnkn5P76kqslB9KuEWgzdEZ8idOnTc3ZK7smh7+qpOc21swCOfmS0+vw0m0O2fxo65bNuk5oHOfxpk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JbnS7UDX; arc=none smtp.client-ip=209.85.216.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JbnS7UDX"
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-3327f8ed081so2076973a91.1
        for <linux-xfs@vger.kernel.org>; Thu, 09 Oct 2025 19:05:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760061907; x=1760666707; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=h1rKJVS+vc6Xu/tqhvpZMEVhOAA3UUcIm1XqkGlHfjk=;
        b=JbnS7UDXsIYTTo2e2s7gJVPY/kak4SQig1MyyhIdw90c5SAA+PmWnxuo+Ai5opKtUm
         CKkW5stFwP8ln5958nyZy18yvzNgad3cOcsfzVOMH0kc51K7kUS2s39KHDYwmqZh2c1w
         iIomCa1pa6PtG/qVlvXIrxqex9/0Fqxjr/rp5Ie88v+ruC+EAJdEbcDcfeXtwFmrNkil
         8NUqVpj5mlBuDTzzY54cG2cIhIfPyHzfO+4rU+CsrhSNieJyUdZpPNYU2uUmrHXfyB/8
         sZOIJD8qCrjIGVvpH2d9fCiuWlxzBKifG2E8gXB80/uDTuj7//9qXseOGb17k2KlyIAb
         yfiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760061907; x=1760666707;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=h1rKJVS+vc6Xu/tqhvpZMEVhOAA3UUcIm1XqkGlHfjk=;
        b=TqTUg6ywna0ZmXhNObrMrLfIg6zx0gRd0LUpR/uA9YYK40Q2qdyvUBq7AeQD4YxtO0
         9FCsG0jCOX8W7NLqm+b/FoegfhZaB9BqmFWOovzQCVnnDjwOirZ4A74+8aaTXryrVgM1
         cjnddZE8IOgboFaVAxzxciP+8JU9urQvh5Af0W6i7WDw++LcNjlt9o09xIm63425S8HG
         4Xxt0JOoIVBDM9SzruTHlZ+3EcBmTw5AgqQ93rJPsiwvyvi2h5PdaeaOH88Jk8Wr35W5
         UoEQMNjI200Xp/TS6b+zfMrmZN4fQegLwPCfsAM5kcm6YjpvfFF5kRtaBaXVOwUJtQyw
         nN1Q==
X-Forwarded-Encrypted: i=1; AJvYcCXYmYs2MdLi6QTu6psfnVhxvTJYh76Wumrs9sBcppbpZsV9Nh5z5ZRpXJKFZ3+00u/hmpkBLVpWemE=@vger.kernel.org
X-Gm-Message-State: AOJu0YxycJ4TfydkiNY/ZFryiPO+kTF8xNSZvpgTM7rKK8U4g1EONjXC
	z1dZ+H+QhRG9prq+QoMxpFPyWK/qHiM+YmPmjU+aF5bicModY5mFpJxB
X-Gm-Gg: ASbGnct1jK1x4w163fB3jATa1/e3xw5Be6l7cvwdkDR8h8OnNHN4bYb9rU3Sxb9YtX4
	Z0W7JEoUbep+9MLmkV8+B/9NlLJmCEmLqiqHFzQJ1QsyQkvafvYk7IXjoOyLqpIkc3EdT49tZS/
	NqKlHjWo9GtTUQ24TGTdqvl5trnWIXFuZBxsHt4ve8Bb5LMjDQpNTaCY6iFSyO522SUYn1NAngH
	vxq03Jc+1tOS6LLxsezuCchNcWwVxOSyKT7lrh5xST4UH5whKEJ1kMwi2IZWNYtxGlDNsfhsEqu
	YakJOLymp6Dr3Reou9KD3qRqFQdvjFvnY3LBkHHLNMXPzlukxnNttA89TjYBGqg9PLk2w6+S6Ak
	Jnt3gEIN5r6a+OgUWWic5LJMIcgLbqhFnK6IPheVJEKD36WHBKb3Lo7XFqe6V0OY=
X-Google-Smtp-Source: AGHT+IFUKd5++PDzS5abSESfTQMJE2QGfoxe3f5Mp2ZuxGS2YUSKKiYyTeMogVzSyN+wUnOPRXUvpg==
X-Received: by 2002:a17:903:1aef:b0:250:1c22:e7b with SMTP id d9443c01a7336-290272e3a78mr128609435ad.43.1760061907263;
        Thu, 09 Oct 2025 19:05:07 -0700 (PDT)
Received: from VM-16-24-fedora.. ([43.153.32.141])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29034e179cesm41443735ad.34.2025.10.09.19.05.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Oct 2025 19:05:06 -0700 (PDT)
From: Jinliang Zheng <alexjlzheng@gmail.com>
X-Google-Original-From: Jinliang Zheng <alexjlzheng@tencent.com>
To: dave.hansen@intel.com
Cc: alexjlzheng@gmail.com,
	alexjlzheng@tencent.com,
	brauner@kernel.org,
	dave.hansen@linux.intel.com,
	djwong@kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH] iomap: move prefaulting out of hot write path
Date: Fri, 10 Oct 2025 10:04:58 +0800
Message-ID: <20251010020505.3230463-1-alexjlzheng@tencent.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <486185f6-7da7-4fdc-9206-8f1eebd341cf@intel.com>
References: <486185f6-7da7-4fdc-9206-8f1eebd341cf@intel.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

> On 11/9/25 08:01, Darrick J. Wong wrote:
> > On Thu, Oct 09, 2025 at 05:08:51PM +0800, alexjlzheng@gmail.com wrote:
> >> From: Jinliang Zheng <alexjlzheng@tencent.com>
> >>
> >> Prefaulting the write source buffer incurs an extra userspace access
> >> in the common fast path. Make iomap_write_iter() consistent with
> >> generic_perform_write(): only touch userspace an extra time when
> >> copy_folio_from_iter_atomic() has failed to make progress.
> >>
> >> This patch is inspired by commit 665575cff098 ("filemap: move
> >> prefaulting out of hot write path").
> > Seems fine to me, but I wonder if dhansen has any thoughts about this
> > patch ... which exactly mirrors one he sent eight months ago?
> 
> I don't _really_ care all that much. But, yeah, I would have expected
> a little shout-out or something when someone copies the changelog and
> code verbatim from another patch:
> 
> 	https://lore.kernel.org/lkml/20250129181753.3927F212@davehans-spike.ostc.intel.com/
> 
> and then copies a comment from a second patch I did.

Sorry for forgetting to CC you in my previous email.

When I sent V1[1], I hadn't come across this email (which was an oversight on my part):
- https://lore.kernel.org/lkml/20250129181753.3927F212@davehans-spike.ostc.intel.com/

At that time, I was quite puzzled about why generic_perform_write() had moved prefaulting
out of the hot write path, while iomap_write_iter() had not done the same.

It wasn't until I was preparing V2[2] that I found the email above. However, the code around
had already undergone some changes by then, so I rebased the code in this email onto the
upstream version. My apologies for forgetting to CC you earlier.

[1] https://lore.kernel.org/linux-xfs/20250726090955.647131-2-alexjlzheng@tencent.com/
[2] https://lore.kernel.org/linux-xfs/20250730164408.4187624-2-alexjlzheng@tencent.com/

Hope you know I didn't mean any offense. Sorry about that.

> 
> But I guess I was cc'd at least. Also, if my name isn't on this one,
> then I don't have to fix any of the bugs it causes. Right? ;)
> 
> Just one warning: be on the lookout for bugs in the area. The
> prefaulting definitely does a good job of hiding bugs in other bits
> of the code. The generic_perform_write() gunk seems to have uncovered
> a bug or two.

Indeed, the reason I sent this patch was precisely because I was unsure why the change
for iomap_write_iter() hadn't been merged like the one for generic_perform_write() — I
wondered if there might be some underlying issue. I hoped to seek everyone's thoughts
through this patch. :)

> 
> Also, didn't Christoph ask you to make the comments wider the last
> time Alex posted this? I don't think that got changed.
> 
> 	https://lore.kernel.org/lkml/aIt8BYa6Ti6SRh8C@infradead.org/
> 
> Overall, the change still seems as valid to me as it did when I wrote the
> patch in the first place. Although it feels funny to ack my own
> patch.

If moving prefaulting out of the hot write path in iomap_write_iter() is indeed
acceptable, would you mind taking the time to rebase the code from your patch onto
the latest upstream version and submit a new patch? After all, you are the
original author of the change. :)

Thank you very much,
Jinliang. :)

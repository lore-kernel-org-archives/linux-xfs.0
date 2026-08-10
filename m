Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 908BF3C4B83;
	Mon, 10 Aug 2026 11:55:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786362941; cv=none; b=JP+UfyLlYBdRCLT6WGWz7+GP2QtWxHUMFQfDln5oZgtNLqmH9JNBybZ5DPJgTClcsvX6SxY2nsIpzTlMZ+x5mBdYE2/TKmCc+IJycFJTjIzliwoLmNlh/m6mpjmsZohKpMJKpvaBrvWsi8Tn8Z4ZoXTqdCBNXHIbqJr3Rl4T4Ko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786362941; c=relaxed/simple;
	bh=X547GRv+kEQlP3B3wk9EjVBJHhYoMcVOke7t5SDxAcs=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=jV3n1l3fG/6/JLxWh0W1Lts81oRzd4b6CADAFQw7zB9BgsyBA5E8d+zi52gYHtdNh5Ib/8w/dU4uyD4Qo9xdRL0Cr7v+nfWV0J4gdIkEyfJBEGEIGfJESr4OMj2z5R/1MVVcnbY5xoRhdyw9rOVgsveysY+AVXFlbip94/8RNE0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SIsjLw5S; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SIsjLw5S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 093B11F00A3A;
	Mon, 10 Aug 2026 11:55:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786362940;
	bh=50wbtiDm3Yk6Q1jNFUXLy8l/QcUP5h+A9AZye7m3aSM=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=SIsjLw5SpoXxqPVmYT94EXXmzfUo+fU/PWHEiv8q1F8twBEvGL1ggqcn+iHxeqeY3
	 KPA7JUVVY9soDpqArdXYWO09fLxZycYt7Aqwcg13vKHb2hvZXAKzpIN+m2ObhEBkih
	 SayNXJPUt8wdmK23ck6evP6ou+DtFYNacRgyEJaXELTY5ihzxOgjFg4fKl9iBk3D8H
	 k2geGHfXQN/zkEaGZTVPMZ49Z+ojt9jmCQQOK4KCdMjg+e4EMuNLWnIGdOUt7j+ayX
	 rqan+BGDUWOFm8d4FW4PfRDj/+M7c3KUjFzFCn0cTc1Pra0ykCxR/YoD304s+by3oi
	 mUHnhriaVTlzg==
From: Carlos Maiolino <cem@kernel.org>
To: djwong@kernel.org, hans.holmberg@wdc.com, 
 Hongling Zeng <zenghongling@kylinos.cn>
Cc: linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
 zhongling0719@126.com
In-Reply-To: <20260729073418.63750-1-zenghongling@kylinos.cn>
References: <20260729073418.63750-1-zenghongling@kylinos.cn>
Subject: Re: [PATCH v2] xfs: check split_sectors validity before bio_split
 call
Message-Id: <178636293868.58486.7369738774331223350.b4-ty@kernel.org>
Date: Mon, 10 Aug 2026 13:55:38 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3

On Wed, 29 Jul 2026 15:34:18 +0800, Hongling Zeng wrote:
> Change the split_sectors check from !split_sectors to split_sectors <= 0
> to make the error handling explicit. While bio_split_rw_at() cannot return
> a negative error code for the current GC I/O path (GC I/O doesn't use
> REQ_ATOMIC/REQ_NOWAIT flags and has proper alignment), making the check
> explicit improves code clarity and makes the intent clear.
> 
> This also makes the code more robust for future maintenance if different
> I/O patterns are introduced.
> 
> [...]

Applied to for-next, thanks!

[1/1] xfs: check split_sectors validity before bio_split call
      commit: 6e6a31401445556b58ab9517e256285989be73da

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>


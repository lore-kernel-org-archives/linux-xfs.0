Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88D2137F72E
	for <linux-xfs@vger.kernel.org>; Sat, 30 May 2026 06:40:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780123245; cv=none; b=aTVuf0bZAg9f7XZ1Fk5ey2S3Aqc6wDmfMcqLMuywaU07SghbL8vzb+b87oDtYs8RGSpHtEgfkhwtsWKPuDivgYibJAtj3CCudBwnNbOAnOeZYp5afc6PiKLKAp0xpDG06B7SuHb29CRzx1QzuGzMnGTBIEMXj7Tx/xxq7YEGyzw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780123245; c=relaxed/simple;
	bh=Jf9AlJxWlmctCuK8VImPuu59q3ed3cgJmEh1i6QjfCc=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=a1WeRObmOUXPzTeYyJ7BqxZQjVR6aRbPRe7/AJ35OdPhgTNStnzTnzs2/UmNnIHpdgEoFscOaRYElD6wNw07Net4nN2wUERgwFXJlRQ7woSrybOSbCgkQJyykQ9gdA7poqP2KHOwZtxsOT+tsFdjitcZ73vbc7vPED0fD7OCRLo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SsS5kLAQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SsS5kLAQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DDFC1F00893;
	Sat, 30 May 2026 06:40:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780123243;
	bh=2riLJx/5qY+9pYms+3xSHMsWHN25Q3mhJ+gfxL4ryyY=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=SsS5kLAQZN25HxZqviEiqiZbajzKPDwmKFq5L69cUG6ZE3e6NxKX4GxExuZC5+nUq
	 yn/ycMMqfuv55qiEP7laPncKbyN+HKdCsRWK0fBKe+oxVOtu4XEic3BrwJcz9p392Q
	 S734bgn8jKsj75zwnTAajygRNJgsDuoEnKqfZC2b7Lmxrd9mzCH9qm/fcHdnAsSukG
	 ea+T9HTRZk/3KT1hvlB7X9bkMpiq2EAfRXehG7Wm/NgB9huc3uI5DJCTz2TM0PEdd8
	 dw2IL+MIJJ8KwkSam/Ird0gq001atEwFaX8R9hzw1fT8FpDnUU1eEJI8jOwVXkj2W/
	 lgRpeDIbKZj/Q==
From: Carlos Maiolino <cem@kernel.org>
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: linux-xfs@vger.kernel.org
In-Reply-To: <20260526195400.352557-1-willy@infradead.org>
References: <20260526195400.352557-1-willy@infradead.org>
Subject: Re: [PATCH] xfs: Remove mention of PageWriteback
Message-Id: <178012324221.23341.13313337803425403166.b4-ty@b4>
Date: Sat, 30 May 2026 08:40:42 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15.2

On Tue, 26 May 2026 20:53:59 +0100, Matthew Wilcox (Oracle) wrote:
> Update a comment to refer to folios instead of pages.

Applied to for-next, thanks!

[1/1] xfs: Remove mention of PageWriteback
      commit: dabfaca8140f64535a79020f0f86ea56f5db5bb2

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>


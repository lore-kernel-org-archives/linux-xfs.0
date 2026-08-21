Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E2DD3A544A;
	Fri, 21 Aug 2026 07:35:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787297759; cv=none; b=X2tph/zMU7N4RcpeeAcdfl40wLvSxImOGXForAoRD7N8l0H9XZF7g58JjFCUfm9SIdqmuBpfPGI4eMuUX/xtVHSIW5YpYWsGP+9KlmmcuFRcPzL72KDDqcTo01BBF0Q89bPgHcCaJ6Go9aB5c1OTTqdude/KNSWslKDTNTBIE24=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787297759; c=relaxed/simple;
	bh=1J3x0jGjjZXy4KsCEaAOtuYkcDPdpqtZAGUhWqhWXss=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=MsshXR/TtqnzVaqQJA1F0fh0VLkwm1sH4hN9+za/n5lxfngSq8YKIR3MWnuY08TSSyLI/nEZOtqCsSonC4T3eyDzS3VDposduIPUIzq6z5gbjgI2m7dCim1+GX6iwyPuvnU6k12nO2CMlAOKe6Kv0Yy42KgNQUy48RFwYif7UdA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UStz8Z33; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UStz8Z33"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 022F81F00A3F;
	Fri, 21 Aug 2026 07:35:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787297751;
	bh=ch2BeEbK7KBwqXLGTBO5faJ9hEhTH0iNUv267kI5NBc=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=UStz8Z33vYNAXUHav9bvvQNfKgoU0PBtWhVI7YhKhBQMTKik8WgoXnH+TubFVLejL
	 xr++7v5JDdKdEAADoKwnELScEXBpIuPPfjOcVgZbylRrGzDG5XKmeZJROY07WPrc7D
	 QRiOdHFT5xFISm1oze5AyiczqVLf5nyfpTofOM5EAbSp/MIim1aF819fvafo2naT6g
	 lxxjaoE8ThghPv+dEwBMaH5g+lpV3Kdsc6airNPrTNALmiTeeGVgoCen3gX+Z+LbtX
	 M2kJsnQUhVksWsjaP07zNlW8ep58vNDm4f9RipW+4Uw6eoZ8U9CR+HjuYzM2TZjDR3
	 8Ze1hc72SCiWQ==
From: Carlos Maiolino <cem@kernel.org>
To: Tal Zussman <tz2294@columbia.edu>
Cc: linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20260807-kmem_to_page-removal-v1-1-7365a789acab@columbia.edu>
References: <20260807-kmem_to_page-removal-v1-1-7365a789acab@columbia.edu>
Subject: Re: [PATCH] xfs: remove kmem_to_page()
Message-Id: <178729775069.580975.1458371418478211803.b4-ty@kernel.org>
Date: Fri, 21 Aug 2026 09:35:50 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3

On Fri, 07 Aug 2026 06:58:51 -0400, Tal Zussman wrote:
> kmem_to_page() has been unused since commit 5ced480d4886 ("xfs: simplify
> building the bio in xlog_write_iclog"), so remove it. This also removes
> the last instance of 'struct page' in fs/xfs/.
> 
> 

Applied to for-next, thanks!

[1/1] xfs: remove kmem_to_page()
      commit: 750a361bfc8a8c8178872f2aecb7507a6fbf41a4

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>


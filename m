Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794992339;
	b=w9iXDBcHT7HnCwa13e4gN+vVIjvkEfYqvXFVKyPWZwRhkypUoodj0o4xMorCXL521fKC
	 q3bCQY5/unDUlCnMmjq0ymQeF7J4/4zcjNOAW/5AAhYGc4/XouRXlkyTRhjFqbvJ7brr/
	 OnjEcXWYL9G1dz4Ti+t8mpb/mwvof7tPagctBwZWjA675sCJsLv1ZE96G3NXmnYZyaOwZ
	 0A/USG3Q3Mvl61I4GMnQARswQu9129ghSWHXLqsHo5UeOXA/Wx1fZKYnUNnLrhxPW9i8O
	 pIYko/lSRBU2HzMYt8EVd8YyvVDWdnWEqzGNPGzhxU5brukMXmFas4WEJf1njbb/eqw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794992339;
	h=Received:DKIM-Signature:From:To:Cc:In-Reply-To:References:Subject:
	 Message-Id:Date:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 X-Mailer;
	bh=4u+NNLWEM85m+eLVVZXfFRxdPZ/ybHRbZTDzL1gpdEo=;
	b=mXoSs/w0lhRbSaSE1u6KMmvaBDXe4niVt29QVl3RnorghFtT9p06HBqwo94pV81MPX/o
	 PzN4baeajXun954bWm7EsHW/3KExrih2BW1Dm1ug0WM9+HR4UYOUGURx7FFY0dXzb9+5Y
	 PHI7OBImI+1suUIw3JBBGErF9VafJ9OqoNXjGRFRnXEa27XYR3n2auJUdtIBtgOg+1nT+
	 A88T0/VRT7FR4cpsF4k+HWpTgEKEHPud0eg1EKwWLWh67+3D1jxkiyyd+DM4TniB9PeQ0
	 8Lhz1w/xczbI19hWVReo3ICI+4QvwtvoV3MVUG3fmvMWW1R8T/UM6OKuJ/4MQAUAn3Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ZAK+zaRn;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05548606A895;
	Wed, 18 Nov 2026 08:58:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ZAK+zaRn
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 198971F000C6;
	Wed, 18 Nov 2026 08:58:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794992338;
	bh=4u+NNLWEM85m+eLVVZXfFRxdPZ/ybHRbZTDzL1gpdEo=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=ZAK+zaRnpzmNA0pgLL5AWiYm/LDvsIeHJ5qdCjmaygU1jHUaM6aCJ7lCR/R6+Y0yx
	 XIIHZM3XBya1bq0dpPyTnOU8ipVUFDWIN0ShqeBZR5gTxE4T55EJBLue9IExnDE3SU
	 3sOB8T8YhaVE2pGgJ3ze8zqWpXNaEpPPfkB9yBc5VvdP12ux6BgzKeLNv8VIycBI6g
	 xGYcBR+xJLaiI8G94MmVdoAswuXDj5gZjnkYaLSniKjCFvYIHXxRllZ/tdR0ZkvPLV
	 19usqzOe7O+q859IIY3VxdqsDuF1NVb/vbMOmRzed1YZfKLdSK9ZDdtpcTpGboLPos
	 YqSX/ylWql21w==
From: Carlos Maiolino <cem@kernel.org>
To: Yiqing Wu <wuyiqing@cmss.chinamobile.com>
Cc: linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20261116014802.16078-1-wuyiqing@cmss.chinamobile.com>
References: <20261116014802.16078-1-wuyiqing@cmss.chinamobile.com>
Subject: Re: [PATCH] xfs: remove unused variable in
 xchk_stats_estimate_bufsize()
Message-Id: <179499233780.5574.6310002190973802227.b4-ty@kernel.org>
Date: Wed, 18 Nov 2026 09:58:57 +0100
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3

On Mon, 16 Nov 2026 09:48:02 +0800, Yiqing Wu wrote:
> The css variable in xchk_stats_estimate_bufsize() is initialized to
> point to the start of the cs_stats array and incremented on every
> iteration of the scan loop, but it is never dereferenced.  GCC flags
> this as a dead assignment when building with W=1:
> 
>   fs/xfs/scrub/stats.c:146:34: warning: variable css set but not used [-Wunused-but-set-variable=]
> 
> [...]

Applied to for-next, thanks!

[1/1] xfs: remove unused variable in xchk_stats_estimate_bufsize()
      commit: 56b3c41b05ae2fc342ac874757d65482322eb360

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>


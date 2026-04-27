Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CFB33C7DF1;
	Mon, 27 Apr 2026 13:26:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777296379; cv=none; b=mMGs7Xs2UYjNTpL9pOYYxtv2UpDzg1SM1IJP1WGCPXSuXhdOfB9RGG5hfMwQErHb1Dtvhr5Dw507EE5xKtdtx6rdk2+/bQSrB9RxIVW+8KhScSOnUM2B5i2ZAyD+Z7pQ9IpEVvAsMWrvlWL6efX6XI2TmI5q0dYkvT+OWngfvSc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777296379; c=relaxed/simple;
	bh=zq5KYIKHAByzw8BZAhMPDv90ScHw3Ru9T95XjtIurXc=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=EGhl0Cflrhj4lm2s8IEqUjEf9Dq+FcEmD1/9gHYfU8JvUQagAYGwyk7n7vLk/bXuacr2Zh5Hvw/mbSpfQhRF3ad2U6hY+n+zPvcx+JfUAkoqxp+5KB3vDFEeyEPJNwiUo3Skw9fSd2Y6oFysC5dzgMf8Kf5/6h0l2EVXBhHTILU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tlga6+lX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tlga6+lX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65421C19425;
	Mon, 27 Apr 2026 13:26:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777296378;
	bh=zq5KYIKHAByzw8BZAhMPDv90ScHw3Ru9T95XjtIurXc=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
	b=tlga6+lXsrrmBrRtOYOPw4oj+lG7Ws5wNxMTtqjrktF0/BSKn299n9cqe5IECS3ui
	 XGmCTdZFAJr3rxBh1e6cFc2kV6Me+UVWQI1WEvFID/+T6s38f/4NdKNbrJCWCi/4jh
	 y5SPZ2NL4vaJybG1RJOII/tf7vjW2LThw4pMX321qGDEfuTIkqgGXgB/ayXOrrToBM
	 RuFZJpzPbGeDy0EneIl3mmPcWDBS5VNVccL5pwtkz0ryjD/+w4Y8NVcbeS9xagHw6O
	 iZbERAApO8df1E/whFCaUY4umKoZXvwh0mH30/Dq/EWqgWCsKmF+GVBo2QmZUkjltt
	 wm6PeKlrXfGuQ==
From: Carlos Maiolino <cem@kernel.org>
To: djwong@kernel.org, kees@kernel.org, alexjlzheng@gmail.com
Cc: alexjlzheng@tencent.com, linux-xfs@vger.kernel.org, 
 linux-kernel@vger.kernel.org
In-Reply-To: <20260410101106.2523665-1-alexjlzheng@tencent.com>
References: <20260410101106.2523665-1-alexjlzheng@tencent.com>
Subject: Re: [PATCH] xfs: remove the meaningless XFS_ALLOC_FLAG_FREEING
Message-Id: <177729637708.100803.10895271333001567849.b4-ty@kernel.org>
Date: Mon, 27 Apr 2026 15:26:17 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3

On Fri, 10 Apr 2026 18:11:06 +0800, alexjlzheng@gmail.com wrote:
> In xfs_refcount_finish_one(), there's no need to pass
> XFS_ALLOC_FLAG_FREEING to xfs_alloc_read_agf().
> 
> So remove it.
> 
> 

Applied to for-next, thanks!

[1/1] xfs: remove the meaningless XFS_ALLOC_FLAG_FREEING
      commit: bfb4dc533d0abaca07013dd71e6b5c6f182232b3

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>


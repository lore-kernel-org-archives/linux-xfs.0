Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5ED1E1FBEB0;
	Thu, 17 Jul 2025 08:11:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752739916; cv=none; b=t7NShJGEwiWqngITlVtVHyZAVOGqQT7wfQw2MvGp+1feqsysgid0CrTf9bW9+E5kGFKef27hhcTD+cGQHOLkMaJ8ozZmxH/kTjy/u45n8MxqPoZc2MMpGn7dxqoFENs6r+ydZG0SlKGZuqLNfQBm7MO6/OJ2JxxJHF05jNW9d+Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752739916; c=relaxed/simple;
	bh=16FajEccwHwlnwLR3yWAQb1Zfx+vgUarz7h+/oSDnoQ=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=XrqOF7nEEzZV5NT9kJRb9y44xf1i1+DHC2TEPB6NO5ACSnXYIinXRjvq6hCQrHLFCu681UzidWNPPfuIDgXoMoL0z/OylWQ9SUrBZpuvMiZwrG9zUSOPeviOHkEVJtfARdH771yZeLRgmPd3BUH5vUKS9XVTey999iZH/ViAGt0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=S1GpSsRx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="S1GpSsRx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74328C4CEE3;
	Thu, 17 Jul 2025 08:11:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1752739916;
	bh=16FajEccwHwlnwLR3yWAQb1Zfx+vgUarz7h+/oSDnoQ=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
	b=S1GpSsRxrPog8XVX0/nU7q2edJ23b8gY3qafRZ0dBn7gPs87TLI4YariTDTycZazc
	 DCEm2xODgeMU5Ygrkjp90zPbL+bNeRwJymA7TklzdFBGJtuw44S33Y2OlWAmLeyrwM
	 P+pH2RFvC8/fci//l7LGvvXTFEvCQ54quHsa5k95wd19zKcewcV8mHsj1x2BQ32lh1
	 tL/zQTIyBYwy/s3vKus3x+uZeof2N2rR7O76+C8eK0xs08T7bdeb2qxFITUlmXSYdD
	 0eeuV2lts413ODzI2RtpGMIQQcglgpZDzCJRSShBj5UEexQQVj0+Hk994UkWrf9U8j
	 adYKVQdRPHLMA==
From: Carlos Maiolino <cem@kernel.org>
To: linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Pranav Tyagi <pranav.tyagi03@gmail.com>
Cc: djwong@kernel.org, skhan@linuxfoundation.org, 
 linux-kernel-mentees@lists.linux.dev
In-Reply-To: <20250704101250.24629-1-pranav.tyagi03@gmail.com>
References: <20250704101250.24629-1-pranav.tyagi03@gmail.com>
Subject: Re: [PATCH v2] fs/xfs: replace strncpy with memtostr_pad()
Message-Id: <175273991411.1798976.8807586942467091508.b4-ty@kernel.org>
Date: Thu, 17 Jul 2025 10:11:54 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.2

On Fri, 04 Jul 2025 15:42:50 +0530, Pranav Tyagi wrote:
> Replace the deprecated strncpy() with memtostr_pad(). This also avoids
> the need for separate zeroing using memset(). Mark sb_fname buffer with
> __nonstring as its size is XFSLABEL_MAX and so no terminating NULL for
> sb_fname.
> 
> 

Applied to for-next, thanks!

[1/1] fs/xfs: replace strncpy with memtostr_pad()
      commit: f161da9418910f4ab7a29099682d03e06ef2c3ef

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>


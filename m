Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F0E938FEFD
	for <linux-xfs@vger.kernel.org>; Tue, 13 Jan 2026 13:10:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768309838; cv=none; b=pjexKynD96oueQz8BDx+cLjKHT1TbiNOnjDtQDSOwOqf49KurIZWfpVAMI2wt62jB25foPH3jEmeJo5ggmkT/wRMqrZI0ahBLBw8gAHFmFm0VGoP8BfycFKVqYKZZTZymOjAQhEgUy9FrucONCy+BHMX6xeCb3Jh4GY6HU+0AXI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768309838; c=relaxed/simple;
	bh=/jdkQUcNvB0uH7PUA7/2/gJV0mvvGhkk9YJ7yI2XGLE=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=LnPy9TENjxsj5leqTZvzVeHVj1hNr5I3uFQwBpGD3lcccdanAgKKaxUIWJBFM9cWwaCQobgF3snPCMGqjFAa8amfc8hh6eHXej4hWzHE/yrDeYL06VMiKbM0Fg35NipQv2+APA+7GGpG1uuOHAl7R138OFLxZhhghTRTa5gAYY8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KbUr5M7B; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KbUr5M7B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7F72C116C6;
	Tue, 13 Jan 2026 13:10:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768309838;
	bh=/jdkQUcNvB0uH7PUA7/2/gJV0mvvGhkk9YJ7yI2XGLE=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
	b=KbUr5M7Byq3Ci5PXbNpjsheQW1BCAQS8edKELAwO3fh0+wy5EYbHKU0m4yGbNjHlm
	 7guOJZUXjkL/fdvCRThEcVYw8jO/y/aobW/giHDMV90yQ0yOCx2C0KyPXBZPCZXb2A
	 RWndcF+mTY6mriHGD03x11A+HF7T1OHE9XgQkAZTey3vLVGQG1C+fXwib3osyiPMR5
	 DTIJ3qY3Obr2m+dH6kFr/CA2QcnBB+VTwiEdeY7UN7ERpJe7lrfJF0PHwEORJWz8Vq
	 Yb8RNlNIL/3mgXqPPZiHc4olw9wJfxA4PL+M2NkB5INPexlFAV7iYxzoO4moKFTHd3
	 +5tc89iTAs0Kg==
From: Carlos Maiolino <cem@kernel.org>
To: linux-xfs@vger.kernel.org, 
 "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>
Cc: ritesh.list@gmail.com, ojaswin@linux.ibm.com, djwong@kernel.org, 
 hch@infradead.org
In-Reply-To: <587bff140dc86fec629cd41db0af8c00fb9623d0.1768212233.git.nirjhar.roy.lists@gmail.com>
References: <587bff140dc86fec629cd41db0af8c00fb9623d0.1768212233.git.nirjhar.roy.lists@gmail.com>
Subject: Re: [PATCH v4] xfs: Fix the return value of xfs_rtcopy_summary()
Message-Id: <176830983646.127908.7489436660038350966.b4-ty@kernel.org>
Date: Tue, 13 Jan 2026 14:10:36 +0100
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.2

On Mon, 12 Jan 2026 15:35:23 +0530, Nirjhar Roy (IBM) wrote:
> xfs_rtcopy_summary() should return the appropriate error code
> instead of always returning 0. The caller of this function which is
> xfs_growfs_rt_bmblock() is already handling the error.
> 
> 

Applied to for-next, thanks!

[1/1] xfs: Fix the return value of xfs_rtcopy_summary()
      commit: 6b2d155366581705a848833a9b626bfea41d5a8d

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>


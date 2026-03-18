Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D77793B7B74
	for <linux-xfs@vger.kernel.org>; Wed, 18 Mar 2026 10:12:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773828761; cv=none; b=KGJo4+wMW/65xasDyKHPaJUHrc2LtwvLCY588ZFDBH/shkQzq89DgAl36fUxDntc7DVbpBa4HqZ9F19vWgEaF5mpMFVJn+PtrLGNtBMOFN3UoGqKcBjYr2nKsPj9PiyyTbaO1f62Gjkf2huBNF8gV78pycvSJD/EGeRZ+SZi+CY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773828761; c=relaxed/simple;
	bh=a5G9CZn4/2xvqWMKonXHZRrEy2OyTXGXjJIVBxWXx7Q=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=WOwx0qnahL8rLfc4k89pJE+wE2699ZhpXs9MOVXoLkP1CdToDt3PWzxGnYXthy/+rNhwCsgNc8oEXlzTtj5j+iSB/HFGqzMaEzpOYwyGHFmT7defXJfHzNSkEnlNFeiVfycwQlSGeWJv9I08JHnWEv6z4HRHZ6CP59Y1GjI4Hts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jZ6NOIcF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jZ6NOIcF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 619B9C19421;
	Wed, 18 Mar 2026 10:12:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773828761;
	bh=a5G9CZn4/2xvqWMKonXHZRrEy2OyTXGXjJIVBxWXx7Q=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
	b=jZ6NOIcF9YGMzXYU4ZN1DV9/yqTsrWKNPzXUYYmWSAGMxxtBpe0MKRiBhueha2MC7
	 WFg7rrz2x4/QLRdjFcxo4QFUsv0XfJE8mI5217jOzUz7eCLsFt8QwOlqQGKrNewm8j
	 +6GzeHsMbNoaIIZlty0PGVG6km+OpfhEQsYRcw2fU6hO+zM9/5M0LMSaXFY83w6XbE
	 QFoX58JAlj0N06r6IGUPnxamhBpav7u0BMHnfxfAaksyODXgdeaa91/qiC8CMlymMF
	 CUPub/HMFPBsP8meQ9arMsyhEPSkCO4sUk/s/Y0RwhooCTZzB/f3Bx0kefPf/QwIuM
	 TxZQryCqyrF5A==
From: Carlos Maiolino <cem@kernel.org>
To: linux-xfs@vger.kernel.org, Damien Le Moal <dlemoal@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Hans Holmberg <hans.holmberg@wdc.com>
In-Reply-To: <20260316114020.753228-1-dlemoal@kernel.org>
References: <20260316114020.753228-1-dlemoal@kernel.org>
Subject: Re: [PATCH v2 0/4] Zoned XFS code improvements
Message-Id: <177382876011.271956.1925876275927718989.b4-ty@kernel.org>
Date: Wed, 18 Mar 2026 11:12:40 +0100
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.2

On Mon, 16 Mar 2026 20:40:16 +0900, Damien Le Moal wrote:
> All,
> 
> Here are 4 simple patches to cleanup the code for zoned XFS.
> Overall, there is no functional changes introduced beside the change
> of information displayed in /proc/self/mountstats (patch 3).
> 
> Changes from v1:
>  - Split former patch 1 into patch 1 and 2.
>  - Changed patch 3 to add new lines of information instead of changing
>    the existing lines.
>  - Reworked commit titles and messages.
> 
> [...]

Applied to for-next, thanks!

[1/4] xfs: avoid unnecessary open zone check in xfs_select_zone_nowait()
      commit: 770323d418ed5848cc21af172f77377b2cc0542d
[2/4] xfs: fix a comment typo in xfs_select_zone_nowait()
      commit: 6a82a691b08070ad03b237d7db89aa0bfef389e2
[3/4] xfs: display more zone related information in mountstats
      commit: 68aa101bf2046aa8365333a3768cece07975ca5f
[4/4] xfs: avoid unnecessary calculations in xfs_zoned_need_gc()
      commit: c1f955437440f92632e2efca4b591371bb3caefc

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>


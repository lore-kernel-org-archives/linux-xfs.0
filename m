Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E63E934BA2A
	for <linux-xfs@vger.kernel.org>; Fri, 19 Sep 2025 16:15:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758298557; cv=none; b=NOSPjGdZfH6QjF9VMv+o8uUAK5XDcWmujYgrayoDILs8p2IQit7hJJsPIHfCUMqqFvV9ZrgvaE4etw4q000NXt3adoNW1nnQWb/a6mmdCqC5VLUII571turbU8vTlSVj5Au2p7p4j2kVh051ZBwbZmC5XScugWfk2TPWFbqrd4g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758298557; c=relaxed/simple;
	bh=dnD2t96VXxkXuAorMEXv/ccjMDIQFTX8KdU85nfxg6A=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=AqcJL1l3b0PhCxPOTQOav7qrc66fRsAcW+SSNkxbGtllMpDp1TRWmUkDT9bYeiK681tIY2LkjD2RU0UydukddkJhN2JQEJOg6u6FP30yFPupSSJtp7sV2kRV8SoAwNJPhPlDGcHTw+q0DpcWn4CDH3WNI1SVu+INjSpi2XUR84w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=B9mouyx6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="B9mouyx6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FE68C4CEF5;
	Fri, 19 Sep 2025 16:15:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758298556;
	bh=dnD2t96VXxkXuAorMEXv/ccjMDIQFTX8KdU85nfxg6A=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
	b=B9mouyx6zKk+Aeg3uNCJnO92xMYCZ0Pdv+l25df0XPCIz1gBsM+uFj4S3VwqL7EUf
	 bF8x/8TG0S0T94A6/Pzxve9Eu3IeRF0eJR6DGvsQp7Dsv0JA88SRxzla6eeOddBPxY
	 YHE/+YiDMBlwDwSw8/OHHiC5bcaSHV9zQTLRFIuBoXKH8cU78Om0yZK5EZqDrCfMHR
	 zkvSSqZ0RDhJCQbhFeVbvdi9PewGh6Z/W98No5zA1bt6c3UtQSN1zjn8UZ534Qvvuk
	 08EW5jH1xCwtuvur5RS6mWz5Z4Kd29HyeeF8JEsI9vnYBq+LAIl+j78CV3A3yrD9Yj
	 ItiyYaRtGPY3A==
From: Carlos Maiolino <cem@kernel.org>
To: linux-xfs@vger.kernel.org, Damien Le Moal <dlemoal@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>
In-Reply-To: <20250918130111.324323-1-dlemoal@kernel.org>
References: <20250918130111.324323-1-dlemoal@kernel.org>
Subject: Re: [PATCH v2 0/2] Some minor improvements for zoned mode
Message-Id: <175829855570.1207654.6129541107287530799.b4-ty@kernel.org>
Date: Fri, 19 Sep 2025 18:15:55 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.2

On Thu, 18 Sep 2025 22:01:09 +0900, Damien Le Moal wrote:
> A couple of patches to improve a mount meaasge and to improve (reduce)
> the default maximum number of open zones for large capacity regular
> devices using the zoned allocatror.
> 
> Changes from v1:
>  - Improved XFS_DEFAULT_MAX_OPEN_ZONES description comment.
>  - Removed capitalization from commit titles
>  - Added review tags
> 
> [...]

Applied to for-next, thanks!

[1/2] xfs: improve zone statistics message
      commit: 8e1cfa51320da0cf599d286c89db043f329ca6b0
[2/2] xfs: improve default maximum number of open zones
      commit: ff3d90903f8f525eedb26efe6fea03c39476cb69

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>


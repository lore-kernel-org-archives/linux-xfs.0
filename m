Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3BA41F1301;
	Wed, 12 Mar 2025 23:07:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741820858; cv=none; b=Zvkm8qAIpg07vDKY9E3/27mtB+qIWPPLPea2ItYqfDOItXoIpCxqUvFzn5dpF6mB+Adc8Buwow2B8Y3dDFsihajeRDKO9zXxaUJNR3gdikWEWwxO0oO6n7WDV3REpeVoSTbR5tAO0dw42EpYK0thOKX6gNeWShyv0igBBV4kCGc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741820858; c=relaxed/simple;
	bh=l2A89hpHHDDFtFx2ZvxTLYt/zSJ3XbjfjDwasJpGKFI=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=FLZqcPbXnZ8wZKoBVLMiMY3SEMtPGQaAhCP7YU61bzNUsr04Sfl5Q+xQTwAZVgYJgmsEgEUrHcxTC0huNRjiaUfHuClX1LXjht75pCgIanaLkCJW67a9gS03g3PVVlluGLK17cBINE9RF7WJqunIXwnda2grcut60Rxx91fzSwQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YXJiY7Gt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YXJiY7Gt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E0D8C4CEDD;
	Wed, 12 Mar 2025 23:07:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1741820857;
	bh=l2A89hpHHDDFtFx2ZvxTLYt/zSJ3XbjfjDwasJpGKFI=;
	h=Date:From:To:Cc:Subject:From;
	b=YXJiY7GtavoO6N/2eBhH2A9VdV/+vWMQSnHQ3xBzSvvsZ3IiQPvk4Xt+B/402Q13U
	 lASk7V30EOpo4YmzAT2AnGTfZQdsHG99ny5iiGN1O4DO5Nj6uEof5wcG7CKA57MsmS
	 UNFUUZpJXd+2w0dh7tn9DZTz2Lmo/lyK08N7B3zRFLBOfQ/dCeYVmWNeDNaLhbTbGk
	 4m8oRZ8czp+2uW+cXwHRHH/3zGsf5iJFFFNsMfNA2EMoEpVi/yinVPu/sjf/P2LBaD
	 KC+2RZimy+eh2cwoevzgUiSJ5CJRiEOyrL91E/bX9XWoBDuO0lXxEClz9KwapwuNGw
	 CGFfUyKVutJgQ==
Date: Wed, 12 Mar 2025 16:07:36 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Zorro Lang <zlang@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: [PATCHBOMB] fstests: random fixes and 6.14 stragglers
Message-ID: <20250312230736.GS2803749@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi everyone,

Here's a fairly small series of patches for fstests -- the first two add
functional testing for some new utilities that went into xfsprogs 6.14,
and the last one is all bug fixes.

--D

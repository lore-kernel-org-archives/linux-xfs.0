Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D1491CAA87
	for <linux-xfs@vger.kernel.org>; Fri, 21 Mar 2025 16:26:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742574409; cv=none; b=XQTh750bKOi55ELB3hpTTz59bbuCUeOM+/HhMZwdImFf/zaBPxgMe8A327Qh8eewfODf4T0zAUcIKS7NnggLPUN1dp7O7oIAs1yY515VEVCSPHKga4MzYz94E2ePnuPGXGIKdlvEpjk7cbkbGUAXQcbUGN4yuWEWJzQH9+lHdug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742574409; c=relaxed/simple;
	bh=eF3yt8qJ/t5oY3/a5EUb/RNL1/gu/rPvGwc5uRwIXiY=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=p1yzrIZrqt4zhtn8Ep9/zYDKYm6P9UXRXTo9YK5zBslmevRELmk23+94j44q+dnZCRmogloQcsVzA7liPjxRuFInC18IaCuFe43go6bvprJG6qYQ0bRcwtyjRVLxnTDDArDCa5iKtaLS41Se7ZlL+QUQR/FSHJ/FAVYunJgW7ZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AByWSfaM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AByWSfaM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81955C4CEE3;
	Fri, 21 Mar 2025 16:26:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1742574408;
	bh=eF3yt8qJ/t5oY3/a5EUb/RNL1/gu/rPvGwc5uRwIXiY=;
	h=Date:From:To:Cc:Subject:From;
	b=AByWSfaM8vp1fKgjnGq8YzF9llGYgOi0AZf7OGVaxpwIKlpMqmYpYhVtRziw1Uq27
	 vSwDLO+iEYJdhorb/tPhoNpFWbhAwDCD+wHppKW1iHTflHtFx7Uv55tZBBUor6FLdn
	 sWbOPbClHx4hoAFHSK0l7D0dhRJ5rg9Q3scIQA+1kRGR6xTFrVPVC1/UIZhnRfB3Fi
	 f8F0Uv78MnTbikLyM3TNkZg+DW5sK0IrS2z6dh8iZFX95HQXyiO+ENrbfF/2D1NYRY
	 X4RTCmtGxfr0/PLeZZkI9liAh6cPNotoZ2TiXtrM2+ACb+hpq+zy7hlAyPo1z4qy1o
	 DLHlgiJSMggCw==
Date: Fri, 21 Mar 2025 09:26:47 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: linux-xfs@vger.kernel.org, Christoph Hellwig <hch@infradead.org>
Subject: [PATCHBOMB] xfsprogs: last few fixes for 6.14
Message-ID: <20250321162647.GN2803749@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi everyone,

This is a collection of fixes for bugs that I stumbled over during the
6.14 QA cycle; and a libxfs sync for a cleanup that went in after -rc6.

--D

Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1831D27874F
	for <linux-xfs@vger.kernel.org>; Tue, 19 Aug 2025 22:54:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755644043; cv=none; b=sL6dSj9NzZr4wj1dhvaCAhCSVTy7DMVrUIupZoMn8i/Oz0g5DU7kHRlxb9VnCa5ZhxnObNj7bEKlR7EKTcUWoyZsidAhu0tkZEQP3kLWYSyaJ8US7mofuud02EGT+YS9YNciJrSYeiE5jKHUzB6HFB2WkMWfe47QSMAXZmq9hTs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755644043; c=relaxed/simple;
	bh=HvhnMb3wN1H8mxEpL4ss2360O63Tj3YQ7CMPpXcyBRk=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=nPcLpSLed2aC5DxVNXqX0n15L18T1q/8cwLlbQ3yCdasNJzQPSapnBjExvkfwbWkfxdTi4BUmHscmSn1ijoFO4piODMOTVF7fcyTjJXKmQxRZZ4edjP3zRof6ff55U0VsxOLgjIq+T1Nll/ey76vxg0lGQgaJWujaSGT7zIUsY0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uDxuFYW0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uDxuFYW0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85391C4CEF1;
	Tue, 19 Aug 2025 22:54:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755644041;
	bh=HvhnMb3wN1H8mxEpL4ss2360O63Tj3YQ7CMPpXcyBRk=;
	h=Date:From:To:Cc:Subject:From;
	b=uDxuFYW0zc3e+pYbHjHEJKoVc9q8WKlJ2mhQD2SCs2Rbu2QZ7mKmv5JWFyKIltRQO
	 2phHpfiFR2Vw63HPqJuyXtrZoEzK72s64jv8IEKgXxbgAdYE7rw9Ryd3JlAesBWwT5
	 sF4pdPoPoyqIs/k0pyuGD2l09v5q2xw5vOJduZCNv0i+sgQSLLMP25UJZsKOWrO+X+
	 DhXjYs48Or28pm1c9sq0JrPoDUzMecryzXc0SL6Kz73cRzdaNXoOipTA52vrNENT/b
	 6aVqgg8kvgQ9ofb9pSFB+GJ98ysSgZSXF4HZ3A5ZPwcYrlIv/CbwJy0Qo+jHrVSGIO
	 FviRqVINLVnyQ==
Date: Tue, 19 Aug 2025 15:54:00 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Carlos Maiolino <cem@kernel.org>,
	Andrey Albershteyn <aalbersh@redhat.com>,
	Chandan Babu R <chandanbabu@kernel.org>,
	Zorro Lang <zlang@redhat.com>
Cc: xfs <linux-xfs@vger.kernel.org>
Subject: Yearly maintainership rotation?
Message-ID: <20250819225400.GB7965@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi everyone,

Now that it's nearly September again, what do you all think about
rotating release managers?  Chandan has told me that he'd be willing to
step into maintaining upstream xfsprogs; what do the rest of you think
about that?

Also, does anyone want to tackle fstests? :D

--D

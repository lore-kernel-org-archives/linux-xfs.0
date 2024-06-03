Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52D8113A41C
	for <linux-xfs@vger.kernel.org>; Mon,  3 Jun 2024 18:45:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717440313; cv=none; b=O2cHsmv4AM1FcmRcFymgV8NLqkwRv14NQRbj3IDQW0PiF48ztzIRo2Gga3w6RN6eUHmYxibh1qdFGpq5tDgco1ZJUJj3wFE9hQkQASNdz5nm6wm68ZG932jyuINr1YESdw/GicXudicNfRMQLI+pO3cY3Kwxvmord/DbnhmpWuE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717440313; c=relaxed/simple;
	bh=LwoMD+0W1D929etmi0eF5XWrW5cG7r0pg2irWQLWgBg=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=Uh+CNROciG9yeNzVmWl3S4iyhZP7lDUfo7qhIauDE/AGQvbUMYn6qf3CFXCGx6dIS56nV0sX/TC2G2L0yhj50eodxeX5pykJiZeBMKFmL42/Chr/BkJCWyXpCjhKgJ+5oUyH+ZW2Bx8Lqxv94SCfg0FM1QM3BkshjfKNxgY6/UU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JD9d8rmN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JD9d8rmN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6EA4C2BD10;
	Mon,  3 Jun 2024 18:45:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717440312;
	bh=LwoMD+0W1D929etmi0eF5XWrW5cG7r0pg2irWQLWgBg=;
	h=Date:From:To:Cc:Subject:From;
	b=JD9d8rmNDFiCCZFIFSVUMgtfygllzrFk3p5WIQSkh9TIkq+DTfQyiqT9N1OZbuuEG
	 WmZgqvSyjYZ2E5oC6My7P2uaUaRmlGh28mbeDtsjEDpObrvsJ0qn3wBb1z3pCfXtN/
	 l3V8M0hjBqFw+tHy+5b4GQt248RKqxa/cEUNKpr2+dACskPO2lbZyxh9IYIEJNzRSO
	 8Bx0YnLT7M0X1hfea/33EWEir7q4CCFNv6VN2HpCxuVPeLcA4E6vh+3Ha0rKergT1v
	 QKCrnSusDPn/U4g9IVdhg7lCDl+rMmRVaRHxOT9dlgtvd1Cura9BTb0DZz+CV5xHNb
	 gocPDFUf3ASPA==
Date: Mon, 3 Jun 2024 11:45:12 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Carlos Maiolino <cmaiolino@redhat.com>
Cc: xfs <linux-xfs@vger.kernel.org>
Subject: [PATCHBOMB] xfsprogs: catch us up to 6.9 (final)
Message-ID: <20240603184512.GD52987@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Carlos,

This patchbomb contains all the patches that I have prepared for
xfsprogs 6.9 against the 6.8 release.  These are the final versions of
the patches; a pile of pull requests is coming shortly.

--D

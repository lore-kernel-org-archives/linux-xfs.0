Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06F831CF7B7
	for <linux-xfs@vger.kernel.org>; Thu, 31 Oct 2024 22:57:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730415442; cv=none; b=EhHEO+ITqPPO+4MUUnPNA63fTS0lShmQxz3W7oLcRv3WH7Gy06b9upI3kQTYfHFNtTHO+d42OMmB49WB/OOxRD6IHjtumKDCmkxyWeoiM2nHliIEasLkfxKhIT0mUyqKhuZAMB41EBYwYXrPLzKHeEAZKIb/687LSLZWGrkmQuc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730415442; c=relaxed/simple;
	bh=K2CHE32p7m8FqmYlbu1jlInaYR4NEQD9EmT/tKFdyI0=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=Ute4AFpeXXgEbSeIdKUTkmH+Fnoswgz/KUGWYbbgArt3DLseDwN438YFBdOSXoDke1bMkRRapat9D0Q62Sya2uadrqQqtZ2NpG3D9py5vOitGriTesOrObCGT5g7Z9cYB2uImW6kJoy2TEcBbU/iYWCBloPGX+FASNQ/6IOm9Mg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=r1c9oYU9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="r1c9oYU9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B4CDC4CEC3;
	Thu, 31 Oct 2024 22:57:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730415441;
	bh=K2CHE32p7m8FqmYlbu1jlInaYR4NEQD9EmT/tKFdyI0=;
	h=Date:From:To:Cc:Subject:From;
	b=r1c9oYU9gJR8r4b0JGaWTt46YqkeXLnL4pJH1HqL0rp3FPBmWANgYM/6T6AHE4BuT
	 IqTlaW5AG2SNtIvKkp7LRgXBFI3aLZPzh/yxc/GX/Tgc4BkMawivA4N11Qx1peWpG+
	 ct8iiQShiTCGvM+p8idF+02CYFBVNaKAOkYZtUNAuerYRBQcXvWkO1eEnM1v0XmnF7
	 EHCAw7a/LH26/77m57vPHhTo5XgLn/zGn4NfMGtXjOkGZIh+kbs1EoDYas6Sf5woQM
	 a1EqvVJBlb5L8jz00Z64SnlxoPQV146aJz2YuCWERzVrokvO420Zz1bmi7XoTv4qHJ
	 bWSk5NMQH0pzQ==
Date: Thu, 31 Oct 2024 15:57:21 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Andrey Albershteyn <aalbersh@redhat.com>
Cc: xfs <linux-xfs@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>
Subject: [PATCHBOMB v3] xfsprogs: everything I have for 6.12
Message-ID: <20241031225721.GC2386201@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Andrey,

All of the patches that I've submitted for xfsprogs 6.12 have completed
review, and I'm about to send you pull requests for all of those
branches.  However, I'm first resending all those patches to the list so
that they are archived in their final form.

With these patches pulled, you will be in a position to say that
xfsprogs is (at last!) in sync with the kernel.  This should make it
/much/ easier for authors of large patchsets to run QA on matching
kernel and userspace.

--D

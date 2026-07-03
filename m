Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0650B433E6E;
	Fri,  3 Jul 2026 04:07:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783051635; cv=none; b=d6flVeK9vxC41pQ6TyYDfFqYnQQg8GM70iL3qi1lFQNGg0hq064QDsXJetzF0yOjqKbflwHj27KWsCoVL5DgDh4EZz0ezvE56MNjCLp1m76bgVnYwF/RRWLiFrKIFmN65T2Jj6JURVfjJMGslwtDA/EeOm7iDwKBeBGgEW03tC8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783051635; c=relaxed/simple;
	bh=wEKIWMO+Ri9HU5A73QMQR+McU5xrYBw9V7Uhhb1oqG0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I+BhloVnrsmS1jkKX59w5QnTR9Q9WnA4tZ0tPf3S9gbx8XQyUTLR7AJOXW+vBeYAWilGF7VzO20rpKNrIR2jkN5zEs1FVGsewbT1cCppY6EMulV6kSMJp/R7L0qSdJ8Zzfk4cO4eW6h4AnuD4P1OJS8kBZBYp99yhTgNOHDFGlY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bCVZ8VVh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bCVZ8VVh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED3D61F000E9;
	Fri,  3 Jul 2026 04:07:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783051626;
	bh=IFe9Sp6FyX4tHzurXt9t8eys+Iey+CwAfcBnVhDFwHs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bCVZ8VVhnsVYpsHprUqFQf2is9OAtzv9SwOZmrgDS04suSX32ZMNyoYjRxUujeTlL
	 xmGQil2qT1SNDu2lLtALBVMcvhFrWV6g1JYpjRF8Dn+XFnoOvqSEhWJe0zqplaRohj
	 PpVsIpZ+BI+xHr28A+pwyOmDrYCq1q2Poggf507jfoMWiEZWU3LKOX0dC/HvN40MdM
	 JiQUqws1HPKLBIiWerUUOMzX8XCHIApeF0kXZKAyUpvF9Vzr+GX3SsVPlaL+52colO
	 VLExSIwqrK0zg5Z5Fb5IcIGKlLQTtjmgtaKAWrC2mqOvN2D64PZCS2gYP5GdImUrAE
	 wLiBOVyjo5GIQ==
From: Sasha Levin <sashal@kernel.org>
To: Hamza Mahfooz <hamzamahfooz@linux.microsoft.com>
Cc: Sasha Levin <sashal@kernel.org>,
	Carlos Maiolino <cem@kernel.org>,
	Amir Goldstein <amir73il@gmail.com>,
	Fedor Pchelkin <pchelkin@ispras.ru>,
	stable@vger.kernel.org,
	xfs-stable@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Catherine Hoang <catherine.hoang@oracle.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	lvc-project@linuxtesting.org,
	linux-xfs@vger.kernel.org,
	Leah Rumancik <leah.rumancik@gmail.com>,
	Theodore Ts'o <tytso@mit.edu>,
	"Darrick J. Wong" <djwong@kernel.org>
Subject: Re: [PATCH 6.6 0/4] fix kernel crash for xfs/235 test
Date: Fri,  3 Jul 2026 00:06:56 -0400
Message-ID: <stable-reply-xfs-235-fstests-66y-20260702213502@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260701163310.GB6517@frogsfrogsfrogs>
References: <20260701163310.GB6517@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Wed, Jul 01, 2026 at 09:33:10AM -0700, Darrick J. Wong wrote:
> On Tue, Jun 30, 2026 at 07:39:32PM -0400, Hamza Mahfooz wrote:
> > Any idea on potential paths forward for getting this series in
> > particular into 6.6.y?
>
> Run fstests, and if there are no new regressions, ask sasha/greg to
> queue it.

Thanks Darrick.

Hamza, could you apply the four patches on top of the current 6.6.y
tree, run fstests, and report the results here? The series was written
against 6.6.84-rc2 about 15 months ago, so a fresh run against today's
6.6.y would both satisfy Darrick's condition and confirm the series
still behaves on the current tree.

Once a clean fstests run is reported I'll queue the series up for 6.6.

-- 
Thanks,
Sasha

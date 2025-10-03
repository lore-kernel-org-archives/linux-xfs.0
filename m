Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBFE423B62B
	for <linux-xfs@vger.kernel.org>; Fri,  3 Oct 2025 01:14:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759454082; cv=none; b=iohoionsL9oc8N7GoIlJt+wHCLHOxSM6KNNF+83OJtveg601Jps8sueiQIoUKIm7Gax7IWiG59xYGGKqJ0LKWWhjXUWbJ/MMydAzYG/pJMdBDTTlazpT7zAqAEQW73cq8o8UolfdDQouMoigE7Jm8QRKJ1CmkAtGfY4TwEGAMOc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759454082; c=relaxed/simple;
	bh=g7StM9ZGeXi6cgDZIWSAuEFzvOHFlaEvFszdipK/1/8=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=Om+6fjtWetTM50hvZ85aEJ3socDcsiRR3ILrs7yLcLOitr56MG9/nRFjcOV2GApyLM5uNPkmepe6va34YuOYSnKUpB4Eb8WvMJHZh6KbwigxgiVo5LLz5attuehx6RyIssHKiZnykyGUP6tvdl9J4NDEzdjRJTZjKIhlUXmsqHc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=C0/G4y64; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="C0/G4y64"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C4F2C4CEF4;
	Fri,  3 Oct 2025 01:14:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1759454082;
	bh=g7StM9ZGeXi6cgDZIWSAuEFzvOHFlaEvFszdipK/1/8=;
	h=Date:From:To:Cc:Subject:From;
	b=C0/G4y64609ScKvSPxV9HUUApjdKn8J8X+XPfouSi4SMSQSQZmFrRJFQRgSSxG8cj
	 gMXXIV+jm4OLww/GEqB3g8nN8FwCl6vM1XmHi0HZ9HKNx+6bLG//JCAJFMKU2dG8Hx
	 icXbe7O0iqEPCE8F+V35n8wT9BfHkkxPeDOixdLdID0HztGjokg8v9XP/qOLBEhwwi
	 uhElXOn/6lcau5N7I8AALyTtT8eqdMa7AQ8R1XBCPKfsu02M6VreGSVJHHgdZvFtic
	 qpEevCPiUg42BQ0hXV4QAEiY7uv6kVXzBRHbjuG48/phJToPnjIhgm753mqaynDAE7
	 LeeiLNAzVWuVg==
Date: Thu, 2 Oct 2025 18:14:41 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: xfs <linux-xfs@vger.kernel.org>
Cc: Leah Rumancik <leah.rumancik@gmail.com>,
	Amir Goldstein <amir73il@gmail.com>,
	Chandan Babu R <chandanbabu@kernel.org>,
	Catherine Hoang <catherine.hoang@oracle.com>,
	Theodore Ts'o <tytso@mit.edu>
Subject: 2025 LTS maintenance for XFS?
Message-ID: <20251003011441.GS8117@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi everyone,

Just out of curiosity, is anyone interested in picking up LTS
maintenance for XFS 6.18?  I don't think $employer is going to go with
it since they just picked up 6.12 for their latest kernel.

Also: Is anyone actually working on anything older than 6.6?

--D

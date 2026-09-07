Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 951933B1EC8;
	Mon,  7 Sep 2026 06:29:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788762554; cv=none; b=dvA3+70CVMuLHhslHJugeNnTUiLOzI7T5XQslQ5YzXg9rdMiVr0pItbdg3LCUvc8+sWATWvnyqdm+aT4+pP4jCts2RS+/yhwJlUVaZc6FSNSE5dXuFrZWXartH7PMTUnnDfUWCkZve0NPE78RyF/ko8X0CEQd6h2F+g8Xpjfo7o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788762554; c=relaxed/simple;
	bh=O2902fyp4tcgi/ADsb3iYSKo3rx7CRchep7IuCHiTF4=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=crcfgCyL1OWd2YKwjBGs9fUGl/wEZWP79bBR8jR+XMol9AspqIe3VATfRc9Yc7/f/y9pP8wIKCIKhyNOoervGV6V176yGkCPk6YvfoBDYEjJ5q5PZ2Fhpy2Lw3IwdpUJiTN+uXIrJlm54y0dJmgZ6r+D30YbXSaCvMku2JpLSfU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=T9vl42Zy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="T9vl42Zy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F31631F00A3A;
	Mon,  7 Sep 2026 06:29:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788762547;
	bh=biwVxPBaTEVTjX7THMNsqyp/lhGPTUQ6uE/djrmEAeg=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=T9vl42Zyqs0P61aSk6vG6OzsBLsmoOKybsK9l6AzfZWgiK1hAJueGoO5dJB1JeOU8
	 fhEvJg6XMs9OAA32J2a2MaV7tW0VipPHU8FyRaUdos/yUmJoRjSMtpQMgARJHKoPNj
	 HSDe4pr6xGeUeLzb8+hkBnkjhuiqZPHZdIJerje6oy4AK82Dk37gXsVvNlpJm7WYEs
	 8RGgWO+XFeQWX1qdcNqiDUzc7y7o5INvkpLHrgY1szlQbsR4sJb23ja3WnGY+hMUHL
	 dbNwN8Ydvo3AgiorD+EH08jt/fI9YnXNoTBR33cr6BI/ptC7/WAx8BtyG/QyWWY0TZ
	 fzb5LKVTLNnjQ==
From: Carlos Maiolino <cem@kernel.org>
To: hch@lst.de, "Darrick J. Wong" <djwong@kernel.org>
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
In-Reply-To: <178840969793.484660.11718284266382755759.stgit@frogsfrogsfrogs>
References: <178840969793.484660.11718284266382755759.stgit@frogsfrogsfrogs>
Subject: Re: [PATCHSET] xfs: LLM-inspired bug fixes, part 10
Message-Id: <178876254670.14253.464463755332532348.b4-ty@kernel.org>
Date: Mon, 07 Sep 2026 08:29:06 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3

On Wed, 02 Sep 2026 22:51:00 -0700, Darrick J. Wong wrote:
> Here's a tenth batch of xfs fixes resulting from a LLaMma.  Mwa mwa
> mwa...
> 
> If you're going to start using this code, I strongly recommend pulling
> from my git trees, which are linked below.
> 
> With a bit of luck, this should all go splendidly.
> Comments and questions are, as always, welcome.
> 
> [...]

Applied to for-next, thanks!

[1/6] xfs: cross-reference the rtgroup superblock extent, not block
      commit: 79ab1af2034b2ad10c5f18910937b938d2ad2219
[2/6] xfs: use the rtgroup extent count to find rtrefcount gaps
      commit: c3085f6c7cca7c162248519ce8d763047cdd8acd
[3/6] xfs: strengthen the "is cow staging" helpers in scrub
      commit: 0d43368844a75ad13561a1198a3b027940730756
[4/6] xfs: fix rtrefcount btree block counting in scrub
      commit: 3f9fd694fa429e89fe6de51b22b0ed5fb8b2daf4
[5/6] xfs: make the rtsummary repair fix the file size too
      commit: 6b760b3232b3efc8bcc7c165e76300bc1c9140c5
[6/6] xfs: count escaped corruption errors in scrub stats
      commit: 4d0624679ae29b469016f1ce4714be58582ed06a

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>


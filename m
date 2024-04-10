Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1678319E
	for <linux-xfs@vger.kernel.org>; Wed, 10 Apr 2024 00:44:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712709864; cv=none; b=OQZD2Mm3aCR/gK3Kc3lxL+5jxo2eL565XUAoCDsIwVXYNwnbguK95oaHX5GAxX0TJnt9wSDcfCIaPKEKRTe9/jxcIQsDYpriUHHurMptyKXs2UbSleSDKM0QC0Jau7sAYL/NsPsEEy/41HfqjZ828kNr5wrpKnqtdYwmzMC3GjY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712709864; c=relaxed/simple;
	bh=FAxSLtfxVteisFVQaqkK2eb/EAiedoireF4gb8wR7b0=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=iAwRnBnQvbz5rGbp9ACi8uF2NM4n8Y19cAuQkD/XjVxEsdBJU7Y2OTxhrpNmi6RltVSuOTPU3F2Un4ebIBeuDWVrx9yduic2SzOG7mqITa1bp+J9EanyY8SN8+hlafV4jLS7BjaSWBA4usRCfxx4eOuWzeZHvB85BsnW1sr3890=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iZCtZl3w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iZCtZl3w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BE2FC433F1;
	Wed, 10 Apr 2024 00:44:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1712709863;
	bh=FAxSLtfxVteisFVQaqkK2eb/EAiedoireF4gb8wR7b0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=iZCtZl3w1thkENnpT7YpT47/wSo92nyVQM/YAv8zdX6poZ1yWRpTpjLnCeW0Bromj
	 7a7VxRJ0TQcl5kjGsBvGQrTtba3E/DRalOEoh/7XMQXUTKt5ZOSvHMRksReL13S1NO
	 u1jIZ+OkzS8h4CMo/8r1flsbp3n+aX2qlOt6KZ6MipsGU2KUiqPGECV9BsrdBm0LuI
	 3Uy2UeJYI7PH3ZF4LJefCjqsVJNiY6t/JxsTCn2Ak6p+g3Y2l3q6kM/a3c2O2I9mRB
	 y+mL3yMbi8ecx1IokoAdqyIDLu8Kwr+YZeehL4r+CLLM7Rru/x1JYInAwFGm9SiLCZ
	 D/pI8zM/+hDsw==
Date: Tue, 09 Apr 2024 17:44:23 -0700
Subject: [PATCHSET v13.1 1/9] xfs: design documentation for online fsck,
 part 2
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <171270967457.3631017.1709831303627611754.stgit@frogsfrogsfrogs>
In-Reply-To: <20240410003646.GS6390@frogsfrogsfrogs>
References: <20240410003646.GS6390@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi all,

This series updates the design documentation for online fsck to reflect
the final design of the parent pointers feature as well as the
implementation of online fsck for the new metadata.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=online-fsck-design
---
Commits in this patchset:
 * docs: update the parent pointers documentation to the final version
 * docs: update online directory and parent pointer repair sections
 * docs: update offline parent pointer repair strategy
 * docs: describe xfs directory tree online fsck
---
 .../filesystems/xfs/xfs-online-fsck-design.rst     |  354 +++++++++++++++-----
 1 file changed, 266 insertions(+), 88 deletions(-)


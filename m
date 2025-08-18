Received: from mail-10624.protonmail.ch (mail-10624.protonmail.ch [79.135.106.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2FF125228B
	for <linux-xfs@vger.kernel.org>; Mon, 18 Aug 2025 15:19:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=79.135.106.24
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755530375; cv=none; b=Ufnu2cPC2E361huUKmjuUvMvu6u9MPKqzBTMj+bdmfM4sAepe3/VhnY1t81oiTsy4v+gXoqFqgdK0DN3i71LnLcucP827MJtm05UFw914cUg+jNrp/9Y2LPT1yRraPoY/9DHPF75myiTGPLmSm5CL6M7x/FmgAuO1mk2RVUM2Z8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755530375; c=relaxed/simple;
	bh=YMYAbv7B7gsAcwtjDy+CMQLzk/4e9Uur9c1cJ87rH90=;
	h=Date:To:From:Cc:Subject:Message-ID:MIME-Version:Content-Type; b=Vce9Ujre9MkRQB/xoKoonaHZzReFhiwC36qDsU4cZ9+uNt6ATfEU4Yh2v4lrSY3P4wQwCw3APL+7LnCo9DHy5cccvjnLFzEne8dnRNJ/8xWnzGXM/F4yNiuj1aIMgJfpsxUcIbEJZdOhepQv5eKqlGZhYUSeRe0ZOkQ/oqrtk2c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=xavierclaude.be; spf=pass smtp.mailfrom=xavierclaude.be; dkim=pass (2048-bit key) header.d=xavierclaude.be header.i=@xavierclaude.be header.b=D/1W/6Hr; arc=none smtp.client-ip=79.135.106.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=xavierclaude.be
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=xavierclaude.be
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=xavierclaude.be header.i=@xavierclaude.be header.b="D/1W/6Hr"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=xavierclaude.be;
	s=protonmail3; t=1755530361; x=1755789561;
	bh=YMYAbv7B7gsAcwtjDy+CMQLzk/4e9Uur9c1cJ87rH90=;
	h=Date:To:From:Cc:Subject:Message-ID:Feedback-ID:From:To:Cc:Date:
	 Subject:Reply-To:Feedback-ID:Message-ID:BIMI-Selector;
	b=D/1W/6HrCQNtrEqIVWoKXYOVnGHFj5t5+zYB+zuaLC8cQCE/q3Pq1vqfUWfG1Ni6Q
	 QdX92vNviPP5+BCZC3+oi4L1ENas6Ua5/WgRAOH8IyYsrrNHtu7ToqGbFV3XR9TbDM
	 Ng3oWEM25qDNQX8tA0OZMeos9V0ekImM8Zbw51djoqbY7gQSCvWUV3LcIPhcxoGaVF
	 fzmyPNVzRBlOz9iRnnPbyRYt5L06aLYUMFKEghJeW9QTAav8Wtjt0xQzKLuIm54J72
	 +grf1usl6u9Adzw/4ErN17AeCwsHJJbEApvp5jUfpuE0o5+MjHoIDbw28K1AHNNYAC
	 4OD3BZ+ZmEtWw==
Date: Mon, 18 Aug 2025 15:19:10 +0000
To: linux-xfs@vger.kernel.org
From: Xavier Claude <contact@xavierclaude.be>
Cc: Xavier Claude <contact@xavierclaude.be>
Subject: [PATCH xfsprogs] Document current limitation of shrinking fs
Message-ID: <20250818151858.83521-1-contact@xavierclaude.be>
Feedback-ID: 36077759:user:proton
X-Pm-Message-ID: a935aaea59e24bf5a51491ffe1d62ec0277a5ede
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hello,

If I understand the code correctly[1], shrinking more than one AG is not
supported. So I propose to add it to the manpage, like for the log
shrinking option.

[1]: https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tre=
e/fs/xfs/xfs_fsops.c?h=3Dv6.17-rc2#n152
-- >8 --

Current implementation in the kernel doesn't allow to shrink more that
one AG

Signed-off-by: Xavier Claude <contact@xavierclaude.be>
---
 man/man8/xfs_growfs.8 | 1 +
 1 file changed, 1 insertion(+)

diff --git a/man/man8/xfs_growfs.8 b/man/man8/xfs_growfs.8
index a0126927..2e329fa6 100644
--- a/man/man8/xfs_growfs.8
+++ b/man/man8/xfs_growfs.8
@@ -70,6 +70,7 @@ otherwise the data section is grown to the largest size p=
ossible with the
 option. The size is expressed in filesystem blocks. A filesystem with only
 1 AG cannot be shrunk further, and a filesystem cannot be shrunk to the po=
int
 where it would only have 1 AG.
+.B [NOTE: Only shrinking the last AG without removing it is implemented]
 .TP
 .B \-e
 Allows the real-time extent size to be specified. In
--=20
2.50.1



Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2845499F3A;
	Thu,  8 Oct 2026 13:32:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791466356; cv=none; b=b9WOLsyBu9UqoA9P22flxT2QJuA5q9PllNdvw2rK93suhhdm4cb4z8fA6YQ9m9z40CFpl4nmWd/hW3bkpRYgGBXA/kmu4wjSJ/b1UpLxpFRL8m8N3vHpGUQArpwoHjy4+mHIPxklygoORYjuR+e9QxDMlIfTiCMOqqaIE0DtDFo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791466356; c=relaxed/simple;
	bh=cDXWTzYY6awLYY7kQN2NFmtSwK67+MppsMl4OkFsepc=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=aFsk3eN+AIrsq/S8IDqvVSLbVZYA//N4/2dxbkGfvAgVWNHiHcpjVN37eJLE61sbS9nLiWcJ3a+rs59HL54o9XAI7C/KpTQdZLjhHETCTeiZ4GUvZsZ0YrPKzLddhQzv7gV/8COeNEB9M2U2zjbx/DC4OenW1O+ImnAgSNijH4A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AcCRK6D4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AcCRK6D4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D5D31F00893;
	Thu,  8 Oct 2026 13:32:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791466355;
	bh=GR2DeNm85IMGtjRrZsC/dxaCkM20HrIGGOruUYwlZ+0=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=AcCRK6D4aIhPO11kC4kfJKQw8gm420ecBbOThBkJG4fG4cDWW9mEqe3rjuFocGMBi
	 iKsCb8OeqjpzFkK+HeB0Zv+eviZnhFAPP8gAWThulQRMjpLS7xFCwtur5bE6vuLui3
	 d/C27Dj7Mg9WV99YNzuHbEDt25VAytFnhRlzlsTzQ8aM7CxOn9N0QZw0NhpK6aMR/r
	 LvrTXt683Jdr9mnIjqZwbJ0P0YsN3M6oU20NsXKGeg6u/gM0Ap3YhPtLdKpftA6+3S
	 uO37aPymzuZNXiVlb6iBRKZ07Qhav8lwuvlaLBlfu6grJx0z1IMnMQxS5c8gbD2Tg5
	 z4aieftiyk8Gw==
From: Carlos Maiolino <cem@kernel.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: hch@lst.de, stable@vger.kernel.org, linux-xfs@vger.kernel.org
In-Reply-To: <179030931976.3344850.17488605741516845262.stgit@frogsfrogsfrogs>
References: <179030931976.3344850.17488605741516845262.stgit@frogsfrogsfrogs>
Subject: Re: [PATCHSET] xfs: LLM-inspired bug fixes, part 18
Message-Id: <179146635431.378461.16105492411517321923.b4-ty@kernel.org>
Date: Thu, 08 Oct 2026 15:32:34 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3

On Thu, 24 Sep 2026 21:10:40 -0700, Darrick J. Wong wrote:
> Here's a eighteenth batch of xfs fixes resulting from a LLaMma.  Mwa
> mwa mwa...
> 
> If you're going to start using this code, I strongly recommend pulling
> from my git trees, which are linked below.
> 
> With a bit of luck, this should all go splendidly.
> Comments and questions are, as always, welcome.
> 
> [...]

Applied to for-next, thanks!

[01/12] xfs: adjust checks for cross-AG reaping issues
        commit: 4c6668ecebc61bb0a53d4c6e95509bc960cf6bbc
[02/12] xfs: actually check XFS_DIFLAG2_METADATA for metadata btree data forks
        commit: 436ae68743a6974021fefa21fd3093d9bf8e66e4
[03/12] xfs: fix xchk_stats_estimate_bufsize to allow for the trailing null
        commit: 6b8d60784b61a17bd591cb4c6e8aa9ed29c24f5c
[04/12] xfs: cross-reference the primary superblock
        commit: 0c61016006ab08f8346f9e7b1e38559bd4ea499e
[05/12] xfs: write the rt super immediately during repair
        commit: 33dfad5a7bbf5c7a4626404eaf3dcdaf94fed0e9
[06/12] xfs: read rt superblock from disk during scrub
        commit: cd16b947cac1463d6f3eeab17247a9db7aa10c38
[07/12] xfs: write the primary super immediately during repair
        commit: 02722664508c1f7368663db6fc2410541c75379d
[08/12] xfs: read primary superblock from disk during scrub
        commit: 612d2e7506c3553b1deedc694846d1c0364ae446
[09/12] xfs: break out of zoned reservation loop if signals are pending
        (no commit info)
[10/12] xfs: jump out of xchk_bmap_check_rmap if fatal signals
        commit: 49d300a51442bd64b627645b7b0b1cd66e492905
[11/12] xfs: mark overfull dabtree node blocks as corrupt
        commit: f61c91a2e5994fa81141d6c06dadae1fed206018
[12/12] xfs: check fork type against dabtree block magic number
        commit: 43030b72a11a532e7e3c21ac84a8625425b4201b

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>


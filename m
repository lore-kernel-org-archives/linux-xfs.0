Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FF13135A5A;
	Mon,  3 Jun 2024 20:11:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717445515; cv=none; b=rBaYGNbekYlMrp1uT7X99AvSsA6kSZAz/U2JwgoTRtNLm8qk0I+uW7qz7sVqrCBuedu0DZVU31C98DvgVw71SV9BrC+BtCfTCKycIB8qZONZ7DeNR8fVs5+RG6vD90c40xdrW4KY60tgHe9vwjz2opK5tUyYBPqsbyA6MomCY/A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717445515; c=relaxed/simple;
	bh=fN7UYs3jvoT/+jWsVxJ8+U0W4qAFCA/gZBoRN3mPtxE=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:Content-Type; b=QL7yRj0bkI9eeyBQB8sPoWB5CSsceTs8EUP9fcG3MIJ85XwMlAbjDPx+x0t9lMdIIYyxtjhAVLSqSzJ5eUe061yJ/loborY08OxbNHxKuoSNYfNghz0rHF5QidwAIUfbkVi8t83Ip+UYT5gK2PwRSQCVUHSxauypMYILk8xmSzk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Yf60uLi3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Yf60uLi3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B266C2BD10;
	Mon,  3 Jun 2024 20:11:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717445515;
	bh=fN7UYs3jvoT/+jWsVxJ8+U0W4qAFCA/gZBoRN3mPtxE=;
	h=Date:Subject:From:To:Cc:From;
	b=Yf60uLi3+tNdkZxZE/xDivcZ1VrliGG62HJSHojGtpTOxUQD92Z5d5NwrG6ZWpdjf
	 mHs/Y47EKzq/EEsLQpwFsvdTGuCAXR0nuK23LgR33nooDJ9x8cArtUh2SW1D5rEj+8
	 YjYxm9P7dLGgIIArpmjzxN8t7PeZYLwVRaVQUBsK0lWc1Tc4K2JdNukXoe5kp2SyFf
	 lf8UwvbbytHkzaesRGH98WJOgc/NVHRsmnALtHD2l14vsSXd/XRJDGp2rBk8MI/xWZ
	 9HUqLpYB/Ts5dHDPJ2j7sHpZh4N1WUvy6YM3Wj0VmObP5U3M8tiKSkE4hkfiK/iUPW
	 iiGqpXqPQ13Gw==
Date: Mon, 03 Jun 2024 13:11:54 -0700
Subject: [PATCHSET 1/3] fstests: random fixes for v2024.05.26
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, zlang@redhat.com
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org, guan@eryu.me
Message-ID: <171744525112.1531941.9108432191411440408.stgit@frogsfrogsfrogs>
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

Here's the usual odd fixes for fstests.  Most of these are cleanups and
bug fixes that have been aging in my djwong-wtf branch forever.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=random-fixes

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=random-fixes

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=random-fixes
---
Commits in this patchset:
 * generic/747: redirect mkfs stderr to seqres.full
---
 tests/generic/747 |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6590415381E
	for <linux-xfs@vger.kernel.org>; Mon, 22 Apr 2024 16:39:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713803948; cv=none; b=RgdqgzvmG4xilci1SKEkLPIHBie+2SdwMkA995S4ZWiJhP9QHEvk4iM3Dbf8QCazFZf7nQ/L8wdxcPUcHr0pvGHS4q+G1tamyV3ec9nX2khLHysLqp2SoiCXtdXEJ4P/2Az8mBhcxwb/OqRTeSZ6yHiSglNNyBGV1PSi7PQUfEQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713803948; c=relaxed/simple;
	bh=xP9I26pd9ueDRnmaeT4Sy/4ilEf/KQtOzcCDc5Jd1Ys=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=lXOmku0BsZweR+FaOGfN86SF/HEgiXwwjYQayrnoYMIYIapEtlFshCmohBOmruXQov/zqiau4w+NIBDj4eJBOJVNOTL9C9Kz1LtRjOEP5OTitzP0ffKL8EXcZgGCXmBIWDaNVq0JKDMY0YIb8AXr73digWCNFh6zzknepxbfGuI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FD9SqlIN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FD9SqlIN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9A0BC113CC;
	Mon, 22 Apr 2024 16:39:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713803948;
	bh=xP9I26pd9ueDRnmaeT4Sy/4ilEf/KQtOzcCDc5Jd1Ys=;
	h=From:To:Cc:Subject:Date:From;
	b=FD9SqlINz/pGxumwSkxI9AfQ6ymK4SKHGQHa/MYTXBItjOAG0kAXcVluiSOM49myh
	 PDxDQmcuaHtmegzb8LFoCjNHjgW6NwTfEg1jgM5R/7I8Gp5cjOuseBWe4wGP9EAoie
	 UpgsVuCt7uUC9VuNyU3B9mawHc8oaWkJ+aVU1W5pyQkkbXnakzEgDy5t/95YpzgVQ1
	 H7acePqymZSv6i4irRBTlXEXzkWQs1oP+Xd5JfGPs0OOww85ht5BOOEiqlVTQSZP9f
	 Syi9ZPpXVBxG7495w1RVMcih3gENBgkdKIEnIHH0gu/UcR69b/2OrBfnBwNsxzQT9x
	 HHAgxfoXlLp0Q==
From: cem@kernel.org
To: linux-xfs@vger.kernel.org
Cc: djwong@kernel.org,
	hch@lst.de
Subject: [PATCH 00/67] libxfs: Sync to Linux 6.8 
Date: Mon, 22 Apr 2024 18:25:22 +0200
Message-ID: <20240422163832.858420-2-cem@kernel.org>
X-Mailer: git-send-email 2.44.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

this is the libxfs sync for xfsprogs, I'm finishing testing it and I'll push it sometime this week.
I'll start to work on the patches already on the list and will push it all to for-next sometime this
week yet.

Some of the conflicts were fixed using Darrick's suggestions (thanks Darrick).

you can pull the series directly with

git pull https://git.kernel.org/pub/scm/linux/kernel/git/cem/xfsprogs-dev.git libxfs-sync-6.8

Any questions, let me know.

Cheers.
Carlos

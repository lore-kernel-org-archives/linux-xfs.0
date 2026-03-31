Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B353939A7F2
	for <linux-xfs@vger.kernel.org>; Tue, 31 Mar 2026 12:26:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774960005; cv=none; b=kT/CkzBb6MfPuCiCEXEULrev6QVot0xmMD/8Xh8Dx5SrUeN/UOvn048mG2nn7swBXnL97jmwBoM/LYwf7x1LFNGqKlq/PMyNgFOrybppP+bDsY4XOoE0oFJGLwX+uaI8FEPz7uv+yKF+xUfJ5jWB+egvijHnV9NgvSy6ttQmFmA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774960005; c=relaxed/simple;
	bh=H1Lr3llLZxV291Um+8ZuxfXRVXW8xjjyj8ySGOqZ5dU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=rKkiOr+3fGyaZFMUFn0JLeClklO/3+Alu316ovQC6bww7hHgm3CFHo8PHe1uHcHm7FQ1iXK6JHbI4RqYfhfe99SozkcEzaMJTfNJnLYTuvsXwtsZs0AK7pSSJMHgJIAX8qsKM2sLeumCWtm8t1uERE2XCouBMgB4m3meyKN1KRo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OkkrEw4y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OkkrEw4y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57F07C19423;
	Tue, 31 Mar 2026 12:26:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774960005;
	bh=H1Lr3llLZxV291Um+8ZuxfXRVXW8xjjyj8ySGOqZ5dU=;
	h=From:To:Cc:Subject:Date:From;
	b=OkkrEw4yuKdFnY0+KeXsUVDl+0+Sc2PvR+M9J3GWWmah4VLQIba9F+tupI6kF0Rmd
	 SuYNzVSmWMf1d+PIsQbAS0y0eZpIoIYxhe6pyxuDqRrmj8ZjsZggeNUQouf9pj0ZaO
	 uj2k9SLfwaP/EdzMAluwuhdXktKf+IdTZIdB+6ht8oZVau+IXl2nV2JG5l6fyPxggB
	 oJW1EByj02ay9zlqiakfGZZLHG6qoIfGEz1y84+lcRiFsE/wEN4H36lcQiDlwUFpAq
	 cNHLKTayPpSkqAU/MeA0dGQCL/6DjV+6WvA48QuT/dWatYbcg2KOPsfgbma0louvQi
	 FTA0k6mnsy+yA==
From: cem@kernel.org
To: aalbersh@redhat.com
Cc: linux-xfs@vger.kernel.org,
	djwong@kernel.org
Subject: [PATCH v3 0/2] Improve user experience with xfs_fsr
Date: Tue, 31 Mar 2026 14:26:29 +0200
Message-ID: <20260331122639.100956-1-cem@kernel.org>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Carlos Maiolino <cem@kernel.org>

This is the V3 of this series,
this fixes an issue based on an user report via IRC in January.

Patch 1 implement changes suggested by Darric, while patch 2 has no
change other than being rebased on top of patch 1

Carlos Maiolino (2):
  fsr: package function should check for negative errors
  fsr: always print error messages from xfrog_defragrange()

 fsr/xfs_fsr.c | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

-- 
2.53.0


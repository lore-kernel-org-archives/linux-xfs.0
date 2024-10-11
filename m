Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AADF209689
	for <linux-xfs@vger.kernel.org>; Fri, 11 Oct 2024 07:42:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728632525; cv=none; b=HP4lMPg4p+bB+S7jecyrZ9EmhPMfRdx5VgJP6qmUYTEl/Y7jMLREk1RZsPYNtluYZAXD91sTsaKbO1JADmVCP15M+FNaqbjCa9HRBolx5VV7JMtFfJ6kL3QraFLFwO1XOuJrP9/VQVv2F2E2tkvGb9ASj/e17pi806OV95wYULo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728632525; c=relaxed/simple;
	bh=BbK2apf43Z3u45Wp/a2ciGvztFPSDy4j4rj3nweOpTI=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=oFQC64F/6JBVW85MmNtTuk+93B1YvIgr/AH85GDYQjfqYfar3Vmuu61+pizArrFAQ1IhenikkFWbi5/vy/eUNARPE99WoF9Ww6bxZclPASfWRbxkc3drSmrccjkdTSY5hMW76HD/la1PdGctrmWhfEZA0Is+yAqcYKe73GkLyZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GuMh7rwo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GuMh7rwo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14880C4CEC3;
	Fri, 11 Oct 2024 07:42:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728632524;
	bh=BbK2apf43Z3u45Wp/a2ciGvztFPSDy4j4rj3nweOpTI=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
	b=GuMh7rwo4cltgmtE1OOaqPVAxtjQGVbSj9UorNpKhX4SCgGH+zci5AK7rWQrNsLD/
	 UP1JO1y0gX/sI/CSFNYXbtfiLlky2+bimd/LwlKMHBFFKkWcUblGY0ebPQacyELOJ6
	 9tamAIolTSYZ78C93rUVFC7J04qUz7ztGNXQCfa57CVtV7yutXHfzw57Adi7rqS1WU
	 0qBPNzFQdigeMz/YF7n0ACBgaf/KdgcbyPoqbnW08lchCOESFhVbKRuIHdSllCC2ff
	 IMIinCK4Wh0+1rYFLYBCAaBqF7Y/cmq1ygdLuwYxWAP7H76CebwBC05Q1SMloOAMNA
	 eO1vo9vDsERWQ==
From: Carlos Maiolino <cem@kernel.org>
To: linux-xfs@vger.kernel.org, Brian Foster <bfoster@redhat.com>
Cc: Darrick Wong <djwong@kernel.org>
In-Reply-To: <20240903124713.23289-1-bfoster@redhat.com>
References: <20240903124713.23289-1-bfoster@redhat.com>
Subject: Re: [PATCH v2] xfs: skip background cowblock trims on inodes open
 for write
Message-Id: <172863252369.1112230.11503773506813571093.b4-ty@kernel.org>
Date: Fri, 11 Oct 2024 09:42:03 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.2

On Tue, 03 Sep 2024 08:47:13 -0400, Brian Foster wrote:
> The background blockgc scanner runs on a 5m interval by default and
> trims preallocation (post-eof and cow fork) from inodes that are
> otherwise idle. Idle effectively means that iolock can be acquired
> without blocking and that the inode has no dirty pagecache or I/O in
> flight.
> 
> This simple mechanism and heuristic has worked fairly well for
> post-eof speculative preallocations. Support for reflink and COW
> fork preallocations came sometime later and plugged into the same
> mechanism, with similar heuristics. Some recent testing has shown
> that COW fork preallocation may be notably more sensitive to blockgc
> processing than post-eof preallocation, however.
> 
> [...]

Applied to for-next, thanks!

[1/1] xfs: skip background cowblock trims on inodes open for write
      commit: 90a71daaf73f5d39bb0cbb3c7ab6af942fe6233e
[2/2] xfs: don't free cowblocks from under dirty pagecache on unshare
      commit: 4390f019ad7866c3791c3d768d2ff185d89e8ebe

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>


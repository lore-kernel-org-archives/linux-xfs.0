Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1A5FCA6B;
	Wed, 22 Oct 2025 11:32:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761132778; cv=none; b=BiuevrZJBzJUHWa2q2A9HpWuk9j0h2m6Dh/2+/JfmIUFWaosxpT8c7MWVPzOqBEX6pPOP4S5HCcKGULFRzlCLb643oZetuLxhf3HJgtofkY9h6ui4hb9c5fJxXST8nyic3P+8VAeDbFtur656PwBzpr6zJsB76EMliYEZ6TLxWE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761132778; c=relaxed/simple;
	bh=0j3aErqYStg0c4zRP+UOFNxgk15ITr7C3ltZOxxe3ZU=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=K2a0NKXmXHp7mM/+VzVxYJzaWPDNiDOo7v88+ACqJ+e5nMBldER4MdeI1wj9sCduuEuq89XfWZSRWRRjulgHibNScxBUj/DC89p0F+GKStPSpbuETmNkLUD5l7LQAFarpo/ny1gRLwUOv7CYT9I6T2XsYBp82jyW+HxAKnxeM+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=N7OLLMRm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="N7OLLMRm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1061C4CEE7;
	Wed, 22 Oct 2025 11:32:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761132778;
	bh=0j3aErqYStg0c4zRP+UOFNxgk15ITr7C3ltZOxxe3ZU=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
	b=N7OLLMRmLS3CmC05BjaYai7Almvy+TlSvgwr5lS9oHaFvN87A1MX139uPqz4sTh6b
	 uVrzA4V+VxmkB8LhK0tMtzg5hfAukq7YpoYzNM+VfaQPdjKW9AL8YvbZbAC1ACi/XF
	 BgSB1HLlGJs9Gl4Sy7SkNYQJdHA1H2tw5Hd2rzEddKkquzXw/R2b0I7o4kHvw1Ak1K
	 apCt5xjSgMAYyg3EZOaoU9e5jJvJSaEjOTngjR3DhmktJp3TtyZtxBJBOW2TBw0I5f
	 QAOMQFXif5g4KmSR6PB6G52a8JXzuzpHbnTpNOwy9p95c9KqgEb50WSCWuCoOq9QId
	 mdXtAJo6u/OVw==
From: Carlos Maiolino <cem@kernel.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: oleksandr@natalenko.name, hch@lst.de, vbabka@suse.cz, 
 stable@vger.kernel.org, linux-xfs@vger.kernel.org, hch@lst.de
In-Reply-To: <176107133959.4152072.11526530466991879614.stgit@frogsfrogsfrogs>
References: <176107133959.4152072.11526530466991879614.stgit@frogsfrogsfrogs>
Subject: Re: [PATCHSET] xfs: random fixes for 6.18
Message-Id: <176113277643.82207.1441469219564358238.b4-ty@kernel.org>
Date: Wed, 22 Oct 2025 13:32:56 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.2

On Tue, 21 Oct 2025 11:29:50 -0700, Darrick J. Wong wrote:
> Random fixes for 6.18.
> 
> If you're going to start using this code, I strongly recommend pulling
> from my git trees, which are linked below.
> 
> This has been running on the djcloud for months with no problems.  Enjoy!
> Comments and questions are, as always, welcome.
> 
> [...]

Applied to for-next, thanks!

[1/4] xfs: don't set bt_nr_sectors to a negative number
      commit: bd721ec7dedcc24ced51559e42a39140b59dfd08
[2/4] xfs: always warn about deprecated mount options
      commit: 630785bfbe12c3ee3ebccd8b530a98d632b7e39d
[3/4] xfs: loudly complain about defunct mount options
      commit: 3e7ec343f066cb3b6916239680ab6ad44537b453
[4/4] xfs: fix locking in xchk_nlinks_collect_dir
      commit: f477af0cfa0487eddec66ffe10fd9df628ba6f52

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>


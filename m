Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 640BE3C09FB;
	Thu,  3 Sep 2026 06:06:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788415568; cv=none; b=OS370I8PoLOz7PbSUupFFwiKxqVwM7GkEapkqhhG+p8y2K6LLeTYkhXrZaMBrgxiEIhae6IjZyoUsc0ppvUItN5Bi3F17mruJpLr+uzU7Lju0s/5HXFk/TydVYVWoSJxqZIRICqE5ITGnNP8G8JqE/6Wvx+6kAeCEnO3HUkcGPk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788415568; c=relaxed/simple;
	bh=Hf50wIdEtUYwIE8R+P8ZMDX5BO2k1ObIWzhImBNdmzg=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=gCsdVXVypRNaxz1KnhJnZU6TLEY8ek4/DMFvlGARBAFHWa/cWrPA/H5/glOjn7YWixAuWyprd7PJY1L7+456E1T2Y+/IKNcEgy8GdAuXriR1VcEArCt30pHAaFNkr61gIvFqMQ4mNfdqwiscBrFkicsw/kUnnV8/HzGMeQ+ijyE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aNpO/5cI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aNpO/5cI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18C3E1F000E9;
	Thu,  3 Sep 2026 06:06:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788415567;
	bh=D+8VM3oxzeogg1E6CiZJ5DN3kP+UXnZK2Ooo5gu20/8=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=aNpO/5cIf3OJkIuagrDD2TmS78GCho7l7v8zj530DzzHw9I4pbB0U9OkhmM5Ct7py
	 3AjFpy0dl9exLSADNtOIS5N+fPZe+baKc7CCRBDq2+V0bAtOdqnt5sB1Zh+AEdnJea
	 J4WdbiVx2OVO6AXvu+cfqvvsmdwfgHpLlMuB37dcRUahwvrHxffEp8cOnFqBvrCgyS
	 ua9F2y6/Isi3nDbGMD7bR8yktAnZCW6abMMFAj8Ty5GbnhDfYp4PycYJFUZqFKKkrL
	 y90ipi/ND5Vje+YEwghQ0FXyCXOI1p5XZ2QBlNr6KGpqMOIHKnPBwGtislf42B/k++
	 7rMxdkE4kAKXg==
From: Carlos Maiolino <cem@kernel.org>
To: hch@lst.de, "Darrick J. Wong" <djwong@kernel.org>
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
In-Reply-To: <178780640140.3528187.6786220801490019229.stgit@frogsfrogsfrogs>
References: <178780640140.3528187.6786220801490019229.stgit@frogsfrogsfrogs>
Subject: Re: [PATCHSET v2 1/2] xfs: LLM-inspired bug fixes, part 7
Message-Id: <178841556579.1198521.11942736274781732357.b4-ty@kernel.org>
Date: Thu, 03 Sep 2026 08:06:05 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3

On Wed, 26 Aug 2026 22:30:57 -0700, Darrick J. Wong wrote:
> Here's a seventh batch of xfs fixes resulting from a LLaMma.  Mwa mwa
> mwa...
> 
> v2: add rvbs, tweak some of the commit messages
> 
> If you're going to start using this code, I strongly recommend pulling
> from my git trees, which are linked below.
> 
> [...]

Applied to for-next, thanks!

[1/6] xfs: don't spin forever on zero-length dirents when salvaging them
      commit: 583c8e8767839bc5f4ac07f14e69506a26ceb914
[2/6] xfs: don't stash removename operations with unknown ftype
      commit: b2362aac3c915e9f01e0bae3e869b94d371076c8
[3/6] xfs: log the tempip after we convert it to extents format
      commit: 6aaa121b24a3f556af65dda2c368e15cc8efb1d9
[4/6] xfs: fix parent rec lookup initialization in xrep_metapath_unlink
      commit: e5604e9446fdb6a6963120e9b0cfc9016ca91c0b
[5/6] xfs: handle reconnecting metadir subdirectories
      commit: 0b0a74f7fcbbd7be189bf4c50c0889858c951a67
[6/6] xfs: lock the healthmon when inserting unmount event
      commit: 41fbf820b6d04ef5a6d4e89931c38da2419b1680

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>


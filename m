Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 766284AE8B1;
	Wed, 14 Oct 2026 08:28:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791966513; cv=none; b=jFmAgrLIKW0E/ndFXUALTpEXSwsB/IBzyQJ6QvGnHzAA/oeHpyIE1i5MU8TCUI1bSakUX5CXM8cWmpDy8hZ40GRLG0ti4pDO2ykb0aDkyGGvFGP/LzYFDNR/cCHbwY3YoP0RWeSB1HstV7hfF05YCEUkx7cQrgOXmlFpdouyNZg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791966513; c=relaxed/simple;
	bh=kD1m3CEBLTbDBbikyRJ/CpGli05UsaY6HM3LA7bsndY=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=Rh3JE92mAesXuYTr9gZSCkwoSjr7+Wzm0v6en18CcAlmhel4fFk9yt9C6LbgSSyDo+ed1rVXejYRez3eh1ZK4N9lpK43tWVUGXvz8omMzeu9SPBAZ+6EcKjzSSHJRFh9w6SG6Z3/ktoliDMXC36BgBkylqfxTzMwiNQb6BTC3xs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KGruZqd1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KGruZqd1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D4771F00893;
	Wed, 14 Oct 2026 08:28:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791966512;
	bh=DeYFnjBMGkP3StKI3ec6bGS4eZr12RphlbspejgmOiI=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=KGruZqd1nGeMIJGjBsO/GqEzJVk1P2j5yy+54vdLpKceTvVRGO6bXYibdYNpEU1X0
	 1PUDmo9kKAmZsmeSxxPtuOQ1Q5iqxWx9iKdU+4hXkprSID/c9UxRrIeD7L2WnQNPMq
	 9StF8u/EWckggtakcZebK2vdnL+lb19S2kOrmC22Vr54pxpmI56VZdZWail6CNuO6D
	 TzNe6RBnZZcXlKgR9t2oYxQNI/UEBE81ldU5crDFWrnajExVWUytqr1eOA3veSDyuM
	 P1NLCxGBYXkoHykQo5tOyZMHQvc/dzLJfu73KAgP9GIy0kP7I8XRvsoTLOueHupmgA
	 54roJHNB76pXg==
From: Carlos Maiolino <cem@kernel.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: hch@lst.de, stable@vger.kernel.org, linux-xfs@vger.kernel.org
In-Reply-To: <179186107061.1898400.3978552773417541744.stgit@frogsfrogsfrogs>
References: <179186107061.1898400.3978552773417541744.stgit@frogsfrogsfrogs>
Subject: Re: [PATCHSET v2 1/2] xfs: LLM-inspired bug fixes, part 22
Message-Id: <179196651088.20513.6716892509876117666.b4-ty@kernel.org>
Date: Wed, 14 Oct 2026 10:28:30 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3

On Mon, 12 Oct 2026 23:05:16 -0700, Darrick J. Wong wrote:
> Here's a twenty-second batch of xfs fixes resulting from a LLaMma.  Mwa
> mwa mwa...
> 
> v2: fix issues pointed out by reviewers.
> 
> If you're going to start using this code, I strongly recommend pulling
> from my git trees, which are linked below.
> 
> [...]

Applied to for-next, thanks!

[01/12] xfs: don't overrun incore inode when cleaning attr forks
        commit: c28b4b48deac17749ed1ebe4289a4ba73541ddc6
[02/12] xfs: fix data fork block count check in xrep_inode_blockcounts
        commit: 147f9f8300cb284923e08bb8a7b32ba9681c45ed
[03/12] xfs: avoid oversized space allocations when regenerating metadata
        commit: ca12256b7f9820aafb361ac496f048d2d4a71c23
[04/12] xfs: reduce new btree slack factor if free space is negative
        commit: 80f13dc7225eec318da7499c7a562d7a34d25e6a
[05/12] xfs: don't queue rmap update twice when reaping a fork
        commit: 219ff8a734d8438e24eb346a847c9b1ad9b7ab5d
[06/12] xfs: only written file data blocks can be shared
        commit: 634b63baf05062988456a0bd5df2696c14ea2949
[07/12] xfs: check for fragments when full-extent sharing matches
        commit: 95e213c1ddb40dfb0a8178ed35c9f29992a320e1
[08/12] xfs: don't clear COWEXTSIZE on directories on reflink filesystems
        commit: 3978b1f3109dfd5c648442bb040f9abd58608226
[09/12] xfs: clear set[ug]id mode bits when zapping attr fork
        commit: eb20a959760c21e3547cd811d0d9b0b29df98959
[10/12] xfs: opportunistically skip btree block checks
        commit: 4ce244b234c251963fca6dff9de6edf26a209d08
[11/12] xfs: always report scrub errors in tracepoints
        commit: 1ccc8f553d885d49c1bfe141ea1f331511940b3a
[12/12] xfs: don't scan across metadata/regular directory trees for dirents
        commit: 03ce4ca43c00394364493865f417d646e252bac2

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>


Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07BB4449B3F;
	Mon, 12 Oct 2026 09:29:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791797343; cv=none; b=KzrTl+rJ5cfcCVduYuMc0qESXk+A4kuvMNhnn9tG51PZAOJaidYavuimWxrdxVQlwanC3co3s0k1JlR13xK6tcd65Kj+oo3wR4HGnvkmP/5Fryol1bK9T8MoWPYoOSZGfryFx2Y0oZUA/SrmWVstH9FK+1xx07Dxb/fSzogA838=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791797343; c=relaxed/simple;
	bh=IfPOvdjBpe2mttPHiD5atsh2QNUtoUtFWviMSt3pahg=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=XWFyCAMbX9tappaYMZfscd7GtR4QXrRk+YrMcJRoN3KGGgCZsAXEPzI+qKuqNCcsx2JwnhElEPgq4BxpiIsQsSPQi7+oWucOIeu8GBHRrrh4lKJPGFGipEfWxwRaJEh2jW8723gqYApME+oiWAAyNBX4cefvvfbMHdy7VTg97LM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YB4phc9u; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YB4phc9u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 488931F0089B;
	Mon, 12 Oct 2026 09:29:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791797341;
	bh=fLg8mAoX+4wLmmOsxr2bmqLF4yf1/+DGyIDf2PU151E=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=YB4phc9uXGFi8fiKIrVqmgvnOSKBohjP59sKrOImxYoD4myN99mvPQJb391DThm4s
	 rZto/tzxw42YXq6VWSH4A+AS01u/Xf/H+ftcsirO0Iuw3dxMKAYqzouBtIcFw/XYhR
	 ygKO2YZXr97pSR9LsAdohyMwhuWTWF1srbrX6xHrhtPy5lQQhWVU1YWV3lg0KlfByH
	 D/E+I0DsqcNSLN2CR6IZZo4XE/XlSyGVBfNk0RGBp+0JLKp5IZBWWsit/Gk0rbYOX2
	 PdEoJx8YN86rsPuM7V3mx4Xrw2vg4bJdLB+smTPYIOq0CvFvCJgGi9NxJrt9mjw3RC
	 DW73nhHAzSJYg==
From: Christian Brauner <brauner@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: "Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org, 
 linux-fsdevel@vger.kernel.org
In-Reply-To: <20260928091111.3986811-1-hch@lst.de>
References: <20260928091111.3986811-1-hch@lst.de>
Subject: Re: use bio_complete_in_task for iomap error reporting
Message-Id: <20261012-geklungen-geist-ramponiert-114676e3a35c@brauner>
Date: Mon, 12 Oct 2026 11:28:58 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.17-dev-3d1b8

On Mon, 28 Sep 2026 11:11:06 +0200, Christoph Hellwig wrote:
> this series replaces three pieces of code to queue up I/O completions
> in user context for error reporting with the relatively new block layer
> bio_complete_in_task() mechanism.
> 
> Diffstat:
>  bio.c       |   46 ++--------------------------------------------
>  direct-io.c |   19 +------------------
>  ioend.c     |   48 ++----------------------------------------------
>  3 files changed, 5 insertions(+), 108 deletions(-)
> 
> [...]

Applied to the vfs-7.3.iomap.final branch of the vfs/vfs.git tree.
Patches in the vfs-7.3.iomap.final branch should appear in linux-next soon.

Please report any outstanding bugs that were missed during review in a
new review to the original patch series allowing us to drop it.

It's encouraged to provide Acked-bys and Reviewed-bys even though the
patch has now been applied. If possible patch trailers will be updated.

Note that commit hashes shown below are subject to change due to rebase,
trailer updates or similar. If in doubt, please check the listed branch.

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/vfs/vfs.git
branch: vfs-7.3.iomap.final

[1/3] iomap: use bio_complete_in_task for buffered read failures
      https://git.kernel.org/vfs/vfs/c/062de5a4ef9d
[2/3] iomap: use bio_complete_in_task for buffered write failures
      https://git.kernel.org/vfs/vfs/c/9d098dfc5522
[3/3] iomap: use bio_complete_in_task for buffered simple dio read failures
      https://git.kernel.org/vfs/vfs/c/26db1836053f


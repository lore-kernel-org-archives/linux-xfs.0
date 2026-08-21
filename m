Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35A6139B4BF
	for <linux-xfs@vger.kernel.org>; Fri, 21 Aug 2026 07:36:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787297769; cv=none; b=D8lApNwG5NaHaOW9T6XP2g7zGS/v3EpiDWiR0Ni66cBKq15kK/TiyEki4CdJhBDi3qhM/sPxPsKY5hUo4zeSq/K6DiED/EeOAHW8s+h28GH9vegA41/04HTfuPglrpaY4UeexiddWF/E4VJ+zOpyTtr/rcsU/OVi2QMyD8oWXrE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787297769; c=relaxed/simple;
	bh=s1AKGEyiGC0O35CQ1fWUmo0H+PGl59kgXp5kIwoxdew=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=qie30Y6kej/70qx+vySGLdbfEYHxdF4udEBGe2QhvEqcCd1BiSoe8PA6KT8VSr9LckIVk7fUes2NvRxM2t4IYQArfaLN2QbeCI9DcRN7JTeJT9mh+wV1F3kbQHUtIMJp/KrOST8joKV5UQapb0PtDF31/XFsDpOECzlUBCAT45E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Fl7xm8vd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Fl7xm8vd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3A941F00ACA;
	Fri, 21 Aug 2026 07:35:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787297757;
	bh=Fp5dc+NBcqUJ5WD098K6kbF6wCle/2ZcQ14wLsyr07Q=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=Fl7xm8vd6rigBNeUZBBJwFzvcPN2Cu7mG35B8hY7B2t22SeJh3WBJ/onfsVhFyYoy
	 CGufLcYq2+GSzFrxaFKW2eGbRdbgdfBEZ0sVcWZNwrdrELaUHwg+CcRTRp+BzzU/gt
	 gdK/HOpxh7dBK90p5M3dp7p54R624eWU96p/WvCauzzi+enDuyq2ghLZKs9MsRJQbV
	 dMzbeqJmVjFntHtCDhD3kLHqkkOHVoB5cXXmWRCZ2Scl/Ih4ctqmMf/M9epxUli/7q
	 sow7wrG5wcS9DmnIc0S5pz/7OlBnRB2R5CZrW96+Wg+x3Qjtl/D0PJhNs9cP5uX4wG
	 iHBgQ3LQ4tYAQ==
From: Carlos Maiolino <cem@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: hans.holmberg@wdc.com, dlemoal@kernel.org, linux-xfs@vger.kernel.org
In-Reply-To: <20260813145617.419537-1-hch@lst.de>
References: <20260813145617.419537-1-hch@lst.de>
Subject: Re: [PATCH] xfs: restore bi_bdev in xfs_zone_gc_write_chunk
Message-Id: <178729775550.580975.16225193293599013022.b4-ty@kernel.org>
Date: Fri, 21 Aug 2026 09:35:55 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3

On Thu, 13 Aug 2026 16:56:12 +0200, Christoph Hellwig wrote:
> xfs_zone_gc_write_chunk relies on bi_bdev to still be valid, which is not
> true when XFS is used on top of a stacked block device.  This can lead to
> misdirected GC writes, writing of plain text when using dm-crypt, or
> miscalculated I/O limits in xfs_zone_gc_split_write.
> 
> Fix this by reassigning bi_bdev.
> 
> [...]

Applied to for-next, thanks!

[1/1] xfs: restore bi_bdev in xfs_zone_gc_write_chunk
      commit: 885435535bb1d07746916d4c8832f95767bf2d7e

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>


Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D68C54763;
	Thu,  3 Sep 2026 06:06:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788415567; cv=none; b=Agug/DCrBoivUV83hr24iYZXCo+yW4xq9qms6+keEsZh5SvQluMsJQUW1RTKtILnxDO7xGDBhVD6rYZoYnh3NLCx/ivyfByI4YNuU3jJW28QDxaWdtu42tiJakO091kC7xFBOHOEX0HoLmDjrHijSL72QpOBFSxNIyJ315cjKJ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788415567; c=relaxed/simple;
	bh=ed0cXQo7zhORpbxy9MoW+9FgK8baThjjjqUKqHgHb5Y=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=hew4al0ILDPlZWPXW1CDKLngYVTTmnrmpHj+AoYHo99GCqVx08smOXpB/HUdhvvVbc5tV2FZyuqvCIGwS8yfeqVVYtH3/Bcv1mJ+jVAeGQiqBTYHK9r8b1JuAjGetTOtXJV2nYGe7VQ+Jdb62x/h4hZnvaMR6ZBw36yoZX9Zm44=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=P/M63Yrc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="P/M63Yrc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EF231F00A3A;
	Thu,  3 Sep 2026 06:06:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788415565;
	bh=y2GBtcZFYnHx/PxbJFF3NxgWj5/wVDXq0245seBhclI=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=P/M63YrctyDnjZwdYspocTaTj7RTXtB+Y3m1A3nsgPBZ1ACNUzm+T6OXecx2oZrDD
	 D7VJOY3t0Ld5p1cV+tUzThGCDfOznTMvXzPSGnbZziFUxlIEgjK9oBXUQvGr4wTWxx
	 /3PLz8FNIR33Jv6Yp6MdcM3TDmrzwUTo2mYTBRGqLh6a8FmKzsLB9zCb9SDlVDStPd
	 QV1NbU+DXBRyCDIkztBcrc5WuxIn+w0k81XJswVspjjTAolWIhe7zkH37853MeaLZ3
	 1ZwpMM6tj7H+Zou10Qv7o74KYwjSBhtam+g9rU6SjVyDNsKBA3hc4tdMBXfW0cz5vs
	 F7AFkmVJoIf3w==
From: Carlos Maiolino <cem@kernel.org>
To: Javier Tia <javier@peridio.com>
Cc: "Darrick J . Wong" <djwong@kernel.org>, 
 Dave Chinner <dchinner@redhat.com>, Allison Henderson <achender@kernel.org>, 
 Andrey Albershteyn <aalbersh@kernel.org>, linux-xfs@vger.kernel.org, 
 linux-kernel@vger.kernel.org
In-Reply-To: <20260810230611.2859909-8-floss@jetm.me>
References: <20260810230611.2859909-8-floss@jetm.me>
Subject: Re: [PATCH v3 0/6] xfs: fix filesystem shutdown from parent
 pointer reservation underflow
Message-Id: <178841556375.1198521.1018671012811358518.b4-ty@kernel.org>
Date: Thu, 03 Sep 2026 08:06:03 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3

On Mon, 10 Aug 2026 17:06:12 -0600, Javier Tia wrote:
> The first parent pointer update that has to grow the attribute fork
> twice in one operation can shut the filesystem down with
> 
>     XFS (loop0): Corruption of in-memory data (0x8) detected at
>     xfs_defer_finish_noroll+0x29a/0x4b0 (fs/xfs/libxfs/xfs_defer.c:721)
> 
> The message names in-core corruption, but nothing is corrupt.  The
> deferred work that failed is a block allocation that returned a bare
> -ENOSPC on a filesystem with hundreds of gigabytes free, and
> xfs_defer_finish_noroll() treats any non-EAGAIN error as fatal.
> 
> [...]

Applied to for-next, thanks!

[1/6] xfs: initialise error in xfs_defer_finish_one()
      commit: 08e6a7587c0a89a342f9ebe4b70160b23db9a138
[2/6] xfs: give the deferred barrier op type a name
      commit: 6c81238928c19fb83d469ec8aca6b90830b7aad0
[3/6] xfs: report the error that made deferred work shut down the fs
      commit: 17783da399db9f363a64a983b37117e736d3aa98
[4/6] xfs: correct the parent pointer space reservation comment
      commit: 410822bd69ef47a231c4239712c2ffe1fab7c68f
[5/6] xfs: initialise args->total for parent pointer updates
      commit: 47531ec00c81e4b41705c9859ac26c7522efffda
[6/6] xfs: assert the reservation covers each da fork growth
      commit: 21a0382da84fc9fc94af0b2b0a868a73c3836f2c

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>


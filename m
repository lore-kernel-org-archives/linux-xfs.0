Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C779B335BA8
	for <linux-xfs@vger.kernel.org>; Wed, 21 Jan 2026 12:24:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768998258; cv=none; b=W9BCUKeZrswD+sMmV/VFABI+h1THOfdhtstt08U5mzy+eKqFpEdpK1wUOoY3ra1vAt3DRXwqwBoI2UtUsbTWwLx6vmGvZhzBwTRLvNLCNLYtgsADUMcK6Z4Nyd0M52SlUvvdc5wak/QhsEe1EQshNQmf+MFwGRPVHnS29K43z24=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768998258; c=relaxed/simple;
	bh=aWKC041hT3sVzThu2i32d7ewoXwK6hi9Agps+QkZRXY=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=aQ3S4YKKB+9TtuPdJw00MLBGuNCyIYxuL5CHzpivtXK2Bow28eyNhwq+2k9D/wWl+8Iu7iMTtBydVJwW3ne6j8iNhJWA6EkmLUCrmS23oO1nmjfQFDxCwnHm585HXMd9XDCVGumhx76pAB18k6on1LRyaRCLL2m3sPdC7g0FlDU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aOCms+tI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aOCms+tI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A07CC116D0;
	Wed, 21 Jan 2026 12:24:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768998258;
	bh=aWKC041hT3sVzThu2i32d7ewoXwK6hi9Agps+QkZRXY=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
	b=aOCms+tI83peFBZTLaVoUZqZlD/TN7y67w65yk2zgkHpp54daQhGuTRodtRlsHaUJ
	 6uyPIa2/aG7PNbs3wE6dE7rHcSh2UCGfDZYaNywb4yseAqT2UvYz4a47Z2cDEuhqek
	 n+0dLhrb2Q0P4g0+c/sQlVnoMXNb9qU9w+V7KBpNcEC5t98WaumXhBawh+zQgnuZD2
	 ulnC5FgGFY5JpW0L07R6vFbxIG2VJMDs5xbaMM9HYCenH75HgPDxeUs0W08VtjAtsT
	 dwPlJYHs6LwXDURcyOnoPDmMUphySbVNKQqWf9MHwlotzt55uipUZS23s+tsA89N6E
	 0BBoJdsvtgroA==
From: Carlos Maiolino <cem@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Damien Le Moal <dlemoal@kernel.org>, 
 "Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org
In-Reply-To: <20260114065339.3392929-1-hch@lst.de>
References: <20260114065339.3392929-1-hch@lst.de>
Subject: Re: refactor zone reporting v2
Message-Id: <176899825712.852894.16137128479556813973.b4-ty@kernel.org>
Date: Wed, 21 Jan 2026 13:24:17 +0100
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.2

On Wed, 14 Jan 2026 07:53:23 +0100, Christoph Hellwig wrote:
> this series refactor the zone reporting code so that it is more
> clearly split between sanity checking the report hardware zone
> information, and the XFS zoned RT information.  This reduced the
> code size and removes an iteration over all RTGs at boot time.
> 
> It will also allow to do smarter checking of hardware zones and
> RTG allocation information in repair once ported to userspace.
> 
> [...]

Applied to for-next, thanks!

[1/6] xfs: add missing forward declaration in xfs_zones.h
      commit: 41263267ef26d315b1425eb9c8a8d7092f9db7c8
[2/6] xfs: add a xfs_rtgroup_raw_size helper
      commit: fc633b5c5b80c1d840b7a8bc2828be96582c6b55
[3/6] xfs: pass the write pointer to xfs_init_zone
      commit: 776b76f7547fb839954aae06f58ac7b6b35c0b25
[4/6] xfs: split and refactor zone validation
      commit: 19c5b6051ed62d8c4b1cf92e463c1bcf629107f4
[5/6] xfs: check that used blocks are smaller than the write pointer
      commit: b37c1e4e9af795ac31ddc992b0461182c45705dc
[6/6] xfs: use blkdev_get_zone_info to simplify zone reporting
      commit: 12d12dcc1508874886ebcbd2aefba74f1ed71f98

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>


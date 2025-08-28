Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3920313543
	for <linux-xfs@vger.kernel.org>; Thu, 28 Aug 2025 13:19:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756387143; cv=none; b=E8BE2p6yzGb5CzwBpQElGULU8hg30jP7WVkWhd1VVr3wh32BKFGD5k7Zi5bB7uwQ7RCAYOqvKZscST3kYyIAhpvj/GyVb27IXFHRLdA5F4oEKuA7GtS9G8TI8kDULDiuJ/ZB6LG9l4fPBIk+cbsdNTTHYNPx2+p+aZDawRoMzG4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756387143; c=relaxed/simple;
	bh=lBUBXKSTLeYCVkAZzTqATwh9bMuFZeG2zaz6XJEKsHQ=;
	h=From:To:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=eEoXPHlPTFW/UXpI2A1XYGYKra5U0OH1mSibnWHONkg02Ckj4jeiwbL9OB95wXQQFzD7wkUnGOJ6MtaM32pV50IOUlOX0CZcmuEpa56GZR86LXRsYCRH4ae5IDHmeymtBaHVj4QIDXWRaFy4gRzhI3XlgelmocnfbaJ7J43Pb2g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NceQfCv8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NceQfCv8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA983C4CEF5;
	Thu, 28 Aug 2025 13:18:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756387140;
	bh=lBUBXKSTLeYCVkAZzTqATwh9bMuFZeG2zaz6XJEKsHQ=;
	h=From:To:In-Reply-To:References:Subject:Date:From;
	b=NceQfCv8JtcJwnR8Iyt2aOVIzyYsE2s+CA7+3sdSXDDVAfciGuyrAOiWn3jBbya9N
	 jKNIikS5jgpKLkqmhr9LG02qszwxj9jBLp6Ze08122o1sNXY8N6fyOxXELrU0KDRD/
	 29ry3l0bOj9q73IKvUDENCxMWnMD4uWIuSch/Tggrda0F4HKREhf8FV5Xe4XApwzo3
	 EhYv0Owscti7Ynmt7CpEtzWFl9U5oVr3b7OgVnlfz3bu2cXPdny1r+dfLsFTTnbGL3
	 xwgggClNb54WICsK3vbuwifNQxcEkVF8mB2EhI5PrrCSI/XP33iuDRM4+52clp4OWZ
	 DcLSNcUSfPkNg==
From: Carlos Maiolino <cem@kernel.org>
To: djwong@kernel.org, linux-xfs@vger.kernel.org, 
 Andrey Albershteyn <aalbersh@redhat.com>
In-Reply-To: <20250804-xfs-xattrat-v2-0-71b4ead9a83e@kernel.org>
References: <20250804-xfs-xattrat-v2-0-71b4ead9a83e@kernel.org>
Subject: Re: [PATCH v2 0/3] Use new syscalls to set filesystem file
 attributes on any inode
Message-Id: <175638713952.29667.3546386820900620080.b4-ty@kernel.org>
Date: Thu, 28 Aug 2025 15:18:59 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.2

On Mon, 04 Aug 2025 14:08:13 +0200, Andrey Albershteyn wrote:
> With addition of new syscalls file_getattr/file_setattr allow changing
> filesystem file attributes on special files. Fix project ID inheritance
> for special files in renames.
> 
> 

Applied to for-next, thanks!

[1/3] xfs: allow renames of project-less inodes
      commit: 8d2f9f5c64f16e0717854fb66d795ebe8c30103b
[2/3] xfs: add .fileattr_set and fileattr_get callbacks for symlinks
      commit: 8a221004fe5288b66503699a329a6b623be13f91
[3/3] xfs: allow setting file attributes on special files
      commit: 0239bd9fa445a21def88f7e76fe6e0414b2a4da0

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>


Received: from mail.camora.dev (mail.camora.dev [45.63.89.95])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA7131ACED5
	for <linux-xfs@vger.kernel.org>; Fri, 26 Jun 2026 00:28:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.63.89.95
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782433707; cv=none; b=YvM1L6q282TB7DFtF9L79KgetioktjqtF1/TEiUO+ONRNbjCmJ5ZDEwpxtWoaBGPp5H8AR0IVUCVp95P/43TRYQPXuTrN0nznZ15Jh0oY73fHP0gFVvs3us1jJ7It+1kHqkv6iI68SszWkm05iw2q0Y4qyn+p+3wDxvew2pCNbc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782433707; c=relaxed/simple;
	bh=d+lQja5lO1waj+4UY1TMhyJxzOgNdsyIxh/0ox8Fd2M=;
	h=From:To:Cc:Subject:In-Reply-To:References:Message-ID:Content-Type:
	 MIME-Version; b=TqSWzvXgTkYIYYD27ZJhesQwFn9IlDrtaJwvMsnn1E8/31/gS1LkT+U9P8U6YbGvK8M+zyz+vhgNs6yZ4Rk3RiSksY8nJlK7WPUBc/Ir8zB07GeYvoYWGr7TLRM6b3ky4GosNdu1ctOGT/RTh/NWGBSZF6im1A9Lo2yRPydnFI4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=collar.sh; spf=pass smtp.mailfrom=collar.sh; dkim=pass (2048-bit key) header.d=collar.sh header.i=@collar.sh header.b=dXF9JowI; arc=none smtp.client-ip=45.63.89.95
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=collar.sh
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=collar.sh
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=collar.sh header.i=@collar.sh header.b="dXF9JowI"
From: vmfunc <celeste@collar.sh>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=collar.sh; s=mail;
	t=1782433706;
	h=from:from:reply-to:subject:subject:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+vRjbavyPTlXhbvgta/fR8bO9QBQU5upx3BWKkNufF0=;
	b=dXF9JowIEiCsNcrjKAP+GI4zvAV9ENnje+212Tkx+KdGcYD5voXvUHasrDK1J5pe0X4qg+
	xagxUTanJnmv+VEehiCjIHpmnah7iNNmhOrNIrDkIGNrI67GsiRnrKQVF0Nk9U+SCXZC0B
	0DG+Zmk7L8jAV/3HCT0YAPdsxIf3tLMXwoLpaKk2Cmpq/gILTOK3KpT+Dpnge6pda8TcjP
	oIQInxLWXqzfkhTNVR2+XUvgjW4VxPEuNOxyuaKaYx51snzoqFRbX7c6rM7Yzv1rtPUtns
	SJAIyzjnyAvdj9qQk1V2x0RIogitXaGp1XP2sKe8kEGEcvy5YtPMoZXibAr/wQ==
To: Darrick J. Wong <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org, Carlos Maiolino <cem@kernel.org>,
 Andrey Albershteyn <aalbersh@kernel.org>
Subject: Re: [PATCH] xfsdump: avoid false-positive __strcpy_chk abort on long
 dirent names
In-Reply-To: <20260625225758.GN6078@frogsfrogsfrogs>
References: <20260625222337.54449-1-celeste@collar.sh>
 <20260625225758.GN6078@frogsfrogsfrogs>
Message-ID: <178243370553.73182.935356806206037088@collar.sh>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Thu, Jun 25, 2026 at 03:57:58PM -0700, Darrick J. Wong wrote:
> Why wouldn't you fix the structure definitions to use the proper VLA
> syntax (dh_name[]) instead of making the code less readable?

looked at that first but dh_name[] doesnt drop in cleanly here. the
declared size isnt slack padding, its the count of name bytes carried
inline in the fixed-size on-media header, n read_dirent() in
restore/content.c reads the record back out using sizeof() of that member:

	namep = dhdrp->dh_name + sizeof(dhdrp->dh_name);
	memcpy(dhdrp->dh_name, dhdr_v1.dh_name, sizeof(dhdr_v1.dh_name));

sizeof() on a flex array member is a constraint violation, so dh_name[]
wont compile without rewriting that reader. it also breaks
assert(sizeof(direnthdr_v1_t) == DIRENTHDR_SZ): the v1 header is 16 bytes
of fields n dh_name[8] is exactly the pad that brings it up to
DIRENTHDR_SZ (24). as a [] member it goes to 16 n the record size moves
with it.

so a proper [] conversion means reworking the v1 on-media reader + the
record-size invariants, felt out of proportion for fixing the fortify
abort, so i kept this to the minimal change that preserves the layout n
the rest of the hardening. happy to do the struct cleanup as a separate
patch if u'd rather, just flagging its a format change not a pure
readability one.

thanks,
celeste

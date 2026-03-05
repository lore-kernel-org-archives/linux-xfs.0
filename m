Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8BF6372B5A
	for <linux-xfs@vger.kernel.org>; Thu,  5 Mar 2026 09:48:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772704094; cv=none; b=ZJOuyDmjFc+5Kuj4edq5SzPErQbygYl11S4EQrpL6GArxGVSc2wGLQJIgLpihgL5Bo1tteCtBhShaYj5LE1lgKVxSdtL/uE+LFriLanYLlluV8h6CrY4ybyz7Z/paDO8iXQ3usrcRLaddB9TWQGEXpPuQpFsKxnuj2yp0M6YjhQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772704094; c=relaxed/simple;
	bh=8W0hZ0iQpLh7OZZgJrtUfhMhGOSd9zf6zWb9YuT8jsI=;
	h=From:To:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=T0vlD50GHAtlvKwKXWMw9R77K38fyplVvABHkVUHr31NWrH+yPXhU4MoX98npoh+mRoiuGAlY+URko1RNwMU68YpnLXgMpSb+gdwWLaRWv4ZOKiZoWAzCN4nQreLux6qLydc5GEEkpVqOlspZXjIHsDc2wgeSleZb4Dd3Arf9iQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eobUAYYi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eobUAYYi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00132C116C6;
	Thu,  5 Mar 2026 09:48:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772704094;
	bh=8W0hZ0iQpLh7OZZgJrtUfhMhGOSd9zf6zWb9YuT8jsI=;
	h=From:To:In-Reply-To:References:Subject:Date:From;
	b=eobUAYYiH1kFbg0+wLRNgfYMm19G4nfkV64kN8JpYno91MavNQG+n731uVEhueU/p
	 d5+FkUGjqDRFRjKdoVCqPkRnPldvtMqmxWGeeAINWsaER8uISn4wpxzS5OfIS1MkvI
	 KtC/WCkc5FHU2ORywGyxuuT5iOpavUmE2OqutPIueb6EoSTjiLlyTx8JQLv/PuSI1/
	 g3Q5pLa7l4IQTPGeY3mwSDQ6jyLicP4aQKJmwjwxcT5OidZk60ZRtm3BFwuSgpvwbr
	 qvCXH5hk5zhPQwgRqaXSk6tYj2MoYS+MAyPrXZ8XJZSfie9lzLnVnsSXTmLEFRgzQM
	 /GcXMUvFaBsUg==
From: Carlos Maiolino <cem@kernel.org>
To: linux-xfs@vger.kernel.org, Damien Le Moal <dlemoal@kernel.org>
In-Reply-To: <20260225224646.2103434-1-dlemoal@kernel.org>
References: <20260225224646.2103434-1-dlemoal@kernel.org>
Subject: Re: [PATCH] xfs: remove scratch field from struct xfs_gc_bio
Message-Id: <177270409367.16364.1785184311578009435.b4-ty@kernel.org>
Date: Thu, 05 Mar 2026 10:48:13 +0100
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.2

On Thu, 26 Feb 2026 07:46:46 +0900, Damien Le Moal wrote:
> The scratch field in struct xfs_gc_bio is unused. Remove it.
> 
> 

Applied to for-next, thanks!

[1/1] xfs: remove scratch field from struct xfs_gc_bio
      commit: 6270b8ac2f41858952074b23c2d3d9aa2fe1bfa9

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>


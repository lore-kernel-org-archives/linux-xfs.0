Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5ED0039A7F6;
	Thu,  2 Jul 2026 07:41:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782978107; cv=none; b=dYApveEbOPCJIEMvsD4yNs58JZpWYqEWagcCexlV3TKau1KRTV5+3u5cOdOQMHaAmj+KOJxbC+lK+CFwRNXKdBsXfp2sEEfDhHZ+7+wjHelDROsiAZHORHUkkvfZUMlme4oOPEHAebkoJE3NoOW/10l46CvTPs0AADhuyvXQIJM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782978107; c=relaxed/simple;
	bh=rbbTGK5IEPcsoqPFchYNcH6XviR0Ovhzdz1mtknJTYY=;
	h=MIME-Version:Content-Type:Subject:From:To:Cc:In-Reply-To:
	 References:Date:Message-Id; b=j10xO1bPfAyCw12SbOOrnQGfdj7L77HBfHXI8r18wusJrx6bvLj1Gk2DeORcIC/YtZPdaXk1Etgq4v43DFpLVDJ6FBDTfqkZ9zA5HMF8hDbT0H4XllHuAnLP+0UoUOY69GvnmOZ/tPsamXyKH0f9f8exeEVoFAwgBHberrrp5zc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jfYUYY7B; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jfYUYY7B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A45741F00A3D;
	Thu,  2 Jul 2026 07:41:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782978103;
	bh=HQD+Zv+MCFoFX8owNBrpFDmZBtwE205TGxfDDnF3MAk=;
	h=Subject:From:To:Cc:In-Reply-To:References:Date;
	b=jfYUYY7BMT53WMwu8B8Vs9SmppFc4NEe81L/0n0LGa58GGwaG+d4MibP8Uj7/JlBz
	 CMifxOeMnDfDykmYQ9F7SNT4v0ZrcjK10L5+XWXjkEegwW2ajTHzdcusLNJo+SNTzZ
	 uR23l4vTYsT/iaLCtJBGjSn264AjROy5hxUdXb50XRT9hbWGBP99IYu+RApqa/EWzd
	 e/SjNn6OcULi+FE4RGYks2LiEBNi5noOO0WseMF5rwtuWEwuu036vJTg54LQiSW+8K
	 n7Kh072MH/9jt2soVBgHntGltUdNZgI1QPraT/6+IbnaAX+xauK9NEEV6Ujd199GTe
	 4EIJ/Tl6i5cyA==
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [RFC PATCH 0/4] Introduce capable_noaudit
From: Christian Brauner <brauner@kernel.org>
To: cem@kernel.org
Cc: linux-fsdevel@vger.kernel.org, jack@suze.cz, djwong@kernel.org, 
 hch@lst.de, serge@hallyn.com, linux-security-module@vger.kernel.org, 
 linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org
In-Reply-To: <20260626114533.102138-1-cem@kernel.org>
References: <20260626114533.102138-1-cem@kernel.org>
Date: Thu, 02 Jul 2026 09:41:39 +0200
Message-Id: <20260702-alufelgen-belag-tastatur-b666a49f7fc0@brauner>
X-Mailer: b4 0.16-dev-4217c
X-Developer-Signature: v=1; a=openpgp-sha256; l=1001; i=brauner@kernel.org;
 h=from:subject:message-id; bh=rbbTGK5IEPcsoqPFchYNcH6XviR0Ovhzdz1mtknJTYY=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWS5iZlKnTwSHtjY/+1zbMWWjeqHPylPPfR62bYTH9rPn
 Lmy3flTfUcpC4MYF4OsmCKLQ7tJuNxynorNRpkaMHNYmUCGMHBxCsBEXBsY/tcuKNpx6f3no4+2
 zmE3eRSpFHDs/Knij2+2eu2+ui4vOWQWI8Oqa1I7nlbouIp33bN+WG2tvVgunTE2J3K23ZnNesZ
 Om/gB
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624

On 2026-06-26 13:45 +0200, cem@kernel.org wrote:
> From: Carlos Maiolino <cem@kernel.org>
> 
> In some cases - filesystems quota specifically here - we'd like to check
> for effective capabilities without issuing spurious audit messages and
> without the need to specify a namespace for that.
> 
> This series introduce capable_noaudit() which has the same goal as
> capable() but without firing audit messages.
> 
> Also, this updates both generic quota and xfs quota code to use that.
> 
> The last patch unexports has_capability_noaudit() which was originally
> exported to be used in xfs but turns out it does not meet our needs.
> 
> Note this is based on top of a current series I have to remove
> has_capability_noaudit() calls from xfs so the xfs patch won't
> apply cleanly without that series.
> 
> If adding this helper is acceptable, I'll turn this into a non-rfc
> series with the required changes to apply properly.
> 
> Comments? Flames?

Convert more, please.


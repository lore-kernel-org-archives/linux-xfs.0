Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12D0E481242;
	Wed,  1 Jul 2026 12:50:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782910215; cv=none; b=sOqeo9QSgg7HHBM5xc7gvXxMC6ONmbaHDjvtkK1tiPcYTFa1V3V4ChmJfO7zyjte0+eL97NxfhjWOzlRMZoKuh90wY/4Z2OeHgCB+MISu9PVifFPorD5Gdi+orEyxl2nvy/wl5gh8GCecPd5uqFFni2bDGs+ArVSnVn/d6t/Mbg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782910215; c=relaxed/simple;
	bh=GaRptAkJWRzCHgv/U/UEqhut/Dkyjtfuozve7xHVtpQ=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=LgqSH+ihiwG3Hw4T6VQrI93SswrcUeta2Cd2kzSN06C+Ho/+oNrNp2RkKB+ImpgUOMj++SoLwdz1DIlyK/4p0TCPePAzbcPKdsCZoJHI/e/9k5YBDb1/XDCzxd0g2bzQW1JIPfJWUAwD0ozJwswtffEBTcuoGpU53a7OgN5z848=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=R5waQXqk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="R5waQXqk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C88C1F00A3A;
	Wed,  1 Jul 2026 12:50:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782910214;
	bh=u+QXB76SEDuUWUsuFodaiWw68/YnlG3c9cQZEepcM3g=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=R5waQXqk76x0VSVqaIo4sjU/0a4RACJz13mC8hAbLU7BdWACHEMD9oC4116qmOLW0
	 G3+Hwy8m3d+gCce2Wn1wBSzbac14opGe52gQODzdwfyPHxXezo8d33v4UvXMRbMnOh
	 y5ABmOUmCdiQYmnKv5BbZYAeQVoSYHfdD98rvbXw1TpPHtfW4XPBbV4Wg2j7xSPh1N
	 9B2NAjpgnOIZ9orYe4EYv/iupE1nV3UFl2ycnAoou8j87Xikin8+UcUDfQUP+2SkIZ
	 vWJ+3TaJRGjAU6cZ504W1an3vQhD6McO+ctAPuKLElg9p9pTYnvk1/eWoaRzSBmNBJ
	 Hbl/ecD2GHFhw==
From: Carlos Maiolino <cem@kernel.org>
To: djwong@kernel.org, kees@kernel.org, linux-xfs@vger.kernel.org, 
 hch@infradead.org, jiazhenyuan <jiazhenyuan@uniontech.com>
Cc: linux-kernel@vger.kernel.org, kernel@uniontech.com
In-Reply-To: <20260623024153.835431-1-jiazhenyuan@uniontech.com>
References: <20260623024153.835431-1-jiazhenyuan@uniontech.com>
Subject: Re: [PATCH] xfs: fix AGFL extent count calculation in
 xrep_agfl_fill
Message-Id: <178291021299.353898.18316681275244521090.b4-ty@b4>
Date: Wed, 01 Jul 2026 14:50:12 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15.2

On Tue, 23 Jun 2026 10:41:53 +0800, jiazhenyuan wrote:
> In xrep_agfl_fill(), the call to xagb_bitmap_set() passes
> 'agbno - 1' as the length argument. However, xagb_bitmap_set()
> expects a length (number of blocks), not an end block number.
> Passing 'agbno - 1' causes used_extents to record an incorrect
> range.
> 
> Fix this by calculating the correct length as 'agbno - start',
> which represents the actual number of blocks filled into the AGFL.
> 
> [...]

Applied to for-next, thanks!

[1/1] xfs: fix AGFL extent count calculation in xrep_agfl_fill
      commit: 7f53bf79bdbac36b644b9fe7a77516baf8de5109

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>


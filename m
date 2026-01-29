Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FE1C387373;
	Thu, 29 Jan 2026 11:31:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769686316; cv=none; b=j7hVP2PG7jeNyrcQC9RmHwtAxQCtDRtBx30nlat1CCtLpi4dCxLMyzh77xzOGFByPDxErvKgoULFX6Ueg7gnS0JY77IGxesLDLTafnDtPAfw4kQASlIeJ2TfC7HfSV4CRVfafrP6Zxy+cpTuKz3no/yAUAOREj3BIe2AG+EBs+k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769686316; c=relaxed/simple;
	bh=D4LfoQFseiULFQQIQx+easTqRY2e0gAD9nhI00MGTSk=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=Jyyz+3Z+jxTk7GUDrBizd5kk0GHxpMbixou0BARUlGxlkqxkKBifNAOo7+tGnmgCa+7TzGKGffLMOvnG4bnzt9J/ILQHJCTMNWF93ojOc2pU4JhiI2pTiEn9thFRMqGu8uzvDE5HwkH+m/Zr11VKLNg2uU0yyZ+rxezYjQ6k7K4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GvXxRDzb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GvXxRDzb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F67CC4CEF7;
	Thu, 29 Jan 2026 11:31:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769686316;
	bh=D4LfoQFseiULFQQIQx+easTqRY2e0gAD9nhI00MGTSk=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
	b=GvXxRDzbaOFgds8+/wckepKupZrDH3FSUtyyrczNpJzYU03Cu8uR/33omqnLpBeAS
	 uzEOeY2KRFupqv6OpX+6Og81TGQvs73Wwlr8FAI3Kyv3ej5bsrmKuZzo/CfgHeRa/8
	 gGftBYJRoRjm23siZTqnGHPs29GBuZTLCbACrHwtGVfB/VTyhHFw95vWUeOQRCDOIR
	 TJwGdeJ3sytmJg0tWWEX9GOF7UQCSGh8tou2kltdC49MMjdoutajS/C8SayrsvQFLL
	 vQsyYZk0uOgXeiNe0oK4zhJTYUHpHpgSdM7C4mFUN1yqQ2xOffTFmR0Igxsx3J/Rcj
	 b1PNAL4gAvwLA==
From: Carlos Maiolino <cem@kernel.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: hch@lst.de, linux-xfs@vger.kernel.org, stable@vger.kernel.org
In-Reply-To: <176939848160.2856414.18157451058012918573.stg-ugh@frogsfrogsfrogs>
References: <176939848160.2856414.18157451058012918573.stg-ugh@frogsfrogsfrogs>
Subject: Re: [GIT PULL 2/4] xfs: fix problems in the attr leaf freemap code
Message-Id: <176968631474.19293.735481998287545896.b4-ty@kernel.org>
Date: Thu, 29 Jan 2026 12:31:54 +0100
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.2


On Sun, 25 Jan 2026 23:21:56 -0800, Darrick J. Wong wrote:
> Please pull this branch with changes for xfs for 7.0-rc1.
> 
> As usual, I did a test-merge with the main upstream branch as of a few
> minutes ago, and didn't see any conflicts.  Please let me know if you
> encounter any problems.
> 
> --D
> 
> [...]

Merged, thanks!

merge commit: 1ef7729df1f0c5f7bb63a121164f54d376d35835

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>


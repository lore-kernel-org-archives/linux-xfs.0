Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EC17442FD1
	for <linux-xfs@vger.kernel.org>; Wed,  9 Sep 2026 13:15:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788959729; cv=none; b=WV37AajgYZFsi5MtPnayXq/Y8rUWt7WP3Q8/ivXG//jsKlicjlOgewW+/IKZ/lwr74Gna/wbC7HEogxffdNSqb3VZ65hzM2ymCYIRt9n1bt/JGLXxjC40Q/7+e1w1+SNdlCZxdrS67vV0Q18Vh9YyLdVcduKR7wB5N5TTg3cq3E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788959729; c=relaxed/simple;
	bh=R042BRp24UxdP6GevtuVRxCE16UoYqkWrCDfNF0zMwQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fk6V8WAlY+lRHM7nJmosCcO38ybpJTRbDLvJK8gpWikauM14clgjMc5I41//IbXMZAph8POqi3jMopegp9IAYs9HMTZcIAAv0IsLr7yI9/OjEOfQ/s23Mz07RJSlETJYuPdQzNDtMXJV/Ea5FKtgvcl86/E0B7Dke3py4Q+G7eE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WEl8Mapk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WEl8Mapk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FC011F00A3A;
	Wed,  9 Sep 2026 13:15:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788959728;
	bh=B0ys/c7roybSde9pLIQI6u3TDmVogxDXpe/c+jqjaCA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=WEl8MapkqM7riKkZLsJNIYQwFKchbMCCNbGQ90DzCl0LcmPgH+1uBrYhneuoO58w7
	 Ew1lvil/2ZtjMUhsEylWtrvzA4h7igv7Y495DuCJDLDTKnIlwWBkSs7p3E+LPrrded
	 bYvtgd/nQnRTYdt8e8/+o1dMzT42pEYF9tIXEPtaHDshRHeFDNysjsvfRQGc03LNK3
	 oMrZ/W9fDxYeg9nXGReZ66GU80bU69Pite9/sLfedRALRUW7tZ2yUqUUR529BbI1Ag
	 Q27wwZ+i4/LW8sX4PrIk/cAkqm6s9bWptVJ89mAiozDdBRDEAvPWww3T3bZ0FtAmzf
	 Fx33iFrfMC49A==
Date: Wed, 9 Sep 2026 15:15:24 +0200
From: Andrey Albershteyn <aalbersh@kernel.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/9] makecfg: handle metadir quota options
Message-ID: <aqFafEzViIfLdFQ5@aalbersh-thinkpadx1carbongen13.rmtcz.csb>
References: <178892910484.4047311.5337345469992668181.stgit@frogsfrogsfrogs>
 <178892910621.4047311.16295302909903460048.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178892910621.4047311.16295302909903460048.stgit@frogsfrogsfrogs>

On 2026-09-08 23:01:33, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> A different LOLLM pointed out that the mkfs configuration file generator
> should generate config file lines for the quota accounting/enforcement
> mkfs options for metadir filesystems, because those quota flags persist
> across mounts.  Add the necessary pieces to do that.
> 
> Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>

Looks good to me
Reviewed-by: Andrey Albershteyn <aalbersh@kernel.org>

-- 
- Andrey

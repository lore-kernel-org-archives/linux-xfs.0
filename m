Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 985FC3B2FF9;
	Tue,  7 Apr 2026 13:38:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775569101; cv=none; b=LRfuZNrrsamlfYNFjM5a4TcW+T8JraoumhaPLmXruYaiSTdkB/FNPGQQsjRa5kioa33fOAxnQ/4551Xlz+2YFHriumwLP4s0R3ulUJ/qX+Zfv8bG65f5HGKlkL2eE8aqLdNqVZTp8vIDwGCl8FjtaSp9d1gQVaHX1Xs8ubklzQE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775569101; c=relaxed/simple;
	bh=jQz46WTazFrARPv9jO3ZMQrsxxYYTJhcvcC4As1op2I=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=F+zPfdKTxoToF4Rv/Y5E5dBuFM9qngEM3bAtaQg5EqEdPyiHcAWwt7fHlL4SBW54v64vuF+P8/4E7eO3yO8SIcidH0dFhSiaZTdVD6vdQOl8qhbJivAfCsaETMUifB/Qfc+SvmuGhzDi8PSJOCldSmW5K2Ow7bzHZRGVLcZuG4I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HFVMUmtZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HFVMUmtZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99328C2BCB1;
	Tue,  7 Apr 2026 13:38:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775569101;
	bh=jQz46WTazFrARPv9jO3ZMQrsxxYYTJhcvcC4As1op2I=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
	b=HFVMUmtZOf5Uq8qnsOABKhvlbzsuUt/sXPD99oD/OE7Y+gSl7Qr5h2t75exWh5x5D
	 u5jlE02pXCredPBut7Ec3KILaPQ8K6qhS3sw++AVH4nlVKEimEnDlYXxyK4FRSYMGe
	 7YOjtCS36IoUcrWHppdTrC3lqAfBHIm2pLwjQprJXGeE3GxPUexiiv0IXMHw8x9X+Y
	 SKneyeU9bOwnXm6VJal///MISMsOITDd4ypCRm4S11jp6OQr5hYTORdgIGqn6aJQg7
	 rSMeE+rX6b5VEtjj/YDYRpPyN2luHqLkpy7C4dZdHD7U1oJ/ZFXiiD7YFzUTPI6s7N
	 il9mjVIBC9xhg==
From: Carlos Maiolino <cem@kernel.org>
To: ruansy.fnst@fujitsu.com, akpm@linux-foundation.org, djwong@kernel.org, 
 Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>
Cc: linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
 stable@vger.kernel.org
In-Reply-To: <20260401040241.560314-1-lihaoxiang@isrc.iscas.ac.cn>
References: <20260401040241.560314-1-lihaoxiang@isrc.iscas.ac.cn>
Subject: Re: [PATCH] xfs: fix a resource leak in xfs_alloc_buftarg()
Message-Id: <177556909933.105112.828032873209479746.b4-ty@kernel.org>
Date: Tue, 07 Apr 2026 15:38:19 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.2

On Wed, 01 Apr 2026 12:02:41 +0800, Haoxiang Li wrote:
> In the error path, call fs_put_dax() to drop the DAX
> device reference.
> 
> 

Applied to for-next, thanks!

[1/1] xfs: fix a resource leak in xfs_alloc_buftarg()
      commit: 29a7b2614357393b176ef06ba5bc3ff5afc8df69

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>


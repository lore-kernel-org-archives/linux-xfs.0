Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 805AA408026
	for <linux-xfs@vger.kernel.org>; Fri, 11 Sep 2026 07:27:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789111663; cv=none; b=ajGe+5lkUPhuke2GzxWb+WI+14i3tNDXwPtZfdJxytJoJICsXRD9/2aR/KUTwcV6qxpvHDFOGraydmyB1FFUzmCO1eChz4H7NCB1wP2oVIrb/MkrBlSxfyw7jkciVagOEYlfALRAc9pmhsIOZtqAg9byewDs7akgRXIXJI0v55I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789111663; c=relaxed/simple;
	bh=dcuEamrCiZJkIoxwKcXrjWYVsBokf9ybNuSYeigDrCo=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=WwqQ0k6dbuUI5hvz9NmGOvO/RSLRFhcFLkInCwztGWmL0R24kndllXY6Eu8R43CebsRp0WIPPMY3LPiWWtlB3fbgdyd+dPEz/MEGA3qq1pihtva5bkw0mJ1vqoANFPQO/hsZyWxvsIyfUZj+aSMrZVxfIigWt6/xD4U6LC2H3AI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ExgcWoYe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ExgcWoYe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48C181F000FF;
	Fri, 11 Sep 2026 07:27:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789111660;
	bh=CNKgnzrioJFSt1jsidg4YXuIzd4Wy5LHm36Ee9m3aqU=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=ExgcWoYeXFwHQC/tF6chNrEVErS6H3UHlVi7fWzfYp7JGK+dg1XLyinyDBgVHQc4Z
	 egTuY3I/Lzl6K8cvN4iefXUZ3knIriOxiz6UGEe8C/jYR3m9LZfvIaiAyumwhNov/3
	 fl5/z8rNSp4MnqJKQy4BUSG7eD87qRhJhH9GRs1kWj7NhXTJQVV9Wz93GKZS182J45
	 fKPfAv4t1Rjl2p9HJSSHOMXCSpTm+MfE6co9WKmniQO+O78I3FhWpr5rCzZxO/ZFjz
	 gY+WBuIJ1IhkWL4NeHBmB03DgF/xjjZaTP3URUzYN9fzsupitT58u+XrsrkkJkmohS
	 ILrVqGKrE1AXw==
From: Carlos Maiolino <cem@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org
In-Reply-To: <20260909060619.1101875-2-hch@lst.de>
References: <20260909060619.1101875-1-hch@lst.de>
 <20260909060619.1101875-2-hch@lst.de>
Subject: Re: [PATCH] xfs: convert all !XFS_RT stubs to inline functions
Message-Id: <178911165999.24622.15467521561794263451.b4-ty@kernel.org>
Date: Fri, 11 Sep 2026 09:27:39 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3

On Wed, 09 Sep 2026 09:05:26 +0300, Christoph Hellwig wrote:
> Avoid random compiler warnings about unused variables when CONFIG_XFS_RT
> is not set.
> 
> 

Applied to for-next, thanks!

[1/1] xfs: convert all !XFS_RT stubs to inline functions
      commit: ea089258eac7c53b593519a917d9f1671c632932

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>


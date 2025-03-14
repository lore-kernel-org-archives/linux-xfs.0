Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D46B12FF6F;
	Fri, 14 Mar 2025 13:28:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741958895; cv=none; b=EFYevCS5O+YRFa9yvN61Y6jwxTSzHogY8rAt/h0E6e3JgqXrwy97mhMOteMrOkaahSRB0CDTGuTa1HiSMAwecDxiGadWTbbU9K0aBF9cyupz1IS2USE3ipl0qCz44w+yPxZWkIetW9NMTLcuKU6ZK5HEUieARXsOnoWwpgDNUB4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741958895; c=relaxed/simple;
	bh=UyP/wk60gHV2lddSY6GpHZDEHOqiE/nUu/eMK2ZPGhs=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=hhQByyoN+iv7OYvWH42gRtTuczqdXjfj8LxgjuZdfbiYgkweK2nQC/PiQo3JHFQZZb3r1xpMOBU1yV6KHWysoX0H/hP/aww8U/U/pM+mJjyoVXbGqe4AJGYpFfM1vBU4OQeSzmZMGNlJVeOVWI6zz+mdql3Atvfn1CN2WlUtLFE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PTzSDy4h; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PTzSDy4h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33EDAC4CEEB;
	Fri, 14 Mar 2025 13:28:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1741958894;
	bh=UyP/wk60gHV2lddSY6GpHZDEHOqiE/nUu/eMK2ZPGhs=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
	b=PTzSDy4hMSNVp69S7CzpMpABrb1jTDtFTN2rmtLAlzWHRZIkbhKqbVXUm0ysypggI
	 letiuGq/0ftZ9H7gyN5nYXNTv858fEfYgEIfeNhhTRd8SSFOKbaXedsfzAZewco+Ex
	 pXTM3HNVNlvMFHXyE5MY6PNMElYxFsUv9onQioX0Sm2YscbXHD6WT2p2HBKPmE1C50
	 RbmF+pmo2G8Js4HtzFFPOLeqPnuYufh3KiCzEmEiZ7ZRFnn4I5EWgNyMFjTomVXrWJ
	 FkzJqj/U228hVBrxwP05RJesJ9htjHuPVI+rhlh904GU2nmzdwa+ZUUd1Jw10E8jqW
	 mSMD8yzXAiyEQ==
From: Carlos Maiolino <cem@kernel.org>
To: djwong@kernel.org, hch@lst.de, Chen Ni <nichen@iscas.ac.cn>
Cc: linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Carlos Maiolino <cmaiolino@redhat.com>
In-Reply-To: <20250313032859.2094462-1-nichen@iscas.ac.cn>
References: <20250313032859.2094462-1-nichen@iscas.ac.cn>
Subject: Re: [PATCH -next V2] xfs: remove unnecessary NULL check before
 kvfree()
Message-Id: <174195889292.416171.15750541984388942104.b4-ty@kernel.org>
Date: Fri, 14 Mar 2025 14:28:12 +0100
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.2

On Thu, 13 Mar 2025 11:28:59 +0800, Chen Ni wrote:
> Remove unnecessary NULL check before kvfree() reported by
> Coccinelle/coccicheck and the semantic patch at
> scripts/coccinelle/free/ifnullfree.cocci.
> 
> 

Applied to for-next, thanks!

[1/1] xfs: remove unnecessary NULL check before kvfree()
      commit: ef0f5bd5dd6233dd7952cea93ad80f3d7e45ad85

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>


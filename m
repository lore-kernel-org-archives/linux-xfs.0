Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA10F36654F;
	Thu,  5 Mar 2026 09:47:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772704025; cv=none; b=C7fl4duQTwT7WeP9c8s4X3FlDOwxW5FIsfLbWyLdtwuKSNjkXuWhK1xSvSPQEskms9VoNV5ibBlPdxic5shen9Pv/twgUqfM2YcnF2rVc0xcq4HyzkbJYmsfUoVsKWnuerTAOxqGdpcZU0JTqaPiOv2pDC+LXrQ3/DHheVruCj4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772704025; c=relaxed/simple;
	bh=G4tHHyffqlJFbAOEiX67ktBTDJ8NqClxVmIA5Qa9T9A=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=n6c6u6qZskTCJQGrd+rHjlZ9UnD1xohmDJjyIBU74O/C2g0lG47FR8wJ6eO50BtnqVmpM5rhjgOnkFTPRRhmuOArFnBA2eZTmbCGbkLr/kWaHKvQR2uMr271nnFBl17pn4fYmet9j3rb0ebEDpBXXf57aOXpwf708muhB7RWfkk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sPe+p5Zj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sPe+p5Zj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A943DC116C6;
	Thu,  5 Mar 2026 09:47:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772704025;
	bh=G4tHHyffqlJFbAOEiX67ktBTDJ8NqClxVmIA5Qa9T9A=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
	b=sPe+p5Zjn/20Bi8ukGbfoSRV00hNE5Ytez3CKuOtgE8LV/gIPs5bVGhhFe+MclPAO
	 mRKHRWArtqG7JSOhTOj3wYixwb1OWMDRbqVrP23alHlUb9l64XBO6kMjtJU8tb1bA3
	 wD3VM2fcTfzydN9ewloEN8OSOuw1YjkRj8BVpYYmKAIo0DEPsC7H3Jp+B6Le3Yfxp8
	 MH09MdUAWGKBUn+5auqDv5oIX7klVQ+M6kHNvagmAR2KXMOXfggb5iezyHn8ynlwDd
	 2NaweK59EIG3Oo+HnXHIzwwvz3N8WMve+Zc0/+gl5sVl5YxUXhTCWTdVJagqxa5gE9
	 0f4Sci7HVrFGQ==
From: Carlos Maiolino <cem@kernel.org>
To: Andreas Gruenbacher <agruenba@redhat.com>
Cc: linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20260304185923.291592-1-agruenba@redhat.com>
References: <20260304185923.291592-1-agruenba@redhat.com>
Subject: Re: [PATCH] xfs: don't clobber bi_status in
 xfs_zone_alloc_and_submit
Message-Id: <177270402441.16196.6189139516303485747.b4-ty@kernel.org>
Date: Thu, 05 Mar 2026 10:47:04 +0100
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.2

On Wed, 04 Mar 2026 19:59:20 +0100, Andreas Gruenbacher wrote:
> Function xfs_zone_alloc_and_submit() sets bio->bi_status and then it
> calls bio_io_error() which overwrites that value again.  Fix that by
> completing the bio separately after setting bio->bi_status.
> 
> 

Applied to for-next, thanks!

[1/1] xfs: don't clobber bi_status in xfs_zone_alloc_and_submit
      commit: 5be2161f245bab6aaf0723fdd0c9635dfcaf9de5

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>


Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2ACE4BA33;
	Tue, 26 Nov 2024 01:21:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732584111; cv=none; b=RwFWXQpzc92YnRQU7PiamKJ+z8Gt8vwUyXotAKZL8f+LlAzaM4n33IA4Rw2gs8+oNIZ7XzGpN6r7rkcXXHg26xPLCgNTnQSvNrRJmBlAY50WMoBcXA+sKAc+hl1AwhpK/NP/GyG/OLZZ2ZLd61AsiMNRXwaGHuzU3mmMkbzS9lY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732584111; c=relaxed/simple;
	bh=U5YpQvVXfme59F60JiXRVBQ66exe5J5wYQtEZW4/lyk=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BLPmax1Sq8S2+V5/9ePPK48B0TxihvqABz0fdxHJ8wWyAG+JrDTuaNDqy2jla94fzY7y1HzMjWyzxxj/QxwYMdNJIiRN7OKLabPeE8E4eA0n9IS7tsr0Znl7Y9nnBthfwc5AqVzLzHwawu1hUZDmJwM/pA+XqRHfTKDS9u8+TeQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Es2Bs/ZN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Es2Bs/ZN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABDF5C4CECF;
	Tue, 26 Nov 2024 01:21:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1732584110;
	bh=U5YpQvVXfme59F60JiXRVBQ66exe5J5wYQtEZW4/lyk=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Es2Bs/ZNjLEl2UJcljv6MdH3NZVxfG3EYCGsWaJDzkJ6ZdkS8Bsdh+ah1RZT/dgwL
	 p/dAURMgR5cF7DeMev0jyTaNvWAgWGZSc2BwUyiPCBREhUTOwfCyN2hiqcGX75luXf
	 i0MSCzbfBAjXFyjzlRKj/1IdPcGOJ1nKc+gKQPN9g8ML3alq/hFCX+dTazVhFlNPnP
	 ooRsRzTmggTtnKxwRJILpdFJygZfXLSbrQDpfOGIjg786qsdgkko8JZVzXby4dc8zd
	 lf3svwLmnXPNWp6TrY6p/FawglgT1rlUXHXOUaQ1CR30OBO+qfWTlz0Q7urPo/BIgT
	 2W17MxazaZQYQ==
Date: Mon, 25 Nov 2024 17:21:50 -0800
Subject: [PATCH 05/16] common/rc: capture dmesg when oom kills happen
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, zlang@redhat.com
Cc: hch@lst.de, fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <173258395147.4031902.17552037714808836810.stgit@frogsfrogsfrogs>
In-Reply-To: <173258395050.4031902.8257740212723106524.stgit@frogsfrogsfrogs>
References: <173258395050.4031902.8257740212723106524.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Capture the dmesg output if the OOM killer is invoked during fstests.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 common/rc |    1 +
 1 file changed, 1 insertion(+)


diff --git a/common/rc b/common/rc
index 2ee46e5101e168..70a0f1d1c6acd9 100644
--- a/common/rc
+++ b/common/rc
@@ -4538,6 +4538,7 @@ _check_dmesg()
 	     -e "INFO: possible circular locking dependency detected" \
 	     -e "general protection fault:" \
 	     -e "BUG .* remaining" \
+	     -e "oom-kill" \
 	     -e "UBSAN:" \
 	     $seqres.dmesg
 	if [ $? -eq 0 ]; then


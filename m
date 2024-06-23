Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6AAC3EA69
	for <linux-xfs@vger.kernel.org>; Sun, 23 Jun 2024 14:03:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719151425; cv=none; b=eaSo3JpqDmhvwomyin44cR9AaTwZpFem9R7Sg6EyVgkyrKzJIxX1Ul9RonRc8QZ8zUHh9n6r/it4fjxoHoO1bS7V5Aq9umeiHFVM4axCQU0WGQ3kzia2079QukQ4IXW13MkiVMwJnS7o0AePRktecWc+jVwkyG6HenitNMdnMpY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719151425; c=relaxed/simple;
	bh=s4IxD54nNdO9A9Bh9NYOOwMRb5ery7TI6wJ/Sng5thk=;
	h=References:From:To:Cc:Subject:Date:In-reply-to:Message-ID:
	 MIME-Version:Content-Type; b=DILxIjq5nZF5DPwEMZ/yMfcJousXB8OnrgmziZFmBv5PoVYEDDpJerCMeqQ5OPogmUbB+5djxAI5IFPRiwN5e+1BYdVq9hap3LWwyBGJ9A1YuswckxONr7uSciSB4i3Qatkh2iGlTNRIHcpqzj94KjV/Tz4Mv0aSRMaUr4ZdjK4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qrVNCQUG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qrVNCQUG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C644C2BD10;
	Sun, 23 Jun 2024 14:03:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719151425;
	bh=s4IxD54nNdO9A9Bh9NYOOwMRb5ery7TI6wJ/Sng5thk=;
	h=References:From:To:Cc:Subject:Date:In-reply-to:From;
	b=qrVNCQUGBI7v8P2hhApYX9SHeVlZxnLQcirwXNQKPbQEpoqTcnnHbk5k98DxTfeF4
	 SSxm/3W5jMe63YkNprOXOfhVR9H9QwaEJnbzQzH8JEIgqhZJb92W8KPBpsPFhqxlVv
	 9Irs4Z5N/yG9y1x22xec6dtJyPnJWTGIHyQI0BpGbExwOYPQeILnG16nyNPxf4zHID
	 ogOT4w1Okc8PIanzbGdfbEqT26ENpNzPmmhpr/4ZKbwFU5YUMDo7OPdywFI1nTbu9e
	 5ZJgLanM8JgtzmZCJHE8W6nApt86nOw9EwS6/Te4arHN4p9KeJidmVUo0tQAP7y4i+
	 FBAYjK0l6Q8iA==
References: <None>
 <171907190998.4005061.17863344358205284728.stg-ugh@frogsfrogsfrogs>
User-agent: mu4e 1.10.8; emacs 29.2
From: Chandan Babu R <chandanbabu@kernel.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Subject: Re: [GIT PULL] xfs: random fixes for 6.10
Date: Sun, 23 Jun 2024 19:18:19 +0530
In-reply-to: <171907190998.4005061.17863344358205284728.stg-ugh@frogsfrogsfrogs>
Message-ID: <8734p34uyp.fsf@debian-BULLSEYE-live-builder-AMD64>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

On Sat, Jun 22, 2024 at 08:59:00 AM -0700, Darrick J. Wong wrote:
> Hi Chandan,
>
> Please pull this branch with changes for xfs for 6.10-rc5.

The new patches mentioned in the PR will have to be queued for 6.10-rc6 as I
have already sent a XFS PR for 6.10-rc5. Can you please rebase the patchset on
6.10-rc5 and resend?

-- 
Chandan

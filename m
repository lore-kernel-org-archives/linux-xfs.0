Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A50413B7BC
	for <linux-xfs@vger.kernel.org>; Fri, 14 Jun 2024 10:10:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718359847; cv=none; b=b8ysdEO8JVGaW21/MIbqpJ3Jvzf6Fof4lLuoQ0ESp3OSCUGLOsdSG8h8YrlPAqOCD+2jM42VvB9yaQ2QYlDZ/RHr01znkmEgZCE+rglFHgsJYT0DT13fNN7UzYrvWMeWlcvHlmlsknmCWlTq6xlUMOSj45HIvKfUyUGOeKSk11U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718359847; c=relaxed/simple;
	bh=Y4fS70pVXZey+LPpLNAXn1yGKygqBVUYZpTdJeVBg7E=;
	h=References:From:To:Cc:Subject:Date:In-reply-to:Message-ID:
	 MIME-Version:Content-Type; b=Di5vibqbFgLoeeqborDiUx7Tt3m5S/I5a8xfLbf9rs4SbRAYVKWD+wQUcn+AmLM+27eorPwumBNyw/ztyZHRnElBoEd9ITe5IjOqKe2GWZCwAnqdVy3H50xJ38f3SSSEPEhPKNX6z9lLzhxlDNQdZqYUcqMbUNCRK7uzAWcVl8o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hE3Azoy9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hE3Azoy9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63E3FC2BD10;
	Fri, 14 Jun 2024 10:10:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718359846;
	bh=Y4fS70pVXZey+LPpLNAXn1yGKygqBVUYZpTdJeVBg7E=;
	h=References:From:To:Cc:Subject:Date:In-reply-to:From;
	b=hE3Azoy9OeAmqDJJc25+JoOMxG36PpE9fIpfvUgCDR4uMNK4g/i3EQlUNP/SImqFR
	 JbKuiqSF9gSGA3iSk8gjnMhlMPKaTTCkk7YxYUYDlXB+PhQGbjQ5u6CTPOUPRz/aFl
	 UFeb+I0wTzqs+hk6xO1Ld40DBhRGhxWEXF/+M+VvPlivJEUW0uwVJYezQpnzBIwVw2
	 MQM/1TdKqwcOPCjRkgYFDJli6w92UmqO/m2wZXu/KwP1Sq1seCXIXpdabm0hASSGSt
	 Q/dgRPhgp5Fohz6BfE/06qoPOfU1j/J3KtQbGX1/7SiMIsr1rjETwgB7Kk3h1LnaZb
	 L95evPdYOGmMw==
References: <20240612225148.3989713-1-david@fromorbit.com>
User-agent: mu4e 1.10.8; emacs 29.2
From: Chandan Babu R <chandanbabu@kernel.org>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: fix unlink vs cluster buffer instantiation race
Date: Fri, 14 Jun 2024 15:31:23 +0530
In-reply-to: <20240612225148.3989713-1-david@fromorbit.com>
Message-ID: <87frtfx2al.fsf@debian-BULLSEYE-live-builder-AMD64>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

I am planning to include this patch for v6.11 rather than for v6.10 since -rc4
is generally the last release candidate where we add new XFS fixes unless the
bug fix is critical. Also, linux-next won't have new releases until June 30th
i.e. the next linux-next release is on July 1st. Hence, we will miss out on
testing/usage of XFS changes from the community.

Please let me know if you think otherwise.

-- 
Chandan

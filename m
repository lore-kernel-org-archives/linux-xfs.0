Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794480336;
	b=KmIcYaunkoCGYGekiUajsRtMcAqSvnJ8P9e5AsPIOLDxLISw2pvwwpCRk0q66T/Sw2qA
	 x3ZQDWZgnPTmNFKUMYvgJm2U1mOXGMUgYuIkhBkdRBRWoRSpPNNzYQYzxYQV5HLr8RCkL
	 1j2FqoNjrYxc5TPgb376wfebuLqB0HKA2VlXAz/1/vVXPWrPGC1/jJ+9Ub/kfONsHCVXr
	 cdL8l8sJBMkW5Wwztf4b4xqGdAGhnDNSJVwF8j6LZ8nXEOdIn6NNGSH5/Kn1cBXPNbrvk
	 qQ/aWDDJyl+TY5NZK5/bJ2vEb0sLZ0mOYwESIhXr/DW9uyMXPcdn5Qbgz2MiXTLWU5w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794480336;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 MIME-Version:Content-Type:Content-Disposition;
	bh=0UFdpnlJ6FMTafaz1XNjhpalFp9g1Z71yviBRFv2A8o=;
	b=iILPty6tdLxOfk3FODfn0JZcB+ZsR8xG7xBXQSl+iN1YPk+AUXfrLMRJGS7Yih8+16Vk
	 LBYBeKXc5Q3IezOqXg9Ml8RXAd3JVajceEES72uuL2IfMw6TcjmD1LpE2v9RAlD4t10HV
	 iZrHJlrcEyk9hSUyQBbPf3QwfEByHioa84EB0dNYWErvc/eRPQoG8GMF/912c4XoeD5BQ
	 fMcNxMuGNMIKXqjT89fgOJCku5KWlmDCb80lc59PBpd+MZW2Q2j78koVJlPrymy3MOb5/
	 XxPJOVff51Bd64y9cqJ6f5vCVqWQACiOUpFBs3S0aKG1MX85a6SqA/4nVghAZGEt0hw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="K8w/nUQ4";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85C1A60A383F
	for <linux-xfs@vger.kernel.org>; Thu, 12 Nov 2026 10:45:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=K8w/nUQ4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10D701F00A0F;
	Thu, 12 Nov 2026 10:45:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794480336;
	bh=0UFdpnlJ6FMTafaz1XNjhpalFp9g1Z71yviBRFv2A8o=;
	h=Date:From:To:Cc:Subject;
	b=K8w/nUQ4hUgXN+foA1LipMiY1kmHbQnzNDjep34tGK7LzUm7e366v7bH52o96Kxrj
	 rHOQwUODOsKHFKVBJU38+CLBzf8m0bNHQTbkqxqD3vmV0HJAgkC5cI2S2q/m2QBmml
	 GevJ+kPN+66mMWgRdtkOPsNTNGpuCTEkHL5dezBCZjLbAxvNSGhD8VWRj+/zrcwCxR
	 B8l4Ss3k5a+N4+cRPPytLLybETMm7duN3XliCcYO1nPSgB4VEqJRtjfbjmWcF4xgzA
	 anYUVAPLiAKhjKF6PdOmiKSfu08GQxbFzzED3la+/xhuTTf+UeavUDIjPbxn0QwFpv
	 Ui+miNYzLHNFA==
Date: Thu, 12 Nov 2026 11:45:32 +0100
From: Andrey Albershteyn <aalbersh@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: aalbersh@kernel.org, muhammad_hazley_samsudin_from.tp@tech.gov.sg, 
	sandeen@redhat.com
Subject: [ANNOUNCE] xfsprogs: for-next updated to 1c122bbd3c88
Message-ID: <avWYxVqDT9aJuM2-@aalbersh-thinkpadx1carbongen13.rmtcz.csb>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi folks,

The xfsprogs for-next branch in repository at:

	git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git

has just been updated.

Patches often get missed, so if your outstanding patches are properly reviewed
on the list and not included in this update, please let me know.

The new head of the for-next branch is commit:

1c122bbd3c88d89695d3b60c1070d87073d56121

New commits:

Andrey Albershteyn (1):
      [1c122bbd3c88] xfs_admin: remove eval use

Eric Sandeen (1):
      [1688728b6c90] libxfs: capture error return of cache_node_allocate()

Code Diffstat:

 db/xfs_admin.sh | 142 +++++++++++++++++++++++++++++++++++++++-----------------
 libxfs/cache.c  |   2 +-
 2 files changed, 100 insertions(+), 44 deletions(-)

-- 
- Andrey

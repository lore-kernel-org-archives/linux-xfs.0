Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 021D2369D7A;
	Thu, 10 Sep 2026 06:01:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789020080; cv=none; b=JYB7IBe43OCnfU6JBGNx/Q81BdPYXHigm86sOTMtLirmAAYgDE+AoazvvC5+D5X9qMqxA33a29ooaDI++WRN4c2u4Jv6VyzrsU6pxcaBF1oasSPyHIhgQI/E9F7ODi4crsl9cGn8+GO2+1fDE38p+TjXKjU5Su6uJ7MIBJmJW0M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789020080; c=relaxed/simple;
	bh=iqMTar/e8AhdHFcEKctsdEbmp6zMshSTTWgHBi9gpq0=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HkREIlSQXK2oRxtohDaY4j/JjSP/6CmxxGtr7RJ+CqzB8+36PXK4VqSQqhTzeXrdA81UIiJCmCTZqNHXEq9EDgvwyIdCv2Lm1n/3SAFmiGwMNCYDf9juxNoec2zENrJfQm30y31oCjZOrR5aWiCnW9ZxyitNaZIMcnntDHHGssw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UlyVsagj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UlyVsagj"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id CE8031F000FF;
	Thu, 10 Sep 2026 06:01:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789020078;
	bh=zb+pgwCa7Gcp+0k2IykZIPzs4udrqCMd0onX9X24IpY=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=UlyVsagjMZ2BgYdsXTDP1NEE4HynBx8wghPCoswic6lJ9nZsAAmzeZaUnKydHsNuE
	 1sqOdNzMPcpmTRZ3gn14gwmqp11N+zVb55+Qu2v+YoILdHVB5c/jev8f7FqEPYXhOO
	 OP960duRNcBr0m/yNjhqaIIa4BWSOlVJcL1Da0F4HlC3cHo0v9/C8O8LCw27B1LvCd
	 okZ/YGkh0Hny8xu5MCw4B0spoPCrdC269FO5RN7udh0QNAthaT5XgSHwTbJhqy9ihd
	 RFhkXyB/k9qNORw44SPlr1UY3B8T6JjLHDINnOj+K0rP/XS1u0vdmc48O24QW2J+sw
	 qV0rEdB903FpA==
Date: Wed, 09 Sep 2026 23:01:18 -0700
Subject: [PATCH 6/6] xfs: use correct jiffies comparison function in
 xchk_maybe_relax
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org, hch@lst.de
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <178901989959.361651.2838640248053656232.stgit@frogsfrogsfrogs>
In-Reply-To: <178901989791.361651.4660674894120948649.stgit@frogsfrogsfrogs>
References: <178901989791.361651.4660674894120948649.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

LOLLM points out that we're supposed to use time_after_eq, not a raw >=
operation here, or else jiffies wraps can go unnoticed.  Fix this.

Cc: <stable@vger.kernel.org> # v6.10
Fixes: 271557de7cbfde ("xfs: reduce the rate of cond_resched calls inside scrub")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
---
 fs/xfs/scrub/scrub.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/fs/xfs/scrub/scrub.h b/fs/xfs/scrub/scrub.h
index 6d7d3523b71f25..7ade1d005efef6 100644
--- a/fs/xfs/scrub/scrub.h
+++ b/fs/xfs/scrub/scrub.h
@@ -40,7 +40,7 @@ static inline int xchk_maybe_relax(struct xchk_relax *widget)
 		return 0;
 	widget->resched_nr = 0;
 
-	if (unlikely(widget->next_resched <= jiffies)) {
+	if (unlikely(time_after_eq(jiffies, widget->next_resched))) {
 		cond_resched();
 		widget->next_resched = XCHK_RELAX_NEXT;
 	}


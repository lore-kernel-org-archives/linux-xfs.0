Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3BE23C1D58
	for <linux-xfs@vger.kernel.org>; Thu,  3 Sep 2026 06:06:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788415570; cv=none; b=SRXPfbmVCE9v9xLhk8RWNWKRiiAlwL8SsBRAKKO7RAhJrP/RjiIHTuFPb5UOSgYITjIbl2YnSyWczD4PpSGI0e5QzzVLF8UvimBNtOMHMhYB6mQLAcwXMbEWpzM1StPfBrAXX4K1RqqPupw6pkLiYxjEeTIVzXeA2vvRe/Dmyiw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788415570; c=relaxed/simple;
	bh=cCIEUVo/Jia8Lx2nKVOiztZq9JDiPbLGe1tteX94G34=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=JTBXHoCiBMz6lfJM1ck881ldA47xqi6pMBdUlmzD15Nc2sPX4+cZOZ/jj3qkwDGMOGiyGf24aczhrUYWNx6tb1KURBSwIk1ppNOuqIlKJhhv3wPjY5PJJ7sSp8JTug9A9oQCrsspA3OdrYmoFj9HKzpZvdqRPw3tG9ESl+acFQ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kz3tkHMY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kz3tkHMY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D29DA1F000E9;
	Thu,  3 Sep 2026 06:06:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788415569;
	bh=AsF4YFw2onqGCJ4WdRp+Ycu4ldt/bkf2CI5LTB+nf74=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=kz3tkHMYcIq6VkQkjjbQzMH977NFxWohWgyMwAYShVL4zXkrc6izv0ZDW7+kpCkBf
	 5kxdio4hHD20sD5Ftl7Ll9vcQ9lf5jXSO9PwgnXiK7Oha1po+sm/qHmDzJtLJsiWWs
	 jc89pPFzvI6IBG6VpwtSOXvWOTA2ZVZOaHlXXzFFosN85nCzVPqpBJ2byLzbIZhpV+
	 Lz7EBDNMX75KLwphb5pYWV1mhn+CBRhHzKZ2NY8PKkLsAOCHBBjt1v59f8irCsUPqI
	 mbpMe09TGn0x+tY//Tp9pF8oUDaBZ/kqVj+/5LVKo6Ct+xpnnGrFdrvSu2ldwBvJLn
	 YvSCVaJvYKT/Q==
From: Carlos Maiolino <cem@kernel.org>
To: linux-xfs@vger.kernel.org, Eric Sandeen <sandeen@sandeen.net>
Cc: Christoph Hellwig <hch@infradead.org>
In-Reply-To: <ce64892a-c991-486d-8650-d40a6452699e@sandeen.net>
References: <ce64892a-c991-486d-8650-d40a6452699e@sandeen.net>
Subject: Re: [PATCH v2] xfs: mark slab-allocated xfs_buf backing memory as
 __GFP_RECLAIMABLE
Message-Id: <178841556855.1198521.10851446476367006341.b4-ty@kernel.org>
Date: Thu, 03 Sep 2026 08:06:08 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3

On Fri, 21 Aug 2026 17:26:39 -0500, Eric Sandeen wrote:
> xfs_bufs have a shrinker and are therefore reclaimable, as is the memory
> backing them. Mark slab-allocated backing memory as __GFP_RECLAIMABLE in
> the kmalloc path so that it is accounted properly.
> 
> 

Applied to for-next, thanks!

[1/1] xfs: mark slab-allocated xfs_buf backing memory as __GFP_RECLAIMABLE
      commit: 033067938274649f611286f8404b6e5c50c3f1f2

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>


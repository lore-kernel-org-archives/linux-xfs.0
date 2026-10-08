Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2852446053
	for <linux-xfs@vger.kernel.org>; Thu,  8 Oct 2026 13:32:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791466372; cv=none; b=YTMf/ict56JVtmdozX5eDH+r8+JZTL2/nJdEB3XtVkPEc6L8IDHlgt8TpZjq5nWbQoXvIOG+4CRnRsTrrZcVeyA87483InZF5PPx0xFvOjICQGTho1TRMGL15pEutPdBd/3CWf299UVvezfbnDTN1wbOaAXYpb1HHukPTCGO0OE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791466372; c=relaxed/simple;
	bh=N5glzPg3ZtbRmoKYtdRAb8wffxB40XSjR0P5OgSwrLw=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=XpBksKRvZEZ/F1XkESEhs8zPAnogDv2ZupN+lapE44CV1zu1SDSaLa3rLjiALjsbUgiF6AGaTKlmyE8hynamnBXQHURk3JQaTlut0FJ2tUa2Yh4Ir3QfZ+bgNx7qdJPkNllnOKoI0PsnwaYvyOMPrjRURHm0B1Nu/YFRqFnRIHw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oKcXtKsU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oKcXtKsU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 579F61F000FF;
	Thu,  8 Oct 2026 13:32:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791466371;
	bh=6xDYswg1nbwDfePk03v8tBhb0xFFEEgi2criwvSHk58=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=oKcXtKsUP6JoFdUKu71ecUUeEwuReRpeMboYuu1tXBT1d7V/nRUse3V7meESIXzec
	 G3ril++Xy27MQ6HkGLuT0cRrk65zsT+EQY1p4WDPFASgrVXlEKPKEoDQdZCFOXbm+2
	 PJV6ZH1rWNpVJhdsk8H7Tqn+/wZaCn8W35joRVUTJrAauE4YyXGgMD4APQn+p7vEru
	 GptzyBlwkb9xBY3BcdZ2mTXsjOF1wgSHMYG8VmW38vI/Yr4ioqD/e2DfgiVUwe/DCZ
	 hsXxG34Ia7GcHIDaFKPSKedVgY50cJ8vfJOEjU8OFD0Ro8nLPyK3Q6OTF8v2VGWpx0
	 ZsmtLVZU4pA2A==
From: Carlos Maiolino <cem@kernel.org>
To: linux-xfs@vger.kernel.org, Eric Sandeen <sandeen@redhat.com>
Cc: djwong@kernel.org
In-Reply-To: <20261002211038.2139655-1-sandeen@redhat.com>
References: <20261002211038.2139655-1-sandeen@redhat.com>
Subject: Re: [PATCH 0/3] xfs: more misc code deduplication
Message-Id: <179146636994.378461.12349981702908687550.b4-ty@kernel.org>
Date: Thu, 08 Oct 2026 15:32:49 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3

On Fri, 02 Oct 2026 16:08:08 -0500, Eric Sandeen wrote:
> Reduce more cut and paste.
> 
> These 3 are independent IIRC, so if anything gives anyone heartburn we
> can just drop the patch(es).
> 
>  libxfs/xfs_dir2_sf.c      |   68 +++++------
>  scrub/attr_repair.c       |   12 --
>  scrub/dir_repair.c        |   11 -
>  scrub/refcount.c          |   27 ----
>  scrub/refcount.h          |   56 +++++++++
>  scrub/refcount_repair.c   |    3
>  scrub/repair.c            |   16 ++
>  scrub/repair.h            |    1
>  scrub/rtrefcount.c        |  263 +-------------------------------------------
>  scrub/rtrefcount_repair.c |   39 ------
>  scrub/symlink_repair.c    |   11 -
>  11 files changed, 122 insertions(+), 385 deletions(-)
> 
> [...]

Applied to for-next, thanks!

[1/3] xfs: factor out xfs_dir2_sf_copy_entries helper
      commit: e029aeece84b0fe4f0aa6b1dd64c0c1c49281cde
[2/3] xfs: factor out xrep_reset_fork_to_extents helper for scrub/repair
      commit: 1e3f1adf6d533b503bc2356129bd7e27c199ad5b
[3/3] xfs: re-use refcount scrub/repair code for rtrefcount
      commit: 1d55a10278054fbebb9f571c99c32dac42327361

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>


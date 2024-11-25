Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E00E376E0
	for <linux-xfs@vger.kernel.org>; Mon, 25 Nov 2024 11:57:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732535865; cv=none; b=M+ioqROmdM2F3XX02dcV6JphauzalJS4CDU8VyH3QKSQPaJ0fFjoyWkZGUsu7EIB6nEdq6GgDAY03v8zH3Ql4YVVTgwCiNzP+Ruy9pNrWwnKnayQ8X1qJjM25Mt8c3CG3ipTeWrZqJ24RTzsVmSLDBEVEqfpaij9K2EFLgYJUw4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732535865; c=relaxed/simple;
	bh=PyvfKebFa/24tWJSlwnjq3YcubIgHzh7Pu1TY4YmnMs=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=drrm1nD97uEEETiTt2/z25+VB4MWbro8KkjLfAE66kjEWBJ9ren7G5m8rhc1WcHhsXBlieYXbjdA0A09N51dV6ntgcHLM+5cl3JeTimmIsNHgMLwvPRn1cn33kMGfjnsZuXYbmpyui74BH+tj1hR3MN9RuRKxyKm6gn/T4xhhB0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ojrP/oKP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ojrP/oKP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B124BC4CECF;
	Mon, 25 Nov 2024 11:57:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1732535865;
	bh=PyvfKebFa/24tWJSlwnjq3YcubIgHzh7Pu1TY4YmnMs=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
	b=ojrP/oKPfW6GhRyb2LZ2T9Uq9IgI//NH2gNM4MDJNRW40Bh/xrj379eX5cjO/nBQr
	 OV46wqJ9kcfGrOWClnSaPOsgyBZd8tSs6hm+7LFg9TGJ2wUeCuIycJ8dMTFjGCUyFa
	 yAGa5LC9rxvsxNz4r4oWgA3N1aDcc24TPnW1PYPW8+UZOR94a0yVAASYFtejc0XmSR
	 oWFkXFMx61jaC/8F9c53xsnchuxsahDgDORpPC3NqJ82FHabYV7lx8+yBDYHHlPjp0
	 FXPU4GhaQkjPKh4X37vx5dvbPA5BQVObvanIUnNaeoIlzFjpO23SWgTOG2RhhyEG1z
	 KMrkhq6fLKsXg==
From: Carlos Maiolino <cem@kernel.org>
To: djwong@kernel.org, chandanbabu@kernel.org, 
 Long Li <leo.lilong@huawei.com>
Cc: linux-xfs@vger.kernel.org, david@fromorbit.com, yi.zhang@huawei.com, 
 houtao1@huawei.com, yangerkun@huawei.com
In-Reply-To: <20240622082631.2661148-1-leo.lilong@huawei.com>
References: <20240622082631.2661148-1-leo.lilong@huawei.com>
Subject: Re: [PATCH] xfs: eliminate lockdep false positives in
 xfs_attr_shortform_list
Message-Id: <173253586143.514512.7602718203739773853.b4-ty@kernel.org>
Date: Mon, 25 Nov 2024 12:57:41 +0100
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.2

On Sat, 22 Jun 2024 16:26:31 +0800, Long Li wrote:
> xfs_attr_shortform_list() only called from a non-transactional context, it
> hold ilock before alloc memory and maybe trapped in memory reclaim. Since
> commit 204fae32d5f7("xfs: clean up remaining GFP_NOFS users") removed
> GFP_NOFS flag, lockdep warning will be report as [1]. Eliminate lockdep
> false positives by use __GFP_NOLOCKDEP to alloc memory
> in xfs_attr_shortform_list().
> 
> [...]

Applied to for-next, thanks!

[1/1] xfs: eliminate lockdep false positives in xfs_attr_shortform_list
      commit: 45f69d091bab64a332fe751da9829dcd136348fd

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>


Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 910791DFDB9
	for <linux-xfs@vger.kernel.org>; Sun, 27 Apr 2025 20:50:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745787022; cv=none; b=bDtnRU7wzAS740QBIKvG55/bKeETFXLF9Sw2ZSAv7ygRg771XmpuJE/lHiLm1+0l8/dq9kocfLgCPn0Y7/c5zD8KNloVujNhg8d/lauNZCqd1k0Yki1HaOWmb8NXpYtiy9fnnhNSWWt8OGINQunAPdi69/FY4IsIK4T3+tbXuJg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745787022; c=relaxed/simple;
	bh=IySfsG/Fon0rlcGAzIt0Y80/E514IZK3vTvQ6N8Lp4s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=m+rhCIzL0Wi40wyaiBy+Iwc92GYWYU1sXNmRDBwZJfye669CecaaVypljLTJjMu0dJYcnFuAgQSUZymlIuBtdWdEXunJcjf5haUH7IaHW+wtFp8iFc6J+CaOmc44VkuTCn+TruAdvum3lGJ6HDANrqklmP9+Ge6kxzfLyHU6/lE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=gbhRtubs; arc=none smtp.client-ip=91.218.175.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="gbhRtubs"
Date: Sun, 27 Apr 2025 16:50:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1745787007;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=DjaP+b4X34P31aw/uqok/yS3GcR1WDAXWGJx5LawSFw=;
	b=gbhRtubsr8dhX6Tb8BlH4xKRLQ/mQlxnmWIJkzzATi86vUmsAWzp3ML+CGxxgwWf2+OfyT
	Gx80UEI+IBB712adtpbS82uo4YSIFDouFwiy3Qx+MyVzgzJitkXBJqjeeee78VJJWm2jxY
	FRqdHR/aQTEJOvdk7/Bzq6BJv/m4MVo=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Fedor Pchelkin <pchelkin@ispras.ru>
Cc: linux-kernel@vger.kernel.org, Coly Li <colyli@kernel.org>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	Carlos Maiolino <cem@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	"Darrick J. Wong" <djwong@kernel.org>, linux-bcache@vger.kernel.org, linux-bcachefs@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org, lvc-project@linuxtesting.org
Subject: Re: [PATCH] sort.h: hoist cmp_int() into generic header file
Message-ID: <ztruxbvaatkgbngjr42twcpwmsowvpvlzxls6f576nzfqs7po2@ttzbexdvps3h>
References: <20250427201451.900730-1-pchelkin@ispras.ru>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250427201451.900730-1-pchelkin@ispras.ru>
X-Migadu-Flow: FLOW_OUT

On Sun, Apr 27, 2025 at 11:14:49PM +0300, Fedor Pchelkin wrote:
> Deduplicate the same functionality implemented in several places by
> moving the cmp_int() helper macro into linux/sort.h.
> 
> The macro performs a three-way comparison of the arguments mostly useful
> in different sorting strategies and algorithms.
> 
> Suggested-by: Darrick J. Wong <djwong@kernel.org>
> Signed-off-by: Fedor Pchelkin <pchelkin@ispras.ru>

Acked-by: Kent Overstreet <kent.overstreet@linux.dev>

Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E9844D5980
	for <linux-xfs@vger.kernel.org>; Mon,  5 Oct 2026 18:06:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791223597; cv=none; b=b1LRU1ECCz7kxfqQoo2Ckjnpa/6f6oXlKc5xcchGH4UxNpCLL/Ernz2Jyhmk/hi8JiwSEb7VanlSCm3b6c1QhaBzFOARqUeIH5+ujoDrbLICHyWh+we9ZU6iVKQUbaahD+E2nDltPjsHEATxjTCwau6KA35BCGXX7FttETdHcmE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791223597; c=relaxed/simple;
	bh=RW4Gw9QGGEJZxb+dfQV1cpfUbA/vDlqqAROybFjHnWU=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=tFqkTw+7wgzHDKFIRqwQr1W7oCsUBTOttnj4AKgNpR8jfmZvc+onoalY30SwJMUzdM81NN5wXVd/vhXwUqHrGGuQwyJqsDkMdl4D5Y+jQ4UmygD99xKM5YKfacvKvI6NOSjZJ0oXw3opV8zd/fA3PN4V/Ab2QFv8s+fRVmHBex8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cnfLzTry; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cnfLzTry"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D33091F000FF;
	Mon,  5 Oct 2026 18:06:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791223595;
	bh=sn+BCnP4KLlH14jKgfJeD/eaez85RqgXkqqZsav4GdE=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=cnfLzTryj/I65aLe3cQ9WS1L5pyl2Sl231iQ+tiXo8QSUhFM8WrDZp/5k+TyZkJGf
	 p4+hmRp2MLQO+B5jFWuL+acXi3USMX9XFm7q/zTS6oLqpPCAIGgtzs9etbVmthqw8g
	 OPgNS7t5JDy/JrIIHOmPebDAoB71w8WHaXlrzlSJCak+x6o3CrYKm4bOE9HPG8Ahxy
	 447puIFUh7aLkV4OAp0BIEo1wFuSj0ouziIgWcfsSkCWSztbwJ4Qqgkeps9iQSZoPI
	 JQny7UXLyLyu8mpEOa69Dc32Qx1ufFYDVfZM0VsdOTL8GyYaL/YMfctyk32xu6ilWV
	 yurOshHLG9KWg==
From: Carlos Maiolino <cem@kernel.org>
To: linux-xfs@vger.kernel.org, Eric Sandeen <sandeen@redhat.com>
Cc: hch@infradead.org, djwong@kernel.org
In-Reply-To: <20260922231845.3266784-1-sandeen@redhat.com>
References: <20260922231845.3266784-1-sandeen@redhat.com>
Subject: Re: [PATCH 0/2] xfs: share rmap & refcount btree ops
Message-Id: <179122359455.102066.16946334354898343076.b4-ty@kernel.org>
Date: Mon, 05 Oct 2026 20:06:34 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3

On Tue, 22 Sep 2026 18:17:07 -0500, Eric Sandeen wrote:
> The first patch should be what I sent before, just combinediff'd.
> 
> The second patch does the same for the refcount btrees as suggested.
> 
> I didn't keep prior RVBs since it's not the same patch any more...
> 
> This elimiates almost 250 LOC.
> 
> [...]

Applied to for-next, thanks!

[1/2] xfs: share the AG rmap btree with the rt rmap btree
      commit: 81caec1321282a29b40742c76188df9f31a00f7f
[2/2] xfs: share the AG refcount btree with the rt refcount btree
      commit: 8439f269aae2b37830b2a6af45f9b111a7856b17

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>


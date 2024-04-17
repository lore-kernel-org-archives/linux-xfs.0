Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C3A779C8
	for <linux-xfs@vger.kernel.org>; Wed, 17 Apr 2024 02:54:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713322449; cv=none; b=urmRDekMf+XOe+mSqtImghaLg4pyreKHM+OC3PhD4c9CbmqwyC37go/xwm4m+30Hx3vT1/LiqsGgxjTw3nJ/XvTUsafaKI1k8XWcQs9qCJu5r7MKZB1tH7NOoEvOK2Y32oGfaU08pj3MrNzUce11ZV0nJPUb1sgvkIGU1ZEx6tY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713322449; c=relaxed/simple;
	bh=NKWmWe1LxNlmmoYOSXV+nzo+8fsBBjkcUl53bBbU4jI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eIaa85veLGdhEdaswXBL3gXv/ITcZ51iCnbzLgwVsvHZZWMgl2KUCzL9q3XdR0n3e/nT5d9hACy0hs3u5EJ9sC8vzQrFLNXcAjDd2ORtZhlJU5hn2ep/zdTqyykIXmgdqY+OwcAg0m2SFNGLqxAkcuHy8QBTGVxxHD+IEfxkN2g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=inWUhfx3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="inWUhfx3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84111C2BD11;
	Wed, 17 Apr 2024 02:54:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713322448;
	bh=NKWmWe1LxNlmmoYOSXV+nzo+8fsBBjkcUl53bBbU4jI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=inWUhfx3MAEwm+mK3BrJTImGrfv85SUg5ImdfkpJQ5B90j/Qw/TB/QeWyx6uSX2qV
	 RfcAXB0f8+9o1WS/BkapNgvuHpXmpwAY2WAvg0oESgb9BMjG3I+I6XVOf38oRGNQqB
	 ZT24mEue440qnnIwJCOIXDUuqP2jDAyWBVGuyhp955/WS8E9q9BkXGfcm2zjzhOXkT
	 cSRFJm5sTXqjYigFSkHGmWJtU78P434KCcUEtCP6Smc5GYl6g7nXFDXcOHNWwHhomF
	 680J4TYHuaXrWS6n/Xff3ukZdeCVTh+rH9m9QtoETM1V7SJEgm1Xue9ZtV6SaXO4Oi
	 fGKP+5Yy/g14w==
Date: Tue, 16 Apr 2024 19:54:07 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: allison.henderson@oracle.com, linux-xfs@vger.kernel.org,
	catherine.hoang@oracle.com, hch@lst.de
Subject: Re: [PATCH 03/17] xfs: use xfs_attr_defer_parent for calling
 xfs_attr_set on pptrs
Message-ID: <20240417025407.GN11948@frogsfrogsfrogs>
References: <171323029141.253068.12138115574003345390.stgit@frogsfrogsfrogs>
 <171323029234.253068.15430807629732077593.stgit@frogsfrogsfrogs>
 <Zh4MtaGpyL0qf5Pa@infradead.org>
 <20240416160555.GI11948@frogsfrogsfrogs>
 <Zh6nGaPvk3tKf3gg@infradead.org>
 <20240416184110.GX11948@frogsfrogsfrogs>
 <Zh7IsJE1HJdzQSZJ@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zh7IsJE1HJdzQSZJ@infradead.org>

On Tue, Apr 16, 2024 at 11:51:28AM -0700, Christoph Hellwig wrote:
> This looks sensible to me.

Ok.  I merged the two functions in the patch where we introduce the new
pptr log op codes, because that made more sense to me:

https://lore.kernel.org/linux-xfs/20240417025208.GM11948@frogsfrogsfrogs/

--D

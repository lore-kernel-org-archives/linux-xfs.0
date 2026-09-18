Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A3A834C981;
	Fri, 18 Sep 2026 00:52:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789692776; cv=none; b=FcuqgfYLGCPNl5AU4JWdUmViW/SE7rA/72LcDh4tnxIQQBv5jUW5dtdQrWIvbwV2BegZzwHjYv6ezj0p0MRKwShCo3OC8ag19Q3v1TJ/kO/RRbnAzYmoBCxsc+GbkKkYt0EvtPSVFDEwpXcmt1vHNryJTLoD9vYSi6ydUA5C5XU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789692776; c=relaxed/simple;
	bh=vBMq0MlOelXMeviQviTVfGaqjcidlqdf5kQGPPj5w8Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PusZMen7Ux0ByJX/FTDKdzNOGvLkOloc00ysdGrisp+spdayFva+WoDm7ZHeoKyo0L7/NYr4NXfS8rlh7ExOiMN+YjtlPuyp8MprhkErzsF4kg6C9T8UObUma5TXBUJ2sjgApWM6EmAcSAoo1BbHp3/Cd/BTqOYLkuXPlGYFjrg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DFArFAIe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DFArFAIe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD20F1F00899;
	Fri, 18 Sep 2026 00:52:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789692775;
	bh=wFBb2/xVBWpM5TnPu9s92lWFyTBaAPmu3T7veyxvxaQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DFArFAIe+Pb5crGMYfHvi0nOVwLOXzvv2liLhCtVtNqe0xrqQ9z8fckcaCuN7IAbU
	 1I9mDD+y0Yxx10+Nm7Yy0gluqSqL/USBcnjJT+NoRFgCw5FEVjLZTy6yhjzFQ4RN3t
	 Tc7Wq7TVlZW5KliHU9Wl21xvZqsBL1P+S42eisaK1Lrozo252jV9mmBIZuB2T6jU8h
	 NRh9Z/7yXW3E+IKs818Lx1i73sHX3oaYUmM0EoQtA5YrZQuOjZxihthOEj8eGKkBSu
	 39ptb8wmUBhMc8JeT+oWpl1xIJFYGGK0NVbIIK1B1CNrzuH+bKcfwAx2FkYVMjJ2+i
	 TadQlfwsKxPlA==
From: Sasha Levin <sashal@kernel.org>
To: stable@vger.kernel.org,
	Christoph Hellwig <hch@infradead.org>,
	"Darrick J. Wong" <darrick.wong@oracle.com>,
	linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Dave Chinner <dchinner@redhat.com>
Cc: Sasha Levin <sashal@kernel.org>,
	Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	linux-kernel@vger.kernel.org,
	"Miguel Gazquez (Schneider Electric)" <miguel.gazquez@bootlin.com>
Subject: Re: [PATCH 5.10.y] iomap: iomap: fix memory corruption when recording errors during writeback
Date: Thu, 17 Sep 2026 20:52:33 -0400
Message-ID: <2026-09-17-daily-reply-0006-iomap-writeback-error@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260916-cve-2022-50406-v1-1-f4423f258ceb@bootlin.com>
References: <20260916-cve-2022-50406-v1-1-f4423f258ceb@bootlin.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> From: "Darrick J. Wong" <djwong@kernel.org>
>
> Every now and then I see this crash on arm64:
>
> Unable to handle kernel NULL pointer dereference at virtual address 00000000000000f8

Queued for 5.15 and 5.10, thanks. 5.15 carries the same bug and your
patch applies there as sent, so it went to both trees.

-- 
Thanks,
Sasha

Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6B5028EC60
	for <linux-xfs@vger.kernel.org>; Tue, 14 Jan 2025 10:30:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736850637; cv=none; b=ppV65g84ZuVsETthNNH8KZlHM4A64wQWPmOqU7+ebR3lBDdSm7fTvJQROTG4l2ev/S7KU0xKQS6mPwoPLVbuqpPFd8nCOO1pha6vhwdfWoP62sFUu/T6SchFdp5svp5TbXT/3iZqrdSgmaoMxZ4vhG31u4mjrk+s4xfU/cVGrqI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736850637; c=relaxed/simple;
	bh=UlmfS7fwthVjw7SsqTYz/zJhVS5DVKOeuUPWje8fjPs=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=nIUh3N1RlK4BxvKkon6Ak87LGXQh1WoDvS9LOGCjiGjomTiht0rwJrpTQ6vGF6m4GICEyrJONg5cp9cXlLA/GH0QRkTmv83+KWvXhq9D9ZNZqbIoNqkISC/fXikNpF60rrv7hw5l+WsN6HT3EtwB+0CzaQyOHz13EWUpryzN7Zk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=azZ3t1Z3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="azZ3t1Z3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D161C4CEE1;
	Tue, 14 Jan 2025 10:30:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1736850637;
	bh=UlmfS7fwthVjw7SsqTYz/zJhVS5DVKOeuUPWje8fjPs=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
	b=azZ3t1Z3wt1UDxl0gvJETNRULUXw4v7l63U/m+gnxkel1J1xw0rYym1JXd5fOCtFO
	 Bc/bN4WLOdAcGtTV12KNI+qV69HrPRJOZp/xL2EsfQ47zGwLjZlyTFVAjL3vfCYWMF
	 N1A627svupmQw9p6uswWKVJ1Axa16dJ5cyoCrmoMeZ0vjCrlvYx3cKD/IDBiPnMkQg
	 /ZF7hU8bDP9kws6aQZJXRoUXupAZUNjF+mxfF2llZuq473DJWqfe/Yb2zbOQJxKzkJ
	 wB8sqlkXOZoUIEEn4uBI2OcuvbN+tngX3g4oK3wHBLOhlpR0tCxYLxEjjpnfzo5M5O
	 srt4tow+7Y1ow==
From: Carlos Maiolino <cem@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: djwong@kernel.org, linux-xfs@vger.kernel.org
In-Reply-To: <20250113042626.2051997-1-hch@lst.de>
References: <20250113042626.2051997-1-hch@lst.de>
Subject: Re: [PATCH] xfs: fix the comment above xfs_discard_endio
Message-Id: <173685063628.121209.2863404878200088054.b4-ty@kernel.org>
Date: Tue, 14 Jan 2025 11:30:36 +0100
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.2

On Mon, 13 Jan 2025 05:26:26 +0100, Christoph Hellwig wrote:
> pagb_lock has been replaced with eb_lock.
> 
> 

Applied to for-next, thanks!

[1/1] xfs: fix the comment above xfs_discard_endio
      commit: f4752daf472b52a376f38243436c67b188a5eddf

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>


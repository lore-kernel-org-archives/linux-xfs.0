Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3F7D231832;
	Tue,  9 Jun 2026 07:26:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780989966; cv=none; b=rqngLCKj4/SA1E9Zwh3Oqn323721HNwWxFIZsI+96BtYZnMmOd20bNwJPX6ReqjTL1ttxwnO27G4hAxQ2S/7/tiuNGER5zXixF5pNbj9B/EbghqCryTXqmjN1HpOCs1AE/+nlOCNNo2BrzleSyRSFAYRgorV1+btoUxofrgrvi8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780989966; c=relaxed/simple;
	bh=dDnylOM/XcJtWCyDBF5mdy8WoN8XOvZXlk9cMUk25dE=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=uBlcUhj7sBNFKH3mBBN1Z+EqD1t6UMCRGYh1HEGegPVa4lBh4eUkQ3HTppl8MAzy9AdVJ42YNZ2CI6FIhTjOjc8QPtNDO2IgUWY3k+/7TLeSp2rT68w2vIKKv1KXRaIicLo4soz3dGYhgkfoEBPqEbAZW/r2wzblwL9ZfxgH4U4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gx5rz+50; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gx5rz+50"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6097C1F00893;
	Tue,  9 Jun 2026 07:26:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780989965;
	bh=CGwtmMLf4nCaY7DBB9s9IoDZ+kmcB1jT00rlHNgFpLs=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=gx5rz+50Y5jr9CURvsI5iqg4VRqZgkhX6RcAE/Ur8IIb+wlcB/Xjv7U0jjQ6OEatz
	 tV6TWQoVWfXVkTwxYIFcyvTbgWXK1r7zP5qkVKzC6hikL80HxP27ZIgjeS/Qle7TK5
	 67jc+SqJQ2WIx1Nif3O9h2P8T2FsbgAmfLX1X/U/V627RPgp2H3sn3AXQ1Lsn2hSMu
	 QInL9OReu5qHG4I5BNtz7qiD/FBPgQO2vKvxrp0sIiPrqjuDzEe5UQsy99gWPgA5hY
	 dJygf1bMggW6O+mJb/kBUuW1baVgVlqJEKvIqr8gfJ72Dn8nvw6mgBTmtOHqmQcB0Z
	 pB7Z4vxSF1/bw==
From: Carlos Maiolino <cem@kernel.org>
To: linux-xfs@vger.kernel.org, Yingjie Gao <gaoyingjie@uniontech.com>
Cc: djwong@kernel.org, stable@vger.kernel.org
In-Reply-To: <20260604120317.930273-2-gaoyingjie@uniontech.com>
References: <20260604120317.930273-2-gaoyingjie@uniontech.com>
Subject: Re: [PATCH 1/1] xfs: fix exchmaps reservation limit check
Message-Id: <178098996409.72840.14573836054642073297.b4-ty@b4>
Date: Tue, 09 Jun 2026 09:26:04 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15.2

On Thu, 04 Jun 2026 20:03:17 +0800, Yingjie Gao wrote:
> xfs_exchmaps_estimate_overhead() adds the bmbt and rmapbt
> overhead to a local resblks variable, but the final UINT_MAX
> check still tests req->resblks.  That is the reservation value
> from before the overhead was added.
> 
> The computed value is stored back in req->resblks and later passed
> to xfs_trans_alloc(), whose block reservation argument is unsigned
> int.  Check the computed reservation so the existing limit applies
> to the value that will be used.
> 
> [...]

Applied to for-next, thanks!

[1/1] xfs: fix exchmaps reservation limit check
      commit: 0a5213bbff62b51c7d4999ac8c7e11ea57d00d45

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>


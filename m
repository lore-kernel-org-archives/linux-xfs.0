Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EF1F13A252
	for <linux-xfs@vger.kernel.org>; Mon,  3 Jun 2024 19:53:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717444387; cv=none; b=r+4l9A5ctmg3aIrsG0ZIcKKSPbP81RSNEIl34qAc79bECQ6l+8BW21WbOeysrHy8LClreYUiFKz/rsJMXRtWRu7uK4Ksb+X+WB9jxwXN69o7k9KS8J9BU+8jDZlp1UEaQqxJ0/O1vRfB3GANcTDee/XDbpXRjQpKDklWmTXThVk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717444387; c=relaxed/simple;
	bh=BvG8Zu8brz098chYB5U5qiHmaI7CBHM/wvauHs7opKc=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=YWSYe3Mb8KDC68BdDX5QN8X5OwBMP7YHomPyXhzP9BOevKM5HGXRa59LEQAgbbkQYPprTxl53vzic/pI4XxfUCLUTaicWRNrlEi5R3bLNGLE+LzrVUz6/xMVZiNtv0E2RAfHxKmy0501Ic/A32xac3wWp1M1JZyg/dhiyYHuRw0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rfN9i9fB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rfN9i9fB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABFBAC2BD10;
	Mon,  3 Jun 2024 19:53:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717444386;
	bh=BvG8Zu8brz098chYB5U5qiHmaI7CBHM/wvauHs7opKc=;
	h=Date:From:To:Cc:Subject:From;
	b=rfN9i9fBKUeqH5ZZU7nESevgRn5PmrwWQR3A1WHLekG+8n5Tbkd2Vz19JnvkFJxIH
	 vs+l7RQfmPaCvpEkpproB35HBhI1cX+DAsAHia26snhCiCcyjHbJ8x0ko5ScvjrohK
	 hQZ5JmcejxTKmiJUyuH/YG+UepFghzxF6KfCjORax60MM3rMAItzuDbc3c/m6mv3TQ
	 5FPY4+4GnYpQhSN8MuoRR0PH0B49Olmt7htiWniXBPMCMV/vRP3XniwAs6hz5/g4s+
	 aycO76Hws8ALumLUaXXSMIsqOk9yRdZlRiUSzEJ5+H/jSrtnU5cRyi0xJjZDkJ7sdy
	 0H1YHwm208A7A==
Date: Mon, 3 Jun 2024 12:53:05 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: [GIT PULLBOMB v30.5] xfsprogs: catch us up to 6.9 (final)
Message-ID: <20240603195305.GE52987@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Carlos,

Please accept these pull requests for all the xfsprogs 6.9 patches that
have gone through review.  The only patch remaining from my stack is the
one about null pointers being passed to duration() in xfs_repair:

https://lore.kernel.org/linux-xfs/20240603161446.GA52987@frogsfrogsfrogs/T/#u

(Just thought I'd mention it since there's been a lot of noise today.)

--D

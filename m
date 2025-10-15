Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1150CEEDE
	for <linux-xfs@vger.kernel.org>; Wed, 15 Oct 2025 12:42:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760532123; cv=none; b=XrXAif6Om5YaoE3cIgCAnf4Wf8MZhcDSc0xk1fmo4QBP/USgSkmfpMw/v02NbyW4vl2nBczbmClCUM8dqGFb5dY/IyykbbLwo7hXL+ZDNF8f0tMmxmy4Z495DB0nm0tlyRpUqjG5eATfqrkOElUgE4JMI17Z2qFG9HZdddQar90=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760532123; c=relaxed/simple;
	bh=Tc8yRzsT9yxsgZq6Q6w8E79mtYuofvY+m7YG5cBJbf4=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=d0IHp4ezeRsp1NhglJUAauQxC7Yxq5iv5PUyhq6a2cFySVBAxE5QIxG6UlY31sX0A9NnQrNKAFWQNMSXTwCBQNdRrYu7wpVSKcdMJcmEg7jsxxSOvNkTsTGlw0lICI8KEUWkeHuJYk28GyvPVWb6LFEd0XeM4aR2isuJV/sTC3E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=j9v1E+mx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="j9v1E+mx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EEB8C4CEFE
	for <linux-xfs@vger.kernel.org>; Wed, 15 Oct 2025 12:42:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760532122;
	bh=Tc8yRzsT9yxsgZq6Q6w8E79mtYuofvY+m7YG5cBJbf4=;
	h=Date:From:To:Subject:From;
	b=j9v1E+mx731cWlkkUp15/HIEHCFi4VmNf13W7nMzk08g6Aus5OwwyFZYNoW5VjMEy
	 1SV2kOFt7fFXC0QmqwPp7Mz2UDbPAHuB1Of7VAPQ+ty60cEL8bS8XmS92ssp92rHNs
	 HJS8zWvVDLnG94WIi3H7Lw/mOSmiTdAKvLSnc0d3pn8WTLooS+3gOE4mIANpOC+cG7
	 qepBkbd1kLIJfpb1AMCQa/dSj4puvxTSQJAZehAO0HkCqt0O/4E4e38CKcesFXak+F
	 O6Dye+HAixBS9m3IeoJj5yZBxmy/qdH8SECgnhYQ3OYDMMuN1EIIRsHB2PVZo5SJzs
	 LQOUd6QzxiXKw==
Date: Wed, 15 Oct 2025 14:41:58 +0200
From: Carlos Maiolino <cem@kernel.org>
To: linux-xfs@vger.kernel.org
Subject: [ANNOUNCE] xfs-linux: for-next updated to 3a8660878839
Message-ID: <5rxujvudle5m5vtkr4toqgnyplfosi5pxhitwdf5et5tblhesz@sqddx3wnraml>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline



Hi folks,

The for-next branch of the xfs-linux repository at:

	git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git

has just been updated.

This just updates for-next for the 6.18 fixes cycle. No patches have
been added to the branch.

The new head of the for-next branch is commit:

3a8660878839 Linux 6.18-rc1

Carlos

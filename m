Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AACA99450
	for <linux-xfs@vger.kernel.org>; Wed,  2 Oct 2024 01:29:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727832563; cv=none; b=KY8Ti3hlVkSO0lJu1AtDCpOEmDLNhBXUmsZ9tCcK/gl1rlvXZwT/15yUlzcBBI3h4y3SRSxz/ouKHjCZCaxAvSeWVwAvZlRbadQfEEqOKP5aoSEJW7ZGvBURo9IEmvGzMo5ly6TdkebKOTwfYZy69AaS1xY/ERKCyia2YgAhx6k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727832563; c=relaxed/simple;
	bh=m+D3IpQOT8/FLzvDlyhBK4q5hJUAmGKsVrJ+ER00gMk=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=AQXOyaux5WYJhARxPeOnTd8ubgDQnjDVlJJqeNGb+nmTh1/00LWirY2hpSKqQRZ4b0OnOBSNKoQi9aydlbqIJu3iyA8OsfjPy4xG/XdOmRDnQBS//z1ApNRLISxiPFnh2W/3J7X49P9hAEv9bY/6BGlLslLGBdKeBrQHdModlvI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=imKjuX7C; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="imKjuX7C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 361F9C4CEC6;
	Wed,  2 Oct 2024 01:29:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727832563;
	bh=m+D3IpQOT8/FLzvDlyhBK4q5hJUAmGKsVrJ+ER00gMk=;
	h=Date:From:To:Cc:Subject:From;
	b=imKjuX7CfuWbtX3UnjuTCnOzRzoNd1u84t5bnXjX4PVSpovVBn8nTfwUZ1AU3MiR4
	 7P3Et5da3+YThwfe8UiNUYHsXYiZEYDZ8L538jdd8fGMNJlepptXTlIbOnMaC8T2RZ
	 bsmlBccwnyt7BM1lWTFO16Zvvl9EtRzHe/eEaFMy55qy0/ZkKEMQ8CVN4644WfnYFb
	 msnpDWqq8ReRxli/8ToJKl1TdPr/flq8Oa3WL9tZGqQdJthfJw1QdddTCnlZ/ESSBi
	 OYd8aZ3NeP37V8BMOANJrDEgAFn9a7rdZh6VXYdoo/+/IVgr3FsjUIQgnkoO196mh2
	 2wqhCmVCPzZ0Q==
Date: Tue, 1 Oct 2024 18:29:22 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Andrey Albershteyn <aalbersh@redhat.com>
Cc: linux-xfs@vger.kernel.org
Subject: [GIT PULLBOMB 6.11] xfsprogs: debian modernization and kick libattr
Message-ID: <20241002012922.GZ21853@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Andrey,

Please accept these pull requests containing bug fixes and cleanups for
xfsprogs 6.11.

--D


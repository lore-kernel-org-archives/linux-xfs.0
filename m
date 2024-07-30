Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5800757CB5
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jul 2024 03:36:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722310588; cv=none; b=XoMIJeaKYlz1kZEg1tVYSKAUzDen69elCPLZT8HN7fSzHmZl2CwbpiI60NNDZ61pnW7qTpUfJulYILLwDrrqLIkjg2q1MN4tQqsGOyGvBerSKZp1ajK0Aq11R8+cOG5mDv+pYsnMENCEiFzf8qntN789SpJ+KBEPsjQ8xXPVYjo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722310588; c=relaxed/simple;
	bh=fmc1Ai/FWbRx5YDFyONH0zCqrmL7DF/6gyTQKUYMmNg=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=cVpjZu1LRW8gK7M9TEYnX9XiB8rEsZ46yzHQmS1GIdSKhIglMfSeBE3N7LQAvQN3kgYMMrQw4EtWjKsYbUX2ER4FWOXFifRVVkgwDlI+rup1lFX9DUNb4H5TZMaOJ5Or5Dxcu3JskWHine8cY55V1yJMEk7OHrH4NW1ewK5viaw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=t58jtqAa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="t58jtqAa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16C77C32782
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jul 2024 03:36:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722310588;
	bh=fmc1Ai/FWbRx5YDFyONH0zCqrmL7DF/6gyTQKUYMmNg=;
	h=Date:From:To:Subject:From;
	b=t58jtqAayRdNGxCEMoLqwJRVP9nCEyayWZs9YVO0dlNMUwAZZ0YHC3sQLxuZc7xw5
	 2YtaDC1Es/H3K/5n0Iu8MNY1ohybRGFLYH5/vsrpm8Smn8W50q+gEqRBx0Z1WzoScV
	 H4ESkxXKr5zYxWDFcY9wWJKdSC+mTv1Sezg5TaqUL32akhDbPbC0ovZsvyci+8iugu
	 GKvH83f00lyMhygqQ19+ezmxnTw6bIUmi2wn+jwV5BwmBfzAoWlNEF0s9cc1/AF0nH
	 VTeb3X3fP96vzhX/SlKopeiqgx7KEaLpCEMpLJDKUTn9wRNUqV0QWVhVrmFXFSnRPZ
	 iUtSpQTPJ5PTg==
Date: Mon, 29 Jul 2024 20:36:27 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: xfs <linux-xfs@vger.kernel.org>
Subject: xfsprogs 6.9 .deb build broken on debian 12?
Message-ID: <20240730033627.GG6352@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi everyone,

Has anyone else tried to build xfsprogs 6.9 .deb packages on aarch64 on
Debian 12 (gcc 12.2.0)?  About midway through I get:

aarch64-linux-gnu-gcc: internal compiler error: Segmentation fault signal terminated program cc1
Please submit a full bug report, with preprocessed source (by using -freport-bug).
See <file:///usr/share/doc/gcc-12/README.Bugs> for instructions.

Will try harder in the morning to sort this out if I have time.
Strangely, the regular build completes just fine, so it's something
about the debuild options that mucks things up.

--D

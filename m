Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3904F4FA;
	Tue, 12 Mar 2024 14:57:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710255441; cv=none; b=stNU/NOQPWhmg2zT5U8z2vt9Xl5kA12oq3Gl/XaxEV2OQEm3oW47VnWPEwIYLksi/ufXEXbw+A6P+OjdrOEeg7vqIQxX3A+d7+nlj0HJYhQbo6EKQuO4mJ2QlEU+QqfVao9ODdLbcQezlMQuzqBDPwVLCaz4QtxLl8RENVnNFPI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710255441; c=relaxed/simple;
	bh=vjGJ0hUjyg8qHI9dl+ddYp47CGEOIPDPtMNzXJiz1Nk=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=CniFdAB2iHW45er67I4Oz/vqznJyKFtzv2v5mAvl7uRtbYfvwk76gR4506kLyeEeMQD2RmeuYDu3sp5eq+UAiljwkF01zbVNmBQ6CbKlXQQsufTDDAJdYc1A5nWWp5EWyqE36vx6XOIXz4et70FGE/6G2td8NZK23ChivRDgkVE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LhVXe7/s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LhVXe7/s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4471CC43390;
	Tue, 12 Mar 2024 14:57:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1710255441;
	bh=vjGJ0hUjyg8qHI9dl+ddYp47CGEOIPDPtMNzXJiz1Nk=;
	h=Date:From:To:Cc:Subject:From;
	b=LhVXe7/ss0XEXtuKkkiFZYk4GZx/79mqpUzaCig0DHKgvV6LLiNsS4JsYmF3Jm47X
	 /ZeZFDCP8bPPRE/ClFo+76TrI9cy9TlhAA7fYnVTeOusAbk7RX0+1tNCv7rsDju00d
	 uvQ9VPyhjkkQ23S1pGYPYemo9Y92zDmp0RBrKujlNLMRUefsvUG9ngiGnZW40xD+c3
	 O1oHJlc1HUKEcex+CTEYKqXg3zx4Cw3p4lnqSyWJ6QO1dFG6QHpCQEbocl8u7ooXyp
	 U5YPTi6/cm9O3Hq5s0lutLuzPOdIOcyXOkZpd8U3gq6uaRl4FIYxnaBIj3r9lVhxKu
	 umXRFNCIIjinw==
Date: Tue, 12 Mar 2024 07:57:20 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Eric Biggers <ebiggers@kernel.org>
Cc: fstests <fstests@vger.kernel.org>, xfs <linux-xfs@vger.kernel.org>,
	aalbersh@redhat.com, Zorro Lang <zlang@redhat.com>
Subject: [PATCH] generic/574: don't fail the test on intentional coredump
Message-ID: <20240312145720.GE6188@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

From: Darrick J. Wong <djwong@kernel.org>

Don't fail this test just because the mmap read of a corrupt verity file
causes xfs_io to segfault and then dump core.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/generic/574 |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tests/generic/574 b/tests/generic/574
index 067b3033a8..cb42baaa67 100755
--- a/tests/generic/574
+++ b/tests/generic/574
@@ -74,7 +74,8 @@ mread()
 	# shell instance from optimizing out the fork and directly exec'ing
 	# xfs_io.  The easiest way to do that is to append 'true' to the
 	# commands, so that xfs_io is no longer the last command the shell sees.
-	bash -c "trap '' SIGBUS; $XFS_IO_PROG -r $file \
+	# Don't let it write core files to the filesystem.
+	bash -c "trap '' SIGBUS; ulimit -c 0; $XFS_IO_PROG -r $file \
 		-c 'mmap -r 0 $map_len' \
 		-c 'mread -v $offset $length'; true"
 }

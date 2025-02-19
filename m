Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07D0A19D8A7;
	Wed, 19 Feb 2025 00:53:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739926408; cv=none; b=e2+b/1C9UJnsLg8NP50bBZGezb28Shu47xvCZlf3OdaC76HVrnY3s2E2VmarBDzVo+RXuRiUTeTD7ncT/WRfdGDIRBkEiS5nXR3U/d6YElKLKrxpJou5qgo74ZUdWWv54jM8NoPrw2fxZ3VpV9CxL/N1SMC5CD3Ee1W37NwklNs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739926408; c=relaxed/simple;
	bh=h1OGbNm7nRIdG2CY/b0Zw7vkylCSnQJzmadzjtDDx10=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qQgTuIVfGwyKCWfUXL/ikzq27A5SBjpvVVtSvG577tQxSXUUdTF9h2N6ufaNXgt3kOTk1Wc0fmVvGTLu6LFlzOq757F51oab+qU9OgpJ4n9nwFAdvxMEftTKP7Fyjds8XkMQjKVnAPnzd/oBXkPIRj61lh9qGm0kKznPjw99jBI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=L6RLtW4+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="L6RLtW4+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5823C4CEE2;
	Wed, 19 Feb 2025 00:53:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739926407;
	bh=h1OGbNm7nRIdG2CY/b0Zw7vkylCSnQJzmadzjtDDx10=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=L6RLtW4+X3eggXBhFKaxTrL6J5yvFde4BX//2RJbdzfqaTnJg6hdnAVs7H2PhuNBz
	 wKN6YcM2KP8Bt+OZ2fT81TADSwp2Qz5iLmcn8R3m6bTE8SsphpKXpv6A8L8XBj8uS3
	 f88VWg6qmeyYHm93MdeUugbhi2rdl0DukXRT/l6ZCGsvz2ri7elZ6sH9QP69WQciWE
	 R9gkg/2QU4UXuWzLw2YHbpfFmD4ZZd3plmvQBk0kdfMcSkW5iPDG98ZJdFZ3iLLzDM
	 qKevKl/gt1eN7VC4Jn+GDeWxbjgL7AZpWdbBfPu8U94ahKrWTicMHTNzMLZgTPubjX
	 6356m46NUgaCg==
Date: Tue, 18 Feb 2025 16:53:27 -0800
Subject: [PATCH 12/12] xfs/349: reclassify this test as not dangerous
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Message-ID: <173992587625.4078254.2974311211127532100.stgit@frogsfrogsfrogs>
In-Reply-To: <173992587345.4078254.10329522794097667782.stgit@frogsfrogsfrogs>
References: <173992587345.4078254.10329522794097667782.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

This test creates a filesystem with all known types of metadata.  It
doesn't fuzz anything, nor does it actually repair anything.  Hence we
can put it in the auto group and drop the dangerous tags.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 tests/xfs/349 |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)


diff --git a/tests/xfs/349 b/tests/xfs/349
index 3937b4fdbffe93..a68bfee579ac41 100755
--- a/tests/xfs/349
+++ b/tests/xfs/349
@@ -5,10 +5,9 @@
 # FS QA Test No. 349
 #
 # Populate a XFS filesystem and ensure that scrub and repair are happy.
-# Use xfs_repair to fix the corruption.
 #
 . ./common/preamble
-_begin_fstest dangerous_fuzzers scrub
+_begin_fstest auto scrub
 
 _register_cleanup "_cleanup" BUS
 


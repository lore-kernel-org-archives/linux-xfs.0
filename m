Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 075925101A;
	Thu, 20 Jun 2024 20:57:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718917048; cv=none; b=WLby0XOruytktWof/xHL362U+JrsMvT5wSMrw0xcrZ4+voRsWq3snJsM1jZkr1ARp4H/+tcE3q40TlpqTWMzCtM3E9eLJzkGL+aNiC3t/4dIPoP3cAwxFb+B56GNTLAVSrQuKrAUU+5f9bhQ6033BP2GDoUydu7WRQLXwfMMmUE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718917048; c=relaxed/simple;
	bh=Uir+bDK0KDidrTaKErbe7nydLaFH+vzal8goirXvNtU=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UMZva93ugmDjEymTKUg14+pR60DwJkmkLBw0PSbB+J47s4BxnCLqAAgdCcLxhFNESau73M5udjEz7VqsU295N5mIra7roUyUPuMJ/MJJ46YmkiO4yj2KmTknnC+jghGYKS8rbfsH5zt+MqbroPpxrMyDbIrKT4ACDozl5Y0TQwc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XEjEEFUF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XEjEEFUF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 815C5C2BD10;
	Thu, 20 Jun 2024 20:57:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718917047;
	bh=Uir+bDK0KDidrTaKErbe7nydLaFH+vzal8goirXvNtU=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=XEjEEFUFaCTymGHoBRV2jexsUfu5rC1IvVsWEJfgVii+m4omORM87UfMwCY8u2+HI
	 tdUHofBMGHbGxVgmeuqM3X7b6ewARmxzAFh5UGyFElv2L6Z8rR8a2ZibfYGKPd5R3o
	 LeV+wRb0JxfWfFA5n+9hvYFbzymB1SiWB6udyz8lIbUb3uwRS2QdkXNdD/Ik99gcKr
	 au4ZP5t2+ayVfQ9p2Xr4nYteJ7xLWsCWd0gkyQEBwxWYD9qDfrLMq65BarxUQjf4T0
	 4YT0ZFAJBw0/iYIo8BESARl7ClibNl4JDMYNqoq1eoVdLveu2OLFXKN9rB/4zK1cFB
	 rUbL8BN8Qwp+g==
Date: Thu, 20 Jun 2024 13:57:27 -0700
Subject: [PATCH 02/11] xfs/206: filter out the parent= status from mkfs
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, zlang@redhat.com
Cc: Christoph Hellwig <hch@lst.de>, fstests@vger.kernel.org,
 allison.henderson@oracle.com, catherine.hoang@oracle.com,
 linux-xfs@vger.kernel.org
Message-ID: <171891669671.3035255.18167512263690234854.stgit@frogsfrogsfrogs>
In-Reply-To: <171891669626.3035255.15795876594098866722.stgit@frogsfrogsfrogs>
References: <171891669626.3035255.15795876594098866722.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Filter out the parent pointer bits from the mkfs output so that we don't
cause a regression in this test.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 tests/xfs/206 |    1 +
 1 file changed, 1 insertion(+)


diff --git a/tests/xfs/206 b/tests/xfs/206
index f973980eb2..d81fe19857 100755
--- a/tests/xfs/206
+++ b/tests/xfs/206
@@ -65,6 +65,7 @@ mkfs_filter()
 	    -e "s/, lazy-count=[0-9]//" \
 	    -e "/.*crc=/d" \
 	    -e "/exchange=/d" \
+	    -e 's/, parent=[01]//' \
 	    -e "/^Default configuration/d"
 }
 


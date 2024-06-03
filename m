Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEB4D131182;
	Mon,  3 Jun 2024 20:12:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717445548; cv=none; b=htoip/eVw0gu+mFmmeXPe63Xf8SOdj4cmuL8t5HvcDMLAxoPIb/YdEpuMdoEpuEKpvaUrIOGJfyj74/yJBzH48Q80/X5+5UoxM8XaXyQ/p2L+nYw4F+9tZh+zn7W1PaOdCrxK6lanUCFzn8f82K6jDFhAIoqvLEPTxCz7NgddxM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717445548; c=relaxed/simple;
	bh=fUsm2LMfQNj0Sw9zCoa7Eura6b/uc6scSFcOQeaeVUk=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=I1ogRJ7VpS6BryyINV44v0HZsueh7RFoVtNhR9Ub9Yw5C+SgRI/M/o6Wg2N3bJPChj9tkpdBHXIDKhTyrKF1SukKJSooCW2JonTsi5xJRwZxVC5Q8XOtqVRvAlcsFg+N+7Fs94AXCdwDlZjiz7JYOVXmBlG8A0P5KCVOS3B+nb0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aMLUSyUW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aMLUSyUW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6D11C2BD10;
	Mon,  3 Jun 2024 20:12:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717445547;
	bh=fUsm2LMfQNj0Sw9zCoa7Eura6b/uc6scSFcOQeaeVUk=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=aMLUSyUWLUy6KET2+PKmf9YwAWeuQpkTIbF+c4+3RfEtVpWSEqUsyKw1Rwu3ON45N
	 SSQSY0jmT6j0cfd/GTAUdHylUa5yjFyqmyueACdpv7s6RMi9Hw+m1SkwKO8dyuRDlx
	 7MzTtWLDboE9ZQHcTp6+1FGVZcwQaVkHn8kWnjMP7j5X8yUVMcxfKx7d+98/TK1T5M
	 OxeIk/2XPLGmnVxzuqiBbczQO+LReG83iXW13Ue/sLgpmTILwtH22+jHOiSYzfpTzA
	 vsOkNMUILP+dImhAykIC8uXROkXMXwnOZxPfR+7ZRFmiIXIlRyXgcpws0OB8AnDn/Y
	 m50B3YbdGZQjA==
Date: Mon, 03 Jun 2024 13:12:27 -0700
Subject: [PATCH 1/3] fuzzy: mask off a few more inode fields from the fuzz
 tests
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, zlang@redhat.com
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org, guan@eryu.me
Message-ID: <171744525438.1532034.2611558250304665559.stgit@frogsfrogsfrogs>
In-Reply-To: <171744525419.1532034.11916603461335062550.stgit@frogsfrogsfrogs>
References: <171744525419.1532034.11916603461335062550.stgit@frogsfrogsfrogs>
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

XFS doesn't do any validation for filestreams, so don't waste time
fuzzing that.  Exclude the bigtime flag, since we already have inode
timestamps on the no-fuzz list.  Exclude the warning counters, since
they're defunct now.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 common/fuzzy |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)


diff --git a/common/fuzzy b/common/fuzzy
index 218fe16543..c07f461b61 100644
--- a/common/fuzzy
+++ b/common/fuzzy
@@ -122,7 +122,11 @@ __filter_unvalidated_xfs_db_fields() {
 	    -e '/^entries.*secure/d' \
 	    -e '/^a.sfattr.list.*value/d' \
 	    -e '/^a.sfattr.list.*root/d' \
-	    -e '/^a.sfattr.list.*secure/d'
+	    -e '/^a.sfattr.list.*secure/d' \
+	    -e '/^core.filestream/d' \
+	    -e '/^v3.bigtime/d' \
+	    -e '/\.rtbwarns/d' \
+	    -e '/\.[ib]warns/d'
 }
 
 # Filter the xfs_db print command's field debug information


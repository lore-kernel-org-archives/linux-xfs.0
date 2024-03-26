Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 610F8128816
	for <linux-xfs@vger.kernel.org>; Tue, 26 Mar 2024 03:23:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711423392; cv=none; b=N3oI3HUK2USaH1alVOeLlew9XQrX6P5JIVGGRSQFXFSpaTj7mX7cdoW55BPNLy6EQ628IkeX1r4j7io3uh7k17G9Kxeskeamai7gmRRDcYvYc6aLvwOITfTQU8B0ooW5JIzFHVsEchg1dFz0K9zHNAbZ6C1e03QbFPexKZkjkDg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711423392; c=relaxed/simple;
	bh=Iqcebc1wg3TwlChA52G5Ft11StqtgqKqGPevfCC46Mg=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=p18d9NhSJX2xYiWNBT/qvQWQBeEB6gYDy0RM0NBkeJQLXO28Th2hmVfhBivcFLhk9phA/o9UZSERv6I6fOqiwXDeMvuOMFIXp+R0Bx/+LAl0j7UplRcSSZr+tRFRMo9rHKhV9W27BkDuiOQGwLSrAmTPrVPEy0QkncrZiBSAX84=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IZdxvwHQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IZdxvwHQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB587C433F1;
	Tue, 26 Mar 2024 03:23:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711423391;
	bh=Iqcebc1wg3TwlChA52G5Ft11StqtgqKqGPevfCC46Mg=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=IZdxvwHQN650LZST+D2JzztkMPh8273FMrHSieo4jdRWdY0buSv0a/GMhyl5WXU30
	 eq+sNywLGi+AC24oqp9mxBmV2EaZaULknuJ4PQduxq3eopJwjw2YcevjwipuyTo77s
	 MUvjXKYj+NP9IlG8Iz8s3hi/4GRmcYc++4zVoa28KH2HvDZSKMe+uhamWgpSX7n2aT
	 1q3OeN9jwlELnEtwVb3MScMgRcsdh7dff3Z0iyQE1jXxCY64+xmLQvUBA0CQpClIb/
	 NMtjym0cvVUXT2EnFMacd4WuWNaOwwvqCM1LgOybS8/dSJR3WBNVxIDEoHaeBh4F5Y
	 CPofsX87Epbgw==
Date: Mon, 25 Mar 2024 20:23:11 -0700
Subject: [PATCH 4/5] libxfs: also query log device topology in get_topology
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Dave Chinner <dchinner@redhat.com>,
 linux-xfs@vger.kernel.org
Message-ID: <171142129002.2214261.1578688776675671438.stgit@frogsfrogsfrogs>
In-Reply-To: <171142128939.2214261.1337637583612320969.stgit@frogsfrogsfrogs>
References: <171142128939.2214261.1337637583612320969.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Christoph Hellwig <hch@lst.de>

Also query the log device topology in get_topology, which we'll need
in mkfs in a bit.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/topology.c |    1 +
 libxfs/topology.h |    1 +
 2 files changed, 2 insertions(+)


diff --git a/libxfs/topology.c b/libxfs/topology.c
index 706eed022767..94adb5be7bdc 100644
--- a/libxfs/topology.c
+++ b/libxfs/topology.c
@@ -292,4 +292,5 @@ get_topology(
 {
 	get_device_topology(&xi->data, &ft->data, force_overwrite);
 	get_device_topology(&xi->rt, &ft->rt, force_overwrite);
+	get_device_topology(&xi->log, &ft->log, force_overwrite);
 }
diff --git a/libxfs/topology.h b/libxfs/topology.h
index ba0c8f6696a7..fa0a23b77386 100644
--- a/libxfs/topology.h
+++ b/libxfs/topology.h
@@ -20,6 +20,7 @@ struct device_topology {
 struct fs_topology {
 	struct device_topology	data;
 	struct device_topology	rt;
+	struct device_topology	log;
 };
 
 void


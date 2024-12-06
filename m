Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22BBF14D717
	for <linux-xfs@vger.kernel.org>; Fri,  6 Dec 2024 23:41:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733528489; cv=none; b=Zv6G/BHJ/ugfIEzHz/F0pN1qODfO19vt5lASCUKA/DmRM9zynWU3IywuxB6Jm4p2JRUYLtYaJAop5cI6D4Y09s+X9dOzUqv3L3NOIHPyWRsTdzjDEebuUw2eX7pWeREGOY2pdQf0LaQhcbjc9kvZyorEyxJO2ek2KYgdWS1iIxs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733528489; c=relaxed/simple;
	bh=E8f04RZHoYDBPu3ARima3VtgSFwHY19ARzv6vg8A7wE=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=W2rMvBZgtKivslOmYMNCxuOPdmAe6PvTPUyx2AYSNxHNIw6fTdQbvyT0MdDo60YLut3JK9RbpZ436k+ub/rY5Rjaavj1GxJul+w3hufl3QAh3KFZSTmRrq8j+oEuB4eIYgUAvkCadMrmCNbXpiz1J4674MvdrKDSAb5BlpDkqFk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZHEwKnCo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZHEwKnCo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E47BC4CED1;
	Fri,  6 Dec 2024 23:41:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733528488;
	bh=E8f04RZHoYDBPu3ARima3VtgSFwHY19ARzv6vg8A7wE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=ZHEwKnCojzaP5zUPAciV6CTmYSPKCOjkhV9S7n1+qQOQDGu6gPGsZw1M9y86ljPUf
	 GRF5C1LQyOS8VRQ762AFS8jniAx+CQTSq0kLXndXFc/aJKqtIoCmXsidxWJ0J3UCDA
	 2LairYFjprfPLJbUX3//gqvY9usmvSYt8rfhJspIN0w2Tc+lt+wLbGZf0bws/3GHKn
	 Gvkz0pELprAM2GMdvnij8OorPjOEh9ojlGnIa+Q+JUT1FcFxBVXvvkQwQAb377UGJV
	 7o/KuqK1odaWg8NG3XhOEujH7Whmlc1MUVV3KNAV6afzk7pwvIyIwwqOyckm8oC9sj
	 hBY+3UQw8EbKA==
Date: Fri, 06 Dec 2024 15:41:28 -0800
Subject: [PATCH 07/41] libfrog: allow METADIR in xfrog_bulkstat_single5
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173352748346.122992.7654454749259242564.stgit@frogsfrogsfrogs>
In-Reply-To: <173352748177.122992.6670592331667391166.stgit@frogsfrogsfrogs>
References: <173352748177.122992.6670592331667391166.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

This is a valid flag for a single-file bulkstat, so add that to the
filter.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 libfrog/bulkstat.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)


diff --git a/libfrog/bulkstat.c b/libfrog/bulkstat.c
index c863bcb6bf89b8..6eceef2a8fa6b9 100644
--- a/libfrog/bulkstat.c
+++ b/libfrog/bulkstat.c
@@ -53,7 +53,8 @@ xfrog_bulkstat_single5(
 	struct xfs_bulkstat_req		*req;
 	int				ret;
 
-	if (flags & ~(XFS_BULK_IREQ_SPECIAL | XFS_BULK_IREQ_NREXT64))
+	if (flags & ~(XFS_BULK_IREQ_SPECIAL | XFS_BULK_IREQ_NREXT64 |
+		      XFS_BULK_IREQ_METADIR))
 		return -EINVAL;
 
 	if (xfd->fsgeom.flags & XFS_FSOP_GEOM_FLAGS_NREXT64)


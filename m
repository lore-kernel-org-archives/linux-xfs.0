Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F5F123C380
	for <linux-xfs@vger.kernel.org>; Thu,  6 Feb 2025 22:33:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738881213; cv=none; b=OEqjDyHQeuw9S2ZE6hu8ME6cvCOq/PtrJfE6kjDcofkmI2soZUQoZ7ouM+cBPjpSTkcHJ664o/Wtld8e6GLViK0kPBAvPyCVZwMxtZGt22fpYNLjW2YC3nalOotD4RSeFSV/UoiYKaUUXdZyeDRvvZ05vXsfmd8WU8tbNHzxavk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738881213; c=relaxed/simple;
	bh=P92t2ZOWqqm/hYmNlwwKrEbbLTc7CzU5KXRl09Kvwg4=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=F/9Fwf63SlKJ2157OCKJL0zDVItDZpOaZBwRasee9IFFffW94pyT08lpFX+uHZDUelnFjOxax4/GUjLXnKiKhaLRE8CeTNTEwQzH7zuDq0i2jkl3SWt8yGUoqetjUCRW05IpLj6wXvQGDAOwQL8VSI+sGtFVuRbzR67rTPH73KE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jhI+um56; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jhI+um56"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73CD5C4CEDD;
	Thu,  6 Feb 2025 22:33:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738881213;
	bh=P92t2ZOWqqm/hYmNlwwKrEbbLTc7CzU5KXRl09Kvwg4=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=jhI+um56zYi8QXK0xFnYqceI9fOA1FM2VX4A0m7Fn+lY/Qh+eXMwlHYXRpO6z34g3
	 qsa0jnI28B3QOTnx45rQN8sicpJg5Z62oZbsASDxTJR17Py52wuTXOktOTDGDrfjQX
	 jrcPasqaC4Vc+l4/mfA3KxmPgMlIjOM682J9fUe2vOFItzRVx8a4KSqIrR9bdd/j09
	 IvhvS+9J6YvhWH/0RVRwm48pOeCZ/MzUR5N5A/d0XY08fcGfpu0JyYtNLkLSsOyocy
	 YDLkAd2tPQnK/wvFcX1QH2kQ6FRu6OQLqYzRJmqrvPWZ7TGAmRS0f/tEiGj3dEXNlV
	 KFODfalHTmcjw==
Date: Thu, 06 Feb 2025 14:33:33 -0800
Subject: [PATCH 11/17] xfs_scrub: don't (re)set the bulkstat request icount
 incorrectly
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173888086229.2738568.17046030028284704437.stgit@frogsfrogsfrogs>
In-Reply-To: <173888086034.2738568.15125078367450007162.stgit@frogsfrogsfrogs>
References: <173888086034.2738568.15125078367450007162.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Don't change the bulkstat request icount in bulkstat_for_inumbers
because alloc_ichunk already set it to LIBFROG_BULKSTAT_CHUNKSIZE.
Lowering it to xi_alloccount here means that we can miss inodes at the
end of the inumbers chunk if any are allocated to the same inobt record
after the inumbers call but before the bulkstat call.

Cc: <linux-xfs@vger.kernel.org> # v5.3.0
Fixes: e3724c8b82a320 ("xfs_scrub: refactor xfs_iterate_inodes_range_check")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 scrub/inodes.c |    1 -
 1 file changed, 1 deletion(-)


diff --git a/scrub/inodes.c b/scrub/inodes.c
index a7ea24615e9255..4e4408f9ff2256 100644
--- a/scrub/inodes.c
+++ b/scrub/inodes.c
@@ -66,7 +66,6 @@ bulkstat_for_inumbers(
 
 	/* First we try regular bulkstat, for speed. */
 	breq->hdr.ino = inumbers->xi_startino;
-	breq->hdr.icount = inumbers->xi_alloccount;
 	error = -xfrog_bulkstat(&ctx->mnt, breq);
 	if (error) {
 		char	errbuf[DESCR_BUFSZ];


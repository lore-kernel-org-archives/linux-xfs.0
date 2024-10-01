Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A7A31C6889;
	Tue,  1 Oct 2024 16:49:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727801368; cv=none; b=fR3X0GcImjbecIPzFdCkzRwEk87c5hUvTdCfYagxrbYH8AM6Gg4qSCkl/B6Lf2WedOvinNeNkQOOsj3XH1mILB9G+ARZjXeCfHDFzpDUknrbn+GWkMqWEySzepVg4BLfyzNiM53D/DCGrDH/t9Dwd7x1t1rBgJo2wVdpajHvUms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727801368; c=relaxed/simple;
	bh=qlrkGjsadYzZFRgJBOj7gSa9KDzacGVy42j3Bh0gE0o=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AjpEO3/MPz+DCvyyucEDsD/BM8l1Ftj0IhTlFjZhBLXDNIRUNTVWkG94lJgx7y0d/RGOBQQTTsGEIjI1QJ6IlnC9PUEpiqqVNI67HN/swKoHfaa5LSGPqPJl7IHJx1+CDsC0H4Kj5TH9+5Wz4q/nIAD4x/BZJ95OqSe3n/k7ZWQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lGDwNgSE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lGDwNgSE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2552C4CEC7;
	Tue,  1 Oct 2024 16:49:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727801367;
	bh=qlrkGjsadYzZFRgJBOj7gSa9KDzacGVy42j3Bh0gE0o=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=lGDwNgSEHvqsYO1LfYHiQ0tr6vZ2qcoiMOpVOHmxb0ZJ6ttUBn8g3WktUnxfobdWZ
	 S8qxZZWfbDy61r8/r6IvXZzIdyCF21Akh6Cv01EAIE+mm/2o5P4yLb73t1xs0cVLyY
	 VJo30R6OMgXKo/Ph1TsJ3n6IixpV9lZ2F0qFn5AozOx9FT+UGNbwBPOey4PelELUhd
	 HrQYKv2gLVrfANXIAIxliwef1uIpDFz58vrvvqf5imZlGaTrObmTswuhsX2DUgdvf4
	 ODBjlwUJlAPxFfmJPJ/BEyLZlnV+OFIJgVKq9c4Bi+BBa1xqpRg4rxudZGHaQly9ve
	 lpT5C8t7W5tRw==
Date: Tue, 01 Oct 2024 09:49:27 -0700
Subject: [PATCH 2/2] xfs/122: add tests for commitrange structures
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <172780126049.3586479.7813790327650448381.stgit@frogsfrogsfrogs>
In-Reply-To: <172780126017.3586479.18209378224774919872.stgit@frogsfrogsfrogs>
References: <172780126017.3586479.18209378224774919872.stgit@frogsfrogsfrogs>
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

Update this test to check the ioctl structure for XFS_IOC_COMMIT_RANGE.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/xfs/122.out |    1 +
 1 file changed, 1 insertion(+)


diff --git a/tests/xfs/122.out b/tests/xfs/122.out
index 60d8294551..4dc7d7d0a3 100644
--- a/tests/xfs/122.out
+++ b/tests/xfs/122.out
@@ -76,6 +76,7 @@ sizeof(struct xfs_bulk_ireq) = 64
 sizeof(struct xfs_bulkstat) = 192
 sizeof(struct xfs_bulkstat_req) = 64
 sizeof(struct xfs_clone_args) = 32
+sizeof(struct xfs_commit_range) = 88
 sizeof(struct xfs_cud_log_format) = 16
 sizeof(struct xfs_cui_log_format) = 16
 sizeof(struct xfs_da3_blkinfo) = 56


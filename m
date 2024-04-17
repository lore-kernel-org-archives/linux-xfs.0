Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7A97171A1
	for <linux-xfs@vger.kernel.org>; Wed, 17 Apr 2024 21:41:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713390082; cv=none; b=MShv89m7fvcuOYJTmIU0b1Q+9NYcuMBb2SOF2cNBcmA+ZrbYF0r9gB1OMaOEdNIphR9wUtgboprJ5bzFom9eSiSqfo8re6pK6FFI126t5dxqvx+UebZ4VLsyVuipqKM/1S2ryU4+t8brLvfYpfN6dnZ9l1qxtEgD2CMioPVclb4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713390082; c=relaxed/simple;
	bh=ALc+MNU+1JicwYBXCv9eGxvlhAQFgS9/F8w8Id6p5kQ=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CeEB9IgIH0gTg4vItqxnNUPob5aG4UUuOekOycNtC9J3RAKfQSM9zFVxmQCe7wHkDca1jTjwdAnmYYn34nRyqaEC5PUfk0MsaMQtHCct40/GJLQ3XNCdr4gdaNy+qGjEjh2ebDTY57E8RUDhwOuXnZqoM8hrmN2MuESwrUImF6A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kWRgcw3d; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kWRgcw3d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 746ACC072AA;
	Wed, 17 Apr 2024 21:41:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713390081;
	bh=ALc+MNU+1JicwYBXCv9eGxvlhAQFgS9/F8w8Id6p5kQ=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=kWRgcw3delegOzWfivrZzyrvd0uXJI6JPCfnHozbwILajDd/rSdfRoswP7Ath4/P1
	 e/OnKqLyyEtbhRH3uhue+usda0P2LtUE/N2iHU0NDVFRjKWuW8PhnYW64QIL0N+YZ8
	 Z3Fe1OB70ZELojoJf3/oxnYk95yjOch8mCH2gqHeVt8jHeMDkLgI25kQZg39EKyc18
	 Qzir6J0T4nzG3S/+DfsR9Qyg6/Hjtj2wR0zw5C/doNJE/2xXDYZs0eGaNNt0BsSwlX
	 dCwkELqtrRcJtfC6fTmnlH0dySoJw+66P3/SqKfmW+s7vYxto3OO9jghjidGI/iXxs
	 R9qZRSVDVoDHg==
Date: Wed, 17 Apr 2024 14:41:21 -0700
Subject: [PATCH 1/5] libxfs: remove the unused fs_topology_t typedef
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Dave Chinner <dchinner@redhat.com>,
 linux-xfs@vger.kernel.org
Message-ID: <171338844379.1856006.13008239553037353433.stgit@frogsfrogsfrogs>
In-Reply-To: <171338844360.1856006.17588513250040281653.stgit@frogsfrogsfrogs>
References: <171338844360.1856006.17588513250040281653.stgit@frogsfrogsfrogs>
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

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/topology.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)


diff --git a/libxfs/topology.h b/libxfs/topology.h
index 1af5b0549..3a309a4da 100644
--- a/libxfs/topology.h
+++ b/libxfs/topology.h
@@ -10,13 +10,13 @@
 /*
  * Device topology information.
  */
-typedef struct fs_topology {
+struct fs_topology {
 	int	dsunit;		/* stripe unit - data subvolume */
 	int	dswidth;	/* stripe width - data subvolume */
 	int	rtswidth;	/* stripe width - rt subvolume */
 	int	lsectorsize;	/* logical sector size &*/
 	int	psectorsize;	/* physical sector size */
-} fs_topology_t;
+};
 
 void
 get_topology(


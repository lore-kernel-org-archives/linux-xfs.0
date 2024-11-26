Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61370C2C6;
	Tue, 26 Nov 2024 01:24:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732584252; cv=none; b=Rvb33aa7pfHskktRAIVJtWAKr0dQSyXfQbqXllfzwpgOa5OkNyHFC5OUNtIhD3PZqPwTD8xD27wgEOD03usenttJm/UtZ238UbQf+kCgbzH0eCak1AosjKogj5YC51LeW3WPlcD04nn3aUTU/n8cY2aOanu5nlEvvpCv8n41NlQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732584252; c=relaxed/simple;
	bh=WG7sUTwQ9t+ufnDveKwxHDjJiotO1YF+NtJBqip96lc=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=U7kZb4M6g8FhpvK4tH3GD4mdEC0UgOLaKoLBOdIPpDx7aZ6DvovDbtmw8XlqF7lAVXfG1olOIf6lilqXf3DxkdtgoS8pFJarJDCA7H25Z24r8Fa0LcfmNULlQIuxghsYVwPAhl8wTi7PIhjQdqvNGIW6OmkYyWq53W1LpoIsf0I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lWuBh2nI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lWuBh2nI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 390C4C4CECE;
	Tue, 26 Nov 2024 01:24:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1732584252;
	bh=WG7sUTwQ9t+ufnDveKwxHDjJiotO1YF+NtJBqip96lc=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=lWuBh2nIKrcYb9hfx746w9tvZ+G2y4VRzoq3pJpDeuyHkmRdNJOXD832x4KYZ0eFF
	 rtBEHDQkEDtJYgYs54wOMN84Npw68ID4ofwmZIg/SoampbDyuIjfhJC4ps1J/VUSPO
	 /bI8dkAKCQ7Yn+7EsFopSDKZqyyFt/se2bsPpnqnNq9iADoDph5W5T+z9SOtiP1rKT
	 sBzzTvHzgulUTaHJJgkLNAIW8z0mZvFeU77JQg63bA2OSm16m2YWMVJbQGLebgO5wt
	 RT+t3ucIsuUBufPaE/tBpulTnRC3ddgN1NMbRlWtNBH/FnHAmIAN7bP1LSpZ01ezBi
	 daIjTgtvKFl3Q==
Date: Mon, 25 Nov 2024 17:24:11 -0800
Subject: [PATCH 14/16] generic/366: fix directio requirements checking
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, zlang@redhat.com
Cc: fstests@vger.kernel.org, hch@lst.de, fstests@vger.kernel.org,
 linux-xfs@vger.kernel.org
Message-ID: <173258395284.4031902.1560490632691011803.stgit@frogsfrogsfrogs>
In-Reply-To: <173258395050.4031902.8257740212723106524.stgit@frogsfrogsfrogs>
References: <173258395050.4031902.8257740212723106524.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

On a system with 4k-sector storage devices, this test fails with:

 --- /tmp/fstests/tests/generic/366.out	2024-11-17 09:04:53.161104479 -0800
 +++ /var/tmp/fstests/generic/366.out.bad	2024-11-20 21:02:30.948000000 -0800
 @@ -1,2 +1,34 @@
  QA output created by 366
 +fio: io_u error on file /opt/file1: Invalid argument: read offset=15360, buflen=512
 +fio: io_u error on file /opt/file1: Invalid argument: read offset=15360, buflen=512

The cause of this failure is that we cannot do 512byte directios to a
device with 4k LBAs.  Update the precondition checking to exclude this
scenario.

Cc: <fstests@vger.kernel.org> # v2024.11.17
Fixes: 4c1629ae3a3a56 ("generic: new test case to verify if certain fio load will hang the filesystem")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 tests/generic/366 |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/tests/generic/366 b/tests/generic/366
index 6e7dd7279218c4..b322bcca72fecc 100755
--- a/tests/generic/366
+++ b/tests/generic/366
@@ -20,7 +20,7 @@ _begin_fstest auto quick rw
 . ./common/filter
 
 _require_scratch
-_require_odirect
+_require_odirect 512	# see fio job1 config below
 _require_aio
 
 _fixed_by_kernel_commit xxxxxxxxxxxx \


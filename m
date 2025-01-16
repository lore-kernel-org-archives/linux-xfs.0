Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 271192419F3;
	Thu, 16 Jan 2025 23:30:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737070255; cv=none; b=TeS+HefB1eVciZa5u8bcPgwWav21F2SN2mWkDWBW9ynNzEXDmkM4R+tkOQr0SOPUhU0bLxsuGHz031V40NBbxeJx6MOFNqCAOYLb7+4MTo8n/Y1l0+NiHqurAVMFDJS1yBleQg5+ozKeeyTG6StBD8PLF6RkdM7QwdU67nFfCF8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737070255; c=relaxed/simple;
	bh=IrM7i4LJFkArnRNgd+TIleFYE6/XmKgM8G4vbLu4IcQ=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ElXUkNfHkDzsjv2hVy4TuysA/I0sd5Z+vZVhCPd2vinXYGUZP32z50/OZaerj14HhwTMawG/tm1czcT1cNLfgrqyAEYpF2koCPXXyE3t2xYrw9KV9Z00cBLYhO4x7/mYGaA8l/hdi4BVUrHa9HwadwjBFaHNk8skBgRwRspREwA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kHkATOMB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kHkATOMB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3737C4CED6;
	Thu, 16 Jan 2025 23:30:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1737070254;
	bh=IrM7i4LJFkArnRNgd+TIleFYE6/XmKgM8G4vbLu4IcQ=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=kHkATOMBWdZ0OonEH8sy15UjDgYskJkbxoWidnkTWbQz1V01Ub23Thcmm/TITtOuC
	 vYlOc/h58rl31BXJt+KMt1QNJTUiqRh2K6FeLVB9f0Z1pshHuRGVOeGAPZfLGtvEUR
	 /GpmjQp8X+fJD9iowfU9ALmEnfsPQjEfv54VaESAPdCg+cA/rhzsIs6Ocq93da8+qH
	 Qd1TOM5Apv1vbyE8ycQIXqcBqKp3Kw0w/rdIHmzD/P2fQsCUtcf8J98PvKPeJd315d
	 aHvObuh3p8tDO2qpL0nOxQgS8K6zQ/RJfZ8vU+JnhjcT1RfCsieBAwd79nPa7kymTv
	 /qoCy+6yn/htQ==
Date: Thu, 16 Jan 2025 15:30:54 -0800
Subject: [PATCH 22/23] fsx: fix leaked log file pointer
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: hch@lst.de, fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <173706974408.1927324.5268034153341516183.stgit@frogsfrogsfrogs>
In-Reply-To: <173706974044.1927324.7824600141282028094.stgit@frogsfrogsfrogs>
References: <173706974044.1927324.7824600141282028094.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Fix a resource leaks in fsx, where we fail to close the fsx logfile,
because the C library could have some buffered contents that aren't
flushed when the program terminates.  glibc seems to do this for us, but
I wouldn't be so sure about the others.

Fixes: 3f742550dfed84 ("fsx: add support for recording operations to a file")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 ltp/fsx.c |    1 +
 1 file changed, 1 insertion(+)


diff --git a/ltp/fsx.c b/ltp/fsx.c
index 9efd2f5c86d11c..2c19fff880330a 100644
--- a/ltp/fsx.c
+++ b/ltp/fsx.c
@@ -3345,6 +3345,7 @@ main(int argc, char **argv)
 	if (recordops)
 		logdump();
 
+	fclose(fsxlogf);
 	exit(0);
 	return 0;
 }


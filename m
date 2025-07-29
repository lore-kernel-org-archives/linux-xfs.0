Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E37A61F956;
	Tue, 29 Jul 2025 20:10:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753819852; cv=none; b=S0v+OsgsAccMsui7IXDEDUpDNN6CZBlOoQBa/eHCmu4+k4KnL/Grv4BaaNPFm6hWY5CbzEtWn2LrOI+QzRufQkhLcCRrAp4fZTiSt8tc5qOrjtPJtcqHqhl9uO8Xs1FvFSwAG63yRPUwhytTAHYlAP50OSOqqvjmWTaoM+nDe6I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753819852; c=relaxed/simple;
	bh=eFMH2R/0KfUawUidYMXBLYMCF4XzE8uF70j6RwFFoMU=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Fs/68SiBnvnqu0/1elwfR9gKspzBwz1pSIoQKDFR3U2jA52q1aK33cEEkkiHjGQvhbjaEgszOopwxNUUtKBQpa1ZwvMXoQof8QE3IZcFqnk4P261ZEgTE5NHTm6YS9oc6MOUROynRUdlW3WngAEze+Umn0lN8Y8TARQka6lzIPk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SY0jHdTp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SY0jHdTp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 735B3C4CEEF;
	Tue, 29 Jul 2025 20:10:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753819851;
	bh=eFMH2R/0KfUawUidYMXBLYMCF4XzE8uF70j6RwFFoMU=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=SY0jHdTpi2v4SFxTM8gmc+lNGrUIvIs09oDfiuwSx6aPx2Pt7ZIzBs9pnEbx+jZlr
	 r4CeQ0iK/ov0VjtXtNwkE80uQ8Sw2EsY9FNU3G0JP09raMAN6iQPJqGp3ZdLgL0IFr
	 dJwlQiWXaeyl2b2CI5SNUgxnM+GVMrVnQ1k74ba2ySj+2HM8TcLiID9X+yVf2OJW6Y
	 VI+3bvNk4bLWWAJ4DHRuFya25vUS0gLjpulsNDNcB3G2uzD2YXi1Z6dRa1skAQjW4Q
	 8dPOuL1CtEVqHyeHP7ir0t0HWkxmxAYPhWwvDfq4q8iQI7XHF/z/VEFixxPuCMQwbf
	 O4KH3V2c0+AHw==
Date: Tue, 29 Jul 2025 13:10:50 -0700
Subject: [PATCH 1/2] fsstress: don't abort when stat(".") returns EIO
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, zlang@redhat.com
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <175381958421.3021194.16249782318690545446.stgit@frogsfrogsfrogs>
In-Reply-To: <175381958396.3021194.15630936445319512317.stgit@frogsfrogsfrogs>
References: <175381958396.3021194.15630936445319512317.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

First, start with the premise that fstests is run with a nonzero limit
on the size of core dumps so that we can capture the state of
misbehaving fs utilities like fsck and scrub if they crash.

When fsstress is compiled with DEBUG defined (which is the default), it
will periodically call check_cwd to ensure that the current working
directory hasn't changed out from underneath it.

If the filesystem is XFS and it shuts down, the stat64() calls will
start returning EIO.  In this case, we follow the out: label and call
abort() to exit the program.  Historically this did not produce any core
dumps because $PWD is on the dead filesystem and the write fails.

However, modern systems are often configured to capture coredumps using
some external mechanism, e.g. abrt/systemd-coredump.   In this case, the
capture tool will succeeds in capturing every crashed process, which
fills the crash dump directory with a lot of useless junk.  Worse, if
the capture tool is configured to pass the dumps to fstests, it will
flag the test as failed because something dumped core.

This is really silly, because basic stat requests for the current
working directory can be satisfied from the inode cache without a disk
access.  In this narrow situation, EIO only happens when the fs has shut
down, so just exit the program.

We really should have a way to query if a filesystem is shut down that
isn't conflated with (possibly transient) EIO errors.  But for now this
is what we have to do. :(

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 ltp/fsstress.c |   15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)


diff --git a/ltp/fsstress.c b/ltp/fsstress.c
index 8dbfb81f95a538..d4abe561787f19 100644
--- a/ltp/fsstress.c
+++ b/ltp/fsstress.c
@@ -1049,8 +1049,21 @@ check_cwd(void)
 
 	ret = stat64(".", &statbuf);
 	if (ret != 0) {
+		int error = errno;
+
 		fprintf(stderr, "fsstress: check_cwd stat64() returned %d with errno: %d (%s)\n",
-			ret, errno, strerror(errno));
+			ret, error, strerror(error));
+
+		/*
+		 * The current working directory is pinned in memory, which
+		 * means that stat should not have had to do any disk accesses
+		 * to retrieve stat information.  Treat an EIO as an indication
+		 * that the filesystem shut down and exit instead of dumping
+		 * core like the abort() below does.
+		 */
+		if (error == EIO)
+			exit(1);
+
 		goto out;
 	}
 


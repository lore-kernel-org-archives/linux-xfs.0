Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B62BB7BB15;
	Tue,  6 Aug 2024 18:22:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722968547; cv=none; b=BXv3944AUI8slqnT0AT7367THWiyj1/7Tf1VFTMiPiJ+TMNnX/hLwwp9jWnygAUjQQyc5OGa2fdRLFqzn3Rokq1t5KfPf1cVNbSKbJUYH5eu5m/rP305+HEOZfKFndm5Jtkh0U/zn7AhBzxpEfzstMDa1FEqKZUwSVM9yGsqZ6k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722968547; c=relaxed/simple;
	bh=PeDBki+kFJRJIjKvGYcsp/Lvyto1oEai0AGvGvDkITU=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=biNI0Ap+dh+HTVjyXa3DEAQD6eyZe0dZaDJDUGjlw8LBUaUMWpIodRCL42DiIRK3nEX25G+Xm15B5exFQW5OwAtwfWyJHIcDyZ8+3OqHe9prwNRzpYyf5hZdxzsohJuHswCRcmE/O0FXAIzDTgA4vGgEqRpL7WoPMsHEaKGx1aQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CDK8tMbQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CDK8tMbQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91178C32786;
	Tue,  6 Aug 2024 18:22:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722968547;
	bh=PeDBki+kFJRJIjKvGYcsp/Lvyto1oEai0AGvGvDkITU=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=CDK8tMbQ239ppdl7DRm9t75TLukce2ThiW1Hzqk1DuNKCR1mMynEDyxM7GHcf1R+s
	 T8VHcglZSd8eY9Ox4hO0/5GMm4oPFUxuMuhixAE3m1z3moH3Gjjp0aLZybxBClLN+/
	 I0Uq4AbRis8/nGUSleyiGs0zVFTCaUZeY6pnmrJOrneaagRlNlxtseZDk3hXzf2h2Q
	 7DKnpi+I6XaRkOqgkYr8pcxzllXvsd83jYs9vfbyt+IY7CHNaztJ+ciMQ6zLm1vT9E
	 r4T7DRSl5WG6dtb8IDgGroGFsVR733QNi8ilvDuELEMwTgbeyFAXny6KQqBIVTS+C1
	 olSsfhzHGfkRg==
Date: Tue, 06 Aug 2024 11:22:27 -0700
Subject: [PATCH 1/1] debian: enable xfs_scrub_all systemd timer services by
 default
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: hch@lst.de, dchinner@redhat.com, fstests@vger.kernel.org,
 linux-xfs@vger.kernel.org
Message-ID: <172296825972.3193535.18204339258677970549.stgit@frogsfrogsfrogs>
In-Reply-To: <172296825957.3193535.4840133667179783866.stgit@frogsfrogsfrogs>
References: <172296825957.3193535.4840133667179783866.stgit@frogsfrogsfrogs>
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

Now that we're finished building online fsck, enable the periodic
background scrub service by default.  This involves the postinst script
starting the resource management slice and the timer.

No other sub-services need to be enabled or unmasked explicitly.  They
also shouldn't be started or restarted because that might interrupt
background operation unnecessarily.

Although the xfs_scrub_all timer is activated by default, the individual
xfs_scrub@ services that it spawns will only do real work on filesystems
that are new enough to have back reference metadata available.  This
avoids surprises for people who are upgrading Debian; only new installs
with new mkfs will get any automatic fsck behavior.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 debian/rules |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/debian/rules b/debian/rules
index 69a79fc67..c3fbcd262 100755
--- a/debian/rules
+++ b/debian/rules
@@ -114,7 +114,7 @@ binary-arch: checkroot built
 	dh_compress
 	dh_fixperms
 	dh_makeshlibs
-	dh_installsystemd -p xfsprogs --no-enable --no-start --no-restart-after-upgrade --no-stop-on-upgrade
+	dh_installsystemd -p xfsprogs --no-restart-after-upgrade --no-stop-on-upgrade system-xfs_scrub.slice xfs_scrub_all.timer
 	dh_installdeb
 	dh_shlibdeps
 	dh_gencontrol


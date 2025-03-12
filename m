Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B01F1F1508;
	Wed, 12 Mar 2025 23:12:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741821124; cv=none; b=qk8bsFp+cz7/F4FELBE4qyc9iTH06828KNRaduKlwTpvNguTJ624HTvA+UtPmDuSFC2rr7DYNKTE2WoaqfDiFAt728jncHHM8NMT2aOBQ7Rn3an0KZdu9A9+xrcuLZTK2aNg0YhSX4NGzzeg1SCsyJgWzhGPJ9LHSbETpMFN1zk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741821124; c=relaxed/simple;
	bh=ecpk6l1eGopc7pVscXzS4Cc9+7gjRfUu9VQF56iisFw=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MkF0naNUdLG1d7u2uFJt1Krn+MOqNVNDWBklEEgXjqj+QeDgQKmhz5OnUbP8+/UbRwxRffvcFlG6UOT6MSROGIhWzSd5G5TrNrzmOMl5o6b0gCuyGWL0ZvsT/kSFWr0GQeyPEGk45cGUg48Car2GWicz5v2Q+91YFrEOcar/DdA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SZbgA+X4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SZbgA+X4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 702A0C4CEDD;
	Wed, 12 Mar 2025 23:12:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1741821124;
	bh=ecpk6l1eGopc7pVscXzS4Cc9+7gjRfUu9VQF56iisFw=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=SZbgA+X4oQ9ZLxB2m5fXj7KhuKnqyLN6MH/rpfbJUNGjUkffoknDE5h0BHGrjpJEq
	 my8qb5Fo7n0Bkvs4FRulMoZFyIc669z9MgKdF1V1agDBpfYcn7lshmPTKGJvA267hm
	 a9WWaJEdDnqcmTuYsNDZSRl3rMxenn7AE9myNXDLKfid/qe8GpVC4Djv8fO6UAkDuu
	 JaRqa+eGTOVoncVZBEQMOD6OvYyyxypQwtk0Bz8QFMjHiYFr0jw4OVkLwD1CheDINS
	 dp3qV78eMP9qmAIBsw7f7FZuO4PqkWO3mqQWO5Wy9U+jYpBR2Qoxldpw4kX01cn2Ig
	 9COZbxbCMClMg==
Date: Wed, 12 Mar 2025 16:12:04 -0700
Subject: [PATCH 3/3] check: don't allow TEST_DIR/SCRATCH_MNT to be in /tmp
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Message-ID: <174182089161.1400713.6024925682002640886.stgit@frogsfrogsfrogs>
In-Reply-To: <174182089094.1400713.5283745853237966823.stgit@frogsfrogsfrogs>
References: <174182089094.1400713.5283745853237966823.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

If we're running in a private mount namespace, /tmp is a private tmpfs
mount.  Using TEST_DIR/SCRATCH_MNT that point there is a bad idea
because anyone can write to there.  Let's just stop that.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 check |   14 ++++++++++++++
 1 file changed, 14 insertions(+)


diff --git a/check b/check
index 33eb3e0859e578..09134ee63e41e2 100755
--- a/check
+++ b/check
@@ -815,6 +815,20 @@ function run_section()
 		echo "SECTION       -- $section"
 	fi
 
+	# If we're running in a private mount namespace, /tmp is a private
+	# directory.  We /could/ just mkdir it, but we'd rather have people
+	# set those paths elsewhere.
+	if [ "$HAVE_PRIVATENS" = yes ] && [[ $TEST_DIR =~ ^\/tmp ]]; then
+		echo "$TEST_DIR: TEST_DIR must not be in /tmp"
+		status=1
+		exit
+	fi
+	if [ "$HAVE_PRIVATENS" = yes ] && [[ $SCRATCH_MNT =~ ^\/tmp ]]; then
+		echo "$SCRATCH_MNT: SCRATCH_MNT must not be in /tmp"
+		status=1
+		exit
+	fi
+
 	sect_start=`_wallclock`
 	if $RECREATE_TEST_DEV || [ "$OLD_FSTYP" != "$FSTYP" ]; then
 		echo "RECREATING    -- $FSTYP on $TEST_DEV"


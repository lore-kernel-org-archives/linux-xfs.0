Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16B3DD2FF;
	Tue, 26 Nov 2024 01:24:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732584268; cv=none; b=qseWvHvdQOHnX38AuSEdIdO+oHCoUSXoMU2lLNpjC9Lx8KfjHWY69XinJESU8X9LulkmWgGoGkhwn8Ba4vBtiCKsu8exgP1X5E2zVPnfGFqmwqdA2FHfMLHBDljbr1yPxulg2DRgrneOtmWW3c5Hi/7RoL/P7YTG9DrlC7adHqo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732584268; c=relaxed/simple;
	bh=VDsGXUkhjWu2r2d/kG9g9aqDH0Qd0M7McumS6moPnVc=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NUtxbFcGjvEEcgWryjNzBTUxfu+Bf6gkem1ANyBdR7xxls3ytOjBvcDDR4fnvMYHz/Sl65Q23mWVOSS5oxnY1CyzJgde2Qx4OwRa5zMTCppdcIIgXPcYrMDVv+L9l+JB2xLFZ4DfSwoq9M+sU0fmvxWzOLRhvo1cxICwDD0TKUs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sEpwL6p1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sEpwL6p1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8F69C4CECE;
	Tue, 26 Nov 2024 01:24:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1732584268;
	bh=VDsGXUkhjWu2r2d/kG9g9aqDH0Qd0M7McumS6moPnVc=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=sEpwL6p1+6uslijQdcZ6YCbGXFGlohAMh7Bwt98KqVaVqEPDDcSzwD84lI2f0D0NQ
	 EDrphKk5aei2kRItnY1GNioYwzb7I6Y0XGvJ3GtgSqpEAYz9fc8YvqzMkY+NB2OKHV
	 mGZg2CydKwOvpzX0cPw3JKFtRpp9sFWxFRhbeui/iB054k0KabHHHbMOv4FJ8KTiAD
	 CyR+PoxAt5dv8zSivh/ucM9P9mjKWzQz3o4ZN3zk5W7pmcZizPivc4VEqouP2Qowvd
	 XNq3ScGqBrKbZTS2gxvMIHe8RXMvHcoAr8eGEnxAijXjP1FD6t7nTDq/YrAv7rWYru
	 bNGrK0XX48Rwg==
Date: Mon, 25 Nov 2024 17:24:27 -0800
Subject: [PATCH 15/16] generic/454: actually set attr value for llamapirate
 subtest
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, zlang@redhat.com
Cc: fstests@vger.kernel.org, tytso@mit.edu, fstests@vger.kernel.org,
 linux-xfs@vger.kernel.org
Message-ID: <173258395299.4031902.7236733593217096781.stgit@frogsfrogsfrogs>
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

Ted reported that this test fails on his setup, and I noticed that I
forgot to actually set a value for the xattr.  In theory filesystems
support zero-byte xattrs, but we might as well set and check the values
so that we can make sure nobody got confused.

The actual test failure comes from attr 2.4.47 refusing to set a
zero-legnth xattr, whereas 2.5 and newer will.  That was changed in the
attr commit 0550d2bc989d39 ("Properly set and report empty attribute
values") prior to 2.4.48:

https://git.savannah.nongnu.org/cgit/attr.git/commit/?id=0550d2bc989d390eb25f7004ee0fae2dbc693a0d

Cc: <fstests@vger.kernel.org> # v2024.10.28
Fixes: 9c3762ceafd430 ("misc: amend unicode confusing name tests to check for hidden tag characters")
Reported-and-tested-by: tytso@mit.edu
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 tests/generic/454 |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)


diff --git a/tests/generic/454 b/tests/generic/454
index 2cc2d81ce4cc77..aec8beb8b43ca0 100755
--- a/tests/generic/454
+++ b/tests/generic/454
@@ -121,8 +121,8 @@ setf "combmark_\xe1\x80\x9c\xe1\x80\xad\xe1\x80\xaf.txt" "combining marks"
 setf "combmark_\xe1\x80\x9c\xe1\x80\xaf\xe1\x80\xad.txt" "combining marks"
 
 # encoding hidden tag characters in attrnames to create confusing xattrs
-setf "llamapirate\xf3\xa0\x80\x81\xf3\xa0\x81\x94\xf3\xa0\x81\xa8\xf3\xa0\x81\xa5\xf3\xa0\x80\xa0\xf3\xa0\x81\xb3\xf3\xa0\x81\xa1\xf3\xa0\x81\xac\xf3\xa0\x81\xa5\xf3\xa0\x81\xb3\xf3\xa0\x80\xa0\xf3\xa0\x81\xa6\xf3\xa0\x81\xaf\xf3\xa0\x81\xb2\xf3\xa0\x80\xa0\xf3\xa0\x81\x93\xf3\xa0\x81\xa5\xf3\xa0\x81\xa1\xf3\xa0\x81\xb4\xf3\xa0\x81\xb4\xf3\xa0\x81\xac\xf3\xa0\x81\xa5\xf3\xa0\x80\xa0\xf3\xa0\x81\xb7\xf3\xa0\x81\xa5\xf3\xa0\x81\xb2\xf3\xa0\x81\xa5\xf3\xa0\x80\xa0\xf3\xa0\x81\x95\xf3\xa0\x81\x93\xf3\xa0\x81\x84\xf3\xa0\x80\xa0\xf3\xa0\x80\xb1\xf3\xa0\x80\xb2\xf3\xa0\x80\xb0\xf3\xa0\x80\xb0\xf3\xa0\x80\xb0\xf3\xa0\x80\xb0\xf3\xa0\x81\xbf"
-setf "llamapirate"
+setf "llamapirate\xf3\xa0\x80\x81\xf3\xa0\x81\x94\xf3\xa0\x81\xa8\xf3\xa0\x81\xa5\xf3\xa0\x80\xa0\xf3\xa0\x81\xb3\xf3\xa0\x81\xa1\xf3\xa0\x81\xac\xf3\xa0\x81\xa5\xf3\xa0\x81\xb3\xf3\xa0\x80\xa0\xf3\xa0\x81\xa6\xf3\xa0\x81\xaf\xf3\xa0\x81\xb2\xf3\xa0\x80\xa0\xf3\xa0\x81\x93\xf3\xa0\x81\xa5\xf3\xa0\x81\xa1\xf3\xa0\x81\xb4\xf3\xa0\x81\xb4\xf3\xa0\x81\xac\xf3\xa0\x81\xa5\xf3\xa0\x80\xa0\xf3\xa0\x81\xb7\xf3\xa0\x81\xa5\xf3\xa0\x81\xb2\xf3\xa0\x81\xa5\xf3\xa0\x80\xa0\xf3\xa0\x81\x95\xf3\xa0\x81\x93\xf3\xa0\x81\x84\xf3\xa0\x80\xa0\xf3\xa0\x80\xb1\xf3\xa0\x80\xb2\xf3\xa0\x80\xb0\xf3\xa0\x80\xb0\xf3\xa0\x80\xb0\xf3\xa0\x80\xb0\xf3\xa0\x81\xbf" "secret instructions"
+setf "llamapirate" "no secret instructions"
 
 _getfattr --absolute-names -d "${testfile}" >> $seqres.full
 
@@ -171,8 +171,8 @@ testf "zerojoin_moo\xe2\x80\x8ccow.txt" "zero width joiners"
 testf "combmark_\xe1\x80\x9c\xe1\x80\xad\xe1\x80\xaf.txt" "combining marks"
 testf "combmark_\xe1\x80\x9c\xe1\x80\xaf\xe1\x80\xad.txt" "combining marks"
 
-testf "llamapirate\xf3\xa0\x80\x81\xf3\xa0\x81\x94\xf3\xa0\x81\xa8\xf3\xa0\x81\xa5\xf3\xa0\x80\xa0\xf3\xa0\x81\xb3\xf3\xa0\x81\xa1\xf3\xa0\x81\xac\xf3\xa0\x81\xa5\xf3\xa0\x81\xb3\xf3\xa0\x80\xa0\xf3\xa0\x81\xa6\xf3\xa0\x81\xaf\xf3\xa0\x81\xb2\xf3\xa0\x80\xa0\xf3\xa0\x81\x93\xf3\xa0\x81\xa5\xf3\xa0\x81\xa1\xf3\xa0\x81\xb4\xf3\xa0\x81\xb4\xf3\xa0\x81\xac\xf3\xa0\x81\xa5\xf3\xa0\x80\xa0\xf3\xa0\x81\xb7\xf3\xa0\x81\xa5\xf3\xa0\x81\xb2\xf3\xa0\x81\xa5\xf3\xa0\x80\xa0\xf3\xa0\x81\x95\xf3\xa0\x81\x93\xf3\xa0\x81\x84\xf3\xa0\x80\xa0\xf3\xa0\x80\xb1\xf3\xa0\x80\xb2\xf3\xa0\x80\xb0\xf3\xa0\x80\xb0\xf3\xa0\x80\xb0\xf3\xa0\x80\xb0\xf3\xa0\x81\xbf"
-testf "llamapirate"
+testf "llamapirate\xf3\xa0\x80\x81\xf3\xa0\x81\x94\xf3\xa0\x81\xa8\xf3\xa0\x81\xa5\xf3\xa0\x80\xa0\xf3\xa0\x81\xb3\xf3\xa0\x81\xa1\xf3\xa0\x81\xac\xf3\xa0\x81\xa5\xf3\xa0\x81\xb3\xf3\xa0\x80\xa0\xf3\xa0\x81\xa6\xf3\xa0\x81\xaf\xf3\xa0\x81\xb2\xf3\xa0\x80\xa0\xf3\xa0\x81\x93\xf3\xa0\x81\xa5\xf3\xa0\x81\xa1\xf3\xa0\x81\xb4\xf3\xa0\x81\xb4\xf3\xa0\x81\xac\xf3\xa0\x81\xa5\xf3\xa0\x80\xa0\xf3\xa0\x81\xb7\xf3\xa0\x81\xa5\xf3\xa0\x81\xb2\xf3\xa0\x81\xa5\xf3\xa0\x80\xa0\xf3\xa0\x81\x95\xf3\xa0\x81\x93\xf3\xa0\x81\x84\xf3\xa0\x80\xa0\xf3\xa0\x80\xb1\xf3\xa0\x80\xb2\xf3\xa0\x80\xb0\xf3\xa0\x80\xb0\xf3\xa0\x80\xb0\xf3\xa0\x80\xb0\xf3\xa0\x81\xbf" "secret instructions"
+testf "llamapirate" "no secret instructions"
 
 echo "Uniqueness of keys?"
 crazy_keys="$(_getfattr --absolute-names -d "${testfile}" | grep -E -c '(french_|chinese_|greek_|arabic_|urk)')"


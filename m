Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A706322A4FA;
	Wed, 19 Feb 2025 19:17:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739992665; cv=none; b=VMqRjLBaAzHOFLU9uc5S+Up/9f0SpK4CQmQKFFmiQ346OIqR3127FaMy+e9TpDeiMMZ542fD+ZGhmj3B3FkKUJRxb0vqs8a3gRTiymz3faDYtxMq6p8Ek91kYwadb9fvqWsgQHH+Srj9gCNdDj9IJ8IQ7I8eH7X5jbiSGpI1Sbo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739992665; c=relaxed/simple;
	bh=FNue1gpx2hNTSzIbEpf10cWIwPwfjUeqEqPBevm0KyQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Wj5uqe/TwiHbmmdz7oTg4Gw3wyUrWLxUGkv+LanSwtVJmNgZHJhhqNdmQI1F8ENAig7xkI51QfmIgM691BO4nnurxzIdQqgUISOgVjkG3CvPlHAcUUgnBoWkQLoNpDaIAwJwiWxFeAuB2N2ZwqLLL+OjLIrL+LBHimLiZ4cO40A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gDWQbEhe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gDWQbEhe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B9C3C4CED1;
	Wed, 19 Feb 2025 19:17:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739992665;
	bh=FNue1gpx2hNTSzIbEpf10cWIwPwfjUeqEqPBevm0KyQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=gDWQbEhenzykbTUds5KHohNxgv2JtTdIZ+GCcoagg9twulbV3RgcLecaISK/Ho6CF
	 2wadxu4mVxhQV0ozGBtAZUAV9Q1WoUm8RHYx/mjyc+AW9waGjA4NR7eIcdRVMGREIq
	 vhz5YopVZ9tiURoLyMnk882+XdT5zT31vorbzODCv6/1uDoUUKXExEp1TrEnxdyQaf
	 GEgJPZjIAoMxmucQO0jCZP6WgPof4iolU5e5SIEP0PESDAUmif1nT5lNgOVsW97sIO
	 zyhiUfxGIOlhbTesSJDZigeXjTCwtf7Xcwcr5vgvHp23v8ej1TZK8q5MTSgUusqKbI
	 2EmxTGQgUL3EA==
Date: Wed, 19 Feb 2025 11:17:44 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com
Cc: hch@lst.de, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: [PATCH v6.4.1 09/13] xfs/104: use _scratch_mkfs_sized
Message-ID: <20250219191744.GR21799@frogsfrogsfrogs>
References: <173992591052.4080556.14368674525636291029.stgit@frogsfrogsfrogs>
 <173992591276.4080556.2717402179307349211.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173992591276.4080556.2717402179307349211.stgit@frogsfrogsfrogs>

From: Darrick J. Wong <djwong@kernel.org>

Use _scratch_mkfs_sized instead of opencoding the small fs creation
logic because the helper scales down the size of the rt volume to match
the data volume.  This means the format won't fail if SCRATCH_RTDEV is
quite large.

Also fix some incorrect bash usage of "$@" and remove the leading
underscore because it's a private test function.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
v6.4.1: use _scratch_mkfs_sized this time
---
 tests/xfs/104 |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/tests/xfs/104 b/tests/xfs/104
index cd625d6b74aaaf..d4fc3ec136ae5f 100755
--- a/tests/xfs/104
+++ b/tests/xfs/104
@@ -12,10 +12,10 @@ _begin_fstest growfs ioctl prealloc auto stress
 # Import common functions.
 . ./common/filter
 
-_create_scratch()
+create_scratch_sized()
 {
 	echo "*** mkfs"
-	_scratch_mkfs_xfs $@ | tee -a $seqres.full | _filter_mkfs 2>$tmp.mkfs
+	_scratch_mkfs_sized "$@" | tee -a $seqres.full | _filter_mkfs 2>$tmp.mkfs
 	. $tmp.mkfs
 
 	echo "*** mount"
@@ -61,7 +61,7 @@ size=`expr 125 \* 1048576`	# 120 megabytes initially
 sizeb=`expr $size / $dbsize`	# in data blocks
 echo "*** creating scratch filesystem"
 logblks=$(_scratch_find_xfs_min_logblocks -dsize=${size} -dagcount=${nags})
-_create_scratch -lsize=${logblks}b -dsize=${size} -dagcount=${nags}
+create_scratch_sized "${size}" '' -lsize=${logblks}b -dagcount=${nags}
 
 echo "*** using some initial space on scratch filesystem"
 for i in `seq 125 -1 90`; do

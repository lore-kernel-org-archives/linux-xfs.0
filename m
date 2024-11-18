Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAB611E7647;
	Mon, 18 Nov 2024 23:03:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731971009; cv=none; b=kAnk/lF0LHG623LUeXZA/UEYNmINtL9rQpSocyPUttyo4BU3ndhoE72MMvmwH5ZKBX8sf15kwRD4d5cY1JmHpZWa+tidOWSs14wDMnaVaIxdSjWQwpi8lYzkkJWDhOHI8V0jol1sb/t92UcXubyF1nJJ+AqV9KN8EZNTVmkyxkk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731971009; c=relaxed/simple;
	bh=ZX22UqJx4AZelv6IirvzVkDKn9wmJ7KLKAv2Gn4JmMI=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=eJGge7FT7o4FLT/FspshDQorDhuklRJ5cKmRQdMnb8XuyQgiMvNS3A/btXdwyT3u/fZk7U0Fy6lo1Pvzy2C36W0RNsEERungAY9ewfZNEyP349/U0v+GBayuW/pyRAb2WiVMuIFpa9o29sZzn4H5WXfE8BJNb1Ykvuqrgc2+v7I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Iy/O0U5H; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Iy/O0U5H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B147BC4CECC;
	Mon, 18 Nov 2024 23:03:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1731971008;
	bh=ZX22UqJx4AZelv6IirvzVkDKn9wmJ7KLKAv2Gn4JmMI=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Iy/O0U5HCbher8dw/NhhQxUxj9EhsL1iir6ZTb0yKgaBpdsg2U+tqYEPQuOZkZc4A
	 23p/dHGjN7n98jiw6Lrge617o71G/pqXCWCOsfwV83vcB8615K/q2cyF2Wu+0/c3/I
	 N7xCuLBUCH0cmvHUllI3AyoxaVx37RiWDD2DrCciIOqxhVLxAE0dnpuIxfO9fYixZO
	 KYB8FhlM1JSN8MjB8hD37vwHLWQZG8v372TucF77NSt44AteaCaWQ99S82y0qGwTEo
	 DfilofP7w8syLYXcSGif6VaOxg90tMZT7Mn8yWlZ8S9C7LcOTcw1zCLR3qTY5qu8yZ
	 YiTpY3EyvWwKA==
Date: Mon, 18 Nov 2024 15:03:28 -0800
Subject: [PATCH 08/12] generic/251: use sentinel files to kill the fstrim loop
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Message-ID: <173197064547.904310.14473736825696277411.stgit@frogsfrogsfrogs>
In-Reply-To: <173197064408.904310.6784273927814845381.stgit@frogsfrogsfrogs>
References: <173197064408.904310.6784273927814845381.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Apparently the subshell kill doesn't always take, and then the test runs
for hours and hours because nothing stops it.  Instead, use a sentinel
file to detect when fstrim_loop should stop execing background fstrims.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 tests/generic/251 |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)


diff --git a/tests/generic/251 b/tests/generic/251
index b432fb11937911..d59e91c3e0a33a 100755
--- a/tests/generic/251
+++ b/tests/generic/251
@@ -125,12 +125,15 @@ fstrim_loop()
 			wait $fpid
 		fi
 		while [ $start -lt $fsize ] ; do
+			test -s $tmp.fstrim_loop || break
 			$FSTRIM_PROG -m ${minlen}k -o ${start}k -l ${step}k $SCRATCH_MNT &
 			fpid=$!
 			wait $fpid
 			start=$(( $start + $step ))
 		done
+		test -s $tmp.fstrim_loop || break
 	done
+	rm -f $tmp.fstrim_loop
 }
 
 function check_sums() {
@@ -188,6 +191,7 @@ find -P . -xdev -type f -print0 | xargs -0 md5sum | sort -o $tmp/content.sums
 
 echo -n "Running the test: "
 pids=""
+echo run > $tmp.fstrim_loop
 fstrim_loop &
 fstrim_pid=$!
 p=1
@@ -199,8 +203,10 @@ done
 echo "done."
 
 wait $pids
-kill $fstrim_pid
-wait $fstrim_pid
+truncate -s 0 $tmp.fstrim_loop
+while test -e $tmp.fstrim_loop; do
+	sleep 1
+done
 
 status=0
 


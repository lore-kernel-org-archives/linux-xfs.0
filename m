Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3905F1754B;
	Wed, 21 May 2025 22:42:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747867328; cv=none; b=llIcbfbGfQFtAfN+O5wGqFa2nrITgFhbsynO65FtlQR50U8rhcQdrbnTgmeP3+gqb6L5JsUM4yjedLbX4jhLsaQ/aCo8NRzJTMFEZKrS1xMVBhS3+Y9/llifKHikcrQrbKY38wTewXH1PgEB5JrDi3IHI8HTEzvRM/tP5IEIIv4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747867328; c=relaxed/simple;
	bh=hVlFGQUAl/Jc0gHP1Ac+iNB6aEzQjHrUSCsugk8JrOA=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jf7qlulK1zDfPdjOd8qrz1f2wl3HFOpieE7atFferxW6QlgWV4v7SmQBmhfp1tzoRc0MHawBFbL9L+9nzz3DOfNK3ghEJd6gcYKiHRKCPiGNCrVoYc12Gxj0VB5CE5GFDzl+lX8xdTuf6O/6/IWJ+qajCY6E14P3xl3rXi+VfSM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MT4mGgbR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MT4mGgbR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 103B2C4CEE4;
	Wed, 21 May 2025 22:42:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1747867328;
	bh=hVlFGQUAl/Jc0gHP1Ac+iNB6aEzQjHrUSCsugk8JrOA=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=MT4mGgbRoVJqq2L23WpPLB8xUG4cbff2pjHUqngavLxgGlObBAD3eGol+YBFrf7uZ
	 0yLf0yux4R0W6i1QEZjvXYoGVdV0KkT91zZjycn4wJFil+3aJMRrfAMigjEzrFgAc2
	 SQubYVEBe0cIqcNSFg6FafygEdprEza1F4VRjrcVdWF+zM36oZQ9E/TRFN35CihjyA
	 MTehhNe5wBEsWWXSqzKnS7kr4R1Lbab/BlJ+R05GrWLYKGjysYHrlMk4bQjCYTJj5e
	 b1Jr2HA3FgFbr1TOIMtof/s0LZTKjVg3XAGXX0EcZaT4azDumfCG6cXGbvzwv7hqK9
	 mM1TBbYypmAKA==
Date: Wed, 21 May 2025 15:42:07 -0700
Subject: [PATCH 1/4] generic/251: fix infinite looping if fstrim_loop
 configuration fails
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: fstests@vger.kernel.org, fstests@vger.kernel.org,
 linux-xfs@vger.kernel.org
Message-ID: <174786719713.1398933.8706464867612580485.stgit@frogsfrogsfrogs>
In-Reply-To: <174786719678.1398933.16005683028409620583.stgit@frogsfrogsfrogs>
References: <174786719678.1398933.16005683028409620583.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

In generic/251, the topmost scope of the test creates a run file
($tmp.fstrim_loop), starts fstrim_loop as a background shell, and then
waits for the file to disappear.  Unfortunately, the set_*_constraints
helpers called by fstrim_loop can abort the subshell by invoking
_notrun, in which case the loop never deletes the runfile and the upper
scope waits forever.

Fix this by amending _destroy_fstrim to delete the runfile always, and
move the trap call to the top of the function with a note about why it
must always be called.

Oh but wait, there's a second runfile related bug in run_process -- if
the fstrim loop exits while run_process is looping, it'll keep looping
even though there isn't anything else going on.  Break out of the loopin
this case.

Oh but wait, there's a /third/ runfile bug -- if the fstrim_loop exits
before the run_process children, it will delete the runfile.  Then the
top level scope, in trying to empty out the runfile to get the
fstrim_loop to exit, recreates the runfile and waits forever for nobody
to delete the run file.

I hate process management in bash.

Cc: <fstests@vger.kernel.org> # v2024.12.01
Fixes: 2d6e7681acff1e ("generic/251: use sentinel files to kill the fstrim loop")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 tests/generic/251 |   20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)


diff --git a/tests/generic/251 b/tests/generic/251
index ec486c277c6828..644adf07cc42d5 100755
--- a/tests/generic/251
+++ b/tests/generic/251
@@ -40,8 +40,9 @@ _destroy()
 
 _destroy_fstrim()
 {
-	kill $fpid 2> /dev/null
-	wait $fpid 2> /dev/null
+	test -n "$fpid" && kill $fpid 2> /dev/null
+	test -n "$fpid" && wait $fpid 2> /dev/null
+	rm -f $tmp.fstrim_loop
 }
 
 _fail()
@@ -61,14 +62,14 @@ set_minlen_constraints()
 	done
 	test $mmlen -gt 0 || \
 		_notrun "could not determine maximum FSTRIM minlen param"
-	FSTRIM_MAX_MINLEN=$mmlen
+	export FSTRIM_MAX_MINLEN=$mmlen
 
 	for ((mmlen = 1; mmlen < FSTRIM_MAX_MINLEN; mmlen *= 2)); do
 		$FSTRIM_PROG -l $(($mmlen*2))k -m ${mmlen}k $SCRATCH_MNT &> /dev/null && break
 	done
 	test $mmlen -le $FSTRIM_MAX_MINLEN || \
 		_notrun "could not determine minimum FSTRIM minlen param"
-	FSTRIM_MIN_MINLEN=$mmlen
+	export FSTRIM_MIN_MINLEN=$mmlen
 }
 
 # Set FSTRIM_{MIN,MAX}_LEN to the lower and upper bounds of the -l(ength)
@@ -82,14 +83,14 @@ set_length_constraints()
 	done
 	test $mmlen -gt 0 || \
 		_notrun "could not determine maximum FSTRIM length param"
-	FSTRIM_MAX_LEN=$mmlen
+	export FSTRIM_MAX_LEN=$mmlen
 
 	for ((mmlen = 1; mmlen < FSTRIM_MAX_LEN; mmlen *= 2)); do
 		$FSTRIM_PROG -l ${mmlen}k $SCRATCH_MNT &> /dev/null && break
 	done
 	test $mmlen -le $FSTRIM_MAX_LEN || \
 		_notrun "could not determine minimum FSTRIM length param"
-	FSTRIM_MIN_LEN=$mmlen
+	export FSTRIM_MIN_LEN=$mmlen
 }
 
 ##
@@ -99,12 +100,14 @@ set_length_constraints()
 ##
 fstrim_loop()
 {
+	# always remove the $tmp.fstrim_loop file on exit
+	trap "_destroy_fstrim; exit \$status" 2 15 EXIT
+
 	set_minlen_constraints
 	set_length_constraints
 	echo "MINLEN max=$FSTRIM_MAX_MINLEN min=$FSTRIM_MIN_MINLEN" >> $seqres.full
 	echo "LENGTH max=$FSTRIM_MAX_LEN min=$FSTRIM_MIN_LEN" >> $seqres.full
 
-	trap "_destroy_fstrim; exit \$status" 2 15
 	fsize=$(_discard_max_offset_kb "$SCRATCH_MNT" "$SCRATCH_DEV")
 
 	while true ; do
@@ -168,6 +171,7 @@ function run_process() {
 		cp -axT $content/ $SCRATCH_MNT/$p/
 
 		check_sums
+		test -e $tmp.fstrim_loop || break
 	done
 }
 
@@ -197,7 +201,7 @@ done
 echo "done."
 
 wait $pids
-truncate -s 0 $tmp.fstrim_loop
+test -e "$tmp.fstrim_loop" && truncate -s 0 $tmp.fstrim_loop
 while test -e $tmp.fstrim_loop; do
 	sleep 1
 done


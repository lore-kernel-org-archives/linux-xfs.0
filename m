Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EBFCD515;
	Tue, 26 Nov 2024 01:23:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732584190; cv=none; b=ZiFZ1RvGyWB2TMwfrnGWYqJlj/B3uqEltQROlIgsMjG+FT2zZjoM6Co/onIvFYJ6uY60y+DYU+1Rxc6wgOECeUvxYu1w13w5uCGESpCSdjxbWQTzOWGKqlMn3lxtAOqmxUy4zHl1pIBRWxt2gr1DpnYhCoqjwaU922D1S88E314=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732584190; c=relaxed/simple;
	bh=2RQv47vEcvXiBvqJDWRerC1u+CftcJabusFCx4tDSpc=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IXrwcEtJOXIhZOmXsGgSbKBdX+y8+6SRkzBDqs92T6oxXRWawQ9TBF64JQzQIbvFtaqOuq0dvvjlU5ptKCZOvZV/uw2bckSREH6D2mA3VOGFDphfCjmcl68Jy7ioU0Ry+Ss3ue8E8njbemjeY9vVO4aA1dGwcEXybVx/PpjsCGs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=M+CEIu3n; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="M+CEIu3n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7996DC4CECE;
	Tue, 26 Nov 2024 01:23:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1732584189;
	bh=2RQv47vEcvXiBvqJDWRerC1u+CftcJabusFCx4tDSpc=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=M+CEIu3n7+Rii6VBGuBI38UPtnybXviLCrbJfE7GnOU+jK+g5pBsdBVkd1WsWqwiY
	 QtZjdDu67lO7qxzfa254AZBHVC1WbZzaU4KKZykq2kl8oZ6Pq6ow5NMqJCNU0Cy5aU
	 /To4+N1+tN/LxOqrDeIfqtj6JO+1/7I7R2cBjF+cyntbQvXigm6HM9ENEyvOLLj16w
	 SBziVcOdCUADMprDPbn22AC4XtBg+UpXddEQia7vFnZhPDEFH2XsKmVXLKSfsPDedj
	 H1jk6xnV4bmWAGd2vCQ3qGrpwm6oIs3vmAopMw2Ssup7MPDbJFFxN/jKUmsrttzAyz
	 UhMDRKLnNX9eQ==
Date: Mon, 25 Nov 2024 17:23:09 -0800
Subject: [PATCH 10/16] generic/251: constrain runtime via time/load/soak
 factors
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, zlang@redhat.com
Cc: hch@lst.de, fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <173258395223.4031902.6225785818970710804.stgit@frogsfrogsfrogs>
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

On my test fleet, this test can run for well in excess of 20 minutes:

   613 generic/251
   616 generic/251
   624 generic/251
   630 generic/251
   634 generic/251
   652 generic/251
   675 generic/251
   749 generic/251
   777 generic/251
   808 generic/251
   832 generic/251
   946 generic/251
  1082 generic/251
  1221 generic/251
  1241 generic/251
  1254 generic/251
  1305 generic/251
  1366 generic/251
  1646 generic/251
  1936 generic/251
  1952 generic/251
  2358 generic/251
  4359 generic/251
  5325 generic/251
 34046 generic/251

because it hardcodes 20 threads and 10 copies.  It's not great to have a
test that results in a significant fraction of the total test runtime.
Fix the looping and load on this test to use LOAD and TIME_FACTOR to
scale up its operations, along with the usual SOAK_DURATION override.
That brings the default runtime down to less than a minute.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 tests/generic/251 |   24 ++++++++++--------------
 1 file changed, 10 insertions(+), 14 deletions(-)


diff --git a/tests/generic/251 b/tests/generic/251
index d59e91c3e0a33a..b4ddda10cef403 100755
--- a/tests/generic/251
+++ b/tests/generic/251
@@ -15,7 +15,6 @@ _begin_fstest ioctl trim auto
 tmp=`mktemp -d`
 trap "_cleanup; exit \$status" 0 1 3
 trap "_destroy; exit \$status" 2 15
-chpid=0
 mypid=$$
 
 # Import common functions.
@@ -151,29 +150,28 @@ function check_sums() {
 
 function run_process() {
 	local p=$1
-	repeat=10
+	if [ -n "$SOAK_DURATION" ]; then
+		local duration="$SOAK_DURATION"
+	else
+		local duration="$((30 * TIME_FACTOR))"
+	fi
+	local stopat="$(( $(date +%s) + duration))"
 
-	sleep $((5*$p))s &
-	export chpid=$! && wait $chpid &> /dev/null
-	chpid=0
-
-	while [ $repeat -gt 0 ]; do
+	sleep $((5*$p))s
 
+	while [ "$(date +%s)" -lt "$stopat" ]; do
 		# Remove old directories.
 		rm -rf $SCRATCH_MNT/$p
-		export chpid=$! && wait $chpid &> /dev/null
 
 		# Copy content -> partition.
 		mkdir $SCRATCH_MNT/$p
 		cp -axT $content/ $SCRATCH_MNT/$p/
-		export chpid=$! && wait $chpid &> /dev/null
 
 		check_sums
-		repeat=$(( $repeat - 1 ))
 	done
 }
 
-nproc=20
+nproc=$((4 * LOAD_FACTOR))
 
 # Copy $here to the scratch fs and make coipes of the replica.  The fstests
 # output (and hence $seqres.full) could be in $here, so we need to snapshot
@@ -194,11 +192,9 @@ pids=""
 echo run > $tmp.fstrim_loop
 fstrim_loop &
 fstrim_pid=$!
-p=1
-while [ $p -le $nproc ]; do
+for ((p = 1; p < nproc; p++)); do
 	run_process $p &
 	pids="$pids $!"
-	p=$(($p+1))
 done
 echo "done."
 


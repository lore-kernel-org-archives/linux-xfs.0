Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 829E422339;
	Fri, 22 Nov 2024 16:53:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732294415; cv=none; b=ZUpiYGi7VYwkGq/p1MgDy922nwhcl2qlbVIENuTNcAivreelvrsxun+eOhSFRVOelukeUJSBcIRXMXNpwQM/YIZA0/7r3ztq4eRMuveD7SfSkttiUK4fLZrDLkeoh36eYB+tVNYzbJyZD5DSOKwKStDbVONn2BgzCAlH153jxS8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732294415; c=relaxed/simple;
	bh=y8PpZm+HcG5jNGFNt/C/yNnVzaez8vzAR40bqTAe2d0=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=l55Pai6RuGDhRfavqfCX8F9BT3hLou4AxDPFyiQutJLoRR3PtnU6ygL6ZHtBOzBouxJFjz/TR9B7u6z0tW9FkguxCo2heKGTqE3Hl7PKTr+BKulgue7zwRCn6ZxOeH+V9JCVKAnRCeFEBTI0sU1SHfNGkbm5vkFjK1yZweWRxvg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pv6uSL1l; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pv6uSL1l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59902C4CECE;
	Fri, 22 Nov 2024 16:53:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1732294415;
	bh=y8PpZm+HcG5jNGFNt/C/yNnVzaez8vzAR40bqTAe2d0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=pv6uSL1lEVy6PG1XbRD3sjrjr/5FlRs2XbdrVtTZCXNzW40LR3JNPFhC3R5QRnWMn
	 p/9KLEyY9Y4fc0GRLRd5/yMVtNSufB3huGO84TfF3SRa2VjRAZKzV+7w1kIfF5he1v
	 hOCxdn6WcIqVvLra+IjxUXkGUtFCqJX2DfIwC/JscVSiQohPdD/kl+yrSxvfDjAISh
	 vQZeeMk9nccQ6jnPE9pZFZ1Vv6jfK7wm9kD/wVqG8mDOeaehboyfOVwh7x55KyNEPI
	 kxmR/5wJ0HSdd7hc5IJ7+muqB51hjkPQgVXr6LwqNbBroUYfXl0xHM9HwiHVK8IEQH
	 OaadDKOH4JonA==
Date: Fri, 22 Nov 2024 08:53:34 -0800
Subject: [PATCH 12/17] generic/251: use sentinel files to kill the fstrim loop
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: hch@lst.de, fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <173229420194.358248.7959632387252983213.stgit@frogsfrogsfrogs>
In-Reply-To: <173229419991.358248.8516467437316874374.stgit@frogsfrogsfrogs>
References: <173229419991.358248.8516467437316874374.stgit@frogsfrogsfrogs>
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
Reviewed-by: Christoph Hellwig <hch@lst.de>
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
 


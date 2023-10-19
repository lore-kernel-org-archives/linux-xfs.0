Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 189E6C41513
	for <linux-xfs@archiver.kernel.org>; Thu, 19 Oct 2023 14:36:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345718AbjJSOgc (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 19 Oct 2023 10:36:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235397AbjJSOgb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 19 Oct 2023 10:36:31 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8F90B0;
        Thu, 19 Oct 2023 07:36:29 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42D7BC433C8;
        Thu, 19 Oct 2023 14:36:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1697726189;
        bh=f/RDXYLMoe7gpB2FN011WJ0FfGsf4my5ApPMrKgpnmg=;
        h=Date:From:To:Cc:Subject:From;
        b=BDXyiWTtQeQdUkDaYDjL5odlszP2qkY0gsv7AKnjvxyXdbrCjjRGfLuG0ICwgc6f1
         pmx3S8aEfWMYkwEBa2s0qfMfe/9nboDJxaL1IpY/9z5IuNZ3Dh74DOdomgDV1FGMhK
         tK1JYZsdHu+NiUn1WBJ6Mr/YxtBbzIFI1xvfrWAueW+vxE5uPH8KnF+kEsLX898316
         rO8wG+KDTgkYi206JAwIwCYsH4deUuiCZYuK2ySjznyS67rgPz9Y6zE4EMA0nSkXxW
         gUuZuJFIirf8qF04+L0lHDO3fhHISrqFcG+8OHiRQE62g1/HSAVVwsXH1ebgkraTJD
         2VLmF3RFLUkrw==
Date:   Thu, 19 Oct 2023 07:36:27 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     zlang@redhat.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Subject: [PATCH] generic/251: check min and max length and minlen for FSTRIM
Message-ID: <20231019143627.GD11391@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Every now and then, this test fails with the following output when
running against my development tree when configured with an 8k fs block
size:

--- a/tests/generic/251.out	2023-07-11 12:18:21.624971186 -0700
+++ b/tests/generic/251.out.bad	2023-10-15 20:54:44.636000000 -0700
@@ -1,2 +1,4677 @@
 QA output created by 251
 Running the test: done.
+fstrim: /opt: FITRIM ioctl failed: Invalid argument
+fstrim: /opt: FITRIM ioctl failed: Invalid argument
...
+fstrim: /opt: FITRIM ioctl failed: Invalid argument

Dumping the exact fstrim command lines to seqres.full produces this at
the end:

/usr/sbin/fstrim -m 32544k -o 30247k -l 4k /opt
/usr/sbin/fstrim -m 32544k -o 30251k -l 4k /opt
...
/usr/sbin/fstrim -m 32544k -o 30255k -l 4k /opt

The count of failure messages is the same as the count as the "-l 4k"
fstrim invocations.  Since this is an 8k-block filesystem, the -l
parameter is clearly incorrect.  The test computes random -m and -l
options.

Therefore, create helper functions to guess at the minimum and maximum
length and minlen parameters that can be used with the fstrim program.
In the inner loop of the test, make sure that our choices for -m and -l
fall within those constraints.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/generic/251 |   59 ++++++++++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 51 insertions(+), 8 deletions(-)

diff --git a/tests/generic/251 b/tests/generic/251
index 8ee74980cc..40cfd7c381 100755
--- a/tests/generic/251
+++ b/tests/generic/251
@@ -53,14 +53,46 @@ _fail()
 	kill $mypid 2> /dev/null
 }
 
-_guess_max_minlen()
+# Set FSTRIM_{MIN,MAX}_MINLEN to the lower and upper bounds of the -m(inlen)
+# parameter to fstrim on the scratch filesystem.
+set_minlen_constraints()
 {
-	mmlen=100000
-	while [ $mmlen -gt 1 ]; do
+	local mmlen
+
+	for ((mmlen = 100000; mmlen > 0; mmlen /= 2)); do
 		$FSTRIM_PROG -l $(($mmlen*2))k -m ${mmlen}k $SCRATCH_MNT &> /dev/null && break
-		mmlen=$(($mmlen/2))
 	done
-	echo $mmlen
+	test $mmlen -gt 0 || \
+		_notrun "could not determine maximum FSTRIM minlen param"
+	FSTRIM_MAX_MINLEN=$mmlen
+
+	for ((mmlen = 1; mmlen < FSTRIM_MAX_MINLEN; mmlen *= 2)); do
+		$FSTRIM_PROG -l $(($mmlen*2))k -m ${mmlen}k $SCRATCH_MNT &> /dev/null && break
+	done
+	test $mmlen -le $FSTRIM_MAX_MINLEN || \
+		_notrun "could not determine minimum FSTRIM minlen param"
+	FSTRIM_MIN_MINLEN=$mmlen
+}
+
+# Set FSTRIM_{MIN,MAX}_LEN to the lower and upper bounds of the -l(ength)
+# parameter to fstrim on the scratch filesystem.
+set_length_constraints()
+{
+	local mmlen
+
+	for ((mmlen = 100000; mmlen > 0; mmlen /= 2)); do
+		$FSTRIM_PROG -l ${mmlen}k $SCRATCH_MNT &> /dev/null && break
+	done
+	test $mmlen -gt 0 || \
+		_notrun "could not determine maximum FSTRIM length param"
+	FSTRIM_MAX_LEN=$mmlen
+
+	for ((mmlen = 1; mmlen < FSTRIM_MAX_LEN; mmlen *= 2)); do
+		$FSTRIM_PROG -l ${mmlen}k $SCRATCH_MNT &> /dev/null && break
+	done
+	test $mmlen -le $FSTRIM_MAX_LEN || \
+		_notrun "could not determine minimum FSTRIM length param"
+	FSTRIM_MIN_LEN=$mmlen
 }
 
 ##
@@ -70,13 +102,24 @@ _guess_max_minlen()
 ##
 fstrim_loop()
 {
+	set_minlen_constraints
+	set_length_constraints
+	echo "MINLEN max=$FSTRIM_MAX_MINLEN min=$FSTRIM_MIN_MINLEN" >> $seqres.full
+	echo "LENGTH max=$FSTRIM_MAX_LEN min=$FSTRIM_MIN_LEN" >> $seqres.full
+
 	trap "_destroy_fstrim; exit \$status" 2 15
 	fsize=$(_discard_max_offset_kb "$SCRATCH_MNT" "$SCRATCH_DEV")
-	mmlen=$(_guess_max_minlen)
 
 	while true ; do
-		step=$((RANDOM*$RANDOM+4))
-		minlen=$(((RANDOM*($RANDOM%2+1))%$mmlen))
+		while true; do
+			step=$((RANDOM*$RANDOM+4))
+			test "$step" -ge "$FSTRIM_MIN_LEN" && break
+		done
+		while true; do
+			minlen=$(( (RANDOM * (RANDOM % 2 + 1)) % FSTRIM_MAX_MINLEN ))
+			test "$minlen" -ge "$FSTRIM_MIN_MINLEN" && break
+		done
+
 		start=$RANDOM
 		if [ $((RANDOM%10)) -gt 7 ]; then
 			$FSTRIM_PROG $SCRATCH_MNT &

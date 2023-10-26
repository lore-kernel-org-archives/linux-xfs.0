Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47540C0032E
	for <linux-xfs@archiver.kernel.org>; Thu, 26 Oct 2023 03:21:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231286AbjJZDV4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 25 Oct 2023 23:21:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229554AbjJZDVz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 25 Oct 2023 23:21:55 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F30EA18D;
        Wed, 25 Oct 2023 20:21:52 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E73DC433C7;
        Thu, 26 Oct 2023 03:21:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1698290512;
        bh=CbVr4r4Q6yQb8oNcslI7RaSk1UxTN7dvVPLZ7kcnY7Y=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Dp8IHpt4Vi5h1ESs1PWAROuBkDywsxruvTtrNIWFmAET7nX0DjaiELxsuNhIsGl1y
         x1GkUezDi7N3DHBAlYEWw4KwHzQ64BK53yIBPl59jr8hY6jgu26WtTfTkvByuVDCgA
         uxiauLK0v9IUtn1l6IAeG2JCMizcIWXndrNzbbQTKsM2sWDZLIFQhiV6uvk8zYyvh5
         MW0fJOB97yQifEDL8SDumdziFFMY7agFeffxOcniTEa8NOWMgYRWgr+uSLj6lhTJNA
         K7+wd3k6QQhFpU71ymJ2kUOr+KnS31gHV+GOZCHS8+XZ72R9w5NC9YIugIkk2uPKG0
         g/3hkEaHjmOvQ==
Date:   Wed, 25 Oct 2023 20:21:51 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     zlang@redhat.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Subject: [PATCH 2/2] generic/251: check min and max length and minlen for
 FSTRIM
Message-ID: <20231026032151.GJ3195650@frogsfrogsfrogs>
References: <20231026031202.GM11391@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231026031202.GM11391@frogsfrogsfrogs>
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
index 3b807df5fa..b7a15f9189 100755
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

Return-Path: <SRS0=lEGq=6I=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50480C2BA1A
	for <linux-xfs@archiver.kernel.org>; Fri, 24 Apr 2020 11:03:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2B3B820736
	for <linux-xfs@archiver.kernel.org>; Fri, 24 Apr 2020 11:03:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726746AbgDXLDe (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 24 Apr 2020 07:03:34 -0400
Received: from mx2.suse.de ([195.135.220.15]:34648 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726489AbgDXLDe (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 24 Apr 2020 07:03:34 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 17F2EACC4;
        Fri, 24 Apr 2020 11:03:31 +0000 (UTC)
Date:   Fri, 24 Apr 2020 13:03:30 +0200
From:   Anthony Iliopoulos <ailiop@suse.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Eryu Guan <guaneryu@gmail.com>, fstests@vger.kernel.org,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH] common/fuzzy: don't attempt online scrubbing unless
 supported
Message-ID: <20200424110330.GV1329@technoir>
References: <20200421113643.24224-1-ailiop@suse.com>
 <20200421153717.GY6742@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200421153717.GY6742@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Apr 21, 2020 at 08:37:17AM -0700, Darrick J. Wong wrote:
> On Tue, Apr 21, 2020 at 01:36:42PM +0200, Anthony Iliopoulos wrote:
> > Many xfs metadata fuzzing tests invoke xfs_scrub to detect online errors
> > even when _scratch_xfs_fuzz_metadata is invoked with "offline". This
> > causes those tests to fail with output mismatches on kernels that don't
> > enable CONFIG_XFS_ONLINE_SCRUB. Bypass scrubbing when not supported.
> > 
> > Signed-off-by: Anthony Iliopoulos <ailiop@suse.com>
> > ---
> >  common/fuzzy | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/common/fuzzy b/common/fuzzy
> > index 988203b1..83ddc3e8 100644
> > --- a/common/fuzzy
> > +++ b/common/fuzzy
> > @@ -238,7 +238,7 @@ __scratch_xfs_fuzz_field_test() {
> >  	if [ $res -eq 0 ]; then
> >  		# Try an online scrub unless we're fuzzing ag 0's sb,
> >  		# which scrub doesn't know how to fix.
> > -		if [ "${repair}" != "none" ]; then
> > +		if _supports_xfs_scrub "${SCRATCH_MNT}" "${SCRATCH_DEV}"; then
> 
> Huh?
> 
> This changes the behavior of the repair=none fuzz tests, which mutate
> filesystems and then write to them without running any checking tools
> whatsoever to see if we can trip over the mutations with only regular
> filesystem operations.  Whereas before, we'd skip xfs_scrub, now we
> always run it if it's supported.

oops...right, we want to let the verifiers catch the errors here.

Speaking of which, I've been staring at the scripts but it's not clear
to me how the repair=none fuzz tests are expected to function. Many of
those tests corrupt AG metadata headers (e.g. the AGI lsn), which means
mount bails out with an error. But the golden output doesn't account for
that, so those tests will fail (e.g. xfs/456).

Further, for things like inode metadata fuzzing where the fs is usually
mountable, the tests will always succeed irrespective of the verifiers
firing or not (e.g. xfs/465).

I'd assume all those repair=none tests would need to check dmesg for
metadata corruptions, so something like:

--- a/common/fuzzy
+++ b/common/fuzzy
@@ -254,3 +254,3 @@ __scratch_xfs_fuzz_field_test() {
 		__scratch_xfs_fuzz_unmount
-	else
+	elif [ "${repair}" != "none" ]; then
 		(>&2 echo "re-mount failed ($res) with ${field} = ${fuzzverb}.")

--- a/tests/xfs/456
+++ b/tests/xfs/456
@@ -43,2 +43,5 @@ echo "Done fuzzing AGI"

+_check_dmesg_for "Metadata corruption detected" || \
+	_fail "Missing metadata corruption messages!"
+
 # success, all done

If this makes sense, I'll send a separate patch to address it, and fix
all repair=none tests as above.

> The open-coded repair conditionals scattered through this funciton
> probably ought to be refactored into helpers, e.g.
> 
> __fuzz_want_scrub_check() {
> 	local repair="$1"
> 	local field="$2"
> 
> 	test "${repair}" != "none" && \
> 		_supports_xfs_scrub "${SCRATCH_MNT}" "${SCRATCH_DEV}" && \
> 		[ "${field}" != "sb 0" ]
> }
> 
> if [ $res -eq 0 ]; then
> 	# Try an online scrub...
> 	if __fuzz_want_scrub_check "${repair}" "${field}"; then
> 		_scratch_scrub -n -a 1 -e continue 2>&1
> 		...

Will do that and send a v2, thanks for the review!

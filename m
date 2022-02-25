Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58E29C433EF
	for <linux-xfs@archiver.kernel.org>; Fri, 25 Feb 2022 22:14:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236084AbiBYWOt (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 25 Feb 2022 17:14:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232310AbiBYWOs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 25 Feb 2022 17:14:48 -0500
Received: from sandeen.net (sandeen.net [63.231.237.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 56E7D16200D
        for <linux-xfs@vger.kernel.org>; Fri, 25 Feb 2022 14:14:14 -0800 (PST)
Received: from [10.0.0.147] (liberator.sandeen.net [10.0.0.147])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id D5EAE116E2;
        Fri, 25 Feb 2022 16:13:19 -0600 (CST)
Message-ID: <3ef560bc-25ae-2fa2-26c0-844acf800c24@sandeen.net>
Date:   Fri, 25 Feb 2022 16:14:13 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.6.1
Content-Language: en-US
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Theodore Ts'o <tytso@mit.edu>, linux-xfs@vger.kernel.org,
        allison.henderson@oracle.com
References: <164263809453.863810.8908193461297738491.stgit@magnolia>
 <164263816090.863810.16834243121150635355.stgit@magnolia>
 <20220120013233.GJ13540@magnolia>
From:   Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [PATCH v2 12/17] xfs_scrub: report optional features in version
 string
In-Reply-To: <20220120013233.GJ13540@magnolia>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 1/19/22 7:32 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Ted Ts'o reported brittleness in the fstests logic in generic/45[34] to
> detect whether or not xfs_scrub is capable of detecting Unicode mischief
> in directory and xattr names.  This is a compile-time feature, since we
> do not assume that all distros will want to ship xfsprogs with libicu.
> 
> Rather than relying on ldd tests (which don't work at all if xfs_scrub
> is compiled statically), let's have -V print whether or not the feature
> is built into the tool.  Phase 5 still requires the presence of "UTF-8"
> in LC_MESSAGES to enable Unicode confusable detection; this merely makes
> the feature easier to discover.
> 
> Reported-by: Theodore Ts'o <tytso@mit.edu>
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
> v2: correct the name of the reporter
> ---

Hum, every single other utility just does "$progname version $version"
and I'm not that keen to tack on something for everyone, if it won't
really mean anything to anyone except xfstests scripts ;)

What about adding an "-F" to display features, and xfstests can use that,
and xfs_scrub -V will keep acting like every other utility?

Other utilities could use this too if we ever cared (though xfs_db
and xfs_io already have an "-F" option ... we could choose -Z for
featureZ, which is unused as a primary option anywhere ...)

like so:

===

diff --git a/man/man8/xfs_scrub.8 b/man/man8/xfs_scrub.8
index e881ae76..65d8f4a2 100644
--- a/man/man8/xfs_scrub.8
+++ b/man/man8/xfs_scrub.8
@@ -8,7 +8,7 @@ xfs_scrub \- check and repair the contents of a mounted XFS filesystem
 ]
 .I mount-point
 .br
-.B xfs_scrub \-V
+.B xfs_scrub \-V | \-F
 .SH DESCRIPTION
 .B xfs_scrub
 attempts to check and repair all metadata in a mounted XFS filesystem.
@@ -76,6 +76,9 @@ If
 is given, no action is taken if errors are found; this is the default
 behavior.
 .TP
+.B \-F
+Prints the version number along with optional build-time features and exits.
+.TP
 .B \-k
 Do not call TRIM on the free space.
 .TP
diff --git a/scrub/xfs_scrub.c b/scrub/xfs_scrub.c
index bc2e84a7..9e9a098c 100644
--- a/scrub/xfs_scrub.c
+++ b/scrub/xfs_scrub.c
@@ -582,6 +582,13 @@ report_outcome(
 	}
 }
 
+/* Compile-time features discoverable via version strings */
+#ifdef HAVE_LIBICU
+# define XFS_SCRUB_HAVE_UNICODE	"+"
+#else
+# define XFS_SCRUB_HAVE_UNICODE	"-"
+#endif
+
 int
 main(
 	int			argc,
@@ -613,7 +620,7 @@ main(
 	pthread_mutex_init(&ctx.lock, NULL);
 	ctx.mode = SCRUB_MODE_REPAIR;
 	ctx.error_action = ERRORS_CONTINUE;
-	while ((c = getopt(argc, argv, "a:bC:de:km:nTvxV")) != EOF) {
+	while ((c = getopt(argc, argv, "a:bC:de:Fkm:nTvxV")) != EOF) {
 		switch (c) {
 		case 'a':
 			ctx.max_errors = cvt_u64(optarg, 10);
@@ -654,6 +661,12 @@ main(
 				usage();
 			}
 			break;
+		case 'F':
+			fprintf(stdout, _("%s version %s %sUnicode\n"),
+					progname, VERSION,
+					XFS_SCRUB_HAVE_UNICODE);
+			fflush(stdout);
+			return SCRUB_RET_SUCCESS;
 		case 'k':
 			want_fstrim = false;
 			break;

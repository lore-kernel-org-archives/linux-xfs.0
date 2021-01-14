Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 984A0C433DB
	for <linux-xfs@archiver.kernel.org>; Thu, 14 Jan 2021 16:38:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 659D723A04
	for <linux-xfs@archiver.kernel.org>; Thu, 14 Jan 2021 16:38:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726253AbhANQh4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 14 Jan 2021 11:37:56 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:35966 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725918AbhANQh4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 14 Jan 2021 11:37:56 -0500
Received: from ip5f5af0a0.dynamic.kabel-deutschland.de ([95.90.240.160] helo=wittgenstein)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <christian.brauner@ubuntu.com>)
        id 1l05cW-0000b3-8L; Thu, 14 Jan 2021 16:37:12 +0000
Date:   Thu, 14 Jan 2021 17:37:10 +0100
From:   Christian Brauner <christian.brauner@ubuntu.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: fix up non-directory creation in SGID directories
Message-ID: <20210114163710.mvt4thnjqoq7gcbk@wittgenstein>
References: <20210113184630.2285768-1-hch@lst.de>
 <20210114104511.kekdiqumjvo2lo7v@wittgenstein>
 <20210114160644.GY1164246@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210114160644.GY1164246@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jan 14, 2021 at 08:06:44AM -0800, Darrick J. Wong wrote:
> On Thu, Jan 14, 2021 at 11:45:11AM +0100, Christian Brauner wrote:
> > On Wed, Jan 13, 2021 at 07:46:30PM +0100, Christoph Hellwig wrote:
> > > XFS always inherits the SGID bit if it is set on the parent inode, while
> > > the generic inode_init_owner does not do this in a few cases where it can
> > > create a possible security problem, see commit 0fa3ecd87848
> > > ("Fix up non-directory creation in SGID directories") for details.
> > > 
> > > Switch XFS to use the generic helper for the normal path to fix this,
> > > just keeping the simple field inheritance open coded for the case of the
> > > non-sgid case with the bsdgrpid mount option.
> > > 
> > > Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> > > Reported-by: Christian Brauner <christian.brauner@ubuntu.com>
> > > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > > ---
> > 
> > Reviewed-by: Christian Brauner <christian.brauner@ubuntu.com>
> > 
> > I ran the idmapped mounts xfstests on this patchset. With this patch
> > applied I was able to remove the special casing for xfs (apart from the
> > irix compatibility check) and got clean test runs:
> > 
> > 
> > 1. with regular setgid inheritance rules
> > root@f2-vm:/xfstests# ./check generic/622
> 
> Is this test posted to fstests somewhere?
> 
> FWIW the code change looks reasonable to me, but I wanted to see the
> functionality exercise test first. :)

(The test is part of the idmapped mount testsuite. This will be sent for
 inclusion after the v5.12 merge window has closed.)

I'll paste the test here (The one on list still works around the xfs
bug and is thus not suitable for testing a fixed xfs. :)) and the
complete test is found under [1]:

/* The following tests are concerned with setgid inheritance. These can be
 * filesystem type specific. For xfs, if a new file or directory is created
 * within a setgid directory and irix_sgid_inhiert is set then inherit the
 * setgid bit if the caller is in the group of the directory.
 */
static int setgid_create(void)
{
	int fret = -1;
	int file1_fd = -EBADF;
	pid_t pid;

	if (!caps_supported())
		return 0;

	if (fchmod(t_dir1_fd, S_IRUSR |
			      S_IWUSR |
			      S_IRGRP |
			      S_IWGRP |
			      S_IROTH |
			      S_IWOTH |
			      S_IXUSR |
			      S_IXGRP |
			      S_IXOTH |
			      S_ISGID), 0) {
		log_stderr("failure: fchmod");
		goto out;
	}

	/* Verify that the setgid bit got raised. */
	if (!is_setgid(t_dir1_fd, "", AT_EMPTY_PATH)) {
		log_stderr("failure: is_setgid");
		goto out;
	}

	pid = fork();
	if (pid < 0) {
		log_stderr("failure: fork");
		goto out;
	}
	if (pid == 0) {
		/* create regular file via open() */
		file1_fd = openat(t_dir1_fd, FILE1, O_CREAT | O_EXCL | O_CLOEXEC, S_IXGRP | S_ISGID);
		if (file1_fd < 0)
			die("failure: create");

		/* We're capable_wrt_inode_uidgid() and also our fsgid matches
		 * the directories gid.
		 */
		if (!is_setgid(t_dir1_fd, FILE1, 0))
			die("failure: is_setgid");

		/* create directory */
		if (mkdirat(t_dir1_fd, DIR1, 0000))
			die("failure: create");

		/* Directories always inherit the setgid bit. */
		if (!is_setgid(t_dir1_fd, DIR1, 0))
			die("failure: is_setgid");

		if (unlinkat(t_dir1_fd, FILE1, 0))
			die("failure: delete");

		if (unlinkat(t_dir1_fd, DIR1, AT_REMOVEDIR))
			die("failure: delete");

		exit(EXIT_SUCCESS);
	}
	if (wait_for_pid(pid))
		goto out;

	pid = fork();
	if (pid < 0) {
		log_stderr("failure: fork");
		goto out;
	}
	if (pid == 0) {
		if (!switch_ids(0, 10000))
			die("failure: switch_ids");

		if (!caps_down())
			die("failure: caps_down");

		/* create regular file via open() */
		file1_fd = openat(t_dir1_fd, FILE1, O_CREAT | O_EXCL | O_CLOEXEC, S_IXGRP | S_ISGID);
		if (file1_fd < 0)
			die("failure: create");

		/* Neither in_group_p() nor capable_wrt_inode_uidgid() so setgid
		 * bit needs to be stripped.
		 */
		if (is_setgid(t_dir1_fd, FILE1, 0))
			die("failure: is_setgid");

		/* create directory */
		if (mkdirat(t_dir1_fd, DIR1, 0000))
			die("failure: create");

		if (xfs_irix_sgid_inherit_enabled()) {
			/* We're not in_group_p(). */
			if (is_setgid(t_dir1_fd, DIR1, 0))
				die("failure: is_setgid");
		} else {
			/* Directories always inherit the setgid bit. */
			if (!is_setgid(t_dir1_fd, DIR1, 0))
				die("failure: is_setgid");
		}

		exit(EXIT_SUCCESS);
	}
	if (wait_for_pid(pid))
		goto out;

	fret = 0;
out:
	safe_close(file1_fd);

	return fret;
}

[1]: https://gitlab.com/brauner/xfstests/-/commit/d1859aecc341edeefe712ab8a3fa63159356c119.patch

and specifically

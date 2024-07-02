Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B7017462
	for <linux-xfs@vger.kernel.org>; Tue,  2 Jul 2024 00:43:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719881003; cv=none; b=LnmXIQG1dat2+mQa3Pib2n/ZbX6Qz62N+xKRV1sbxekT8ddqAeOqcR9SPRMOsaYTHCN8GBPRsLWIRAqpXIlnmNSAT6Pw1Lael9H3DfEDnhIiY94+tJ0C9ei1TxKdq0EoKQaeiYvpZteYM/hGlOogcaxj/DVtbq1i6zT4wrQoUHM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719881003; c=relaxed/simple;
	bh=aVb41195rStVX+Auz8tsZEjw+2i/kipv/nI+QnnhAcA=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=mDtTBp/6Ta6pEAHRukRUYy+dlVG05rjZm5WO2ay7eSlqikfjmOkV1Hso7Jc3YnsNwBFgvBuXJ3vPg6+LzLMa4tsflB/DUyM/Jxqrg007FfuwzXAHjiDJ+kE5MBpexXvwg9J8BCzeh1QiueE3GQRKoj/f5ac6B2R6BoczFyRiSZo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GKQKScAM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GKQKScAM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2848C116B1;
	Tue,  2 Jul 2024 00:43:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719881002;
	bh=aVb41195rStVX+Auz8tsZEjw+2i/kipv/nI+QnnhAcA=;
	h=Date:From:To:Cc:Subject:From;
	b=GKQKScAMDUPRsxPBGbi05dJYeFWolZZVMN7amIQFLX6x22WnCY4MNlsTgaJBkeZJc
	 elZH2vmPByoiCsigLFLN/Xj3Dj8AYsqdZ/if0LGW2QB9zrwMCB097JcIExRMuX+kOB
	 MhxC1nAeLmMwJGS8BiJ32o13CZCdcIq267LSf6SeTHehwquk8qSBloGkRQdh4FkVRb
	 C+5d7sVxVY7pDfhevLwHX4JOvWpbjzYwuopbWQlsc6bKXOIdIxCTv1c20/W06JtHqR
	 XNr1Svf5hYX68Z9IEav6I+ni0r4E0KZ2vW8Z4fUCqjFdannl/cW+pfCbTF5yXVilWj
	 CMzxmN0ABtk1Q==
Date: Mon, 1 Jul 2024 17:43:22 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>, Carlos Maiolino <cem@kernel.org>
Cc: xfs <linux-xfs@vger.kernel.org>
Subject: [PATCHBOMB] xfsprogs: program changes (mostly xfs_scrub) for 6.10
Message-ID: <20240702004322.GJ612460@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi everyone,

This is a partial patchbomb of all the changes I would like to merge for
xfsprogs 6.10.  The first patchset adds exchange-range support, and the
11th patchset adds parent pointers support.  Nearly everything else are
all the fixes needed in userspace (i.e. xfs_scrub) to complete online
repair.

Most of the new stuff for xfs_scrub are a lot of hardening of the
systemd system services; strengthening of the deceptive unicode checker
to report on the last few years' worth of unicode attacks; and better
responsiveness during the phase 8 FITRIM.

I've omitted everything that's already passed review, which cut down on
the patch count substantially.  Any patch with an 'R' column 1 has been
reviewed by someone; a patch with a '-' in column 1 has not been RVB'd.

[PATCHSET v30.7 01/16] xfsprogs: atomic file updates
- [PATCH 01/12] man: document the exchange-range ioctl
- [PATCH 02/12] man: document XFS_FSOP_GEOM_FLAGS_EXCHRANGE
- [PATCH 03/12] libhandle: add support for bulkstat v5
- [PATCH 04/12] libfrog: add support for exchange range ioctl family
- [PATCH 05/12] xfs_db: advertise exchange-range in the version command
- [PATCH 06/12] xfs_logprint: support dumping exchmaps log items
- [PATCH 07/12] xfs_fsr: convert to bulkstat v5 ioctls
- [PATCH 08/12] xfs_fsr: skip the xattr/forkoff levering with the newer
- [PATCH 09/12] xfs_io: create exchangerange command to test file range
- [PATCH 10/12] libfrog: advertise exchange-range support
- [PATCH 11/12] xfs_repair: add exchange-range to file systems
- [PATCH 12/12] mkfs: add a formatting option for exchange-range
[PATCHSET v30.7 02/16] xfsprogs: inode-related repair fixes
- [PATCH 1/3] xfs_{db,repair}: add an explicit owner field to
- [PATCH 2/3] libxfs: port the bumplink function from the kernel
- [PATCH 3/3] mkfs/repair: pin inodes that would otherwise overflow
[PATCHSET v30.7 03/16] xfs_scrub: detect deceptive filename
- [PATCH 01/13] xfs_scrub: use proper UChar string iterators
- [PATCH 02/13] xfs_scrub: hoist code that removes ignorable characters
- [PATCH 03/13] xfs_scrub: add a couple of omitted invisible code
- [PATCH 04/13] xfs_scrub: avoid potential UAF after freeing a
- [PATCH 05/13] xfs_scrub: guard against libicu returning negative
- [PATCH 06/13] xfs_scrub: hoist non-rendering character predicate
- [PATCH 07/13] xfs_scrub: store bad flags with the name entry
- [PATCH 08/13] xfs_scrub: rename UNICRASH_ZERO_WIDTH to
- [PATCH 09/13] xfs_scrub: type-coerce the UNICRASH_* flags
- [PATCH 10/13] xfs_scrub: reduce size of struct name_entry
- [PATCH 11/13] xfs_scrub: rename struct unicrash.normalizer
- [PATCH 12/13] xfs_scrub: report deceptive file extensions
- [PATCH 13/13] xfs_scrub: dump unicode points
[PATCHSET v30.7 04/16] xfs_scrub: move fstrim to a separate phase
- [PATCH 1/8] xfs_scrub: move FITRIM to phase 8
- [PATCH 2/8] xfs_scrub: ignore phase 8 if the user disabled fstrim
- [PATCH 3/8] xfs_scrub: collapse trim_filesystem
- [PATCH 4/8] xfs_scrub: fix the work estimation for phase 8
- [PATCH 5/8] xfs_scrub: report FITRIM errors properly
- [PATCH 6/8] xfs_scrub: don't call FITRIM after runtime errors
- [PATCH 7/8] xfs_scrub: don't trim the first agbno of each AG for
- [PATCH 8/8] xfs_scrub: improve progress meter for phase 8 fstrimming
[PATCHSET v30.7 05/16] xfs_scrub: use free space histograms to reduce
- [PATCH 1/7] libfrog: hoist free space histogram code
- [PATCH 2/7] libfrog: print wider columns for free space histogram
- [PATCH 3/7] libfrog: print cdf of free space buckets
- [PATCH 4/7] xfs_scrub: don't close stdout when closing the progress
- [PATCH 5/7] xfs_scrub: remove pointless spacemap.c arguments
- [PATCH 6/7] xfs_scrub: collect free space histograms during phase 7
- [PATCH 7/7] xfs_scrub: tune fstrim minlen parameter based on free
[PATCHSET v30.7 06/16] xfs_scrub: tighten security of systemd
- [PATCH 1/6] xfs_scrub: allow auxiliary pathnames for sandboxing
R [PATCH 2/6] xfs_scrub.service: reduce CPU usage to 60%% when possible
R [PATCH 3/6] xfs_scrub: use dynamic users when running as a systemd
R [PATCH 4/6] xfs_scrub: tighten up the security on the background
- [PATCH 5/6] xfs_scrub_fail: tighten up the security on the background
- [PATCH 6/6] xfs_scrub_all: tighten up the security on the background
[PATCHSET v30.7 07/16] xfs_scrub_all: automatic media scan service
- [PATCH 1/6] xfs_scrub_all: only use the xfs_scrub@ systemd services
- [PATCH 2/6] xfs_scrub_all: remove journalctl background process
- [PATCH 3/6] xfs_scrub_all: support metadata+media scans of all
- [PATCH 4/6] xfs_scrub_all: enable periodic file data scrubs
- [PATCH 5/6] xfs_scrub_all: trigger automatic media scans once per
- [PATCH 6/6] xfs_scrub_all: failure reporting for the xfs_scrub_all
[PATCHSET v30.7 08/16] xfs_scrub_all: improve systemd handling
- [PATCH 1/5] xfs_scrub_all: encapsulate all the subprocess code in an
- [PATCH 2/5] xfs_scrub_all: encapsulate all the systemctl code in an
- [PATCH 3/5] xfs_scrub_all: add CLI option for easier debugging
- [PATCH 4/5] xfs_scrub_all: convert systemctl calls to dbus
- [PATCH 5/5] xfs_scrub_all: implement retry and backoff for dbus calls
[PATCHSET v30.7 09/16] xfs_scrub: automatic optimization by default
- [PATCH 1/3] xfs_scrub: automatic downgrades to dry-run mode in
- [PATCH 2/3] xfs_scrub: add an optimization-only mode
- [PATCH 3/3] debian: enable xfs_scrub_all systemd timer services by
[PATCHSET v13.7 10/16] xfsprogs: improve extended attribute
- [PATCH 1/3] xfs_repair: check free space requirements before allowing
- [PATCH 2/3] xfs_repair: enforce one namespace bit per extended
- [PATCH 3/3] xfs_repair: check for unknown flags in attr entries
[PATCHSET v13.7 11/16] xfsprogs: Parent Pointers
- [PATCH 01/24] libxfs: create attr log item opcodes and formats for
- [PATCH 02/24] xfs_{db,repair}: implement new attr hash value function
- [PATCH 03/24] xfs_logprint: dump new attr log item fields
- [PATCH 04/24] man: document the XFS_IOC_GETPARENTS ioctl
- [PATCH 05/24] libfrog: report parent pointers to userspace
- [PATCH 06/24] libfrog: add parent pointer support code
R [PATCH 07/24] xfs_io: adapt parent command to new parent pointer
R [PATCH 08/24] xfs_io: Add i, n and f flags to parent command
R [PATCH 09/24] xfs_logprint: decode parent pointers in ATTRI items
- [PATCH 10/24] xfs_spaceman: report file paths
- [PATCH 11/24] xfs_scrub: use parent pointers when possible to report
- [PATCH 12/24] xfs_scrub: use parent pointers to report lost file data
- [PATCH 13/24] xfs_db: report parent pointers in version command
R [PATCH 14/24] xfs_db: report parent bit on xattrs
- [PATCH 15/24] xfs_db: report parent pointers embedded in xattrs
- [PATCH 16/24] xfs_db: obfuscate dirent and parent pointer names
- [PATCH 17/24] libxfs: export attr3_leaf_hdr_from_disk via
- [PATCH 18/24] xfs_db: add a parents command to list the parents of a
- [PATCH 19/24] xfs_db: make attr_set and attr_remove handle parent
- [PATCH 20/24] xfs_db: add link and unlink expert commands
- [PATCH 21/24] xfs_db: compute hashes of parent pointers
- [PATCH 22/24] libxfs: create new files with attr forks if necessary
R [PATCH 23/24] mkfs: Add parent pointers during protofile creation
R [PATCH 24/24] mkfs: enable formatting with parent pointers
[PATCHSET v13.7 12/16] xfsprogs: scrubbing for parent pointers
- [PATCH 1/2] xfs: create a blob array data structure
- [PATCH 2/2] man2: update ioctl_xfs_scrub_metadata.2 for parent
[PATCHSET v13.7 13/16] xfsprogs: offline repair for parent pointers
- [PATCH 01/12] xfs_db: remove some boilerplate from xfs_attr_set
- [PATCH 02/12] xfs_db: actually report errors from libxfs_attr_set
- [PATCH 03/12] xfs_repair: junk parent pointer attributes when
- [PATCH 04/12] xfs_repair: add parent pointers when messing with
- [PATCH 05/12] xfs_repair: junk duplicate hashtab entries when
- [PATCH 06/12] xfs_repair: build a parent pointer index
- [PATCH 07/12] xfs_repair: move the global dirent name store to a
- [PATCH 08/12] xfs_repair: deduplicate strings stored in string blob
- [PATCH 09/12] xfs_repair: check parent pointers
- [PATCH 10/12] xfs_repair: dump garbage parent pointer attributes
- [PATCH 11/12] xfs_repair: update ondisk parent pointer records
- [PATCH 12/12] xfs_repair: wipe ondisk parent pointers when there are
[PATCHSET v13.7 14/16] xfsprogs: detect and correct directory tree
- [PATCH 1/5] libfrog: add directory tree structure scrubber to scrub
- [PATCH 2/5] xfs_spaceman: report directory tree corruption in the
- [PATCH 3/5] xfs_scrub: fix erroring out of check_inode_names
- [PATCH 4/5] xfs_scrub: detect and repair directory tree corruptions
- [PATCH 5/5] xfs_scrub: defer phase5 file scans if dirloop fails
[PATCHSET v30.7 15/16] xfs_scrub: vectorize kernel calls
- [PATCH 01/10] man: document vectored scrub mode
- [PATCH 02/10] libfrog: support vectored scrub
- [PATCH 03/10] xfs_io: support vectored scrub
- [PATCH 04/10] xfs_scrub: split the scrub epilogue code into a
- [PATCH 05/10] xfs_scrub: split the repair epilogue code into a
- [PATCH 06/10] xfs_scrub: convert scrub and repair epilogues to use
- [PATCH 07/10] xfs_scrub: vectorize scrub calls
- [PATCH 08/10] xfs_scrub: vectorize repair calls
- [PATCH 09/10] xfs_scrub: use scrub barriers to reduce kernel calls
- [PATCH 10/10] xfs_scrub: try spot repairs of metadata items to make
[PATCHSET v30.7 16/16] xfs_repair: small remote symlinks are ok
- [PATCH 1/1] xfs_repair: allow symlinks with short remote targets

--D

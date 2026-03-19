Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22182351C1C
	for <linux-xfs@vger.kernel.org>; Thu, 19 Mar 2026 04:37:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773895028; cv=none; b=p5g1LDMTP/abEZDUKQCyoPV/hyWKFC9ETRCnPLC2ONeUrII588zRWTaySTcuQJGaugJmUgMu72DAFgOzjnRmof91OntqsA4GzheRc7hszRXlCpir8IYGRA6EWC5lSyCO38mrVBGoGHEcLItZO1VgxBHG6tdzx16FAUeb4KC6J0o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773895028; c=relaxed/simple;
	bh=OZzn+5gXy8AVFlekDspiiVJ02TV0kkb8DUiThMpwe8M=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=slt812gkvngGo0q/hUO/Mq0UtUDcxWQvKlCqWeuCJYNabSxMyOqqDBahbt0Gt93Y8Yc8mN123HGZIb7s/vQ9XT7ilupvWR2E00b5+1o/211a4fcWQ1TeoLO4YKq1288JVrPl9FAQC1UPXt51L6uCWNWLq/0va4xJzzHPfSc5rUM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=m2L80igJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="m2L80igJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94BDCC19425;
	Thu, 19 Mar 2026 04:37:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773895027;
	bh=OZzn+5gXy8AVFlekDspiiVJ02TV0kkb8DUiThMpwe8M=;
	h=Date:From:To:Cc:Subject:From;
	b=m2L80igJ4ULqg2kh3RqEie0cjxb+ryBt8KkTNEk7PWRzRdzdNN9hrkNwFTfM9KfNq
	 Qo9I3UMgnAzRQOdHn9mpTm211ih219lwEj7cMZ/fmOC43ROD/eWd4/PYofFv8So46q
	 rYeAY3xRRYdFMqIHa02fEI2cmd/U1UGHA07lPB20K/Aa72BUQkuqWiut0ucw6csvEC
	 VfQTfl/sbUJ+freIVUqQqiEKNQBfiuyCWYzWDSgTC5nZrNrhhz88W05kgrD+BIC/fz
	 ZH8Af1hDaRsyB0yaPayEBY2zAL54ycGPzD7M8QLv1KkWpp9rXoF67FDCBEzEaDxDxb
	 8cW9VWmahAxZQ==
Date: Wed, 18 Mar 2026 21:37:07 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Andrey Albershteyn <aalbersh@redhat.com>
Cc: cem@kernel.org, hch@lst.de, linux-xfs@vger.kernel.org,
	Zorro Lang <zlang@redhat.com>
Subject: [PATCHBOMB v10] xfsprogs: autonomous self healing of filesystems
Message-ID: <20260319043707.GO1770774@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi all,

This patchset contains the userspace and QA changes (xfs_healer) needed
to put to use all the new kernel functionality to deliver live
information about filesystem health events (xfs_healthmon.c) to
userspace and a lot of cleanups to xfs_scrub's media verification.

In userspace, we create a new daemon program that will read the event
objects and initiate repairs automatically.  This daemon is managed
entirely by systemd and will not block unmounting of the filesystem
unless repairs are ongoing.  They are auto-started by a starter
service that uses fanotify.

When the patchsets under this cover letter are merged, online fsck for
XFS will at long last be fully feature complete.  The passive scan parts
have been done since mid-2024, this final part adds proactive repair.

Here's what's left to review, thanks to Christoph for doing a bunch of
xfs_healer reviews and sharing some cleanups he wanted to see in
xfs_scrub; and to Zorro for merging the fstests.

[PATCHSET v10 1/2] xfsprogs: autonomous self healing of filesystems
  [PATCH 19/26] xfs_healer: use statmount to find moved filesystems
[PATCHSET v10 2/2] xfs_scrub: refactor to XFS_IOC_VERIFY_MEDIA
  [PATCH 01/22] libfrog: allow bitmap_free to handle a null bitmap
  [PATCH 02/22] mkfs: rename byte unit conversion macros
  [PATCH 03/22] libfrog: lift *BYTES helpers to convert.h
  [PATCH 04/22] xfs_scrub: report truncated devices as media errors
  [PATCH 05/22] xfs_scrub: fix i18n of the decode_special_owner return
  [PATCH 07/22] xfs_scrub: move read verification scheduling to
  [PATCH 09/22] xfs_scrub: don't pass the io_end_arg around everywhere
  [PATCH 11/22] xfs_scrub: rename nr_io_threads
  [PATCH 16/22] xfs_scrub: perform media scanning of the log region
  [PATCH 17/22] xfs_scrub: index read-verify pools by xfs_device ids
  [PATCH 18/22] xfs_scrub: move failmap and other outputs into
  [PATCH 19/22] xfs_scrub: clean up device-related error messages
  [PATCH 20/22] xfs_scrub: drop SCSI_VERIFY code from disk.
  [PATCH 21/22] xfs_scrub: raise media verification IO limits
  [PATCH 22/22] xfs_scrub: allow overrides of the media verification IO

v10: cleanups of the media verification code in xfs_scrub
v9: reorg listmount/statmount, use it to find moved mounts, improve the
    commit messages and documentation
v8: clean up userspace for merging now that the kernel part is upstream
v7: more cleanups of the media verification ioctl, improve comments, and
    reuse the bio
v6: fix pi-breaking bugs, make verify failures trigger health reports
    and filter bio status flags better
v5: add verify-media ioctl, collapse small helper funcs with only
    one caller
v4: drop multiple client support so we can make direct calls into
    healthmon instead of chasing pointers and doing indirect calls
v3: drag out of rfc status

--D

Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFA851F4634
	for <linux-xfs@vger.kernel.org>; Tue,  3 Mar 2026 00:25:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772497510; cv=none; b=AOLK2gjrD6yfrI+neLr0HOIhgApE+NOwMGyGT2YvHqGGDrUfmJ2cTfO4XKywxF+MJwAAsWdrHGeWHVVQ/pKtwYuUZaEu3z+o3RZUVrMTowzyG/KHbmCOdwBl/iNQRwlbxIMdi/HE5P4KL+pGrR91img9VeGHnSc8Zekp4rjhT6w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772497510; c=relaxed/simple;
	bh=oXZ9U+xsvs+2LOwKqt9jUtQEmQvSZrcMQ7xcS6feXuY=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=hukWUNlgYgPcec3LUvUY6PdIwLXXeaZasSndHP9rnlOc6IUC6ZjaRcDCuQM3rtcXwaS/pwwSoHrFILNSSEA7DQW8L9gmSEaWvkfotRkZc0HUgVhgqOhxaA5HRx5jxi3qBd+uaOxLjt1tp3oaGHX1Ljctjud6CIbU28CK7NDopaY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hXdPdmFJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hXdPdmFJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80D1DC19423;
	Tue,  3 Mar 2026 00:25:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772497509;
	bh=oXZ9U+xsvs+2LOwKqt9jUtQEmQvSZrcMQ7xcS6feXuY=;
	h=Date:From:To:Cc:Subject:From;
	b=hXdPdmFJYSdQQpATlF62vbz4QU2ANiKQWIRuB+wLrLTqlohKJqxAXMG08DCkBJAge
	 POa1wmixrqkgEYyH5F9ddeKS65vD0xB2+0KNvLqsmHaCum3HWBAa/I382zAVVk5omC
	 3gdHJhP5uuUA6OH/psILZEU5ri7hsgOeKGf0oiOegFaWj89uJRlu67qjZwNPnR+uIp
	 ++UBDkxgzKqu5NJYR4VfewB0YqWOLsNcR3ezN9MWC83KLng54vjJP9clSEGd3KR89X
	 RFck0nV1EQ9Wapyvmb8ezfXeejlMLu3+dFPnTiZAFJsuRfsW0y/wsMAaPtYMMZ31ZC
	 IQltm1F1aKXxw==
Date: Mon, 2 Mar 2026 16:25:08 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Andrey Albershteyn <aalbersh@redhat.com>
Cc: cem@kernel.org, hch@lst.de, linux-xfs@vger.kernel.org
Subject: [PATCHBOMB v8] xfsprogs: autonomous self healing of filesystems
Message-ID: <20260303002508.GB57948@frogsfrogsfrogs>
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
userspace.

In userspace, we create a new daemon program that will read the event
objects and initiate repairs automatically.  This daemon is managed
entirely by systemd and will not block unmounting of the filesystem
unless repairs are ongoing.  They are auto-started by a starter
service that uses fanotify.

When the patchsets under this cover letter are merged, online fsck for
XFS will at long last be fully feature complete.  The passive scan parts
have been done since mid-2024, this final part adds proactive repair.

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

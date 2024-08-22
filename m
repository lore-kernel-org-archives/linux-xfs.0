Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85D7F1CC151
	for <linux-xfs@vger.kernel.org>; Thu, 22 Aug 2024 14:43:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724337813; cv=none; b=b3dNBKF/gByKd6Z7+dKchXJdB2amWdI+RH+kcbX3Zwa0fOtd1tS4uFcdTy3cACp+XkwCGFZvIvHRBJV1VSHrygrvBczYPmrx7hoE9l7Yt7o2Nugr70/priZGqOUjNqX1x6NxVWPSbpC+jgp592HGLahkkUMCTWb9LkdCEltOutk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724337813; c=relaxed/simple;
	bh=CnskYCyzEZqOP6saLcifTRlLp+k961zQ/ECKT1nG6fA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=qMzLv4Johs7Wwtc9XDsjpVKHEN1+BFSUFoCDty1NczOiMlKkJh7cDhcdKR3KlrFHbstSZLvgrfAMck+6/O08GnS8NFO2Sd4TGem4vaXHo6OtCe+wGI16SzEyn9AI6xxpOreShYBVUpqWl98Phiy2lCl+NtIp80c/ofvqln9tAyI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=EQmfffJz; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="EQmfffJz"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1724337810;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=OU4n9rOOEq1xDdw7y5sS73yDKdKzZct4WLyBIkmSXng=;
	b=EQmfffJzffCDEoQTQp+9BiaPfFbUMvG/+HBbpFxonmYt5k5iLJFyO6qvzZGMjuV5fCuJma
	7CwSCl09mitQsuwW66fjsruAKXoGSKQs9UxKlkTh3yXKSpMfOSKzLjibQhkG/fUDG6B+8B
	wwBsZ0rWMReVNnSFJDvDBTOewx++TwY=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-610-utNSIiw1NNaHLzwfZgZpVQ-1; Thu,
 22 Aug 2024 10:43:27 -0400
X-MC-Unique: utNSIiw1NNaHLzwfZgZpVQ-1
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C28311955F42;
	Thu, 22 Aug 2024 14:43:25 +0000 (UTC)
Received: from bfoster.redhat.com (unknown [10.22.33.147])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 76A0A19560A3;
	Thu, 22 Aug 2024 14:43:24 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
To: fstests@vger.kernel.org
Cc: linux-xfs@vger.kernel.org,
	djwong@kernel.org,
	josef@toxicpanda.com,
	david@fromorbit.com
Subject: [PATCH 0/3] fstests/fsx: test coverage for eof zeroing
Date: Thu, 22 Aug 2024 10:44:19 -0400
Message-ID: <20240822144422.188462-1-bfoster@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

Hi all,

One of the questions that came up on the last round of review on dealing
with the iomap zeroing problem [1] was having some proper test coverage.
When looking back at some of my custom tests, I realized some relied on
delay injection hacks, and otherwise felt like a random collection of
command sequences and whatnot that were probably somewhat duplicative.

Rather than adding fstests that continuously add random sequences of
xfs_io commands to try and test for zeroing problems, I started playing
around with fsx and came up with this series. In a nutshell, this does
intentional post-eof writes (to the eof page, via mapped writes) for
operations that are otherwise expected to perform partial page zeroing.
This allows the existing post-eof and unexpected data checks in fsx to
detect problems as normal. In my initial tests, this reproduces both the
truncate (already fixed) and write extension problems related to iomap
zero range fairly quickly on XFS.

It also produces zeroing issues on other non-iomap filesystems (ext4,
btrfs, bcachefs), which I suspect is something that probably needs to be
fixed on a per-fs basis. To test fsx itself, this so far seems to run
reliably longer term on XFS with the corresponding iomap zero range fix
in place.

Patch 1 is refactoring prep, patch 2 enables the eof data write
mechanism, and patch 3 adds a new fstests test to use it. The test
currently only supports XFS due to the aforementioned issues, but the
idea is to remove the restriction as other fs' are fixed. Thoughts,
reviews, flames appreciated.

Brian

[1] https://lore.kernel.org/linux-fsdevel/20240718130212.23905-1-bfoster@redhat.com/

Brian Foster (3):
  fsx: factor out a file size update helper
  fsx: support eof page pollution for eof zeroing test coverage
  generic: test to run fsx eof pollution

 ltp/fsx.c             | 129 +++++++++++++++++++++++++++++++-----------
 tests/generic/362     |  27 +++++++++
 tests/generic/362.out |   2 +
 3 files changed, 126 insertions(+), 32 deletions(-)
 create mode 100755 tests/generic/362
 create mode 100644 tests/generic/362.out

-- 
2.45.0


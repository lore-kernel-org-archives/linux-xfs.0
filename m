Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54653241695
	for <linux-xfs@vger.kernel.org>; Thu, 16 Oct 2025 18:58:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760641131; cv=none; b=FNiwkbm2dubqtLUvI/IuktJnNSF0sWp1caqfrJVodUUpBAsZ6mywzu5ExH2NRNcqNSQzMHd17V4lintZsC9scuiMJHiX3Z2cn5LvD1EhD8n6qj4hvdKmYwrcTdhnL+ZonTq366dH3mcgR1nW0P0saC/vSjurCqoynNcfrKtLzMc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760641131; c=relaxed/simple;
	bh=YT4/gLrVVH+gsP3u2nMRhIFWzwtDPemMZ4ONnGjaVGA=;
	h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type; b=LHw7bfKlztRcBgO3CSVr7jzeEkFpwKBXTsKG85aW8Ss2Ew0h0mWF/c2lgmA9RlifiqL1UitFrVbl4O9b2Q4UZBb9jjSAljA6hoNRnQg+qwdigHJ3Rweeu68FD9K9RrJ+bb4WVAakJmi59lkfYKinKOuejw0z0BXgIr6woKZj8mM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=LJgPC5CI; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="LJgPC5CI"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1760641128;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=OzPX3lW8vqrNQb7NmlkzBTj8ETamZDMo0KjBuBi+VMs=;
	b=LJgPC5CId0iZMN1R4cYpDNr4fmsYRtq7YCfK/dGqgkwSmbls9TR2vShl0UhIDHwNTaT7RV
	dckaDFMqU3ZGaSXbWkjrS9b0zfZ25i6O5OFtOok3djf5Ac7lW9dEAEw+E6Bnv+uuuQEqoo
	dNSKCBkWGRqNodrRjdorvxrlGa2SxWY=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-224-F2D5sFA1OOqgzpKjoLwUIQ-1; Thu,
 16 Oct 2025 14:58:44 -0400
X-MC-Unique: F2D5sFA1OOqgzpKjoLwUIQ-1
X-Mimecast-MFC-AGG-ID: F2D5sFA1OOqgzpKjoLwUIQ_1760641124
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E30BD18002F7;
	Thu, 16 Oct 2025 18:58:43 +0000 (UTC)
Received: from bfoster.redhat.com (unknown [10.22.65.116])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 634D11956056;
	Thu, 16 Oct 2025 18:58:43 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
To: linux-fsdevel@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: [PATCH 0/6] iomap, xfs: improve zero range flushing and lookup
Date: Thu, 16 Oct 2025 15:02:57 -0400
Message-ID: <20251016190303.53881-1-bfoster@redhat.com>
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

Now that the folio_batch bits are headed into -next here is the next
phase of cleanups. Most of this has been previously discussed at one
point or another. Zhang Yi had reported a couple outstanding issues
related to the conversion of ext4 over to iomap. One had to do with the
context of the folio_batch dynamic allocation and another is the flush
in the the non-unwritten mapping case can cause problems.

This series attempts to address the former issue in patch 1 by using a
stack allocated folio_batch and iomap flag, eliminating the need for the
dynamic allocation. The non-unwritten flush case only exists as a
band-aid for wonky XFS behavior, so patches 2-6 lift this logic into XFS
and work on it from there. Ultimately, the flush is relocated to insert
range where it appears to be needed and the iomap begin usage is
replaced with another use of the folio batch mechanism.

This has survived testing so far on XFS in a handful of different
configs and arches. WRT patch 3, I would have liked to reorder the
existing insert range truncate and flush in either direction rather than
introduce a new flush just for EOF, but neither seemed obviously clean
enough to me as I was looking at it with the current code factoring. So
rather than go back and forth on that on my own I opted to keep the
patch simple to start and maybe see what the folks on the XFS list
think.

Note that this applies on top of the pending folio_batch series [1].
Thoughts, reviews, flames appreciated.

Brian

[1] https://lore.kernel.org/linux-fsdevel/20251003134642.604736-1-bfoster@redhat.com/

Brian Foster (6):
  iomap: replace folio_batch allocation with stack allocation
  iomap, xfs: lift zero range hole mapping flush into xfs
  xfs: flush eof folio before insert range size update
  xfs: look up cow fork extent earlier for buffered iomap_begin
  xfs: only flush when COW fork blocks overlap data fork holes
  xfs: replace zero range flush with folio batch

 fs/iomap/buffered-io.c | 49 +++++++++++++--------
 fs/iomap/iter.c        |  6 +--
 fs/xfs/xfs_file.c      | 17 ++++++++
 fs/xfs/xfs_iomap.c     | 98 +++++++++++++++++++++++++++++-------------
 include/linux/iomap.h  |  8 +++-
 5 files changed, 125 insertions(+), 53 deletions(-)

-- 
2.51.0


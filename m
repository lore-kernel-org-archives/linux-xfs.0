Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C71F13AA26
	for <linux-xfs@vger.kernel.org>; Thu, 18 Jul 2024 13:01:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721307698; cv=none; b=YCCqrccdPOQO2mfrEqr2Bcz2sm0k6DXDJ8E24u6qUn1m5WSHKP+cKtw8HA8DqexP6pNXSoljhhtk/9Z0NQtMLoU/h7ouUkprhIl9s4ubMRJNU7ThrdnIg4ekdya1Y/439ypDhBNKV5nAHNSItCMxM6GlDw7J7Sf8f4TmVBQpqGo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721307698; c=relaxed/simple;
	bh=44eKkADUZLTHdOk3vfRVVa/sjhepUi7G73DNE1Ui/zU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=uioFaKcEY88j4Fmu/WRAUvw7s6Io+1SDKfg/vLbxIiVJq6dZvcU8Dgw8RsSbuhvfrYNbXWiIhziWM0atZo6NsVg0LGvEymoWk7LbnpYiusjhqC6f7QigLGv20QrzKtdmd2cZMPbbWRzlwSKZpHCQ/1sIbBz5gWxSHmh24OVuQck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Uq+L6v/H; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Uq+L6v/H"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1721307695;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=3V+PXHSFTyeo6sWREIhFwcbZRHc4HxgVv7/AuNwulEI=;
	b=Uq+L6v/HM23OOejRBzVuwmDKTrZ+PP9nyUqENHpFddlGLhzVYO0qlfjs87rHzdhmJOq1CH
	oZkBPYB/+hRF+H14xsOx/k5dsLtngKT3wf4twibmuzcgkKpfWohp4pBcarVoZOZ+ZLtvt7
	y9haqsvwejxeCkiQuaDowuVJiVIRitw=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-64-xFF67-MjO-aQYm0ORU9Ngw-1; Thu,
 18 Jul 2024 09:01:31 -0400
X-MC-Unique: xFF67-MjO-aQYm0ORU9Ngw-1
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 5C9761955F66;
	Thu, 18 Jul 2024 13:01:27 +0000 (UTC)
Received: from bfoster.redhat.com (unknown [10.22.16.39])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 577671955F68;
	Thu, 18 Jul 2024 13:01:26 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-xfs@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH RFC 0/4] iomap: zero dirty folios over unwritten mappings on zero range
Date: Thu, 18 Jul 2024 09:02:08 -0400
Message-ID: <20240718130212.23905-1-bfoster@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

Hi all,

This is a stab at fixing the iomap zero range problem where it doesn't
correctly handle the case of an unwritten mapping with dirty pagecache.
The gist is that we scan the mapping for dirty cache, zero any
already-dirty folios via buffered writes as normal, but then otherwise
skip clean ranges once we have a chance to validate those ranges against
races with writeback or reclaim.

This is somewhat simplistic in terms of how it scans, but that is
intentional based on the existing use cases for zero range. From poking
around a bit, my current sense is that there isn't any user of zero
range that would ever expect to see more than a single dirty folio. Most
callers either straddle the EOF folio or flush in higher level code for
presumably (fs) context specific reasons. If somebody has an example to
the contrary, please let me know because I'd love to be able to use it
for testing.

The caveat to this approach is that it only works for filesystems that
implement folio_ops->iomap_valid(), which is currently just XFS. GFS2
doesn't use ->iomap_valid() and does call zero range, but AFAICT it
doesn't actually export unwritten mappings so I suspect this is not a
problem. My understanding is that ext4 iomap support is in progress, but
I've not yet dug into what that looks like (though I suspect similar to
XFS). The concern is mainly that this leaves a landmine for fs that
might grow support for unwritten mappings && zero range but not
->iomap_valid(). We'd likely never know zero range was broken for such
fs until stale data exposure problems start to materialize.

I considered adding a fallback to just add a flush at the top of
iomap_zero_range() so at least all future users would be correct, but I
wanted to gate that on the absence of ->iomap_valid() and folio_ops
isn't provided until iomap_begin() time. I suppose another way around
that could be to add a flags param to iomap_zero_range() where the
caller could explicitly opt out of a flush, but that's still kind of
ugly. I dunno, maybe better than nothing..?

So IMO, this raises the question of whether this is just unnecessarily
overcomplicated. The KISS principle implies that it would also be
perfectly fine to do a conditional "flush and stale" in zero range
whenever we see the combination of an unwritten mapping and dirty
pagecache (the latter checked before or during ->iomap_begin()). That's
simple to implement and AFAICT would work/perform adequately and
generically for all filesystems. I have one or two prototypes of this
sort of thing if folks want to see it as an alternative.

Otherwise, this series has so far seen some light regression and
targeted testing. Patches 1-2 are factoring dependencies, patch 3
implements the main fix, and patch 4 drops the flush from XFS truncate.
Thoughts, reviews, flames appreciated.

Brian

Brian Foster (4):
  filemap: return pos of first dirty folio from range_has_writeback
  iomap: refactor an iomap_revalidate() helper
  iomap: fix handling of dirty folios over unwritten extents
  xfs: remove unnecessary flush of eof page from truncate

 fs/iomap/buffered-io.c  | 81 ++++++++++++++++++++++++++++++++++-------
 fs/xfs/xfs_iops.c       | 10 -----
 include/linux/pagemap.h |  4 +-
 mm/filemap.c            |  8 ++--
 4 files changed, 75 insertions(+), 28 deletions(-)

-- 
2.45.0


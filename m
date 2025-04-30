Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBE6E265CCB
	for <linux-xfs@vger.kernel.org>; Wed, 30 Apr 2025 18:58:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746039488; cv=none; b=tdJKaCwDc2URCf/LBewgm4DjFOswoOSx87R9dgnIzwiO1zo8h3TYA/ST8v2a90js1j920Yx10LBmLGsEG610B3C61SUZJWGBf7peQapcLQU3Rmt/z/pSRhNER1qN6GUpcdfqWfiutNwO9IigbRukdRjLbze+Cmtf9CbvAionnjs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746039488; c=relaxed/simple;
	bh=eBaEQA0UyoS8kK9Ez/9RCxaO9hajAsolzMIuBWbSVVU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=skojnJCqxDmillRtAAwVSt/cbVLmAsQZty9VFgktUaKZK72sylHmlGn/fW5bB9jwOwv77TYRa3rmg++1HE3Yw5DijrSWoXlk8EcnACsH/Vm6/TrczPXxMmYrfx6Lg4oYIEbXvsSAonoiDkory0XkmCZf9Wd02LMbxliTyMYGnfw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Bn0JAD87; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Bn0JAD87"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1746039485;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=Xq/7u0jVPnqvzv9Lfllxn0qSSjIMEL2U1XB6M2M4T8o=;
	b=Bn0JAD87JhrtmayF4kkMjYS8jEqeacZS6BHObO6XNT+WMUaPBDoFZAA4xO2AMxTkP+LCrU
	CCEGoAw4EiKm1VmIT/ZMgEWMEzuv1Ur38wo+uNWSQ53RjLnUWGl8zlMWByrOOkU8mL9zmg
	PLEEfSV09TtWVMmOe538Xb90wefJgO8=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-622-FRmP50MGMBS03tnmbkPoSg-1; Wed,
 30 Apr 2025 14:58:00 -0400
X-MC-Unique: FRmP50MGMBS03tnmbkPoSg-1
X-Mimecast-MFC-AGG-ID: FRmP50MGMBS03tnmbkPoSg_1746039480
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E0F24195608B;
	Wed, 30 Apr 2025 18:57:59 +0000 (UTC)
Received: from bfoster.redhat.com (unknown [10.22.64.112])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 61DCC19560A3;
	Wed, 30 Apr 2025 18:57:59 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 0/6] iomap: misc buffered write path cleanups and prep
Date: Wed, 30 Apr 2025 15:01:06 -0400
Message-ID: <20250430190112.690800-1-bfoster@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40

Hi all,

Here's a bit more fallout and prep. work associated with the folio batch
prototype posted a while back [1]. Work on that is still pending so it
isn't included here, but based on the iter advance cleanups most of
these seemed worthwhile as standalone cleanups. Mainly this just cleans
up some of the helpers and pushes some pos/len trimming further down in
the write begin path.

The fbatch thing is still in prototype stage, but for context the intent
here is that it can mostly now just bolt onto the folio lookup path
because we can advance the range that is skipped and return the next
folio along with the folio subrange for the caller to process.

Thoughts, reviews, flames appreciated.

Brian

[1] https://lore.kernel.org/linux-fsdevel/20241213150528.1003662-1-bfoster@redhat.com/

Brian Foster (6):
  iomap: resample iter->pos after iomap_write_begin() calls
  iomap: drop unnecessary pos param from iomap_write_[begin|end]
  iomap: drop pos param from __iomap_[get|put]_folio()
  iomap: helper to trim pos/bytes to within folio
  iomap: push non-large folio check into get folio path
  iomap: rework iomap_write_begin() to return folio offset and length

 fs/iomap/buffered-io.c | 92 ++++++++++++++++++++++++------------------
 1 file changed, 53 insertions(+), 39 deletions(-)

-- 
2.49.0


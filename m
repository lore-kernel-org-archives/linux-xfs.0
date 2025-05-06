Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 523E728136C
	for <linux-xfs@vger.kernel.org>; Tue,  6 May 2025 13:38:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746538694; cv=none; b=b6+lTeO2vNIuYa0ewPc5LzdkQw2qmabH5/7wzbSKKLJC37NVbfbmInpW4A+UixunUTsCXZQRln7zwQUp0D/EOcHoPtT/RzzrLoStzPqmhv7FCM05qeBUEjQNg90WG4Og9dQ6EuGwee77pUeqBJYx2tqqLTprcZOgu8KWZkq0hT4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746538694; c=relaxed/simple;
	bh=YUwIk/MUgZVDImrx7CL0rOp1pojouNJ/5zWviwTHO3c=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=RrP95QhljTCMU9U49yvJqTUoC8V7rdsYz4ZCXuS11OpcXyqknL2ZmE4iXn6NmYzs+gxqdXoYBVp8h5pbH8aWJ1X1ACRmC9s5Yl4CnVxTWzvWazUBGZf9AD/uBqYfzubeMF2RUhj7DxhPxqEMXLzvTo2ULEHWdb7odrnxfjICAYo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=AyUw/U3R; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="AyUw/U3R"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1746538692;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=FRDlHq9OYFR2plyoy4p/CDyb6oeH08x28ypDYsNxI+g=;
	b=AyUw/U3RsXJsd0zAZDet2YGMYzWOg+bPLpbMvKLXQlYp8rMVvpiVt7i9qR80pA3ELu4n4r
	+9o6fUspFxKO5ehT2/GUy05hBSAnp+YKzWQ8KYXO9P6mNdSyin4cpepjBbmhZHGQjzduF0
	+UCnWvaPmBh2gfj61knVF+nAUZEn6vU=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-360-JKduOJfVOT-xafKeiTQrng-1; Tue,
 06 May 2025 09:38:08 -0400
X-MC-Unique: JKduOJfVOT-xafKeiTQrng-1
X-Mimecast-MFC-AGG-ID: JKduOJfVOT-xafKeiTQrng_1746538686
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7BBF51955D52;
	Tue,  6 May 2025 13:38:06 +0000 (UTC)
Received: from bfoster.redhat.com (unknown [10.22.64.112])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 8A8F419560A3;
	Tue,  6 May 2025 13:38:05 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-xfs@vger.kernel.org,
	djwong@kernel.org,
	hch@infradead.org
Subject: [PATCH v2 0/6] iomap: misc buffered write path cleanups and prep
Date: Tue,  6 May 2025 09:41:12 -0400
Message-ID: <20250506134118.911396-1-bfoster@redhat.com>
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

v2:
- Split up warning in trim folio range helper.
- Use min() and min_not_zero() instead of open coding.
- Drop pos param from __iomap_write_begin() (folded into patch 6).
v1: https://lore.kernel.org/linux-fsdevel/20250430190112.690800-1-bfoster@redhat.com/

Brian Foster (6):
  iomap: resample iter->pos after iomap_write_begin() calls
  iomap: drop unnecessary pos param from iomap_write_[begin|end]
  iomap: drop pos param from __iomap_[get|put]_folio()
  iomap: helper to trim pos/bytes to within folio
  iomap: push non-large folio check into get folio path
  iomap: rework iomap_write_begin() to return folio offset and length

 fs/iomap/buffered-io.c | 100 ++++++++++++++++++++++++-----------------
 1 file changed, 58 insertions(+), 42 deletions(-)

-- 
2.49.0


Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F1DC83CDA
	for <linux-xfs@vger.kernel.org>; Wed, 28 Aug 2024 18:18:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724869099; cv=none; b=dlLPOdbNZN0Yk/DoVx8D95jAmM44OsyGtS2GFvH0JGlZckPgp3zdSjArH9USSmELyJqvY8pLZ8e3N0cjlWPAH9Atx9YJwY/Tj2HmOHTLOPI1aU0IiRntBGf7+7dz9cjm5dnT1Z1tNNoEu9zhDqJruGxtJOv5MAG4sBC32Rb5gqU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724869099; c=relaxed/simple;
	bh=ub2PtdbzkWqTScAykiG/y9W2Vj98b3VxBXrnlRuY5ww=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=GdsoGPC/cLNGkCgMU5XIGG+R/C16g1bDiVP+PEIJMOQOOa05AF5SpG1BUSwL2tlXKd1LYCwZsbSydPiCMqsLkLOa03OdHivFmdYF2y++xewg+5g9WO01sB35t+LWCRPpGLvWo148uB0V+4i0VndIyKw7+fuCy6f9LWOpNxdlGhI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=cV4QTtgd; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cV4QTtgd"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1724869096;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=8f5jiKMPEzVZfu8sCcA3fPqiZFgd2OyHSIN7R3dj5Tk=;
	b=cV4QTtgdrQdqCuddfch8U+HMhchO1FlJEDpk7SGhcHtwpxorV5NgO1V2yA/KuDoPQCamf0
	MQy2OqDt3NsAk295s7V0Ukn400OZDfeV5PR07kvuwosAkaDuvo+mN0/c7nX1FVc9xAokBF
	J+VKNvNYpu2BrsL6uT6DcZe8tpaR5eA=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-287-TOJ04gWaNf-9P2rGx4YA0w-1; Wed,
 28 Aug 2024 14:18:13 -0400
X-MC-Unique: TOJ04gWaNf-9P2rGx4YA0w-1
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C7CCC1955BEF;
	Wed, 28 Aug 2024 18:18:11 +0000 (UTC)
Received: from bfoster.redhat.com (unknown [10.22.16.95])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 8B90A1955D64;
	Wed, 28 Aug 2024 18:18:10 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-xfs@vger.kernel.org,
	djwong@kernel.org,
	josef@toxicpanda.com,
	david@fromorbit.com
Subject: [PATCH v2 0/2] iomap: flush dirty cache over unwritten mappings on zero range
Date: Wed, 28 Aug 2024 14:19:09 -0400
Message-ID: <20240828181912.41517-1-bfoster@redhat.com>
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

Here's v2 of the iomap zero range flush fixes. No real changes here
other than a comment update to better explain a subtle corner case. The
latest version of corresponding test support is posted here [1].
Thoughts, reviews, flames appreciated.

Brian

[1] https://lore.kernel.org/fstests/20240828181534.41054-1-bfoster@redhat.com/

v2:
- Update comment in patch 2 to explain hole case.
v1: https://lore.kernel.org/linux-fsdevel/20240822145910.188974-1-bfoster@redhat.com/
- Alternative approach, flush instead of revalidate.
rfc: https://lore.kernel.org/linux-fsdevel/20240718130212.23905-1-bfoster@redhat.com/

Brian Foster (2):
  iomap: fix handling of dirty folios over unwritten extents
  iomap: make zero range flush conditional on unwritten mappings

 fs/iomap/buffered-io.c | 57 +++++++++++++++++++++++++++++++++++++++---
 fs/xfs/xfs_iops.c      | 10 --------
 2 files changed, 53 insertions(+), 14 deletions(-)

-- 
2.45.0


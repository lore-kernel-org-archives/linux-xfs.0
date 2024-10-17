Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFF361DED57
	for <linux-xfs@vger.kernel.org>; Thu, 17 Oct 2024 16:32:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729182772; cv=none; b=X6kaH1bXr1cxthIOaB5Wh9gpdY6oJ1gpCRRRnx8kNl/9zvhO/hfgzZUoiysyhltgI9UzTmUy/1B5RGvfXxXZAARbZblAh8A9Ryi0tzBdcv9DCSm9vKDdsQMH9oE3i7ExV2gIu72ljyQ685mEfhBAzmmD0r4TobwqXC+XuDe5JBs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729182772; c=relaxed/simple;
	bh=ptD+kQ216mfK6QXzZo+vXhvs2J9P25LJLfLA6kDD5Hk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=RJw9w1E1FPvj01lInWnmZwpGEe6vb43+Twl39zrCjSoLdqtu4LlwWKVJ7dcCOntrw/MiSqUPJPiUR1SzCTCnTY9zl80Ek+4SX9Wg6diuPC0bu/uAwp/GA4prpNbkW/xneICzSP7Zty+/WCtKDYJBkUlWf+kEVfnrHrrthO24X+c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Xc208ALL; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Xc208ALL"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1729182769;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=oSEgV58v8Kdb9BEzqVHTfVU0Xoy6mhli+NutDSc3M/Y=;
	b=Xc208ALLeBaVrvDwsmrchABRLReuJDl48U7Cr4ONVTdFG9Pg96Eu+wz0+ezI16O37PGwPH
	pWEeIF9uFqYqV0KA1iLhCK18Row8eWtoFEsRvij/1WtVf8EhdoHJqJXzBPGsmhi+rpp1wN
	SRuPF7zz2aRp66lErLWsStTUeIvPjqE=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-552-O-7pnhV6OW6-C44yADSWPA-1; Thu,
 17 Oct 2024 12:32:46 -0400
X-MC-Unique: O-7pnhV6OW6-C44yADSWPA-1
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C6EF61955EE8;
	Thu, 17 Oct 2024 16:32:44 +0000 (UTC)
Received: from bfoster.redhat.com (unknown [10.22.64.30])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 6D15E1956086;
	Thu, 17 Oct 2024 16:32:43 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
To: fstests@vger.kernel.org
Cc: linux-xfs@vger.kernel.org,
	djwong@kernel.org,
	hch@lst.de
Subject: [PATCH 0/2] fstests/xfs: a couple growfs log recovery tests
Date: Thu, 17 Oct 2024 12:34:03 -0400
Message-ID: <20241017163405.173062-1-bfoster@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15

Hi all,

This is first pass of a growfs crash and log recovery test I cooked up
for XFS. A bit more background and context on this is available here
[1]. In short, this reproduces at least a couple log recovery issues on
XFS related to growfs that Christoph has tracked down and resolved.
Darrick proposed a simple realtime variant in the discussion at [1], so
patch 2 is a stab at that. It's basically just a copy of patch 1 with
some rt related tweaks. However..

Darrick,

I believe you reproduced a problem with your customized realtime variant
of the initial test. I've not been able to reproduce any test failures
with patch 2 here, though I have tried to streamline the test a bit to
reduce unnecessary bits (patch 1 still reproduces the original
problems). I also don't tend to test much with rt, so it's possible my
config is off somehow or another. Otherwise I _think_ I've included the
necessary changes for rt support in the test itself.

Thoughts? I'd like to figure out what might be going on there before
this should land..

Brian

[1] https://lore.kernel.org/fstests/20240910043127.3480554-1-hch@lst.de/

Brian Foster (2):
  xfs: online grow vs. log recovery stress test
  xfs: online grow vs. log recovery stress test (realtime version)

 tests/xfs/609     | 69 +++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/609.out |  7 +++++
 tests/xfs/610     | 71 +++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/610.out |  7 +++++
 4 files changed, 154 insertions(+)
 create mode 100755 tests/xfs/609
 create mode 100644 tests/xfs/609.out
 create mode 100755 tests/xfs/610
 create mode 100644 tests/xfs/610.out

-- 
2.46.2


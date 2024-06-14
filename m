Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE98C200A9
	for <linux-xfs@vger.kernel.org>; Fri, 14 Jun 2024 16:07:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718381232; cv=none; b=sMoxDABFzUfOkW3vD529nu13FjzQe9GIOYlVJJp0QonK5XqaCzVLAXWXLTzvteZugXVeWyh6ZAOjw5rO1Q0nnZsxFmlW0dVpSuJBeLqwqTX6PB+aE1SxTo0oXEDksc1aSxS69FuJzJ9KqLyNzkDxsDv/IEwPAJHuaqQzXfAPpns=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718381232; c=relaxed/simple;
	bh=yPdm9SrMJJJG4Zof76A1c1UkLvBAsV9BHFBpHK5G3gA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=mF56JLFGvd5VR7ab4BsB8N+Ee1sMuh8DU8VcsQotFj+EUAQwMBMdBkzMqVjkKZSwG6vhPBjFg7u/PAOpR4lE278HdjStkCSgrmpV1KaiYT3w+xBNsgW3h/KG2JDpiwpNMtpNddhtyW2XXmRnIUUxLd1LImEvpsPgF+9qiX8+uBo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=TaMSxY3/; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="TaMSxY3/"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1718381229;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=5qVFx2DmEPTRSQwzV2GyNAvD4rzZKCUj6KutWom9zl8=;
	b=TaMSxY3/Xe4OaZ0PJLaKeq4UaKnEIrOnnZK2L4Pv023DIKuG5y9+3vb8CndJtdK7UKLSGl
	Mp3w+y43jqRDTZY6HG7R/iflTZXyV4S5/daU3aNMWFFSyLXn+9KOlnNDZ8f0g9qMYF/+IE
	n+G+oxlQ0zSSxBwHoFGaI5S9+3n2Alo=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-274-iCkZGD15OTGhquxzunPLRg-1; Fri,
 14 Jun 2024 12:07:08 -0400
X-MC-Unique: iCkZGD15OTGhquxzunPLRg-1
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 817DD1956058
	for <linux-xfs@vger.kernel.org>; Fri, 14 Jun 2024 16:07:07 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.22.34.24])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 493541955E72;
	Fri, 14 Jun 2024 16:07:06 +0000 (UTC)
From: Bill O'Donnell <bodonnel@redhat.com>
To: linux-xfs@vger.kernel.org
Cc: cmaiolino@redhat.com,
	Bill O'Donnell <bodonnel@redhat.com>
Subject: [PATCH v3 0/4] xfsprogs: coverity fixes
Date: Fri, 14 Jun 2024 11:00:12 -0500
Message-ID: <20240614160643.1879156-1-bodonnel@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

Select fixes made following coverity scan results on 04/23/2024.
CID: 1596597, 1596598, 1596599, 1596600, 159660

Signed-off-by: Bill O'Donnell <bodonnel@redhat.com>
---
v3: use %lld instead of %ld and cast howlong to (long long) in PATCH 3/4.
v2: initialize automatic struct ifake to 0 at declaration instead of
    setting individual member if_levels to 0.
---


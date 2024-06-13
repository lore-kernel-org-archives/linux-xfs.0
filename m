Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD7511494C4
	for <linux-xfs@vger.kernel.org>; Thu, 13 Jun 2024 21:19:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718313594; cv=none; b=lqLgxgCKS0YS1bjZcwKN9CbIaNF6kqtalZ8closOelFejtPx9BJTBHIDHi8CCOLtqZ/I1ESVx4VD+c8tZLDGewQDzygI6V8/RgmwG+MCJuyUvTESD/Hv+Cs/tmPAJUxMhpzjGxl9lAeFFTfHUdi1hGoNyZxP52ENwgaJS1HKN2I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718313594; c=relaxed/simple;
	bh=VQztX74q+ToUUwdGG8B4b92uxfQyaJxS+aF44OVxW5Q=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=jGuTzM/NMEShqcbrdMe+M2s1mSIogFB/k3yohcJEwHP57yOdF8XgKofHNDt2fPBIDz5LV7UQkLBtjJCKmdMJ1SOVZ34+CEMGl/RatE1QMaNvoNCYl6xTtK1TqHDid+xCFedxxj5JSKFC5NVKD8F822kP67yPp+Zlc1jVyT5/7P0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=eWiTl1CL; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="eWiTl1CL"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1718313591;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=uhdYlh0UkvTEtwJNixfGbgO0U8uFHBG7j9aGm0PO48Y=;
	b=eWiTl1CLeoV46FAAwmy57gDbz+QP75gwppl2Jdtp3a2Mch8dQaWNlSC53XRl6+nU3SwwWb
	B1QOUAMbwTUDGNsm0fUBMmtMC4NiYly/R2pEaSRU66AQuDt0I4DtOvtF0XWKVSYkvEnMqv
	R7PSU84UyThWOq1zb3x5hnmrnpxqdaY=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-659-LwK09vKtNV6_CMBrhi3_4g-1; Thu,
 13 Jun 2024 17:19:50 -0400
X-MC-Unique: LwK09vKtNV6_CMBrhi3_4g-1
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 50A3219560B7
	for <linux-xfs@vger.kernel.org>; Thu, 13 Jun 2024 21:19:48 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.22.34.24])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 493CC1956050;
	Thu, 13 Jun 2024 21:19:47 +0000 (UTC)
From: Bill O'Donnell <bodonnel@redhat.com>
To: linux-xfs@vger.kernel.org
Cc: cmaiolino@redhat.com,
	Bill O'Donnell <bodonnel@redhat.com>
Subject: [PATCH v2 0/4] xfsprogs: coverity fixes
Date: Thu, 13 Jun 2024 16:09:14 -0500
Message-ID: <20240613211933.1169581-1-bodonnel@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

Select fixes made following coverity scan results on 04/23/2024.
CID: 1596597, 1596598, 1596599, 1596600, 159660

Signed-off-by: Bill O'Donnell <bodonnel@redhat.com>
---
v2: initialize automatic struct ifake to 0 at declaration instead of
    setting individual member if_levels to 0.
---


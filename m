Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D49EB145B2F
	for <linux-xfs@vger.kernel.org>; Thu, 13 Jun 2024 18:18:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718302686; cv=none; b=J+lBv4g56eoHfcpwifMDjDOGYyBmeJ1LMNteTbxrp57eRXq/tT/BK9mWrDSuP04U0HdZc7biKfhAkcRzByHA4QENevEoCWaUJHtIBgxXs7VnmZAtj6kgk2w+0wjCRfez8/+nFcp9HHbMD+hlAaQXUysJctZYj+F66urqhY7iDG8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718302686; c=relaxed/simple;
	bh=yBIhm0A+6ksedyxVAC7fBT0nELuA91zc6FS/44fwBak=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=fQN0uq4mE96467jHklgBMN80vzndm40uR+2tEX8ixwVbg09wBOC6cYqeRVrke6OyOzKPDD0tGLLfW4rlygewJPqNigea5h6UzdOShJzARDKn++jd0bzrQyEiOc8FCgT0t6tG7r5lvpDvnI6PQmNryaSVU73Y3wySTthwhCKZJno=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=CB9BAYyj; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CB9BAYyj"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1718302683;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=yBIhm0A+6ksedyxVAC7fBT0nELuA91zc6FS/44fwBak=;
	b=CB9BAYyjo6je/WGuw5MACMD2xVG4qfDs4X+lmuv9XlQDdM5Oxtil0UMlB/7vByDVtWEiF4
	MItAKpzbD0jdxtSMXSYK7NhIyPgTy/bwAw3YkgyD/7/rhGegWny+0zsIHPbwTbjdpZ1TrY
	o8aThPBdxuMCA+udesWg74rYmGK0Yow=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-460-L4UirqKcOG6vdt5DbrbJ8w-1; Thu,
 13 Jun 2024 14:18:02 -0400
X-MC-Unique: L4UirqKcOG6vdt5DbrbJ8w-1
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 54C45195608A
	for <linux-xfs@vger.kernel.org>; Thu, 13 Jun 2024 18:18:01 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.22.34.24])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 522461956058;
	Thu, 13 Jun 2024 18:18:00 +0000 (UTC)
From: Bill O'Donnell <bodonnel@redhat.com>
To: linux-xfs@vger.kernel.org
Cc: cmaiolino@redhat.com,
	bodonnel@redhat.com
Subject: [PATCH 0/4] xfsprogs: coverity fixes
Date: Thu, 13 Jun 2024 13:07:04 -0500
Message-ID: <20240613181745.1052423-1-bodonnel@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

Select fixes made following coverity scan results on 05/23/2024.
CID: 1596597, 1596598, 1596599, 1596600, 1596603

Signed-off-by: <bodonnel@redhat.com>



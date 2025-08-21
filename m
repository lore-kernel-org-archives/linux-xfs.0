Received: from unicom145.biz-email.net (unicom145.biz-email.net [210.51.26.145])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6849D17BA3;
	Thu, 21 Aug 2025 05:56:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.51.26.145
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755755813; cv=none; b=LxraF4LkpYibgdM1PVBGS2M5vEK7jXGGJyVAC98MEgt2glRCEGH+og0p9OYEofjWkPSMXmIZkfZPYGWLsxv+DzzHvefFU9RS5vOZ3Eil2MZFxd27eBvolnM4i/aI2gLRJnP2KMcteyjcv4zclqF+2Ame9SD3X/GKfANaMuYmlEY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755755813; c=relaxed/simple;
	bh=u+naIwJRv/P1JexjaegzYYWrQG0ap9+JnttS0myNNXM=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=OKyrU5Ceqv4Mu6pSN/xV4ImlIsAM73mmK8L4e25/l9IlzpFbudo01KZbup7AKKK0RlUE9vfBuD1uiyRsl+IOyqYb5S3pz7L3qdeZemM736j7MEzMvYjzbIlFeU5yYVC8uJIlsO+FnXu5/xelnrsvGDHO5WmmTBskGbI3qG5msOg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=inspur.com; spf=pass smtp.mailfrom=inspur.com; arc=none smtp.client-ip=210.51.26.145
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=inspur.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=inspur.com
Received: from jtjnmail201606.home.langchao.com
        by unicom145.biz-email.net ((D)) with ASMTP (SSL) id 202508211355311966;
        Thu, 21 Aug 2025 13:55:31 +0800
Received: from localhost.localdomain.com (10.94.10.82) by
 jtjnmail201606.home.langchao.com (10.100.2.6) with Microsoft SMTP Server id
 15.1.2507.57; Thu, 21 Aug 2025 13:55:31 +0800
From: chuguangqing <chuguangqing@inspur.com>
To: Carlos Maiolino <cem@kernel.org>
CC: <linux-xfs@vger.kernel.org>, <linux-kernel@vger.kernel.org>, chuguangqing
	<chuguangqing@inspur.com>
Subject: [PATCH 0/1] fix  typo error in xfs comment
Date: Thu, 21 Aug 2025 13:54:15 +0800
Message-ID: <20250821055416.2009-1-chuguangqing@inspur.com>
X-Mailer: git-send-email 2.43.5
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
tUid: 2025821135532a9f6cfad76f4763800e593758c50706e
X-Abuse-Reports-To: service@corp-email.com
Abuse-Reports-To: service@corp-email.com
X-Complaints-To: service@corp-email.com
X-Report-Abuse-To: service@corp-email.com

The original comment contains two spelling mistakes: "attribute" is misspelled as "attibute", and "targeted" is misspelled as "targetted".

chuguangqing (1):
  xfs: fix typo in comment

 fs/xfs/libxfs/xfs_trans_resv.c | 2 +-
 fs/xfs/scrub/dirtree.c         | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

-- 
2.43.5


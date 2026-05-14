Received: from mx0.herbolt.com (mx0.herbolt.com [5.59.97.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F50041B345
	for <linux-xfs@vger.kernel.org>; Thu, 14 May 2026 14:38:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=5.59.97.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778769486; cv=none; b=FRmaoosMwk7PdTMwyZJQ6G6WmusXE3YQnMSaizbaIwyI6ms5viTeKrDrJOFJB7hEKPMMu9z87w33vnzUnj0rJb2q/ufcwqeb1PVpQ6fNruNpKza9CCMjAj45LVqLPpefn2rpaF2/PFteUXB35cSZ2cyY66mpchfhGTQYJQKBFVI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778769486; c=relaxed/simple;
	bh=uKUFuXsJlk7tgHywEBxk6AhExYiAnCDICBHdN+SwyMQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=fO4ZL0xSAKaXjE+1I6BrlUjhjemXbwuQIvGYDpV0NwddNhhwjbfQ0AoDcZ6X4Q/LMotkI/WRj7wOLTWfTliJ4r91GjJrMFqcoj0fzAjnvQOMpRygoSu9g9ssC84pLQXrD8tpFrqS9OHn/+0SEclKtFUJKbx+OkJMxRI01Nzdk74=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=herbolt.com; spf=pass smtp.mailfrom=herbolt.com; arc=none smtp.client-ip=5.59.97.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=herbolt.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=herbolt.com
Received: from mx0.herbolt.com (localhost [127.0.0.1])
	by mx0.herbolt.com (Postfix) with ESMTP id 31806180F2D5;
	Thu, 14 May 2026 16:37:56 +0200 (CEST)
Received: from trufa.intra.herbolt.com.com ([172.168.31.30])
	by mx0.herbolt.com with ESMTPSA
	id CA8RA0TeBWpZsSoAKEJqOA
	(envelope-from <lukas@herbolt.com>); Thu, 14 May 2026 16:37:56 +0200
From: Lukas Herbolt <lukas@herbolt.com>
To: djwong@kernel.org,
	sandeen@sandeen.net,
	aalbersh@kernel.org
Cc: linux-xfs@vger.kernel.org,
	Lukas Herbolt <lukas@herbolt.com>
Subject: [RFC PATCH 0/1] Add default config file for mkfs.xfs
Date: Thu, 14 May 2026 16:37:16 +0200
Message-ID: <20260514143716.893814-2-lukas@herbolt.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi all,
The default values cannot always satisfy everybody and users/packagers should
be able to override defaults without the need of specifying configuration file
on command line. It was previously discussed in here [1]. 

The proposed patch adds /etc/mkfs.xfs.conf where the default values can be set.
It also lightly changes the default behavior for -l/-d/-r concurrency allowing 
now to be set to -1 to keep autodetection on SSDs.

[1]
https://lore.kernel.org/linux-xfs/84c8a5e5-938d-4745-996d-4237009c9cc5@sandeen.net/

Lukas Herbolt (1):
  xfsprogs: mkfs.xfs add default configuration file.

 include/builddefs.in |  1 +
 mkfs/Makefile        |  3 ++
 mkfs/mkfs.xfs.conf   | 50 ++++++++++++++++++++++++++++++
 mkfs/xfs_mkfs.c      | 72 +++++++++++++++++++++++++++++++++++++++-----
 4 files changed, 119 insertions(+), 7 deletions(-)
 create mode 100644 mkfs/mkfs.xfs.conf

-- 
2.54.0


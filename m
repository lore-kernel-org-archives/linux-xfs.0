Received: from mx0.herbolt.com (mx0.herbolt.com [5.59.97.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5ECEA3D567F
	for <linux-xfs@vger.kernel.org>; Mon, 25 May 2026 07:58:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=5.59.97.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779695909; cv=none; b=Yx79Bl/BQ6tJhb+BAQ6zTwNAXkQhc77lvMj7EhQ/7xtLH+0wENPtjISJPUQP5WIcYCLDpm4FYDKF8vU6izzWAV4K96UEmPepIbCPKE7KjT08ClmgXHtwuU+/NRApl91DftfCTkQNQt8xZ4v3IiPzAxHdfkyFsYfBVgrr7cue+IM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779695909; c=relaxed/simple;
	bh=E96gYITdIbOtyu1jmMQCncVO8y7R2xFwnJ+dWaBcQ38=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Wdb9lVhgdUVmMejLBsfKeYtILQPW510+Rh2z7wzagYLi4hZZFW20L3pNynup5pf0EfuLPq+SCDe37vAu7mNCQHQkEKVMn0gGwyoRrCRt5ZR2EUbVrp/kfcBmU9kLz+Gjc85uXCTMHEDs0I28yFdjCMbsL+KK1oy0QYZyAG3b78c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=herbolt.com; spf=pass smtp.mailfrom=herbolt.com; arc=none smtp.client-ip=5.59.97.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=herbolt.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=herbolt.com
Received: from mx0.herbolt.com (localhost [127.0.0.1])
	by mx0.herbolt.com (Postfix) with ESMTP id 264D1180F2D5;
	Mon, 25 May 2026 09:58:14 +0200 (CEST)
Received: from trufa.intra.herbolt.com.com ([172.168.31.30])
	by mx0.herbolt.com with ESMTPSA
	id rrOwOhUBFGoUrzcAKEJqOA
	(envelope-from <lukas@herbolt.com>); Mon, 25 May 2026 09:58:14 +0200
From: Lukas Herbolt <lukas@herbolt.com>
To: djwong@kernel.org,
	sandeen@sandeen.net,
	aalbersh@kernel.org,
	dgc@kernel.org
Cc: linux-xfs@vger.kernel.org,
	Lukas Herbolt <lukas@herbolt.com>
Subject: [RFC PATCH v2 0/5] Add option to use default config file.
Date: Mon, 25 May 2026 09:57:47 +0200
Message-ID: <20260525075752.4159504-1-lukas@herbolt.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,
Sending a v2 version trying to implement the changes suggested by 
Carlos, Darrick, Eric and Dave. The default.conf is not installed
automatically but there is simple example file.

The order is now build-time < default-file < command line settings.
Some values like uuid,sunit,swidth sector size and block size are not 
allowed to be set in the default config file and if set user is warned
about it and the value is reset to build-time default.

I moved setting of some values in cli_params and setting of mkfs_default_params
into new bld_dft struct as If I get it correctly we were basically setting
some of the default values on two places. It also  resulted in cleanup of
unused parameters from some validate_* functions. 


Lukas Herbolt (5):
  xfsprogs: mkfs.xfs Add buildtime default cli_params as global variable
  xfsprogs: mkfs.xfs add default configuration file.
  xfsprogs: mkfs.xfs add auto|autodetect value for -d/l/r concurrency
  xfs_admin: add -d option to manage default mkfs config file
  xfsprogs: mkfs.xfs clean up unused dft option in various validators

 .gitignore                           |   3 +
 db/Makefile                          |  11 +-
 db/{xfs_admin.sh => xfs_admin.sh.in} |  30 +++-
 include/builddefs.in                 |   1 +
 mkfs/Makefile                        |   2 +
 mkfs/default.conf.example            |  10 ++
 mkfs/xfs_mkfs.c                      | 240 +++++++++++++++++----------
 7 files changed, 207 insertions(+), 90 deletions(-)
 rename db/{xfs_admin.sh => xfs_admin.sh.in} (70%)
 create mode 100644 mkfs/default.conf.example

-- 
2.54.0


Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.222.175
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794478839;
	b=z1sMweJWEB3VdkUz51cUYiINZcG2Ifke61L1k2qWHE5+wcep8c9JYkjM4t28oco1OSGe
	 7KgSWcCJPeS7bdl7bnqwoXiCMAuh1Pkq46Kn3AqdB4dsYsevncG5kcdMvkMpn8QsKSmvr
	 H+JxgI9wtWzBL1wftoUBxUulBTcmraWYerOqknldPTs5L+iGWYI1cNXRcH4kR1oQuue/8
	 x9jwehX+FsRXk9I/OCDUHiI3x5YVzFDHye2emLFom4xdPDjY4iYTqKR3TuphXCIU6AQ8k
	 jsxWfzgoi/TrNex4zd+vX0/bWD1dGhcYt0lEFhMGH60XCDAjn9tFbhUF889K7HsuDpQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794478839;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=EF7KRxBo0qNjwVf72fb3/RBlZOqXFYYSTlSs7Me9Vk0=;
	b=s71c8rS2Ikv8slMvsoGmT4xfp1V0zeiUZ0631PTJHAw06nh+SCFsqJz7NHTh2plSrymX
	 L7INUWfbSr5ovApSvYaQ0TdznCorNNikDwiuRfas/RFGqE/6cWFN2Pl/P5QKbuu1vV83P
	 GRtBYSelEBGnRotUkflpZ75yLRdLnxXyIsQIJjv5dgod8Bdx5b5e5w5m+P97gZcN9DxkO
	 aySK+EJ3od1NjjLYs2twMwuJFcOfOhSsVySkfXSi4on6Vkd+d8rv9/s3PnOZSPG/sbgOA
	 SttjRfcv96lkYtQqKrPxs+UF/GebpZMxNTq1+JvuMOmzGm4yNS6N+m3yfhitDfdoyOA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=cs.unc.edu;
	spf=pass smtp.mailfrom=cs.unc.edu;
	dkim=pass header.d=cs.unc.edu header.i=@cs.unc.edu header.a=rsa-sha256 header.s=google header.b=BZ0kacbc;
	arc=none smtp.remote-ip=209.85.222.175
Received: from mail-qk1-f175.google.com (mail-qk1-f175.google.com [209.85.222.175])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F584606A32E
	for <linux-xfs@vger.kernel.org>; Thu, 12 Nov 2026 10:20:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4F584606A32E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=cs.unc.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cs.unc.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=cs.unc.edu header.i=@cs.unc.edu header.a=rsa-sha256 header.s=google header.b=BZ0kacbc
Received: by mail-qk1-f175.google.com with SMTP id af79cd13be357-930c0f9c1b1so426283985a.1
        for <linux-xfs@vger.kernel.org>; Thu, 12 Nov 2026 02:20:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cs.unc.edu; s=google; t=1794478837; x=1795083637; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=EF7KRxBo0qNjwVf72fb3/RBlZOqXFYYSTlSs7Me9Vk0=;
        b=BZ0kacbcCRVq6LBGBfa+HzANug4uNF5z0Lf8jwfzYrm1y6NYl9QHzLqnz9KNipWQWY
         nTZnUTi006r+tN2LBDLQNShf+oemvUPDqVuliBF+QIuyPx5oOqsuwbXLhOiC1CfSgcB1
         2Aq4jnAuQOsdy2mcuDvEVQRdXWpwVghQ7pJi24Uk7RGBGO1QiPHCslgbJpZ+IZwNNKCp
         mqOxnrecpPgEsRvQD3XCt57xznz7iMIvpw9KcteBARSdGVmxQJoLBvllPC2EEqBThiJ3
         laJ6SW7CT/viIhZGjKcCbeb4KTZAweFxs11Lo26Jpf3BVtEBCc7rSklk+mmRR4WLEk/0
         iilw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794478837; x=1795083637;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=EF7KRxBo0qNjwVf72fb3/RBlZOqXFYYSTlSs7Me9Vk0=;
        b=p14F3uMh3t5Q4vJB8RtMvQMC92s2FJDIEno+oMNN2EAOTn+pA6I586EiXsx2apJali
         Pj4HqVeBvkFPCqk2rdeZiCr2izzrVC0aEksfP4C1fGNp2N/MZVoGSOOBHtIm9Gj2ja0h
         rlVbzxp4aV3uHFFtEDAGuub9LnNVBfVg4a+wy6Y7uT6Bx0cqF78Aff7YoQ9FC/qjbtTI
         p+XyKTCtZttuDfJuQ+R4QwtYoDuGV5qrAtEBfLtCF1aUfammAMBHN4VgJ8YmWsbI9rqI
         gXC3tWd04ouJQU1bbxgPqAxp9DvXWfpzCAYN/R+gf+Luvx2EHuhjg1CNCt/8Gs7AMLr5
         GXDw==
X-Forwarded-Encrypted: i=1; AL+hErHqvGmntx89SxZsQczhf0hcb32EDUQC2oNzcvOqSdoFt0SjgCDmmeJSRBP7Os4okfhoBf93dFEgPNI=@vger.kernel.org
X-Gm-Message-State: APuU4Z8Q4fuCP0ECducVrDhHMBQVFbqFKKMV51r6O8O39B8vpMaP2kcK
	s22IgCAUWNgx8VLn26NRRcbo9lxglGft+E6+mAisMHaSJ/xRnks5xZl7fSjDd18rrA==
X-Gm-Gg: AYBFou0J+AmAYOYZ+HzPQjmdNcUrWT3UWR9UXHA1FfiXtQp7v9rrE655Y7eNQb5aOs6
	RrR8btrBL3NuMC2O1Nt7wYt4kDyc5G4fr7Z8hAWhod/mev6KGV+NJdnSXiHeJkfPg+Cw1i5C7r2
	Ny0VnDnz4qixFisP0eEA30rHuJULRKWh/k3kad6AJiIxAUk2TtNpworf+au8qTbxZXzCIEQo05u
	KpAcmWXZiya1sQ68W5uc9xYhcyjtIHldqFbrOodqkzQgjJv876+17ykzFHa0gIXUmbyv2y/gi2l
	mYi/dNnVAh7UV7kP0C3aWKgN5pvPK8Oh4bPdeAdh4LDzs+ZLAj5ABGBhVF63wA6PG42Pe3hUHZa
	iJWNbF6HVK9TdWPrJrdMqMTSHEum/RluVGHPIbtZ/s0m0NNRYKoPvfPdeE16O8MCrV6UhGABtQA
	SVs2DaDlsrDijdzj4XVVUlPZnhvSeAtUh9ACQly/GeyvftIayUW0u4e6TrrmPg8+Pwy0HEqcU/V
	wGUPzK2+QygMTnBMf5a0bGBK33UbDSWBES6YNbOxv+JLAriAysC2KYhTocX9pUYYdLg7k7wNiN2
	Ru3cBTtvS4QKqxT/d7qMKLACOIXvuMdY3lVd45WRmdN6NZmrLuv2uUdI1phJSxtZ/H2dYTteNw=
	=
X-Received: by 2002:a05:620a:4412:b0:93f:38c7:64e1 with SMTP id af79cd13be357-947affc99efmr842215585a.25.1794478837209;
        Thu, 12 Nov 2026 02:20:37 -0800 (PST)
Received: from cobra01.cs.unc.edu (cobra01.cs.unc.edu. [152.2.130.143])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-9479e7a8348sm691143785a.26.2026.11.12.02.20.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Nov 2026 02:20:36 -0800 (PST)
From: Hengyu Liang <hengyul@cs.unc.edu>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: [PATCH] xfs: fix f_bfree underflow in statfs()
Date: Thu, 12 Nov 2026 05:20:18 -0500
Message-ID: <20261112102018.3922571-1-hengyul@cs.unc.edu>
X-Mailer: git-send-email 2.53.0
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Commit dd324cb79e54 ("xfs: refactor xfs_fs_statfs") made
xfs_statfs_data() limit f_bfree with max(0LL, ...) instead of
max_t(int64_t, 0, ...).

However, the value is an unsigned difference, so max() never picks 0.
As of now, when the free block counter is below the count of
unavailable blocks, statfs() reports f_bfree and f_bavail close to 2^64
instead of 0, and df prints negative sizes.

A similar issue happened before and was fixed by commit 237aac4624aa
("xfs: ensure f_bfree returned by statfs() is non-negative"). Perhaps
the refactored code needs that fix as well.

The issue can be reproduced on a new 2 GiB filesystem mounted on /mnt:

    for i in $(seq 3000); do head -c 65536 /dev/zero > /mnt/s$i; done
    dd if=/dev/zero of=/mnt/big bs=1M
    xfs_io -x -c 'resblks 100000000' /mnt
    for i in $(seq 1 2 3000); do rm /mnt/s$i; done
    sync
    df -h /mnt

Before commit dd324cb79e54 ("xfs: refactor xfs_fs_statfs"), the result
is:

    Filesystem      Size  Used Avail Use% Mounted on
    /dev/vda        2.0G  2.0G     0 100% /mnt

After that commit, the result is:

    Filesystem      Size  Used Avail Use% Mounted on
    /dev/vda        2.0G  -64Z  -24K 100% /mnt

This patch will compare the difference as a signed value again.

Fixes: dd324cb79e54 ("xfs: refactor xfs_fs_statfs")
Cc: stable@vger.kernel.org # v6.14
Signed-off-by: Hengyu Liang <hengyul@cs.unc.edu>
---
The resblks ioctl only keeps the reproducer short. The same values show
up after filling a filesystem, writing with O_DIRECT into preallocated
space and deleting files.

Application impact (Ubuntu 26.04 user space, XFS root in that state):
on v6.13, "apt install" stops with "You don't have enough free space in
/var/cache/apt/archives/". On v6.14, it prints "18.4 EB available",
starts the download and fails with ENOSPC. GNOME's "Low Disk Space"
notification is sent on v6.13 and not on v6.14.

Tested on xfs for-next: with this patch, df, apt and the notification
behave as on v6.13.

 fs/xfs/xfs_super.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 5a06132aa384..42be6bd34d43 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -916,7 +916,7 @@ xfs_statfs_data(
 		xfs_sum_freecounter(mp, XC_FREE_BLOCKS);
 
 	/* make sure st->f_bfree does not underflow */
-	st->f_bfree = max(0LL,
+	st->f_bfree = max_t(int64_t, 0,
 		fdblocks - xfs_freecounter_unavailable(mp, XC_FREE_BLOCKS));
 
 	/*

base-commit: 48326a2382d80715475d10ce98734ac65d2d2150
-- 
2.53.0


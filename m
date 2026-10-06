Received: from mx0.herbolt.com (mx0.herbolt.com [5.59.97.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE81445C715;
	Tue,  6 Oct 2026 13:52:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=5.59.97.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791294745; cv=none; b=BMlsCFmkiVkI+4cucwdXYNnbdUGBh//jwRYYANGkt8/cp1+qE6Yk7afU/JRraA5cDasaSqfbWI9qgNzdySN76JqlKcWEjuMiWNeVfWeq5uMY+GbfBX1Cn2dvUMIXb2i5ExEE6/zpI/Zc+ODNh80Kdb+umZX5tfJ/ykSbtSekpFI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791294745; c=relaxed/simple;
	bh=maVJ9R67KGtDdwu3uAK9yCxmJdv9ore2N3ygNFhv8ug=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=bAI/1KCKhc5C+tmtdAoFtZUsYF0PIim38ZBpHDgLOfwiNZX5NRvRlzD9HyZuNjG0s/jEwOyqoXxW1xVqNHErtz74pP6AZyQvTc897VIPHt7kM6ELAt03odGhsaz0IRNtVThikJ8OiGd0nM9j+QmssW7iOM8+H60kzBTMvqfvqGY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=herbolt.com; spf=pass smtp.mailfrom=herbolt.com; arc=none smtp.client-ip=5.59.97.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=herbolt.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=herbolt.com
Received: from mx0.herbolt.com (localhost [127.0.0.1])
	by mx0.herbolt.com (Postfix) with ESMTP id 06F91180F2C1;
	Tue, 06 Oct 2026 15:52:14 +0200 (CEST)
Received: from trufa.intra.herbolt.com ([172.16.31.30])
	by mx0.herbolt.com with ESMTPSA
	id NqUZMw79xGqI/wEAKEJqOA
	(envelope-from <lukas@herbolt.com>); Tue, 06 Oct 2026 15:52:14 +0200
From: Lukas Herbolt <lukas@herbolt.com>
To: zlang@kernel.org
Cc: fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	Lukas Herbolt <lukas@herbolt.com>
Subject: [PATCH 0/1] Fix random.c UB on int overflow
Date: Tue,  6 Oct 2026 15:51:51 +0200
Message-ID: <20261006135205.400485-1-lukas@herbolt.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

While building xfstests with default rpm CFLAGS/LDFLAGS, I noticed
the generic/007 fails with:

    --- /opt/xfstests-dev/tests/generic/007.out	2026-10-06 14:08:02.556220624 +0200
    +++ /opt/xfstests-dev/results//generic/007.out.bad	2026-10-06 14:40:01.667593670 +0200
    @@ -14,9 +14,9 @@
     .........................................................................
     .........................................................................
     ....................................................
    -creates:  18736 OK,  18802 EEXIST  ( 37538 total, 50% EEXIST)
    -removes:  18675 OK,  19927 ENOENT  ( 38602 total, 51% ENOENT)
    -lookups:  12000 OK,  11860 ENOENT  ( 23860 total, 49% ENOENT)
    -total  :  49411 OK,  50589 w/error (100000 total, 50% w/error)
    +creates:  18745 OK,  19086 EEXIST  ( 37831 total, 50% EEXIST)
    +removes:  18685 OK,  19864 ENOENT  ( 38549 total, 51% ENOENT)
    +lookups:  12065 OK,  11555 ENOENT  ( 23620 total, 48% ENOENT)
    +total  :  49495 OK,  50505 w/error (100000 total, 50% w/error)
     
    -cleanup:     61 removes
    +cleanup:     60 removes

This happens because because the lib/random.c has optimized out the negative
branch check as overflow on signed int is undefined behavior.

    if (it <= 0)	
        it = (it + it) ^ MASK;
    else
        it = it + it;

Changing the if-else to single if based on the original `it` value prevents the
compiler from optimizing out the code.

    int apply_mask = (it <= 0);
    it = (unsigned)it << 1;
    if (apply_mask)
        it ^= MASK;

Steps to reproduce: 
    dnf install redhat-rpm-config -y
    ./configure CFLAGS="$(rpm --eval '%{optflags}')" \
        LDFLAGS="$(rpm --eval '%{__global_ldflags}')"
    ./check generic/007

The random.c is used in:

    ext4/052
    generic/007
    generic/010
    generic/011
    generic/014
    generic/094
    generic/225
    generic/311
    generic/676
    xfs/008
    xfs/188

and I did not noticed any regression with this change and the only one
failing with the original implementation is the generic/007. 

Lukas Herbolt (1):
  lib/random.c fix undefined behavior on signed integer overflow.

 lib/random.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

-- 
2.55.0


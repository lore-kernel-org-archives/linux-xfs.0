Received: from mail-vs1-f51.google.com (mail-vs1-f51.google.com [209.85.217.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A4C04D0CC5
	for <linux-xfs@vger.kernel.org>; Wed, 23 Sep 2026 11:58:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.217.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790164719; cv=none; b=EzR18nhGvP7ABGqQ/v732/AdLzTmc6zpjmGm8ebN2gjfO5oWDUKOMqHxHo/z7i9nTMf1hKDm4r57GFc/giQpSszs19tRmmrRlaQbEWfCRIYvvaGjHZvb3CJwNFSTEMLFQa95FyA4FWMpsaMi4HSZ8I/GNcuoEcwiarKd5veHXx0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790164719; c=relaxed/simple;
	bh=1H5M234+4Fg/Pq6qk0rP5Oq9G8Tl/o5fQwWqQNUz3Bg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ZwFlMQUw1xVthteo8NJB5IN9W1SfTLpmJAcuP3NAlIW7jDc5pLjRu/t2JY4oWauUwpHj89/1C6RIfepzBfn82joHZ9LSdKE8fKWhwGr2L6/Jm/X2EIbuEBGmNiwwS5fqbs20tLAQwkY7zRjXgrzEejZgB8Mj96NRFWAFdKdtAjs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XJMgnwXO; arc=none smtp.client-ip=209.85.217.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XJMgnwXO"
Received: by mail-vs1-f51.google.com with SMTP id ada2fe7eead31-78a338fe106so1776220137.0
        for <linux-xfs@vger.kernel.org>; Wed, 23 Sep 2026 04:58:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790164712; x=1790769512; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=nlVujRWWeuEM6btf5nuU1hM8tEcJ0tIS4bqjs/e+5Gk=;
        b=XJMgnwXOSR140+QFWwNSFHQCDt/uze1Vf3xV2LcI+wD+Td0lZWK+1rXZJAZdDhVEiN
         kNGMAv7OQRvCf0QObY/1mQ/3HICuG8PizrffmmETEjL0uELj5PeaITK0UWNkj2NNGuzJ
         yDUCqL17kP/J8g5STp+u3zEfNp5KPRSHp3ZzYR3xLx2xxntY76b0KC5O+PjEPrtdDDMp
         3jWPyHqxn9wKFyXphgEuJEwl8D7iFUgXix7DJBKlT3nZNmVfKiH0d6a8QtXQ/RiQ7BdP
         5L3Wd5XEuI4fg1zDEjd2ytcf6AKuuv7RaNYztRsQ3dxfz6xAKjv3Tt9x/uxEq8gvQCNU
         6Irw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790164712; x=1790769512;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=nlVujRWWeuEM6btf5nuU1hM8tEcJ0tIS4bqjs/e+5Gk=;
        b=C8oHdbmQ4OKG64TizYZqcIV/W9Ghy3p2tJBDGooKSS+mQqeAY9D5iHreXuGfvLXbOU
         gJ/9aSFSC1zGwRYXlobULfrwN0YnABsokZmPVmsw8xA2Duk8PyBPHgP41/Fn0niDJshD
         m9wy9IqVBiN4wFezwpeDEo6AW/KInJBCgmUsjwPYuE7ELB9Y3oULvgSuwNvaxGsi/utX
         mZ1KLAOXk5+NWj2V7XES1Ve0BB1ZPk2+UkVfi7bGR8P1mE4ZUxQJpyXUmXDwBHUEGbYW
         WK1RsH6L03x2iRsutLGPeMyzZkeIKDWx1GE9AwT6IT3oLDTl8RIVwEl1WZOPekCTxRnE
         9UNw==
X-Gm-Message-State: AFuF++mE5tGnH9g1dAJbY90vT698teGnaNKHO99HiaMwEq0p0X0bF5DX
	/LpOhGKhIYV4Mn2DnULB11DC/EkM4u3CFTWMh7GY/Ec3FBsn2TVuP0v/hOR/yw==
X-Gm-Gg: AYBFou0kZXtjiaS46sxKT1MgzukXXUaMAeQf1weZdV863AvtGFpTGojTS7v+OqQ3ip3
	vF06PeJo4HJufgnGW2dAygTqqu5CLsnkvDECskoqmSx+UoyMLjWsqUbk6XfTLt0MQxQ5WQwqsZd
	138b+el5HNMUSeo5uSZbN/Q2WyKOrzj7IDrrpnB8LtaSo6izBfxqe8NhaPIc0GzD834LCe9RqJb
	dj7AoL8NhDcZGgHhkxY1iQY0hLrXTdTI4vjUqpr+udZgfYFTk6hu92vbKjr1fyxavJw9eaak1AT
	T1yWZfet/tc7AB02a57gS4/4CYllstXQ+QDTNmjnaSW/LhDAJSqEMF2zaF3XL/fjZ79z4HhARhA
	8sGeYjWcdo/3E2UkglJNON42Pzu4C3BDJcluX/wPx9bCM6pDDWq7xJUELDsbU5ejPGLRTVMy1Ry
	7HOxcbZz3mntM6zHb45mNdDkcywSDr3p6ZFNDPqw28GbOAHW2Ewu9AoqtgUn/zCxk=
X-Received: by 2002:a67:fa0d:0:b0:7a9:3b76:61ff with SMTP id ada2fe7eead31-7aa9df8a2dcmr4201536137.1.1790164712489;
        Wed, 23 Sep 2026 04:58:32 -0700 (PDT)
Received: from beelink.. ([187.13.30.172])
        by smtp.gmail.com with ESMTPSA id a1e0cc1a2514c-985167e6fcfsm3257250241.0.2026.09.23.04.58.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Sep 2026 04:58:32 -0700 (PDT)
From: Aldo Ariel Panzardo <qwe.aldo@gmail.com>
To: linux-xfs@vger.kernel.org,
	Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J . Wong" <djwong@kernel.org>,
	linux-kernel@vger.kernel.org,
	Aldo Ariel Panzardo <qwe.aldo@gmail.com>
Subject: [PATCH v2 RESEND 0/2] xfs: fix out-of-range remote xattr value length
Date: Wed, 23 Sep 2026 08:58:21 -0300
Message-ID: <20260923115823.3305596-1-qwe.aldo@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

v1 tightened only the read-time leaf verifier.  Darrick pointed out that
the underlying problem is the signed value-length check in the consumer,
xfs_attr_copy_value(): a remote value length is an on-disk __be32 that is
stored into the signed args->rmtvaluelen, so a crafted length such as
0x80000000 becomes negative and slips past the "buffer too small"
-ERANGE guard, and is then used as a copy length.

v2 fixes both ends:

  1/2 rejects a negative or oversized value length in
      xfs_attr_copy_value() before it is used, so a bogus length cannot
      become a copy length even if it reaches the value copier.
  2/2 is the v1 verifier fix, rejecting the malformed remote entry at
      read time.

Both are bug fixes and are now cc'd to stable.

v2:
  - 1/2 is new: fix the signed value-length check in xfs_attr_copy_value
    (the consumer / root cause), per Darrick's review.
  - 2/2: cc stable; otherwise unchanged from the v1 verifier patch.

v1: https://lore.kernel.org/linux-xfs/20260707140118.3217585-1-qwe.aldo@gmail.com/

Aldo Ariel Panzardo (2):
  xfs: reject out-of-range attribute value lengths in
    xfs_attr_copy_value
  xfs: reject remote xattr entries with an out-of-range value length

 fs/xfs/libxfs/xfs_attr_leaf.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

-- 
2.53.0


Received: from mail-pg1-f180.google.com (mail-pg1-f180.google.com [209.85.215.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8BA915E5D9
	for <linux-xfs@vger.kernel.org>; Tue,  2 Apr 2024 21:35:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712093749; cv=none; b=ntlEYQZFWlYuo3zbCrFjPHShxizhBBbsnCxQmp3TPqfPhgmd/DCRPvFWxyWgzeS0mMyGX+VkV9O8PG9WVh7Pyh80FO2yLjbm0j+SJbSv7ZFdVYcqAvCVHls/HC4Sg3/JWDik2lHbwAGOP5wFnureuleZcd9D6ZrWESgaDSa4w7Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712093749; c=relaxed/simple;
	bh=O47L7B4679jYoYDg9JqiDmUjgVI6IDIzhDpMFUFD/5Y=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=iuLPrhOEVkRbwhRE89UDK5s9UMvVIPk0WaNj9b2IXGQokYkgE/DNbwa1pwMSMbsyXlGrnILjXBxQ2/WLxuIdXhwYHDq6UMBUfCdI7REyJp3tXzvIXs8wfqjHiY+lPMqczpif5CftE8PDLLOoKMxYTBcH5oBok+3A4ks/KD86VeM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=MRxdfbf0; arc=none smtp.client-ip=209.85.215.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="MRxdfbf0"
Received: by mail-pg1-f180.google.com with SMTP id 41be03b00d2f7-5dc949f998fso3693459a12.3
        for <linux-xfs@vger.kernel.org>; Tue, 02 Apr 2024 14:35:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1712093747; x=1712698547; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=O47L7B4679jYoYDg9JqiDmUjgVI6IDIzhDpMFUFD/5Y=;
        b=MRxdfbf0ExSW6GRXMuM5QtavuaMVj1XEjZ4iay5GNB8J7X8Zycz3DkzXCYKUxjiDe1
         UYAXpYEt9b7v5fOYXhl1ky81xXpHg/L6pgkiNFfJsxS/P3qSH+ODIPPhCn90jVhBE+mm
         pFwlLhFFy+SG11g6BBI/pjyeiBo+vwpihCzuUxaUyAMToiKouF00w2WEtx0QgeDk1KR5
         t9eZW6XGVeNlONIEWH1dlx8PM/RTx5DNJahipLn7DiLMJEPKF+wTbjDBnh5igWeJvAjz
         WStdP3WKm43qXsHcVQC9xTY9qytnDW1fyFGLQBKY19S3GPVhVx2ITudzJ6tAfWjVq676
         0ORA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712093747; x=1712698547;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=O47L7B4679jYoYDg9JqiDmUjgVI6IDIzhDpMFUFD/5Y=;
        b=S7iivsAv7VH1DJAlV2KZK+vcPJHrauwrYoxaBQcnOlsV/skHJ0Z5b30EeJ08+fzxLK
         JMCqLM13mC/yKAJorm05cO4TvSFUM4KYSGA7SwuEQhJ1VDchkgutjDplm+Td+xLa48RT
         aYb9iNE/ZqbcD0nvzsBew5AeEkULrAVLU2DwzF9ebGOuA4lBfApgQpEUaUH6rXMftjHE
         JoorOutARdoCyLX9uGswkFbW7Xq2CRsZvDWh2Bvbvh9VA2lLIG5GsQHoyv3o3hNQ/IVk
         yO2pA0E58WucmybJLxjZ+aBpZt/sBNMJtfZETN4LYzy+yqNOnuZdObpG6objJ8qTaxPv
         /Mjw==
X-Gm-Message-State: AOJu0Yzr2cZZHF64xxath/Ieb28+Zf0KgkFjrLWtxchfvH3GSgeFyo7m
	4QUMQQExGSld7dE8DxIXGlglFsAT2MENHn8FgQcgWLXTZ4luUGxPrLhVfH+zCHxQ2uY+/luh7+i
	X
X-Google-Smtp-Source: AGHT+IGkaMK7u+g5aUfrITGqnKiuugDrZ16MXAfVRb8llHLCiwf6dIlxijhOGjVECUeOrPqROBSvXA==
X-Received: by 2002:a17:90a:65c1:b0:2a2:53b:fcd8 with SMTP id i1-20020a17090a65c100b002a2053bfcd8mr10485675pjs.13.1712093746675;
        Tue, 02 Apr 2024 14:35:46 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-56-237.pa.nsw.optusnet.com.au. [49.181.56.237])
        by smtp.gmail.com with ESMTPSA id x17-20020a17090a531100b002a0593432bbsm10086478pjh.52.2024.04.02.14.35.46
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Apr 2024 14:35:46 -0700 (PDT)
Received: from [192.168.253.23] (helo=devoid.disaster.area)
	by dread.disaster.area with esmtp (Exim 4.96)
	(envelope-from <dave@fromorbit.com>)
	id 1rrlnE-001n71-0B
	for linux-xfs@vger.kernel.org;
	Wed, 03 Apr 2024 08:35:43 +1100
Received: from dave by devoid.disaster.area with local (Exim 4.97)
	(envelope-from <dave@devoid.disaster.area>)
	id 1rrlnD-000000052FP-2KF0
	for linux-xfs@vger.kernel.org;
	Wed, 03 Apr 2024 08:35:43 +1100
From: Dave Chinner <david@fromorbit.com>
To: linux-xfs@vger.kernel.org
Subject: [PATCH 0/5] xfs: sparse warning fixes
Date: Wed,  3 Apr 2024 08:28:27 +1100
Message-ID: <20240402213541.1199959-1-david@fromorbit.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In chasing down a recent regression, I realised I wasn't running
sparse regularly on my "fs/xfs-only" kernel builds, and so I missed
a warning that would have prevented a bug from slipping through.

I've modified my build scripts to always run sparse when I do these
delta builds as I develop code, and I found a few other warnings
that needed to be addressed. No bugs were uncovered - they are
simply modifications and/or annotations to the code to address the
warnings and make them go away.

There remains a couple of sparse warnings in the transaction
reservation calculations - sparse throws "too many tokens" warnings
from the max(t4, max3(t1, t2, t3)) calculations. These are sparse
code parser issues, not a code problem, so I have ignored them for
now.


Received: from mail-wm2-f13.google.com (mail-wm2-f13.google.com [74.125.225.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B60A14503F3
	for <linux-xfs@vger.kernel.org>; Mon, 21 Sep 2026 08:32:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.141
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789979528; cv=none; b=e+IimbdM9QqFq2pCLQjfvDvA3Z6ZIaDCQpQP64R6Ci980iFcAIk6Kw7HMJB466GnO9EUexbPtUOC+INFpJZq8yd8pKSnRneR2X7j61rT1zgNkyOrQ89P/CF4tp+kxCnpLAzNmFNcwwxCP/6BOJ6GJRsnakEfauC0Kz3ci1lMlRQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789979528; c=relaxed/simple;
	bh=FpulTvokzqTeYJ3OxmxU/rNnFJQPKqgmcY5hN5CfRuM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=jtaTGIy3WpMco8VNcb+BGckGtYgJnKtN9C4U4hxTJpAzeNGczuVDlQWxv1P6XVlY35xFhpN/d6Yp9ViuG2+5kH4wG+SlLCTWnBxrTdQF17b2h714TymQZ+2EKogtppLcCoinrsTujzYufoCo7Jp+hvB+h6zkAWls1+c1cUlwblg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RgeWXc7T; arc=none smtp.client-ip=74.125.225.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RgeWXc7T"
Received: by mail-wm2-f13.google.com with SMTP id 5b1f17b1804b1-49ccff31419so22621445e9.3
        for <linux-xfs@vger.kernel.org>; Mon, 21 Sep 2026 01:32:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789979525; x=1790584325; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=b4yvBlT2oLUB9GwD1lafs/1zu+WTyBTei4mStM1E9qs=;
        b=RgeWXc7TJJdM4IP3yNb4OxJR8gpgeUpY8O8JeOwOmFkm+SCAWv8s0Z4noFVsBazhfw
         Z11O4BU5SJbq6p5Yo9tfSlhwWmhYwBbeZWMukpFNlraMJzv52hadT7QBpNMRe1l5h2eB
         aZpC+1RftVfvulgcHnZxvYlpbG/OLTlcHuDBR4rAp2xXpBr8Ju/tLRqVxRPSiUKze9tt
         h1zl7dTAkVxzuivHCw3VbCK3rqv28HNMl4f1jm4IAcu1ul7AVkNXWbNZaA853T/iJ3+w
         pPDv8Emql11DOGhA4+HQ1E5073c7iKeJgPMVxj7hSlhaZwik+ieXIRdYJDNEapM7oA2Q
         9kqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789979525; x=1790584325;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=b4yvBlT2oLUB9GwD1lafs/1zu+WTyBTei4mStM1E9qs=;
        b=BuznINYcEsVeIWJpjJIKeGX1fiMlBdRon6dIYrsFBwOKqZfzSgHSamsEr2Cif6m3yy
         6zNsD87l1U5rSP/75icfJcfKBi52TM35fvrEsrGPZEkwK7Cy0UlEYMiub16v2LGAILI1
         Nqr0/CmR8x/hRQua0LITQNTcFYBlN4Eccb+4XjxMckpXcXewR58z9qxkm/aZCoAeYI7j
         xVAAIiBHYL2UaLs7lUc83KNa8MZbfBm6gsQpqqUuIo8cxB2uD2RvY/IONLlPTWh1NTCt
         JqDCTj+d6ybzyKDh1VPRFIGGLsV7BXNnE+DqUtkQPSjMUJQ4okX2IdvS1+5Xgu+eGLfd
         Phsg==
X-Gm-Message-State: AFuF++lSFyuY2mJFnrU+JeRgkRs7D5lWCW0/O6XnJP1//l2meansX9+4
	VhlqWcFv1Kg+2PR4afALiEPfq3xA2O3b1xTVfh1asZml5l6T3j7mfGXO
X-Gm-Gg: AYBFou2qEqVcOz1TD/w0LzfwTrxwqL2xNnDVrwDJNxb572RVQExLbuyy9hABRf+eirZ
	puwoIPcxg2CpRWB3ilJ4rCpFTFOiEyNVzwz5IW2PI1IV5pe0DZMHZnhnJI8YcxSAVI5Mxgyy7MU
	1VIQO9kEhhGob0sqd3V7u/HnMWvk5gGX7S7KxaVsFBZM8wpdBpecgol3YpD/xluyu6o+I4P3NRf
	tf2ISr5O/FHEwzCyFQrwgxoJ7iqlGwTpesu99CirymwMIMac3nvnBwmj9a+75nY6rSuGqJIMpmR
	pmWedBu7KUG5yP7/oSH5E/mP4IY1VasBlla+17Rzrpgp5l8IW+p4uknHkcJDbe3T0wN1Nl2YLN9
	Zpn1bCxeWZE1NWvva9nha3ffLrhPCwuMTgW3Yz8cGrtVZeUrY6DiDDY1Vzlcw9ANzxz1qfxrYZw
	Yo5Kd3Z+z+IF2Hd2gBe97Xq+yyHHkAOchwOVkcU2kNmIB35fsvzYc+jivGYga8x9rYuTVWmIGVr
	xxpMOQzXmj4HdDgaNjZoFQMR5+EwfKCdLZ4E+w3TzD7
X-Received: by 2002:a05:600c:674f:b0:49d:4ef:bf70 with SMTP id 5b1f17b1804b1-49fc56aef4fmr130546835e9.10.1789979524541;
        Mon, 21 Sep 2026 01:32:04 -0700 (PDT)
Received: from andreayoga.wind3.hub ([31.189.116.68])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49fcd10d174sm222806105e9.11.2026.09.21.01.32.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Sep 2026 01:32:04 -0700 (PDT)
From: Andrea Parri <parri.andrea@gmail.com>
To: Christian Brauner <brauner@kernel.org>,
	"Darrick J . Wong" <djwong@kernel.org>,
	Joanne Koong <joannelkoong@gmail.com>,
	Brian Foster <bfoster@redhat.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Hannes Reinecke <hare@suse.de>,
	Daniel Gomez <da.gomez@samsung.com>,
	Pankaj Raghav <p.raghav@samsung.com>,
	Dave Chinner <dchinner@redhat.com>
Cc: linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Andrea Parri <parri.andrea@gmail.com>
Subject: [PATCH 0/3] iomap: fix error handling regressions
Date: Mon, 21 Sep 2026 10:31:30 +0200
Message-ID: <20260921083133.2960-1-parri.andrea@gmail.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Fix three independent error handling regressions in iomap:

 - clear the writeback context after a failed ->writeback_submit() call,
   preventing an already completed ioend from being submitted again;
 - preserve an iomap iteration error when iomap_fiemap() has a pending
   extent to emit; and
 - preserve a direct I/O data path error when sub-block tail zeroing
   succeeds.

The fixes have no ordering dependencies and can be applied or backported
independently.  Each issue was reproduced before and after its respective
fix.

Andrea Parri (3):
  iomap: don't resubmit an ioend after ->writeback_submit() failed
  iomap: don't lose a fiemap iteration error when emitting the last
    extent
  iomap: don't lose a failed direct I/O bio's error when zeroing the
    tail

 fs/iomap/direct-io.c | 11 ++++++++---
 fs/iomap/fiemap.c    |  8 ++++----
 fs/iomap/ioend.c     | 10 +++++++++-
 3 files changed, 21 insertions(+), 8 deletions(-)


base-commit: 93f51579e7df248780214094418f205253383cc5
-- 
2.53.0

Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC2A143F0A8
	for <linux-xfs@vger.kernel.org>; Thu, 24 Sep 2026 09:12:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790241173; cv=none; b=YGuRsdIZelYOvHbT8cCwJjPD4VnWbNPNTD+bGLXAHqGY7gCfLxqomlJ+XXs/WCDNp5pcd9XzxPseDyVfdo0ad6RQ8JM4hLOlTMa9CDDIALZgezKMIszovi4fR7TMS3PvrY/UqnYHRLBia+1HJLejLnIWNqhqff/SuKI5mu3v1zM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790241173; c=relaxed/simple;
	bh=bdRnAFMPfR0Fi2FAhCeyEX0UMH3xIQeedJjK+qlB13E=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=YLhBJY6dBa5KeNO8j5k/XSoaxqkHA6sIn6GzmAp9SVHsDfHddhrFuKdQRYj27AKOsAmrNjzoCmBrusK+q076PqhQ31KThe4iudTzVsM3qLhAmkrZW/QyaMo4U/22ZK5OmqzMD4QBIi7AJlqX2bcS3KYYMgZWtD3rR+49zz5RfJw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VwPsbpge; arc=none smtp.client-ip=209.85.221.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VwPsbpge"
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-48586861639so319484f8f.0
        for <linux-xfs@vger.kernel.org>; Thu, 24 Sep 2026 02:12:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790241170; x=1790845970; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=6niAdIjChtQP2qK+00u7tIPySJJlYrE3QgIHUPARYiI=;
        b=VwPsbpgeOCbObW+qYEiDr8xwiuTPceahYchMt8OI3s9ltqV5SSQaAt8KpqmNHFvk6o
         IwRt7drwmLHrpFOKV8Dzj0+IjLvtEMgcH6EeboaVVZOj8jjXZNoCEgQRGvTsJtLQsk7T
         ggs3S2uY4OJKPpKr9Hf2luQT7tYXfB3g3+RQRVJcD7B0gzwJ6ytClDYGgyP70QRUVT6o
         CJTbqttE984uUQjNiH2fA0ZyTUZRdxabUEWCoH8wYsAAKWpeCsJ3YwmBw9W0tVUGV17q
         8MViOkOsWDsDjKkjMwWXEM56xxYcm5eJ9ahm3v1hD5kwy3FB8KM1GCyyNZZ7n6Z1/wmw
         emFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790241170; x=1790845970;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=6niAdIjChtQP2qK+00u7tIPySJJlYrE3QgIHUPARYiI=;
        b=tCwyoxYTIJFkp6zeKqJedFXzlrX9HNxy/OJiKsNPnQXpDgFSbMvhjncnjQvv91A/un
         sBaBvpHovirLM/NDZs3LfhBSFYIn7gN6FAY1i/bdIDBejzNP+zPOkaX1Vi6X1iFOKtJg
         Zlaia2iipAnk/yp7zBobyktncOyLDfskBNUwDYc5AW3sev6E7Uf/oSThzB8n1AJyxmwR
         vxCYD5u5OvJ95tCT/VZkwSs/pvm5UeQfDbSOA6ABbiQiJ1gR0Qty1V0Wbh9buv0CdTSB
         HeHUzn5CtV0dqjoch8Dvu1r5h7r7/dCl+tFeXjn64dJjFFLZKdbFxg5oM9wHbQxp8cGO
         l/Mw==
X-Forwarded-Encrypted: i=1; AKwUvBwLKFy8K3jTwmlsPL+j81Fm6mj4iDUT5zJvzjQryfBXCJy2wfxZvsL+CT2uld8DAYYza3x1tDlB96M=@vger.kernel.org
X-Gm-Message-State: AFuF++n77BZ082xkgLmoqZyq0fQTmLkNU5w0VAF85si4f5O9kQWipHQN
	XlVRRUnQuo+HM1PY8huyuFt28QuswElETz2QeiylRmS121Hg+ZABIz1P
X-Gm-Gg: AYBFou0D9kFOcqMIXQGcVJn9zO8mFbbPXQEWctTbAEw0Pcv+VJxluEfhHQaNmuasjeA
	DCrAhKHua55tiZ41Q/P9t29rsiB3erZhl5Vz6Be3uMss5jPZxEQr5Zasj+5uVXVMJnjyOaeUQu2
	Kih85Yod5vd0FZ/GT6n2pfzfv0g1JzRssBYKkQHTMXCUoY+Hcfk2n3iPQBOxbDiQQjC8DUf/C5g
	HFCz62GSckv/+2QCqdCoNZX+fOjysQiJlLkh8rsbgk/hNewrvysN6E/ku/zELr3mui+DfpnSgcL
	SaEtcbZdIkprij7xyCWG9BN493TI6VBrJNXIDvX/g0d68PrzOOCEh8FL/8W4Q6JKCwG3wzxBxQF
	EGg8jV3ERte2PU/UxT5SroiYqtUsSPBXiMzPv6pKD3CsoEyMYHvbOzcNMkRQUIzgmh34z+idQP7
	2K4gMfH+hJDBi2UN3g9ol3KoTdaiwu2YuRaphIIY9mFqcnhbAyAglBBC9yFbnDrojcaI/gMx4lY
	A5E64dxcJ4kcis+9UAC3/V4725UUoMObVoKUGrS9Ijj/wuc7afJGNNaCwLkOPtShmrezFHc3kYX
	EnBy
X-Received: by 2002:a05:6000:2893:b0:485:8226:c69e with SMTP id ffacd0b85a97d-4887170dbf7mr3176319f8f.29.1790241169823;
        Thu, 24 Sep 2026 02:12:49 -0700 (PDT)
Received: from andreayoga.localdomain (93-42-14-189.ip84.fastwebnet.it. [93.42.14.189])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4886848636asm12756677f8f.6.2026.09.24.02.12.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Sep 2026 02:12:49 -0700 (PDT)
From: Andrea Parri <parri.andrea@gmail.com>
To: Christian Brauner <brauner@kernel.org>,
	Carlos Maiolino <cem@kernel.org>,
	"Darrick J . Wong" <djwong@kernel.org>,
	Joanne Koong <joannelkoong@gmail.com>,
	Brian Foster <bfoster@redhat.com>,
	Christoph Hellwig <hch@infradead.org>,
	Damien Le Moal <dlemoal@kernel.org>,
	Hannes Reinecke <hare@suse.de>,
	Daniel Gomez <da.gomez@samsung.com>,
	Pankaj Raghav <p.raghav@samsung.com>,
	Dave Chinner <dchinner@redhat.com>
Cc: Andrea Parri <parri.andrea@gmail.com>,
	linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: [PATCH v2 0/4] iomap: fix error handling regressions
Date: Thu, 24 Sep 2026 11:11:50 +0200
Message-ID: <20260924091203.198225-1-parri.andrea@gmail.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Adding Carlos Maiolino to the To: list since patch 2 (new in v2) touches
fs/xfs/ outside the iomap directory.

Fix three independent error handling regressions in iomap:

 - clear the writeback context after a failed ->writeback_submit() call,
   preventing an already completed ioend from being submitted again;
 - preserve an iomap iteration error when iomap_fiemap() has a pending
   extent to emit; and
 - preserve a direct I/O data path error when sub-block tail zeroing
   succeeds.

The three fixes have no ordering dependencies and can be applied or
backported independently.  Each issue was reproduced before and after
its respective fix.

Patch 2 is not a fix and carries no stable tag: it adds an XFS error
tag (requested by Christoph) that lets patch 1's ->writeback_submit()
failure be injected without the boot-param hack used for the original
reproduction.  I used it to write an xfstest reproducing the bug (list
corruption caught via CONFIG_DEBUG_LIST on an unfixed kernel, clean
writeback failure on a fixed one); I'll send that separately to
fstests@vger.kernel.org once this series is out for review.

Changes since v1:
 - Patch 1: reworded the added comment to fit 80 columns (Christoph);
   answered Christoph's request for a reproducer in the commit message
   (fault-injected ->writeback_submit() failure on a reflinked XFS file,
   reliably hits list_add double add on the unfixed kernel); confirmed
   with Christoph that the final ->writeback_submit() call in
   iomap_writepages() needs no equivalent fix, since wpc is never reused
   after it; picked up the version-scoped stable tag Darrick suggested;
   picked up Brian's Reviewed-by.
 - Patch 2: new, added per Christoph's request.
 - Patch 3 (was 2/3): no code change; picked up the version-scoped
   stable tag Darrick suggested; picked up Reviewed-by tags from Brian,
   Darrick, and Christoph.
 - Patch 4 (was 3/3): reworked per Christoph's suggestion to drop the
   zerror/ret handling entirely instead of just fixing its type, since
   iomap_dio_zero() can only fail via a can't-happen WARN_ON_ONCE()
   assert; this also resolves Darrick's question about the local
   variable's type, since there's no longer a local variable to type.

Andrea Parri (4):
  iomap: don't resubmit an ioend after ->writeback_submit() failed
  xfs: add an error tag to inject a ->writeback_submit() failure
  iomap: don't lose a fiemap iteration error when emitting the last
    extent
  iomap: don't lose a failed direct I/O bio's error when zeroing the
    tail

 fs/iomap/direct-io.c         | 19 +++++++------------
 fs/iomap/fiemap.c            |  8 ++++----
 fs/iomap/ioend.c             | 10 +++++++++-
 fs/xfs/libxfs/xfs_errortag.h |  6 ++++--
 fs/xfs/xfs_reflink.c         |  5 +++++
 5 files changed, 29 insertions(+), 19 deletions(-)


base-commit: 93f51579e7df248780214094418f205253383cc5
-- 
2.53.0


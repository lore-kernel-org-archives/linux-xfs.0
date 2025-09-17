Received: from mail-pg1-f179.google.com (mail-pg1-f179.google.com [209.85.215.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9F7B30DD0A
	for <linux-xfs@vger.kernel.org>; Wed, 17 Sep 2025 22:24:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758147895; cv=none; b=PGXhG+30OqnqB4f6Gu6vQlnyaJWirYdWxmZaApt7ij/BCPXjVE/ylDa5F9T3rNsjWMm1RtDGw04a8Z6w/iq2rfR/A4JDC+x5lEkvFmBE/EAI7gcISc7kF7Pw4J33DWsps0UkfYDbLE6FrluipAX/6WPNT0Ct6ySnLsnPDGdTSnc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758147895; c=relaxed/simple;
	bh=Xwwgc/zTyJ43VYKkxkJZLUEAQy0InzCX8neD/bZIz10=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=U+GYB/JfiY4+6f0ytLFsfMQh4ArrbGJt8Cp16VhllL2GRlauRjlIxrt3fXKHzLO4hEW5HXzISvLTa7FLegZNlT62qA8PYvPgUFcjHOI7cyrV6QWNVJnhQNm1OANTyHLIPLu7Lz2RIHSZf4ojXVeM9yg/1GaUukEo9oxn1XEssiY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=lb/YOChg; arc=none smtp.client-ip=209.85.215.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="lb/YOChg"
Received: by mail-pg1-f179.google.com with SMTP id 41be03b00d2f7-b54d23714adso250008a12.0
        for <linux-xfs@vger.kernel.org>; Wed, 17 Sep 2025 15:24:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1758147893; x=1758752693; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Xwwgc/zTyJ43VYKkxkJZLUEAQy0InzCX8neD/bZIz10=;
        b=lb/YOChgRqCfp9hqNVIbwYlNpmAkiP/qtcCmvYJCKCo9bDX2mpAhpKcttmpSGMIxM+
         u9S49S6Mbco5Sm1zXj2ebl98aKau1oACsBlVlDmX5EXppyfoWiymjCaGb/HzmvZYJylM
         OS8I10szrzbFK8x/yxXVuGjZx13fMbarzjT+uncRx5JqXODO4gN1MOfyZba7LX9yFhM1
         RNWPXqtexmlREq/Xjlv7b3/v/2IEFjSg+JHyvwQPM0I72TCKrQNZsRxenOhqLS3m+sd/
         acJnjmgFTYUCZhlPPX/UNisBZEGN0VIBX5mcx8w2O0gL0Yg2qMUDc+whl5NxrG+m9d80
         5T+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758147893; x=1758752693;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Xwwgc/zTyJ43VYKkxkJZLUEAQy0InzCX8neD/bZIz10=;
        b=AObhG2noRqX4UYDdzkXFsv8gTRJieDi0LZHPEAx0gfh00BaeiYfICbBzJVhj4nC797
         mMTeVFR9FURHZKbf6la46802LFD71g5SIXHm+yUnWM8rPHQ6V/jRCfwBQYHaQL9+PlG6
         5dbn6oLELimUPYe7hy/CJKkuepRwlbfn/xKhVe9n7+xqi5rp/piazwyEA/naXSaRckgS
         cAAswWokP46cjJ30ZE3nHm4lE4rc0R1zGc7obIVpxaUIeX4NUo/7x5CtIKvoMCyE1ZKg
         ypbDb/QTHAvXVcLAkJ/ZvazsvRuFoQw+1ZBIsZk1cqWMPO3j9puCOMpRcAPWB1UPMXTY
         mIcg==
X-Gm-Message-State: AOJu0Yw6ln9sS0bvmdZCsaFC9ukGWlnSjMwZGT66nN7Fem1P+R+G7nMw
	sONOvanofpJOEhg+/bLvR7yHuoq/eg5uYPIbvqFRAstTB8jfbG49y3J24C2xYVLdG5NStxLRGmR
	6Mj+G
X-Gm-Gg: ASbGncv3bKgD1jvE8qs7qJo64chSahKfDUyuTHzvcQ3UQdqViJGzZDWr9/ar7cOADrn
	pUO/pNLqHpUWH+ZKEUqPS7bMb/Z5ir9d+9Zv2DzQ610hL128G7hpxPj+67PbQsu4wofDBI837Jc
	LHkJha6Ut09t9YXhgrVNdtJgFTkhuS2i1XyNY0FtZIEnCfjuuNyFw7pl/HQe44MEjyiAkMHQkE8
	V1vj5mwJ9kurrXe/UTSpEi0rOilaLkIRfFmQaJ/c0kb1y+d5FD0w0Dvw77xHZVo/kuv4Xgqgmxl
	1YiNovaVMGKxExbAyYs/3ix3YDLJlO6UJ5Pj7fhtujp2WSqtCsZV8F0XH6Bgng6ybohNX6YntRx
	6wJkrJG6KMgBKjAvHCYGkiSAFt0AXb2zDANK2e4uXJxU5ySr+XkLlEvn1uLE4LYYvBccomfD0fj
	ddEzhQ
X-Google-Smtp-Source: AGHT+IFJHqy5BRr/ZvManiXJCioTGxFzmPdc9bOHxs+9NrFIt5YzNLgqZ4vmTeY//XLHNzaGqOyC8A==
X-Received: by 2002:a17:902:c404:b0:265:e815:fcdf with SMTP id d9443c01a7336-2697ceb5489mr15958635ad.17.1758147893208;
        Wed, 17 Sep 2025 15:24:53 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-91-142.pa.nsw.optusnet.com.au. [49.180.91.142])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b54ff35afa1sm574948a12.7.2025.09.17.15.24.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Sep 2025 15:24:52 -0700 (PDT)
Received: from devoid.disaster.area ([192.168.253.111])
	by dread.disaster.area with esmtp (Exim 4.98.2)
	(envelope-from <dave@fromorbit.com>)
	id 1uz0a1-00000003I2X-3uca;
	Thu, 18 Sep 2025 08:24:49 +1000
Received: from dave by devoid.disaster.area with local (Exim 4.98.2)
	(envelope-from <dave@devoid.disaster.area>)
	id 1uz0a1-00000005a9A-3CYo;
	Thu, 18 Sep 2025 08:24:49 +1000
From: Dave Chinner <david@fromorbit.com>
To: linux-xfs@vger.kernel.org
Cc: jack@suse.cz,
	lherbolt@redhat.com
Subject: [PATCH 0/2] xfs: reduce ILOCK contention on O_DSYNC DIO
Date: Thu, 18 Sep 2025 08:12:52 +1000
Message-ID: <20250917222446.1329304-1-david@fromorbit.com>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi folks,

This is the changes I came up with in the course of the discussion
with Jan about the fallocate+DIO+O_DSYNC performance improvement
thread here:

https://lore.kernel.org/linux-xfs/CAM4Jq_71gxMcnOdgqWhKEa53sr9r57Qpi0hc5bs3NgtnNOGwtg@mail.gmail.com/T/#

The first patch is moves a little bit of code around to ensure
that xfs_inode_item_precommit() always calculates all the changes
before it starts manipulating the dirty and fsync flags on the inode
log item. Whilst technically it could be considered a bug fix, the
bug it fixes requires an inconsistency in the on disk format to
exist first, so it likely won't ever be an issue in normal
production systems. It also requires an application to run a
fdatasync and then have a system crash just after the
inconsistency is addressed to expose it. So the likelihood of it
ever being triggered as a data integrity issue is -extremely- tiny.

The second patch is the one that addresses the performance issue. It
removes the ILOCK from the sync/datasync path completely, and
instead relies on a new datasync commit sequence number being stored
in the inode log item to elide datasync journal flushes when they
are unnecessary. The mechanism is explained at length in the patch
description.

The changes have been perf tested by both Jan and Lukas, and it has
passed multiple fstests runs on a dozen different configs without
regressions here.

-Dave.


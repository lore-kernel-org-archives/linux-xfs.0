Received: from mail-ot1-f49.google.com (mail-ot1-f49.google.com [209.85.210.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B15A65191
	for <linux-xfs@vger.kernel.org>; Tue, 19 Mar 2024 02:15:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710814556; cv=none; b=cKjFKKEv/Wn325W/ZkzSj6STJ9XRl/VKEk28zv9GabuAQMVkST/oB5O5W3Sw7k/e0Id8zljK1hfhEMReAX1Zoxe5OFa439pmuwGGgYUmiXJoWn/R4C/kywpqcFPTx8AqRXTymGOG3JvLpNMdUCV1w0drP3txfwJXPYvV6e0wdIA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710814556; c=relaxed/simple;
	bh=bXwa2aCarJ0GdklwcURZ1oIRZL/ZzexX2/PWVVdqOHc=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=cWRJnbQ96r1MtpC5JDrpmYpU025AL69jD8pAKJZunzw8s68S7BYuZjM6aJk5ry/cG65fy+juYAgPEjN+/iidNpLHznykLS9lTF25tRmDItm15sGl+VV777uqCgGHhDpZAtn58RCm7/5YTCWnsLLAJApE4zJ31OpXAKMXUnozRzg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=pTaefcOp; arc=none smtp.client-ip=209.85.210.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="pTaefcOp"
Received: by mail-ot1-f49.google.com with SMTP id 46e09a7af769-6e682dbd84bso1546315a34.0
        for <linux-xfs@vger.kernel.org>; Mon, 18 Mar 2024 19:15:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1710814553; x=1711419353; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=CZLy57S+MnfI6h+fcuLt4FP3xNUFClmjuk/uq2cjzFQ=;
        b=pTaefcOp/H5WyR4/YqQU0c/cosZdmWGn8MRZzQUs3Wk2/4HxI6fbY3GZQAqvYBxOWO
         dMlD8cREcCxtTHqbVozJvNNtT8BWEgRP/jBeaRnHGZ/gN60z+IBUTTPT9NMiKipKxjIW
         qeP19RlYAEKU5Is0IDLi6YUEPSMnmgDjefG0bJ1lCCSwWYMmbD4WIX2cgIYZ+fXac4s5
         JKUqadmb08uXZfvMs84mUZj9Y+LSDB1GC9nUal8JfhMYpboheSHRLt7dJIdXsc95f+iG
         bOQcUfaTeaarLmDyDHeq0FczTyVWDT2Z6dYMzF770Fc+6bFhoeaLnMJ9PYq0sLkWfmPF
         ho2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710814553; x=1711419353;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=CZLy57S+MnfI6h+fcuLt4FP3xNUFClmjuk/uq2cjzFQ=;
        b=jlWpXdgvUr6ig4vln9K81Cg3mIjF0vgtV/gPjvHqV5GJ/J0zeVyNhxIXW1175TAVJy
         K5LFRI/rSc4FOkwanel5B/tP9Yk/puwDdCScD/EFrLVrXnz1nJtBguIpeeiR/IiW6Iap
         Jcx2xnf7cX/YW83YddGkI1DeBfRNErxU+TqqWaH1ECv1zSYVHZ8whCfN5iA02+JTFP3N
         g1BKKlzSaSY1RA579Xl0aF1pLF2bDFH0YiGHnmul2RMfuwr7htRU8Ub9f2qPofFaT2HC
         QeOy7uDhvUl7+zDFl3AwkBZ/kcXmlJcTr/p/dnTeRlMF2vn9cCCZDWtGMWpIjvcg2SdT
         cn6w==
X-Gm-Message-State: AOJu0YziNg1xjQ83KET2TqaZ82LDIX+R9++GtIV3EK5StWfl1U4hA4be
	HCodnIYh6Rp8qb5KOySpSpwA4/w1gOPql660E10xga4gw2hzGJ9TQdH5gWVcKEZcs/ugQx0z3oj
	e
X-Google-Smtp-Source: AGHT+IHa8GYEL2A7V8ukcoBg/8EOgwcbuTU7TOLkfPEiLG8pPCXCTdD3hxEbarGyfD3EuFzLRUxqXA==
X-Received: by 2002:a05:6808:3992:b0:3c2:3f40:3813 with SMTP id gq18-20020a056808399200b003c23f403813mr18900755oib.29.1710814553199;
        Mon, 18 Mar 2024 19:15:53 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-185-123.pa.nsw.optusnet.com.au. [49.180.185.123])
        by smtp.gmail.com with ESMTPSA id h62-20020a638341000000b005dc832ed816sm7942116pge.59.2024.03.18.19.15.51
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Mar 2024 19:15:52 -0700 (PDT)
Received: from [192.168.253.23] (helo=devoid.disaster.area)
	by dread.disaster.area with esmtp (Exim 4.96)
	(envelope-from <dave@fromorbit.com>)
	id 1rmP13-003s4v-1k
	for linux-xfs@vger.kernel.org;
	Tue, 19 Mar 2024 13:15:49 +1100
Received: from dave by devoid.disaster.area with local (Exim 4.97)
	(envelope-from <dave@devoid.disaster.area>)
	id 1rmP12-0000000Ec6g-48u3
	for linux-xfs@vger.kernel.org;
	Tue, 19 Mar 2024 13:15:49 +1100
From: Dave Chinner <david@fromorbit.com>
To: linux-xfs@vger.kernel.org
Subject: [PATCH 0/5] xfs: fix discontiguous metadata block recovery
Date: Tue, 19 Mar 2024 13:15:19 +1100
Message-ID: <20240319021547.3483050-1-david@fromorbit.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Recently Zorro tripped over a failure with 64kB directory blocks on
s390x via generic/648. Recovery was reporting failures like this:

 XFS (loop3): Mounting V5 Filesystem c1954438-a18d-4b4a-ad32-0e29c40713ed
 XFS (loop3): Starting recovery (logdev: internal)
 XFS (loop3): Bad dir block magic!
 XFS: Assertion failed: 0, file: fs/xfs/xfs_buf_item_recover.c, line: 414
 ....

Or it was succeeding and later operations were detecting directory
block corruption during idrectory operations such as:

 XFS (loop3): Metadata corruption detected at __xfs_dir3_data_check+0x372/0x6c0 [xfs], xfs_dir3_block block 0x1020
 XFS (loop3): Unmount and run xfs_repair
 XFS (loop3): First 128 bytes of corrupted metadata buffer:
 00000000: 58 44 42 33 00 00 00 00 00 00 00 00 00 00 10 20  XDB3...........
 ....

Futher triage and diagnosis pointed to the fact that the test was
generating a discontiguous (multi-extent) directory block and that
directory block was not being recovered correctly when it was
encountered.

Zorro captured a trace, and what we saw in the trace was a specific
pattern of buffer log items being processed through every phase of
recovery:

 xfs_log_recover_buf_not_cancel: dev 7:0 daddr 0x2c2ce0, bbcount 0x10, flags 0x5000, size 2, map_size 2
 xfs_log_recover_item_recover: dev 7:0 tid 0xce3ce480 lsn 0x300014178, pass 1, item 0x8ea70fc0, item type XFS_LI_BUF item region count/total 2/2
 xfs_log_recover_buf_not_cancel: dev 7:0 daddr 0x331fb0, bbcount 0x58, flags 0x5000, size 2, map_size 11
 xfs_log_recover_item_recover: dev 7:0 tid 0xce3ce480 lsn 0x300014178, pass 1, item 0x8f36c040, item type XFS_LI_BUF item region count/total 2/2

The item addresses, tid and LSN change, but the order of the two
buf log items does not.

These are both "flags 0x5000" which means both log items are
XFS_BLFT_DIR_BLOCK_BUF types, and they are both partial directory
block buffers, and they are discontiguous. They also have different
types of log items both before and after them, so it is likely these
are two extents within the same compound buffer.

The way we log compound buffers is that we create a buf log format
item for each extent in the buffer, and then we log each range as a
separate buf log format item. IOWs, to recovery these fragments of
the directory block appear just like complete regular buffers that
need to be recovered.

Hence what we see above is the first buffer (daddr 0x2c2ce0, bbcount
0x10) is the first extent in the directory block that contains the
header and magic number, so it recovers and verifies just fine. The
second buffer is the tail of the directory block, and it does not
contain a magic number because it starts mid-way through the
directory block. Hence the magic number verification fails and the
buffer is not recovered.

Compound buffers were logged this way so that they didn't require a
change of log format to recover. Prior to compound buffers, the
directory code kept it's own dabuf structure to map multiple extents
in a single directory block, and they got logged as separate buffer
log format items as well.

So the problem isn't directly related to the conversion of dabufs to
compound buffers - the problem is related to the buffer recovery
verification code not knowing that directory buffer fragments are
valid recovery targets.

Hence the fixes in this patchset are to log recovery, and do not
change runtime behaviour at all. The first thing we do is change the
buffer recovery code to consider a type mismatch between the BLF and
the buffer contents as a fatal error instead of a warning. If we
just warn and continue, the recovered metadata may still be corrupt
and so we should just abort with -EFSCORRUPTED when this occurs.
That addresses the silent recovery success followed by runtime
detection of directory corruption issue that was encountered.

We then need to untangle the buffer recovery code a bit. Inode
buffer, dquot buffer and regular buffer recovery are all a bit
different, but they are tightly intertwined. neither dquot nor inode
buffer recovery need discontiguous buffer recovery detection, and
they also have different constraints so separate them out. We also
always recover inode and dquot buffers, so we don't need check
magic numbers or decode internal lsns to determine if they should be
recovered.

With that done, we can then add code to the general buffer recovery
to detect partial block recovery situations. We check the BLF type
to determine if it is a directory buffer, and add a path for
recovery of partial directory block items. This allows recovery of
regions of directory blocks that do not start at offset 0 in the
directory block. This fixes the initial "bad dir block magic" issue
reported, and results in correct recovery of discontiguous directory
blocks.

IOWs, this appears to be a log recovery problem and not a runtime
issue. I think the fix will be to allow directory blocks to fail the
magic number check if and only if the buffer length does not match
the directory block size (i.e. it is a partial directory block
fragment being recovered).

This passes repeated looping over '-g enospc -g recoveryloop' on
64kb directory block size configurations, so the change to recovery
hasn't caused any obvious regressions in fixing this issue.

Thoughts?

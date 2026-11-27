Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.44
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795774175;
	b=sw5b26YoF/heQ3OBjhFrJ0fyyCZKl+oBvf3OTdZ8PA8Hw5GOspifep/147lpqrvnw5fj
	 nnLhf/Nhc0cVWCRPRHBh4WDHUoGHRnNDooShpEfVriNCQCxJLWkB/EGy43fiNSuVdtSRZ
	 mkKU+8zzurvxPgXJglGrncaHqQIuLaPWFGue5Xvj357jFyAoybJheoQDOYLABI+Es67Ph
	 B9kMdSnufIxJqrpKfL813Qx50qTiRcQAver3mN2vlL5SS+EiF+rKhCeaowrZsnAmOYVHz
	 2t2oa2ZAlOO3xkRhEw604hqSEIJCtO9q5FP9um27VptIA9rKfgxhbOf9eV+QixXeEiQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795774175;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=PT2edGw1BGuy8Db7HIuBzejTR21TYqKpoKF8KfZWiQo=;
	b=jrp5cB+/CR4EhHl2OYGMD26NnitznyLZPinWLxKxb29L/P8tzaQGdl3KcimLTVjQ0R63
	 fvIEhT3zPLZDMIpxC7sw6y9TjmqpH0nkZsUPBOs42ldFQ8rB2vAV1OX+JskW5XkaSgU5S
	 CF9V3En/faMA0Pa5Va51uTZ5doOE9KcwQXnvaqCx4IccAXjkzCDhTbIOMDIOhSK1hCRGU
	 8NYJgZHuWVKHwNdQwklUIorSF0vmGWW3wnKwWXxpOfu2nk1/0BnsKdrCKxHjKxhKUOxv2
	 liPtABXkIf84oDMB7OzbNAxs1OHY0MNxFVuJwW616i23k8VLFotuJuHdxrbECYhpKbg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=bwF1a+YE;
	arc=none smtp.remote-ip=209.85.221.44
Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF52B606A31E
	for <linux-xfs@vger.kernel.org>; Fri, 27 Nov 2026 10:09:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DF52B606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=bwF1a+YE
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-4a357b1c649so4556417f8f.3
        for <linux-xfs@vger.kernel.org>; Fri, 27 Nov 2026 02:09:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1795774173; x=1796378973; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=PT2edGw1BGuy8Db7HIuBzejTR21TYqKpoKF8KfZWiQo=;
        b=bwF1a+YEEodRJkLfqlE3oxFx1EPVFQVO8IUxkVObcwNs6En182Wl/vYXLklP0K7gfT
         Mu8Kxn7kJuSlqMcOwXMW44IFaA4TtDdH06pkTNuDCwtmPoacT4NN4psERpK6+saETvpz
         W9pt/LY5C6PmDa8GdmvPG06lZsMLzAPLThPyl32xxZVdaZOI/NavUosPWDjVpFUbCa5d
         zRkVLWVSmFMOSuTMAS5O72NCelOmVw/X6ztDyr9f/hOgRxdUWPfT0AE37WmjYMxxFF5x
         gcHGtGJUy8UPtkj0B5YBkkHncnjlKFyCKf1ClRa9V9t7mJhUYHSwqnoJWwOxdjOVQhNm
         B8Jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795774173; x=1796378973;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=PT2edGw1BGuy8Db7HIuBzejTR21TYqKpoKF8KfZWiQo=;
        b=SnpkPJDWYn/6A284SuEphbVLroJDeBFYkDKXhRFcj18NKeY6lQfMr5+gtZtQXrxjtb
         6e3J5ygprGSFYJAErhrNWxUZzaLzxtQ5bxmP2msQUV00hPGjhNRbgiJvHpa0LQfl/iyF
         mbPfBr4SZNdWJXxlPb7c/NrtOuRiYs7GtPQTuksu3jfsfFkr7iTOt5PRTIYSTfN0MQ/U
         jjd9PexGCr2e3zb+VdCIc4stf60HdzDLf2DqqZ26T0LJajOhdB0VX0l4LyANlFlt6gwE
         VENIKkkr3g640QsAS11KXItjU17r8oA+I8lbYoRZDumC3tWwciQExR/GElZD5kAuDEmB
         ITrQ==
X-Gm-Message-State: APuU4Z/8UzcOI4vVKswXvDPrMC6WpkmFeY7rXTIYdE9UYIqTr0j3VKrD
	5iH0fXrSRoj8HX1eh/SmGddUP+li9mdihUuKEX6/Um/rN50lgoSa3quGN78LFVG4aA==
X-Gm-Gg: AZFdTZf34+obLvpzWXCMne66ZjmC0VfmHw+5SeL+BcT11vxj92acgcBpgyqDEYgmuBh
	t5zGKpjAWAvhUH4pxxkeFlqqwXd8PHRgBjXAv+pSmlYghBdlxV3G2gxv20JucTsP6Oa8BKtsZng
	RZKdwacxTuIvBvwH3l5+x9S4gDofj3qeHHuQSM22ePqXaFxBoPrZ94djpmNUoJPf74S0XRCnhSN
	cgo+PBe+kXEPa6WGrgs3IlckSv/8F5MfeRDDfxJpldJEvxuoAIUHOXKsKloZNvqkJcmpgqttELb
	4vkCJki0mzrrYqnSvNg5Y27/gTiSf4ROHWqxPb9aXwtK6YF28+DNaZpimsfQ6Eq8ifO3K9bMmQe
	5WVoRhTUrDFn0+j85QEI/gWweMtJDgLN/BxJbHBDlaWJVceZBGAtvXenzAdOj6vGPErlRjLYzqs
	VAJQW7qGUr0CX+JRpkS2Ce8+nu7SJl6+rbU5qxqLsihNQdVBvFezEsfksB++umwi69107wmEwHU
	uGKN3R+QbStH02JUlEu9xNer3ynY+rDvpN6KHrHUP96PwuxMDP9IrYxgoiyvC50FUR1BHPkpULk
	HKPNWws1DQKd5JZpvJNAJ51/C4MF846OqPx9Dhvr9ZVR6McN9zmJArDbUdBmbztpHyjt6vsQSmS
	5hVE/VKqe6wuy3jOF+ZEuhUI0DDLAOdxSQQ==
X-Received: by 2002:a05:6000:4a0b:b0:4a7:4efc:11d0 with SMTP id ffacd0b85a97d-4abaf740155mr43096946f8f.12.1795774173128;
        Fri, 27 Nov 2026 02:09:33 -0800 (PST)
Received: from localhost ([2a07:de40:b240:0:2ad6:ed42:2ad6:ed42])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-4b33a596f9csm22106858f8f.12.2026.11.27.02.09.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Nov 2026 02:09:32 -0800 (PST)
From: Wei Gao <wegao@suse.com>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org,
	"Darrick J . Wong" <djwong@kernel.org>,
	Chandan Babu R <chandanbabu@kernel.org>,
	linux-kernel@vger.kernel.org,
	Wei Gao <wegao@suse.com>
Subject: [PATCH] xfs: clear XFS_EOFBLOCKS_RELEASED on truncate down
Date: Fri, 27 Nov 2026 10:09:29 +0000
Message-ID: <20261127100929.32124-1-wegao@suse.com>
X-Mailer: git-send-email 2.43.0
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

Commit f1204d96450f ("xfs: only free posteof blocks on first close")
introduced XFS_EOFBLOCKS_RELEASED to avoid freeing speculative
post-EOF preallocations across repeated open/write/close cycles.
To reset this flag when a file is truncated down, xfs_file_release()
relies on the XFS_ITRUNCATED flag:

    if (xfs_iflags_test_and_clear(ip, XFS_ITRUNCATED)) {
            xfs_iflags_clear(ip, XFS_EOFBLOCKS_RELEASED);
            ...
    }

However, XFS_ITRUNCATED is an ephemeral flush-on-close flag that is
cleared as soon as dirty pages are written back to disk by background
writeback (xfs_vm_writepages()) or explicit fsync (xfs_file_fsync()).
If writeback occurs while the file is being written, or if fsync()
is called before close(), XFS_ITRUNCATED is cleared. Consequently,
when close() is subsequently called, xfs_iflags_test_and_clear()
evaluates to false, XFS_EOFBLOCKS_RELEASED is never cleared, and
xfs_free_eofblocks() is skipped.

If an open reference (such as a loop device) pins the inode in memory,
the post-EOF blocks remain allocated permanently, causing tools and
tests (such as LTP swapon04) to observe leaked blocks beyond EOF.

The issue can be easily and deterministically reproduced on XFS using
fsync():
 1. Create a file, write data, and close it (sets in-core
    XFS_EOFBLOCKS_RELEASED = 1).
 2. Re-open with O_TRUNC (sets XFS_ITRUNCATED = 1) and write 16 MiB
    sequentially (allocates 32 MiB / 65408 blocks due to speculative
    preallocation).
 3. Call fsync(fd) before close(): xfs_file_fsync() clears
    XFS_ITRUNCATED.
 4. Call close(fd): xfs_file_release() sees XFS_ITRUNCATED is 0,
    leaves XFS_EOFBLOCKS_RELEASED set, and skips xfs_free_eofblocks().
 5. stat() reports st_blocks = 65408 (32 MiB) instead of 32768 (16 MiB).
    Any subsequent swapon discard punches only the 16 MiB swap area,
    leaving 32648 blocks and failing discard assertions.

Fix this by clearing XFS_EOFBLOCKS_RELEASED directly in
xfs_vn_setattr_size() when the file is truncated down, ensuring that
subsequent close() treats the file as truncated regardless of whether
fsync() or writeback cleared XFS_ITRUNCATED in the meantime.

Fixes: f1204d96450f ("xfs: only free posteof blocks on first close")
Signed-off-by: Wei Gao <wegao@suse.com>
---
 fs/xfs/xfs_iops.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index e04b7d9d212d..b216b96d05a4 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -1124,6 +1124,7 @@ xfs_vn_setattr_size(
 		xfs_iflags_set(ip, XFS_ITRUNCATED);
 
 		/* A truncate down always removes post-EOF blocks. */
+		xfs_iflags_clear(ip, XFS_EOFBLOCKS_RELEASED);
 		xfs_inode_clear_eofblocks_tag(ip);
 	}
 
-- 
2.55.0


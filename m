Received: from buxtehude.debian.org (buxtehude.debian.org [209.87.16.39])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 779814D179B
	for <linux-xfs@vger.kernel.org>; Mon,  5 Oct 2026 17:25:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.87.16.39
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791221112; cv=none; b=l/65ByY332cVC3mRStXqaRW5WcB+NZW0vvjQ0vf1nNCPelvJkmse3uuky/cnYJSB2rXwzgnNCIdKqy0WoFP4YNaEVAqy/p5w0O03a6eNQB5LTeOTjGMm+6ojO2EvVccLjlYBSAzd9d5TD3iAH/hHKBb9cvgtjABOEJLL5LezlSU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791221112; c=relaxed/simple;
	bh=HPQFx2is0ieEJVe20uGM4PhbiKW1+p2gDf94Lw0VAsA=;
	h=Subject:References:Date:From:To:Cc:Message-ID:MIME-Version:
	 Content-Type:Content-Disposition; b=fIJu8XcXsuFZesAjin5yHs91zmxOqIjmKIp27gosxGvMziMW9vJvP70DbSvsl7RG0nTJ0ePwrIJz4YpyjAEtCjrwrako4YYTDGgKGszTLvPjk56Iu1zpuBg4te+YvV0WqMskl1woN1Nw1JBb9QeTO3x5Nxmg+LYXFdKPbxpgJsQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=buxtehude.debian.org; dkim=fail (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=BxhrKwzR reason="signature verification failed"; arc=none smtp.client-ip=209.87.16.39
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=buxtehude.debian.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BxhrKwzR"
Received: from debbugs by buxtehude.debian.org with local (Exim 4.96)
	(envelope-from <debbugs@buxtehude.debian.org>)
	id 1xDmQw-00Eegw-0I;
	Mon, 05 Oct 2026 17:25:02 +0000
X-Loop: owner@bugs.debian.org
Subject: Bug#1149571: [ANNOUNCE] xfsprogs: for-next updated to caca7f14b449
Reply-To: Andrey Albershteyn <aalbersh@redhat.com>, 1149571@bugs.debian.org
Resent-From: Andrey Albershteyn <aalbersh@redhat.com>
Resent-To: debian-bugs-dist@lists.debian.org
Resent-CC: linux-xfs@vger.kernel.org
X-Loop: owner@bugs.debian.org
Resent-Date: Mon, 05 Oct 2026 17:25:01 +0000
Resent-Message-ID: <handler.1149571.B1149571.17912210033491538@bugs.debian.org>
X-Debian-PR-Message: followup 1149571
X-Debian-PR-Package: xfsprogs
X-Debian-PR-Keywords: 
References: <179080491253.7201.8697529754428195540.reportbug@mars>
X-Debian-PR-Source: xfsprogs
Received: via spool by 1149571-submit@bugs.debian.org id=B1149571.17912210033491538
          (code B ref 1149571); Mon, 05 Oct 2026 17:25:01 +0000
Received: (at 1149571) by bugs.debian.org; 5 Oct 2026 17:23:23 +0000
X-Spam-Level: 
X-Spam-Bayes: score:0.0000 Tokens: new, 125; hammy, 150; neutral, 78; spammy,
	0. spammytokens: hammytokens:0.000-+--UD:kernel.org, 0.000-+--diffstat,
	 0.000-+--UD:git.kernel.org, 0.000-+--gitkernelorg,
	0.000-+--git.kernel.org
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:51637)
	by buxtehude.debian.org with esmtps (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <aalbersh@redhat.com>)
	id 1xDmPK-00EeIv-2l
	for 1149571@bugs.debian.org;
	Mon, 05 Oct 2026 17:23:22 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1791221001;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=G/Fp1l+4O2G/kdbq36fNWAo+kb/ppuNf3q/OqZtqd4s=;
	b=BxhrKwzRFaqPIDM/y1ngeveNqRPqC1vVzA0wrU7JTII8OjCb+RZgtVErU+Sa0VxmpRl53E
	6caCOmw2CtTHolnL4RqatRwQBhDGoi5OrbpANiVqiQdHNwWSYr41sIS+/05IgJjGoRBdnY
	xBQR2aikKZzpd0tula1XHav399QbXjw=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-683-EEfZiNj4NXqWEh3ZHVSWfQ-1; Mon, 05 Oct 2026 13:22:15 -0400
X-MC-Unique: EEfZiNj4NXqWEh3ZHVSWfQ-1
X-Mimecast-MFC-AGG-ID: EEfZiNj4NXqWEh3ZHVSWfQ_1791220935
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-4a028616bebso17402395e9.1
        for <1149571@bugs.debian.org>; Mon, 05 Oct 2026 10:22:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791220934; x=1791825734;
        h=content-disposition:content-type:mime-version:message-id:subject:cc
         :to:from:date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=G/Fp1l+4O2G/kdbq36fNWAo+kb/ppuNf3q/OqZtqd4s=;
        b=vHz6osPdrr9h+jiIaw1vNjbrlgdlZErdo73AG6DN/kBpHMt+Voa+wS6rsBFelU+K0j
         ky62ZDaMYlhTHnlBos6G41IcxxksRkKhfEpIdg8m2uUD3EhpmRriJshrSQszc1LDN23I
         XxczYy5gpXolffa84+GMsxKz23DuqPkgnoEV9AolCLdv/15xKU6SyDbmgEvLbtUA6222
         6w4io6sWrss2QGDouPkHn4E5PIv18IZp28dYkLtYimpdRKhKaksxGqj5Dd90TMeA+OWb
         en3EZxixDExjUzPWeyEsDzwa0hOMCr3yj7kxufP2veHWXIph8rTWG6N0bSEI0KHJp6Bf
         mYFQ==
X-Gm-Message-State: AFuF++nAuU/uYNoJFc0bjL0IEZTiNSRgaChPnaVrikmdmgaA6nn6CpdC
	PzcWb2n2ezBXBaFXakLxm8fPD1jYQ3t2aBXxUYV+nzCHi0PC+ij9rctxn5gJAO9f4R12NtZum6x
	3GNgLnxyW7AgkF4MQgVcBcYoh3LKCOO45AQHRl0CMKzJhLvogJ6cEJNiWlw==
X-Gm-Gg: AYBFou0tPdjWc9kqz1wmjsxkhiC3kSFy1/qHzJDTVzJS80z++F6145to3TDaCsSUgMn
	lUzSEYwaLPkAQWg9AfXjgpeKMk0vkZ3l8cvt8i0aprJwTlxeeOvclPH4623rBCuwLH1EOu55bSq
	TfOUQJ52i+SWlNzfhcQ6yZVmkhU9Zt4zf1upa/NEOjyqeYM+e4ZLwedru3EHgw0fQ6m85ZOsKy6
	r5g7eKUR/cwzjNR7eZcLsCSXxGPvoLtnhALnldOLrRQuY6Er5QXrWxQFzpl0NuyA8MN1rKTIhBm
	jUxm3XIJGSa1gYI/WYEro3345QrQbqrvzlzkRsKENE2BqdnFGH9XtrVndpYyn5OXVe8gU2N2y5I
	u0ieBNM9uiovveKCJxMwA6ncfp+X1zf+WpA==
X-Received: by 2002:a05:600c:4fc1:b0:49f:f099:6fb1 with SMTP id 5b1f17b1804b1-4a02756f148mr192739755e9.15.1791220934501;
        Mon, 05 Oct 2026 10:22:14 -0700 (PDT)
X-Received: by 2002:a05:600c:4fc1:b0:49f:f099:6fb1 with SMTP id 5b1f17b1804b1-4a02756f148mr192739335e9.15.1791220933961;
        Mon, 05 Oct 2026 10:22:13 -0700 (PDT)
Received: from aalbersh-thinkpadx1carbongen13.rmtcz.csb ([217.30.74.39])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a178c33091sm5790085e9.4.2026.10.05.10.22.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Oct 2026 10:22:13 -0700 (PDT)
Date: Mon, 5 Oct 2026 19:22:13 +0200
From: Andrey Albershteyn <aalbersh@redhat.com>
To: linux-xfs@vger.kernel.org
Cc: 1149571@bugs.debian.org, aalbersh@kernel.org, biebl@debian.org, 
	djwong@kernel.org, hch@lst.de, linux-xfs@vger.kernel.org, sandeen@redhat.com
Message-ID: <asPcwLl90eFEnfB6@aalbersh-thinkpadx1carbongen13.rmtcz.csb>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: PzhaTeX2IQohS79-WBVdXRLLQy-44K5CgFWXZzp_7VI_1791220935
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Message-ID: <20261005172213.cO9b8hzCpGD1V2VN-57JFPspjLCvDduU6_zrCs44EV8@z>

Hi folks,

The xfsprogs for-next branch in repository at:

	git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git

has just been updated.

Patches often get missed, so if your outstanding patches are properly reviewed
on the list and not included in this update, please let me know.

The new head of the for-next branch is commit:

caca7f14b449c94583a263e5d4e51354e86529f8

New commits:

Christoph Hellwig (10):
      [8a4a368b497d] libxfs: refactor the reinit case in libxfs_buftarg_init
      [08c91516ffa7] libxfs: split error injection option parsing out of libxfs_buftarg_init
      [8f9506e2dafc] libxfs: remove buftarg member aliases
      [35e136a42548] libxfs: unify buftarg handling with the kernel
      [55ec0ef299d5] libxfs: make the size check in rtmount_init internal RT device aware
      [c189d771732e] libxfs: don't clear ->dev in libxfs_device_close
      [45c2b2ae6968] libxfs: fix buftarg initialization for the RT device
      [d69aadab419e] libxfs: rename bt_bdev*
      [5f82a09e37bc] libfrog: improve ramdisk handling in platform_flush_device
      [e58810a53900] xfs_db: remove a double-whitespace in rdump_regfile_data

Darrick J. Wong (2):
      [d28edf8b3722] xfs_healer: correct xfd_ API usage
      [fde1eeed253a] xfs_healer: fail earlier on non-xfs filesystems

Eric Sandeen (3):
      [196c46c1bd31] libxfs: change cache_node_allocate function signature
      [92d45f837671] libxfs: Return -ENOMEM on actual cache node allocation failures
      [caca7f14b449] libxfs: do not allow cache growth to overflow

Code Diffstat:

 copy/xfs_copy.c          |   2 +-
 db/io.c                  |   4 +-
 db/metadump.c            |   7 +--
 db/rdump.c               |   2 +-
 healer/xfs_healer.c      |  14 ++++-
 libfrog/linux.c          |  13 ++--
 libfrog/platform.h       |   2 +-
 libxfs/buf_mem.c         |   4 +-
 libxfs/cache.c           |  54 ++++++++++++----
 libxfs/init.c            | 161 +++++++++++++++++++++++++----------------------
 libxfs/libxfs_io.h       |   4 +-
 libxfs/rdwr.c            |  50 ++++++++-------
 libxfs/stubs/xfs_mount.h |   3 -
 libxfs/trans.c           |   4 +-
 libxfs/util.c            |   2 +-
 mkfs/xfs_mkfs.c          |  10 ++-
 repair/attr_repair.c     |  11 ++--
 repair/da_util.c         |   2 +-
 repair/dino_chunks.c     |   8 +--
 repair/dinode.c          |   8 +--
 repair/phase3.c          |   2 +-
 repair/phase5.c          |   6 +-
 repair/prefetch.c        |   6 +-
 repair/quotacheck.c      |   2 +-
 repair/rt.c              |   2 +-
 repair/scan.c            |  16 ++---
 repair/zoned.c           |   2 +-
 27 files changed, 228 insertions(+), 173 deletions(-)

-- 
- Andrey

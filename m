Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6612A13DBA0
	for <linux-xfs@vger.kernel.org>; Tue, 24 Feb 2026 07:17:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771917459; cv=none; b=APfYOObFkR6sUY03eLPd/M+00m/d5Q8rcF2025F/RBp+zx5RsfkjpI/V8i2qg1UhrisbsFwkgFtEr/TmUZ46v1NzLCFahQvuLsEsf3RNxM7fMWlITuDrRqjiL/r5Mzy2O3ARm2XNfWANjpCFkgkjyacMI7YPnipa78SUMoLnX34=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771917459; c=relaxed/simple;
	bh=awDSGMLi8gE1Mu1yYIRLuy+ygNXS7LrEgADWQcpzrYs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=jrjc54G11iH4CoAA2c4EL7qIpJLQTH0DRAhC4QzmzHzY8mlQEb8taFN3d744MZtrtuA3ebaIARWopIyEXg693WFc/zieUB988LVGztGhyP+ceWu0XGGz4kRiZn7IERJGd6LbyBaFEmxBrNGYPhSxgtxo0VhTZzGJR3vLgdpLfpg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=BkJxTuel; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=PvDxfeu7; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BkJxTuel";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="PvDxfeu7"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1771917457;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=6NYu8pY1ouCPtZ2vDY1nZ88AhTeLCns0XORKWdlEN2w=;
	b=BkJxTuelSloHdWgzwFwvLC/4ggvLo9C+ZgFm18DLrj4Lbi16+DaRVnW+FlLlecUuC3pDt/
	DzcBkkwEIgzwgI17tagJZgHeU7reRUliAGqpm18oa2+lLE6J4DD3snnEi2jlarI9rv9sB7
	TUz1c8lfxnCB1klIUZcNvcyiu0WmoYY=
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com
 [209.85.214.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-201-LyOIpRjPMi2rCsI0rr8iow-1; Tue, 24 Feb 2026 02:17:35 -0500
X-MC-Unique: LyOIpRjPMi2rCsI0rr8iow-1
X-Mimecast-MFC-AGG-ID: LyOIpRjPMi2rCsI0rr8iow_1771917455
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-2a7d7b87977so55332245ad.0
        for <linux-xfs@vger.kernel.org>; Mon, 23 Feb 2026 23:17:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1771917454; x=1772522254; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=6NYu8pY1ouCPtZ2vDY1nZ88AhTeLCns0XORKWdlEN2w=;
        b=PvDxfeu7LkqqMUb3W6KdDoirSjEc/vVxy5nR8LZVCPXyX3Lr90VmCimKEYcl2v/h+r
         oHtAxjIlLAjcBF165dgcRgZt2YBzasoUQF21N+F7X3r3I0a5xzNF5P+i7JynX6EU6HHR
         uJxbCNJgJ8lJ1RdUV7Zrh5/6F2Q0KIBJ6WWbd9je+/I7rWgJAbvjio/47Z49e0JwuugM
         gvgvLay5hnYFOjoA15Wb6+Kxfe1xACikjQBKNas0orW3QLSwWz5TvREFRaVBZ19v/Wnd
         6ZxNbCmgJDR41jGyqU8a66sKspBo8QngpyGQ9afp1YadP1ba4+jcg/GiWE58Ag74bael
         2bxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771917454; x=1772522254;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6NYu8pY1ouCPtZ2vDY1nZ88AhTeLCns0XORKWdlEN2w=;
        b=FdYN00utxM+c/8ltoBWJNJOrlATRyTUijyEG88IVtZ78R0j61pIirJTyr12G/KBnkB
         J/AGrfXa/zdWktxuunNXf1G5KmK7YQ418CyyuIb3JU89sbIhtquRnQ32O0uUpwIA5LhU
         DrcDUW27wLS0s/AnwP09I2XxD62uPSHxxcepW9WLxAzM3umAnloh832Td7SansBahWMX
         T/g7symGldVpwQLUaIm1tz0vgNNDuoS1hynrWK3eVKm2grafGGZ48Yd4t3E+grQ0Y5Da
         6nBA88Igmw4k3JMhUoxbXiWwS5xin6hG8+5U1IAxMzlEwhsGTxjnyKTFwhP7ALrEa2/T
         ckGg==
X-Gm-Message-State: AOJu0YzLHSqHOX5wZ5pEFzY2awRYqQ9neVSYY/InJx5e61p571UtcEyE
	4y/eUEGPEfB16WfzJsGBVfsDLZcEAHhSdseydkhkE6j8Z4NXePZuyW2qhrLOX7YgY9XT9ZPxZSl
	4EpX1MQ/B15KYKhofiG/ltYjNJvKT5p2Js5ShlKMQ9se8kVT24aG6Q7xDZO+YmL/DM5TdaPxQm7
	7ncYwlZre7BVaAdC4pHo+D9LxxQ3+peqjyMnIxGi5JF+eqiQ==
X-Gm-Gg: ATEYQzwsP3WHndrdkiC2ffkNx6bLzmQo0UG2ADlAbELlQBi/mdhS4WzTiSirQSGYJ4v
	LfQNqovt+8kDOUiJmrUHT2CSilvk/BTS2gCbl2vcY61kv+VECIpN5+eUfdg4WtoLJ9XUbE0lXXn
	xJbZpIdDDaAvOb9BopiZOUFQvist2CVRR4+IWjyk6BSnCAYIoMk4uUpS3Y5mq9/OGa3FU+Zt2rZ
	AaLI/HlRbidrTvKyi3q/cqJyi9bby6DAVGAnOxgyYDIjvD2IJHhKPLkN8/uth/KBWcnOhAAKkcv
	GXMMot9RwFtKV8f53ivzTE23GHL51N4ndZFEYBuLViDZmHyXkdFvYBkLpSFO0mMCvvbiIzFyCib
	Mcyi2L2jdKif4/vgkdJpN/iUhuNfvaq2cow==
X-Received: by 2002:a17:903:11d2:b0:2aa:e6c8:2c6e with SMTP id d9443c01a7336-2ad7457a8c8mr96669455ad.56.1771917454225;
        Mon, 23 Feb 2026 23:17:34 -0800 (PST)
X-Received: by 2002:a17:903:11d2:b0:2aa:e6c8:2c6e with SMTP id d9443c01a7336-2ad7457a8c8mr96669225ad.56.1771917453644;
        Mon, 23 Feb 2026 23:17:33 -0800 (PST)
Received: from anathem.redhat.com ([2001:8003:4a36:e700:56b6:ee78:9da2:b58f])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ad80907b4csm58720515ad.78.2026.02.23.23.17.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Feb 2026 23:17:32 -0800 (PST)
From: Donald Douwsma <ddouwsma@redhat.com>
To: linux-xfs@vger.kernel.org
Cc: Donald Douwsma <ddouwsma@redhat.com>
Subject: [PATCH 0/5] xfsdump, xfsprogs distro builds and DEBUG=
Date: Tue, 24 Feb 2026 18:17:07 +1100
Message-ID: <20260224071712.1014075-1-ddouwsma@redhat.com>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

tldr; Fedora builds with -DDEBUG, is that what folk want or expect?

We see cases from the field where xfsrestore aborts on an assert(3).
In each case there's a real problem that needs to be fixed, but these
problems are preventing folk from restoring their data. With the asserts
suppressed or removed xfsrestore usually does something sane enough, at
worst leaving restored content in the orphanage where a user can find
it.

This was notably seen with the original xfsdump bind mount fix, now
we're seeing asserts fire during cumulative restores in
noref_elim_recurse.

  xfsrestore: tree.c:1421: noref_elim_recurse: Assertion 'isrealpr' failed

This appears to be caused by a rename to within the tree between restore
levels, or a combination of modifications during occurring during the
dump. Fixing it will likely require changes in noref_elim_recurse, or
tree_post, to ensure elements of the tree are created for these edge
cases.

But why are we seeing assert(3) active in Fedora based distro builds?

xfsprogs and xfsdump m4/package_globals.m4 shows builds should default
to DEBUG and xfsdump doc/INSTALL talks about how to turn off asserts and
create an optimized build, but only Debian has its build rules in-tree,
where they set DEBUG=-DNDEBUG.

Building locally on Fedora or similar gets varied results with recent
Fedora versions building as if DEBUG=-DNDEBUG was set within the realm
of configure or autoconf, which may be misleading people.

But for Fedora release builds we can see that they're building with
DEBUG=-DDEBUG resulting in gcc called with -DDEBUG in the build logs.

  https://src.fedoraproject.org/rpms/xfsdump
  https://kojipkgs.fedoraproject.org//packages/xfsdump/3.2.0/4.fc44/data/logs/x86_64/build.log

  https://src.fedoraproject.org/rpms/xfsprogs
  https://kojipkgs.fedoraproject.org//packages/xfsprogs/6.18.0/2.fc44/data/logs/x86_64/build.log

I don't think the intention was to have these build as DEBUG, but that
seems to be the current result. But before I dig into this further can I
confirm what people think this should do?

The following series is illustrative of the changes to build xfsdump
cleanly with DEBUG=-DNDEBUG, or the type of downstream workarounds
required to help end users hitting problems for the status quo.

Don

Donald Douwsma (5):
  xfsrestore: remove unused variable strctxp
  annotate variables only used for assert
  xfsrestore: include TREE_DEBUG all builds
  xfsrestore: remove failing assert from noref_elim_recurse
  xfsrestore: assert suppression workaround

 common/drive_minrmt.c    |  5 +--
 common/drive_scsitape.c  |  5 +--
 common/drive_simple.c    |  9 ++---
 common/main.c            |  6 +--
 common/mlog.c            |  6 +--
 common/qlock.c           | 18 ++++-----
 common/ring.c            |  2 +-
 dump/content.c           |  8 ++--
 include/config.h.in      |  4 ++
 man/man8/xfsrestore.8    |  4 ++
 restore/Makefile         |  6 ++-
 restore/content.c        | 36 +++++++-----------
 restore/dirattr.c        |  3 +-
 restore/getopt.h         |  4 +-
 restore/inomap.c         |  9 ++---
 restore/restore_assert.c | 39 +++++++++++++++++++
 restore/restore_assert.h | 18 +++++++++
 restore/tree.c           | 82 ++++++++++++++--------------------------
 restore/win.c            | 24 ++++--------
 19 files changed, 148 insertions(+), 140 deletions(-)
 create mode 100644 restore/restore_assert.c
 create mode 100644 restore/restore_assert.h

-- 
2.47.3


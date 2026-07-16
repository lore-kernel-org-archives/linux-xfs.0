Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1830D328B4B
	for <linux-xfs@vger.kernel.org>; Thu, 16 Jul 2026 19:47:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784231248; cv=none; b=Z25HbATqFf7I6kdz+9WhEJOsvhIZJjoX9pwwSvx3yu8OZr6q8bstBaxSsELaoolRBxJrERj2hjPnev3nUMqNfapDPAc4hAu552nvq10Zw8rGYbwx2XQk9XV/fcaUm9G2hhGNoLAW9ftOOfn0tJROZpqM6NGhB94/YOminOB0Vzc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784231248; c=relaxed/simple;
	bh=apsKxCXBBJhOrEWIEfsu9HfNbb2ohijT4lx29ZYPuEY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qTRReats9qwMjD2pkOqUT7lw8O8ycnMDl6EAuv+9C7cWBexweQW1HPyUa/bmYiVib1gO/ypC5WzG9qSlgMjyqhRtORHFyKmGrQvYq7tEEVahSa5+87IIYLnlejveUCBetj9xG6+qvAGX4IAhfHN5pbJNHt2hzJMc6iYLIH6Eias=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=Ok89dV2k; arc=none smtp.client-ip=209.85.221.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="Ok89dV2k"
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-4720f3bf164so431142f8f.1
        for <linux-xfs@vger.kernel.org>; Thu, 16 Jul 2026 12:47:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1784231244; x=1784836044; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=4K6Sk5G4U5Wr6YiGiWV6CWaqqXOEaTOhfB+u2CmX/tI=;
        b=Ok89dV2kpFmBdQm2l9+hR/gDDj0ilH7WEN+yuM55PpcHk/NJPYJM/DQbhO4aTzX/5I
         4zvBhuAXaMUnmMkSrx4D/I5XHUbM7Js2/3dShWulLzmMRkXXD6tad4MTMUQpBQtUngD/
         UMoCO6HsoN7k9bXGzLhTBC/ttB5MQJEgNAD1w5dR89CHDkm/odKcjzA1M91qs5Vo/23A
         sDpstjD1k+znpZu+N/fvm/aBauKWLgoxoTTQq4EgiFZo+g2gV3FO+jGpjOKyWPp12Nvo
         28/0UCtgNzSZ0cwDZTxP2K5tTFVWkXdJ9J4kAaIuuXisOZorJytdFCx93U+CTA7byAHm
         gepA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784231244; x=1784836044;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=4K6Sk5G4U5Wr6YiGiWV6CWaqqXOEaTOhfB+u2CmX/tI=;
        b=KwjUZSS+D09Dswm3YxkAeRcMD3Kds8yoQSMt+UTRddEu4LbmVkyTIz6NrUljLWx+0c
         qCkpFKreG7nGT74IEC76CtSQSUFpqx1S3qt+MsCx2YeiYtLKjNhAoFk6ixSH2tWGYSHk
         gbwTI3BYgAk+t8+KBfspIOyO/k4pm59kbIinnJ5/EQxKkdt3FBo2jzQPAbJemJAlk0/w
         TyTZ7F50kET1tlZaJVoztqTqxrq7RWxw+cU1Kj+R7PXDstnyV0P3WzBNWW5PE11xvTWq
         5q+zpUjyNdUbwQLAdFwq3pMlqBDUCJpVaMlf6yLec7Pivb446lVVCdcNuEwPsRVWHZZU
         cFcQ==
X-Forwarded-Encrypted: i=1; AHgh+RoeSUaknH2x75kDKK1x6DyWOnVTEmtJqa81iOa/jU+bi2Fsn4XRZVk1kwBf79rkqDOgXbGAoeACdbk=@vger.kernel.org
X-Gm-Message-State: AOJu0YzKESoPm4uh8rr5/3aQHpQa1AMStOug1f6o4YcDRq3VYeLFePFg
	/yOy8OfbPikkPvjL2ODBroCrYv1cVxQjCTZJBzYAayoWVbNrK+Aij51AtXzbKmW+jhA=
X-Gm-Gg: AfdE7clZeDrlZlwv1TX6xpe4jusgKe2CZ0y4iXt1MCUiJY1zLI+nhQ/G3yPEgX+5Hy2
	xswtllV0WVCD+inAOMmuxVy6fWwYuMETWwbqDaYfZfZ2UZAsgTq2TlUIqRq/YGVVKg97C45Z61L
	Za7IdzhBatnkcsoEBYvK2CL5qmQRjQpT2lYoCyPItCZWWbejeb7GteSeWoh83aViqL7wEUNBJBQ
	CdlsdbS3h1vyT4Clwac2YKxZOFpcWptXJrkWdycHU794AMD2L1SY7YZIC5pM+EjMX+3oTb9dr7s
	XqDqykZcOT69d5PcxAcq8BqtCJO1oCiTNW79C1R+Cjp5ToscbNIOdw4xqncjWutup8wlh3FgR3s
	qYZKv6EzN7MdTUip/NoKf7HIIIuUxMNOCpmZtfAyAd/jkZiomQ6/qcH1nDsMJTo4z
X-Received: by 2002:a05:6000:2c11:b0:46f:8561:fe60 with SMTP id ffacd0b85a97d-47f5a548693mr5406869f8f.17.1784231244149;
        Thu, 16 Jul 2026 12:47:24 -0700 (PDT)
Received: from localhost ([2a07:b241:1004:8300::1000])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47f4635aa34sm24445244f8f.15.2026.07.16.12.47.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jul 2026 12:47:23 -0700 (PDT)
From: Avinesh Kumar <avinesh.kumar@suse.com>
To: djwong@kernel.org
Cc: cem@kernel.org,
	fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: [PATCH v2] libfrog: make cmn_err() emit each message atomically to avoid torn output
Date: Thu, 16 Jul 2026 21:45:49 +0200
Message-ID: <20260716194723.191090-1-avinesh.kumar@suse.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716151329.GA7371@frogsfrogsfrogs>
References: <20260716151329.GA7371@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Avinesh Kumar <avinesh.kumar@suse.com>

fstests xfs/033 fails sporadically with a spurious blank line in the
xfs_repair output:

- output mismatch (see /opt/xfstests/results//xfs/033.out.bad)
    --- tests/xfs/033.out	2026-06-24 15:52:51.000000000 -0400
    +++ /opt/xfstests/results//xfs/033.out.bad	2026-07-14 18:54:46.582495041 -0400
    @@ -103,6 +103,7 @@
     Phase 3 - for each AG...
             - scan and clear agi unlinked lists...
             - process known inodes and perform inode discovery...
    +
     bad magic number 0xffff on inode INO
     bad version number 0xffffffff on inode INO
     inode identifier 18446744073709551615 mismatch on inode INO

Root cause is in cmn_err() (libfrog/util.c), which emits a message
and its newline as two separate writes to unbuffered stderr.
xfs_repair's threads all share stderr. If one is preempted between the
two writes, another thread's line lands in between:

(snips from `cat -A 033.raw`) -
Phase 3 - for each AG...$
        - scan and clear agi unlinked lists...$
        - process known inodes and perform inode discovery...$
Metadata corruption detected at 0x445dd3, xfs_inode block 0x80/0x4000        - agno = 0$
$
bad CRC for inode 128$
bad magic number 0x0 on inode 128$

which should be like -

Phase 3 - for each AG...$
        - scan and clear agi unlinked lists...$
        - process known inodes and perform inode discovery...$
Metadata corruption detected at 0x445dd3, xfs_inode block 0x80/0x4000$
        - agno = 0$
bad CRC for inode 130$
bad magic number 0x0 on inode 130$

_filter_repair() strips the noise line it glued onto but not the lone
newline, which then fails the golden diff.

Make the two writes atomic.

do_error() in xfs_repair.c also has same issue, fix that too.

Signed-off-by: Avinesh Kumar <avinesh.kumar@suse.com>
---
v2: fix the do_error() in xfs_repair.c too.

 libfrog/util.c      | 2 ++
 repair/xfs_repair.c | 2 ++
 2 files changed, 4 insertions(+)

diff --git a/libfrog/util.c b/libfrog/util.c
index 5bae5bab..3b6df917 100644
--- a/libfrog/util.c
+++ b/libfrog/util.c
@@ -116,8 +116,10 @@ cmn_err(int level, char *fmt, ...)
 	va_list	ap;
 
 	va_start(ap, fmt);
+	flockfile(stderr);
 	vfprintf(stderr, fmt, ap);
 	fputs("\n", stderr);
+	funlockfile(stderr);
 	va_end(ap);
 }
 
diff --git a/repair/xfs_repair.c b/repair/xfs_repair.c
index 6b97a806..dd758ebc 100644
--- a/repair/xfs_repair.c
+++ b/repair/xfs_repair.c
@@ -458,10 +458,12 @@ do_error(char const *msg, ...)
 {
 	va_list args;
 
+	flockfile(stderr);
 	fprintf(stderr, _("\nfatal error -- "));
 
 	va_start(args, msg);
 	vfprintf(stderr, msg, args);
+	funlockfile(stderr);
 	if (dumpcore)
 		abort();
 	exit(1);
-- 
2.55.0


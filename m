Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6E0B260566
	for <linux-xfs@vger.kernel.org>; Fri,  3 Oct 2025 09:35:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759484120; cv=none; b=P/LAApIYYtly435Hc4GR6RbxpdTUOz855jsbyHAkJL6MIxXGYtWhcmesBMKgt1gHTe4M+5IqZt3js0fTUzFhX+D4dmZxUFV6IBk2aei0ok6oEluZMnSANl2kQeVXIr7ljDnfu2OI8VIGp2z2YsSXKn3MwcbRKjr9K57mUsTNqRY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759484120; c=relaxed/simple;
	bh=vvUJddjEBDF+Ztgm1hAHoT+ASJXHJAAKJ82WwfFRfu4=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=EZKwSwhDk/oi/s7FRNpjjw9Thw6chSLrYMx+LoSh7QP09ioQnc0yGLdQ0eMnUa/fTNa+3ox3EC1jbJW31PJWDQA8XyACDlvvRyhZtwI/V0GvvgKmtCX2AFqy80vzU9HwIZEGwTcpE1TP7b0sVSK9aIkdLPeEsng2ZC73ZlfA+2U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=LszTdb+c; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="LszTdb+c"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1759484117;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=cTvI1DpoQ3LONUfIqcabKF8qqakEhbOmxQY1Lj6nxQQ=;
	b=LszTdb+c0rcTsgXuoO6AVLAXZ9BL8mrzux8sDkDGULtDIrdtu4IvcHj5dsRdNO1IPjks3G
	qJduB7ScUVoOOaQoWup7UQHm3VwkJKsGHafGAX/B/k1lvYz7ti95OTAbnGZUdgeBel1mPK
	DFVQteDkZhWcPfjWtlqwAuySYA8KzG0=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-507-_PHSo8UHO8mYMK2uB6dbmQ-1; Fri, 03 Oct 2025 05:35:16 -0400
X-MC-Unique: _PHSo8UHO8mYMK2uB6dbmQ-1
X-Mimecast-MFC-AGG-ID: _PHSo8UHO8mYMK2uB6dbmQ_1759484115
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-3ee12ab7f33so1290751f8f.2
        for <linux-xfs@vger.kernel.org>; Fri, 03 Oct 2025 02:35:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759484115; x=1760088915;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=cTvI1DpoQ3LONUfIqcabKF8qqakEhbOmxQY1Lj6nxQQ=;
        b=n8XDT7z4HP9Lv6OVwyJ6ayDso2+EKA3TlDlUiRT/67kdivBDH5WFuF7RP4i3ns6v11
         /V5alBRzYM9rqwvoghkKSQnOKh7TwU9ZP7W+IS7XTO8Cma7CTNggELL/YVcYqTW79/zM
         LQyHWjbNRDFHQ+NLp8O82OzceFQneTXCUsAdBcO/2opuPql7o2If4n1Aap1SXOTsKYQV
         tJBbGAs8oIZ0NSUSiUF+D8jGvaUq3fi4fm0JAUAAltcHGVGUJWDFkSP7Yt4Am2Jy5TEC
         bHW5BRMDY7BSqPDq2+62veitz2O5zN9rMyQfiVjkxoTaX/KPjcMm4dYXEW+pprGiephW
         49Kw==
X-Forwarded-Encrypted: i=1; AJvYcCWFx+Rza+jqUnmh+LoqJ51X+/c3dMhLb1/1rip0VzrAdFdu9Jrn2ed9OcHp6iMN8TeVDNdsQFICZVk=@vger.kernel.org
X-Gm-Message-State: AOJu0YwA2h+jIfu2/3ZB8Gj2yxMGtfM4VwFd6aQQj/gBNOnFUjmN/Yqt
	AgdBcPv/LPf4htkiYupQ3jTx8s3IQ2EopOAOgcznW0Fn6NVvHE1HY64V8VKGqCGQbX3SV5YnCX4
	989h7N+FhVaKA4Z8N1S56gb9syqiKGYiaQUydLZtBxu5/SmCtX19ZhQSRrUDO
X-Gm-Gg: ASbGncuLwBf8c2Xh7mWWFsF+O0ZUyxPu8ASXbc1fxYwFDed7ED8hcHofIbtslgKA3W1
	pfVzJZZINg8x6wMoIXE/+y/4m2YDLfJjii40aJ7bF1SRCtQi//YDe5kR29+iYoLzbtpesaeNCbf
	0XDbdgP/PtyLfPYy0IClhiURziUHufFKc+54XwZ6y8gpvhLKLz+bA5eXnY+whdFe1Cx95HxHGAM
	pwRmInAGr20zVPQPmWw74DfTnsukA0Vqfut3uVVUltxQTQqmbk7ktFTFpDeZdNlLEbdy8eQn7WL
	G5osB8JZXw7scOq61YoH5MHd0eDuc9wl1udxYtkeCipOlCRAWiL64r5r+y70qwskjjt9tKgP
X-Received: by 2002:a05:6000:288d:b0:3d1:6d7a:ab24 with SMTP id ffacd0b85a97d-4256714bdb4mr1271047f8f.17.1759484115155;
        Fri, 03 Oct 2025 02:35:15 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IH0vyuKNoB3TDCcPMspLmidueip+wl7tYR26n0nTXJo0IDYg1kMeuPVLq6KLG4A5ZpZfhojIQ==
X-Received: by 2002:a05:6000:288d:b0:3d1:6d7a:ab24 with SMTP id ffacd0b85a97d-4256714bdb4mr1271019f8f.17.1759484114612;
        Fri, 03 Oct 2025 02:35:14 -0700 (PDT)
Received: from [127.0.0.2] (ip-217-030-074-039.aim-net.cz. [217.30.74.39])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46e61a020a3sm121695005e9.10.2025.10.03.02.35.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Oct 2025 02:35:14 -0700 (PDT)
From: Andrey Albershteyn <aalbersh@redhat.com>
X-Google-Original-From: Andrey Albershteyn <aalbersh@kernel.org>
Subject: [PATCH v4 0/3] Test file_getattr and file_setattr syscalls
Date: Fri, 03 Oct 2025 11:32:43 +0200
Message-Id: <20251003-xattrat-syscall-v4-0-1cfe6411c05f@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIADuY32gC/2XNQQ6DIBCF4auYWZcGBBW66j2aLqgOSmrUACEa4
 92LdtE0Lv+XzDcreHQWPdyyFRxG6+04pBCXDOpODy0S26SGnOYF5awisw7B6UD84mvd9wRRmgL
 zpkQmIV1NDo2dD/HxTN1ZH0a3HA8i29evJak8WZERSkpNVS0Mrwyj9ze6Afvr6FrYsch/gKLqD
 PAEqJcWkjMhKqn+gG3bPkXgEBTwAAAA
X-Change-ID: 20250317-xattrat-syscall-ee8f5e2d6e18
To: fstests@vger.kernel.org
Cc: zlang@redhat.com, linux-fsdevel@vger.kernel.org, 
 linux-xfs@vger.kernel.org, Andrey Albershteyn <aalbersh@kernel.org>, 
 "Darrick J. Wong" <djwong@kernel.org>, 
 Andrey Albershteyn <aalbersh@redhat.com>
X-Mailer: b4 0.15-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=2156; i=aalbersh@kernel.org;
 h=from:subject:message-id; bh=vvUJddjEBDF+Ztgm1hAHoT+ASJXHJAAKJ82WwfFRfu4=;
 b=owJ4nJvAy8zAJea2/JXEGuOHHIyn1ZIYMu7PuFiVNFlSp31Tg6o8o7oE+xkXo3cWqYzM4rwvJ
 r5oMnGuPNtRysIgxsUgK6bIsk5aa2pSkVT+EYMaeZg5rEwgQxi4OAVgIvlZDH/Fc21s+h4uW6L8
 7YJoZOVl85LTIiecjiqefrIiOF5n1e0PDP+jb4nm3n+99ttT1gXWRzP5Xn/9eN/o2Yw0y1/beWa
 UVC/iAAA710mh
X-Developer-Key: i=aalbersh@kernel.org; a=openpgp;
 fpr=AE1B2A9562721A6FC4307C1F46A7EA18AC33E108

Add a test to check basic functionallity of file_getattr() and
file_setattr() syscalls. These syscalls are used to get/set filesystem
inode attributes (think of FS_IOC_SETFSXATTR ioctl()). The difference
from ioctl() is that these syscalls use *at() semantics and can be
called on any file without opening it, including special ones.

For XFS, with the use of these syscalls, xfs_quota now can
manipulate quota on special files such as sockets. Add a test to
check that special files are counted, which wasn't true before.

To: fstests@vger.kernel.org
Cc: zlang@redhat.com
Cc: linux-fsdevel@vger.kernel.org
Cc: linux-xfs@vger.kernel.org

Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
---
Changes in v4:
- Use _filter_file_attributes to focus only on nodump in generic/2000
- Add _filter_file_attributes to common/filter
- Link to v3: https://lore.kernel.org/r/20250909-xattrat-syscall-v3-0-9ba483144789@kernel.org

Changes in v3:
- Fix tab vs spaces indents
- Update year in SPDX header
- Rename AC_HAVE_FILE_ATTR to AC_HAVE_FILE_GETATTR

Changes in v2:
- Improve help message for file_attr
- Refactor file_attr.c
- Drop _wants_*_commit
- Link to v1: https://lore.kernel.org/r/20250808-xattrat-syscall-v1-0-6a09c4f37f10@kernel.org

---
Andrey Albershteyn (3):
      file_attr: introduce program to set/get fsxattr
      generic: introduce test to test file_getattr/file_setattr syscalls
      xfs: test quota's project ID on special files

 .gitignore             |   1 +
 common/filter          |  15 +++
 configure.ac           |   1 +
 include/builddefs.in   |   1 +
 m4/package_libcdev.m4  |  16 +++
 src/Makefile           |   5 +
 src/file_attr.c        | 274 +++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/2000     | 109 ++++++++++++++++++++
 tests/generic/2000.out |  37 +++++++
 tests/xfs/2000         |  73 +++++++++++++
 tests/xfs/2000.out     |  15 +++
 11 files changed, 547 insertions(+)
---
base-commit: 3d57f543ae0c149eb460574dcfb8d688aeadbfff
change-id: 20250317-xattrat-syscall-ee8f5e2d6e18

Best regards,
--  
Andrey Albershteyn <aalbersh@kernel.org>


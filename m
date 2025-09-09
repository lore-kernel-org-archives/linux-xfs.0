Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBD7F2BB17
	for <linux-xfs@vger.kernel.org>; Tue,  9 Sep 2025 15:24:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757431488; cv=none; b=MCydOhgnRfXKIpvOpT6hgtsoX3PR3kReWTnDJD2GJ0HI5DH/LkncpqmI4zlQ92g7EHvxOGaidb7ZLgZ/b4JVrGzjNUruJUoTlVTPClZasx+VWBEwEYmqqhaFO4fYet5NXrJf8b3CD4Mk3RWCwxOtce0STxah8BjxB8zppx5sMu4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757431488; c=relaxed/simple;
	bh=qLI7K7SjBg75kFVpuEMsnQPGUHaOHPFdi7ri3LAszIA=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:
	 In-Reply-To:To:Cc; b=pOzhKgNupfChZLdxeNdJWRSHxJI8HsGDkbzkRiUlBFm9e/0gMC4DKN9ZCtAw3/D5/6LTNMidJVJc4UNrxIz4b0nAPplpvTpNb/MxmrO1TXLTsrsL1niZdmnYY6xgrCm9rGf173tziYrqHDpEc3HeuvcuR/2kFlKEWe8IXABfJKg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=STDkYNtF; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="STDkYNtF"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757431486;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:  in-reply-to:in-reply-to;
	bh=EVQrM7vvGg2wr9cyg1VwAlrBbHtBHMrtY7DnkbL5fuU=;
	b=STDkYNtFZXl8FSelh6bMe5kBTVS18sIuxUXFDK/ltgNedqOEuUszucVs7WQflbfCwvIBdp
	Bwi4lqBed4Qn+pWWlVwxOAMJ9t98xoyuwTvRxvvve7xvix4BlprAhf0X20bg7ZmWXObrZb
	MkDn7feN3yJtDXCNwNX98xT3fe1BDq0=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-467-5-EBhoTKPiKpVvTD25htbA-1; Tue, 09 Sep 2025 11:24:44 -0400
X-MC-Unique: 5-EBhoTKPiKpVvTD25htbA-1
X-Mimecast-MFC-AGG-ID: 5-EBhoTKPiKpVvTD25htbA_1757431484
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-3dbf3054ac4so3434376f8f.3
        for <linux-xfs@vger.kernel.org>; Tue, 09 Sep 2025 08:24:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757431483; x=1758036283;
        h=cc:to:in-reply-to:content-transfer-encoding:mime-version:message-id
         :date:subject:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EVQrM7vvGg2wr9cyg1VwAlrBbHtBHMrtY7DnkbL5fuU=;
        b=qAqHK2T/E+NlJYSsTr9J5kQO3zGwiUOh5/9w+Q4ccueV+M+Y9xdRwxQrCIRa2iowVZ
         PkwqJUKYni+vUugfLZYgDa2r5CzsCVFge1mEzDlnTmtQXfqR0sbIM37F7mR3L/y7Qwti
         tz3KLiQWfar0bMpHXuzSmHKi36snhQqm+M6r3L5YKGU7cs2t4SzlKJg6vwX2TQIjbfjr
         bWctg/KG3X1QSbtvXi7HvP+iq0SO4dw5oEBHxAGFYefxrz42xLm0SoXXBwoIgmUdSWku
         aTJ1D/Ha7NKCcBN2EhgS6C7JZHM/NcGI33MEBcv9YKWE+nPtB/x71oBiuF6K9jksn1Xs
         vv7g==
X-Forwarded-Encrypted: i=1; AJvYcCVRVM1KdvzJFvanCp3jwyeRSHhEcqp0O5tNvzZ3wYF+ywQyQlWiLsC0Vsxrvmz1m29UFrFOO91YfO0=@vger.kernel.org
X-Gm-Message-State: AOJu0YwBV8t2SLxzLj42hOY/Zm4OkTvSAY7vgXB1+YKT6i/KBXRPRdtu
	ljCOvuPevfgC5jsno0HeGTVqrXreSOVvm/PWzAE3kWqgW7goDbDFw477AEzjCe3DaVQpU/V4+7b
	ZKXebwyXG8FBdlGmNkGk3FXzZkuu8nj7vovwMr3i4uQTzipJmfTNggvGMVnF0
X-Gm-Gg: ASbGnctJjJwQeVi2V7dgFwlA1JLsQkH13MzSmrVMJn1HD5aTEVOYyuPz0wVtPQIt6fK
	TaJXvMkF/EuoKgudGpSFZ39keRolW+g6GOyUiPZPF+6S/TSCcZHDCZmTShqOsanmuTt4T+APOvi
	MO35Iz8RuJZRU1SPsDdJfV4Eg0tuAmB0m9c9fH3BnVSm9fHAkBXl6YXTwR4irml7rz8pbBAnxWV
	w/SD0CAGpQ+swyrv1TX8/BBKesgRmc00CAVpCp9qEgDkCV6W7JcwXI91oKR2gNzsl5QCv71b6+G
	rLkGq26IQcdu76+C30W7fU2BzEMj+xcFohbq5z4=
X-Received: by 2002:a05:6000:3108:b0:3d6:212b:9ae2 with SMTP id ffacd0b85a97d-3e643ff9652mr10220482f8f.63.1757431483576;
        Tue, 09 Sep 2025 08:24:43 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IET43k6r7zmrgVjEPOzVzXuIKLSqrOCLzwj6hxs/9rooTTnKM2oQAJL5BkN8TiuGwtdt3/+uw==
X-Received: by 2002:a05:6000:3108:b0:3d6:212b:9ae2 with SMTP id ffacd0b85a97d-3e643ff9652mr10220461f8f.63.1757431483113;
        Tue, 09 Sep 2025 08:24:43 -0700 (PDT)
Received: from [127.0.0.2] ([91.245.205.131])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45df17d9774sm11432015e9.9.2025.09.09.08.24.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Sep 2025 08:24:42 -0700 (PDT)
From: Andrey Albershteyn <aalbersh@redhat.com>
X-Google-Original-From: Andrey Albershteyn <aalbersh@kernel.org>
Subject: [PATCH v3 0/4] xfsprogs: utilize file_getattr() and file_setattr()
Date: Tue, 09 Sep 2025 17:24:35 +0200
Message-Id: <20250909-xattrat-syscall-v3-0-4407a714817e@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIALNGwGgC/2WNzQqDMBCEX0X23JR0gzbtqe9RPORn1VDRsglBE
 d+9IdcevxnmmwMicaAIz+YAphxiWJcC6tKAm8wykgi+MKDEVqrbXWwmJTZJxD06M89Cq8dg0Vr
 pOgVl9WUawlaNb8gK+pJNIaaV93qSsTbVp/Hfl1FIodGgR9/qrrWvD/FC83XlEfrzPH+b9gfgs
 wAAAA==
X-Change-ID: 20250317-xattrat-syscall-839fb2bb0c63
In-Reply-To: <mqtzaalalgezpwfwmvrajiecz5y64mhs6h6pcghoq2hwkshcze@mxiscu7g7s32>
To: aalbersh@kernel.org, linux-fsdevel@vger.kernel.org, 
 linux-xfs@vger.kernel.org
Cc: Andrey Albershteyn <aalbersh@redhat.com>, 
 "Darrick J. Wong" <djwong@kernel.org>
X-Mailer: b4 0.15-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=1698; i=aalbersh@kernel.org;
 h=from:subject:message-id; bh=qLI7K7SjBg75kFVpuEMsnQPGUHaOHPFdi7ri3LAszIA=;
 b=owJ4nJvAy8zAJea2/JXEGuOHHIyn1ZIYMg647Wr0f7ht6kevFYlS64ymSOnUrZ8yw+58ufzfz
 UyZcrFHbVg7SlkYxLgYZMUUWdZJa01NKpLKP2JQIw8zh5UJZAgDF6cATKRXkpFhs8DGq4G2BXle
 E/63iO6TaFC/nbKh7PrmiW86+Xa4ctyKZmT4cPT52dTVnw6uEmzRsbu2q+ZtzGHlHVP+6U+Zckb
 u+uN1jAAdgEna
X-Developer-Key: i=aalbersh@kernel.org; a=openpgp;
 fpr=AE1B2A9562721A6FC4307C1F46A7EA18AC33E108

Hi all,

This patchset updates libfrog, xfs_db, xfs_quota to use recently
introduced syscalls file_getattr()/file_setattr().

I haven't replaced all the calls to ioctls() with a syscalls, just a few
places where syscalls are necessary. If there's more places it would be
suitable to update, let me know.

Cc: linux-fsdevel@vger.kernel.org
Cc: linux-xfs@vger.kernel.org

---
Changes in v3:
- Fix tab vs spaces indents
- Update year in SPDX header
- Rename AC_HAVE_FILE_ATTR to AC_HAVE_FILE_GETATTR
- Link to v2: https://lore.kernel.org/r/20250827-xattrat-syscall-v2-0-82a2d2d5865b@kernel.org

---
Andrey Albershteyn (4):
      libfrog: add wrappers for file_getattr/file_setattr syscalls
      xfs_quota: utilize file_setattr to set prjid on special files
      xfs_io: make ls/chattr work with special files
      xfs_db: use file_setattr to copy attributes on special files with rdump

 configure.ac          |   1 +
 db/rdump.c            |  20 ++++++-
 include/builddefs.in  |   5 ++
 include/linux.h       |  20 +++++++
 io/attr.c             | 138 ++++++++++++++++++++++++++++--------------------
 io/io.h               |   2 +-
 io/stat.c             |   2 +-
 libfrog/Makefile      |   2 +
 libfrog/file_attr.c   | 121 ++++++++++++++++++++++++++++++++++++++++++
 libfrog/file_attr.h   |  35 +++++++++++++
 m4/package_libcdev.m4 |  19 +++++++
 quota/project.c       | 142 ++++++++++++++++++++++++++------------------------
 12 files changed, 380 insertions(+), 127 deletions(-)
---
base-commit: 1d287f3d958ebc425275d6a08ad6977e13e52fac
change-id: 20250317-xattrat-syscall-839fb2bb0c63

Best regards,
--  
Andrey Albershteyn <aalbersh@kernel.org>


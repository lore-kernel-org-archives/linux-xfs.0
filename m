Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C09F21E5710
	for <linux-xfs@vger.kernel.org>; Tue, 29 Jul 2025 11:01:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753786882; cv=none; b=MfTdH/SVYD9XF19bu3MkYTxaqhTkGxB04Fjx3D/btmnJmdiChv/V/cjyzNyfCt+kpszCbYs8PyqetaFRQ809Y3+c6VvWZxITkpZxO9JthYs1ZXijY3cDfCCjWxYki1jwNPPspuNzSvYiyZZkzM6e1y55iNI+SM1dWalrZsc7Smw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753786882; c=relaxed/simple;
	bh=fikE8a849ZvY0NqSVIqK/RvVCx5SzlJ3sPLvJdLN+zg=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=F8jwVhOWRX2UOf8pp2MFfXlMT5bdiaVYUhHy1o50IBNzJm/KgpbW6ggEPXoKJaDXZwVFIib1fhqCrrZXtU7wDes0vzv/FWjVRQ1mQLD8FEbBYLFaLMmC09o1Vlxa1sKfwUnvoJoJCLe/I9n6CNji9hHBvE1+SsWQop17+uGPVVQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=PrdKtT06; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PrdKtT06"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1753786879;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=3zLcxJlB9KjasNQVBbTWC3tte0FM2CG2Uz2Lto4+22k=;
	b=PrdKtT06o+CRiq+Uy2TIuP2UEx7U/iPNSvHKuzWBvhceAtWd5EidZZHXXCgVK2HWdoMc4e
	bgsA/3/jq1Fqq7myUR+je6/LTGfZbCXTfqrrOML3srLFUUtJFjYXF98VgG2oG/UDFLfTve
	5K07UNr+ZcarUSxOiYceLOgA7MZi6M0=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-93-ANWi2sWxOH6MVxFCg7Oz0g-1; Tue, 29 Jul 2025 07:01:18 -0400
X-MC-Unique: ANWi2sWxOH6MVxFCg7Oz0g-1
X-Mimecast-MFC-AGG-ID: ANWi2sWxOH6MVxFCg7Oz0g_1753786876
Received: by mail-ej1-f72.google.com with SMTP id a640c23a62f3a-ae6d6b8eacbso419506666b.0
        for <linux-xfs@vger.kernel.org>; Tue, 29 Jul 2025 04:01:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753786876; x=1754391676;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3zLcxJlB9KjasNQVBbTWC3tte0FM2CG2Uz2Lto4+22k=;
        b=MzDSsYgkBaqUuB7NuG481hd4NfA5XVuC9rt/LXlrIBj1rYhEE3SvZhqYxlk9ti2Gim
         eNA7AfPJKoPJHZqn+q2oaZQ0caWm2ec/q1eEs/Uq6SVTGX8r/4AzE4emYA24bv35sWeg
         QDBFTZr6CUuUK5TSCzuS1eMMC9Gx190Ww+7+ZMtdfm47L2p2PFCKGSOik/01zvILRPR5
         wLiCM3IUCiQdrCkHPYfbuV9jk3PdgEldyYT7PnafdY5DDHLs9TTOVqViprqtZyCZAsOy
         GVQRYSlfH7nSziTgqNn2SrjIpIqZm+ZH/dYmgGuRzkFyDnkzy7F1UBuHmiqYUQxE9FIx
         hL5Q==
X-Forwarded-Encrypted: i=1; AJvYcCWRJJuVd2BNN98qwLirAaJ1DwGAkeaXGR6Qwkp9pAroT7iVmWNK5rgSLLS154n8U8w+gDiiXDvwCoI=@vger.kernel.org
X-Gm-Message-State: AOJu0YxPkt81huooau2KGAz/GQd9WCu6xH24yuRgtZUpYNS2Z7p2UfZY
	Ogwb61A8nkXJSnTShF57oMedojFZLASofHOEH5G78jHai5iNbtXTkp/PL/77JM7ugNF2jRyN2pm
	vgnaKbJlRwkk89kCjiY/jyryjLCW3lw4hChSbB/iOnMOI7oIJOg3PJSMGtO7a
X-Gm-Gg: ASbGnct40Yem54SvY0UPm4kS9FSGPRB77z3gRKiD0vh6ERxRCtZodpXhOxV6DeGpUkT
	UmRxMvFsUSJQpW/7/cS/8d0BD+Hn4jq3vsYpOkQ0eZzAqVZSI8yGZR68OLgm1zhpX5SlnDH3O09
	YoquW11z84vKhMQ+3gX+UWA9eOtvhuHyepBHwqx6VI4iACBcH+ods9nna3YXe8+uNnVvNDtitfM
	G8Va5lIH7222HidGCRU6o/7561k75xzXUE/UinTAMEbd7U/doQ2/Aje69ZcFwRlf9fq++8BAU3/
	RtVXgEHFfNGWZc6WH+yt/Ce6XwW9hPqjJ+Rl4iaRz3fjug==
X-Received: by 2002:a05:6402:dc4:b0:609:9115:60f1 with SMTP id 4fb4d7f45d1cf-614f1da65a6mr11612383a12.16.1753786875822;
        Tue, 29 Jul 2025 04:01:15 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGtewM2nKaI4fUPc4mUO8XjfWcubAB+Fq2RkF9arLtNad0e/NqNg1C1T9ETP05+qc6zYK1DEA==
X-Received: by 2002:a05:6402:dc4:b0:609:9115:60f1 with SMTP id 4fb4d7f45d1cf-614f1da65a6mr11612331a12.16.1753786874813;
        Tue, 29 Jul 2025 04:01:14 -0700 (PDT)
Received: from [127.0.0.2] (ip-217-030-074-039.aim-net.cz. [217.30.74.39])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-61563b3edd8sm1083884a12.47.2025.07.29.04.01.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Jul 2025 04:01:14 -0700 (PDT)
From: Andrey Albershteyn <aalbersh@redhat.com>
X-Google-Original-From: Andrey Albershteyn <aalbersh@kernel.org>
Subject: [PATCH 0/3] Use new syscalls to set filesystem inode attributes on
 any inode
Date: Tue, 29 Jul 2025 13:00:34 +0200
Message-Id: <20250729-xfs-xattrat-v1-0-7b392eee3587@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIANKpiGgC/6tWKk4tykwtVrJSqFYqSi3LLM7MzwNyDHUUlJIzE
 vPSU3UzU4B8JSMDI1MDYyMD3Yq0Yt2KxJKSosQS3SRjw0TLNNPUFCMLEyWgjoKi1LTMCrBp0bG
 1tQD3gMSXXQAAAA==
X-Change-ID: 20250320-xfs-xattrat-b31a9f5ed284
To: cem@kernel.org, djwong@kernel.org, linux-xfs@vger.kernel.org
Cc: Andrey Albershteyn <aalbersh@redhat.com>
X-Mailer: b4 0.15-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=941; i=aalbersh@kernel.org;
 h=from:subject:message-id; bh=fikE8a849ZvY0NqSVIqK/RvVCx5SzlJ3sPLvJdLN+zg=;
 b=owJ4nJvAy8zAJea2/JXEGuOHHIyn1ZIYMjpW/ozw4S/uc7vhE9R7OTLjwFuW6Gnff+Zk/mD/l
 xe3u+1E+++OUhYGMS4GWTFFlnXSWlOTiqTyjxjUyMPMYWUCGcLAxSkAE7m3nOF/xUPXWdHXvIpu
 hPypm99zasqN9BDnun3n2JSOrLQ2tCrIZvhfHV0bt7v0R1CG7eqEi2v6n/mvSdXs740UEtmkzv2
 3awkjADbATI8=
X-Developer-Key: i=aalbersh@kernel.org; a=openpgp;
 fpr=AE1B2A9562721A6FC4307C1F46A7EA18AC33E108

With addition of new syscalls file_getattr/file_setattr allow changing
filesystem inode attributes on special files. Fix project ID inheritance
for special files in renames.

Cc: linux-xfs@vger.kernel.org

---
Darrick, I left your reviewed-by tags, as the code didn't changed, I just
updated the commit messages. Let me know if you have any new feedback on
this.

---
Andrey Albershteyn (3):
      xfs: allow renames of project-less inodes
      xfs: allow setting xattrs on special files
      xfs: add .fileattr_set and fileattr_get callbacks for symlinks

 fs/xfs/xfs_inode.c | 64 +++++++++++++++++++++++++++++-------------------------
 fs/xfs/xfs_ioctl.c |  6 -----
 fs/xfs/xfs_iops.c  |  2 ++
 3 files changed, 36 insertions(+), 36 deletions(-)
---
base-commit: 86aa721820952b793a12fc6e5a01734186c0c238
change-id: 20250320-xfs-xattrat-b31a9f5ed284

Best regards,
-- 
Andrey Albershteyn <aalbersh@kernel.org>


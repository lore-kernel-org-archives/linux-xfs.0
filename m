Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6538E1FC109
	for <linux-xfs@vger.kernel.org>; Wed, 16 Apr 2025 14:44:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744814692; cv=none; b=RT/vIfQsbAsXs5EpI1wevCvRMsxF8hDLdvv656gGeNys6BcOhq6i+Y0IXdST1jF35YGhcs8ZH5NxJuuPIixi0K/N4F5XvXn6r5RIJeBqiKafOKqLA8Qct0ZCeY76e9/Vw69FxJtOkwLByy9z08X+IXQNFiNJO7JcncUz5rSCves=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744814692; c=relaxed/simple;
	bh=W8PsYtxecDHQtlWWGFV7dHT9V7QmgH8WW3t7YZELHzk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IPsN1chmotClBmhrX+ZA+E4ygIaKogRmlFdfDlP0oB0rWOUY7AMxnccnGOzeLvCHkqI+gdSDLwGYUHE7ZHk3j04EIyvx87mn1a35GukvHATWLsY1hdqhxNqkB5hv1JG5SYxaCmn0grnVs/3SeYr2VQXcALme/SJIk7qRb07xv3o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UMPL2UF3; arc=none smtp.client-ip=209.85.208.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UMPL2UF3"
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-5ed1ac116e3so10514493a12.3
        for <linux-xfs@vger.kernel.org>; Wed, 16 Apr 2025 07:44:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1744814688; x=1745419488; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yR31uWjwmuuBRtt1HHlCz+o+4lsC+PPt2kNwunz/WWw=;
        b=UMPL2UF3sUnGzfyJjBRS8qPhpZuyhQ+k4mFU2K/IFp2vimUvIQz7cUV49zfHwptPg0
         byvvqGYV/YhOjNpWBc3PCG8+umRFrXP7lxYU035TyLDtgLEt4NesXqahI3RjfhK5DpnC
         UvtGUuJAo4polj6ag1nPqflPQPdO5oMezbrhlkZOMA3gAhcHJyIZYWd2OQw1cY5W/RtP
         cb38hopxT67d7+BixWmtjXVrtuHIHEBj7MnflvSasroRWuiyjPb6wqdRbRcIirz/reBB
         OCcC80vZq1vAE0lR6Ir4LO7J5thSqnIdwP4jSXUnKjMQd8BRmY2Dj7NSZSZ0pUHfFxtS
         yJsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744814688; x=1745419488;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yR31uWjwmuuBRtt1HHlCz+o+4lsC+PPt2kNwunz/WWw=;
        b=ptiAVnfZ/cQKtTm37GK1U4ICKy64WhGoF56H29IXglksrraK3ira7J3k3C23pmNEST
         +pQ7xjYYxSJ+T7AIm5PLc1ajwATTmsc5TXkO/u9MUVgDGx/5In7qmwROAg/7RemxVL49
         jg2cqL3PWGJcSWdIkTIaYyxp5EndiZsJqMgGjkaT3XidjJlnLSUfyZFLJlR2eWCbgYWd
         uD4fANZf0sUR8FpkGaBhvfXQUDHgunqb+JVYKoja2o71TO7euBRI+UFW3Tdq+9f1kQFO
         pp7zNkIno+1qLxkxC6S/DIJIyDDtTIzOCUxbYA/FrbWlwi7YECyNKYLZEKMwt3FwufHY
         miSw==
X-Gm-Message-State: AOJu0Yx83aWyebP4rcSpRkVsgekkdZH/+kQ+qPfmvEH8b8oyeHktM+E+
	4hZ0pijO6/g5ubvMKfEBKNPPFmkFqqPcSzB42NvdKe/iAS0XkRukG2n5pg==
X-Gm-Gg: ASbGncvkoLwaGUEhh3v17/7Tht9qLq+18pdVMect92UFNgM25G2mpkOqYNVkBy5T+Rv
	otikN/2YbM/ThUTnK+2RTSzhDKPp8VYmL8FxmYyIetQCa7VHApnmf6qQ2DXgdCOXbI0GSV5uEFa
	Qe8yinPGpMMlpMEcl3hsggo3Bl2XeQi0mu2BlEZZPy7k9Rht0UjHTlW78iyflaxNupAqLjjRBte
	BPcaLTSKmwPfDGU34alKVBzlijZZWgaUzsszPyLneiJSwXX2DdzBPtXxDTo8Vl8BQRYmcFoWiEe
	6183equJ04zB8T3SxmQyqzGWQeuKifosD7nMM7AxnMCQNNu534k=
X-Google-Smtp-Source: AGHT+IHgV/zCOddQHUiRKJdd76ghAkZsx9PxZDmk4Z0uVK6BXVbzA6V1II9PX7audGMGRQPNN5/j0Q==
X-Received: by 2002:a17:907:2d8a:b0:aca:d5a1:c324 with SMTP id a640c23a62f3a-acb42571ad4mr220068166b.0.1744814688248;
        Wed, 16 Apr 2025 07:44:48 -0700 (PDT)
Received: from localhost.localdomain ([2001:b07:646e:16a2:521a:8bc0:e205:6c52])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-acb3ce59962sm141167966b.78.2025.04.16.07.44.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Apr 2025 07:44:47 -0700 (PDT)
From: Luca Di Maio <luca.dimaio1@gmail.com>
To: linux-xfs@vger.kernel.org
Cc: Luca Di Maio <luca.dimaio1@gmail.com>,
	dimitri.ledkov@chainguard.dev,
	smoser@chainguard.dev
Subject: [PATCH RFC 1/2] xfs_proto: add origin also for directories, chardevs and symlinks
Date: Wed, 16 Apr 2025 16:43:32 +0200
Message-ID: <20250416144400.940532-2-luca.dimaio1@gmail.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250416144400.940532-1-luca.dimaio1@gmail.com>
References: <20250416144400.940532-1-luca.dimaio1@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In order to preserve timestamps when populating target filesystem, we
need to have a reference to the original file.

This is already done with regular files, we extend this to dirs,
symlinks and chardevices.

Excerpt of old protofile:

```
/
0 0
d--755 0 0
: Descending path rootfs
 bin   l--777 0 0 usr/bin
 lib64 l--777 0 0 lib
 sbin  l--777 0 0 usr/bin
 dev d--755 0 0
  console c--620 0 0 5 1
  null    c--666 0 0 1 3
  random  c--666 0 0 1 8
  urandom c--666 0 0 1 9
  zero    c--666 0 0 1 5
 $
 lib d--755 0 0
  ld-linux-x86-64.so.2   ---755 0 0 rootfs/lib/ld-linux-x86-64.so.2
```

Excerpt of new protofile:

```
/
0 0
d--755 65534 65534 rootfs
: Descending path rootfs
 bin   l--777 65534 65534 usr/bin rootfs/bin
 lib64 l--777 65534 65534 lib rootfs/lib64
 sbin  l--777 65534 65534 usr/bin rootfs/sbin
 $
 dev d--755 65534 65534 rootfs/dev
  console c--620 65534 65534 5 1 rootfs/dev/console
  null    c--666 65534 65534 1 3 rootfs/dev/null
  random  c--666 65534 65534 1 8 rootfs/dev/random
  urandom c--666 65534 65534 1 9 rootfs/dev/urandom
  zero    c--666 65534 65534 1 5 rootfs/dev/zero
 $
 lib d--755 0 0 rootfs/lib
  ld-linux-x86-64.so.2   ---755 0 0 rootfs/lib/ld-linux-x86-64.so.2
```

Signed-off-by: Luca Di Maio <luca.dimaio1@gmail.com>
---
 mkfs/xfs_protofile.in | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/mkfs/xfs_protofile.in b/mkfs/xfs_protofile.in
index e83c39f..066265b 100644
--- a/mkfs/xfs_protofile.in
+++ b/mkfs/xfs_protofile.in
@@ -51,12 +51,12 @@ def stat_to_str(statbuf):
 def stat_to_extra(statbuf, fullpath):
 	'''Compute the extras column for a protofile.'''

-	if stat.S_ISREG(statbuf.st_mode):
+	if stat.S_ISREG(statbuf.st_mode) or stat.S_ISDIR(statbuf.st_mode):
 		return ' %s' % fullpath
 	elif stat.S_ISCHR(statbuf.st_mode) or stat.S_ISBLK(statbuf.st_mode):
-		return ' %d %d' % (os.major(statbuf.st_rdev), os.minor(statbuf.st_rdev))
+		return ' %d %d %s' % (os.major(statbuf.st_rdev), os.minor(statbuf.st_rdev), fullpath)
 	elif stat.S_ISLNK(statbuf.st_mode):
-		return ' %s' % os.readlink(fullpath)
+		return ' %s %s' % (os.readlink(fullpath), fullpath)
 	return ''

 def max_fname_len(s1):
@@ -105,8 +105,8 @@ def walk_tree(path, depth):
 		fullpath = os.path.join(path, fname)
 		sb = os.lstat(fullpath)
 		extra = stat_to_extra(sb, fullpath)
-		print('%*s%s %s' % (depth, ' ', fname, \
-				stat_to_str(sb)))
+		print('%*s%s %s%s' % (depth, ' ', fname, \
+				stat_to_str(sb), extra))
 		walk_tree(fullpath, depth + 1)

 	if depth > 1:
@@ -134,7 +134,7 @@ def main():
 		statbuf = os.stat(args.paths[0])
 		if not stat.S_ISDIR(statbuf.st_mode):
 			raise NotADirectoryError(path)
-		print(stat_to_str(statbuf))
+		print(stat_to_str(statbuf), args.paths[0])

 		# All files under each path go in the root dir, recursively
 		for path in args.paths:
--
2.49.0

Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89B4C1CAA98
	for <linux-xfs@vger.kernel.org>; Wed, 16 Apr 2025 14:44:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744814685; cv=none; b=Ud0mwYa1YQlB/rBAnbQq0crIBMCySuc9tSIrC7YCCP+KQgy6tIQI1H4kcPS6aqU+cZpSH0NPCVOZ0UBOojCYN5WDWg4rd7YFEqdmsQ0Xxew8RrJsHCwsx5RcZ9Eben55YmTL4I/A5RjI56XwK65gJPL68qf+SzF+6yFb2VwMLfw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744814685; c=relaxed/simple;
	bh=EEe3OjGdfZRMKI7RbNeIKYIcieQF/8uvDB1eLCPqWFs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=AU9DNkyNQ1j3q+6zcfDdrbmmDCRAK6VQLAz3G4GULHoNQpinCsjDL3pBoqy7qtG5Z4nHlw6pmEzEN8aiOmo/nTUkqslahEKqqVojLI8LjmDBeFGW4DO29uWq8qoLe7UImHz3qWrhYzMhAtrhrF6hZ2p9fL+jfn9H9gWDWO06LlQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ER8hUdza; arc=none smtp.client-ip=209.85.218.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ER8hUdza"
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-ac3eb3fdd2eso1272132866b.0
        for <linux-xfs@vger.kernel.org>; Wed, 16 Apr 2025 07:44:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1744814682; x=1745419482; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=arzn7QIdiKz6aulHd9qrcwXef+2xnU12V3474bb5hts=;
        b=ER8hUdzargGfLsKmVBPoaOw7xmtF0SaXAgn3qy7Wosw59gd+ZHt+v2KfNifSjd+FVw
         DGF9jU9MUoGdxRB7sKc+3tEUtz+q8fsrCkdtOJ9PKbs8dRTH5tiYpKqHbsh2NZBLiFS1
         Fj7w1+oMZUEWrCoKax0lhI1kxmEtutltg4SyAvbrWPudNHyThJhvWlT3t7vHL64lV6R+
         FJq1zATKQw1wL0bX4vJPfJT/+Gpjt7tRJk4+Ee1DCr94eoh3kGfUDGdrd0BL1ko2kUMa
         whhRyPdxZCl+Nm6r+CHTtlrwVXZsQ+TyZohBkf7ox0oGR2sUp9LNXuNZbfaqghQYECnd
         I0Qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744814682; x=1745419482;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=arzn7QIdiKz6aulHd9qrcwXef+2xnU12V3474bb5hts=;
        b=MEFGl6aYd6g0y1G7H9iHe8b+T4pJgrArOIcvx8CfbylbBOeeLp15KjX7Hel1ojwDs/
         15F1tP6VPf8ACv3EgpShiKR7ex69OTlP/ykm3VRBjgleP4v4Itd0BGYEqlmr2jZPx8px
         JYK3olTKF9WD1K4BqjOmvf94M0RSCOGWHlGz9ZtIzVmwwZEV8HHBK65vDDDCJ+fDfMHR
         FjXeVO3iz2K7VouTNebGZeia2s4qJPHXaBp4R/rmHQBdfbxjYJHUxhcWCeuOEfvEsK4F
         +oRxpAy0TIyT58suUwIkQomaFvNiXzz+6fxxzdHEyen2n0scDAg8F7I7quas6CfIbUvx
         mWxQ==
X-Gm-Message-State: AOJu0YxgJgU5VWMcH02t/qLjd5O2Ljk6SfZY3nrbDLGrjn4B1/oKJaBT
	co0q26LBZezaj6XiP+PjpZsht7V7P0vfZlDxdtOP3yp8iJbTrWWShfh4xQ==
X-Gm-Gg: ASbGncvbYyHQSA7nV0ndclYMHLiYRhSK6csqflBdF53DzV+pVLyZ4RCpsiCanqNvBUN
	yzHIewyvZnh60EBHRulxdJ2+YG9J9rjrcuiJIZEeRnxkJXCPiOGePDRDL6raoWABO+SSnnPZTuE
	6wu8PE8y8xE3WN/gmobEwvw6ryL0Fo6SxC7jnU6dMNCAoHR4638CfcyyLKaSiCTGin7VaZkFbrJ
	BYmkxmk+D2VioVqSebE/b0OainpyXuD+5srKL+KrZMV6BkqCAYWVLeTrVuKPsWOWiBkV4O0hG4v
	STKDmJzbuM6gNFSm0h/iFLSsj1EulkZFJEtmIlkExx7BjomfD6c=
X-Google-Smtp-Source: AGHT+IEtz5gLJfwpB0Oi4rNaeRsgkgl0/ABiC5SEkVND0whDfcMLo8SJ1hHwgiJbgfWQ0cJQbWLY9w==
X-Received: by 2002:a17:906:dc8b:b0:ac3:bdd2:e709 with SMTP id a640c23a62f3a-acb42877dc9mr224552166b.11.1744814681491;
        Wed, 16 Apr 2025 07:44:41 -0700 (PDT)
Received: from localhost.localdomain ([2001:b07:646e:16a2:521a:8bc0:e205:6c52])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-acb3ce59962sm141167966b.78.2025.04.16.07.44.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Apr 2025 07:44:41 -0700 (PDT)
From: Luca Di Maio <luca.dimaio1@gmail.com>
To: linux-xfs@vger.kernel.org
Cc: Luca Di Maio <luca.dimaio1@gmail.com>,
	dimitri.ledkov@chainguard.dev,
	smoser@chainguard.dev
Subject: [PATCH RFC 0/2] prototype: improve timestamp handling
Date: Wed, 16 Apr 2025 16:43:31 +0200
Message-ID: <20250416144400.940532-1-luca.dimaio1@gmail.com>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi all,

This is an initial prototype to improve XFS's prototype file
functionality in scenarios where FS reproducibility is important.

Currently, when populating a filesystem with a prototype file, all generated inodes
receive timestamps set to the creation time rather than preserving timestamps from
their source files.

This patchset extends the protofile handling to preserve original timestamps (atime,
mtime, ctime) across all inode types. The implementation is split into two parts:

- First patch extends xfs_protofile.in to track origin path references for directories,
character devices and symlinks, similar to what's already implemented for regular files.

- Second patch leverages these references to read timestamp metadata from source files
and populate it into the newly created inodes during filesystem creation.

At the moment, the new `xfs_protofile` generates a file that results
invalid for older `mkfs.xfs` implementations. Also this new implementation
is not compatible with older prototype files.

I can imagine that new protofiles not working with older `mkfs.xfs`
might not be a problem, but what about backward compatibility?
I didn't find references on prototype file compatibility, is a change
like this unwanted?

If so, what do you think of a versioned support for prototype files?
I was thinking something on the lines of:

- xfs_protofile
  - if the new flag:
    - set the first comment accordingly
    - add the additional information
  - else act as old one

- proto.c
  - check if the doc starts with the comment `:origin-files enabled`
	(for example)
  - if so, this is the new format
  - else old format

Eager to know your thoughts and ideas
Thanks
L.

Luca Di Maio (2):
  xfs_proto: add origin also for directories, chardevs and symlinks
  proto: read origin also for directories, chardevs and symlinks. copy
    timestamps from origin.

 mkfs/proto.c          | 49 +++++++++++++++++++++++++++++++++++++++++++
 mkfs/xfs_protofile.in | 12 +++++------
 2 files changed, 55 insertions(+), 6 deletions(-)

--
2.49.0

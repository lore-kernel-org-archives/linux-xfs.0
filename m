Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8144C222577
	for <linux-xfs@vger.kernel.org>; Wed, 26 Feb 2025 14:50:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740581458; cv=none; b=upIcr5iFWdUUvYrMN5OleFdwIZo1YPy03I8ugduhamWN9JOI9MmSb+/FR79A0JHpgSIeTORoACK2R2j7ffCGKlShIN+lUydpE5uskD1NA+5YldgJTypF2vUgGDBBOfwLpgAIpnwSufkyBUlmUas75G9qTCBVHRpyWlPuKo06/zo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740581458; c=relaxed/simple;
	bh=nWXniU+15Xc5fVHjiKp7hiPT8D01Okf4RRSq4ClOuxU=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=AMYtbuUJvWnh5lparUoeRaJf1mJVvef0IYhQpOTolWrkjWeuICGsUg196d7S7rJzGDH1RXtpqc3t9XDwGO7Tzm8uVkpfkIDMPaoSFCGyRvkSUUZbukrsgiiB6LNZSeSl/d9NXQnMeqYqtj0isuFS233bXkPhog+ZwBmHjxMeC4A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=L/8Qjyns; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="L/8Qjyns"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1740581455;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TKPtXsMH69xJKPgfxR6xbzqEWHadgfTeIRJ9Po3KV5I=;
	b=L/8QjynsvOc5lc2T4NxcBHJJhf5OqMwdc61pJtlKEKE9/+EKp5nnehM0eXArI6tyHRb72N
	e9ElJ6SHZBaOU6WAkCip4cWJkM4oHs/u4io+AEItpYFEH3nr+lpv+o8OPA3zeXI/bqkZhx
	jrou7KEHWUbSNUW5dqVUpiibNSa+18Q=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-657-4VWlAgBIMgCgKNAyGNfQ2w-1; Wed, 26 Feb 2025 09:50:54 -0500
X-MC-Unique: 4VWlAgBIMgCgKNAyGNfQ2w-1
X-Mimecast-MFC-AGG-ID: 4VWlAgBIMgCgKNAyGNfQ2w_1740581453
Received: by mail-ej1-f71.google.com with SMTP id a640c23a62f3a-abb93de227dso656416966b.1
        for <linux-xfs@vger.kernel.org>; Wed, 26 Feb 2025 06:50:53 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740581452; x=1741186252;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TKPtXsMH69xJKPgfxR6xbzqEWHadgfTeIRJ9Po3KV5I=;
        b=B+YFkk5YVSmVC1Vs7JfsHdD76HnDj88iS7YObJAH5XkqyX70bTjfQBDcR+oucYN3MW
         C/1gsU6iNumcr+dHi3O1bmDnLVhYA53AU7pgYFo8i8c/rTEh5zxMMzsbdG2uPmSvXePC
         d6gA/Fjy9U5+VcOhCCsBhTqYq1QCewVkG9h9DbSlBFnfpjcd05vWNaBIn2k5nuXXYLn3
         WMdQlUz4TLfJ9GwRoljXGpnfjYvD0pX0wKQcofW3a1lnWKKCPbRcBM9rHdmZbJEiz2SF
         IukOWxCdFyg5ZA2FCpfdWsifv3XsU2MAmhoyjsec4sIkb4mGySDU2tReAPr3G4eVoeEy
         Lwgg==
X-Gm-Message-State: AOJu0YyBxrc+DvsE+6fgSHECFCYIV7eb3z3w8W0XJa/OcJCEZ2Ck2a6H
	JO8rGwe9x40sHpDum3kzX7oE1JSGDG4aeQns2wA5uNVL+wQ+DlbWfVULxU7HKpyTL+13YTs29QZ
	VTTTB/MUzh/LRRdIrX9nCPOLGb9hy5y+GJH9BsQT+Uh0jgXqBdR+oQgig
X-Gm-Gg: ASbGncve5xDblhL679YFjIXA3C0W/gAmeJmrj2/dPnm0oZfOVbelVAjSTYqgbYSRcx4
	LCjLTxSSiJADb8XZydv+lbc74Qwje2XDMjaDTprrtGE3fGd9pv+Iy3+uEDUM2IAvyJUpRkGpsSm
	qzmU2TJfzYoZVFs359AaJOM0Sp7Sd+ksgzlwFajwdayc3yTUUQMQWKE2fUyiLqyceBGZrzPBMQc
	T9D5B/EaLdbh+1I2ECt8ETG2YbnBaNZbbV23hnAKnsJOyHNS3MKqbhJgeMfiQGe6e+GCttDnFSj
	6ma2qsEYcXqft0p8Xpkl2eR14kLqPB+yfLpDVblJ3w==
X-Received: by 2002:a17:907:7753:b0:abb:e7ed:d603 with SMTP id a640c23a62f3a-abed0c76db8mr804354266b.9.1740581452586;
        Wed, 26 Feb 2025 06:50:52 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFYBkKPk62N3G7pEZ1dz89MOAvGyorK44fGFWGmJo7gRoGMTd+nn9OdZiytzlWWn9myeqeGzw==
X-Received: by 2002:a17:907:7753:b0:abb:e7ed:d603 with SMTP id a640c23a62f3a-abed0c76db8mr804351366b.9.1740581452205;
        Wed, 26 Feb 2025 06:50:52 -0800 (PST)
Received: from [127.0.0.2] (ip-217-030-074-039.aim-net.cz. [217.30.74.39])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-abed1cd564esm337731666b.21.2025.02.26.06.50.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Feb 2025 06:50:51 -0800 (PST)
From: Andrey Albershteyn <aalbersh@redhat.com>
X-Google-Original-From: Andrey Albershteyn <aalbersh@kernel.org>
Date: Wed, 26 Feb 2025 15:50:31 +0100
Subject: [PATCH v5 06/10] git-contributors: make revspec required and
 shebang fix
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250226-update-release-v5-6-481914e40c36@kernel.org>
References: <20250226-update-release-v5-0-481914e40c36@kernel.org>
In-Reply-To: <20250226-update-release-v5-0-481914e40c36@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: "Darrick J. Wong" <djwong@kernel.org>, 
 Andrey Albershteyn <aalbersh@kernel.org>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=1798; i=aalbersh@kernel.org;
 h=from:subject:message-id; bh=nWXniU+15Xc5fVHjiKp7hiPT8D01Okf4RRSq4ClOuxU=;
 b=owJ4nJvAy8zAJea2/JXEGuOHHIyn1ZIY0vdrOR/6aR+QpfczbfcC1U132MOdjkT6p64LmMZbw
 vo9LnThj4qOUhYGMS4GWTFFlnXSWlOTiqTyjxjUyMPMYWUCGcLAxSkAEzl2k5Fh/9y4l22z+5ld
 H7n4xkyyCay5YaOqfe7FrpbWLfnycv+PMTKcNPEyc1X5Hv8/88XZx3GXjba+utWt+C7zjX6Y+l5
 t9mwuABqeR8s=
X-Developer-Key: i=aalbersh@kernel.org; a=openpgp;
 fpr=AE1B2A9562721A6FC4307C1F46A7EA18AC33E108

Without default value script will show help instead of just hanging
waiting for input on stdin.

Shebang fix for system with different python location than the
/usr/bin one.

Cut leading delimiter from the final CC string.

Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
---
 tools/git-contributors.py | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/tools/git-contributors.py b/tools/git-contributors.py
index 1a0f2b80e3dad9124b86b29f8507389ef91fe813..01177a9af749776ce4ac982f29f8f9302904d820 100755
--- a/tools/git-contributors.py
+++ b/tools/git-contributors.py
@@ -1,4 +1,4 @@
-#!/usr/bin/python3
+#!/usr/bin/env python3
 
 # List all contributors to a series of git commits.
 # Copyright(C) 2025 Oracle, All Rights Reserved.
@@ -144,8 +144,7 @@ def main():
     global DEBUG
 
     parser = argparse.ArgumentParser(description = "List email addresses of contributors to a series of git commits.")
-    parser.add_argument("revspec", nargs = '?', default = None, \
-            help = "git revisions to process.")
+    parser.add_argument("revspec", help = "git revisions to process.")
     parser.add_argument("--separator", type = str, default = '\n', \
             help = "Separate each email address with this string.")
     parser.add_argument('--debug', action = 'store_true', default = False, \
@@ -160,9 +159,6 @@ def main():
         # read git commits from repo
         contributors = fd.run(backtick(['git', 'log', '--pretty=medium',
                   args.revspec]))
-    else:
-        # read patch from stdin
-        contributors = fd.run(sys.stdin.readlines())
 
     print(args.separator.join(sorted(contributors)))
     return 0

-- 
2.47.2


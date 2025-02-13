Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CC8424BBEB
	for <linux-xfs@vger.kernel.org>; Thu, 13 Feb 2025 20:16:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739477767; cv=none; b=i1YWAilapGU8lLpBCHZupQ3l2b3NTLHq73pQgQfY5HQ8iIG2sCKPAwcpG7IZdBKBf5Bz0MHv8Lk5P6OtaE7rMw8Xv3krI4ysi2M4F3+LkDj6O33uIXAcogjLN7KQk7ik3aJyr5ubigTB8ISbdLfP564A9Yrn+vE2qJm9ZiX1ZRg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739477767; c=relaxed/simple;
	bh=HU9n5NvoPomLXLF6LgaJXXpRdjxvBbILUZwTjWna110=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=suwa/Q2zmYX/ZuyX2VmLeG1kGoqRGNfecY50Oqcnqa7bjGGe/WXLXDimpXTjdEvR8BWoOUbxV4/BAU5Rs105Vo41sv5yFwUVwrzM/X3qES+gEK2NLx+r0SW29a3YS77vwKT6N3p27tA4vRnTtG+2RDcFl+3BTHYMa0/wFa0fZAM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=chGRVmMd; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="chGRVmMd"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1739477764;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8Dwzp/NU0ujGgiL6wnczWrvsNXVl+Zg+N3jt2/uSQpM=;
	b=chGRVmMdTChEbsr1XP2AI742OjPCW7t0u6kLBIg2fEJm9K+VwkmE/5FSk2CYpG5v2j/OF5
	+KB764oV39ZryXTnBTwG0uvzuo90PpSbktl9wyEZsQuXsxoLorYZ8V1ccsICYjh2OHKVc9
	KzOuawu/mJzZRtiGherdrfCm1G9M0hg=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-624-GLIgAOWUNCikjQJKrPY9lw-1; Thu, 13 Feb 2025 15:16:03 -0500
X-MC-Unique: GLIgAOWUNCikjQJKrPY9lw-1
X-Mimecast-MFC-AGG-ID: GLIgAOWUNCikjQJKrPY9lw
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-4395f1c4366so7130045e9.3
        for <linux-xfs@vger.kernel.org>; Thu, 13 Feb 2025 12:16:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739477761; x=1740082561;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8Dwzp/NU0ujGgiL6wnczWrvsNXVl+Zg+N3jt2/uSQpM=;
        b=Gfax9DWv49ZV0d1Vakp+dXIf+efusX95ShJ58vCYX5PdIWCtA/WsBymmtTiV+t/yr1
         dsv8hPUQZr0weF2DbM1kdlpqH6bQMkXe1WWL9Ax4CmGpKFaU9UsT2VLeOJWHKluR2Vte
         2jj74G2+GtrJ7zlXHjmVrf8UALW5JmsFWduWhtChJLLvW49rAAg7X3L36gxMHykMOz3g
         nxr/ICYC8eOwVTIl+DJAeVQtXn9FpkdtIUTIl8TTfZArPq2fYtplKR4jI6lBlrQZVyZj
         /7CUz9/89TZb3GznWjwkzHDW6SQ8EkTMNliG7h55oN2eoPYSJ4e7xD7U6wocpuJLDvUa
         dTbA==
X-Gm-Message-State: AOJu0YyDSu2TKrKBYBIBoIPGLUC1Hvff6itZAf8+Tiomq47al3cJXr5Y
	NadkMMBlqwrItVNLs4jnHy4XCXiaXxfHA9XA+iK1DS+O/In/Lj8U4/Vn45sMZtlSKXr93z4xAzo
	83hVB30RD/fsqDW8qjb4G7Q5klDET8g47l383lBy4PdGkrdSqYkY6qiyxbcaAaKiD
X-Gm-Gg: ASbGncvthtrruwNnmUf2Zu/8Y4xaQQq/gHe5O5fkT7DrEDfRThabJGJDxv+2Xtz36Kq
	mFSMhI0I0HHBqQXNqqUFBlVEWYiB8zADroIyzpU2lno8LfuTCWWNwNsWqcV6Nr3oJPu4/xVQCOI
	IejWe+sO2+XtcUW9PGLWEVm3PKT4O9ZCOMtX5rRnNXkBETLL9FCmEtkDouMc3CPKqkjXeRWAGew
	n7nlvio0tUnVQ/JqmIpsO7UsV6Hk8uipSIsiZ8SrTB/2FQxymtDc9yfYtLarFMUFQqFvAOds0+N
	bEO0n5S0Trvoeo7EMvdWf4VDxxQt17k=
X-Received: by 2002:a05:600c:4f89:b0:439:57a3:4fd6 with SMTP id 5b1f17b1804b1-4395817a64emr100052755e9.13.1739477761341;
        Thu, 13 Feb 2025 12:16:01 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGTyGHFgC18k8AdMXVtrdqPD79w/7OMnLDUqEbZyZU9x7wrmEYsQ1xIxqk0/nMvKfx05pfs/Q==
X-Received: by 2002:a05:600c:4f89:b0:439:57a3:4fd6 with SMTP id 5b1f17b1804b1-4395817a64emr100052485e9.13.1739477760917;
        Thu, 13 Feb 2025 12:16:00 -0800 (PST)
Received: from [127.0.0.2] (ip-217-030-074-039.aim-net.cz. [217.30.74.39])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4395a06d237sm57520895e9.21.2025.02.13.12.16.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Feb 2025 12:16:00 -0800 (PST)
From: Andrey Albershteyn <aalbersh@redhat.com>
X-Google-Original-From: Andrey Albershteyn <aalbersh@kernel.org>
Date: Thu, 13 Feb 2025 21:14:26 +0100
Subject: [PATCH v4 04/10] Add git-contributors script to notify about
 merges
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250213-update-release-v4-4-c06883a8bbd6@kernel.org>
References: <20250213-update-release-v4-0-c06883a8bbd6@kernel.org>
In-Reply-To: <20250213-update-release-v4-0-c06883a8bbd6@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: "Darrick J. Wong" <djwong@kernel.org>, 
 Andrey Albershteyn <aalbersh@kernel.org>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=4032; i=aalbersh@kernel.org;
 h=from:subject:message-id; bh=HU9n5NvoPomLXLF6LgaJXXpRdjxvBbILUZwTjWna110=;
 b=owJ4nJvAy8zAJea2/JXEGuOHHIyn1ZIY0tcF/ZrzJci+Pa/dTEreK7XL6uW2mfaHmX62/Mh5W
 jutwcbrzZaOUhYGMS4GWTFFlnXSWlOTiqTyjxjUyMPMYWUCGcLAxSkAEzlgz8jQy7LI+LR6e5Cj
 zU1bgbvJ4VU8yuL6urPUfmWnh7hM2bWHkeGQ/8br+/5pOB803WdZFb2xr4v76U+ntBo5x4aM+Ff
 frvIAAD8NRsI=
X-Developer-Key: i=aalbersh@kernel.org; a=openpgp;
 fpr=AE1B2A9562721A6FC4307C1F46A7EA18AC33E108

Add python script used to collect emails over all changes merged in
the next release.

CC: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
---
 tools/git-contributors.py | 101 ++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 101 insertions(+)

diff --git a/tools/git-contributors.py b/tools/git-contributors.py
new file mode 100755
index 0000000000000000000000000000000000000000..70ac8abb26c8ce65de336c5ae48abcfee39508b2
--- /dev/null
+++ b/tools/git-contributors.py
@@ -0,0 +1,101 @@
+#!/usr/bin/python3
+
+# List all contributors to a series of git commits.
+# Copyright(C) 2025 Oracle, All Rights Reserved.
+# Licensed under GPL 2.0 or later
+
+import re
+import subprocess
+import io
+import sys
+import argparse
+import email.utils
+
+DEBUG = False
+
+def backtick(args):
+    '''Generator function that yields lines of a program's stdout.'''
+    if DEBUG:
+        print(' '.join(args))
+    p = subprocess.Popen(args, stdout = subprocess.PIPE)
+    for line in io.TextIOWrapper(p.stdout, encoding="utf-8"):
+        yield line
+
+class find_developers(object):
+    def __init__(self):
+        tags = '%s|%s|%s|%s|%s|%s|%s|%s' % (
+            'signed-off-by',
+            'acked-by',
+            'cc',
+            'reviewed-by',
+            'reported-by',
+            'tested-by',
+            'suggested-by',
+            'reported-and-tested-by')
+        # some tag, a colon, a space, and everything after that
+        regex1 = r'^(%s):\s+(.+)$' % tags
+
+        self.r1 = re.compile(regex1, re.I)
+
+    def run(self, lines):
+        addr_list = []
+
+        for line in lines:
+            l = line.strip()
+
+            # emailutils can handle abominations like:
+            #
+            # Reviewed-by: Bogus J. Simpson <bogus@simpson.com>
+            # Reviewed-by: "Bogus J. Simpson" <bogus@simpson.com>
+            # Reviewed-by: bogus@simpson.com
+            # Cc: <stable@vger.kernel.org> # v6.9
+            # Tested-by: Moo Cow <foo@bar.com> # powerpc
+            m = self.r1.match(l)
+            if not m:
+                continue
+            (name, addr) = email.utils.parseaddr(m.expand(r'\g<2>'))
+
+            # This last split removes anything after a hash mark,
+            # because someone could have provided an improperly
+            # formatted email address:
+            #
+            # Cc: stable@vger.kernel.org # v6.19+
+            #
+            # emailutils doesn't seem to catch this, and I can't
+            # fully tell from RFC2822 that this isn't allowed.  I
+            # think it is because dtext doesn't forbid spaces or
+            # hash marks.
+            addr_list.append(addr.split('#')[0])
+
+        return sorted(set(addr_list))
+
+def main():
+    global DEBUG
+
+    parser = argparse.ArgumentParser(description = "List email addresses of contributors to a series of git commits.")
+    parser.add_argument("revspec", nargs = '?', default = None, \
+            help = "git revisions to process.")
+    parser.add_argument("--separator", type = str, default = '\n', \
+            help = "Separate each email address with this string.")
+    parser.add_argument('--debug', action = 'store_true', default = False, \
+            help = argparse.SUPPRESS)
+    args = parser.parse_args()
+
+    if args.debug:
+        DEBUG = True
+
+    fd = find_developers()
+    if args.revspec:
+        # read git commits from repo
+        contributors = fd.run(backtick(['git', 'log', '--pretty=medium',
+                  args.revspec]))
+    else:
+        # read patch from stdin
+        contributors = fd.run(sys.stdin.readlines())
+
+    print(args.separator.join(sorted(contributors)))
+    return 0
+
+if __name__ == '__main__':
+    sys.exit(main())
+

-- 
2.47.2


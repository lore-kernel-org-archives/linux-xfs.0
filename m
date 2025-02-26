Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9AEF222566
	for <linux-xfs@vger.kernel.org>; Wed, 26 Feb 2025 14:50:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740581454; cv=none; b=YAoUPcgbotkQaDl8/f/TPQu3zRHyghCQAkMHF//gpYZpnagqr4hDqEkkaO/FjjO0r22pH/Mqc4Cxg5n9SARCr+TnWoC3gVcZoOEZpH6/k34u5UODwin3MEVWLOOHbJb8GgqZEeE2DMSp9H0MAEMUSJ/sYy/UxF2jJXhzS89uwKs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740581454; c=relaxed/simple;
	bh=HU9n5NvoPomLXLF6LgaJXXpRdjxvBbILUZwTjWna110=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=VlYLiq85P4DMzCWdXEJxDJ263k/atswOUknqWOdvqNj/7og0hl1xSagfdK0n0FE05i2917pmXUz9N1f6xCnYXtIFnW8bMSTbGv8ml/o/3iutnrv6H/2ddpiPmn+2Deo25xsmVq0NLazYJCX0Heb21AbRgBQZkm5Re02q1L2BUSg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=RgRohG9S; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="RgRohG9S"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1740581451;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8Dwzp/NU0ujGgiL6wnczWrvsNXVl+Zg+N3jt2/uSQpM=;
	b=RgRohG9STbpZRL/9lmkyNyLgZ35RAR2zq+IMY8X0Oqev/9YZXEyakTN2dV3j8BJUIkDiVq
	03Ijri6D4lQbLd/3VSVPkfofwvXVON7oMg2ug5nfIE8hfgJj54uxgl7U1H/0PD9c2t3OvC
	jvvAIQr5te4h2+tKli3v8feZWymKYek=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-578-Cf1zXvD2OvGWkDRFuymXqg-1; Wed, 26 Feb 2025 09:50:50 -0500
X-MC-Unique: Cf1zXvD2OvGWkDRFuymXqg-1
X-Mimecast-MFC-AGG-ID: Cf1zXvD2OvGWkDRFuymXqg_1740581449
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-4399a5afcb3so63351365e9.3
        for <linux-xfs@vger.kernel.org>; Wed, 26 Feb 2025 06:50:50 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740581449; x=1741186249;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8Dwzp/NU0ujGgiL6wnczWrvsNXVl+Zg+N3jt2/uSQpM=;
        b=HccVV6ssBnDowgFAgbrL4I+17iR6KA7tIkCamBIZ6VBLmHZa3emO3lCo9uGB5W9w4U
         MgL4eA/01d2JgCfrjabqk7aiM/qewXNHySAajlhO4cp2SzJ1oCtLHC5TK3wbLr55HvrZ
         J+nAZNPvKTAR1B2y0LPgY7CDcvwDqEKIBzCF7lODXYG/+wlRedBvAhzJ2Y/vjD96W+Ie
         YrRNB0O85uU9wjq9EH33Z5JgYUN3rdDVw8RduOfzDBBvJK0VBe/39SElMveElVATNLGT
         oa44D+/MvFPe0+gWlTBeaCfjYsxrjOkRai7KGA6HrvH153c/pRAUjiYeRqQAa9tuUT3s
         cNZw==
X-Gm-Message-State: AOJu0YxzZlqnfC8XUUG8079lk2SXhOtHqmMnVOK86lDQ13pDguWRx2Rz
	L+FokzMjrOsWnODR6wPEkx/RzBTWh+PmHtdDbfhgjI+JTDk2n2axGffjnYLEm1X/zbo1sp5iA4/
	VcacodvV/U654BkP+Ay8i7mv1l7x7+Ym8zXyj/grumbD/Wjn1OFc0L6wN
X-Gm-Gg: ASbGncuauOO1Wm8F4u+h5SAm1d082Dp/vU51KTX1AfeIKrmVpy1x+/a5GC6l8M8GLgf
	XP1NhsXftX0v305TgXOWqEOJ30p/MsrfMTvvd86lSS/FZ6T56VdqQ01FSPB/CLs6b0JkFCJVp4t
	SjOjCS52ymh0zNrci9CrFJ/GCl+YEUA0eycP0IZ2LcOSRGNR7FjN8a7GuiD1OYweeLx4a3mTK1j
	AOpGz0jOj1xW3HSC3pFKqZQeu2P8yJFO0D5X848P9SwhO4VeI70+LVL+TUEjUHGhjJS4+jtQES8
	iV8ZQ7aRkEq/C/+ZZDmKqgfiJGr2XFhtKk3EvrE/7g==
X-Received: by 2002:a05:6000:1f8f:b0:38e:48a6:280b with SMTP id ffacd0b85a97d-390cc631ac9mr7594973f8f.34.1740581449019;
        Wed, 26 Feb 2025 06:50:49 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFeFD/DQPsHaVSdJ/tUgQmtYO/WuEoPN1w+SH0YcoiPxMkH/5DSVMqE15RMqgMP+komvViUhw==
X-Received: by 2002:a05:6000:1f8f:b0:38e:48a6:280b with SMTP id ffacd0b85a97d-390cc631ac9mr7594936f8f.34.1740581448559;
        Wed, 26 Feb 2025 06:50:48 -0800 (PST)
Received: from [127.0.0.2] (ip-217-030-074-039.aim-net.cz. [217.30.74.39])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-abed1cd564esm337731666b.21.2025.02.26.06.50.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Feb 2025 06:50:47 -0800 (PST)
From: Andrey Albershteyn <aalbersh@redhat.com>
X-Google-Original-From: Andrey Albershteyn <aalbersh@kernel.org>
Date: Wed, 26 Feb 2025 15:50:29 +0100
Subject: [PATCH v5 04/10] Add git-contributors script to notify about
 merges
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250226-update-release-v5-4-481914e40c36@kernel.org>
References: <20250226-update-release-v5-0-481914e40c36@kernel.org>
In-Reply-To: <20250226-update-release-v5-0-481914e40c36@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: "Darrick J. Wong" <djwong@kernel.org>, 
 Andrey Albershteyn <aalbersh@kernel.org>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=4032; i=aalbersh@kernel.org;
 h=from:subject:message-id; bh=HU9n5NvoPomLXLF6LgaJXXpRdjxvBbILUZwTjWna110=;
 b=owJ4nJvAy8zAJea2/JXEGuOHHIyn1ZIY0vdrOX8VjZQ8U8gbETk902NrQWZ0G+Odb9MCOZutQ
 5Zyp+mEvu8oZWEQ42KQFVNkWSetNTWpSCr/iEGNPMwcViaQIQxcnAIwkY1iDP+DWWwWXdrvxXNt
 7WK95evdKrzMHY0nrOZ8M1vmgu7bj75ODP9sd599qngtPDuC117hvpLUU9e+FyorL1QUyKsFPRP
 wv8sCAL1eQ7I=
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


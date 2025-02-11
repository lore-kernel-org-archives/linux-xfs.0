Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 048BD260A21
	for <linux-xfs@vger.kernel.org>; Tue, 11 Feb 2025 17:27:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739294843; cv=none; b=qISWspw70BSTq5p4D5JAbwq8RbLk35nVMtK7fVBwBUX7SXmA7yHvo0Kh9VN7uVbGvdMLJpwWSfF5m+gVJRhnlZYYS/ZzBifMeTpVryAPP9k5TxVSZuhXEgkYit+wP3RrvLqLOd9wyJTPC8rDAVRZtVzYoCBoNvuY5bfRwlgrpXk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739294843; c=relaxed/simple;
	bh=P5QJ+CY8V03RSJMRjOaOeD7xdRvGtHAn+xsQuCyRIOo=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=Kfnv7XBGccLafEdhTSnzkwYqcDxm2r96IJNsmXgbroHRmLU/9tJ03tNXf9eFJCdGysvPW29TfK5MTvebnafnpOnZLhIzK7lPBv03DQ84APbPePoDBHjV7LZ1ROVt90+aIk8YrQOzEMEgFNxqthCLVioc8WGWijKCFIarARI+sjY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=X00mEMOE; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="X00mEMOE"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1739294841;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=mvrYeWRHBcDIgb+SA7ykN/NLWK8QBRAULzEeD3MC9LA=;
	b=X00mEMOEi1YcHmxk1igkyNl2hLsjIKRCKG2RBH9eNf6fR6IARmqYH8DtxePNlFjGv636qP
	Sa74zVFbwHZt0IE+J7LIKJJy1R2OOxnJDPUKMj3M1j+8eizDdcpqXgwU9d8yFzkbtX7/K1
	vWJmmYm6O4ZEFZCr3SNEDXNgvJ2AouM=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-357-5c3doy8LN6SaxfIjmXC7gA-1; Tue, 11 Feb 2025 12:27:19 -0500
X-MC-Unique: 5c3doy8LN6SaxfIjmXC7gA-1
X-Mimecast-MFC-AGG-ID: 5c3doy8LN6SaxfIjmXC7gA
Received: by mail-ed1-f71.google.com with SMTP id 4fb4d7f45d1cf-5de572c8fd7so3409801a12.2
        for <linux-xfs@vger.kernel.org>; Tue, 11 Feb 2025 09:27:19 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739294839; x=1739899639;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mvrYeWRHBcDIgb+SA7ykN/NLWK8QBRAULzEeD3MC9LA=;
        b=l2VMOBoj+s7xTX3h8AB//9Va76ZwzvAnrDBv/6NGTJ7Kp45pMqP7hlOlaE6QoX00fQ
         7ATpRXJuU4Q5jjHuCp5rrLPI/mIri3/DsfeKZWmlN6RjBY220XqFGkyrC0KKNLqbPOjC
         PL7maW/t4f7atawD52Xaa8S/kISAhQ27hjfywqNwOtTO+QBDf5TsvI1A3V2s4hVZZsI/
         JdhGVvR3WUY7cXxfPwIgSP8NmI0KkLuC/CuhkLce8wH5eyNXLKltc5qSKaXB6iDSQl4g
         ebHDxozLSWCi+9MML2hhm8US+D4QRdfHFN4G1cOLpcFDxmFSWij+GJfIT6MXb3DRYtmE
         vM7g==
X-Gm-Message-State: AOJu0YymaCg9AgFomFAQKsO8zH5/xRdziOXRho4xMNqTkqvZem7hL4O6
	ndIRGzbLuQGaHbd2xaTniLvIkAO++gANyVa1+aFNLjoi8qhbfl/9WkOmfk3a0IKuyTD9MbFc6XW
	8QF87Oo7fjIpQk7Sny5RAI1ShbW/jcZ0PThq3IQLIOHPtxoEVobdCNdzs
X-Gm-Gg: ASbGncuiUQGiKXloNTww6KdrjPoH6LrJQ4+eXIGGKenDx/99q6QZYom3eVWVvuB3knW
	Zxwv0SxR/q2rpCJx6YsFd1tgdhbdh+2brhGjvOKkjQpkVOqjpBSVPm7c/pJvD3Ph895PdWAOzex
	EfbwUgfXRUFx+0jKiRgD5ZS+BLZdzJD1db5iDFrxCT2Ta4uenvqjJkFVOXzU4nDsRUM/fOKNOg8
	FN6pi76YdVvQlvzXV8Eo30lvJZO2OctMx/Okm4rqMiID8ZAc1yXBrsUIlYQIW/VV2SUaaI3cvBv
	DPLlBoRYVCAAwF5ces+1XqII64C0DRk=
X-Received: by 2002:a05:6402:2106:b0:5de:4877:ef41 with SMTP id 4fb4d7f45d1cf-5deade00a82mr7787a12.25.1739294838542;
        Tue, 11 Feb 2025 09:27:18 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEjl4RcaaRIi8OaUyZNh4TFeC4MFe3lYuYsUhMDj78HnsMCtSv3D8hpYMNMjQExgnj+dzRhug==
X-Received: by 2002:a05:6402:2106:b0:5de:4877:ef41 with SMTP id 4fb4d7f45d1cf-5deade00a82mr7767a12.25.1739294838171;
        Tue, 11 Feb 2025 09:27:18 -0800 (PST)
Received: from [127.0.0.2] (ip-217-030-074-039.aim-net.cz. [217.30.74.39])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5de5ced9758sm6914335a12.76.2025.02.11.09.27.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Feb 2025 09:27:17 -0800 (PST)
From: Andrey Albershteyn <aalbersh@redhat.com>
X-Google-Original-From: Andrey Albershteyn <aalbersh@kernel.org>
Date: Tue, 11 Feb 2025 18:26:57 +0100
Subject: [PATCH v3 5/8] Add git-contributors script to notify about merges
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250211-update-release-v3-5-7b80ae52c61f@kernel.org>
References: <20250211-update-release-v3-0-7b80ae52c61f@kernel.org>
In-Reply-To: <20250211-update-release-v3-0-7b80ae52c61f@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: "Darrick J. Wong" <djwong@kernel.org>, 
 Andrey Albershteyn <aalbersh@kernel.org>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=3842; i=aalbersh@kernel.org;
 h=from:subject:message-id; bh=P5QJ+CY8V03RSJMRjOaOeD7xdRvGtHAn+xsQuCyRIOo=;
 b=owJ4nJvAy8zAJea2/JXEGuOHHIyn1ZIY0ld3FPjsXbPiqXd9S+3cNbdYa32P3FC6bJEq/e12Y
 MX0TrXQrywdpSwMYlwMsmKKLOuktaYmFUnlHzGokYeZw8oEMoSBi1MAJuK0jOG/T/I6xSlfprBE
 vZGdxiien77z8JUgplYxCYFv68q3SblVMPwzPar0q3EPA7PoyQeTPaOer7DVURP8fdo1xPrE8YC
 F1Ru5AZsRRx8=
X-Developer-Key: i=aalbersh@kernel.org; a=openpgp;
 fpr=AE1B2A9562721A6FC4307C1F46A7EA18AC33E108

Add python script used to collect emails over all changes merged in
the next release.

CC: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
---
 tools/git-contributors.py | 94 +++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 94 insertions(+)

diff --git a/tools/git-contributors.py b/tools/git-contributors.py
new file mode 100755
index 0000000000000000000000000000000000000000..83bbe8ce0ee1dcbd591c6d3016d553fac2a7d286
--- /dev/null
+++ b/tools/git-contributors.py
@@ -0,0 +1,94 @@
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
+    parser = argparse.ArgumentParser(description = "List email addresses of contributors to a series of git commits.")
+    parser.add_argument("revspec", nargs = '?', default = None, \
+            help = "git revisions to process.")
+    parser.add_argument("--delimiter", type = str, default = '\n', \
+            help = "Separate each email address with this string.")
+    args = parser.parse_args()
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
+    print(args.delimiter.join(sorted(contributors)))
+    return 0
+
+if __name__ == '__main__':
+    sys.exit(main())
+

-- 
2.47.2


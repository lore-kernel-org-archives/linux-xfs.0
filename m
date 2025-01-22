Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6199213E9F
	for <linux-xfs@vger.kernel.org>; Wed, 22 Jan 2025 15:02:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737558127; cv=none; b=fAFW/Z/qw1Qu+e2oTt+TxyEMLEZdWZFH3Z7kwlaa02uLzgdxvepUinT4jwZ3Jup2WXh3PV6lzmNjHznfyNYWcrWTxoqJVMA4LY7ys6YzKdawWerjLaMnZlOIh8wGIgzAt6bX/E1Frb9Z4D+oL1GnqVuaG0CTWv4rTGmVQjNDZmQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737558127; c=relaxed/simple;
	bh=F5HU3Xp/jxQooClcPRELOAHXMLa8iF4uvNUW/o/A42M=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=QRTmv6x7kYsrIUi1e9Hij2VYicXicZvfYvZyzZENHsUEGlXk2ca9luGvFwowWVyNzpJDAlkUk6GizZC4JMwWvJg1KFtubYnPgFjUVG7xX/t1XGsDAg8AKjaSk8XhQHHgqdAJCFzp8aKc4q/TwCMbG7TFIXEC8jaeyQHVkc1hGYI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Cm8oDnRs; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Cm8oDnRs"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1737558124;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tS1SBHSzp3jboL2Txd7yHDXoLpAHy0eMvDpJgubzJ1c=;
	b=Cm8oDnRsWOfxcJJvewWO9jcZ8bEnWzhRnxex6Tp0HLTO7UPyczNZNfWkdb8iGzFdApWRLC
	PtJSv1ZgjgNPpzEPdAO6dkx42dcVQs77VFXTtCK6mLQ2n3YbazhLmOWs/6jxN1fZ//4w+i
	iIwknKUWvEOXJ66PoGoSSdFousP8uBA=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-74-HV8yddRTO0WZGfP1Osv5xg-1; Wed, 22 Jan 2025 10:02:03 -0500
X-MC-Unique: HV8yddRTO0WZGfP1Osv5xg-1
X-Mimecast-MFC-AGG-ID: HV8yddRTO0WZGfP1Osv5xg
Received: by mail-ej1-f72.google.com with SMTP id a640c23a62f3a-aafc90962ffso720955766b.0
        for <linux-xfs@vger.kernel.org>; Wed, 22 Jan 2025 07:02:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737558122; x=1738162922;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tS1SBHSzp3jboL2Txd7yHDXoLpAHy0eMvDpJgubzJ1c=;
        b=sQ1E1yOdvW/L5RzPV0RcC/z7dTsrdW9dYcZ2Kt7gcD4V1KAHyX9qQdMelh2Ytgi4KS
         Vl2mP/6jHpKLK/16h55PDf6lREWC/9gCc2tneTJELoLDLHv3svMJw+vLesxxa/tdH6Sw
         Am4aZr/6NZghmnR5CAd4D/buhdFM7nsl2F1QhXP5Zh7bSFlYL8NSeguwCa6JnQ5lzJ5W
         AkX1PJTRobtPjZbJC8QhAgbNYy33Q94cLuX9Pn73e11eiQ1j2T+eDkGi8DBQUXAxN7GA
         Jyy7ZpY8i41XHE3dY8AhbzGpBUkoBpSHtE5vkmnwL7nnOjLPqjXW+ZFlup9bi14oEbel
         oJXA==
X-Gm-Message-State: AOJu0YxnX5XExP2YcZNTomZ3TD+vgFJJ0Y3a1h8jBUSTQLo3NA5PR40o
	OCpdeV7S4BKH0L7VsesZ5/EbbVapVIDbXDTjxmVm6rxLkxOkxnf54tPQG4NvSLVvBu7Rh5pRJEU
	vzJW6rPETat6KC6p4f6UYz/1Z0mSuhRvr2aplxLXER7rWOPXidOasRh2N
X-Gm-Gg: ASbGnctH6oSm5BEl17aJUbKbjxR0LB8P+5G6kksBYBRgyRFXqeW+i4kGGfxAYHeCX0V
	Cju/kRFhuPSz9Nhro8CuNuzKzxAN6DzeqLT5pUc2LFD39ztKeIeys2wrshHHx0JdDijKIbep+zb
	V3JgLM7tpsIXcO+GIEVx3jNYMfQxXkKPQqS3MhY+ybSlHJZPskOMs1gLCFnCxrWLANpm3ZMnCoZ
	ZhG243hDjuAEIigPorXSlVU4Fzfe6YBwr1VjiAKGYdkOerA8LskODsQ4jopbtJeqaRZrTOasZe5
	CIBoV9aII+7X/cSADVxj
X-Received: by 2002:a17:907:2d93:b0:ab3:8a8a:d1f2 with SMTP id a640c23a62f3a-ab38b2e71f4mr1742241466b.30.1737558120785;
        Wed, 22 Jan 2025 07:02:00 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEADdFbRxFXtJXIBY99/BFayTLQvAcFmVSG/ESIHhaFF8JZghiD6KN0MlUzV/QgIjbxs+6YwA==
X-Received: by 2002:a17:907:2d93:b0:ab3:8a8a:d1f2 with SMTP id a640c23a62f3a-ab38b2e71f4mr1742219366b.30.1737558118627;
        Wed, 22 Jan 2025 07:01:58 -0800 (PST)
Received: from [127.0.0.2] (ip-217-030-074-039.aim-net.cz. [217.30.74.39])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ab384f2303csm925653966b.100.2025.01.22.07.01.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jan 2025 07:01:56 -0800 (PST)
From: Andrey Albershteyn <aalbersh@redhat.com>
X-Google-Original-From: Andrey Albershteyn <aalbersh@kernel.org>
Date: Wed, 22 Jan 2025 16:01:31 +0100
Subject: [PATCH v2 5/7] Add git-contributors script to notify about merges
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250122-update-release-v2-5-d01529db3aa5@kernel.org>
References: <20250122-update-release-v2-0-d01529db3aa5@kernel.org>
In-Reply-To: <20250122-update-release-v2-0-d01529db3aa5@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: "Darrick J. Wong" <djwong@kernel.org>, 
 Andrey Albershteyn <aalbersh@kernel.org>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=3742; i=aalbersh@kernel.org;
 h=from:subject:message-id; bh=F5HU3Xp/jxQooClcPRELOAHXMLa8iF4uvNUW/o/A42M=;
 b=owJ4nJvAy8zAJea2/JXEGuOHHIyn1ZIY0idyBC6P2PZTUEN8TgbDRLEMM+kD2uXsQXd0LZfMZ
 va8dlS18VRHKQuDGBeDrJgiyzppralJRVL5Rwxq5GHmsDKBDGHg4hSAiSzlYvhnP2fbL1MOw6Vf
 nl9luNP4umjdxd1vV71+OEnO93AAzyqGCYwMn2T+vtuTWe0/55+F0Q/HF91btkUbfnrz4x6bhxP
 LtEwnJgD7QUeq
X-Developer-Key: i=aalbersh@kernel.org; a=openpgp;
 fpr=AE1B2A9562721A6FC4307C1F46A7EA18AC33E108

Add python script used to collect emails over all changes merged in
the next release.

CC: "Darrick J. Wong" <djwong@kernel.org>
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
2.47.0


Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05E9424BBF5
	for <linux-xfs@vger.kernel.org>; Thu, 13 Feb 2025 20:16:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739477768; cv=none; b=GsGEk3pWLu+nn960urYhO1X/2Xni79qq8BVfk89GLXuNIxYcXok1zNxEW+46AIQH4HU1PbNgCH3m2WGN+DnjqPrbbb/ry6CwM/Pq9boQuqI3qI0Djb6kwwJrwvQdrzE1Os4+fumefsZTpGoC6I+zzTaYjG248LXkODhAJ+JIt+4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739477768; c=relaxed/simple;
	bh=FRMtZEM/v2TdSzfxgy/TEs1Vbuhq4HDz9EGnvkfc2rs=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=c4KsF765fL3BKBDU8fVc7HO+WFtzFTEJLTmWS3kxEgBt+P/JefyWMoPBX3YlTchIxWto4RTeBcLHTWCPhiis1OX/x0EzylFK9oCo8e3OOBkVB9Orhg0Bc1jYwcqxNg2II2Z8EAvb2V5Ypq5sy2P6cjQ9pZ3KF4oBp2UyncXZ5iE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=OvD0Qz3t; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="OvD0Qz3t"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1739477765;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bY9CGV7zlvT14th3ab23rDDHWXiloyF5GCzDs8pWPBY=;
	b=OvD0Qz3tChEuynf+0ROlJ5w/zQ+OD/1KjeP819jDW1lbq9SRVsXsk+SkY4t58DQbBRgnst
	gUvmvuMEoCCJDH3HKIqJcCq3+2DvfHV4NkOs1yRZrfy7S40y2UMz7Wc3kkbIDkqVY28ko9
	0NOdgRmCfqPoXxhMJIGhXXqftmJWEM4=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-508-djcTmiwKM3iN9QHn0UPUZQ-1; Thu, 13 Feb 2025 15:16:04 -0500
X-MC-Unique: djcTmiwKM3iN9QHn0UPUZQ-1
X-Mimecast-MFC-AGG-ID: djcTmiwKM3iN9QHn0UPUZQ
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-4395fa20a21so8317275e9.1
        for <linux-xfs@vger.kernel.org>; Thu, 13 Feb 2025 12:16:04 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739477763; x=1740082563;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bY9CGV7zlvT14th3ab23rDDHWXiloyF5GCzDs8pWPBY=;
        b=Q3QFX98kUDdg6eQS4eEKpA0mHQBTZo+IxcfouNH9qTpvzDtXPCPe33zpEmKRsopeM7
         WSdsVS+iTvqMthJFN89foeJMTBknTkmsJYEkzB31jYCRh5pjOVv8+Li4XML0PuKzyPIl
         9Lz5sS4tfmhYdRy44Z8mVbwQcTicRggGMOyT+sM7y7dGmbYFjaCEzLzLzUGZBlCiBn7g
         o8gkFAlNXgnlDfuARO+t3Na7Dl1/otSvuBkve9y5uO8suqj03uV3SxJoSE3/G/oih2F6
         nCu/Vh3DTJ/RkLruIMkfLQTofrKmLKOeVKhULIyCdi+fyTlW1tROULqWLAHdECnden08
         Rrog==
X-Gm-Message-State: AOJu0YzwWycI/tnK5dPcAWqB4XqSSuNc+6R7oDBdOQ/8fTjcd7ddvn8B
	ieazCk8b+Ch3vmrzs3tmJxJSOJM9iI45MOgXYNEJiqU2N1e0ybk6j8U0eqSZ88b5hoxusLuhY3W
	a5CN9iXgUuDhipMhRbzrfE5oVPkrD3mO+J0YA5kIRv+5ErQOfXOCkYN4eyUhue6Vw
X-Gm-Gg: ASbGncv+Ka9N3Uz8pnHizjK3PjSBwpejHR/V4ZI5uUORZDlAxbbgrxktwOomXgIazK5
	INwc1V6S8DmV1ETzuPfiCOeAxZ8FPreuTKUDJyXvofYwosN6vMQSljQ5FTtPp1fzfYcGfVttVix
	ZTrD5e498oeZTn4OnpNEwi7VFAD+WKpuHbD55k/ikMP3S5bmavUkRZnqBLUZHcI+0FkthOLuAQk
	yzd8GOf2iIPqSY8Q781LqOjyVFuN0zqsxULY3HZgbFm5mV/hrs/OZGNaEokOc/ZzcW3WncQOjXs
	tBzmoRPkeJ9UTP1x8rCEBp4rfIM+vQQ=
X-Received: by 2002:a05:6000:4a17:b0:38d:d166:d44 with SMTP id ffacd0b85a97d-38f24da9cf2mr5264787f8f.23.1739477762944;
        Thu, 13 Feb 2025 12:16:02 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGEl1x+X+UYDCaahN3gUCpDwhADHqd9ULDIdFIHTTb2rh19MpZt9LijFXMBWsimjdSb19ueGA==
X-Received: by 2002:a05:6000:4a17:b0:38d:d166:d44 with SMTP id ffacd0b85a97d-38f24da9cf2mr5264759f8f.23.1739477762517;
        Thu, 13 Feb 2025 12:16:02 -0800 (PST)
Received: from [127.0.0.2] (ip-217-030-074-039.aim-net.cz. [217.30.74.39])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4395a06d237sm57520895e9.21.2025.02.13.12.16.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Feb 2025 12:16:01 -0800 (PST)
From: Andrey Albershteyn <aalbersh@redhat.com>
X-Google-Original-From: Andrey Albershteyn <aalbersh@kernel.org>
Date: Thu, 13 Feb 2025 21:14:27 +0100
Subject: [PATCH v4 05/10] git-contributors: better handling of hash
 mark/multiple emails
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250213-update-release-v4-5-c06883a8bbd6@kernel.org>
References: <20250213-update-release-v4-0-c06883a8bbd6@kernel.org>
In-Reply-To: <20250213-update-release-v4-0-c06883a8bbd6@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: Andrey Albershteyn <aalbersh@kernel.org>, 
 "Darrick J. Wong" <djwong@kernel.org>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=5799; i=aalbersh@kernel.org;
 h=from:subject:message-id; bh=FRMtZEM/v2TdSzfxgy/TEs1Vbuhq4HDz9EGnvkfc2rs=;
 b=owJ4nJvAy8zAJea2/JXEGuOHHIyn1ZIY0tcF/Tp4alKc799ZzvEzbq1jPL0nV+FI6aKNX9TWT
 Zk86aBsceS+jlIWBjEuBlkxRZZ10lpTk4qk8o8Y1MjDzGFlAhnCwMUpABPZd4yR4dhn8fKP86Yr
 un1z5DGIXJKidOqxyGSObbGGDq+uLany4GZkaDlT6P3u7Y6t7n0C1/QC2P/6ahZdP2Cc8rA8Iy3
 L7J81LwC76EnS
X-Developer-Key: i=aalbersh@kernel.org; a=openpgp;
 fpr=AE1B2A9562721A6FC4307C1F46A7EA18AC33E108

Better handling of hash mark, tags with multiple emails and not
quoted names in emails. See comments in the script.

Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 tools/git-contributors.py | 109 ++++++++++++++++++++++++++++++++++++++--------
 1 file changed, 90 insertions(+), 19 deletions(-)

diff --git a/tools/git-contributors.py b/tools/git-contributors.py
index 70ac8abb26c8ce65de336c5ae48abcfee39508b2..1a0f2b80e3dad9124b86b29f8507389ef91fe813 100755
--- a/tools/git-contributors.py
+++ b/tools/git-contributors.py
@@ -37,35 +37,106 @@ class find_developers(object):
 
         self.r1 = re.compile(regex1, re.I)
 
+        # regex to guess if this is a list of multiple addresses.
+        # Not sure why the initial "^.*" is needed here.
+        self.r2 = re.compile(r'^.*,[^,]*@[^@]*,[^,]*@', re.I)
+
+        # regex to match on anything inside a pair of angle brackets
+        self.r3 = re.compile(r'^.*<(.+)>', re.I)
+
+    def _handle_addr(self, addr):
+        # The next split removes everything after an octothorpe (hash
+        # mark), because someone could have provided an improperly
+        # formatted email address:
+        #
+        # Cc: stable@vger.kernel.org # v6.19+
+        #
+        # This, according to my reading of RFC5322, is allowed because
+        # octothorpes can be part of atom text.  However, it is
+        # interepreted as if there weren't any whitespace
+        # ("stable@vger.kernel.org#v6.19+").  The grammar allows for
+        # this form, even though this is not a correct Internet domain
+        # name.
+        #
+        # Worse, if you follow the format specified in the kernel's
+        # SubmittingPatches file:
+        #
+        # Cc: <stable@vger.kernel.org> # v6.9
+        #
+        # emailutils will not know how to parse this, and returns empty
+        # strings.  I think this is because the angle-addr
+        # specification allows only whitespace between the closing
+        # angle bracket and the CRLF.
+        #
+        # Hack around both problems by ignoring everything after an
+        # octothorpe, no matter where it occurs in the string.  If
+        # someone has one in their name or the email address, too bad.
+        a = addr.split('#')[0]
+
+        # emailutils can extract email addresses from headers that
+        # roughly follow the destination address field format:
+        #
+        # Reviewed-by: Bogus J. Simpson <bogus@simpson.com>
+        # Reviewed-by: "Bogus J. Simpson" <bogus@simpson.com>
+        # Reviewed-by: bogus@simpson.com
+        #
+        # Use it to extract the email address, because we don't care
+        # about the display name.
+        (name, addr) = email.utils.parseaddr(a)
+        if DEBUG:
+            print(f'A:{a}:NAME:{name}:ADDR:{addr}:')
+        if len(addr) > 0:
+            return addr
+
+        # If emailutils fails to find anything, let's see if there's
+        # a sequence of characters within angle brackets and hope that
+        # is an email address.  This works around things like:
+        #
+        # Reported-by: Xu, Wen <wen.xu@gatech.edu>
+        #
+        # Which should have had the name in quotations because there's
+        # a comma.
+        m = self.r3.match(a)
+        if m:
+            addr = m.expand(r'\g<1>')
+            if DEBUG:
+                print(f"M3:{addr}:M:{m}:")
+            return addr
+
+        # No idea, just spit the whole thing out and hope for the best.
+        return a
+
     def run(self, lines):
         addr_list = []
 
         for line in lines:
             l = line.strip()
 
-            # emailutils can handle abominations like:
-            #
-            # Reviewed-by: Bogus J. Simpson <bogus@simpson.com>
-            # Reviewed-by: "Bogus J. Simpson" <bogus@simpson.com>
-            # Reviewed-by: bogus@simpson.com
-            # Cc: <stable@vger.kernel.org> # v6.9
-            # Tested-by: Moo Cow <foo@bar.com> # powerpc
+            # First, does this line match any of the headers we
+            # know about?
             m = self.r1.match(l)
             if not m:
                 continue
-            (name, addr) = email.utils.parseaddr(m.expand(r'\g<2>'))
+            rightside = m.expand(r'\g<2>')
 
-            # This last split removes anything after a hash mark,
-            # because someone could have provided an improperly
-            # formatted email address:
-            #
-            # Cc: stable@vger.kernel.org # v6.19+
-            #
-            # emailutils doesn't seem to catch this, and I can't
-            # fully tell from RFC2822 that this isn't allowed.  I
-            # think it is because dtext doesn't forbid spaces or
-            # hash marks.
-            addr_list.append(addr.split('#')[0])
+            n = self.r2.match(rightside)
+            if n:
+                # Break the line into an array of addresses,
+                # delimited by commas, then handle each
+                # address.
+                addrs = rightside.split(',')
+                if DEBUG:
+                    print(f"0LINE:{rightside}:ADDRS:{addrs}:M:{n}")
+                for addr in addrs:
+                    a = self._handle_addr(addr)
+                    addr_list.append(a)
+            else:
+                # Otherwise treat the line as a single email
+                # address.
+                if DEBUG:
+                    print(f"1LINE:{rightside}:M:{n}")
+                a = self._handle_addr(rightside)
+                addr_list.append(a)
 
         return sorted(set(addr_list))
 

-- 
2.47.2


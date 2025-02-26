Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4DA72222A1
	for <linux-xfs@vger.kernel.org>; Wed, 26 Feb 2025 14:50:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740581457; cv=none; b=kkTWwNHU0F7u5l/fOKs5sqdu5JJVIk8IWP+Ry8aAYwBeVaYEyf14wrT4a5RkArnERt+G6Qfw8RWYjwUNjvppky4R4CWhhfRxjBWfxLMDS0quNVQwb41kWL/6FXKSKIWb/vfnZcI0/yz0B1A1SdxY4aQZFeL+bv/zBj3YjcRGqfg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740581457; c=relaxed/simple;
	bh=peniH+DoGXFkb53GxKcQx5eQOqXnoRSKLDoia0Z9haM=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=MMQvmDQNGxdpty8oDIeoB34cFZ8etHMPyeTHjjVWsTsR9bc8572y7noARRnRs8h6pwBa5XPvt0donU3DdCbrgHav6CY03uPhVrxrbNinA4DMBiDbLAQrYxrCvsvcCt5wcdMuf0U7CADH1lHMG9DVTuAYYvO/QXcLDTAm7umMxn8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=EOtSSbHg; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="EOtSSbHg"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1740581454;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=DKpCQd9SYnqagMEVbWdcxpNkMgcZ1ncGzrsX/EvMtTE=;
	b=EOtSSbHg/ISprvO7y/X5VqKAvrMceIxcvLnF5S5qL14XQP7/aWxInyIa/MxUtPiOoNg2OL
	q8Wu3dmlRvt6Z7xEz1hYsFGEqWGjweUkf0ozVV+yFIekyt6edWW6DEYOlaWQsKSYVl/xzG
	QoALFvePIUzrv+XKzqzroXHgt7/3XUw=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-606-oFExS77OO2eTksGtb6X6Fw-1; Wed, 26 Feb 2025 09:50:52 -0500
X-MC-Unique: oFExS77OO2eTksGtb6X6Fw-1
X-Mimecast-MFC-AGG-ID: oFExS77OO2eTksGtb6X6Fw_1740581452
Received: by mail-ed1-f69.google.com with SMTP id 4fb4d7f45d1cf-5e067bbd3bcso7099510a12.3
        for <linux-xfs@vger.kernel.org>; Wed, 26 Feb 2025 06:50:52 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740581451; x=1741186251;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DKpCQd9SYnqagMEVbWdcxpNkMgcZ1ncGzrsX/EvMtTE=;
        b=SIsy2f8MHXXmRIAGYldQ9knAhOmwsiYaMUbHM36GqWorMm6OEfsXtUHUZhZfNudMkh
         BKEhDYeHt35FPNfFLJ36DH3MI894RtrLt32Jd3/xDyJG6DFuCZaGuDEYj6Q2XNWSmWy/
         IeF16IbrjcZ8GlGCdsUzzh0K86WbzP5LOWWtq6y2g2yO39Wcg0ln3zVqRLBcglP14JFR
         y2AnG8M39+5WJ0Rud4QIJMjt6arkpC+zQRa1sT142/qWJm2P+yQaEmTpz4xuPleYx4Te
         g1sbbF2ZlCCSpSlZzsgSxSmqZsnpMW7WOhTvrfNhIibdZxTXWo7GCU8dKA/xS6L340oj
         o6KA==
X-Gm-Message-State: AOJu0YzhQGP8hYRwuzET3JWkHgB+FCxeNIOnBjaGQNOx7Q3HkAo0Ehrg
	dpbohx0bsBI1x7dkZrgjF9UiWOjgmMNiqeG+KGZuhN6AwbmRuGeaTlt38yC9YH1UFPiUm8aNLtA
	FKNj7pm08o8Nm52B2SezqXij0VLLc/VMjtzdz0qYav5I9jyFV73ApnGzy
X-Gm-Gg: ASbGncunEN7802LPeTtJ3MmsIdvK1mcuuFzkTRFV9vfZbY5KulYKXFDS/pR+3gVZLh9
	9Eh7D4XIzGmtZCQoj6S5WSuSz8ExjItoPu0m/PFTo6BpXfp9D8e9FBKhmyzHIq5up1olU8+EVL0
	+FultIpxEXtlOGgYgq4WJeB5RI229HxSBOoSIPf8KcmXw+M4GCDy4v5hZSLKL8SHibuuLX4UNLi
	KdwLbhCovlbamCMHC/NRGhI6kBWHEJdNEROBIgkyxkmQgGZoTGHULIwEYqUzCNmS8l8UvBSLo0L
	tpfs2/yb4cDyRlIqjybWxqR5BrPd4IXdNjO46kYrpw==
X-Received: by 2002:a17:906:3081:b0:ab7:fc9a:28e2 with SMTP id a640c23a62f3a-abed1068fafmr747038866b.47.1740581451551;
        Wed, 26 Feb 2025 06:50:51 -0800 (PST)
X-Google-Smtp-Source: AGHT+IG2pTtCfXtsrDPD11Mmq827lwbTroShh8zdKbUE+ErRya7j0cWOEej+b0XdfewXOUMnFLV6IA==
X-Received: by 2002:a17:906:3081:b0:ab7:fc9a:28e2 with SMTP id a640c23a62f3a-abed1068fafmr747036166b.47.1740581451136;
        Wed, 26 Feb 2025 06:50:51 -0800 (PST)
Received: from [127.0.0.2] (ip-217-030-074-039.aim-net.cz. [217.30.74.39])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-abed1cd564esm337731666b.21.2025.02.26.06.50.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Feb 2025 06:50:48 -0800 (PST)
From: Andrey Albershteyn <aalbersh@redhat.com>
X-Google-Original-From: Andrey Albershteyn <aalbersh@kernel.org>
Date: Wed, 26 Feb 2025 15:50:30 +0100
Subject: [PATCH v5 05/10] git-contributors: better handling of hash
 mark/multiple emails
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250226-update-release-v5-5-481914e40c36@kernel.org>
References: <20250226-update-release-v5-0-481914e40c36@kernel.org>
In-Reply-To: <20250226-update-release-v5-0-481914e40c36@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: "Darrick J. Wong" <djwong@kernel.org>, 
 Andrey Albershteyn <aalbersh@kernel.org>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=5847; i=aalbersh@kernel.org;
 h=from:subject:message-id; bh=peniH+DoGXFkb53GxKcQx5eQOqXnoRSKLDoia0Z9haM=;
 b=owJ4nJvAy8zAJea2/JXEGuOHHIyn1ZIY0vdrOespCu7RClbzzmhz2nthzbV7Ky6+nJ8gdKnGf
 pOJLsOXrY4dpSwMYlwMsmKKLOuktaYmFUnlHzGokYeZw8oEMoSBi1MAJnLoH8P/ki6zyv7kZZl+
 +rkaBX43PuVHn47se3zub53j/Dv8U76wMzK0Sv6QXmLys7BCQC7503PTrrlehqsyfat6/kpt3xU
 RksUKAPDrR1o=
X-Developer-Key: i=aalbersh@kernel.org; a=openpgp;
 fpr=AE1B2A9562721A6FC4307C1F46A7EA18AC33E108

Better handling of hash mark, tags with multiple emails and not
quoted names in emails. See comments in the script.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
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


Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4666F24BBEB
	for <linux-xfs@vger.kernel.org>; Thu, 13 Feb 2025 20:16:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739477769; cv=none; b=U13QivhF1g5G0wJckZ9AbrW7peCCo72Q+sxQSxfTQ2Sqmixo17WkpB/5a76cqA0JXZdFzQKhZAXEGSXWUD7jQBvtzMK06EaFhO+cOilVmDI5fqLi74xUKM2LCjApbfSON+82AuIxvNLQ+/CUhq7066VSrSndUHYkrxqmtp/BEzI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739477769; c=relaxed/simple;
	bh=VYmMJTB6ehENr3WhCSM9iKdq6BQu8DfprsA/mDAgtJk=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=qNoxcpvEY3itHXotcmurQ3rF7TtO00VS1R2PCtpdSpUFOa76npi9vvTX007Skz++v4FzmPqBTUEl7MnSTiGuVPDB8c6T5g+MsGtJq5vj1tkjyJhT0TPQJ1xiDIR4krLl38SAC0tXLtaic/ZsREOurR7qkr5eUJIpAaumKrX9r3I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=eI1lz3Be; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="eI1lz3Be"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1739477767;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=MhLwHh6iu7zsAzndLlkS/0chSXf0+r9ublGzpAhqKGs=;
	b=eI1lz3BeUZt3OVSstwksOBIDgQ6gFTFnOphhXvS2k8d4AplABr6B79hMe2tBnP86617mHR
	l7EZu95aGOtVWDlsjQx5M+syTwyJo96oul0vAllz3S6zkrW5yp5yzDY+P+uoWbP/JHTovA
	6ssYBPZJjo3KaILR9tygBOf9/p9Vv2Q=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-561-AXzSF-lJP6OKdt2AU9R03Q-1; Thu, 13 Feb 2025 15:16:06 -0500
X-MC-Unique: AXzSF-lJP6OKdt2AU9R03Q-1
X-Mimecast-MFC-AGG-ID: AXzSF-lJP6OKdt2AU9R03Q
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-38de0201961so1429850f8f.2
        for <linux-xfs@vger.kernel.org>; Thu, 13 Feb 2025 12:16:04 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739477763; x=1740082563;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MhLwHh6iu7zsAzndLlkS/0chSXf0+r9ublGzpAhqKGs=;
        b=VjV/yMZD0zOIc+gHpqtcT71z5iKmO5MjMwN2pvkzVa0qX6IGrPI4a6MQanC+kxcDSp
         WjLZxKltDqifVFiJupC9G6gDJt0R5wa+3cnJhLYXf8CWVLzS5arXRFp6LB7GRA6fBt0c
         uu0KQ9r5AMQsQgsSome0v6q8yGN5GTdD/WyQ2oW3a6Nef9HYJAvL5maKghkFHoBuyDaR
         NAw78GfHcENZ1lwzx2/CtiZSAvwdOvjsPz8XLhYCwNwXJ6RBsz6AOb9rSinYgRSBKA2A
         xReYVPGtTTg3SR50AIQcboXnk+hgEiMWMneooUru4QtFfI4rCXTLLg0lnMz8z6ebMAo5
         1PCw==
X-Gm-Message-State: AOJu0YwqlFKVVuCoFG2J0FW/HsXHQJ1mR0F0X76izyq8wp46xHliwubD
	PzdDLp6pfVEo71WVjEPWlz6CeaobiE4Odu6DIbspf5xt/Dohyq0xFhRtsa0eDext4cHjZRqT33L
	9fnX+8ItzKfkv5RnswCzLHc61AagbKDPvHF5mJzJXUnLjHl0UGvyIEPY1ZhL0tq24
X-Gm-Gg: ASbGnctBtsh1JdJaMzRrXLMCMNAWL8WnrZPc3e55VEXUfkjWr0Q9e+s4h6C1vlAaamk
	oQiugJ0kECtbm3RQfHIIxbmkn/lbz2+UnDi0E0c4OXBfG0Qg+yMkWUZLfEF3IuDR6r5R+EMb/OU
	iZv1cUZM76KIP0fRjOKqAjWZVoREwuc3n9FyX3ciYUhPEGMNFMGcPsqucLmHiti7yVojszlmNig
	mLY/K/lsFrj49iDtZGl+h3x4seseD51Yet2/kZyOTcbwIsdALwJhUTYzOMbrPU9mRFB9Lo4/5Sn
	Tar+DWB3P5vWrMYGrhyY0onsieiaTjA=
X-Received: by 2002:a05:6000:186d:b0:38d:d118:8b4d with SMTP id ffacd0b85a97d-38dea2eadcdmr9883332f8f.54.1739477763530;
        Thu, 13 Feb 2025 12:16:03 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFoazP6TCAHXibYn9BX731+i3xY0fK1TtDKxEP0QD2HXuCue1F30GIB3MdjDSxH5jfumOx5lQ==
X-Received: by 2002:a05:6000:186d:b0:38d:d118:8b4d with SMTP id ffacd0b85a97d-38dea2eadcdmr9883303f8f.54.1739477763175;
        Thu, 13 Feb 2025 12:16:03 -0800 (PST)
Received: from [127.0.0.2] (ip-217-030-074-039.aim-net.cz. [217.30.74.39])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4395a06d237sm57520895e9.21.2025.02.13.12.16.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Feb 2025 12:16:02 -0800 (PST)
From: Andrey Albershteyn <aalbersh@redhat.com>
X-Google-Original-From: Andrey Albershteyn <aalbersh@kernel.org>
Date: Thu, 13 Feb 2025 21:14:28 +0100
Subject: [PATCH v4 06/10] git-contributors: make revspec required and
 shebang fix
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250213-update-release-v4-6-c06883a8bbd6@kernel.org>
References: <20250213-update-release-v4-0-c06883a8bbd6@kernel.org>
In-Reply-To: <20250213-update-release-v4-0-c06883a8bbd6@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: Andrey Albershteyn <aalbersh@kernel.org>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=1748; i=aalbersh@kernel.org;
 h=from:subject:message-id; bh=VYmMJTB6ehENr3WhCSM9iKdq6BQu8DfprsA/mDAgtJk=;
 b=owJ4nJvAy8zAJea2/JXEGuOHHIyn1ZIY0tcF/fpeEVV9M+NV/c3vsza0KKav0M9dzPn6/5ZdM
 nfvb6ieMZ+po5SFQYyLQVZMkWWdtNbUpCKp/CMGNfIwc1iZQIYwcHEKwERWSDH8M45f2vz8Xb6t
 Vno400ZJS89A+QqH6zs5uWUOKF8++bHZkZFhUtCSta9TpaOXFCnZfC4SveV3Q1Pn0KaXNob2s/s
 /c03iAQDg+kkF
X-Developer-Key: i=aalbersh@kernel.org; a=openpgp;
 fpr=AE1B2A9562721A6FC4307C1F46A7EA18AC33E108

Without default value script will show help instead of just hanging
waiting for input on stdin.

Shebang fix for system with different python location than the
/usr/bin one.

Cut leading delimiter from the final CC string.

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


Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30F2C262162
	for <linux-xfs@vger.kernel.org>; Tue, 11 Feb 2025 17:27:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739294846; cv=none; b=MYg3IItOsxNrw5CgW2N1PTVvlbz967mze0fstlke06iOxc/IOTXKlVz9U5P8e8Y90oHxXL5cPWG50zPYbpUPf44IhuXxT0Lw/Jp0HtlYz9d7oWQ/uO7TS1Dv8rZYx11x37D84+/hBYEYCOSSHsyBX1hVbUBMx201q6a3BPWhklE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739294846; c=relaxed/simple;
	bh=4Fbw+XqP61Uaxwz0mjj/xD2lKl37iZmTyltw/87z4Ko=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=MpoxxJaza5ezZ0aik2ZaMxMYVFNkVpuhG/DYEdedPqJmr89Ds4jN3NtXHLlFMPeUabQuNP3MoWqXDSwN/1lKWy7VJDRR6Esw4KEMUY0TLPcF4XWrRufAcbKx2kB3i55SP+vFXiF8H/uqiU3rAhWbY5QFoM5BAlP59cAqCbDCZ2Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ewYTzCGD; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ewYTzCGD"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1739294844;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sNUfLB5JYV85TpcQVEw0wgxfmDOV95SyfAmBnVop0/4=;
	b=ewYTzCGDMltA4ymm+vsrpz/DJmaMK7AuNEZ2/EkVjJsU6ylWDA2SwMmqYh8V3kawLL4SUS
	x3S/yUDFrKHEosF71cNpFfMrth0hi8brZvZA3YphRZP983hLJk8bdO1BM7yribyswfdmtJ
	1CoW8sLW9P2tyrhetxtGIyH6HQ3ISmE=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-391-29UZUhrfOL6WaZONLBnXDQ-1; Tue, 11 Feb 2025 12:27:20 -0500
X-MC-Unique: 29UZUhrfOL6WaZONLBnXDQ-1
X-Mimecast-MFC-AGG-ID: 29UZUhrfOL6WaZONLBnXDQ
Received: by mail-ej1-f70.google.com with SMTP id a640c23a62f3a-ab76aa0e72bso490361766b.0
        for <linux-xfs@vger.kernel.org>; Tue, 11 Feb 2025 09:27:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739294839; x=1739899639;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sNUfLB5JYV85TpcQVEw0wgxfmDOV95SyfAmBnVop0/4=;
        b=D2hs1OLLHhXsZg6uoZcfSELgFCH+FwRkMqhJfI4n/rTt5HKGQ96PvfvKisJnxbphC+
         zRALxOs5dq//NX239TZrSoFR3kdbjKyMmZDzfpPhgWRdADFk8YvzIsLt4T15H+GOnnTH
         qpO5MZ65SyvW4LiNOtuhEqEvvH6jc9atxSmez2TCxS1MwHIuvVi0MmYWrcJWvEyJxOQQ
         7IfUz1ChnbrUCWO50hDi54R7sxwG4ujufwnNIVZM2p/QAI7434OKAlsyq4NnUVu49Hfr
         CdrIumQP33Vula4bKv1w2teRqEt2QXxVYrzBQc1g0lThlbyL+kxfSeXJCSKE5skVdZq7
         mtPw==
X-Gm-Message-State: AOJu0Ywtx/ZVUdjFWJGbNfHhw+cpwRndVz2wiVXOVZCtc9jy0N0mXG8j
	c6S0NXmY+kKEHqxkABb1G3O3MV2Nat28uxnBuTx0+6waJA1x8QcvX+4merAyM2/zNiYI6+jwfPe
	b2xDXE/VFWjO1eejdZomN9oS93eSlRS1ErmJf9JKvI7IV2vRQyGH6IlPGbv4bOJpGpvc=
X-Gm-Gg: ASbGnctUcbMexPyZxt4jINrdu2JOQDG4kE3oBKsd6wr56QIHi2wxX9Lt94Q/XFPpiEE
	hY+/oI8mK1VHUOYnATuQ2eYHCy0gAu0QpSM8kWjlnIxUARn4dG8vyO/rXEvjojRIQNQBMmfWO30
	K9kjFJTiboX7+cmytlrotPgw6iNEhr61xa00TVggEoQJTXWrDJ2YB2NqmZGBNQnUrLtmLusVS3p
	eARLBTKfyshvgU70As0jGIcmG3Hl3EBJkuWaKYIVM+b6tRWi7LO/w2lSMMdWrmT0ngGRlYgkr/P
	2nlamqUrAHmVAkDxiew/jM/n0cPdFjY=
X-Received: by 2002:a05:6402:27cc:b0:5d0:d818:559d with SMTP id 4fb4d7f45d1cf-5deadd7d39emr76243a12.11.1739294839204;
        Tue, 11 Feb 2025 09:27:19 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEC2TwZohEYhD+RbkjUvkfxUpA125nSK6VJRheGjJwkH1S4iG1YEOKWVD/fE8Bk6JsPjVliyw==
X-Received: by 2002:a05:6402:27cc:b0:5d0:d818:559d with SMTP id 4fb4d7f45d1cf-5deadd7d39emr76195a12.11.1739294838869;
        Tue, 11 Feb 2025 09:27:18 -0800 (PST)
Received: from [127.0.0.2] (ip-217-030-074-039.aim-net.cz. [217.30.74.39])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5de5ced9758sm6914335a12.76.2025.02.11.09.27.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Feb 2025 09:27:18 -0800 (PST)
From: Andrey Albershteyn <aalbersh@redhat.com>
X-Google-Original-From: Andrey Albershteyn <aalbersh@kernel.org>
Date: Tue, 11 Feb 2025 18:26:58 +0100
Subject: [PATCH v3 6/8] git-contributors: make revspec required and shebang
 fix
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250211-update-release-v3-6-7b80ae52c61f@kernel.org>
References: <20250211-update-release-v3-0-7b80ae52c61f@kernel.org>
In-Reply-To: <20250211-update-release-v3-0-7b80ae52c61f@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: Andrey Albershteyn <aalbersh@kernel.org>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=1303; i=aalbersh@kernel.org;
 h=from:subject:message-id; bh=4Fbw+XqP61Uaxwz0mjj/xD2lKl37iZmTyltw/87z4Ko=;
 b=owJ4nJvAy8zAJea2/JXEGuOHHIyn1ZIY0ld3FCw7YfnU/u2tVf/UJJXXK2RPmPBxs9Kt2rXdI
 k/k6v4HqczpKGVhEONikBVTZFknrTU1qUgq/4hBjTzMHFYmkCEMXJwCMJHOhwy/WavlqzzP1715
 fNNNKULnveS+FOdz4hHSB75wMZ7/f2WPDCPDGratRjfm7mmeoNPlfEXQ06ik8IIFv8iGDRZic18
 n5aZwAAAeTkez
X-Developer-Key: i=aalbersh@kernel.org; a=openpgp;
 fpr=AE1B2A9562721A6FC4307C1F46A7EA18AC33E108

Without default value script will show help instead of just hanging
waiting for input on stdin.

Shebang fix for system with different python location than the
/usr/bin one.

Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
---
 tools/git-contributors.py | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/tools/git-contributors.py b/tools/git-contributors.py
index 83bbe8ce0ee1dcbd591c6d3016d553fac2a7d286..628d6d0b4d8795e10b1317fa6fc91c6b98b21f3e 100755
--- a/tools/git-contributors.py
+++ b/tools/git-contributors.py
@@ -1,4 +1,4 @@
-#!/usr/bin/python3
+#!/usr/bin/env python3
 
 # List all contributors to a series of git commits.
 # Copyright(C) 2025 Oracle, All Rights Reserved.
@@ -71,8 +71,7 @@ class find_developers(object):
 
 def main():
     parser = argparse.ArgumentParser(description = "List email addresses of contributors to a series of git commits.")
-    parser.add_argument("revspec", nargs = '?', default = None, \
-            help = "git revisions to process.")
+    parser.add_argument("revspec", help = "git revisions to process.")
     parser.add_argument("--delimiter", type = str, default = '\n', \
             help = "Separate each email address with this string.")
     args = parser.parse_args()

-- 
2.47.2


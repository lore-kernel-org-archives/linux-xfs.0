Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5C1F24BC19
	for <linux-xfs@vger.kernel.org>; Thu, 13 Feb 2025 20:16:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739477772; cv=none; b=eK/wmrds31pGWagiUTxPk0NDxcFZ/s94Z8aNFR/vsiKVcQMf5/k/sngachkjONWiwQnR4tqXfKZcN9hF/ZgWbK1/FG7Uzm6zDK5cHzHwfFdbRl8YE3Wz7l3Ajh0Mie/jXu2hLCYHBvi99WmMPPvTOZWKCc7oIIPs26DJrhRtESo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739477772; c=relaxed/simple;
	bh=XNICfqvtAdFyaSy5yFvtRHfxYOmOjIVK99ClUIx4oGk=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=kxzDMcPbBidt+NqzdvgnxOl9F+/Ic4/Ph5Fj3ZpAnsT/IUDaDg2BXdyRtJJm0D8Vu5KgiabzzfHl0fIArlogN8P8AEOUCmPWsvkGCiJIjscXUjFICJORNcPQpis9hZfjqh2ejXoN6S0LQu11f2N+k32PGQjICxthlCyj+1+z1eQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=XhC3pykS; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XhC3pykS"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1739477769;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+4/i8ubbRyMPAjDq/V5xbwxQmNy53IZMUMQjA3oiP2U=;
	b=XhC3pykSWoS+SloTIx9IYUUrl6sv0i9ty0qsPyCHAKe/bsnj1IRfuf62p93JjIFJnVsfJ1
	QKTEH2w6IjV0yAtNHfToNugTBB/XZv1Y4OtHrVpsy8WpVndQoZmWPkQNc1mkI7amllqPeA
	ZlOn17yB4ajAxnr33kuT5mLQvVBqig8=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-86-XJRZ1UasPTuqUrh9hJgnUQ-1; Thu, 13 Feb 2025 15:16:08 -0500
X-MC-Unique: XJRZ1UasPTuqUrh9hJgnUQ-1
X-Mimecast-MFC-AGG-ID: XJRZ1UasPTuqUrh9hJgnUQ_1739477767
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-38de0201875so785040f8f.0
        for <linux-xfs@vger.kernel.org>; Thu, 13 Feb 2025 12:16:07 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739477766; x=1740082566;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+4/i8ubbRyMPAjDq/V5xbwxQmNy53IZMUMQjA3oiP2U=;
        b=wm69lr7PNf4TZO+O7HRlY4xaY0aQ4o4sUKQ6+bd+RRW0vXCrNv+PhHzNM0sW8UkgVW
         L/O4o4kyGE03O4qfJCXZ3k2ZcaGO3QyOrlAgzRKxBCuV3FyGWoMrEauEaXQWSgA1tStL
         kbherroCLqCYbwnGoifexHErmDxplcHo59SQqkefx2BEW/8wcsht6zS83PHtiZbYcwBj
         6NhmzAvDc4xmQH4b9I5GsUDVK3Heyv1nLcoA7wOIP5snobLG7HtMn01cQJLsIDoGXoGa
         AheIgTCkoQc/Dkcc5CpB6UpdYV+vZ9ookIDLKBB5rH5UXvfahG3mp+7O73pdwzOlM72n
         w7NQ==
X-Gm-Message-State: AOJu0YxSxJp89vVKW18hdMC4iy/QUQfh2MH7oEH3e5ayQjj9hc1xu5CF
	xnmn1tXIe0E4beDwsFtLysRh5trpiYcpgg8J8gJyEkLEYJdqlvZ6Mqsou3/XmN9NOKKYRsOCEh0
	0uTvkga7Nf/2oU2I7eGhCSC0RRA1Vg+rBNh0urkn5ZTQZQL3HlRvcs4p/36tD2Wsm
X-Gm-Gg: ASbGncuOim+nz9/okx1UBb12axc6z86HY2npz/l34nNQ85ezfn9CGZk+uj/wCSRawEA
	29nRMaFn+6xdXZ6KO3nSeieG99DAm+4g8LtalqVEME1nUdqEM/AiXTsL6So/5q0WYqM2nR4va16
	H6fgqwGC8U1Z0cZ3LAGZ2j9cnMc0qhWV1ovjE9Za8C9csOypoHMFdebOunG5F3Lctp+S2eDYXzi
	Y7HH4RNmMj54V1DEMsvZNYIF3vfo9RRc0vSJS8+lSbnkv3Dlgp9y87HqfNx8neo5k+sb2X6modP
	2m4GkDDlzqp3R0/pwbAXz+Nt9TCRMI0=
X-Received: by 2002:a05:6000:178b:b0:38d:c55e:ebcf with SMTP id ffacd0b85a97d-38f2451a511mr5180621f8f.52.1739477766561;
        Thu, 13 Feb 2025 12:16:06 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFr1XiW5AZJPmmi7WnXT4ODMT0EYmPXoglelcXIxhXwWnvwn7rX8gsPSlCi4XNJJlK9kTyPnw==
X-Received: by 2002:a05:6000:178b:b0:38d:c55e:ebcf with SMTP id ffacd0b85a97d-38f2451a511mr5180602f8f.52.1739477766264;
        Thu, 13 Feb 2025 12:16:06 -0800 (PST)
Received: from [127.0.0.2] (ip-217-030-074-039.aim-net.cz. [217.30.74.39])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4395a06d237sm57520895e9.21.2025.02.13.12.16.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Feb 2025 12:16:05 -0800 (PST)
From: Andrey Albershteyn <aalbersh@redhat.com>
X-Google-Original-From: Andrey Albershteyn <aalbersh@kernel.org>
Date: Thu, 13 Feb 2025 21:14:31 +0100
Subject: [PATCH v4 09/10] libxfs-apply: drop Cc: to stable release list
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250213-update-release-v4-9-c06883a8bbd6@kernel.org>
References: <20250213-update-release-v4-0-c06883a8bbd6@kernel.org>
In-Reply-To: <20250213-update-release-v4-0-c06883a8bbd6@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: Andrey Albershteyn <aalbersh@kernel.org>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=705; i=aalbersh@kernel.org;
 h=from:subject:message-id; bh=XNICfqvtAdFyaSy5yFvtRHfxYOmOjIVK99ClUIx4oGk=;
 b=owJ4nJvAy8zAJea2/JXEGuOHHIyn1ZIY0tcF/bplwbgwQc9WUM1f1YnHSlG2yf89u2D1U63t/
 dufNrrMOt5RysIgxsUgK6bIsk5aa2pSkVT+EYMaeZg5rEwgQxi4OAVgIiy3Gf4HTebldXygWLBs
 R1OQpoHnDQ9x9nVZ+Q/0dj5Z5xF44Hopwz/tJvlLh/Nya1VaLmy68maF56YZPIaPs+1/v1bsNrk
 S788IAK3jRYI=
X-Developer-Key: i=aalbersh@kernel.org; a=openpgp;
 fpr=AE1B2A9562721A6FC4307C1F46A7EA18AC33E108

These Cc: tags are intended for kernel commits which need to be
backported to stable kernels. Maintainers of stable kernel aren't
interested in xfsprogs syncs.

Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
---
 tools/libxfs-apply | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/libxfs-apply b/tools/libxfs-apply
index 097a695f942bb832c2fb1456a0fd8c28c025d1a6..e9672e572d23af296dccfe6499eda9b909f44afd 100755
--- a/tools/libxfs-apply
+++ b/tools/libxfs-apply
@@ -254,6 +254,7 @@ fixup_header_format()
 		}
 		/^Date:/ { date_seen=1; next }
 		/^difflib/ { next }
+		/[Cc]{2}: <?stable@vger.kernel.org>?.*/ { next }
 
 		// {
 			if (date_seen == 0)

-- 
2.47.2


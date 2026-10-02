Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1ACA448388
	for <linux-xfs@vger.kernel.org>; Fri,  2 Oct 2026 21:10:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790975446; cv=none; b=BFKTAkzmGAw2e2AnxctX4EFHBEbuyDL3yu9H95nnMsmCZcKEJgp/ck8+UkdR5SBDFmuO2XMWdffMd+UzqrPbw7AH78uFEIR46GWVlAmtvJP91MR7cmZ6CPLBue1/TSJUZIbpD9HxMR1Re+B/k2KMUeoCh+sJ7COsYIjk+GruDTo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790975446; c=relaxed/simple;
	bh=yHYe+hi5KgB78AWsG4fSS5iFkuqwaCxAgIe4rTqWQZQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=uUKmCnT96fiFCc1RQa/ZtGGbu8fF9VO/BmN8zigKCwhLjAnwO4Li8rvJQjM3klJrWb6bmXTo+78fVQ8y/7DMCmlqQsSf4P05lEB/Ow2P3W8Reb4OHtnmjZelWHxQtNMvJwiqq3nxFMyOWRJchg3y4OHbrvYgPm0wvsUiEF2n/9E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=b3t6181O; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=Ksz50rn+; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="b3t6181O";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="Ksz50rn+"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1790975443;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=WNQKEnOgZOYxwt34e2WtIRVR4XtlsX1b+/t3ye1Cm8g=;
	b=b3t6181OlG3u4B2AjHCXa+1fgqvW14FhTEnW4zhjs7tJIfO1/6B2swtL4g8dn8DjUFagrI
	yBk5y7Vd4wnBfaA1bh9ehYgs4DWR9q9kui/2hjUIq0BGzatVElHnu94n84juueq97v0gdR
	R9fJ3+7hnRDOamBF6/MlBM/FALWJzJk=
Received: from mail-ot1-f72.google.com (mail-ot1-f72.google.com
 [209.85.210.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-692-HDtIOe7wPYe0yngOeIJSFQ-1; Fri, 02 Oct 2026 17:10:42 -0400
X-MC-Unique: HDtIOe7wPYe0yngOeIJSFQ-1
X-Mimecast-MFC-AGG-ID: HDtIOe7wPYe0yngOeIJSFQ_1790975441
Received: by mail-ot1-f72.google.com with SMTP id 46e09a7af769-80a4a17618dso636066a34.0
        for <linux-xfs@vger.kernel.org>; Fri, 02 Oct 2026 14:10:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1790975441; x=1791580241; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=WNQKEnOgZOYxwt34e2WtIRVR4XtlsX1b+/t3ye1Cm8g=;
        b=Ksz50rn+Li90h5/oh2zlTyRcy4HdEtLaQCH+0J1TBlYnes6qFGvZHgNvYzi7fNt4rv
         0GjXPVXrT2AUvqFG9ezgJoQN1m5xEkynoGxZLd3mOVpE5lL7aWwsaTH02XN5socdvlQI
         lf/OayEGSfV3HnEBt5f10bCy3L+wL9av/H6++z00F4kyp12MXQAPEfjrxqAR/QZIbWPt
         MkqcoNWDWzUt8rktXQwJNfkWM4N7f+AFh0Au3Yg018CFD8XlmcvuXRX4WsszjxwbLajU
         WKnIx3/0uCXyIUbon8qpdrRYQuPHdig7bER8zldUAHS4TvuoFKDni2cb6I+h0WT0sOPJ
         68GQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790975441; x=1791580241;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=WNQKEnOgZOYxwt34e2WtIRVR4XtlsX1b+/t3ye1Cm8g=;
        b=RZW1LdIc9Pb+b4eA6qlBzau24yixFhBdpPDFy5OC+Rm7xSqphor5v+jal7q8jJXLHP
         PeVo+j2xiHDXFd1lAd2bo6dXbT99qctDNqheeRmcpFdHWUxWR1bpSJishXweSyK1o3jK
         GUajCGKu4wkkoGUNnFnONyj3lZXIme3M0aTN32Z305E/+/JqEZOn3Bxbz+9h5XfsRYSV
         40tiL8vroB8YBbWY0kl+FISoou4DX/8InVGRY+Dj3lOIY79VjaRZbTkWPr5TJ41OODIM
         rK8DiEkFtAzZLpxM5zXKjm3GIZjyxh+XS+6ttlkcas2LkuszWALeUAy61Ft8Cogumw+r
         MHBQ==
X-Gm-Message-State: AFuF++m0e2R6NZW0v2OfH/u4sHE5/Ygr/a3gS1mrZA5mtA0LmpYwSuE9
	K097priw7k+oTGHJQe3h5pbJdFk6+FMOHukA9JznU3Y3j+wt43H7lf4suxwNbJ+ryjze2HSwtw9
	K2Toijy6NZSG9l56csX2szGC7l/BKWzG/bSdcMfSqD9xseFxr9qJpeQPdmMRBTIoBsOaTARSi7f
	+khju1d4bByTutWpPhLJQVP9WhSwoOrHBo+zixAu4KfpTtyRc=
X-Gm-Gg: AYBFou1oNw/Z/UgvNrVNSnVMxm4d10uFOE7/1Wug3zmNUkt1SaTgodgt0MdfkaYuwfl
	4rrvI3wF0w7iXk2Wc50H6RWNksORR7C/h0nwLh3iNcpSV+xFP+JSOe0qCsGiTIeFUOvMsawIUvx
	wuJmzNZ+3GdBwA6K7UP7UXrY+638tfLjpMuYS56+LkAZmezASZWIIlSeLaUrPINe6uehItmTFgI
	/vt5z9qL2GncppHQZqlx8h5vvrCMhFJQrh+KeerX4QHYnZqB6RZBycINqPNf8o8Zkba/3f+Y3z1
	Y8TcpMwC87Tb33YfzYodE5O1GPcWmiozKFH84l01rYmmq3t47KhNTc1zMki3GSC8u4sUZD7n8Du
	DqPVN5zo6+1VOb6BppdmZQm7JzUGpiBROetQM4Q==
X-Received: by 2002:a05:6830:6c0c:b0:822:4c30:8f04 with SMTP id 46e09a7af769-82285765089mr2945419a34.13.1790975441519;
        Fri, 02 Oct 2026 14:10:41 -0700 (PDT)
X-Received: by 2002:a05:6830:6c0c:b0:822:4c30:8f04 with SMTP id 46e09a7af769-82285765089mr2945402a34.13.1790975441039;
        Fri, 02 Oct 2026 14:10:41 -0700 (PDT)
Received: from big24.sandeen.net (97-116-156-223.mpls.qwest.net. [97.116.156.223])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-8227aa72075sm4456044a34.27.2026.10.02.14.10.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Oct 2026 14:10:40 -0700 (PDT)
From: Eric Sandeen <sandeen@redhat.com>
To: linux-xfs@vger.kernel.org
Cc: cem@kernel.org,
	djwong@kernel.org
Subject: [PATCH 0/3] xfs: more misc code deduplication
Date: Fri,  2 Oct 2026 16:08:08 -0500
Message-ID: <20261002211038.2139655-1-sandeen@redhat.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Reduce more cut and paste.

These 3 are independent IIRC, so if anything gives anyone heartburn we
can just drop the patch(es).

 libxfs/xfs_dir2_sf.c      |   68 +++++------
 scrub/attr_repair.c       |   12 --
 scrub/dir_repair.c        |   11 -
 scrub/refcount.c          |   27 ----
 scrub/refcount.h          |   56 +++++++++
 scrub/refcount_repair.c   |    3 
 scrub/repair.c            |   16 ++
 scrub/repair.h            |    1 
 scrub/rtrefcount.c        |  263 +-------------------------------------------
 scrub/rtrefcount_repair.c |   39 ------
 scrub/symlink_repair.c    |   11 -
 11 files changed, 122 insertions(+), 385 deletions(-)

Thanks,
-Eric


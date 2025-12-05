Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1848F305E0D
	for <linux-xfs@vger.kernel.org>; Fri,  5 Dec 2025 15:03:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764947022; cv=none; b=CvACtGBdTO19qLXeHuKoAPvNva05Be0+Jswn8ZajIokProTszHsC9uOvyyaVr5eraJttJvlFuIFbsBigJbdDst0VyDunCpmGZlzTGjp4IuLMjiPkKH6BwQFnmkIeb2GF3p62o3EH5FmVXpKuieEjuhUuk5ODGA39jp846OZrmPM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764947022; c=relaxed/simple;
	bh=FOrIAOrLz45BLzgEl+6tW2WEgtZQ4tBT+6XxwzxLT94=;
	h=From:Date:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cUga7E7K/tHct7Hx9mdjxHhgEgYTZbiR6dOMHpZa/OdixZneaP8ahlewUMb81qGeDLndPQsT4FLKtWxJtWOD71c/SN6Mew6hAjBRJbcgOCDMlMaoXEu4NJ1KdsHmU+Z65b7FNZIogiMm0FZyBWy+DdkeheUdzcH1ATCsQhSfvtw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ezU1vNPQ; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=RImgv3c7; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ezU1vNPQ";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="RImgv3c7"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764947017;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=BXVQBIwIqraoeFL7pf0tgfou27V0cCgp3GuWoePCCHE=;
	b=ezU1vNPQm6gB1nuU8fXmIb4sBsueI6WeckRgOgTHsSFcGDuBIYWh/eCOJjn9LiBccbBK/O
	SNjwE9SUWa7OTD0OpBob11Oz3CVJPwTVjWzMNDVclZ/hS4D3Qwvtk3tsU8u2GEJ2Yfaccc
	d+vbs086ozQriZn7kAkcdPsEUgjBQGM=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-359-MTSMjhbwNjSbFI4b8AEyCw-1; Fri, 05 Dec 2025 10:03:36 -0500
X-MC-Unique: MTSMjhbwNjSbFI4b8AEyCw-1
X-Mimecast-MFC-AGG-ID: MTSMjhbwNjSbFI4b8AEyCw_1764947015
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-42b2ad2a58cso983729f8f.0
        for <linux-xfs@vger.kernel.org>; Fri, 05 Dec 2025 07:03:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1764947014; x=1765551814; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=BXVQBIwIqraoeFL7pf0tgfou27V0cCgp3GuWoePCCHE=;
        b=RImgv3c7ZOYpUj5DfS95apueXF8NHIyKFPA3ePl5K30lGL0Gbi6Q7tOTHf1vGBcUwW
         kslkG2C0wW/DjdfmuFEw0ftZYp2D4/GTD4tmNq5AFmY3jiyr3uUJMNTOekmVpAvIipkT
         BTCnssC5I0B+PodZQBvsD+DAQ70JEbAZAPOdBMnDAv2zThebjAVgr7r+SWWmPY59GQMZ
         ycz3yni15zgTinqoNr6V/ZPq+KUQTVfn7zU3g5UpDAkSOKLd2mv0atIE2D610xm2RyIW
         636Um7TCrah0o5FkhsEnR+EbSymOlvL1cNYkHNQ1JkdBKJ8RQWVahbQhYjsRFosBqojI
         0rCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764947014; x=1765551814;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:to:date:from:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=BXVQBIwIqraoeFL7pf0tgfou27V0cCgp3GuWoePCCHE=;
        b=T1miqfTtQw0dsL35A22Gnm79mb3EKznp2+iTbV286LYVmgrzSpRVFGAkXmmf+yAxtZ
         SZgOOud1fg0zHeiEECHY/oyGmI6jhCM0aS5m3TnGcXS8bhA2fYKdDhHwOr6aJbcUJ0UK
         Q88bof7wL4fsvjRQLzDQxWRzwztgttgASVNpa9ZHY8+2I0/aQdkX/TrEvjQ3HbaaTQtK
         q6MDse+MXBi7/Q3mxDN1Se6ppy3rlSK1rTnVB6+hm2nstT4zeaL8mpxLFBac+9SR1TPM
         6YpOyw5i/2TAc7xOivCZPLKnIbdx/bXmwEAQIL6teLbgm2a7VxOucLPue1uL8SnGm4Cf
         GNnw==
X-Gm-Message-State: AOJu0YzHs17d5tvPBb1QoL6hrjEa6uh51MoUNTiw7gVSG9j+7FsdLLoz
	ObjJKDIdGL3x4DF1FXMzE72TFui+yC5rUdt3218sL8C481pLDLh2TiR6d72Z5pTpZChOIQygnn7
	1fZWVvUf1ZmTWxGZ3YTPmYz8Jna6DnZBSAIRH8uxT1wPyFoenXxupk5xeIOcxJENAIh2nohsRrV
	8WMhNpi/QxmYnqGMjCsdn2egHcmqg6fcvzDogjNlDZm/dn
X-Gm-Gg: ASbGncusFkZsQFZoMeSTCvX/3wWX4d3PfLTu4PrGk9Gq5QbXlYVGI+DEfVxW3XGolPf
	43ZXjd6Gz/htuUVRaDwQFglSRhLfwyGGUAwnYzVidMGeev5IGeU5FLuJQ+mflDvnaC4v0W9ww+g
	wf+Q6fugyyqSDdcmqPM7ClLbS9lRU4C/p2BGu4cYEouTdLGXUQjTp1DcrQkpwuCVBouBFOhp9Jc
	ohOmfBjARtI452ohUKf3rSJTn85smdGPrZ6j+Kp9bZbe+G2qMDEV7xwEgLQrgQZv39AP0oKqCrY
	cLkx0PMTDGnY2mKhStDw5PKzv38j4CkMUYFTUhWx0SvZF6LzhwdaS/yaK99rDhdEDpG8e9sM7KU
	=
X-Received: by 2002:a5d:5f43:0:b0:42b:2e1c:6341 with SMTP id ffacd0b85a97d-42f73174480mr11564017f8f.9.1764947014442;
        Fri, 05 Dec 2025 07:03:34 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFAJhwDzGtbB5RtHvfmtZ09AsLOOJTOYrfomaDshp+R5kHCQCIIeB+T/6WDM1qozVsu5I0Nog==
X-Received: by 2002:a5d:5f43:0:b0:42b:2e1c:6341 with SMTP id ffacd0b85a97d-42f73174480mr11563956f8f.9.1764947013802;
        Fri, 05 Dec 2025 07:03:33 -0800 (PST)
Received: from thinky ([217.30.74.39])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42f7d353f8bsm9450262f8f.43.2025.12.05.07.03.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Dec 2025 07:03:33 -0800 (PST)
From: Andrey Albershteyn <aalbersh@redhat.com>
X-Google-Original-From: Andrey Albershteyn <aalbersh@kernel.org>
Date: Fri, 5 Dec 2025 16:03:32 +0100
To: linux-xfs@vger.kernel.org, aalbersh@kernel.org, cem@kernel.org, 
	cmaiolino@redhat.com, djwong@kernel.org, dlemoal@kernel.org, hans.holmberg@wdc.com, 
	hch@lst.de, preichl@redhat.com
Subject: [PATCH v2 25/33] xfs: remove the unused xfs_buf_log_format_t typedef
Message-ID: <xycjda2zxe7jlvwnsgi3vt6lzlehqlt2spqmtvfdt4iwu3x5at@ywuxgxvx65xu>
References: <cover.1764946339.patch-series@thinky>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1764946339.patch-series@thinky>

From: Christoph Hellwig <hch@lst.de>

Source kernel commit: 1b5c7cc8f8c54858f69311290d5ade12627ff233

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
---
 libxfs/xfs_log_format.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/libxfs/xfs_log_format.h b/libxfs/xfs_log_format.h
index aa8e3b5577..631af2e28c 100644
--- a/libxfs/xfs_log_format.h
+++ b/libxfs/xfs_log_format.h
@@ -541,7 +541,7 @@
 #define __XFS_BLF_DATAMAP_SIZE	((XFS_MAX_BLOCKSIZE / XFS_BLF_CHUNK) / NBWORD)
 #define XFS_BLF_DATAMAP_SIZE	(__XFS_BLF_DATAMAP_SIZE + 1)
 
-typedef struct xfs_buf_log_format {
+struct xfs_buf_log_format {
 	unsigned short	blf_type;	/* buf log item type indicator */
 	unsigned short	blf_size;	/* size of this item */
 	unsigned short	blf_flags;	/* misc state */
@@ -549,7 +549,7 @@
 	int64_t		blf_blkno;	/* starting blkno of this buf */
 	unsigned int	blf_map_size;	/* used size of data bitmap in words */
 	unsigned int	blf_data_map[XFS_BLF_DATAMAP_SIZE]; /* dirty bitmap */
-} xfs_buf_log_format_t;
+};
 
 /*
  * All buffers now need to tell recovery where the magic number

-- 
- Andrey


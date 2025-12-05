Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCAE1343D8F
	for <linux-xfs@vger.kernel.org>; Fri,  5 Dec 2025 15:04:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764947075; cv=none; b=UVJHgUbJ02SnKfU5kTrE9zCqUF6EEJNzHLPvEpkYYlsHb2FKL7PzEujcJTR1hHRoqCnwG1VLHHGcvaA+2jmACib2cJWKYEkO87WMJW1fober+yw5l4ZTRitoaI3ZpMvSbuLSGlHNBq+NkD84eEr7b/xoBMT2syY0QezJJZw/qrU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764947075; c=relaxed/simple;
	bh=xGnykQaua/nd/s4s8V87ZJQ+lof2bTmvrXZcuxC/B3A=;
	h=From:Date:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=puHfAdJFQu5JBXD5HIfbR60SSw9TxabSmw6MOmxHR9fYneUeejvlcVnvp9d2F0UNJMFjGsdtoh4CPeo+hZUGaieCDT9cnlDtdIT5mjdB1btUPYzuYKaazWKJXPnWnJkmHYpadHU4ppzSQBSxyOi1QWPOh28fI+n6H3NFbY2mNis=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=HJPPZlJU; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=bJbN0qKM; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HJPPZlJU";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="bJbN0qKM"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764947070;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=8tsf8MnXAOA+ZlTJo0VvCTEPLXIZEoVQ1tGqT0a0KOs=;
	b=HJPPZlJUtYIdj53Om7jLc80WahFw+/0TcO7xxBhQ18KB/SJlc76rm0l2XlLgE5OGCAqWxL
	f7m0slueRCMtPh1Ae3m8aDUB6ho74BTx6buTw6Ll4cofg2MWMk6KI8/Vd4Gv/FltuMqigQ
	buYj2yMg+H0U0ecUi/FOSC5i7hqVZg8=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-492-AsjS5sU8Pfi8XMQ5fnAMWA-1; Fri, 05 Dec 2025 10:04:29 -0500
X-MC-Unique: AsjS5sU8Pfi8XMQ5fnAMWA-1
X-Mimecast-MFC-AGG-ID: AsjS5sU8Pfi8XMQ5fnAMWA_1764947067
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-42b366a76ffso1267417f8f.1
        for <linux-xfs@vger.kernel.org>; Fri, 05 Dec 2025 07:04:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1764947066; x=1765551866; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=8tsf8MnXAOA+ZlTJo0VvCTEPLXIZEoVQ1tGqT0a0KOs=;
        b=bJbN0qKMaWKwAcrGX1FXcpmeJcikgZ1U79jfSmIn5pODDOqSCSAu1TLl3gD3x6H89z
         9voTrj16P/3PmviB6a29w4cphxkJ2P2ANwp9UGkVObhOmplyROgGYRF4zoY48t7r9kTi
         DveTrIGuIqQnc5Rw3Ony0uFnfow8+XQS4LgDcO846epV91vrLntu7msLAK2xKmOsc19/
         jc8AEf0nrMbVHNpIWdmkGC90xZj4ZvaTexUXqsOOu03ykQS4+VAAX+PJ6h8iuq78XDcz
         3AlQn8Ljd2vWb12sM4LOUIT+75e421C6Z5CkQDAzIX2bfYCgsaVdKcyfI6DkHN0QffS9
         5GiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764947066; x=1765551866;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:to:date:from:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=8tsf8MnXAOA+ZlTJo0VvCTEPLXIZEoVQ1tGqT0a0KOs=;
        b=LJrLEzpHEkSr7wqEzYS85OyFl986uj4135/TvoTldNzelJkjQoqYF9NdaHLahVDrD0
         rZsUVqq1nSMQQgZN4M1hZHJjCMAJzW0CZ2ZPfQrdEf0Oj6o2jhdKiuaxIQ/35tuXyRor
         zTt0zzRk1TEZSk3AXYR2bSK1SRx5j4XGo6cK+E20YByWpRc5T6Abx5TkkzE12z19NGfC
         Y6zdbT+PbzNLp3kzHg9j60k+4AT7GZ5LxvYbBZnhyBcEqFGFBh54mQ6nYmvucXe59HAy
         yAp7MDtwWAiTARKWlKwc2/99qFTESCA3uJEcKS4dYrOlJXdxKJcNDQfAN5ZZC0hJasEc
         NLGw==
X-Gm-Message-State: AOJu0YzQCVb62/6Nb/EC7Grqaw9k7PxuScmB4KGSdtKkpgGQMHh9gA3i
	ZEUEoPzi4isMxVzm9XFvisgLyQ3GyPvTe7Tfy7Nsjsx8DBavy7vuXvr1UlgvuKE5C62uBMZdC+u
	s/qpFr7OPxNS3KWaK6GE4mOsFB3jktuHT68jik+FuOyraUt87gSQbY+qphdAD3S4TyLeON9OvM9
	0bRaq4Kah61YIOiE0FWlEbFcSBdO9CfH+BqLejnqz7MkqF
X-Gm-Gg: ASbGncskX53yTn+KeTYsCwtZvc75/QYoyNfKRxteAz4beb5gAxZK/Mh9lFCWmorkrjE
	8b8bsWNo/bWcRniFZ+VrmqzPDAjBS8aNmteeUisAXCQWgDCYpOQVH6p+7B0VuCcsV353aK9BqzU
	Vtvqi8fj95xbgbYOMeDbRK9614vRFmKlLbeSIsaE+6JhfKHMutJeo5dZmT5mc0n5b2EXyVhm1qv
	i2ng1JIhEVTUTGI0MF7uNezoc24WiZ1TyyrThK60LO98MXMnHBbz0/S7TUeWzENTiBa6HjbN5Wd
	Z7cdrihDg8xaJKZ4byKZYhsbK5Ap4JheecUaLmVsTlkdqqOJehudVb6EWLv1tgj/QQ0L50ubwvU
	=
X-Received: by 2002:a05:6000:2887:b0:429:8b01:c093 with SMTP id ffacd0b85a97d-42f7980aab0mr7401536f8f.15.1764947066208;
        Fri, 05 Dec 2025 07:04:26 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEasfcC341yu4irYYneScChjmTdD9DVaJzh6BUHYtXbAmO4zg8O14tbslv6EOf8aCMTogdRPQ==
X-Received: by 2002:a05:6000:2887:b0:429:8b01:c093 with SMTP id ffacd0b85a97d-42f7980aab0mr7401471f8f.15.1764947065602;
        Fri, 05 Dec 2025 07:04:25 -0800 (PST)
Received: from thinky ([217.30.74.39])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42f7d2226d0sm9161607f8f.21.2025.12.05.07.04.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Dec 2025 07:04:25 -0800 (PST)
From: Andrey Albershteyn <aalbersh@redhat.com>
X-Google-Original-From: Andrey Albershteyn <aalbersh@kernel.org>
Date: Fri, 5 Dec 2025 16:04:24 +0100
To: linux-xfs@vger.kernel.org, aalbersh@kernel.org, cem@kernel.org, 
	cmaiolino@redhat.com, djwong@kernel.org, dlemoal@kernel.org, hans.holmberg@wdc.com, 
	hch@lst.de, preichl@redhat.com
Subject: [PATCH v2 32/33] xfs: improve default maximum number of open zones
Message-ID: <5bskwe62qj2uqhfw7hqi3qtcvkywmggvgxolg7okyfhi6bkqah@rin2higjat6e>
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

From: Damien Le Moal <dlemoal@kernel.org>

Source kernel commit: ff3d90903f8f525eedb26efe6fea03c39476cb69

For regular block devices using the zoned allocator, the default
maximum number of open zones is set to 1/4 of the number of realtime
groups. For a large capacity device, this leads to a very large limit.
E.g. with a 26 TB HDD:

mount /dev/sdb /mnt
...
XFS (sdb): 95836 zones of 65536 blocks size (23959 max open)

In turn such large limit on the number of open zones can lead, depending
on the workload, on a very large number of concurrent write streams
which devices generally do not handle well, leading to poor performance.

Introduce the default limit XFS_DEFAULT_MAX_OPEN_ZONES, defined as 128
to match the hardware limit of most SMR HDDs available today, and use
this limit to set mp->m_max_open_zones in xfs_calc_open_zones() instead
of calling xfs_max_open_zones(), when the user did not specify a limit
with the max_open_zones mount option.

For the 26 TB HDD example, we now get:

mount /dev/sdb /mnt
...
XFS (sdb): 95836 zones of 65536 blocks (128 max open zones)

This change does not prevent the user from specifying a lareger number
for the open zones limit. E.g.

mount -o max_open_zones=4096 /dev/sdb /mnt
...
XFS (sdb): 95836 zones of 65536 blocks (4096 max open zones)

Finally, since xfs_calc_open_zones() checks and caps the
mp->m_max_open_zones limit against the value calculated by
xfs_max_open_zones() for any type of device, this new default limit does
not increase m_max_open_zones for small capacity devices.

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
---
 libxfs/xfs_zones.h | 7 +++++++
 1 file changed, 7 insertions(+), 0 deletions(-)

diff --git a/libxfs/xfs_zones.h b/libxfs/xfs_zones.h
index c4f1367b2c..5fefd132e0 100644
--- a/libxfs/xfs_zones.h
+++ b/libxfs/xfs_zones.h
@@ -29,6 +29,13 @@
 #define XFS_OPEN_GC_ZONES	1U
 #define XFS_MIN_OPEN_ZONES	(XFS_OPEN_GC_ZONES + 1U)
 
+/*
+ * For zoned devices that do not have a limit on the number of open zones, and
+ * for regular devices using the zoned allocator, use the most common SMR disks
+ * limit (128) as the default limit on the number of open zones.
+ */
+#define XFS_DEFAULT_MAX_OPEN_ZONES	128
+
 bool xfs_zone_validate(struct blk_zone *zone, struct xfs_rtgroup *rtg,
 	xfs_rgblock_t *write_pointer);
 

-- 
- Andrey


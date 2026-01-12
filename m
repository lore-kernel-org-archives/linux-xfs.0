Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5BCE2701CB
	for <linux-xfs@vger.kernel.org>; Mon, 12 Jan 2026 14:52:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768229532; cv=none; b=eDZ/4C5znAnymwqIuJY/rZ0qzj5yZLjYdc+ng3yLLHnF5rTlbTGhyWwmghuXl7StZTNiXwMoanYnpJtr8icAXUP6Ec8N6NYHuZ3uiRmPAKrm5r7+NBE0hLVx/rbWdv2xljYJBBKwQzbsesmS+a9WCaA2kpdoQIZuDROUKN/12BU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768229532; c=relaxed/simple;
	bh=w1I6PwvwzLsgyGpHJFKwtxkJvjQ0CES+ZFjhSTB9vDs=;
	h=From:Date:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uJK79kCecUYGEjtDJdIKHuzyotQrQ6D24U3jx8C/9QczoipVTLBqGA0kkckqonoe/+lwtWgZEgRHGKKMS4T8xupZkGpEWRY/62adXbXsLAcOG6CT4xSbV+kXNo1mPAR2OqWhWROhv9ifb2HIm+lL1ymdPA8G8ooVzK+q87CACeE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=X6PTjrGY; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=BPXjEGyO; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="X6PTjrGY";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="BPXjEGyO"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1768229529;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=rxT4TpIEnXfcR0i9Em+M35vPC8aSThrR47NkUhIyHDQ=;
	b=X6PTjrGY3JQQC+4/PeNjTjO4dcqlpP4segBEHWwzdMexTsahuca+uFdkfwofRjZsO5kSwl
	LisBnGz+7LilmdD+pO1YlFSVoQY+lYcgPWdeEJkrJS16NvsgGWd46wkdPDTFCF29m2XIuh
	20afI5XCdVYRRybxp0m5nSrFb/dTI7c=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-212-Bir4CvNzN0m-FohKJBqamg-1; Mon, 12 Jan 2026 09:52:03 -0500
X-MC-Unique: Bir4CvNzN0m-FohKJBqamg-1
X-Mimecast-MFC-AGG-ID: Bir4CvNzN0m-FohKJBqamg_1768229522
Received: by mail-ed1-f69.google.com with SMTP id 4fb4d7f45d1cf-64b4b64011dso10994411a12.2
        for <linux-xfs@vger.kernel.org>; Mon, 12 Jan 2026 06:52:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1768229522; x=1768834322; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=rxT4TpIEnXfcR0i9Em+M35vPC8aSThrR47NkUhIyHDQ=;
        b=BPXjEGyOgKjPUJJC2ZjtLpTvVAbHQf75kSpUnfCI25pSlE+Up/dP1i4a/PRRoRL70I
         tdFpU2sagKQI5fnCG2SQXA5d0RBSlkZ60JkerwyX6lBUhFIKKbv6WlAvNtCsk/MJPSab
         eu5plH71VivZkancdPOjCZNeGtWHco+OGoCJNK5WIZj6EQhU+9LfZ/17P9Q0uSh8Q63j
         bydlkXv2VKCohWodIM1CakCqFdThAMyRGDr9xepwbbcRnTU+U6rYtcTgl/a1yjL8Cxt0
         s1UJut0ueJxN6aayohDTZyEw9Bk431eGnt0nJYgiiN+NuDGW7uffGETQGHPaYgbvjaOS
         R9Ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768229522; x=1768834322;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rxT4TpIEnXfcR0i9Em+M35vPC8aSThrR47NkUhIyHDQ=;
        b=unOiOTpdzCTaRVbIn5W6JDyxxUkPNjpV9q037t5+oQCpyJCZcv9Mkk4fbLHTIwd0Qu
         hqj50vvCEMV4r7tOcIzWBLrnsmAVpIh3FcAWJpkoGqZrc3pOqfXle9A976ubI3uoi3zW
         7uqw/GAjr6WbtwymPf9jTEZfS6SpD3DiXH00i5phSax2Sg7CvlfRhjl+OMmDKYI8LJOl
         BWuJ/bkvTI2ZBnul2v6ZgwlbGBmGQud4rv6MfWPa8BPlCFT4sp0mGzSt2CVJmJ9GBvn1
         EART5H1cX2YSvabOXmuAFkN8c2jQT7RcLzSXqL6m/M1KH7iH2BFxAuIoGqVMFyK+QVWv
         B5qg==
X-Forwarded-Encrypted: i=1; AJvYcCWPk54qoXREYJ6tOH+KLpDaMNMj1SmP+V8GkOC8/tVbuOLfcBVDBS1393q96skJiTfPf26UnCIApOQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YxfZVsv+elWILBo4ysBowPw/7f9pKKO4XznBLK9mwOMgO9Ucxgf
	66LzXQLgpAnZKp1hpP+ifK0lCmKWB8acLZMTOXX+TviF5yy9zZQMSd5g8NwaAbKq6z0ZgiP0ZEb
	VCCVpu+hA3DW/MXjWbN2LKOf63mrLtbkHCgOm9xZseM75ybVTq1Hx8FiDBeqGrkBWZ7/h
X-Gm-Gg: AY/fxX6LDUy/oWfHng2i2YsOv+ToHUJNI2/I4zgOwH8dwi0QnQbgirKn1qjQP4iXFZG
	uVuYpgj0Eq1TQpVicXw4fSXPntR8pTgcLocxINCgZKNF8Hx3pfDtER4QWCqjt2ppaJdnRlAJ/Nq
	zUJ/2R9EOSSGWajy52oy6uhC2RM/yBimXWD11qcwlj7vOuKH1Z0jAtjyyVLvfK5uM+Xu7Jq93Xq
	s/arRWKN2OA24QdCsd0d7WrbGtq2jSMXV1bJnrhd65W1MtEf+SdW3iR3H3AmiBg7RHXe3Wc1cGk
	epQoI8kG0qvDZLdZeibA3sIZWpENSI0SYam1EausVMQ1fya3oJFndFSIVUUDCodcX0USs2L1
X-Received: by 2002:a05:6402:4309:b0:64d:65d:2315 with SMTP id 4fb4d7f45d1cf-65097e8e3b3mr17114482a12.30.1768229522142;
        Mon, 12 Jan 2026 06:52:02 -0800 (PST)
X-Google-Smtp-Source: AGHT+IF5HedpXYEVDgdb3na03m1dE9g5d9SGRCXlO36Bm8gCzP1H5KKM5v9HNGEWEFxIDCR45EpR/w==
X-Received: by 2002:a05:6402:4309:b0:64d:65d:2315 with SMTP id 4fb4d7f45d1cf-65097e8e3b3mr17114452a12.30.1768229521690;
        Mon, 12 Jan 2026 06:52:01 -0800 (PST)
Received: from thinky ([217.30.74.39])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6507b8c4048sm18254819a12.2.2026.01.12.06.52.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jan 2026 06:52:01 -0800 (PST)
From: "Darrick J. Wong" <aalbersh@redhat.com>
X-Google-Original-From: "Darrick J. Wong" <djwong@kernel.org>
Date: Mon, 12 Jan 2026 15:52:00 +0100
To: fsverity@lists.linux.dev, linux-xfs@vger.kernel.org, 
	ebiggers@kernel.org, linux-fsdevel@vger.kernel.org, aalbersh@kernel.org, 
	aalbersh@redhat.com, djwong@kernel.org
Cc: djwong@kernel.org, david@fromorbit.com, hch@lst.de
Subject: [PATCH v2 18/22] xfs: advertise fs-verity being available on
 filesystem
Message-ID: <n54xljh4z2vdvxsifux2hue2hnjixlw6jtq3azudreah3lt4de@en2vz44o4vz7>
References: <cover.1768229271.patch-series@thinky>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1768229271.patch-series@thinky>

Advertise that this filesystem supports fsverity.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Andrey Albershteyn <aalbersh@redhat.com>
Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
---
 fs/xfs/libxfs/xfs_fs.h | 1 +
 fs/xfs/libxfs/xfs_sb.c | 2 ++
 2 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
index b73458a7c2..3db9beb579 100644
--- a/fs/xfs/libxfs/xfs_fs.h
+++ b/fs/xfs/libxfs/xfs_fs.h
@@ -250,6 +250,7 @@
 #define XFS_FSOP_GEOM_FLAGS_PARENT	(1 << 25) /* linux parent pointers */
 #define XFS_FSOP_GEOM_FLAGS_METADIR	(1 << 26) /* metadata directories */
 #define XFS_FSOP_GEOM_FLAGS_ZONED	(1 << 27) /* zoned rt device */
+#define XFS_FSOP_GEOM_FLAGS_VERITY	(1 << 28) /* fs-verity */
 
 /*
  * Minimum and maximum sizes need for growth checks.
diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index 744bd8480b..fe400bffa5 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -1587,6 +1587,8 @@
 		geo->flags |= XFS_FSOP_GEOM_FLAGS_METADIR;
 	if (xfs_has_zoned(mp))
 		geo->flags |= XFS_FSOP_GEOM_FLAGS_ZONED;
+	if (xfs_has_verity(mp))
+		geo->flags |= XFS_FSOP_GEOM_FLAGS_VERITY;
 	geo->rtsectsize = sbp->sb_blocksize;
 	geo->dirblocksize = xfs_dir2_dirblock_bytes(sbp);
 

-- 
- Andrey


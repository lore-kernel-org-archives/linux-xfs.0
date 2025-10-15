Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3680E31A06A
	for <linux-xfs@vger.kernel.org>; Wed, 15 Oct 2025 09:55:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760522112; cv=none; b=W2HqEDjRfXFmx0Wrz/h69wV29ztR9fR/iEQi3FGGi0nGQIgyRSIFti4dmZxgLK1jaxGujRUc28si1MDxe0bblvHgn1iQ3FPI0Fj4lSOjNmPc8RZ9gDJOwdjaM0iHqZwE0asR2Mf0s7/cq3OE7NAnZKi/9u07X6ouGEzACUb1mrw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760522112; c=relaxed/simple;
	bh=X4Dmu8RsG6T2RVXHVaXxqEd9FkCz2aPR//2QDzOsAFA=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=Hqg708MqQ+BmD8vhQh8diLHLg3h3L6hbw7FkMQLAiL2ZFGyRar5LXldTsKDWFDJKH0JFyM4623bT87lmpxcOWydTv+jGkwdoCgrHaI2Uy9ncu6gckNv16aruR8HXCCGop3f4prSBQcogyHlpJtp1S3QPM6aXJcYcyZ0jbYc4TzQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=icu05SMP; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="icu05SMP"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1760522110;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=1+9h3z1XLSExggfKk5yie+TyUZjwmwY8w3pzjremY+Q=;
	b=icu05SMPRy6NLKOqWf5wSsorYWDMNmYo4uvusRkIPfnGSZJmlIaU0vkY6ykpXpUvvL4Zdo
	P8vKnxoBlFzlrWUg/k4kEqp7Be7STc1c8vXbJlVSl4DUqmZQKSWbgFakhmEtwAbiPXnMb1
	ztoz/3Kl68hVaT/RpgsR0EXMybsjm+U=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-492-ZU7mjPCxPVCZ2ouXEgZqPQ-1; Wed, 15 Oct 2025 05:55:08 -0400
X-MC-Unique: ZU7mjPCxPVCZ2ouXEgZqPQ-1
X-Mimecast-MFC-AGG-ID: ZU7mjPCxPVCZ2ouXEgZqPQ_1760522107
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-3f6b44ab789so4047405f8f.3
        for <linux-xfs@vger.kernel.org>; Wed, 15 Oct 2025 02:55:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760522107; x=1761126907;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1+9h3z1XLSExggfKk5yie+TyUZjwmwY8w3pzjremY+Q=;
        b=qrYSnFP4n7XSSJ1KTN6P3kCzSxJsHy3N73bYOuL6dIoYOxtWuWyHxR3LiWpcJYlcpv
         rmaWGo06U61rIwtS/H2jKgY75eX57R/mKYdZsJxju4LUhUsipFqS5hzL0Tu7FOK58C9s
         7B17xKE9s4arfoXInwowaK0zwFTwyA8opaUu/Y89GD/sipq1OdhQksXHm+WVHyxvgkx2
         IHHTUVHWEKnQEf4ZmStGmj+Wj2VtSrXR9t1iIwRVSX3eE3tPeYv09uiroJToctu2+alj
         M+MPZBpcVIMCylZBvnHisPKT0tiVRl25EXM6evOy6LWEJtMfaze5OIzAGlbs/MUfER/q
         LXFA==
X-Gm-Message-State: AOJu0YyB+QwSfueDgaXY9oqytEpzpcdXqq6iTW+p+c++QNZtKRljmDKF
	Lx42QP0yyWLV0ykTmTZ3IygtZLscx5AZrb2Mnt8j01kQ7BgaQfp2lJXHefzzpLgaMvigJbl8yTU
	t1KQngWXcvHmO06cImJUWENJjr5Q/eypCnmUdXFpw4eQAvo92vWSgYgkcI0CVJ41JtrBKIr5Zm9
	ZtH/rQJAsDcXaYH4xTzT1jbSiugW2EcRZNPPyc/OnxTpmw
X-Gm-Gg: ASbGnctnQBbJOom2hYbm7ZluNUhTvkSMUV0s4ej6xdW4L6w2pzmEZLWu+2tsLRWWtq/
	hYEwBsJ7p9mFtQtdt66K6xwzjJ9JYMp+fQRF0j0CEfJ2npZ81bOuhPamZ/0B8Qk/fHbWLqiEshM
	dDZTvcEfDMQSuXxhAmpXf5wy2p4il+jTeU3NfydeWGQf4NqmrNcDoiTxUSDndXlbuEAIYdAD1Yy
	PSxnKUVgIEWaTqrhs7g07hnp19su9iKVMAKyMYNX9pZY9hdust/4VT7FW440yLDAzhkbXPGss61
	cCSy/HZYgPN+HWUrUQeq/O3Fu8svCTbGeynl+Taa3Mj/n4QJu9WIjXokvzIJ
X-Received: by 2002:a05:6000:25c3:b0:3ec:e276:f3d5 with SMTP id ffacd0b85a97d-4266e8dabeamr18543957f8f.42.1760522106979;
        Wed, 15 Oct 2025 02:55:06 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHTDRgbXXzXKusokNIdCBz3sdQcESLWmduNxzCipe4gvOikFJa4ONLeQBv6jjnVvVRTIZsmRg==
X-Received: by 2002:a05:6000:25c3:b0:3ec:e276:f3d5 with SMTP id ffacd0b85a97d-4266e8dabeamr18543922f8f.42.1760522106336;
        Wed, 15 Oct 2025 02:55:06 -0700 (PDT)
Received: from thinky (ip-217-030-074-039.aim-net.cz. [217.30.74.39])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-426ec3ab5f7sm9549315f8f.43.2025.10.15.02.55.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Oct 2025 02:55:06 -0700 (PDT)
Date: Wed, 15 Oct 2025 11:55:05 +0200
From: Andrey Albershteyn <aalbersh@redhat.com>
To: linux-xfs@vger.kernel.org
Cc: aalbersh@kernel.org, djwong@kernel.org, iustin@debian.org, 
	linux-xfs@vger.kernel.org
Subject: [ANNOUNCE] xfsprogs: for-next updated to 15fd6fc686d5
Message-ID: <rqiscksagn3yqj42dhtldkiohg7pds7lytnvbgwdmqwji6yqvg@nwdtib4j2zuq>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi folks,

The xfsprogs for-next branch in repository at:

	git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git

has just been updated.

Patches often get missed, so if your outstanding patches are properly reviewed
on the list and not included in this update, please let me know.

The for-next branch has also been updated to match the state of master.

The new head of the for-next branch is commit:

15fd6fc686d5ce7640e46d44f6fa018413ce1b64

New commits:

Darrick J. Wong (1):
      [15fd6fc686d5] xfs_scrub_fail: reduce security lockdowns to avoid postfix problems

Code Diffstat:

 scrub/xfs_scrub_fail@.service.in | 57 +++-------------------------------------
 1 file changed, 3 insertions(+), 54 deletions(-)

-- 
- Andrey


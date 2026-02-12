Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5257E29D289
	for <linux-xfs@vger.kernel.org>; Thu, 12 Feb 2026 08:41:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770885661; cv=none; b=Z6lKVmpVru4K8TIAWd8bZDNKsnWSpnmdzXPkkeyig3voTpiC4rWVH0ctPkMJBlpgZAqM2FV666cP7KDrvChC0sI5J8kJhzRAn9xzK+im9COqgLfP4XodxEBG/Vwp+9ctMWe7T4k2dm/HMUCpKevropY+w4XlyTSo68gYMDaFFr4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770885661; c=relaxed/simple;
	bh=cl938Ti4asykzJQfcH9dcu74Ycfktb4FZovTLe3ueao=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OM6FMHGOglax2Ne7QopHR5fkRl53dIuI7SLThU46O81FpJu1EVwI9/GJUQtMRJ4Pyoy+JD8REy+pREH4K0DS+WAH9LRKl76rzX9qhN4RJLHAmrLOieSTMSYta8YwFLe46mQDeCe577DyiESc7eWANFuXavgSS1Sm3Pp81f2rCL0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=PnLJVFeU; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=bu5FSjOi; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PnLJVFeU";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="bu5FSjOi"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1770885659;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=JL7NTSnX4xVSvnxCNOmwrKaXtUHlYFRCmkMorjX+mX4=;
	b=PnLJVFeUEzcqNJXyzJAOUy4nBLmdgMmybrjrghf892DAphLkYMd1XOjveRsG2JskLJT+sD
	5GWH+sDcRlOV9KF79AAJ1G9DroLBAmEgDAWKiVRPyFWsm03Ej+KQelgk0FdPShHEpT1akh
	XcrG8IZgskCZV2BPqUwPx0eYWMbthaE=
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com
 [209.85.214.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-484-4qcEPjjfMn-ofaz7YC9EHg-1; Thu, 12 Feb 2026 03:40:57 -0500
X-MC-Unique: 4qcEPjjfMn-ofaz7YC9EHg-1
X-Mimecast-MFC-AGG-ID: 4qcEPjjfMn-ofaz7YC9EHg_1770885657
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-2a943e214daso193908745ad.3
        for <linux-xfs@vger.kernel.org>; Thu, 12 Feb 2026 00:40:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1770885656; x=1771490456; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=JL7NTSnX4xVSvnxCNOmwrKaXtUHlYFRCmkMorjX+mX4=;
        b=bu5FSjOiUj99GO6dPtW8BuTAPaM8b7i4+uiRbFDZ9sSY1/9q2mR91QrA1giZmRsB+h
         azW7kviqd0COCBzFy8JPmcZabcSXgM4UqyRrguXTXBi+5CsVUuBpehhETLg5KwUX0n0O
         HFFoY5zScfqSbtf0BSs8dA4BsbDfA/zA6diml/WETkidpynYoxDh4KhoU1mrnYvEi7Tu
         atJysZkqQfAdStuJuEZGTMq7hy0lXapuDmDvr/MlNxuaQAKzpFQsK16LwvcBHi9MiLjp
         kreGKg9j5MZqyd603VOSDN9oR14uYWyCwUAfbc8C6oLL46FadmmaM/GPxoKZ8QSVoHUm
         LW/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770885656; x=1771490456;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JL7NTSnX4xVSvnxCNOmwrKaXtUHlYFRCmkMorjX+mX4=;
        b=ENqjvFPbMALi/vZGg2OhdhEklaDyp7nhPwTowvTwhx9Lx7sV3wRU7BzVGPcO0iGiA8
         y/LTT9EkkUcPIbu+GAEvWpDavJebZDW0R5qzfMwyfMMkx3KKMdy6sveYgEZz53A7OcQS
         XFzasGORVzDFXYeaT74d0/AnJRQiBnU1pP+eJypXkDLswjUOIE9PT+Yn5UiIS2Fdp0u8
         pzGv2SnoiSRZoVhCCnES1dJI3eP/TQ5HRKJ6AnH++XdzTdr7qcznkmsDEXnf+QhRKkMl
         pc7zq30nJ5Cza5QLKnqdtVylCpDYPAga/GjCO+0XoqnsVYRlEak8W8FAarJRyfb8L+PS
         Qa8g==
X-Forwarded-Encrypted: i=1; AJvYcCVSGKE9codkVXuGpV1tnI/Xl7ZyU+hqfQb3xybDW/tTNBOczWIPY6rCYhP96vH6EzyvrUtW1jG4RnA=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzs+y8mUzz4xk30W5B184UwxQ9gdG8MueThLozsvYwztG3RO+CC
	0mnFyRELTk27OfA0np7rmqt83O14HLZP/LA3seOnLO8LiYs9SVKkTy0ffLD+wYqX1cHDfm0Rgt0
	HwyF6Z+I7bof6TFSzH8hD38Rw9ncx6PdhTw+0dfXHspi7nE1eYCLF5jonwlUsKDywWUBk6g==
X-Gm-Gg: AZuq6aItYFIHVR+/iWz4RAxgSWNAo3ntMYvjm2xY9kLbVqzfFDD7AWU8bbqSjleat/T
	QD6yuq+DdLwWMb7Kbj0AUzHQKnhq5wp31lK+T9u7jddsfXptJxn/viOmJtq07QyEWXHxCI/61ue
	1l49OWIrLkUsDOXZhT2PD5yQI/Mbp2qSPjPRl3R8jPFHpYa36Dp7L2CMPjPROvTNdvutaQZgcgm
	mV9KTsAOrE7WsFEZz8we3hW8kg+1EBWmse+T/4MdtJJLyC7FYsJq8Ipj7ZuYe7XtDJV+8XTNsVd
	xJANf5Ve3cIb2qLTSVLX+OepAXVDKPy4Gm+O2v/eJFGD4vJoj+fFqNeau5fSZMKbW+5rLn02DJ/
	CM5SFi8CoGdKEgicFpQX+Kktcqy2ZUqNp7J1JUea7dkl4FNuzggo5oFUgsqV2Uw==
X-Received: by 2002:a17:902:ef45:b0:2a8:2c4a:3570 with SMTP id d9443c01a7336-2ab39b12efcmr18314285ad.49.1770885656189;
        Thu, 12 Feb 2026 00:40:56 -0800 (PST)
X-Received: by 2002:a17:902:ef45:b0:2a8:2c4a:3570 with SMTP id d9443c01a7336-2ab39b12efcmr18313965ad.49.1770885655690;
        Thu, 12 Feb 2026 00:40:55 -0800 (PST)
Received: from dell-per750-06-vm-08.rhts.eng.pek2.redhat.com ([209.132.188.88])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ab29965c27sm69782145ad.57.2026.02.12.00.40.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Feb 2026 00:40:55 -0800 (PST)
Date: Thu, 12 Feb 2026 16:40:50 +0800
From: Zorro Lang <zlang@redhat.com>
To: Jan Kara <jack@suse.cz>
Cc: fstests@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 0/4] Avoid failing shutdown tests without a journal
Message-ID: <20260212084050.uim52ck6zhffd5kl@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
References: <20260210111707.17132-1-jack@suse.cz>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260210111707.17132-1-jack@suse.cz>

On Tue, Feb 10, 2026 at 12:20:17PM +0100, Jan Kara wrote:
> Hello,
> 
> this patch series adds requirement for metadata journalling to couple
> of tests using filesystem shutdown. After shutdown a filesystem without
> a journal is not guaranteed to be consistent and thus tests often fail.

Hi Jan,

This patchset makes sense to me, thanks for fixing them :)

Since you brought this up, I just tried to check all cases using _require_scratch_shutdown
but lack _require_metadata_journaling, I got this:

$ for f in `grep -rsnl _require_scratch_shutdown tests/`;do grep -q _require_metadata_journaling $f || echo $f;done
tests/ext4/051       <=== fixed by this patchset
tests/generic/050
tests/generic/461
tests/generic/474
tests/generic/536
tests/generic/599
tests/generic/622
tests/generic/635    <=== fixed by this patchset
tests/generic/646    <=== fixed by this patchset
tests/generic/705    <=== fixed by this patchset
tests/generic/722
tests/generic/730
tests/generic/737
tests/generic/775
tests/generic/778
tests/overlay/078
tests/overlay/087
tests/xfs/270
tests/xfs/546

g/050 tests ro mount, so it might not need _require_metadata_journaling.
g/461 doesn't care the fs consistency, so ignore it too.
g/730 looks like doesn't need _require_metadata_journaling.
overlay/087 looks like can ignore _require_metadata_journaling.

Others, include g/474, g/536, g/599, g/622, g/722, g/737, g/775, g/778, overlay/078
look like all need a journal fs.

About x/270 and x/546, if we don't suppose other fs would like to run
xfs cases, then xfs always support journal.

I initially considered calling _require_metadata_journaling directly inside
_require_scratch_shutdown. However, I decided against it because some cases might
only need the shutdown ioctl and don't strictly require a journal.

Does these make sense to you?

Thanks,
Zorro

> 
> 							Honza
> 


Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.222.170
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794504790;
	b=gZbxq9kTXrfBeHtN7m2QgpWifqED9TcJ8wI0nQeV4QngRJR+N7xbbIdQqBShsv5wLLhn
	 Q1CiKLUnBBGsKhCjR8vm4z6jrjy8EBziP+UtZYp/YpqzrjfHlloSVRvqaff4sG9E17Hov
	 IB8awR8QsAFRVucJWNH1ZP3OTMDMyHQMxBglCnKq6nYlmSwvp7ob1H2kil+5E0qVCuV5o
	 G+GBktng9OMu/bNJMdW17m/z0tNWHLMbnWoIp4RDTXMep2hNBAtvZyuZoAX4UwYYCXFK1
	 fKIRDQx6mrKz1jNByzsF9nVl6a5gI7ssSkuTD5FJbnWGBfF6ApwlXGNby60egehK/Jg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794504790;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=5eyhuI7FzhekfX+xV3Iq1NylLu+7L5LKRe2f31Y/j3M=;
	b=SCADyIdtMc2R5RJ9zBeBS+TA/RBO4F98Cf5YkXZPeTXevylOnt7l2ag78r0csJaStkFT
	 DeM4Hto8BbutggITjeZlduTr+trIl2ACBKkTaK0A8q3dPqtHYAAzHhOptRtc7dme1QesY
	 dAvPyEgF0MJLqUizpR8acXrNd+6Cl4VpfyPfPqcu2V6amtaRjrDYJ6j0rL4Tj78GALXTm
	 MTbzeqXvZxURXgqf8T7sJzHzmgWYEKh/gCcnbXb62y+E6HXFY5UR21klL/agOpHIejXXq
	 gsB0H+wf8J5dkD4h7VPXn1ak7z24mnNmszF25pgfzm7PQnkHAjGUX4Fy73Sc54ccIhg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=cs.unc.edu;
	spf=pass smtp.mailfrom=cs.unc.edu;
	dkim=pass header.d=cs.unc.edu header.i=@cs.unc.edu header.a=rsa-sha256 header.s=google header.b=gOc9aebS;
	arc=none smtp.remote-ip=209.85.222.170
Received: from mail-qk1-f170.google.com (mail-qk1-f170.google.com [209.85.222.170])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78ECD606A889
	for <linux-xfs@vger.kernel.org>; Thu, 12 Nov 2026 17:33:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 78ECD606A889
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=cs.unc.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cs.unc.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=cs.unc.edu header.i=@cs.unc.edu header.a=rsa-sha256 header.s=google header.b=gOc9aebS
Received: by mail-qk1-f170.google.com with SMTP id af79cd13be357-945e6d9ceeaso387838985a.0
        for <linux-xfs@vger.kernel.org>; Thu, 12 Nov 2026 09:33:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cs.unc.edu; s=google; t=1794504788; x=1795109588; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=5eyhuI7FzhekfX+xV3Iq1NylLu+7L5LKRe2f31Y/j3M=;
        b=gOc9aebS94R9Z2z+F3JlD4FtBL5rSRjWPa3k3fS/+u01SyRKfF4MunWEzfG1FfevNY
         Pp+IZHc7ma9YY0rw3vCJ5oXDvLLe2D+WwydDoSqvl7SS8V359Es1jbMKaI9LMEaBm1LD
         C4DVjsq/r033GO2WkLkhphgIS66X/RaSCerVaysfSaai3cY3LRkGPIezK0bv9sBXsHBe
         afX3tk/586JF/SAWCfG4GuL793vMJUqooU9wAzE/5OhBA8mh2pQzufuYgCzO0EbG4iRz
         Wv+Ml06U9XqNKWd1c8FNP6rmP01wwppYcfqcNjOeVklswe3kBesjPWFbivGKGSBCBBS/
         2qnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794504788; x=1795109588;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=5eyhuI7FzhekfX+xV3Iq1NylLu+7L5LKRe2f31Y/j3M=;
        b=JMisE9T2YAlpNFIMMCM/riG+f6ReR0r+gQjokrFAQL6LL0/Y8DG62Jv/K7mY7HNR08
         PhfYA0ffvqZp2lTI1tISzwBUzej6ShnN0CzPaBj85AFBVFpi7NCl6b2Qxf4bSJAA/S6s
         LaLDLxHorr8aIeYgicxLhG13/skxJyn+TG6XqboWqxjB43AEhgDDo7o7+54WN83od9Ey
         vvW9pKqOjMd6o24YS/FhufZ1WH8XYmw+IP4xD5BPgi3m4Qha4xLzfHQKisaS9NhKXCFN
         I/RI+ol0KX96fFaiq5AErxBBl6VbgRvL5/o09Lwwp555MbQ+3BeAJKgfsWrB1mp/8+5B
         4hzw==
X-Forwarded-Encrypted: i=1; AL+hErGcAg+ZUXD452oyYx2Ra2UZnbieUK2LRan8tifM0usDtQaYHjKidpGM5+LlVcGAVeYLwliib8aWzqQ=@vger.kernel.org
X-Gm-Message-State: APuU4Z+6EWeFfRceDynvXOnq1XkILnmoRyaW2nXd2lW+SVbamI9BSWkp
	vgXL8zATsDGsJnua4TGHg3lWxPItBIvWMXNv0q8r9j6zqTSurKjNjq5urhKrjOL6KQ==
X-Gm-Gg: AYBFou36F8jztw7VnisfBe8+SyoOM2xKV00rGEoFLLSuaP+FtJLU05W0F5AWWb4OGta
	KXGlNqweiJmrRY6BUQFN5YynF7vvhZ+Ji5dt2gGB91Kc+rDH6wvV6vUCGs2QXV1bdqkLuy1ffYp
	nNoHPb2IqLA/YGX3vKHMZzWRsFQBvsF0FTcGeNnrO/He6M/DQ1DKLK+sYbjV7NkjERavQ4R4nTQ
	VpzRsTjzgAmAUS6fiYG1NXcMeDuac6ATIs4fWYi4aw+D84O0n6QV6eJ9fJ8TjkjEpNfEGD/6gwG
	lYT3AVFtBUSHPsEeKi6XGjI5MlMAO8u92js7J04K2SOQmiNfkJ/11KqCf9Deoz4K3stG83nrtS4
	9Ykk8rAfXG5NKVzhJtU8yuDG4wHuwK+uGXju1hOqddWyykk8YwwSo+VMWuS+0+xJ3tkOGbp245n
	xbChtVco7j2MTem0T2KPIRKgsTNMYomSUDuIgI5ca+PE2/pPddaACKOrohPTkKtu73EiQupgu5h
	5GfQPTYdsVFpqU8qAQ26NOuitEK7C4LatS2Q4vddnUVZtAQfm7CFZMq3tg00VvqcMQ6Yt26f4ym
	KIPy6oBIGRYD0/gwxhEhZX0fJ5gnZlSoSAW6RL3XI/4z9z8eMNoO
X-Received: by 2002:a05:620a:4048:b0:93e:7192:191c with SMTP id af79cd13be357-9494bb97d00mr12510885a.17.1794504788307;
        Thu, 12 Nov 2026 09:33:08 -0800 (PST)
Received: from cobra01.cs.unc.edu (cobra01.cs.unc.edu. [152.2.130.143])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-9479e73a65fsm767293285a.12.2026.11.12.09.33.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Nov 2026 09:33:08 -0800 (PST)
From: Hengyu Liang <hengyul@cs.unc.edu>
To: Christoph Hellwig <hch@lst.de>
Cc: fstests@vger.kernel.org,
	Zorro Lang <zlang@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Carlos Maiolino <cem@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: test that statfs does not report negative free blocks
Date: Thu, 12 Nov 2026 12:33:03 -0500
Message-ID: <20261112173303.979651-1-hengyul@cs.unc.edu>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261112155331.GA32171@lst.de>
References: <20261112155331.GA32171@lst.de>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Thu, Nov 12, 2026 at 04:53:31PM +0100, Christoph Hellwig wrote:
> On Thu, Nov 12, 2026 at 10:49:17AM -0500, Hengyu Liang wrote:
> > +# Only the data device counters are checked.
> > +_disable_scratch_realtime
> > +
> > +_scratch_mkfs >> $seqres.full 2>&1
> > +_scratch_mount
> > +_require_xfs_scratch_non_zoned
> 
> Why do you need _require_xfs_scratch_non_zoned?  If this test is always
> working on the data volume due to disable_scratch_realtime above,
> a zoned vs non-zoned RT volume shouldn't matter unless I'm missing
> something.

I copied it from xfs/306. _disable_scratch_realtime only unsets
SCRATCH_RTDEV and removes "-r zoned=1" from MKFS_OPTIONS. When
SCRATCH_DEV itself is a zoned device, mkfs still creates an internal
zoned RT section, and the root directory has rtinherit set, so the
files are created on the RT section. I tried this on a zoned null_blk
device without the check: all the fallocate calls fail with EOPNOTSUPP,
statfs on the mount point reports the RT counters, and the test fails
with and without the fix.

> Otherwise this looks good to me, thanks a lot!

Thanks for the review!

Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20F682853F8
	for <linux-xfs@vger.kernel.org>; Wed, 15 Apr 2026 14:14:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776262488; cv=none; b=p6AYKcZ2sziTVLoNM/DqSGPQi+dyLQ1BqrHDgAKtFeEmDVHRNMNzt6+L/WTgLKQlIX/hk6DA3zfxJ/+dq9RaOg/EgdyfW9qyDmeDNdwnz0BtS73UzlzEmNuftfqTBnLJZ6QeY2h61Vw9auQ7UEuQ/AtNI48Su1hrnlrXj6Vjqsk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776262488; c=relaxed/simple;
	bh=oh2ZaD0YVIXH6z71ONW01jAr7uKpA09o3YgGZotFJA0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=n1oaVJTE0wo0c/uIhDiYp0oqQ/c1G498sRTMVzi54JYrd/puqL6o4zfpfesATdMgk/gi45JFqiqTE0w8ev4YDF06W2/VuD7nF3ypL/QJcAjd1N/7G8UtC1tvkwH+4bYgkyx6VAo30aLWablu14pO7EFTqJz3nV2lLbp7Uyv+NKw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=GFfWK4xz; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=ZbunACQO; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GFfWK4xz";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZbunACQO"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1776262486;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7KRtbM5vRtC+90vFJ9CK7bzztdcwxjyK64to/dX/3L8=;
	b=GFfWK4xzR+pj2vyyRkA9jQQT+I/nAN3Scycuhhpsxrpu5dPMhABU/2U04J2TiwgWSV1bP8
	yWxqPRaJRHQa7YqwPBU0NaK/Q1O8vkvI+hiiuY9Me2hi4wwCVNTZ8ltveqeoT+dsInRCnE
	rclrgyC3ieng8qNPk1vmsm41klv3APA=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-608-bAtWOtAFMRSIkI7Nsv4p_g-1; Wed, 15 Apr 2026 10:14:42 -0400
X-MC-Unique: bAtWOtAFMRSIkI7Nsv4p_g-1
X-Mimecast-MFC-AGG-ID: bAtWOtAFMRSIkI7Nsv4p_g_1776262481
Received: by mail-qk1-f197.google.com with SMTP id af79cd13be357-8d65190e52fso1408563285a.1
        for <linux-xfs@vger.kernel.org>; Wed, 15 Apr 2026 07:14:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1776262481; x=1776867281; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:reply-to:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=7KRtbM5vRtC+90vFJ9CK7bzztdcwxjyK64to/dX/3L8=;
        b=ZbunACQOfOMSjEzO6D/+YjdvPrS7HAcLgB98mMnIxmmnInA1l+PJzSmxcWCgnKr8dh
         acl+aOjnl2r8uC3zOdQ4IcxzmpJuIX9KkyWjqW0Ah8sqO2xM2CEs7I0f6W5Q+7GxcIk0
         t0y+LQ1eGIT1rKij+0IxdriK1mmqxORC0y7AxIv+OXXDQ78yDcwOw6HBbJdM/n8oqubn
         FfOQOVSao6U7ri3wyGiXYOuRsr9b2pw8RPW6d9838iLdHj26FZ37yQIphweGSAO1kotb
         JS05f0g+7DmANkyz72v/MdIEejwNUF590atBnoZ7Rjq/R29IHTYMN409CCog/SX1VU2/
         zqwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776262481; x=1776867281;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7KRtbM5vRtC+90vFJ9CK7bzztdcwxjyK64to/dX/3L8=;
        b=mTXU5KmqCHgJAzyW3Q1D1F/nY/x1Q7+RG/Pd34kJmy6ZDDc2NXeokSU5ezhKtrYINg
         DqcMJSFSS0sMlM34kV2hOXhE6r6pf9q7jrR4NnkAg6Poyv/D6VqSPdi8u/XFsbW7/eOs
         rT0qUfps/4mPB/6DNGRwC50mOS8u/aYqsq9+UxgcaF1/lzoRJKQKv3N6QbNngFe1McSY
         IS9EVueiOx7M6GPfiyUxVg56TuhFUBWfJ5pI527JDC03kYqpi1L3aMkPi8rboZDnp2I5
         pipwwegGNGucVxJMTOnrnjlHWZ+IquymDInUyzoe3oNkh/PB8gxig0dSEtzzVYjunB9K
         Yz6g==
X-Gm-Message-State: AOJu0YycyOhf0bNHkGrZ2QH3TqGoWvj2/OxSd2XZ80BqcChowf0oP4o+
	vZp2PnCC8H+Tx1FBtTs4U+gerEfCx95LMm4PbiUL0c4uPEnH2IAUHARij92lCQBr6yaOhdLInpg
	hXx2WsTbmyvg25fPUck0ahyrVRPchCmpjnnBbn2FgS+tvuF9eArCXieEL4jpdd9HBGX59z9Dt
X-Gm-Gg: AeBDiesTj7xSqcJNDg9y5TOjw/5ZxsrXkiU46p+2pQbhVkYDLfPktT8CyK15JIIVtKI
	CXyQosesVNjS9Oo9XnfmqShizSKo+GgKCLMVt+zs5mM2kBerQrGHlW4tUT8Sh1AFF/DlQymYrUu
	IuU3W2bXiMWE8hdLAP0zCttWGqjms7NRI98Yx33gXBdZV3hYWsRsptSVJ0K402CAZxIsSS9YJ7N
	AK9aLHhktYoX6Sh7RdCcFPv22o2V19iCscJzWuNx28bOTbI2ctmmLzzgmAm53UNJhtAqY1do5yo
	cknb8tpgBwfCZLUnU74zvoLr14WDy76JtQ7blx8rAvNXuxl31h2FxDac16mS74pVZRNk7zT7Jkr
	+tjmEndb+WGpRJLmQyU92dje5aSGcf7Le63gAMV2lC7jrN9wgnHgGjIKthCd479zlYlnEjqvc
X-Received: by 2002:a05:620a:29cd:b0:8cd:982d:411d with SMTP id af79cd13be357-8ddcf6b6995mr3111045285a.52.1776262481275;
        Wed, 15 Apr 2026 07:14:41 -0700 (PDT)
X-Received: by 2002:a05:620a:29cd:b0:8cd:982d:411d with SMTP id af79cd13be357-8ddcf6b6995mr3111037185a.52.1776262480611;
        Wed, 15 Apr 2026 07:14:40 -0700 (PDT)
Received: from [10.0.0.83] (97-127-66-40.mpls.qwest.net. [97.127.66.40])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8e4f31f95f9sm143932085a.43.2026.04.15.07.14.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Apr 2026 07:14:39 -0700 (PDT)
Message-ID: <dc04b435-88c6-4b7e-802a-59734afe3184@redhat.com>
Date: Wed, 15 Apr 2026 09:14:38 -0500
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: sandeen@redhat.com
Subject: Re: [PATCH] xfs: flush delalloc blocks on ENOSPC when creating
 symlinks
To: Ravi Singh <ravising@redhat.com>, Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 djwong@kernel.org, dchinner@redhat.com, cem@kernel.org
References: <20260415071657.23412-1-ravising@redhat.com>
 <ad88TluB4FIP3yJV@infradead.org>
 <CAF-d4OvKZOsez5589KUYTjRz05PQHCQ-uRkXu-3iaO3tOjcavA@mail.gmail.com>
Content-Language: en-US
From: Eric Sandeen <esandeen@redhat.com>
In-Reply-To: <CAF-d4OvKZOsez5589KUYTjRz05PQHCQ-uRkXu-3iaO3tOjcavA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 4/15/26 8:24 AM, Ravi Singh wrote:
> On Wed, Apr 15, 2026 at 12:51 PM Christoph Hellwig <hch@infradead.org> wrote:
>>
>> On Wed, Apr 15, 2026 at 07:16:57AM +0000, Ravi Singh wrote:
>>> When creating symlinks on a nearly-full XFS filesystem,
>>> xfs_symlink() fails with ENOSPC even though space could be
>>> reclaimed from speculative preallocations. xfs_create() already
>>> handles this by flushing outstanding delalloc blocks via
>>> xfs_flush_inodes() and retrying the transaction allocation, but
>>> xfs_symlink() returns the error immediately.
>>>
>>> Add the same ENOSPC flush+retry logic to xfs_symlink() so that
>>> symlink creation behaves consistently with file creation.
>>
>> While we're at it - do we also want it for tempfiles and scrub?
>> i.e., should we move this logic into xfs_trans_alloc_icreate,
>> similar to the quota logic?
>>
> tmpfiles and scrub tempfiles are created without
> directory entries, so they don't need a new directory block
> allocation and don't hit this ENOSPC path.
> 
> As for moving the logic into xfs_trans_alloc_icreate(),
> xfs_flush_inodes() is a heavier operation (sync_inodes_sb).
> Pushing it down into xfs_trans_alloc_icreate() would make every
> caller pay for that flush, including paths that don't need it.
> 
> I think keeping it in the callers that actually need it
> (xfs_create and xfs_symlink) is the right scope.

I think that's correct. I had looked at this and came to the same
conclusions after also thinking i.e. tmpfiles needed the same
treatment, couldn't reproduce it, then realized it's because it's
directory block allocation that needs the freed up space, something
tmpfiles don't require.

Thanks,
-Eric


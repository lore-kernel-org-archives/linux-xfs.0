Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6264153800
	for <linux-xfs@vger.kernel.org>; Wed, 19 Jun 2024 15:50:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718812221; cv=none; b=X9sQhHOKwLgXKiDcERJPiCmsB/fKpfd+IC2VxjTYc8ck35KxuLylwhctlFFb39Q1VUTQPsgCYJRV+WwZ74ddXtLPTJle0/cwLUcSUONX7tgYFMEYdSG6t7BQ4/HzfTN35Cks0EX1UTJS7f/qNPT/Yw5FakVY75er3fu0wYE1wzc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718812221; c=relaxed/simple;
	bh=VATKY4ntOy3UVNzrBLOPMij9tR5+YFoj764LQzVn1ls=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=nNLshtKnVl7JRwlEz9Zn8M+3nJoJR7iRiQVsv83iwLzGyN7l7GPOvy69bM/YzIe5VLJNo3/sIHqwB6dWwQyC2len/B8kgYy5O8+HKDjzIFN10uiWavnI4GF5aM6TqKeIw51+c15YCzrSFcjFVXaBv1xvS/f1k0XLAt8qd3/2MK4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=FMPefbQd; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FMPefbQd"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1718812218;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Bca52+KHJpYXad3d6s5t9DXJS072JLebI7oVilD5KVE=;
	b=FMPefbQdSW6NMihYT5SfPxlB/LhWUgNS8i79HhVCET9BnqRFu/atgr0talHuUEm6w5OEc8
	4vYwxPgRMsjHuTR+L+nPrPAJtyk/yFF0wILXteRIWjy3ZRfupg9EodfrLwbfn0gt+9PorC
	A0nBoZbKNxjeR5LooHOCyJg4+Sc1YgA=
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com
 [209.85.166.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-547-Ry7Hf8JsObeKrZUL5XImxQ-1; Wed, 19 Jun 2024 11:50:17 -0400
X-MC-Unique: Ry7Hf8JsObeKrZUL5XImxQ-1
Received: by mail-il1-f199.google.com with SMTP id e9e14a558f8ab-375df29cb12so66816895ab.2
        for <linux-xfs@vger.kernel.org>; Wed, 19 Jun 2024 08:50:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718812216; x=1719417016;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Bca52+KHJpYXad3d6s5t9DXJS072JLebI7oVilD5KVE=;
        b=nRoCh92IWz8FDFKW8AoSbgsQmdk4cnLfzvfbTvdjYI+3SZPSWwDMY57RG/oRSy6YFH
         uN2/bfDuFqatrneLARgKjotvwIRGatb9x+00oyxwDPBILI/iDgzM2GXyuxBEHi6SM5SI
         lOC9Q9p/dfptAThEsREM3z6x1e8brB7q/trY1oDdhpfraX+5nK6oasLOub7HLee1F2kd
         OUqmcz0o2/Pa7qLsLGtkQm38H38duvivgwtaVhrx96KVkUX9hff+Qcf3BxhAKxuwbx8e
         xRpOtb8iqDQKqCMxecRkkALKehecw0pv2xRbSZO+ys7Wi9TZQ3henmTmnncHa3r0VgsY
         yfAw==
X-Forwarded-Encrypted: i=1; AJvYcCXchixuGqu1mlZ+uVVNdD3jsTOPtqU8j/tUbqGrCpc1KJY43bvsl6VBZBXcz0sLiDU4nspPOh7HOwDVVCcmBOJT0WhKwqGKMH1S
X-Gm-Message-State: AOJu0YyCnu5NtZkxGwOt+gNbhE2KbCs4pv+MBIuRiam3giFSCuFDN5TV
	ZIE/csDzaU6J1vVSGMFzYwNYSg0LaFsvifX+4d2AFfnsS0bwY0He1KfVlvXIgQLRF6kPIQsAyVw
	ZrItoDDZ4kSgWzOcQN79HBtEcusoHAJwnZgsWfobccal8APKsYE0NOh95Eg==
X-Received: by 2002:a05:6e02:1a09:b0:375:c473:4a78 with SMTP id e9e14a558f8ab-3761d6f1e8bmr29238065ab.23.1718812216452;
        Wed, 19 Jun 2024 08:50:16 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEWU+e/0QED9sYApsPJcJHWfCz30zKTwOAJIMKvSPRsQmg91cgdYoAtJuz30ijOikL77Qcnyw==
X-Received: by 2002:a05:6e02:1a09:b0:375:c473:4a78 with SMTP id e9e14a558f8ab-3761d6f1e8bmr29237915ab.23.1718812216105;
        Wed, 19 Jun 2024 08:50:16 -0700 (PDT)
Received: from [10.0.0.71] (sandeen.net. [63.231.237.45])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-375d866e36asm27249415ab.5.2024.06.19.08.50.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 19 Jun 2024 08:50:15 -0700 (PDT)
Message-ID: <7aeebecc-d5ef-4eea-a4e5-ddbfa411ee1e@redhat.com>
Date: Wed, 19 Jun 2024 10:50:15 -0500
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [LTP] [PATCH] configure.ac: Add _GNU_SOURCE for struct
 fs_quota_statv check
To: Li Wang <liwang@redhat.com>, Petr Vorel <pvorel@suse.cz>,
 Zirong Lang <zlang@redhat.com>, Boyang Xue <bxue@redhat.com>
Cc: ltp@lists.linux.it, linux-xfs@vger.kernel.org
References: <20240617053436.301336-1-liwang@redhat.com>
 <20240619092704.GA428912@pevik>
 <CAEemH2d=m3qAJkiv86B+L+iTc5qc+phGn+GO=kEe_fGOXxEMLQ@mail.gmail.com>
 <CAEemH2fH6tX9obxcVS6XJLcMvAvOz-JPe6wWoQdv26x8GAx2rQ@mail.gmail.com>
Content-Language: en-US
From: Eric Sandeen <sandeen@redhat.com>
In-Reply-To: <CAEemH2fH6tX9obxcVS6XJLcMvAvOz-JPe6wWoQdv26x8GAx2rQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 6/19/24 7:08 AM, Li Wang wrote:
> cc Eric Sandeen <sandeen@redhat.com <mailto:sandeen@redhat.com>> who is the author of:

If adding _GNU_SOURCE to the LTP configure.ac fixes the problem,
I have no concerns about that.

However, I also sent a patch to fix xfsprogs - having this wrapper in the
header is really unnecessary, and will likely cause problems for others
as well, so I just proposed removing it.

https://lore.kernel.org/linux-xfs/be7f0845-5d5f-4af5-9ca9-3e4370b47d97@sandeen.net/
 
(This problem only recently showed up due to other changes, see the explanation
in the link above)

Thanks,
-Eric

> commit 9d6023a856a1c4f84415dff59b0d5459cc8768db
> Author: Eric Sandeen <sandeen@redhat.com <mailto:sandeen@redhat.com>>
> Date:   Thu Feb 27 15:05:48 2020 -0500
> 
>     libxfs: use FALLOC_FL_ZERO_RANGE in libxfs_device_zero
> 
> On Wed, Jun 19, 2024 at 8:05 PM Li Wang <liwang@redhat.com <mailto:liwang@redhat.com>> wrote:
> 
>     Hi Petr, XFS-Experts,
> 
>     On Wed, Jun 19, 2024 at 5:27 PM Petr Vorel <pvorel@suse.cz <mailto:pvorel@suse.cz>> wrote:
> 
>         Hi Li,
> 
>         > These changes help ensure that the necessary features and definitions
>         > are available during the configuration process, preventing potential
>         > issues related to missing or incompatible definitions. This should
>         > resolve the compilation error related to struct fs_quota_statv:
> 
>         >  /usr/include/xfs/xqm.h:167:8: error: redefinition of ‘struct fs_qfilestatv’
> 
>         I wonder how _GNU_SOURCE influences any XFS header?
>         I haven't found anything in (<xfs/*.h>) or in <sys/quota.h>
> 
> 
>     With installing a newer xfsprogs-dev package on RHEL, we got a problem
>     in configuring our LTP test.
> 
>     According to the inclusion relationship: "xfs/xqm.h" -> "xfs/xfs.h" -> "xfs/linux.h".
>     The linux.h header introduces an inlined function that needs '_GNU_SOURCE' and <fcnctl.h>.
> 
>     $ git clone https://kernel.googlesource.com/pub/scm/fs/xfs/xfsprogs-dev <https://kernel.googlesource.com/pub/scm/fs/xfs/xfsprogs-dev>
>     $ cd xfsprogs-dev/
>     $ git describe --contains 9d6023a856a1c4f84415dff59b0d5459cc8768db
>     v5.5.0-rc1~39
> 
>     #if defined(FALLOC_FL_ZERO_RANGE)
>     static inline int
>     platform_zero_range(
>             int        fd,
>             xfs_off_t        start,
>             size_t        len)
>     {
>             int ret;
> 
>             ret = fallocate(fd, FALLOC_FL_ZERO_RANGE, start, len);
>             if (!ret)
>             return 0;
>             return -errno;
>     }
>     #else
>     #define platform_zero_range(fd, s, l) (-EOPNOTSUPP)
>     #endif
> 
> 
>     My test version is based on 6.5 so contains the inlined function to build.
> 
>     # rpm -qf /usr/include/xfs/xqm.h
>     xfsprogs-devel-6.5.0-3.el10.x86_64
> 
>      
> 
>         I know that some quotactl0[23].c define _GNU_SOURCE, but it's interesting that
>         this influence the header. Also, which RHEL (or whatever distro) version has
>         this problem?
> 
> 
>     The error occurred (with install xfsprogs-devel) during the configure script
>     checking struct fs_quota_statv. It failed to compile conftest.c and report
>     such errors:
> 
>     configure:5697: checking for struct fs_quota_statv
>     configure:5697: gcc -c -g -O2  conftest.c >&5
>     In file included from /usr/include/xfs/xfs.h:9,
>                      from /usr/include/xfs/xqm.h:9,
>                      from conftest.c:138:
>     /usr/include/xfs/linux.h: In function 'platform_zero_range':
>     /usr/include/xfs/linux.h:188:15: error: implicit declaration of function 'fallocate' [-Wimplicit-function-declaration]
>       188 |         ret = fallocate(fd, FALLOC_FL_ZERO_RANGE, start, len);
>           |               ^~~~~~~~~
>     configure:5697: $? = 1
>      
>     It similarly to the above quotactl07 patchfix, so adding '#define _GNU_SOURCE'
>     isactually formaking the fallocate()happy.
> 
>     Or, another way is the change made in "xfsprogs-dev/include/linux.h" otherwise we can't
>     configure our LTP correctly.
> 
> 
>     -- 
>     Regards,
>     Li Wang
> 
> 
> 
> -- 
> Regards,
> Li Wang


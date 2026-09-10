Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05E4C494A1E
	for <linux-xfs@vger.kernel.org>; Thu, 10 Sep 2026 13:43:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789047782; cv=none; b=BdZui2TLYEuRgG8F85oSnNRKzex2A0xOBFdfMR3kR+6Z5P268VQ0aHId+LoCrl7Tiy5glcyz4NbWUyFiJoBM4lu1rTzRwk9F5IEUrTWcHzJcXMbUstJetBcxKaeqs8OBNb2s4gF3s5nZnjAlL8Mj/6XTBy3yPiYGLMn4m1SVCGU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789047782; c=relaxed/simple;
	bh=98ToWsIS5d7IjM6ytuYwT3/Jd61Z99/5CcphE1jQArU=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=ohkd9DRshFkrV/4+2zSN0sKH5kQYNQd3iwWra4krYQPGuUm3F7wWt5wk08DJrp/49sx26QV6lq1kPJkKoVOyofsAvIz4deyt+MUqzIC8rC9Vara0rqEHE1YoDDj5DbqubiWcfPbm4Etz8h8mXledSXGyaniAEq59xG5uBdkIacQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=iyr3whHP; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=QL/SaU4q; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="iyr3whHP";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="QL/SaU4q"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1789047779;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=pJZZpHiP7CPuGKYWAqqyZAd3k8D84Jqu2Jb8Skkggz8=;
	b=iyr3whHPyiAwG5dn8E/SfzANIpfltrCwqPHUy1X5Bn1qhp/6ZF5b7jj1FtJad5e7FRR8E1
	LXOr40oKG6Xws8LSrQGjYVDObwyAKzgWqm64cwAtMMSCsACrOLF6ayVtz7U/WeNj8/Hx6a
	adR1MONlYTf7jfW6Mqs/vkFCrzzEuKw=
Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com
 [209.85.215.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-84-xKdxUOLhPyOlP3ELQBbN3Q-1; Thu, 10 Sep 2026 09:42:57 -0400
X-MC-Unique: xKdxUOLhPyOlP3ELQBbN3Q-1
X-Mimecast-MFC-AGG-ID: xKdxUOLhPyOlP3ELQBbN3Q_1789047776
Received: by mail-pg1-f199.google.com with SMTP id 41be03b00d2f7-cc132709c76so9835786a12.3
        for <linux-xfs@vger.kernel.org>; Thu, 10 Sep 2026 06:42:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1789047776; x=1789652576; darn=vger.kernel.org;
        h=content-type:mime-version:message-id:date:user-agent:references
         :in-reply-to:subject:cc:to:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=pJZZpHiP7CPuGKYWAqqyZAd3k8D84Jqu2Jb8Skkggz8=;
        b=QL/SaU4qUMxjSQDoGVgI34D9SeUM45rCEafQP1B24QyBd/58GnMl6eNnwwI8wYIQYi
         U1BhM44Cvfb2+nw3/Bq3HjuvjfX0YfgC8qlfgW8nmgdACCyaFGKBDHDcIB+NHQfkJV/p
         LjrA0onvWMG0yUY1kpLw3zZCBAzfkcjyVKtlaPB5mDOErgEaNGx03HBL+J+LLeuSBxVI
         +9OicTHJciHa4GkOfVBKAMg2sch82Ba3YnegfDZm2NP6ee5LO3SXHPI0+kKEQSSkRdw3
         L4S/l9UpMDDUxkMnKrHypUatNlH5AZvm/tn3xBpvZNqZ8FizF45osAEbHtyT1Ve6PfhX
         mb5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789047776; x=1789652576;
        h=content-type:mime-version:message-id:date:user-agent:references
         :in-reply-to:subject:cc:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=pJZZpHiP7CPuGKYWAqqyZAd3k8D84Jqu2Jb8Skkggz8=;
        b=XrjMQTJ9Dx2M89DJisT9OD0oV7TDV0QrdhLS/Gd2OCMShumYuHvzcdHBrSYb34WoAW
         wUikxV6iyUPXZgvoO21hAhNB3RK5F19RIZ6D+7vSL/Sn+ITsKX7mKmaR/fYBTQiCQrxy
         4Qq6LaLEEpxo9L5D8Kr5G7qgo6NO5KvF26qr6SA6zzROvv19W/NbrZIaNIVAJFoIAe9m
         PlJYCdhLVWYplnjV/ZduWzdT+ZvsXAcY6zU3CwqfQk7pNH2cAV9TBFrhqXt64UOYxAbT
         weG4P+6ywKRU1eF25D91wxh7/rF1JYGAfOWeOLxuMRWX5zIOGlfCLvlpFQBvRWARqrvQ
         DkOA==
X-Forwarded-Encrypted: i=1; AKwUvBxmHTPwgxyXKZaWdxguT7RZVc2wSDKAxOdYDKIjI9ZaVCbAO4FqfkPqV21pKDhVBz3XIsXA161EPMs=@vger.kernel.org
X-Gm-Message-State: AFuF++myWgJsWVAJARZm4gsrQiHXikQdM7rD3CBNIvsUzoAN4BLA/nRC
	fk7DEFyH5K8EqZ1hKKdddjhtpEYxzi34geMq6hgQ+/PZKOvyrCa9PNi8GMAXH2hpEo0EeLg1z3i
	h/W4htIC4cb650RcblXoWLAZYQ6ZR5FYm1uboF/i2hKpSgG2ngSRx4rzIM9lZpQ==
X-Gm-Gg: AYBFou2dZj+LBDY1BMFodN0zGrU+ksJ7FVaBrs7/rf/5/MJK9HUQ4rP7CAG2pWs15Q3
	4NOnv4oI/iU6+CxdUYBZe+J9pJYYbFzXbtrwrrR8JDS8v2D1ATmdHj+1ITqBGFV548dozLYgHkX
	Im+Mvcpb829j4TE5w71QvSGGG/5cpFiuvvzob3klhkcGcLOosoMZU6TX6uW0xA18JaUOlHzrxyI
	PJFD8glsMsAchP9p4/JLHPVFGRUtHoA161QL2di/nugcXsTC//A/8HPP1hrJwRSidm1Tu83Is/8
	w/n0AedpaB6WWFphtKkyJAmQV4SqBRKQG88UwJwEhClK3kDqgZ0pJrnvkTXMlFMBGnjU3bephA=
	=
X-Received: by 2002:a17:90b:268d:b0:398:b71e:60c1 with SMTP id 98e67ed59e1d1-39d70ae1201mr11368185a91.12.1789047776237;
        Thu, 10 Sep 2026 06:42:56 -0700 (PDT)
X-Received: by 2002:a17:90b:268d:b0:398:b71e:60c1 with SMTP id 98e67ed59e1d1-39d70ae1201mr11368108a91.12.1789047775647;
        Thu, 10 Sep 2026 06:42:55 -0700 (PDT)
Received: from localhost ([240d:1a:c0d:9f00:be24:11ff:fe35:71b3])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cc467df7beesm7140566a12.7.2026.09.10.06.42.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Sep 2026 06:42:55 -0700 (PDT)
From: Shigeru Yoshida <syoshida@redhat.com>
To: Carlos Maiolino <cem@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>,  "Darrick J. Wong"
 <djwong@kernel.org>,  Deepanshu Kartikey <kartikey406@gmail.com>,
  linux-xfs@vger.kernel.org,  linux-kernel@vger.kernel.org,
  syzbot+ccdf3469f5f653bff7ac@syzkaller.appspotmail.com
Subject: Re: [PATCH] xfs: take hm->lock in xfs_ioc_health_monitor() before
 insert
In-Reply-To: <aqJ6yulX3XBEoj4u@andromeda.toxiclabs.cc> (Carlos Maiolino's
	message of "Thu, 10 Sep 2026 11:40:09 +0200")
References: <20260906144629.17009-1-kartikey406@gmail.com>
	<20260907045150.GI1933798@frogsfrogsfrogs>
	<aqI7LFBkAhMSaDnx@infradead.org>
	<aqJ6yulX3XBEoj4u@andromeda.toxiclabs.cc>
User-Agent: mu4e 1.12.12; emacs 30.2
Date: Thu, 10 Sep 2026 22:42:53 +0900
Message-ID: <87y0d99q8y.fsf@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Carlos Maiolino <cem@kernel.org> writes:

> On Wed, Sep 09, 2026 at 10:07:56PM -0700, Christoph Hellwig wrote:
>> On Sun, Sep 06, 2026 at 09:51:50PM -0700, Darrick J. Wong wrote:
>> > On Sun, Sep 06, 2026 at 08:16:29PM +0530, Deepanshu Kartikey wrote:
>> > > __xfs_healthmon_insert() asserts that hm->lock is held
>> > > (lockdep_assert_held), but xfs_ioc_health_monitor() called it right
>> > > after allocating hm, before ever taking the lock, triggering a
>> > > lockdep warning.
>> > > 
>> > > Take hm->lock around the call.
>> > > 
>> > > Fixes: b3a289a2a9397 ("xfs: create event queuing, formatting, and discovery infrastructure")
>> > > Reported-by: syzbot+ccdf3469f5f653bff7ac@syzkaller.appspotmail.com
>> > > Closes: https://syzkaller.appspot.com/bug?extid=ccdf3469f5f653bff7ac
>> > > Signed-off-by: Deepanshu Kartikey <kartikey406@gmail.com>
>> > 
>> > Heh, I added a patch just like this one to my own tree.
>> > Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
>> 
>> Can we get this queued up ASAP?  It's also causing a lot of failures in
>> our zoned XFS CI.
>> 
>> 
>
> Done. It's in for-next already. Not sure if I'll manage to push the
> attrs fsblock fix yet this -rc, but this one will go to Linus on
> Saturday

I noticed that the second mutex operation in this commit was
accidentally left as mutex_lock() instead of mutex_unlock(). I've
sent a fix as a separate patch ("xfs: fix double mutex_lock() call
in xfs_ioc_health_monitor()"). Feel free to use it if it helps.

Thanks,
Shigeru


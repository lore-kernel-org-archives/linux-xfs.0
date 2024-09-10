Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B821014A088
	for <linux-xfs@vger.kernel.org>; Tue, 10 Sep 2024 18:30:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725993027; cv=none; b=Qo2BuEf1SoGQVLAPrWNuWV7vvw2NgNq1DSlikkJHLRTyG2WMTPLyPcOewTjTJryk+0JZEapqVdgEbL9Z5Yit/UdLrlkZWi2P4mPTEcnFphQNZNK8bl6c5hQQ5oHvhiniVRmd6e0dxBOBZzMNnmB4HzoQjkdHpTVdmFrC8F+SMDw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725993027; c=relaxed/simple;
	bh=g3w3Tso/v/0w2ygisx+WBduPcsMuiZqkxxm3w8elGhk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=juF3YFsVzwpvl9PeEfn1Jy4dYjXPxF9+Eu4kqCjs7ttDCXMW6wGAfIgP0HQrVUL11NyTflXqm/vtmoJaj9E0O+pU4ccvM1huPOvzmpgafoSqTkscDAX6Gwsm1Gcmk76CoNTIl9Vk5hoO5Azcspp4N0QGDK2T8AB+71J7gkNlBpk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fwgej9u6; arc=none smtp.client-ip=209.85.208.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fwgej9u6"
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-5bef295a429so6629358a12.2
        for <linux-xfs@vger.kernel.org>; Tue, 10 Sep 2024 11:30:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1725993021; x=1726597821; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=8v5Hd0GafvR7eRw+F0b/pQqT5Z7153+Dlo66ZdBXwCc=;
        b=fwgej9u6OEaSODOdjmtWHSy36aVJ7bx12nrjcs5c9nia1ycC1CV67feJHQ7FE54lBa
         Fa2cGwt2b5X9C8j78JWoNcbKu1UgzPX4YGOxlku+onfJFRp3vwLVhhlffTyk8aWCwzTf
         8gFHOelzODZFTR1QyS9kS4V45SKB8RBjySgjg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725993021; x=1726597821;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8v5Hd0GafvR7eRw+F0b/pQqT5Z7153+Dlo66ZdBXwCc=;
        b=cUl9zh7BjaFiLUBLLYtic8SYPaMhdkq6SdXnSOEhY46qvHPu6tgRFxVLlkTZ6YfLF1
         RTevqUuVqLtzxBCe0rYRfH1ZZoqtcVq8saJRLbG86Zda+ioV7cuNzeL5A6fHLwpqZjbq
         rd/Vw6hNhpKNXEXr1em6OArvRmrVksEah8D9xkPn3tROyGVDvq5h3xLRRFy7qDnvJGg/
         Kcgpawyo4i2Gr/heL7RrLvc0ntRf8en8oo3xFFiDxRCmRLXKKEXM0qnr8J/zKIOB8KMs
         Fep9OcTHo7FGHte4t8BEl12d5/PgqQ5s6/L4gNZ02TikPzJtI8Cib37z3fUIVYXI4t5B
         jtXg==
X-Forwarded-Encrypted: i=1; AJvYcCU/FnWmALKorxC7OtPwI5bjgqxPt9NWqu/J1ziBN1PMRTsqAeAiMQZDXMeKd2eVdyd4ehFpMXDQN1A=@vger.kernel.org
X-Gm-Message-State: AOJu0YwIRAD0PzOaI+UmcmyGr0bxfFNqMheozZLbfnh1Ucf3+b2xIlI5
	5jACmjE57Z0hXkyfmPQaOERfiXxL3Rt+S7EdTgWckpiuP0ckWizNmj7oz3DOYUg7s+WzmH4eIBg
	YpBc=
X-Google-Smtp-Source: AGHT+IFuiclxUBy+yb/6caj5bZP3ptvNzjE/jGN2FH4D4rOdQmZTYswpjs7JwtkEzCanxWwSEqugOQ==
X-Received: by 2002:a17:907:7245:b0:a8a:8a31:c481 with SMTP id a640c23a62f3a-a8ffad9da34mr166338566b.42.1725993020726;
        Tue, 10 Sep 2024 11:30:20 -0700 (PDT)
Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com. [209.85.208.53])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a8d2593dbb7sm513197466b.56.2024.09.10.11.30.19
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Sep 2024 11:30:19 -0700 (PDT)
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-5bef295a429so6629304a12.2
        for <linux-xfs@vger.kernel.org>; Tue, 10 Sep 2024 11:30:19 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCXfy/lm9ayK5ucc7D1cfJsKtsNtTKCAHMsq3PVGR6Gf0O0Jpjeu/EUxBxOnnh2qLyMPVCiGPZBnNqM=@vger.kernel.org
X-Received: by 2002:a05:6402:34c4:b0:5be:cdaf:1c09 with SMTP id
 4fb4d7f45d1cf-5c3dc7baef3mr12220681a12.28.1725993019011; Tue, 10 Sep 2024
 11:30:19 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <0a43155c-b56d-4f85-bb46-dce2a4e5af59@kernel.org>
 <d2c82922-675e-470f-a4d3-d24c4aecf2e8@kernel.org> <ee565fda-b230-4fb3-8122-e0a9248ef1d1@kernel.org>
 <7fedb8c2-931f-406b-b46e-83bf3f452136@kernel.org>
In-Reply-To: <7fedb8c2-931f-406b-b46e-83bf3f452136@kernel.org>
From: Linus Torvalds <torvalds@linuxfoundation.org>
Date: Tue, 10 Sep 2024 11:30:02 -0700
X-Gmail-Original-Message-ID: <CAHk-=wgO9kMbiKLcD3fY0Yt5PJSPD=9NVH0cs=xQFSk8dU9Z1Q@mail.gmail.com>
Message-ID: <CAHk-=wgO9kMbiKLcD3fY0Yt5PJSPD=9NVH0cs=xQFSk8dU9Z1Q@mail.gmail.com>
Subject: Re: Regression v6.11 booting cannot mount harddisks (xfs)
To: Jesper Dangaard Brouer <hawk@kernel.org>
Cc: Damien Le Moal <dlemoal@kernel.org>, LKML <linux-kernel@vger.kernel.org>, 
	Christoph Hellwig <hch@infradead.org>, Netdev <netdev@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>, 
	linux-ide@vger.kernel.org, cassel@kernel.org, handan.babu@oracle.com, 
	djwong@kernel.org, Linux-XFS <linux-xfs@vger.kernel.org>, hdegoede@redhat.com, 
	"David S. Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>, 
	kernel-team <kernel-team@cloudflare.com>
Content-Type: text/plain; charset="UTF-8"

On Tue, 10 Sept 2024 at 10:53, Jesper Dangaard Brouer <hawk@kernel.org> wrote:
>
> af2814149883e2c1851866ea2afcd8eadc040f79 is the first bad commit

Just for fun - can you test moving the queue freezing *inside* the
mutex, ie something like

  --- a/block/blk-sysfs.c
  +++ b/block/blk-sysfs.c
  @@ -670,11 +670,11 @@ queue_attr_store(struct kobject *kobj, struct
attribute *attr,
          if (!entry->store)
                  return -EIO;

  -       blk_mq_freeze_queue(q);
          mutex_lock(&q->sysfs_lock);
  +       blk_mq_freeze_queue(q);
          res = entry->store(disk, page, length);
  -       mutex_unlock(&q->sysfs_lock);
          blk_mq_unfreeze_queue(q);
  +       mutex_unlock(&q->sysfs_lock);
          return res;
   }

(Just do it by hand, my patch is whitespace-damaged on purpose -
untested and not well thought through).

Because I'm wondering whether maybe some IO is done under the
sysfs_lock, and then you might have a deadlock?

              Linus

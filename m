Received: from mail-il1-f199.google.com (mail-il1-f199.google.com [209.85.166.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C8AA20B803
	for <linux-xfs@vger.kernel.org>; Thu, 24 Apr 2025 08:59:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745485163; cv=none; b=BY46Tod5mVUhKvnQbF2vNnFYICj2gPgROr+PUY5IJ+86mAS54Xfmdc9gEnZzo6yAUb9AIAus3jwZPL7vcLMhTOvlVHbelLjrjLxjlTRjrN2OnlNu7x1Fpkey63VqFnyGlHEzeXhOlgNq5qeCijeecU6pqVhKuFaWh2B5LxTJBoY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745485163; c=relaxed/simple;
	bh=N47ykR6NUWtRq4erTcl+KS/Qyu7ndgzqN703DmZda64=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=PQATx/4BPKNK6S0cMJ4rBycZHAiGIz8tt8Ex72bJzIdktoDMSmtPa0/ysWz4yBGCHbBYDSYqP8RyBBSflxoAgqDmMtuYMjrRr8QK8qbQ/sSSSSxcGCUzwwlZvS0s3CEoMt7wv1JZqnN1x7UAbDW0C4F8BqXRTY1WtueRv2z4OeU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f199.google.com with SMTP id e9e14a558f8ab-3d922570570so10236595ab.3
        for <linux-xfs@vger.kernel.org>; Thu, 24 Apr 2025 01:59:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745485161; x=1746089961;
        h=cc:to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1Z93bCrJfOW43DXKBTDnM6RhhcZ/O5Fr+k9HY7iqBwg=;
        b=l4/Ul7aK9KucUFepN2yM2nmsRgeHQ5og8yEeIXHZ/12qdSCX3LZGqsL5qe61mKU5En
         26UDXsKZa7nk5xIu7pCTBo//Pc32uANpbhXdPiW0BbCgKMYeVgcCK0c88orx5I2QQTQO
         Q2ft89/Pewj/ABWLnzjcTbW5SKbxIqw03bI4A2K/gR2Jd0/LjbABcuBYT9041ksizSix
         owfKh4aMu+olRnQeLOpahTxlAfgn4JNoq4gkavnxFv6pLg2i/wdvCOQwPQQOebYH4rVA
         lCaFm6TK6Xj9sPA/9+S8XJD9uRCDLtXuCHi7WoH3jmxOeiMXLvJGm7+NbJWTURB4PMDa
         +Xyg==
X-Forwarded-Encrypted: i=1; AJvYcCX2uLYUumfTx413KbodVraY9kcldBdzf1/bdGykdGPDwg3UAQCK2BH3moNocHWNmUCyjrZztroNfwY=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzspfs2FjVyyyE2ZMTFJ2f9AP8rPQbIVj84XaqHQX0R02PHThhm
	1M/kU+WBsvlwCmcVMklB8d//a4UCsYDXI3QCpQ6HhJA2EBB+OFE899aEPQFJ65dg8qy4NIFMm2a
	MbKGCsr+iqzUEfRspaKgyFTIdsOwKJxjC+DfzeZjPspcU7WLdYeb6wp0=
X-Google-Smtp-Source: AGHT+IHqxxBuf6pSikN1iLEFp4B9endVU/Hv0sCKywoL7eyZ2dC3aQ2Ce+cuwI38I1xNL696T0xYiIOk2NWvsKszYNR1+nXruKvw
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1a0e:b0:3d5:890b:d9df with SMTP id
 e9e14a558f8ab-3d93041e57emr16671365ab.15.1745485161215; Thu, 24 Apr 2025
 01:59:21 -0700 (PDT)
Date: Thu, 24 Apr 2025 01:59:21 -0700
In-Reply-To: <20250424085914.82201-1-contact@arnaud-lcm.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6809fd69.050a0220.317436.0049.GAE@google.com>
Subject: Re: syztest
From: syzbot <syzbot+b4a84825ea149bb99bfc@syzkaller.appspotmail.com>
To: contact@arnaud-lcm.com
Cc: cem@kernel.org, contact@arnaud-lcm.com, linux-kernel@vger.kernel.org, 
	linux-xfs@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

> #syz test

This crash does not have a reproducer. I cannot test it.

>
> --- a/fs/xfs/libxfs/xfs_ialloc.c
> +++ b/fs/xfs/libxfs/xfs_ialloc.c
> @@ -1182,6 +1182,8 @@ xfs_dialloc_ag_inobt(
>                         if (error)
>                                 goto error1;
>                 } else {
> +                       pag->pagl_leftrec = NULLAGINO;
> +                       pag->pagl_rightrec = NULLAGINO;
>                         /* search left with tcur, back up 1 record */
>                         error = xfs_ialloc_next_rec(tcur, &trec, &doneleft, 1);
>                         if (error)
>

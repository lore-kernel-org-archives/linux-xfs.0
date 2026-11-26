Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.48
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795715947;
	b=4/kFmkKuJ/Nd4NbUrtU2wVA1uu+LVh7Q26QM61AQH8d20fRuQ1OUq2FeCJ1Z9s8n2aXO
	 wWxAcEfSaU6RBtRC6qeE9a3k6fQqwzQXcPWtSZUBF1eai01xM65IMyo6lGNF+KHsDgiIe
	 oGfB5X7CFQHOKJUCdtvQ/UmHdla0+G5GZbrYkLhceYkE1bEshd7xwDCvCXvGPfIzw2ZN+
	 sKYyitltkLDROaNdWH964GhnHtzSQmkOnVgmzaPdUxZKWNymDm25noYy5FAw96ad7EVQ4
	 hJdGwhiRoh6xPQBy2bL4fMwTxSG2/g34UKpfO7mZux2fzq/Aggx42jKH1xbRt8A5R2w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795715947;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=kSoIKOLT3+XabJWpUUxG3nmSVnvVHcKC8IWUKEmSpyk=;
	b=x69jjLLGI0JWvKVRuW7a/RRAbnI31XD6igjls3TXU5xOFyZCtKwZPBQCAq2tmoE8Fp3G
	 exp3vmspoWrMqIhHXC1jrHxupWrG7jwHoFr56KkAQEW2lWbF9Y84F5vucUchBor6tJ9gO
	 MC8wyOlXtFTgASky/z2hrnM7pOafBfR4n8eY0q4ixuO0xOz/uwqHvKRjgpifhreK1oHut
	 21gzXUCivN4Xda1pIh2bBKOMsG+F/GRc7SNqtnkrtpJZpDz+ifGg051Caq4x+vrvdI3bi
	 7FBPvfFXF615rQ+T6MI5uplWiqpdf1i0S/SqKo1x4fz4tIhB+04itzjT73Xg35+VseQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=FjlYfhdN;
	arc=none smtp.remote-ip=209.85.221.48
Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 305B8606A31E
	for <linux-xfs@vger.kernel.org>; Thu, 26 Nov 2026 17:59:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 305B8606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=FjlYfhdN
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-4a5024b3c28so4786174f8f.0
        for <linux-xfs@vger.kernel.org>; Thu, 26 Nov 2026 09:59:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795715945; x=1796320745; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=kSoIKOLT3+XabJWpUUxG3nmSVnvVHcKC8IWUKEmSpyk=;
        b=FjlYfhdN/THyqzVu6c+I6Y9P/7ZOaDE5FmS42pXMztlcikrhrWKLam6pUFL7txUkJ4
         UbIS714OKdJsMkRJ7GLVMJ9KEmHUKYBDhdZ6hx6tOH6OWCIH6eUC0qPHSljx907N8dpf
         zppdZzYKF9kth1swPK1kll4PVlIJ9VmTSet8Ajh+R3MZQHt6pWJcZLQRpLkobqdHedk1
         +KIl+QLlV5rKSD2WNtJk2/9CJp8X49OsjGn5l9OeAWa6hFN8HXC6zpE2YIuBITTCtofw
         jsEnwBCTCILxv0GNqWYhBoOh3ae4vC6w89H4NRoMlWphoWZsxqDoygEtdNq2gxo10jyq
         47cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795715945; x=1796320745;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=kSoIKOLT3+XabJWpUUxG3nmSVnvVHcKC8IWUKEmSpyk=;
        b=UWB/Lv+w+1Dh+tLz8593N0Qj10pAh0H0w0J8TKgtr6Q9eIgoNE6mkbJLEcftpe38Kh
         1ymaarzIIt/VGTJ0z8nnwKZPKuI6y43WHWvA5YO2Npo7aQsXkIJkfFHb8P9kfIrwWXB5
         hROztCKdOJuqdb9pvfrh0v5Jc6RkvrGq08QBDsZwmqn04IxqIYIM0dQgdeCcKcY12grJ
         K/hD6ybwrEOfIEKfD5WOJkM4qzDugPkW08kzkNDTooDUouh9FWfTveXb7ZFSsZNiCV2n
         zZ9PrB63N0ZjuDnCcbRgYRMyoyd/MetnBC+xuhk51JOII2qZbIvZCUq/Y+TnOgscwQFo
         lv5g==
X-Forwarded-Encrypted: i=1; AL+hErEeawfEIE0oC2adTxK74/bXIU62PktHfAUkBVvquZXBkxpEaCx62DYwLYYbDi2hBJR9IFKQJ9UIm8Y=@vger.kernel.org
X-Gm-Message-State: APuU4Z+PavnK/KUtppsftfsnb7YHPSUN1+zrWWJrXL1sC2RAADhEfMC/
	iKvGCbA7kJQ/BGmPGyuBq0zieOo3aM7ZKbDmLz79+uasa3PEggSYlQJl
X-Gm-Gg: AZFdTZcCMqPfjSt5PToRmzzr0+zIAqEWKdcwHVn6FFR2I5WEXK1TbW/1pbokzvaGF3y
	BJ7A4JTGvRNy5+G19ezYQzs17WZ+zRDJE1BXOPXnd8qPFnPcqULx17W9XUaE7zCENj1mGwYutSu
	0PNQafpmiE8IVyztf4iY0y6Nw5AAjJfb1Wkq7hDAahe+qJ9YZnRl7k/a8fRYZFjLzvHrHaqZSao
	Q62sRKsTE5iC6ezTE8+Zwjgoz9oJwML0yL5x7YhlXKlgiV9hC0uPG3c7ZTUQSKQbdkZ7NJ+smhx
	STe2yMy5fLW96f7XQuNP1OOTek6Fiv3/CaQqGfhIYGXmLzYP6+Idp4QbCuiX4PUqediPrBRB7+w
	bD0OmntyR+tjJKvYIIJpHTricKYvJIOWOp0NN13Euh1pq78cbfYyutYmL1mzdRFgqXYaKO1/JW5
	OyG6ayL/vkF2dzzQHNI4ZDiglzBcMcwGScwZhphqTN0XWIcORyTKzZ1fFJNiIPCmBf8dhegQeKz
	5crdY5jNe4tldyR9zoGbmd5zbxf5YeMqv0pQTCmWWOQC9GCII6BUBoYb/ZcS+GoyRHnTQDzH8Fi
	7erGUYJYyB1jsJMV1xMuiPXysGQa/kEeP6u5geRVYHJxPG2UKtd0ZbTCHqLeDUfnA3Qd1dJ/wcJ
	uAgGvNm9eoudW7jWaoIuRoOXlDAU26J415mxYWg==
X-Received: by 2002:a5d:59c3:0:b0:491:632f:2c8f with SMTP id ffacd0b85a97d-4aa4e01e2e6mr54213015f8f.2.1795715945287;
        Thu, 26 Nov 2026 09:59:05 -0800 (PST)
Received: from andreayoga.localdomain (93-42-14-189.ip84.fastwebnet.it. [93.42.14.189])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4ab6baa3882sm41519433f8f.49.2026.11.26.09.59.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Nov 2026 09:59:04 -0800 (PST)
From: Andrea Parri <parri.andrea@gmail.com>
To: Carlos Maiolino <cem@kernel.org>
Cc: Andrea Parri <parri.andrea@gmail.com>,
	Dave Chinner <dgc@kernel.org>,
	Jeffin Philip <jeffinphilip14@gmail.com>,
	linux-xfs@vger.kernel.org,
	syzbot+c32ff62cf4913d345d0c@syzkaller.appspotmail.com,
	syzbot+9d8e687768d0f38c1f09@syzkaller.appspotmail.com,
	syzbot+a4fde844548510369112@syzkaller.appspotmail.com
Subject: Re: [PATCH] xfs: wait for buffer unpinning before shutdown completion
Date: Thu, 26 Nov 2026 18:58:45 +0100
Message-ID: <20261126175846.167973-1-parri.andrea@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <awhtipqpIxxUgyjj@cronus.toxiclabs.cc>
References: <20261126164604.158012-1-parri.andrea@gmail.com> <awhtipqpIxxUgyjj@cronus.toxiclabs.cc>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On Thu, Nov 26, 2026 at 06:34:02PM +0100, Carlos Maiolino wrote:
> I *think* Dave is already working on a proper fix for this on his
> series, so I'll wait for him to look into this as I didn't have time to
> go through his series yet.

Thanks.  Please drop this patch in any case: Sashiko pointed out that
it can deadlock in xfs_buf_delwri_submit(), which keeps every buffer it
has submitted locked until all of them have been submitted:

  xfs_buf_delwri_submit()           CIL abort (xlog_cil_ail_insert)
    lock bp1, xfs_buf_submit(bp1)
      xfs_buf_wait_unpin(bp1)         xfs_buf_item_unpin(bp1, remove)
                                        drop pin, wake waiters
      log is shut down, complete bp1    xfs_buf_lock(bp1)    <- blocks
    lock bp2, xfs_buf_submit(bp2)
      xfs_buf_wait_unpin(bp2)    <- blocks, bp2 would be unpinned
                                    later in the same abort

This needs bp1 and bp2 to be pinned in the same aborted checkpoint, with
the abort reaching bp1 first and bp1's unpin dropping the last BLI
reference.  That is the quotacheck case the patch claims to fix.
Without the patch, xfs_buf_submit() does not wait once the log is shut
down, so this is a regression.

I couldn't find Dave's series on lore.  Could you point me to it?  I'll
check whether it covers these syzbot reports before sending anything
else.

> LLMs references should stay away from commit messages. Doesn't matter
> what tool you used, the code is still your responsibility.

Understood, I'll keep them out of the changelog.

Thanks,
Andrea

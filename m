Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26358158878
	for <linux-xfs@vger.kernel.org>; Tue,  9 Apr 2024 21:29:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712698193; cv=none; b=N8D1VW+DMa8xOkmpk4FWFLz+JOUUzhQ3IC+pzUj/dgp8XKwX7YFEpVHLj0K3kY7JcXqHHBtgd5V6iVvoj0IX+o9CkdC5hR9R6tO8KoA1sHsJtonUFTEgPJ9RVLsssM6k/Hfu1iWbsh5JWjQNsqH0bgDY25/X310H++JRWux4Klo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712698193; c=relaxed/simple;
	bh=Ubqqm63lKdnzIJduqL2oJ1Vi2+iIgr/cKwTszXup7q0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XL/SnQ6WrBb2nChEmSa/iQsZpHVczpJrkyKqu0ZKunaapHmWwcpKtoPoJ/ZRr7x/8t8G5SDYvmwe7CKhrws3rBiFitWRHJ+F4a8lMhZ7J8e/hZzAgcSWSql5y6QCOhG/PE7TKfTDosuicH7w94TqjR2sWC1+iXQPmP6CaurJoRI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=VJCJkhDg; arc=none smtp.client-ip=209.85.210.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="VJCJkhDg"
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-6ed5109d924so1898837b3a.0
        for <linux-xfs@vger.kernel.org>; Tue, 09 Apr 2024 14:29:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1712698191; x=1713302991; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=lppOhDLhaTktGl6lazMPAeBs02NfwHMeHSnwbowOWTw=;
        b=VJCJkhDga/OfKWeKbdrV+Saj9YmigCMLGWF6BfgnQH3eH/S5yBIWflk+OPpwtREuOe
         sCZzrABd56f1+kvK3UE8lUjqkbdw9/DIVfraZRmuWWGFbeUgR5nF1Jggriy2kyc8BiT3
         WG0uqYH+QFP3PCBjxaLWrN9sbyBXT4g4Gjvx+s2sjOqCW92mtMNHWnyE+tbS9iOmvjtL
         83ocso+vIOzA3YcvmGz8c5BsZDEQZ1yPXn1dlslF78q4D70zvWDphBajBYEfoPJVIDLd
         tOuVrVGhru5QLUAMuspZ6FEnkvqGtKz1qHoqCWn6fMtLS5aODbw1gspxqRiPljuVMG94
         tlxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712698191; x=1713302991;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lppOhDLhaTktGl6lazMPAeBs02NfwHMeHSnwbowOWTw=;
        b=WBMquiOo4XhS8kZWO0oqC4f1ml0xHfUXJv3EF2d3In0SUEjY5byGeXDQjj09iruOks
         iGOZ8/ReCc9XkoIoebIfWHN5i43qTCqkETcqTsoBhDj1wmIS2DTZEjRunGSm1M+BTudG
         2ZtvXsuax2t4iRkBbmnaVvwZQnRdO8wcwRxRsHZ8iPvLbqej8H1IA+Pj1izDjg848tVi
         vxNCf9QfWofFmkpwFDGGVdRvyQvZfhaRRu3v6U/LFK8wxxBCYjOKthsOqGo9RMVjMx/M
         p7Zlw64qhxRhn5uok4L/1Y7GWE1fquAFwJeKAwiYkU4GscOrTyb0nw8NFZUnihK8K0BD
         l+OA==
X-Forwarded-Encrypted: i=1; AJvYcCV75rGStqzHyaRGQX34iLRXpuvciSyLj0k4sxAQs0mKkzGNiisSaY8UYdLpQu9C+sFMDIPHcZlT+GGbat8pj17mEwe++2p8Wk+G
X-Gm-Message-State: AOJu0Yx0dAmvTWUuqlwX2dwmHwhT7KzhJ7wc5GhlMdHKYBcA7EO+0D+w
	zFE9qcK7qrG7MWMsi2hYVAG9etfmp7WK1YMvXx7eUA+adDMsWBWhSrFp39t+fG0=
X-Google-Smtp-Source: AGHT+IFvOqPyH50nuc2JACoXyF6q2DKJ9ivcnsRna4tGd1/cjZ8p4v7GhrD65qleDU/qtwwIyhj4CQ==
X-Received: by 2002:a05:6a00:14d1:b0:6ec:faef:dd28 with SMTP id w17-20020a056a0014d100b006ecfaefdd28mr932086pfu.23.1712698191116;
        Tue, 09 Apr 2024 14:29:51 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-56-237.pa.nsw.optusnet.com.au. [49.181.56.237])
        by smtp.gmail.com with ESMTPSA id x12-20020a056a00270c00b006ed048a7323sm8006356pfv.86.2024.04.09.14.29.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Apr 2024 14:29:50 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1ruJ2J-009xO3-3A;
	Wed, 10 Apr 2024 07:29:47 +1000
Date: Wed, 10 Apr 2024 07:29:47 +1000
From: Dave Chinner <david@fromorbit.com>
To: syzbot <syzbot+b417f0468b73945887f0@syzkaller.appspotmail.com>
Cc: chandan.babu@oracle.com, dwmw2@infradead.org,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mtd@lists.infradead.org,
	linux-xfs@vger.kernel.org, richard@nod.at,
	syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] [ext4?] [jffs2?] [xfs?] kernel BUG in
 unrefer_xattr_datum
Message-ID: <ZhWzS47ZvqF2WriS@dread.disaster.area>
References: <0000000000002444e20615a20456@google.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0000000000002444e20615a20456@google.com>

On Mon, Apr 08, 2024 at 09:04:18PM -0700, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    707081b61156 Merge branch 'for-next/core', remote-tracking..
> git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux.git for-kernelci
> console output: https://syzkaller.appspot.com/x/log.txt?x=1562c52d180000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=caeac3f3565b057a
> dashboard link: https://syzkaller.appspot.com/bug?extid=b417f0468b73945887f0
> compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
> userspace arch: arm64
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=14e74805180000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1613cca9180000
> 
> Downloadable assets:
> disk image: https://storage.googleapis.com/syzbot-assets/6cad68bf7532/disk-707081b6.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/1a27e5400778/vmlinux-707081b6.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/67dfc53755d0/Image-707081b6.gz.xz
> mounted in repro #1: https://storage.googleapis.com/syzbot-assets/f039597bec42/mount_0.gz
> mounted in repro #2: https://storage.googleapis.com/syzbot-assets/b3fe5cff7c96/mount_4.gz
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+b417f0468b73945887f0@syzkaller.appspotmail.com
> 
> jffs2: nextblock 0x0001d000, expected at 0001f000
> jffs2: argh. node added in wrong place at 0x0001e03c(2)
> jffs2: nextblock 0x0001d000, expected at 0001f000

Nothing to do with XFS or ext4 - they are simply being mounted with
invalid mount options at the same time.

#syz set subsystems: jffs2

-- 
Dave Chinner
david@fromorbit.com

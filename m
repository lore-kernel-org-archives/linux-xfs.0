Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8B9851C48
	for <linux-xfs@vger.kernel.org>; Sun, 28 Apr 2024 08:09:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714291778; cv=none; b=PiE6xmFVfjQIjJiNrD6yIqzx5UMrOZAVZkmAVnn9brRcdG9KfVcvG+rwiaD7pIDzWVPzYTWvl3nkpVFNHQWRxXQyccpQypxrwdlW5teLDvMhKOG4NcfObDFth5TXJfsl1jaiESbtJCbTJ6pC7oquyOQVEWQLAZFsofwjuKGSCZs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714291778; c=relaxed/simple;
	bh=RGtjeZHfticbLVVHVwKN60wvYIzeLxe4ZhOw7GQu+bA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=j3qMi4q4HXZB/V2L1cPFxMFeyTnVjsH1vd61GKjOl6hohpsLpeXyu0nc0aE3GqWJpiM30bDSUSWrLV3dls78z1K2SccbYIW0mQFdviUmI1mMfqQXfiFlyyQT61f5/tc+dzFMEam0g2EjxtuCn+iNCmCbRa+D+dt9urV4L4TPJrs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=ecGu1KaS; arc=none smtp.client-ip=209.85.210.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="ecGu1KaS"
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-6f28bb6d747so3067600b3a.3
        for <linux-xfs@vger.kernel.org>; Sun, 28 Apr 2024 01:09:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1714291777; x=1714896577; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Cr2/pezhFZvy2ti4izAfkmb7Mo4zjJj1mKJct8ejdOU=;
        b=ecGu1KaSF4BC9/wR/c/ZUhvWZOTYc/tr7ywxtedLjjlhZNW7iyBTgVfIsc/envqEpY
         U/p2TuUEJXjcB/zlvoJehCv+kL+MTgrXZkAhgOB6RAtq8Suxay1/V3oJTRTdbbJjEV8M
         rR9Ol/eVDMWsNkDnp0uGADJ1pkDo6WTfsDc+HbimSRa1D7FhALg2/hrZg/i951lbQkH9
         zyKwpBJK1pJSpy5XfBRyt0vq/FamhY7R76Z7sAZi+TXdoDhvilpmTpHhd3JE5lI4UBJJ
         +B1bO+5U1gN3J9J4/mcU5sCtoWYLNvIlayQpgJ2iYQD9wRgLtnMzIwhxfktvirDtVCK0
         /CRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714291777; x=1714896577;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Cr2/pezhFZvy2ti4izAfkmb7Mo4zjJj1mKJct8ejdOU=;
        b=vOkWIT7Oy8Lq6hZZ3GI9U8kNXXt8y+xwsNXPZ/P87hDQ9eXJnSK04aTm2R2qeq8V3r
         IpQCSNS1rfUxsBvGVmP2BR7tjuYOoCZxyd/wF1yKFWq4Y/rdmgs23QQtFOiSoKuC3/Z8
         hvXdPdXX/C6JOmCYpUmZO8Hnqg3xZMFnqOA9i9nVKn929omeX7rxBMU6GoEifHQTLr9e
         g3lnAL69XAoYlzOSLvzMVMcyaJM+cbwlUW6iLak/KuUYdYZupauf2Ew0zTGag+oS8OAe
         qDxxrn1JZockes2DuuKDfHXH8y7ipYtn/lI0ymUtgCpTF90W3mWms4ZpVOdjTjNCOmIy
         sp8A==
X-Forwarded-Encrypted: i=1; AJvYcCVsN9CXsvqlMSAApHY9noT1jeWyAKTFb+mY5J/P2Lhx+GCD8lMHzT3KeH6rgYHyIel2Nb7nXS1xskJTq+OBPd3CwjwNlRbsxX26
X-Gm-Message-State: AOJu0Yz0t4DuEwZmDNolV/voZ+hmoUZIW0Qm44Ui6zlasX14ZaHP0pP/
	MpKA16vpd8rApWHU3GBxWN599tuvuadOOwxHyCFzk4NDp0gJN72spqbBHvJBx28=
X-Google-Smtp-Source: AGHT+IFVq6F6PgiUJXdrmsEFFbPDCdWKUqbzFYW11KIw0Ka/fKJVMKo5MPDPlwhCu84K4aFEZj2KKA==
X-Received: by 2002:a05:6a00:3c88:b0:6ec:ebf4:439a with SMTP id lm8-20020a056a003c8800b006ecebf4439amr9369087pfb.5.1714291776828;
        Sun, 28 Apr 2024 01:09:36 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-29-7.pa.nsw.optusnet.com.au. [49.181.29.7])
        by smtp.gmail.com with ESMTPSA id r18-20020aa79892000000b006ed0c9751d0sm17777890pfl.98.2024.04.28.01.09.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 Apr 2024 01:09:36 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1s0zbJ-00Dfbv-36;
	Sun, 28 Apr 2024 18:09:33 +1000
Date: Sun, 28 Apr 2024 18:09:33 +1000
From: Dave Chinner <david@fromorbit.com>
To: syzbot <syzbot+1619d847a7b9ba3a9137@syzkaller.appspotmail.com>
Cc: chandan.babu@oracle.com, djwong@kernel.org,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-xfs@vger.kernel.org, syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] [xfs?] possible deadlock in xfs_fs_dirty_inode
Message-ID: <Zi4EPfTFLZZibR7X@dread.disaster.area>
References: <000000000000fee02e0616f8fdff@google.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <000000000000fee02e0616f8fdff@google.com>

On Thu, Apr 25, 2024 at 10:15:29PM -0700, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    3b68086599f8 Merge tag 'sched_urgent_for_v6.9_rc5' of git:..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=158206bb180000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=f47e5e015c177e57
> dashboard link: https://syzkaller.appspot.com/bug?extid=1619d847a7b9ba3a9137
> compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40

#syz dup: possible deadlock in xfs_ilock_data_map_shared

-- 
Dave Chinner
david@fromorbit.com

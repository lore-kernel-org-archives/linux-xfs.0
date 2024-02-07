Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E1FE127B53
	for <linux-xfs@vger.kernel.org>; Wed,  7 Feb 2024 21:15:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707340531; cv=none; b=r0cj4xnks9vatiS9Tub68bBqUvfU6YXwgURPKIa5J+YQJjpMdOG0izsUhvDHp1Jy2BZbGGb0i6z3ZXZx+I3DA8GRzrVZM45/jOTKHYr905/gBJikwtyZE4zlnjZzozxoLt+opP6uDakus/zGiqLuydfNt/ww6mk7OhvPJxd/UrY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707340531; c=relaxed/simple;
	bh=19oFLOywtRTDwr5C4A46OzhtascO/FjsYpXHX8JQkGQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nkkb+rEwCVWPL/S+9WuhvHB8yBD2QCJmCKaLonQqRO9OWmZWzGTIsYW/9/JE64VhEfxvTYGfBfE3FbJqxrMW3LF1r2BRZxo89X+dCESWHswYrGB9ueIqI0oZoaFyDooP3XcreZ7S/JQ5XHNuZUxPb4tmAqilK5ex+zsMccNyb2I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=KbwVS21i; arc=none smtp.client-ip=209.85.210.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="KbwVS21i"
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-6e055baec89so207284b3a.1
        for <linux-xfs@vger.kernel.org>; Wed, 07 Feb 2024 13:15:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1707340529; x=1707945329; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=04OQtEbZdH/pUOm6NUHTngrItClskq9Yti7ODoE+vKs=;
        b=KbwVS21i+mVfi3kUN7l4faD+1PsEOcYY8tqP/TvKGm9DThaLcOTHYBTUk0EwtDsbkM
         4hzf9QjWaIaIC0+o4ezhGILesNISMiSMxk9ioGFzHfkHrxodYx7xT4lccX4HquQDOXkh
         cXgotaZ9vL2rRbTli0UL/FCFRMxVBT2JUngp65PynnKK2v1aYaSMz9qblAZzf/+Bcj+t
         5omVRQ2m8ac8MvNnOspevLLigYQ5IkXbKK+yQ/GI9IQjDbtAjFtG5IOmGWH8tfkeivLH
         jPUb78DFCQHBPDrcWn9lmgnDqNqu1bXem7F6qpccaatNR6U/pJsaX3NM9JNc0VzG5Y/S
         WU5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707340529; x=1707945329;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=04OQtEbZdH/pUOm6NUHTngrItClskq9Yti7ODoE+vKs=;
        b=ETaOkd0HK4LIj1Liiv1vfXl6/SaA44ImmETy1AYawe8WBdvuSqZcfm7gCTsHOFGpYt
         puaQ9r3YfAl3N93BZMc5GT+wabWIIdqmLZoZqWMIAHrIiVjdpWEWy5COuN6CewSd8ma0
         fS/o0HOyXG1/teQnQJ22kfGQUaVYVi9EJ4goSXByUnR4NXlYTzrKP3Af3HvHIo1JuZxb
         HfRkMk8/MuEmjA4LiXP2sGR16/ivpi5J7JpS8Ftbmz/iF3sV4PKOxbh6Kicn/QlHpdJ/
         NXbIWXbbHz0n983HUOQgDheWv706J6a1yb8UI9zDBLhGioLM9tBfoHGYUqFgOXQTFcm0
         S0Cg==
X-Forwarded-Encrypted: i=1; AJvYcCVzMezhb1mvc0M4kB43E3nTC1XHKBRK0XS8nCKsNKUbTrdzTq3sItI4jrr/jeJD/U7fSNk7vDVnOaiXnkcbZ1iTxPKTEgsog+F5
X-Gm-Message-State: AOJu0Yxp5R0wMkyJ+eBKgewDxSh/GPz+Kp5ahLpLJO+6PseZOnESQCSD
	So1QqIVadq1ZpwoILVtaTEsSiyg2gow2CznLOJ9BuiZIPCsT8HsIac4j8C5olww=
X-Google-Smtp-Source: AGHT+IHW5jPend1XcjCroAlSsQfuNUH2BCxiWinXUuj9oBba79YI/CYXbOgMa4EIipr05A/LEP2yog==
X-Received: by 2002:a62:f207:0:b0:6e0:5149:3040 with SMTP id m7-20020a62f207000000b006e051493040mr1036504pfh.5.1707340528832;
        Wed, 07 Feb 2024 13:15:28 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCUepmCBRtg9CtTqz+61+TUFDmeXMUFsG6AUptVta3ZOix7VzXdsOe2QipA/7T+glNzueVo0ub1tD7nqsetWHcQbGiZ7VB7Np2f9XSs3Ru9WsDnVzLNK+xhT8/dsIDYIAINbSpD9DCJfzufcmgeoB1ln/LmvLme0qduZMv7Uile4lVkubgjpggjrrGCO8MTZ8sBDocBmkodBIngI861R2Qhr4Fv19J1Tw8fKJMwqgK/yBijNo+8TfK+sFHNG5OAPIElMM9T3r2XIwewo8W9irxKSHTdJSAPf1yoycpcPwA6+wkeEd3+ZMfvLBfrTKGwXaim0gqLygA==
Received: from dread.disaster.area (pa49-181-38-249.pa.nsw.optusnet.com.au. [49.181.38.249])
        by smtp.gmail.com with ESMTPSA id lp20-20020a056a003d5400b006e04c3b3b58sm2186789pfb.179.2024.02.07.13.15.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Feb 2024 13:15:28 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1rXpGQ-003R6W-0B;
	Thu, 08 Feb 2024 08:15:26 +1100
Date: Thu, 8 Feb 2024 08:15:26 +1100
From: Dave Chinner <david@fromorbit.com>
To: syzbot <syzbot+3f083e9e08b726fcfba2@syzkaller.appspotmail.com>
Cc: axboe@kernel.dk, brauner@kernel.org, chandan.babu@oracle.com,
	djwong@kernel.org, jack@suse.cz, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org,
	syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] [xfs?] INFO: task hung in xfs_buf_item_unpin
Message-ID: <ZcPy7sm6SujCXwXv@dread.disaster.area>
References: <0000000000009c7eb105f5b88b70@google.com>
 <0000000000006f69c90610a8edb3@google.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0000000000006f69c90610a8edb3@google.com>

On Mon, Feb 05, 2024 at 01:13:04PM -0800, syzbot wrote:
> syzbot suspects this issue was fixed by commit:
> 
> commit 6f861765464f43a71462d52026fbddfc858239a5
> Author: Jan Kara <jack@suse.cz>
> Date:   Wed Nov 1 17:43:10 2023 +0000
> 
>     fs: Block writes to mounted block devices
> 
> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=176f2d7be80000
> start commit:   d2980d8d8265 Merge tag 'mm-nonmm-stable-2023-02-20-15-29' ..
> git tree:       upstream
> kernel config:  https://syzkaller.appspot.com/x/.config?x=471a946f0dd5764c
> dashboard link: https://syzkaller.appspot.com/bug?extid=3f083e9e08b726fcfba2
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=17a077d8c80000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=14d91c74c80000
> 
> If the result looks correct, please mark the issue as fixed by replying with:
> 
> #syz fix: fs: Block writes to mounted block devices

No, not even close.

-Dave.
-- 
Dave Chinner
david@fromorbit.com

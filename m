Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48CCA31A072
	for <linux-xfs@vger.kernel.org>; Wed,  7 Jan 2026 13:00:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767790823; cv=none; b=SRNe7GT7DFb/Y+0zS+/n8do0iSFimD+jpf518dJ8qYhCAGzkhxVKASOPJXW+F66BQwpWVKd3Wy/w7KEcWBB8HE7N6dQXgnD5C645BdFjRQv4TuECO0sea0/meTRGFPJaNLqfSbtl6Ds4bI0csJPZuif2gHQ3WV3QFCAm9oNC31I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767790823; c=relaxed/simple;
	bh=gjLcioOKjCaArvb7NVQEop76HM4t8V/bf2T2jADtt1U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WoP5Euln6zJYn6kOZUeQGIkNOec4EFltlQuEafBX1YThcJd+HTo4iAsl4QZ/e5SzgXtpthgnMXh+94WNT29LSeZeUimhQh8XJfNq9ZWbAJA1yN+mEpkhZfIgSOxY75NbJgwLUvw/phWmEYbvqVLrjyKvrOkiMRWYxRxvlTrvTBs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=bZPUSTbc; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="bZPUSTbc"
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-4779aa4f928so21415585e9.1
        for <linux-xfs@vger.kernel.org>; Wed, 07 Jan 2026 05:00:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1767790819; x=1768395619; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=b8OM/wM0uqGFQsQ0XBq0KDPlvIR+dfDKEQPKcNmmmRA=;
        b=bZPUSTbcKsWmuTFXDhmekR57ep8iKo0zUD8gRh/csC6HbBjeqN7+J50Yv1ZFkESq8P
         4lqKb9iInxdqD7VLrX78H+Xv3vRz1YSfrh2FlNoHeg1MVY2en3lP4oL9GOVQ790XCb69
         56cvgcJdnHPiZbvb4HU+c0RWNX3Esgece+zPzicSqNQm6/8C8Ilauzv7Z1CRcwPDwX3X
         L55vKF0uDUbDghvs7q8tvt7+YZA/aaw40MKBQYcsUbaWQy3CdQlQgbNpWcVYmj7K89y+
         YPDBcoHQUoEpM+TOl78buQLPv9u++bo+TmLbjudTk6f2AMnvE+GCnk6Q/g8ta6/dF14K
         /A7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767790819; x=1768395619;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=b8OM/wM0uqGFQsQ0XBq0KDPlvIR+dfDKEQPKcNmmmRA=;
        b=KjLFN+GFcTSxHnBq64L29zidO53jnDwoAyX8YQBw/65vFpCuvpkTMnwOtLzv92VmTi
         /VnRhuI54qDpQ6BgZlO1wa2LCIy/7/qpFnZhIp392In55TbFVQP3ZpGmWOuPuzP7ezXO
         YPLPhE/0xVE9zjzwa5Wc05Ul9+UoPuV7PmEd5j2Oj/FI8qJNpyFjonz/gayJDEozY9PQ
         Ys0e1LmCVFRxiCV7iXNtgp8yCSNFr6SBwzTXACdxZgBiKmzXsWUfcO0E8wJbY9X6su0k
         iptbwuSnO8C03UuAIcC9WDqR2t7YiU9Est0qHi9pCMipFiKO0qeGcxUh499rbUt0ir/Y
         gMSw==
X-Forwarded-Encrypted: i=1; AJvYcCVVZE+phmCR3Nkwd1MMdQDesSgcwjs4UQTOves4kNc6tF8bW4AOYjucoucs4a5lY7SbJCe0VrkhSXU=@vger.kernel.org
X-Gm-Message-State: AOJu0YzjjlTvMxm9JnRwip8mmi+pPjqfiuIud1mpHcDp3mb3jgRcPYzv
	itM+ZKr+ixX4ZRoe1rCIL12epHHwT98LaKqiv0unixZFyIAbPEr8GG1WP6rnEasnGp717rj3nHC
	MulIg
X-Gm-Gg: AY/fxX6sZvkQABw0DP+DZcK0Tg5K2nes5aVGNmHhQA4ogy02V3EyXIMRihPt4ugOlTE
	hsv11DDYqrSnJ961aZc2BFlLqCN2mYNnFXZJAR5JW16LrkjEPX7jFK+SAfdPyQxNhKd693+B5Ap
	oObPehcCbrOA5LDztxH24sW3rB9thDS6kJ7ii+BLJjtm6Pp/+owbzEHWWvie+DJo5ued2Vk+Evl
	J+2TgMK/Z3ZX2nNkxynU+YRgADCU4PWJZQFeWawIRycVMQwoLXbyE47N9S2D8mffrjW1R0WvA4S
	Wydb1ZP4cpRcuvh1z/zLbIJ8UidWpC+7VvrCKDZZADvMGp4OhBpLH5fKFI5mlM3V2vX4GgDmfH3
	DnciuX3aBmtfjn12fNJYMctjoMP25dAE+yGQE9yj7zUewniAXHAn4HfeR8Y55+OeDdZ6ZhRt4Ly
	tlAKFYXjZFZetyVw==
X-Google-Smtp-Source: AGHT+IHXv9yotK6XG/wc2JBKVbd7hMIoqMUXk18WTbSVp9IFsDwfj8PCGizKHMxES3PasjFMQuD/Ng==
X-Received: by 2002:a05:600c:c4a8:b0:477:54cd:2030 with SMTP id 5b1f17b1804b1-47d84b32788mr29119595e9.21.1767790818492;
        Wed, 07 Jan 2026 05:00:18 -0800 (PST)
Received: from pathway.suse.cz ([176.114.240.130])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47d87189e54sm11153655e9.12.2026.01.07.05.00.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Jan 2026 05:00:17 -0800 (PST)
Date: Wed, 7 Jan 2026 14:00:13 +0100
From: Petr Mladek <pmladek@suse.com>
To: syzbot <syzbot+9bc8c0586b39708784d9@syzkaller.appspotmail.com>
Cc: anna.luese@v-bien.de, cem@kernel.org, davem@davemloft.net,
	edumazet@google.com, horms@kernel.org, jhs@mojatatu.com,
	jiri@resnulli.us, john.ogness@linutronix.de, kuba@kernel.org,
	linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org,
	netdev@vger.kernel.org, pabeni@redhat.com, rostedt@goodmis.org,
	senozhatsky@chromium.org, syzkaller-bugs@googlegroups.com,
	xiyou.wangcong@gmail.com
Subject: Re: [syzbot] [xfs?] INFO: task hung in xfs_file_fsync
Message-ID: <aV5Y3UG7JMJ0iE_i@pathway.suse.cz>
References: <686ea951.050a0220.385921.0015.GAE@google.com>
 <686f0cd3.050a0220.385921.0023.GAE@google.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <686f0cd3.050a0220.385921.0023.GAE@google.com>

On Wed 2025-07-09 17:44:03, syzbot wrote:
> syzbot has bisected this issue to:
> 
> commit 0161e2d6950fe66cf6ac1c10d945bae971f33667
> Author: John Ogness <john.ogness@linutronix.de>
> Date:   Mon Dec 9 11:17:46 2024 +0000
> 
>     printk: Defer legacy printing when holding printk_cpu_sync
> 
> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=14b19a8c580000

Just for record. It looks to me that the bisection was wrong.
The original problem was:

ci starts bisection 2025-07-09 13:22:22.587055103 +0000 UTC m=+182.380303436
bisecting cause commit starting from d006330be3f782ff3fb7c3ed51e617e01f29a465
building syzkaller on abade7941e7b8a888e052cda1a92805ab785c77e
ensuring issue is reproducible on original commit d006330be3f782ff3fb7c3ed51e617e01f29a465

testing commit d006330be3f782ff3fb7c3ed51e617e01f29a465 gcc
compiler: Debian clang version 20.1.7 (++20250616065708+6146a88f6049-1~exp1~20250616065826.132), Debian LLD 20.1.7
kernel signature: fd86d90e0d4e2b546bda0ba5ad3009b1c803f92f35eefc7a5a9a6a9779edb44a
run #0: crashed: INFO: task hung in xfs_setfilesize
run #1: crashed: INFO: task hung in xfs_setfilesize
run #2: crashed: INFO: task hung in xfs_setfilesize
run #3: crashed: INFO: task hung in process_measurement
run #4: crashed: INFO: task hung in xfs_setfilesize
run #5: crashed: INFO: task hung in process_measurement
run #6: crashed: INFO: task hung in xfs_setfilesize
run #7: crashed: INFO: task hung in process_measurement
run #8: crashed: INFO: task hung in process_measurement
run #9: crashed: INFO: task hung in xfs_setfilesize
run #10: crashed: INFO: task hung in xfs_setfilesize
run #11: crashed: INFO: task hung in xfs_setfilesize
run #12: crashed: INFO: task hung in xfs_setfilesize
run #13: crashed: INFO: task hung in xfs_setfilesize
run #14: crashed: INFO: task hung in xfs_trans_alloc_inode
run #15: crashed: INFO: task hung in xfs_trans_alloc_inode
run #16: crashed: INFO: task hung in xfs_setfilesize
run #17: crashed: INFO: task hung in xfs_setfilesize
run #18: crashed: INFO: task hung in xfs_setfilesize
run #19: crashed: INFO: task hung in xfs_setfilesize
representative crash: INFO: task hung in xfs_setfilesize, types: [HANG]


But the end of the bisection looks like:

testing commit 4ca6c022279dddba1eca8ea580c82ea510ecf690 gcc
compiler: Debian clang version 20.1.7 (++20250616065708+6146a88f6049-1~exp1~20250616065826.132), Debian LLD 20.1.7
kernel signature: 03f8650641fe155806b39e47c854b91bf96ee0d5e9d18ff940235c5a21c89620
run #0: OK
run #1: OK
run #2: OK
run #3: crashed: BUG: MAX_LOCKDEP_KEYS too low!
run #4: crashed: BUG: MAX_LOCKDEP_KEYS too low!
run #5: crashed: BUG: MAX_LOCKDEP_KEYS too low!
run #6: OK
run #7: crashed: BUG: MAX_LOCKDEP_KEYS too low!
run #8: OK
run #9: OK
run #10: OK
run #11: crashed: BUG: MAX_LOCKDEP_KEYS too low!
run #12: OK
run #13: OK
run #14: OK
run #15: OK
run #16: OK
run #17: OK
run #18: OK
run #19: OK
representative crash: BUG: MAX_LOCKDEP_KEYS too low!, types: [UNKNOWN]
# git bisect bad 4ca6c022279dddba1eca8ea580c82ea510ecf690
Bisecting: 4 revisions left to test after this (roughly 2 steps)
[62de6e1685269e1637a6c6684c8be58cc8d4ff38] Merge tag 'sched-core-2025-01-21' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip

testing commit 62de6e1685269e1637a6c6684c8be58cc8d4ff38 gcc
compiler: Debian clang version 20.1.7 (++20250616065708+6146a88f6049-1~exp1~20250616065826.132), Debian LLD 20.1.7
kernel signature: 8e4e982610da69c055ecca8aaca23f23a454eb4db0ee20d8bf6d5ae22aeebb01
run #0: ignore: lost connection to test machine
run #1: OK
run #2: OK
run #3: OK
run #4: OK
run #5: OK
run #6: OK
run #7: OK
run #8: OK
run #9: OK
run #10: OK
run #11: OK
run #12: OK
run #13: OK
run #14: OK
run #15: OK
run #16: OK
run #17: OK
run #18: OK
run #19: OK
false negative chance: 0.001
# git bisect good 62de6e1685269e1637a6c6684c8be58cc8d4ff38
Bisecting: 2 revisions left to test after this (roughly 1 step)
[0161e2d6950fe66cf6ac1c10d945bae971f33667] printk: Defer legacy printing when holding printk_cpu_sync

testing commit 0161e2d6950fe66cf6ac1c10d945bae971f33667 gcc
compiler: Debian clang version 20.1.7 (++20250616065708+6146a88f6049-1~exp1~20250616065826.132), Debian LLD 20.1.7
kernel signature: 7566994b210981fb429e3b5e9ed670407710135484fee131b57299dc8b3071f7
run #0: OK
run #1: OK
run #2: OK
run #3: OK
run #4: crashed: BUG: MAX_LOCKDEP_KEYS too low!
run #5: crashed: BUG: MAX_LOCKDEP_KEYS too low!
run #6: crashed: BUG: MAX_LOCKDEP_KEYS too low!
run #7: crashed: BUG: MAX_LOCKDEP_KEYS too low!
run #8: crashed: BUG: MAX_LOCKDEP_KEYS too low!
run #9: crashed: BUG: MAX_LOCKDEP_KEYS too low!
run #10: crashed: BUG: MAX_LOCKDEP_KEYS too low!
run #11: crashed: BUG: MAX_LOCKDEP_KEYS too low!
run #12: crashed: BUG: MAX_LOCKDEP_KEYS too low!
run #13: crashed: BUG: MAX_LOCKDEP_KEYS too low!
run #14: crashed: BUG: MAX_LOCKDEP_KEYS too low!
run #15: crashed: BUG: MAX_LOCKDEP_KEYS too low!
run #16: crashed: BUG: MAX_LOCKDEP_KEYS too low!
run #17: OK
run #18: OK
run #19: OK
representative crash: BUG: MAX_LOCKDEP_KEYS too low!, types: [UNKNOWN]
# git bisect bad 0161e2d6950fe66cf6ac1c10d945bae971f33667
Bisecting: 0 revisions left to test after this (roughly 0 steps)
[f1c21cf470595c4561d4671fd499af94152175d5] printk: Remove redundant deferred check in vprintk()

testing commit f1c21cf470595c4561d4671fd499af94152175d5 gcc
compiler: Debian clang version 20.1.7 (++20250616065708+6146a88f6049-1~exp1~20250616065826.132), Debian LLD 20.1.7
kernel signature: a7cc6b185bdb5074103099a969663e598b6c2f53f61168a0f2e7c1d9bc9e8426
all runs: OK
false negative chance: 0.001
# git bisect good f1c21cf470595c4561d4671fd499af94152175d5
0161e2d6950fe66cf6ac1c10d945bae971f33667 is the first bad commit
commit 0161e2d6950fe66cf6ac1c10d945bae971f33667
Author: John Ogness <john.ogness@linutronix.de>
Date:   Mon Dec 9 12:23:46 2024 +0106

    printk: Defer legacy printing when holding printk_cpu_sync


Notice:
=======

The original test crashed with:

    crashed: INFO: task hung in xfs_setfilesize

But the bad commits around the potential bad commit are failing
with

    crashed: BUG: MAX_LOCKDEP_KEYS too low!


Conclusion:
===========

I believe that the bisection went into a wrong direction.
And the printk() change has nothing to do with a hung task.

Best Regards,
Petr

> start commit:   d006330be3f7 Merge tag 'sound-6.16-rc6' of git://git.kerne..
> git tree:       upstream
> final oops:     https://syzkaller.appspot.com/x/report.txt?x=16b19a8c580000
> console output: https://syzkaller.appspot.com/x/log.txt?x=12b19a8c580000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=b309c907eaab29da
> dashboard link: https://syzkaller.appspot.com/bug?extid=9bc8c0586b39708784d9
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=15e24a8c580000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=10ed3582580000
> 
> Reported-by: syzbot+9bc8c0586b39708784d9@syzkaller.appspotmail.com
> Fixes: 0161e2d6950f ("printk: Defer legacy printing when holding printk_cpu_sync")
> 
> For information about bisection process see: https://goo.gl/tpsmEJ#bisection

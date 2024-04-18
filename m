Received: from mail-io1-f69.google.com (mail-io1-f69.google.com [209.85.166.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB3F85338A
	for <linux-xfs@vger.kernel.org>; Thu, 18 Apr 2024 04:27:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.69
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713414471; cv=none; b=H8uTyTP5SjPZuzoLMXEjRT2TSFS5yRSKB4wdB+aQ4cVIUjqdVx1A1uwqpXt6sSQ/v1qetshpnhqycRezCZUDfMIRo+hklCQd7nBSfzCez87YbDCGWaBZACqrS/uOsLkUemSaK3TEkAuuBdbLRjmKmEaRBu52rd0iun8IsDR1jgI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713414471; c=relaxed/simple;
	bh=SfG1s1y1fbs4IRvRpyJEItMWdHRLy7BTd3xvVF3hb1Q=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=NBAmUq6y/cxOf+G3WdpnRK3AItVJ8H91qzivkNMi3Fg8ySnXc1iGui/X0jiTPOyHD4/pti4EuSnyP9yqxZ9/PSNS+3KWOPAusa78qi0O+OPd6O9+4JiDxPL9FRQUs5f+yHA3QVFrBuZG2D+qhihrfngigYebpIKy/oNpGnXm4VI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f69.google.com with SMTP id ca18e2360f4ac-7d6c32ef13bso46011439f.0
        for <linux-xfs@vger.kernel.org>; Wed, 17 Apr 2024 21:27:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713414469; x=1714019269;
        h=cc:to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=SfG1s1y1fbs4IRvRpyJEItMWdHRLy7BTd3xvVF3hb1Q=;
        b=uHvdcnUsl4C3XCStFHPWLBJ2lAwxghPEfkBAVtMLcZta8smIhDAxcUlW0xDEdqn6a2
         ED0j8V8Bo9O3E6gw8FORWdD7mgLxYuqNzsafkuHM90sYzeKXaOTb/uJtzsXj/0j2B2rn
         U/HrUFK+xK9T9K9P9Z3UsS5t0pjLknryBTb12ZRC3eld+rEeKAx5mJ+VDpO0CkILz78k
         aDMuqu8mFygjZsyvsnom56P2F9Rv5bHkH+UPwgXNyaFFSv4vqd6ahnvkhaBqhRm7MZsg
         4PyqTk1VvIQSbpEwXSzHvCqzSjOp+/KjskLRN+yVENDgLs3A7p6r19c287bqJ1cD86Ms
         01hw==
X-Forwarded-Encrypted: i=1; AJvYcCVuK7xwqFQT1/M6zLaQ7fe4qiaJLoygLcPWNsS0emusxOYBnZxXLyCCp3Q4uLAlZYgLT90YqS8Xh0LlT5A5PNK/ALpVEKj3Yx6s
X-Gm-Message-State: AOJu0Yykzajl3PNdMCEOXrAbBGQlfTOveP7AKbIQCPQkvXdX33c4MCjK
	P+YFC+qJN5NzgXoOrcBUTXZt/To4WMRi8jKGUVHU6x4FGptXyVEPF9adb3+KUJ91ZmeVTRURC8P
	dvRBER9IbI95zo02wpZhkYySQ3Z8XTR+OxWgV4gLoRUu4bUBxJBIfgEU=
X-Google-Smtp-Source: AGHT+IFwL8qeN80Hv4nk9W+bxA3Mu/wX0/j/+lzG4a9AN7cCSGgQotKYvsLnIC5qQraEK1JJIlW4Sb3AG3WAp6IiyW2Ip0HUyaAR
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6638:8523:b0:482:e922:2823 with SMTP id
 is35-20020a056638852300b00482e9222823mr99129jab.0.1713414468938; Wed, 17 Apr
 2024 21:27:48 -0700 (PDT)
Date: Wed, 17 Apr 2024 21:27:48 -0700
In-Reply-To: <20240418042740.313103-1-aha310510@gmail.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000c63725061657646d@google.com>
Subject: Re: [syzbot] [fs?] [mm?] KCSAN: data-race in __filemap_remove_folio /
 folio_mapping (2)
From: syzbot <syzbot+606f94dfeaaa45124c90@syzkaller.appspotmail.com>
To: aha310510@gmail.com
Cc: aha310510@gmail.com, djwong@kernel.org, hch@infradead.org, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, linux-xfs@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

> please test data-race in __filemap_remove_folio / folio_mapping
>
> #syz test git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master

This crash does not have a reproducer. I cannot test it.


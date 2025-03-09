Received: from mail-il1-f199.google.com (mail-il1-f199.google.com [209.85.166.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43F67187FEC
	for <linux-xfs@vger.kernel.org>; Sun,  9 Mar 2025 16:20:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741537203; cv=none; b=kHkbScX7DdzSWTMMtwSwQGgGAjKHlIeQfwfJspmQDDHYM+uie8G3w84tqr5Qttx9Rhqc2NP4nwJeI9TMfmsUjTWv5JOJrAYj3FnXx9xlbo89B9lb+xxYPpz0D8dVgE0IpmtSDg0KievCPylroZIX0nIB1sXRpb85hjynjcD4sBg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741537203; c=relaxed/simple;
	bh=UJv+3p818hAynouGODGqPemY4sdL2sg5sl1CQD4WCAY=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=KWnbnTu0IE6EIqF39DPuaz4fbu2Z/ywQK0kNk0BGCfo6SsmdXO3fUvYA96VCaEPjgbGbUrKRBrx8BFA1N/+/7elNb+RzNoX4EwbuvFPgTwnvn3N7mn7vNTFFc/03JXAWC9q/oA/jw3GYzP4+1e5KrFdvFEjl/69M4Mj29JzNsAg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f199.google.com with SMTP id e9e14a558f8ab-3d43d333855so27310155ab.0
        for <linux-xfs@vger.kernel.org>; Sun, 09 Mar 2025 09:20:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741537201; x=1742142001;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=kvHzXY7sxLiJE9tWVn3P+7dA0tfrkLHjWoYFez7ztlI=;
        b=L6bID3vBVKOOUBylRI9AkOvy517qQWEi5CYFh8bP9JKlJlvDvX/PrBkaqnmidx2m6l
         d5Gh6ECyzLh7VaHnIMogzv5iuWxFKRMLIk41EA1X4MsaL5zUxccyjAI+7LsTgFqlV7z2
         6hEOisGyGhgAFYOVIOFV04qX8e56xo65KD8VJFGbI85v6FOU51nGoKPYqXUlFOmGkCBL
         vKYgemGvCWil8k+Hf4NCyfPotPeEmGTjfKKOY7b7oEy/crUzpsO/L6+LnIuueYBGOQ0H
         uL2gjdPwnaC+kXOXiVEO4z6pYeXNrtTlllBSAiD8Iz65/gAjzW8ZC4G/aSR20PEuuZFq
         3fJw==
X-Forwarded-Encrypted: i=1; AJvYcCW6RZe9uJR6n0sP+zQHb+ji+PXVNlNPlWoI9Lti57NOhWtzqzmSiO5+aNISR1XTyPAyNUpmhLRFEyc=@vger.kernel.org
X-Gm-Message-State: AOJu0YxW+iabSqQMyqGAV9qdEdTtrdR9amR51ExO9IPYJqeZBWXFsZtt
	IekrgYwizpa8rwNwzNnV7Bz8fkFJaginfv2NF0PaOm7nlXgwbEhZJxhM+qI+pyD9I5YljXIvVQz
	ONXVOQi9QuotROM0Tnos97XruDAWkt6Hchn2BXtn8gU3tT9mR1lEV9O8=
X-Google-Smtp-Source: AGHT+IGzBV6/Mmw1jYJbp4k4xeAwt6EP5l8CLTLHNIXSvmWfgnNG3Eq5hlJ73B1hltOvdNhKNoHGM4Vwa3Q3wdVte9AmRIZsV4VY
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:240b:b0:3d3:fbae:3978 with SMTP id
 e9e14a558f8ab-3d4418ed8e7mr107345105ab.9.1741537201441; Sun, 09 Mar 2025
 09:20:01 -0700 (PDT)
Date: Sun, 09 Mar 2025 09:20:01 -0700
In-Reply-To: <CAOQ4uxj49ndz2oJcQMhZcXTAJ+_atUULNLPzLAw-BLzEdFwV+A@mail.gmail.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <67cdbfb1.050a0220.3d01d1.0000.GAE@google.com>
Subject: Re: [syzbot] [xfs?] WARNING in fsnotify_file_area_perm
From: syzbot <syzbot+7229071b47908b19d5b7@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, amir73il@gmail.com, axboe@kernel.dk, 
	brauner@kernel.org, cem@kernel.org, chandan.babu@oracle.com, 
	djwong@kernel.org, jack@suse.cz, josef@toxicpanda.com, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, linux-xfs@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot has tested the proposed patch and the reproducer did not trigger any issue:

Reported-by: syzbot+7229071b47908b19d5b7@syzkaller.appspotmail.com
Tested-by: syzbot+7229071b47908b19d5b7@syzkaller.appspotmail.com

Tested on:

commit:         b63f532f fsnotify: avoid pre-content events when fault..
git tree:       https://github.com/amir73il/linux fsnotify-mmap
console output: https://syzkaller.appspot.com/x/log.txt?x=11fd1fa0580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=afb3000d0159783f
dashboard link: https://syzkaller.appspot.com/bug?extid=7229071b47908b19d5b7
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
userspace arch: arm64

Note: no patches were applied.
Note: testing is done by a robot and is best-effort only.

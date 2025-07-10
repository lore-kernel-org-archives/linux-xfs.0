Received: from mail-io1-f72.google.com (mail-io1-f72.google.com [209.85.166.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FF8018E25
	for <linux-xfs@vger.kernel.org>; Thu, 10 Jul 2025 00:44:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752108245; cv=none; b=fxo1WtTv/1QSHBOTvuMiJca6oJlnGD6+Q1MMIVyRXyYpwhrLhSHYnZSlB5pM34E47N3ER9bkX8wA8eh19vSPS6MCvDHgl9qv5serDTipSQBmzGrrxyJ0RB6z9gQ3FP3K/+8EFp4LqDP/zzTljd6VC+s4tOXpNcjcCVL0VxmWfJc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752108245; c=relaxed/simple;
	bh=GtFfO5UBSQpd6M3n0qyyFSGpUGz7IH8edCIj/6qkjNI=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=qbHdCpezwthLsxZboy6atLUqNObQb6H5FuoPyq4zHJWCEaYeZJRoJib0HNrjsmgli095e2bxrZwVnTSXv2B2tP6urfkVem/RD0QN+c3UWoSC7RsXbWoUg2GDPm4CNbMQfbmRR9R7WCQsrobfFFrDWPKHjaKkcvTDdbxcFt31RcE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f72.google.com with SMTP id ca18e2360f4ac-869e9667f58so112030839f.3
        for <linux-xfs@vger.kernel.org>; Wed, 09 Jul 2025 17:44:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752108243; x=1752713043;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=P6ubFXBJaVX9NJ5Nijg0B0BPCDcgJxeSI1/VddLlHAM=;
        b=RAXJ5Z+CuKiy4NNJbgUbu/sIufYJEHgMNM3D2mV+nMCn8cKRDV+eXiedwTvT3UeKnG
         s4k8QGvcvyn4/V1QUj2d3gTZoU/vW0DZWWaFzSI7VZLlkhBpPln6Mmx62v4qgCbKF8H8
         b354gH9MGX2AkI4YmUG7/pFLtWn91E28ZDhdyGYQcV5EuEoXlM5OmBKpev5Co3bfOYx2
         m1ZfJpw6nRuKtgYCjYUSebWKjo2agYZ5pWPwKd27ggaAovJ3HOIq8ALx6gcjzEdiC7mz
         oa/BHHcdr6qBdY7EefBQiBK94HkVJutiybnpmCxlTV4sjC+CsC0JrZJ1w4uJ80v7rXoC
         U+DA==
X-Forwarded-Encrypted: i=1; AJvYcCWSu13KOJhgYghVLArojHfrQjTJUy1dv6gKMx6/EbnZz7tLLG26uXLcQFNBoZ4U5Pppfrp5HrVhEvE=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx+P5nJ2VKIg3lYZuZsYauPRZirky7boiIR9NpZTzn30TIPu41W
	JroNiRWz/OLF1h5SSDBNyNam+Dh/NnCOwWqwfFBH+ZyEmFhTT2MsX3LCb+hIJrkRzL87Wa3MTaH
	u11hv6ftHxNkkrqFMMIEOVPJl6GqGeZ0gGlmPM/SbmBCTNLYT5cUKYEhAOW4=
X-Google-Smtp-Source: AGHT+IEEZTrsGg61LrPeklxaxuumgz77c9VLsfiGovZIPBLMORTLfebejWKSzMwqiccyUFrmz9OwM5HLJ3KvEiSnw5pXU5bjBcFZ
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6602:408e:b0:864:4aa2:d796 with SMTP id
 ca18e2360f4ac-87968fe0bedmr74344039f.8.1752108243595; Wed, 09 Jul 2025
 17:44:03 -0700 (PDT)
Date: Wed, 09 Jul 2025 17:44:03 -0700
In-Reply-To: <686ea951.050a0220.385921.0015.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <686f0cd3.050a0220.385921.0023.GAE@google.com>
Subject: Re: [syzbot] [xfs?] INFO: task hung in xfs_file_fsync
From: syzbot <syzbot+9bc8c0586b39708784d9@syzkaller.appspotmail.com>
To: anna.luese@v-bien.de, cem@kernel.org, davem@davemloft.net, 
	edumazet@google.com, horms@kernel.org, jhs@mojatatu.com, jiri@resnulli.us, 
	john.ogness@linutronix.de, kuba@kernel.org, linux-kernel@vger.kernel.org, 
	linux-xfs@vger.kernel.org, netdev@vger.kernel.org, pabeni@redhat.com, 
	pmladek@suse.com, rostedt@goodmis.org, senozhatsky@chromium.org, 
	syzkaller-bugs@googlegroups.com, xiyou.wangcong@gmail.com
Content-Type: text/plain; charset="UTF-8"

syzbot has bisected this issue to:

commit 0161e2d6950fe66cf6ac1c10d945bae971f33667
Author: John Ogness <john.ogness@linutronix.de>
Date:   Mon Dec 9 11:17:46 2024 +0000

    printk: Defer legacy printing when holding printk_cpu_sync

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=14b19a8c580000
start commit:   d006330be3f7 Merge tag 'sound-6.16-rc6' of git://git.kerne..
git tree:       upstream
final oops:     https://syzkaller.appspot.com/x/report.txt?x=16b19a8c580000
console output: https://syzkaller.appspot.com/x/log.txt?x=12b19a8c580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=b309c907eaab29da
dashboard link: https://syzkaller.appspot.com/bug?extid=9bc8c0586b39708784d9
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=15e24a8c580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=10ed3582580000

Reported-by: syzbot+9bc8c0586b39708784d9@syzkaller.appspotmail.com
Fixes: 0161e2d6950f ("printk: Defer legacy printing when holding printk_cpu_sync")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection

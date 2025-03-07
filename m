Received: from mail-il1-f200.google.com (mail-il1-f200.google.com [209.85.166.200])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B80523A99D
	for <linux-xfs@vger.kernel.org>; Fri,  7 Mar 2025 16:21:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.200
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741364464; cv=none; b=RZyHK+HWN6qr/f4LoAkEvt83oprofvwJ1XL15mY4JPYquMVgn34+mUaLjgRQRL7HDXqI0ISIRLAFmPbgHxOux4KTDEVhpLznWDK113OaFo3NwL+ec9JqdxR/8An2U3VYSWadDGS/QirxV0+fCNPMS33Tg1sGAURix/Lt09g+Low=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741364464; c=relaxed/simple;
	bh=NtertMuEVLb4GQJzbCtunKWOV/Sy4gysXnmuTeY8Afc=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=Huq2Gx00UlWd6L2n3ywH+aTyBn/i6ae4t9kYB9IL1EF5h6OuyElwvC6Y9VkcZShTStiRhoOmeyzvQAqCx7On6fXpjElN9oOVLCNt2UNxNbSoKz0XEs5a0hQrV+hrFRUH6g/s9JtCA7/Kw5Lu67pE9CBc+rnb/p+tvUmPElyR6rA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.200
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f200.google.com with SMTP id e9e14a558f8ab-3d054d79dacso37897105ab.2
        for <linux-xfs@vger.kernel.org>; Fri, 07 Mar 2025 08:21:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741364462; x=1741969262;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hqoZmbhmrm3Wo0MivXF1llagCoU9e35MwSyCFLjrWUs=;
        b=c+c8ig5PoPJhsocLI+oLLx/q/YS0I18LuDzvziL1kiBH6DlgJbBLa4j3uTfw0Ahrz8
         V9hTaB1PvBxXhfXPjrRYVJIKzEiXmru/0WdryjjCEJXoO9qIaSYhllDGnZvUwuUnsDmC
         kURg1QfSYRKkCCxzSdd9+ieGai7UrVNralDJjEGJ6rU1YaZeWAZlwlkQsm8B4Q+dEksZ
         tP4d4EVA1Y4ADCX2jhhnNvLtuNulQ2SaX22+U0VykozHuaUogIyS5SfIKlWnsDck9Z5Q
         ey0k2fSYLwth+EKze+TiaoA8AnyrlWMnQX1kiDDi87Q44hlpSzexU9TfRolrFCrLzQU+
         c00g==
X-Forwarded-Encrypted: i=1; AJvYcCUr7FZlOCJbvDGZD2l5s3n71ksZ/kSsOVXGGjWF/87ORfYkvmqh+HOZwqqsaz80ld31woQqG1cnGo0=@vger.kernel.org
X-Gm-Message-State: AOJu0YyfuMlQ22NvbrPBFdjd12IlwN+JgdHJm3S7zvMDSXbS2iRT7Ubq
	/6GtndyT0wdqQx4c79twz/WTLjWPGNhx7KcnHIB6NWvqB3hz+846B7JyD+2mDXxYuOWAaubJrHz
	2yy5CZFcLJTJi2dL22XNBOf+KxOr5OtsoWLrtR55QrCfFZO+fifmQgG4=
X-Google-Smtp-Source: AGHT+IE2nPYnITDZFp2SAZViHoxjw6aguupsRSsmbyNsC89hqZr0PErp4tSqaFr1UoOWuFXn55n8KZ94RFEwvPF2I/+bF0BN3faJ
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:2168:b0:3d3:d28e:eae9 with SMTP id
 e9e14a558f8ab-3d44193d992mr52659425ab.7.1741364462402; Fri, 07 Mar 2025
 08:21:02 -0800 (PST)
Date: Fri, 07 Mar 2025 08:21:02 -0800
In-Reply-To: <CAOQ4uxizF1qGpC3+m47Y5C_NSMa84vbBRj6xg7_uS-BTJF0Ycw@mail.gmail.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <67cb1cee.050a0220.15b4b9.0082.GAE@google.com>
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

syzbot tried to test the proposed patch but the build/boot failed:

failed to apply patch:
checking file include/linux/fs.h
patch: **** unexpected end of file in patch



Tested on:

commit:         ea33db4d fsnotify: avoid possible deadlock with HSM ho..
git tree:       https://github.com/amir73il/linux fsnotify-fixes
kernel config:  https://syzkaller.appspot.com/x/.config?x=d6b7e15dc5b5e776
dashboard link: https://syzkaller.appspot.com/bug?extid=7229071b47908b19d5b7
compiler:       
userspace arch: arm64
patch:          https://syzkaller.appspot.com/x/patch.diff?x=16fe4878580000


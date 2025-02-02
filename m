Received: from mail-io1-f69.google.com (mail-io1-f69.google.com [209.85.166.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B71B1F542A
	for <linux-xfs@vger.kernel.org>; Sun,  2 Feb 2025 15:08:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.69
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738508885; cv=none; b=sLIxLobP86Im7kwdI+3zIluNX29UZHhAbGKtE3kxKZP1HXQt7seuHg7ZWnkaQGc7OaPUM7CVFFaUISsvytlh1uxALIRKXoDxVJjMacB7faxhhgONW2VWi6TZ0bftCByrajxE2ZZewKKDZkiMexbDH7VPc7w+ZvzWIe67VwP4mMg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738508885; c=relaxed/simple;
	bh=X7yd2+qFNeEAS8UzBFjEEjjbiRWfQSFMD+J2voO/PLA=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=e3c59XWoVYXrFhuQ29S1muRRwM9rNBlpbmksxuaLYGx8EkJFQRmA7Xs8goH8zzYmcUyXaFHfjV34xgVUUtKn47NLI5mCxVT9PtvKKOscADu4P8msqWhLmIn3C2beB8/LHMqPB+w72vBN/Ge8gDXwy4dS5ywJvKmX5BxziRNLP64=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f69.google.com with SMTP id ca18e2360f4ac-854a68f5ae7so183701339f.3
        for <linux-xfs@vger.kernel.org>; Sun, 02 Feb 2025 07:08:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738508883; x=1739113683;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=as8jRmBqhydUDXs/90pySCuCHeb3fP0O7KZ+qpwNogc=;
        b=P1LtH4DAmdgOk3SUmoMn2lnt/BCYkYqb9PZcAAa5hmagKesHwCxlz0y6EhJ7Fhfjvi
         AdDhT509HMQhXuLIQ4V1UQJMAuHd7MzKQbUnjpWqyxsMGG3dSC740z5WLsH21gEbcq5x
         xnGRvZ0VOLaopWT3SnUNQGTZ7whKvgk6fw0Z5f8ST576wah7PI8x+GCy+OzBHqMJCiSh
         Sqa3b5k3ww/nmnE/Yqo1fTy4orGNfn1ZeHE74Uq0Ze5oxyIxQfxIRYyvkugouDdrSP1b
         ZJzDPDV7vPDOQeAAL1YcLjF/5ctH/41I4qfSHjV1TILBRyaTMp9w45Qmo3i43nnbvz4g
         Sx8Q==
X-Forwarded-Encrypted: i=1; AJvYcCW2E+mtufvd6VLDcGVOyfKEpkJEbRmzhcuk9xyEPKRUE/KTdxn38GUd+pNSt0CDFgGZmV/1kfZ7yOQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YxZ27EU1ZRbhiZ1K1L+bGuUFKvVCiiwgdl9XE83F9MBP2qXaX8w
	z7ayO/rMHHQM7Zyy7Rs66U8nX7dyZJTPzqnwEgNG+a/onq6C7AKG9d5K5l43+y5mRhw+DM/XmTr
	mmPklmcqC50P/tVIQk1dCuVMOpp13QS0RHv33wsZeswlKcDt7Rn8eDYM=
X-Google-Smtp-Source: AGHT+IEyT6hh3PLCefTt8R5zupg7eSLCcrw1zcw0pQj/rzpMk5ZriYXQfwbK7UrNl+4HV97Y5tsvO9wCAJT+mxxtrZoX+v24BD8O
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a92:ca4f:0:b0:3d0:24c0:bd4d with SMTP id
 e9e14a558f8ab-3d024c0bfafmr51172895ab.18.1738508883278; Sun, 02 Feb 2025
 07:08:03 -0800 (PST)
Date: Sun, 02 Feb 2025 07:08:03 -0800
In-Reply-To: <6798b182.050a0220.ac840.0248.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <679f8a53.050a0220.d7c5a.0070.GAE@google.com>
Subject: Re: [syzbot] [xfs?] possible deadlock in xfs_buf_find_insert
From: syzbot <syzbot+acb56162aef712929d3f@syzkaller.appspotmail.com>
To: cem@kernel.org, chandan.babu@oracle.com, djwong@kernel.org, hch@lst.de, 
	linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot has bisected this issue to:

commit ee10f6fcdb961e810d7b16be1285319c15c78ef6
Author: Christoph Hellwig <hch@lst.de>
Date:   Thu Jan 16 06:01:42 2025 +0000

    xfs: fix buffer lookup vs release race

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=1193ad18580000
start commit:   69b8923f5003 Merge tag 'for-linus-6.14-ofs4' of git://git...
git tree:       upstream
final oops:     https://syzkaller.appspot.com/x/report.txt?x=1393ad18580000
console output: https://syzkaller.appspot.com/x/log.txt?x=1593ad18580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=57ab43c279fa614d
dashboard link: https://syzkaller.appspot.com/bug?extid=acb56162aef712929d3f
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=174cd5f8580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=162e2d18580000

Reported-by: syzbot+acb56162aef712929d3f@syzkaller.appspotmail.com
Fixes: ee10f6fcdb96 ("xfs: fix buffer lookup vs release race")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection

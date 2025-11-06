Received: from mail-il1-f199.google.com (mail-il1-f199.google.com [209.85.166.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0214B261B8F
	for <linux-xfs@vger.kernel.org>; Thu,  6 Nov 2025 11:06:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762427165; cv=none; b=puq0M5ZIISNII36dgRSc8qQtrgAuf7OqkNy4TQ0BfkGdJZUr3jw2Kw1DXNvX6yvow3q2xpFjB9wViaoIUzFpEPr95eBD5XQ+ZmmtP8gyVK2uWw/gPnsBR3Mf4q0a6AYCYWOUgQKCzryUKypHQroNvqNvzf3J7Af10YsTz5mknhI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762427165; c=relaxed/simple;
	bh=MDxxMhIORU1N6H7vl53fjvMx/eCJgCUEAWu06Xd4fyo=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=TXEm61Xrq1Vbgk52dj2zS3tmb+4l/VLi9AQC/GQrWIby0qfUinTqPOTiyNI7OL0Yrs14iaqmZQoNX01HGDDIAeAq3t9bU4gx/E5dI4AmaqDFgKZhF+fyCahUs47h1tLSAb3N+XBZc7Xpmh1rgyZRs7l8fmNsvMEGcmy6gy9FjuQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f199.google.com with SMTP id e9e14a558f8ab-433312ee468so1785325ab.1
        for <linux-xfs@vger.kernel.org>; Thu, 06 Nov 2025 03:06:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762427163; x=1763031963;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7YLmpBcJQQJc3uvBPyux9aBsbuqfkQpqtFUsIwakHSk=;
        b=krCEKPloYLcnzMEHs4y4fkGaK3w7yE8b3ya9f0l4aoR/GTmQWmlgziclFJgc/TOtjd
         rZZ5HJE8fpqKAsm+/gGMZV2WLdFVv2WOzZ0o9m3hN9MZd3JKqNQFJZAGzrjQQiQIOfTs
         efHpeXETG7D12T52eXNIYvyYk+YlL6jLhieK/xU4VF8hyhKqtBFYI5UDIfN0GjX0ldG1
         8RAvpzdURQ8JTdk4ALY61Ap8lpFxPlY9GxKC04ri8dE7WgQUpeorAsYvV6UiLuyei3DF
         /gK06k9y4ZdLcamqnRQEOfxcUsa4dCDt7qXn8sPb68UpTat3BTGOMjakrmt7bHe0uEPm
         SYLg==
X-Forwarded-Encrypted: i=1; AJvYcCXrzeMXOR7nnC22Gw+uDx18Znk0qxlx1nifYzbWdRPiuHW/AoGAzWCuWsj5PYA7Iou6HB0/OfHEXnE=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz5u2KhXW1vkTQ6sYtDVcMaiP92LGi+K3+c7XHz34+4kkHhrHV4
	oTFATnjkxEWrEkA5OTI1xxz7nUvZPUXzTOJMkFT15pKRaN9xh2AZzfFARATPpwqUWmVLdmhLI32
	hXSwTn2K5OAPghQRBZTb6IHY3StSbnFyF/kkAqPMxl5qLsAM0dwv0UOZsLks=
X-Google-Smtp-Source: AGHT+IE/u/KUDmfVhtAT+bF/JPkOxMXgQqhGjaEF35rveLN7I4NxGZIDTM47S3PtW6CsTFA7cmt9IEyen43RF5wsFZCo3/mO09du
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1567:b0:433:2400:2eef with SMTP id
 e9e14a558f8ab-4334ee78384mr39296765ab.13.1762427163097; Thu, 06 Nov 2025
 03:06:03 -0800 (PST)
Date: Thu, 06 Nov 2025 03:06:03 -0800
In-Reply-To: <6774bf44.050a0220.25abdd.098a.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <690c811b.050a0220.3d0d33.014d.GAE@google.com>
Subject: Re: [syzbot] [mm?] KASAN: slab-use-after-free Read in filemap_map_pages
From: syzbot <syzbot+14d047423f40dc1dac89@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, chandan.babu@oracle.com, david@redhat.com, 
	hdanton@sina.com, jgg@ziepe.ca, jhubbard@nvidia.com, kas@kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, linux-xfs@vger.kernel.org, peterx@redhat.com, 
	syzkaller-bugs@googlegroups.com, willy@infradead.org
Content-Type: text/plain; charset="UTF-8"

syzbot suspects this issue was fixed by commit:

commit 357b92761d942432c90aeeb965f9eb0c94466921
Author: Kiryl Shutsemau <kas@kernel.org>
Date:   Tue Sep 23 11:07:10 2025 +0000

    mm/filemap: map entire large folio faultaround

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=12658532580000
start commit:   b19a97d57c15 Merge tag 'pull-fixes' of git://git.kernel.or..
git tree:       upstream
kernel config:  https://syzkaller.appspot.com/x/.config?x=292f3bc9f654adeb
dashboard link: https://syzkaller.appspot.com/bug?extid=14d047423f40dc1dac89
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=12399442580000

If the result looks correct, please mark the issue as fixed by replying with:

#syz fix: mm/filemap: map entire large folio faultaround

For information about bisection process see: https://goo.gl/tpsmEJ#bisection

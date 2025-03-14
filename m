Received: from mail-io1-f69.google.com (mail-io1-f69.google.com [209.85.166.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2367170824
	for <linux-xfs@vger.kernel.org>; Fri, 14 Mar 2025 16:19:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.69
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741969146; cv=none; b=TkHLggskgL1RMIQ56f0DaOoH5SKoa3F3LAWWZ88v/YFP5vTaqWzuO3Lio3ChpmHMdjz6Nlnn2+ViSC+c86FLXdDJI31XeROOq8kvUQAYJEc7QvIdfCqqFAmpfKv+CxGU5XkiG3FUhHHs8c2sFVuuCPy6CTo2pOXBEgLLIvMWKJ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741969146; c=relaxed/simple;
	bh=1PyPhPPPXzUrW81edLk/hVexOnLGTmWk6S6oTJDjr1g=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=ag87vlD7soNoE6FNdxtAZNIev5LeLNNl8Jw+rpfY+2eiIqhgSqkhdB3SPc102he7ANTcc1GTB2QrxGRaIXeZnjUh8S31FSBIHY7yz5+uEwydYUfXc37LUbHkaPd4XPppD8PmFoMxCfGEGDXpd0o13xg+bT/Ak8sj22O06m3MlD4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f69.google.com with SMTP id ca18e2360f4ac-851a991cf8bso302925739f.0
        for <linux-xfs@vger.kernel.org>; Fri, 14 Mar 2025 09:19:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741969144; x=1742573944;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UxgpvdqPX3ylkbOIJHtNR/2q3jsEmcofJWs1Q6fg4hM=;
        b=JP9CpA9xLI5ezIbugyHuKPfCTdI39iYeaD5vVI+0RJMB/aHopn8zw51NZkfNtQYAet
         anMMMMIuBRYxlJCh8YT3zLgC+p0w9c24wz8UsSxvJTDpcTGWZ8Nab+RUKAjJJRsRr8Jk
         oX1x+WuaBGudeNppHOquRuMGFANnN3lqmM+S1xE4qLGX576ABQ0D0bVZv8EMdE88bqxU
         VNN0lSZw5aEgyawgv1ozNjgamlsq5zIWa5BxHQxLjtXDbW0J0GCB2o6tmH69Z5U3wYxj
         IrWtGOVf9d1zHaHFH8Eb9WNkjiJG2V2xPsW2kFAcEgo+p6okoHv8kARsiY3qzWWzwsKW
         R/3Q==
X-Forwarded-Encrypted: i=1; AJvYcCVTsZYYMlhL5pdSf0lLCjOX3OhcnbRXzjJGNgjvAKTlTrzvC7mXrQzC5IUTGeJ31k13ACQyZ1OqOsQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YxuBhhtuYLZWEDVMsS4JXErRl1sBzm1SZWoZyWXfyWxCRvor2GG
	Lkqi3wQerHqNzW2eZCNSFi5EQOY8Zo9vbROG8LsWRsMCEttjQhIUKleOXMhKOnLJ+UCv1L7uB6w
	xmXyVpXrSTqDAQRv2i4ip3x874w2H5w/T0sJ1pGTPlvKK/azXSOSpFKQ=
X-Google-Smtp-Source: AGHT+IEE3iUoDMvt6vpYaKTf9X03mBdBOF392XsUet07v7oD5JzD+kITjp+U2pfYs2O9VOBXHhH9vfIZPElBK0LwW6g4S9LoSoY6
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a92:c503:0:b0:3d3:d156:1dcd with SMTP id
 e9e14a558f8ab-3d479f6b87fmr60200315ab.1.1741969144137; Fri, 14 Mar 2025
 09:19:04 -0700 (PDT)
Date: Fri, 14 Mar 2025 09:19:04 -0700
In-Reply-To: <6798b182.050a0220.ac840.0248.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <67d456f8.050a0220.14e108.0047.GAE@google.com>
Subject: Re: [syzbot] [xfs?] possible deadlock in xfs_buf_find_insert
From: syzbot <syzbot+acb56162aef712929d3f@syzkaller.appspotmail.com>
To: cem@kernel.org, chandan.babu@oracle.com, cmaiolino@redhat.com, 
	dchinner@redhat.com, djwong@kernel.org, hch@lst.de, 
	linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot suspects this issue was fixed by commit:

commit a9ab28b3d21aec6d0f56fe722953e20ce470237b
Author: Christoph Hellwig <hch@lst.de>
Date:   Tue Jan 28 05:22:58 2025 +0000

    xfs: remove xfs_buf_cache.bc_lock

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=17fb5c78580000
start commit:   69b8923f5003 Merge tag 'for-linus-6.14-ofs4' of git://git...
git tree:       upstream
kernel config:  https://syzkaller.appspot.com/x/.config?x=57ab43c279fa614d
dashboard link: https://syzkaller.appspot.com/bug?extid=acb56162aef712929d3f
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=174cd5f8580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=162e2d18580000

If the result looks correct, please mark the issue as fixed by replying with:

#syz fix: xfs: remove xfs_buf_cache.bc_lock

For information about bisection process see: https://goo.gl/tpsmEJ#bisection

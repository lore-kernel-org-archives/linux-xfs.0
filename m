Received: from mail-oi1-f173.google.com (mail-oi1-f173.google.com [209.85.167.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59A2BEB8
	for <linux-xfs@vger.kernel.org>; Fri, 22 Dec 2023 02:06:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iGxKGhEo"
Received: by mail-oi1-f173.google.com with SMTP id 5614622812f47-3bb6e8708b7so934328b6e.1
        for <linux-xfs@vger.kernel.org>; Thu, 21 Dec 2023 18:06:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1703210779; x=1703815579; darn=vger.kernel.org;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=UCuvXgGVBllnF7kYrwGnMP7O133slTvNR4ZyKlkSLi8=;
        b=iGxKGhEomNZUZe6u3cD/jtzO+5MqreXN5sel0nNa4oBxN8ujyI92sDgtN12do+uNvs
         ZeEzrcFAd6aqsBA+sQos0bIlZGvqNSf9UuZrf2EIL/u3B9oq+W7aJdpITh/vZXgPbSLf
         dD3l1r3xqymbd1PEHFj5//u3Lg0Xov74GlAmYf34MfKbJLnoslC8+wqUKmBVy01zwlVx
         gVp40pbBtBR8O2PXtjP36YQZsj3LNDX3xUrYn6A0NdX5CAVi7fDFXxVARCVhTdQG3zux
         7mj7dg+9b2ELmdpoNx/RTGPFYQfakl79JygBg0BuRJC4e0+PC/50497u51IOyKzjpjbj
         kCqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1703210779; x=1703815579;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=UCuvXgGVBllnF7kYrwGnMP7O133slTvNR4ZyKlkSLi8=;
        b=aOEIlYo8owZqvzn/J6JvPb4HrrivkFBTBb4k0Bc2POL+y1Xt0HG6lceJpQqpNJqIqF
         L3BkKtKXkCEBpy/PXnyBghbm7Xp2D5GMv5EJErdqV2js+1d+nI+Ya5IHlU9+pGezChgq
         7jTiQdYW9Pn2sriXBRbAU0F3x0Aai6M9x6Q8Iu9WPnhNqWPkxOOWPl6pcCW7zjb1MD91
         kC9OS7c/UPw3yIxGhS/geSYPVwTeICB+jmoBijqDSZRESOqq5GFVHrPA5dxAvaStQwgd
         Iwi5GS969Ur3na/yJgOs0Z8CMwq2GbtaImDRBVn8izPb3ClO4HZ2r63Ak8Zr1LBPA5Xv
         VC4A==
X-Gm-Message-State: AOJu0YzXMFcEjlyVyppNz/khbXNfvctvWbGvV7b6jLpqQN+y/SXq/IvD
	7AVrSv1eskFDoGxZ1XyS8uCgRgT6Uxm7FDYR8YqQuBjlSAw=
X-Google-Smtp-Source: AGHT+IHKrT3QUcBZptrEBQrhy894otshPbZTFQDMzcsq3AjNdqKuyXlGlkp8qVasR7T4UO8cmok3pkVUOy2SThnaClo=
X-Received: by 2002:a05:6808:650b:b0:3b8:b063:a1da with SMTP id
 fm11-20020a056808650b00b003b8b063a1damr590179oib.100.1703210779281; Thu, 21
 Dec 2023 18:06:19 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Phillip Ferentinos <phillip.jf@gmail.com>
Date: Thu, 21 Dec 2023 20:05:43 -0600
Message-ID: <CACf8WVvuBpDwMdTor_oGobAKG6ELyUMmm4-HAu--eTfZqF5+Yg@mail.gmail.com>
Subject: Metadata corruption detected, fatal error -- couldn't map inode, err
 = 117
To: linux-xfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hello,

Looking for opinions on recovering a filesystem that does not
successfully repair from xfs_repair. On the first xfs_repair, I was
prompted to mount the disk to replay the log which I did successfully.
I created an image of the disk with ddrescue and am attempting to
recover the data. Unfortunately, I do not have a recent backup of this
disk.

The final output of xfs_repair is:

Phase 5 - rebuild AG headers and trees...
        - reset superblock...
Phase 6 - check inode connectivity...
        - resetting contents of realtime bitmap and summary inodes
        - traversing filesystem ...
rebuilding directory inode 12955326179
Metadata corruption detected at 0x46fa05, inode 0x38983bd88 dinode

fatal error -- couldn't map inode 15192014216, err = 117

The full log is:
https://raw.githubusercontent.com/phillipjf/xfs_debug/main/xfs_repair_1.log

Based on another discussion (https://narkive.com/4dDxIees.10), I've
included the specific inode:
https://raw.githubusercontent.com/phillipjf/xfs_debug/main/xfs_db_01.log

I also cannot create a metadump due to the following issue:
https://raw.githubusercontent.com/phillipjf/xfs_debug/main/xfs_metadump_01.log.

Any advice would be greatly appreciated. If any more information is
needed, hopefully I can provide it.

Thanks in advance

Received: from mail-oi1-f179.google.com (mail-oi1-f179.google.com [209.85.167.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AFCF6FD5
	for <linux-xfs@vger.kernel.org>; Tue,  7 May 2024 05:13:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715058799; cv=none; b=fUhZZ9VkRHXj7dy/q0v4iMb93VrF35Trz+EDm/Bh2x/Tj88NHgrrF2fkP8JAch2S3IPdvv8SZ54j5Z8zJKXS1x1CMOtZir8Zo7wNjjERdhLp1LtJxzkdVeG8ENvXDMOT9SL2YiobNIdmHuHFNTIhTY2uXgv34Us5+5eW++0vzxg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715058799; c=relaxed/simple;
	bh=j+VAvIY79+UZLMS7r3L/ArDvCS5JTLxqAsWPJIm6Ae8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=n/hZJJkIXyirTvAy7Im/MXOSBLajeTce8UNmZJZZU1GidXHFF1yTl79FtrMSoKta/EA/lBBCrtWgK4ZhkvbS/18CZ+a4JFtTWW6vrgUqD1PsoNZKnClB3aoPjyfe+jIhbPb8jP4MeTxJji3a1sRE/18eT7lt9e4uS1oDmTNwpgk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gcvBVIPV; arc=none smtp.client-ip=209.85.167.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gcvBVIPV"
Received: by mail-oi1-f179.google.com with SMTP id 5614622812f47-3c96c096a32so1026688b6e.1
        for <linux-xfs@vger.kernel.org>; Mon, 06 May 2024 22:13:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1715058796; x=1715663596; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=YTD4OcseSOc1BxbspqPKCexuDiK51PZlecuOQQTNK70=;
        b=gcvBVIPVxlZz6/RzHk6KAg4/2STSRC0T0goHgZa3MWwOW3dmUK/x0MEFN/bbFEpYFi
         wJUE6NAnIkCXEgiYb6l9b+mF04OlvFgB01xG0RRbF4Yccqh6yAZZnGAE6bSfJO4N/3aZ
         g2hxR+/4aWl+J1LtpvifwL/8uNmHgL/Or8yyNSdxo6vgai9SNOCntS2OVneow3Z6bOUb
         l/SovwquGJBQpSB1R4WCWi0RmfLwCrjfZUhyvct3UYZAZxdykscbZ4s0C61lfEUtPZak
         Dk9F0eLp4jjy8pe3NdAn6+jo1vXmzHhrluemzj6Cq5EuRXe+LdUMVqEzOCSHtogzpt4y
         eKPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715058796; x=1715663596;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=YTD4OcseSOc1BxbspqPKCexuDiK51PZlecuOQQTNK70=;
        b=BIEgaXZ4vIXnw0rSV5GcoE1x5MIzdheyn6PZtZzwez3QL+A27YVWl3BdemF11bWsKi
         AGmo0t7aoDqVB4iuKXWozYn/FJvYsz3svI1z8DxpK65N6NDr4UzkU357wiEOs2Rd5NBs
         uaWH04lXOQvnbXXzSOS9f/wJh+4ucdIBubjL64lISF2leGw9c1BqKRn/7oSUxX/bFVCY
         3u9y55E+4reQuVeqoltlty0/+ZyI0mYKo68uhuPFAxjjkb03Qb9faOltxjimkatJXVzk
         djIl+Wn/w270xFRpK5cYDO2VG+JnGdYpzUOK7cvNJ3ISiD5LWgyYaGWpkKRUPo49/G4N
         MtGw==
X-Gm-Message-State: AOJu0YwWIX+o9JYx7xag/VhI1nly40f28X4BbmGICgiiI2+hHZBPxAOH
	JTSWvB65KGIiFz7nno/kL8UKW2WLri0sEujhP6/ZTLsfpcnAIyp4yRcxMQ==
X-Google-Smtp-Source: AGHT+IGEtWgrfc+sUhJxssskQVxywhjTXoXt6l/PPcxEwIobgFFnegi8NNZZoVfpBmD3OS5LGU69Uw==
X-Received: by 2002:a54:4099:0:b0:3c9:7057:e8c8 with SMTP id i25-20020a544099000000b003c97057e8c8mr4150592oii.46.1715058796190;
        Mon, 06 May 2024 22:13:16 -0700 (PDT)
Received: from dw-tp.ibmuc.com ([171.76.81.176])
        by smtp.gmail.com with ESMTPSA id t30-20020a056a00139e00b006f45fa013c0sm4763218pfg.85.2024.05.06.22.13.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 May 2024 22:13:15 -0700 (PDT)
From: "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
To: linux-xfs@vger.kernel.org
Cc: Dave Chinner <david@fromorbit.com>,
	"Darrick J . Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@infradead.org>,
	Ojaswin Mujoo <ojaswin@linux.ibm.com>,
	Ritesh Harjani <ritesh.list@gmail.com>
Subject: [PATCHv3 0/1]  xfs: soft lockups in unmapping and reflink remapping path
Date: Tue,  7 May 2024 10:43:06 +0530
Message-ID: <cover.1715057896.git.ritesh.list@gmail.com>
X-Mailer: git-send-email 2.44.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hello,

In one of the testcases, parallel async dio writes to a file generates
large no. of extents (upto 2M or more), and then this file is cleaned up for
running other I/O tests. In the process of deleting this file, soft lockup
messages are observed. We believe this is happening due to kernel being busy
in unmapping/freeing those extents as part of the transaction processing.
This is similar observation with the same call stack which was also reported
here [1]. I also tried the qemu-img bench testcase shared in [1], and I was
able to reproduce the soft lockup with that on Power.

Similarly another instance was reported where xfs reflink remapping path also
saw a similar softlockup problem while iterating over deferrd work items
in xfs_trans_commit() -> xfs_defer_finish_noroll().

So as I understood from that discussion [1], that kernel is moving towards a new
preemption model, but IIUC, it is still an ongoing work.
Also IMHO, this is still a problem in upstream and in older stable kernels
which we still do support and such a fix might still be necessary for them.

This patch fixes the softlockup warning for both of the callstacks.

v2 -> v3:
Move cond_resched within xfs_defer_finish_noroll() loop

[v2]: https://lore.kernel.org/linux-xfs/cover.1714033516.git.ritesh.list@gmail.com/

Ritesh Harjani (IBM) (1):
  xfs: Add cond_resched to xfs_defer_finish_noroll

 fs/xfs/libxfs/xfs_defer.c | 1 +
 1 file changed, 1 insertion(+)

--
2.44.0


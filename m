Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFA786F06A
	for <linux-xfs@vger.kernel.org>; Thu, 25 Apr 2024 08:35:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714034157; cv=none; b=TsQXeXNj8tucxaf9JBmmWpB+RRV8e2tIQ3K/Jb3Xc47u54UFuQTGVUfoOsw2oKFqaTFGaqRQCNt9mvElxbuTvOcPeaWh/y6NjDH7IyEiN/KfFHQdT7XKZliMaRzaJ8a8vRMrIwqwl6zxAZK6ytcLZG3yGSlUHM26anDOUVH0P60=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714034157; c=relaxed/simple;
	bh=KYQX7ap+Jbk9Rv5M77H9iX6gTclUWA91Lndn0gbWsiM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=UWBLEiRCaPO8muWnaXrp/YxmRVAeQaBuJWw3BDNh8e+d4ZelrQ7srs5pR6/cYN6TKZi1TL7HFyb1tdA9r/atLORCL+KHAJOJenAU/rbRu8+gIrRgBGfjp+5g/hUEqwO2pg0/eA9OwxnebUgbn+U8W1VNL6sBjFZjtho3soUZJYQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=I72uLV4/; arc=none smtp.client-ip=209.85.210.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="I72uLV4/"
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-6eff9dc1821so746633b3a.3
        for <linux-xfs@vger.kernel.org>; Thu, 25 Apr 2024 01:35:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1714034154; x=1714638954; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=c/3sXGnsMGxfOFGxDpyanV+J/CN26+qge4Y3r9AvmD4=;
        b=I72uLV4/cLPmwNVvbTho/CP05ztCCxncDhkW+7Edw0ufb0TjG+L8Dmvp93u3uXzAas
         qExelYzbymNfaZx6xyMoag8PIdJmDmIlyNlGnzmbOQIjIN7cUrmZBseZ7BKiMef/2o/m
         UJxY/qfKWXx/llK1kSSv+nuKBijvXPAIHztB4tDaZLSq2tRH+RljPKZlBITzecwgPdDQ
         wE+hb4bauSkuGPdp1kHBPUl/66itEia2zCbhvs9UnSR1NC4gRlJ6vBnIq6+ec704wqE2
         oxpJtD9gSVj6GrEgIeb3gtKWEPA8HJoGzz9Iyc/dheYQXqrGvPCecxOfr/4iroqhjkRV
         xyAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714034154; x=1714638954;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=c/3sXGnsMGxfOFGxDpyanV+J/CN26+qge4Y3r9AvmD4=;
        b=qFwvUXKvzTnKcPe5jECIQwArFB+Gl3GVxqDlRFMpHkabWZh87FV7ocRb7ID19v3H6J
         41/jrZQNDAiclheF0D31GXLZo7Qm3CkG38DNtB3njXwecVKQfSj/zFc3HZUhMlSsd5Qp
         whJRwYaVP8MehecVvs6YNeZBffAvAQciO4TJqtXddfUJ0WBCF16GU62J4/yrB2zht8vK
         p9I9c/+8vniTABh2O15XjuCeXPeaGTkfew38jbqGnGQP/ymYSWMSfcAsBVJKrgPgsK5b
         sdZeelLrO7FKOHHpw0lXs9tYrgBDhH9q2nIGemX8a7HHELsM/by8mfyOQT1hiMgWKGBE
         RJww==
X-Gm-Message-State: AOJu0Yybj47Rn5Dw2FcwDZLUuxmGqhLS3MIYCyJGvHXkOt3/X1YfWVif
	lUNvQTIBn4oKFrNWAZchCHI1xPDPyoEwQXzz69+R1HqVrhb8fDdzdE0cANIG
X-Google-Smtp-Source: AGHT+IGfH2Bv8+jbN0nXr3ACf5j/+l8ryy8QhZV7BbrA4G4ZgFlQou3E3bA1WoTexogbRGGOPmjWXw==
X-Received: by 2002:a05:6a00:9282:b0:6ea:f392:bce9 with SMTP id jw2-20020a056a00928200b006eaf392bce9mr6620723pfb.15.1714034153839;
        Thu, 25 Apr 2024 01:35:53 -0700 (PDT)
Received: from dw-tp.in.ibm.com ([129.41.58.7])
        by smtp.gmail.com with ESMTPSA id b9-20020a056a00114900b006eaaaf5e0a8sm12629989pfm.71.2024.04.25.01.35.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Apr 2024 01:35:53 -0700 (PDT)
From: "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
To: linux-xfs@vger.kernel.org
Cc: Dave Chinner <david@fromorbit.com>,
	"Darrick J . Wong" <djwong@kernel.org>,
	Ojaswin Mujoo <ojaswin@linux.ibm.com>,
	Ritesh Harjani <ritesh.list@gmail.com>
Subject: [PATCHv2 0/1] xfs: soft lockups while unmapping large no. of extents
Date: Thu, 25 Apr 2024 14:05:37 +0530
Message-ID: <cover.1714033516.git.ritesh.list@gmail.com>
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

So as I understood from that discussion [1], that kernel is moving towards a new
preemption model, but IIUC, it is still an ongoing work.
Also IMHO, this is still a problem in upstream and in older stable kernels
which we still do support and such a fix might still be necessary for them.

RFC -> v2:
==========
1. Move cond_resched within xfs_bunmapi_range() loop

[RFC]: https://lore.kernel.org/linux-xfs/cover.1713674898.git.ritesh.list@gmail.com/
[1]: https://lore.kernel.org/all/20240110071347.3711925-1-wenjian1@xiaomi.com/

Ritesh Harjani (IBM) (1):
  xfs: Add cond_resched in xfs_bunmapi_range loop

 fs/xfs/libxfs/xfs_bmap.c | 1 +
 1 file changed, 1 insertion(+)

--
2.44.0


Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 798E621C9F2
	for <linux-xfs@vger.kernel.org>; Thu,  5 Dec 2024 15:29:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733412570; cv=none; b=IQQyDmXd/CMJcyio3auTzR7bHtOur3NElIscaytcyX2AxVbsltgx1zrYVhQcyz6pTuA9UHbetyis0bon9kAQQIEe/ceUoDHQRw0BKwKlAKalXtWnSJbDTonbOzTbr3QNRGNdJIdjdmWG/Pi7CyiqbeXy4JGtIsFY8YM7JfwQbs4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733412570; c=relaxed/simple;
	bh=CPkdtsTVlVdzC79FkBL54fDDLLXCMGu5i3CJPSHhPmc=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=jzArFXIeypRBz7frcLI+lrVkltC2NsvyuMFxWW3xY+t/bVR8ehHBuJIHChIzl3Aj5tgcOayCcR9lWnJlfIAq2HISMmY8p18Z5TE0LrqddIgYOY2mx291PeWKTirLPMY0gWA38y7d2T+/KfKktLSh9V7RStQzNbu5YWUWSJg66rQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=P/WkxSER; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="P/WkxSER"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1733412567;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type;
	bh=AnaLcPMvbeIIu+JBtiWFjvE0tG3/SojUxLC4PRfIIpM=;
	b=P/WkxSERGNM3UxlPL7B5SGb1KyorbVkUYNh5VEK+wg5NIDteWqkhQGqnMxVoGPSc/B+X77
	QmojryVl1lamaS7DXsqiNVIk7iISuMiL7ETJkF4e1RFmh2kZwEBv9dTnIYzeWDLlnzYRzG
	+mTzmeEIwfLxnwqUzdtgnzrt6Cz2X5M=
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com
 [209.85.214.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-536-HOS1Dq8NNX-3usXrXBAJVA-1; Thu, 05 Dec 2024 10:29:25 -0500
X-MC-Unique: HOS1Dq8NNX-3usXrXBAJVA-1
X-Mimecast-MFC-AGG-ID: HOS1Dq8NNX-3usXrXBAJVA
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-215ccbcdc7eso14418395ad.2
        for <linux-xfs@vger.kernel.org>; Thu, 05 Dec 2024 07:29:25 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733412564; x=1734017364;
        h=content-disposition:mime-version:message-id:subject:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=AnaLcPMvbeIIu+JBtiWFjvE0tG3/SojUxLC4PRfIIpM=;
        b=NZTk7D9X8uSp16kw0KL30a9+bUWov9wt2MCSo92tAquKBkCEK7+11cHJ1uVx0cJsge
         CjYrjodMt8b5sLoYV0RnSpRCNWbgKxAAR8ElkTSnjLhJ78DJItjYGm0npYgWmkyxLS7Q
         lRi5uTMfHzWYFdFK6REnQPDPwDB6jr4duc4wMmOAhMrzM7+Y2GOQ/6dqxqapzlJ2+ZF7
         28mq3s0C7cx7u6WCzvmNqpJ+eFr4e8mgUKhI5fdQT/iVw2/3uGPQ86NhPS/3NiAVY9FQ
         Z9epW7OewGtjnf2EVcDaM45irpVCV2dTJ2WODrpKHsruDVFmVGVXsIXUstmSTfrXhX7a
         ZXLA==
X-Gm-Message-State: AOJu0Yx2PZ+b7gAg0MH8RqcabqBoFwuAIAdASSn7/gCJtdhxOGIkgOn9
	EkL17knejDmwD7wsCICYRVOrKP8hC7vccIZOo7qUFWlHXSSTl7k+eZ+mmBbPU92wkSPM2IYBqPM
	7LHilWW3qWlFJ4505pP8GQ54o4OnJCAOBGsW7kOjTGTNIRxanY3nVKXY664lhdBqmLSc5HbjFTl
	PCYuSn4aoWz+nP4crVKbQMgVFZcgrz/B1Fx7uP7J/I
X-Gm-Gg: ASbGnctD9dU1KmNuMTbtIMis5azcifP3JOkVEGk1btfxb6/g02iKYroORDw+NphuON5
	aNqXqLG4qt5I9c5g57OPG7FDQuyoMI52ipVYrTettzvWYHZReAIyPZA08DWATTKDgOPssDb8C9F
	9Pu/gjFLvwqyYyLE5OQdUcL7jC9YXoBYAD8Q9AakzJ4my5q/CUZZrxLWDj8za7Aajvg9Cto1TMN
	x0rF8lAmTotG7WNbySe92ja9od+qlgHwi6Ju41Rm3m/8+bZ+3hn695HUqAHXJ68Q10sVOyDvJ0n
	JzaZKmxUooYMZYI=
X-Received: by 2002:a17:902:d504:b0:215:7cde:7fa5 with SMTP id d9443c01a7336-215bd26734amr149925445ad.56.1733412564685;
        Thu, 05 Dec 2024 07:29:24 -0800 (PST)
X-Google-Smtp-Source: AGHT+IH/Y7/1skEb/Ym+rNWOpP4aLpvrNXse0wGMpdRdsOahSIdvvCvwZgvZFF+2nUjA3tMV/LQ1xA==
X-Received: by 2002:a17:902:d504:b0:215:7cde:7fa5 with SMTP id d9443c01a7336-215bd26734amr149924995ad.56.1733412564245;
        Thu, 05 Dec 2024 07:29:24 -0800 (PST)
Received: from dell-per750-06-vm-08.rhts.eng.pek2.redhat.com ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-215f8e5f172sm13889525ad.69.2024.12.05.07.29.23
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Dec 2024 07:29:23 -0800 (PST)
Date: Thu, 5 Dec 2024 23:29:20 +0800
From: Zorro Lang <zlang@redhat.com>
To: linux-xfs@vger.kernel.org
Subject: 64k blocksize xfs can't be mounted
Message-ID: <20241205152920.ptesvhhxvq2tcxif@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi,

Recently all my 64k blocksize xfs tests fail [1] on latest mainline
linux (HEAD=feffde684ac29a3b7aec82d2df850fbdbdee55e4) with
latest xfsprogs (for-next branch, HEAD=409477af). Do I miss something?

Thanks,
Zorro

[1]
# mkfs.xfs -f -b size=65536 /dev/nvme0n1p5
meta-data=/dev/nvme0n1p5         isize=512    agcount=4, agsize=61440 blks
         =                       sectsz=512   attr=2, projid32bit=1
         =                       crc=1        finobt=1, sparse=1, rmapbt=1
         =                       reflink=1    bigtime=1 inobtcount=1 nrext64=1
         =                       exchange=0  
data     =                       bsize=65536  blocks=245760, imaxpct=25
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=65536  ascii-ci=0, ftype=1, parent=0
log      =internal log           bsize=65536  blocks=32608, version=2
         =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =none                   extsz=65536  blocks=0, rtextents=0
Discarding blocks...Done.

# mount -t xfs /dev/nvme0n1p5 /mnt/test
mount: /mnt/xfstests/test: wrong fs type, bad option, bad superblock on /dev/nvme0n1p5, missing codepage or helper program, or other error.
       dmesg(1) may have more information after failed mount system call.

# dmesg
[  459.450856] XFS (nvme0n1p5): Sparse inode alignment (0) is invalid. 
[  459.458090] XFS (nvme0n1p5): SB validate failed with error -22. 


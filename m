Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A2781BDD0
	for <linux-xfs@vger.kernel.org>; Wed,  6 Mar 2024 05:30:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709703057; cv=none; b=RLu0xaKaFbTDPu+i057/7VA9EGJMmPsaiiduRaO4fSc8XHo9nEOTarvqClkeSEWoOq7piABybtyJoFuIKm278jRdZK5Qib15YSDBzulcxc1RfnrxrtAxyG9jdXgMQ3IrxNukPzyEghbYpYpXxdLj55VHSYC4b52T9o85m9DNers=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709703057; c=relaxed/simple;
	bh=7/aJmX+7PT0+Bj6JqavuTW4WLVYi3uyZ/FZlntEvqYc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LpiaKkERO6lsXIM5fP103i5krux/ncEOh9P00sBN/aX2+WL0EBaHzbEUR6Bb6mDn+VlJ6bxLmpfb6y90iQ4BSTgFXX19gaJKD+gHo6RvEu0QcDUbiERquKKMZLcst02PpxUrqKNAWXlxBE96irESrI5F2KCOT4lbCIg22xv2ZvE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=2e5Eczi4; arc=none smtp.client-ip=209.85.210.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="2e5Eczi4"
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-6da202aa138so4799345b3a.2
        for <linux-xfs@vger.kernel.org>; Tue, 05 Mar 2024 21:30:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1709703056; x=1710307856; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Myq8EY3hxTeJMj+gbWvv9pGi1rqPDiivG8o1mQ1I1qQ=;
        b=2e5Eczi4B5XX27b8N6YPzR2x6To/xJB8Xpe1mLdLBlRb+9apFSX5wyLuMLG01tV3hh
         P1Cjy01nj3/3VrtE7+3zbmmuI6yqpoBBulTTQh3ElBLAMq+ULm1nZ/OdMtV4B9EapQzR
         V6Wo8UwX9hOzsedXTN6sleKyNtEsH210nGTSvrlNHfsV3MNZ/VNiq1BHPYMuO7cPEig/
         sgWeE1B4uhFDYVHn0+Ui68ObflkuC21/0MBnDQtk+9a1z4oo8lzqc6eozbwbpHCvqe7X
         ieRGAcP1dZuJm75KH15q86vyuaN4Lrfd91boPiUd6qbbKxa+15dovppiB4dRRVL03WHu
         xFMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709703056; x=1710307856;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Myq8EY3hxTeJMj+gbWvv9pGi1rqPDiivG8o1mQ1I1qQ=;
        b=prdT0qz60o54cJkZi6g0OeJEK69Lyr6YTiiXmL4xoQsKLuHDbmi+EasKqtfau7Powq
         b+rm6Jb8R4OpXM5rEbacdD2e+Now8/hAL0gXAv99zzm0usKuFlNxbk/7HgunfKQ5PFh8
         VjnSiDaBzcdBNr7JEFu0SYAmNrXwMZ/q4dA5+jH+JN5kWt2bO1/evMMWkVQ/8bhIeDPs
         BWTYuR3NCOPiGBgGvk2cVvTR220IDYEeUbBwZWg1JtKmr+nOwl3v/+PNrJ/8OZ+AD03O
         2uR/W6K73+DuugVLShvu5wMIFfgZDLxO2/iqGy+ab3SPlHpjX828TFvqFnKByePAa1vy
         J/lQ==
X-Gm-Message-State: AOJu0YyYaBY5QUyQ7hcoDgCBS/WRWgzIQYUI0a7Q+ger/USkm6jRXZwl
	Hc6vw7q2RlGTFAMJaFLsfnu30XuiqEgcCIgBXy5zphR2rK50DI+F+AI3+Vek8tychKojpETa6ZZ
	O
X-Google-Smtp-Source: AGHT+IHwYCYZ3hfXtapic4RxMvaiFSz4x6QvmVADrWYFSXJAoGhcjw4BhssFQ3rZjldgk4yepMBDdQ==
X-Received: by 2002:a05:6a20:7d92:b0:1a1:492a:c125 with SMTP id v18-20020a056a207d9200b001a1492ac125mr4530143pzj.28.1709703055455;
        Tue, 05 Mar 2024 21:30:55 -0800 (PST)
Received: from dread.disaster.area (pa49-181-192-230.pa.nsw.optusnet.com.au. [49.181.192.230])
        by smtp.gmail.com with ESMTPSA id y6-20020a17090aca8600b0029a78f22bd2sm9655946pjt.33.2024.03.05.21.30.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Mar 2024 21:30:54 -0800 (PST)
Received: from [192.168.253.23] (helo=devoid.disaster.area)
	by dread.disaster.area with esmtp (Exim 4.96)
	(envelope-from <dave@fromorbit.com>)
	id 1rhjrg-00FfkB-1P;
	Wed, 06 Mar 2024 16:30:52 +1100
Received: from dave by devoid.disaster.area with local (Exim 4.97)
	(envelope-from <dave@devoid.disaster.area>)
	id 1rhjrf-00000006xLz-3wYr;
	Wed, 06 Mar 2024 16:30:51 +1100
From: Dave Chinner <david@fromorbit.com>
To: linux-xfs@vger.kernel.org
Cc: john.g.garry@oracle.com,
	ojaswin@linux.ibm.com,
	ritesh.list@gmail.com
Subject: [RFC PATCH 0/3] xfs: forced extent alignment
Date: Wed,  6 Mar 2024 16:20:10 +1100
Message-ID: <20240306053048.1656747-1-david@fromorbit.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <ZeeaKrmVEkcXYjbK@dread.disaster.area>
References: <ZeeaKrmVEkcXYjbK@dread.disaster.area>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Garry,

I figured that it was simpler just to write the forced extent
alignment allocator patches that to make you struggle through them
and require lots of round trips to understand all the weird corner
cases.

The following 3 patches:

- rework the setup and extent allocation logic a bit to make force
  aligned allocation much easier to implement and understand
- move all the alignment adjustments into the setup logic
- rework the alignment slop calculations and greatly simplify the
  the exact EOF block allocation case
- add a XFS_ALLOC_FORCEALIGN flag so that the inode config only
  needs to be checked once at setup. This also allows other
  allocation types (e.g. inode clusters) use forced alignment
  allocation semantics in future.
- clearly document when we are turning off allocation alignment and
  abort FORCEALIGN allocation at that point rather than doing
  unaligned allocation.

I've run this through fstests once so it doesn't let the smoke out,
but I haven't actually tested it against a stripe aligned filesystem
config yet, nor tested the forcealign functionality so it may not be
exactly right yet.

Is this sufficiently complete for you to take from here into the
forcealign series?

Cheers,

Dave.

Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E392E2853F7;
	Fri, 20 Jun 2025 14:03:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750428206; cv=none; b=JRrwVukke+lEa6x66VB3z6kE3+VgsGFI1RCd+Fxv3SeQ61Pr4YhG9sJoXeTj5yd/TfAdZX8WYAMm4zblVfQr2IXlsePiFKnUB5JT38ADIdF1XQD9lVBZl/7at1kIeAEzSH7Rg+kOQPpKWmWgCf3l2/ffjJFTeRNRbdNkEOlvy4Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750428206; c=relaxed/simple;
	bh=4NEDyJXdNqSWXOZ4emVLeSKU5MjypHaO00EcnF46Flc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J9k/9kEurnB9+hvHHN3hnohvsPgFKJX+wzYtzSh2831m19W0lOz67SeBnUJJTLPVmwJ09HX0DLH7sqxMIZqxyI9YBROGLiEQ8Ouv85miyI9CdK8Hyrt/VUbSYHtSfuNtq6GsK4XdfQDHi4+LZS0qLUc7Yduj6yWjUuBpS1kSh6I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NTNwZPRJ; arc=none smtp.client-ip=209.85.210.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NTNwZPRJ"
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-747abb3cd0bso1321604b3a.1;
        Fri, 20 Jun 2025 07:03:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1750428204; x=1751033004; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Xn7VkzjBGtxC5wocnjwA6tAAMdVwFSL8OdOVM5bwT48=;
        b=NTNwZPRJxS3dUIW7EmHkxw5FW517yXmpV5Tigpqt1zDCoHo7lnHOQHDISsBUDYssCj
         UM03F7jeWfYvB2QEkfFGtRXBncvbOShry6Xn4So1Dq9JKy6WwAaUjaKC7FUyUPn7pvGE
         za100yTGHS/hXZQ4Gof5SOSTdlGWm6IbwAKOC9Qach/vSKObf6TTuUusqZ+koRItEzhE
         EPRrZQ4goBwhkQc0/lZoe7S5EtH/ijW2Wqh8bDpqZF88u3Gvg/WqkGR3fcVj4Iw/A2/9
         oOxGBRfNYB4D+VnLHvtsDyQ3ExtlszZnO0xOQWMEMdUy2VSEfxuZV7SoLmAufWMY+ORM
         dMnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750428204; x=1751033004;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Xn7VkzjBGtxC5wocnjwA6tAAMdVwFSL8OdOVM5bwT48=;
        b=KhqwCiXtOwyO87YJDO+ZNO12UcnSEwZjGb6ltHHWqCDCHmBSYBnDoWUKSW1U5asAVC
         D1d/XsIpD8AYpspG8jj1TRNYUdfyMOWbqZQWrUTxQc4dnFD9yu42qafW/verc+hI++JB
         WHc/Jf8SWAV23S8pWLiQeKiPpmoby7+EO/jUtkrVgNn5+TRzrc4DqvKr0KuA6gpU4Kjc
         2yYzAurKwr5nqO5ZQQpNq/fM48PUt/ffekXt+48WQtACmr6NXAVUlAplQgIArLf1NEiq
         qXf/WmzfgsVbUeucG5Z1pdeTMAZ9lnJGIOlM+v1jlBZhVStKXMTSNZ68rrikvWCwKojn
         VofQ==
X-Forwarded-Encrypted: i=1; AJvYcCWHYlAtLfMrg6Qt5ohIIAQhRT9pHSMHStdO2uNIh3HRxeORY7TSmZaDoKK8Qi/RbviqE2+fAsrCS13t8sQ=@vger.kernel.org, AJvYcCWhccWjVzJ1nedQVOO8mjM/WuFhXpAqLE2pFbh+qxYbYeuo35TIBism91z2eDbaIodADP92w05WRSh5@vger.kernel.org
X-Gm-Message-State: AOJu0YwCZYw8w/VFKumAb0Kbti1AsDLJvmM2o4UQtbjbIuldsOqWBEr8
	wnuXiISwUk/Tlf+ag/+meDgUpBMeTI2reFa8j9g9F5ef/wtllCjZNV+6
X-Gm-Gg: ASbGnctogEkzzcyMTIbKVVGVjsOdvo2mTg7bb/zjq/5YOdL+O8sj4sp+tIwAxFo+Q8v
	sUkILuEaLHoE1Gh619RjB9OcKzKhrdfWUGbJTawmtGw0zO7XLLmmpmeaQ4brWCi4U5cQwV75w88
	2pAUgLdxZ3hUQtrR+yBwQVobApKW66XtX0tsJocZoQ89tjDqndJbO7IANsS1FKIzBPg7woRtJcN
	0qsJUDlr/Ty+oYitjiltgV7vFoIjr/dpZBKYSvD1JoqKWSNulL61oqRCte4L77WvXYcHEzKN7YX
	/KZtnTkzi4lgqSM8cnyztkbpqHWv4QUkj6zTAZZcpqpF0EGTTychr8s0P7H5LWYmOyEA2kLmgQ=
	=
X-Google-Smtp-Source: AGHT+IEA8OM74XLIyYLhLaheuXwHNmIRKwJLELETRIVKeQTi78LCozw/MaDGR08IIgyqKTzIaWRMPQ==
X-Received: by 2002:a05:6a21:900c:b0:1f5:8cf7:de4b with SMTP id adf61e73a8af0-2202931826cmr4005618637.16.1750428202241;
        Fri, 20 Jun 2025 07:03:22 -0700 (PDT)
Received: from VM-16-38-fedora.. ([43.135.149.86])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7490a649388sm2135010b3a.113.2025.06.20.07.03.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Jun 2025 07:03:21 -0700 (PDT)
From: Jinliang Zheng <alexjlzheng@gmail.com>
X-Google-Original-From: Jinliang Zheng <alexjlzheng@tencent.com>
To: david@fromorbit.com
Cc: cem@kernel.org,
	chizhiling@163.com,
	chizhiling@kylinos.cn,
	djwong@kernel.org,
	linux-kernel@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: Remove i_rwsem lock in buffered read
Date: Fri, 20 Jun 2025 22:03:20 +0800
Message-ID: <20250620140320.231780-1-alexjlzheng@tencent.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <Z23Ptl5cAnIiKx6W@dread.disaster.area>
References: <Z23Ptl5cAnIiKx6W@dread.disaster.area>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Fri, 27 Dec 2024 08:50:46 +1100, Dave Chinner <david@fromorbit.com> wrote:
> On Thu, Dec 26, 2024 at 02:16:02PM +0800, Chi Zhiling wrote:
> > From: Chi Zhiling <chizhiling@kylinos.cn>
> > 
> > Using an rwsem to protect file data ensures that we can always obtain a
> > completed modification. But due to the lock, we need to wait for the
> > write process to release the rwsem before we can read it, even if we are
> > reading a different region of the file. This could take a lot of time
> > when many processes need to write and read this file.
> > 
> > On the other hand, The ext4 filesystem and others do not hold the lock
> > during buffered reading, which make the ext4 have better performance in
> > that case. Therefore, I think it will be fine if we remove the lock in
> > xfs, as most applications can handle this situation.
> 
> Nope.
> 
> This means that XFS loses high level serialisation of incoming IO
> against operations like truncate, fallocate, pnfs operations, etc.
> 
> We've been through this multiple times before; the solution lies in
> doing the work to make buffered writes use shared locking, not
> removing shared locking from buffered reads.

Hi, Dave

I have a question that I haven't figured out: If shared locking are used
in buffer writes, how can the read/write atomicity mentioned by [0] provided
by xfs be guaranteed?

  "  "I/O is intended to be atomic to ordinary files and pipes and FIFOs.
  "  Atomic means that all the bytes from a single operation that started
  "  out together end up together, without interleaving from other I/O
  "  operations."
  "  
  "  i.e. that independent read()s should see a write() as a single
  "  atomic change. hence if you do a read() concurrently with a write(),
  "  the read should either run to completion before the write, or the
  "  write run to completion before the read().
  "  
  "  XFS is the only linux filesystem that provides this behaviour.

[0] https://lore.kernel.org/linux-xfs/20190325001044.GA23020@dastard/

thanks,
Jinliang Zheng :)

> 
> A couple of old discussions from the list:
> 
> https://lore.kernel.org/linux-xfs/CAOQ4uxi0pGczXBX7GRAFs88Uw0n1ERJZno3JSeZR71S1dXg+2w@mail.gmail.com/
> https://lore.kernel.org/linux-xfs/20190404165737.30889-1-amir73il@gmail.com/
> 
> There are likely others - you can search for them yourself to get
> more background information.
> 
> Fundamentally, though, removing locking from the read side is not
> the answer to this buffered write IO exclusion problem....
> 
> -Dave.
> -- 
> Dave Chinner
> david@fromorbit.com

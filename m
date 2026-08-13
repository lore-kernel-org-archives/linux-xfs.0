Received: from mail-qv1-f45.google.com (mail-qv1-f45.google.com [209.85.219.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3B0A35CBC3
	for <linux-xfs@vger.kernel.org>; Thu, 13 Aug 2026 07:08:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786604934; cv=none; b=i3YmtuzkZ2/Hin48Z8QuVtgJIyJPXIRLnwiz86EYbTrAMbDGb0cC8DZusTQwSZq8Zyv19ZrehYgoHKV3JWpixtGRNfT2eGl+BFBc8QF4r1Tl4YDtlKcd5XKMyLt0zHdie26Fw2/PuDlI8FaEYvcPjqaBHESiy2VH7RpOGiO5gGk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786604934; c=relaxed/simple;
	bh=MulVI1Kiy0buwNlVioiVtUEoA2TAjOLCUV9Iz+SqDCI=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=cNClRciyB5AzJqyVyWjv23EJycmfu0ZqyNNd+wXG60RfvayP02yeskM4yDyLlcSxISpzqKfVNY9Nbw/JaErLlp02uAJmcrubheS/5V0z7K5yljzjCrSau6GfssYqDDT5OmtLia1zv0yMcdsbtYINZJwKWsPpGhe3HMVR5EYGc6s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Y+yALEWu; arc=none smtp.client-ip=209.85.219.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Y+yALEWu"
Received: by mail-qv1-f45.google.com with SMTP id 6a1803df08f44-9063b380982so4832256d6.0
        for <linux-xfs@vger.kernel.org>; Thu, 13 Aug 2026 00:08:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786604932; x=1787209732; darn=vger.kernel.org;
        h=content-disposition:content-type:mime-version:message-id:subject:cc
         :to:from:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=hiS1TSxKyC8d1Eg14jpETfU/OrjWeK1FYL0Fa5frlCQ=;
        b=Y+yALEWuKa0DL2GlT7BKJI70lDQf279YwgolIRoD/NTNoacIZr/PXYCmut8on/XuES
         /qR/hf/ckn6Z2UbsQw/JmVhXyUIG8kG+QUY8wxOb6FES03ohzz5fIyGx7fWvYfqu6mpZ
         b5/yR80GrG7CjSU/TN9REqeUB15KTOzhGnB5h1khONR/NO9Ds7/vteUP1+3mECzZwZ++
         ITbO5TG+fgcGRHFJc/zNvIwCQO9KjiZbEAJyH/rYioTSDRFj4YB7gV/w+DaVDtMQGS6K
         LovrppIB6iw6EQHabRiVv9j4IzMkaO2SkRuHAMWYmXL/JeYRnaktsQH3TrIrbY4kpT4v
         bQig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786604932; x=1787209732;
        h=content-disposition:content-type:mime-version:message-id:subject:cc
         :to:from:date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=hiS1TSxKyC8d1Eg14jpETfU/OrjWeK1FYL0Fa5frlCQ=;
        b=EqIVDBD1QLphUOoBZsCL9uW9+ioaTp9AXGSrpOgfbtP2/UQqOkCSw90iLB2GRT/YC8
         jqHF9G42PY0fmGKe2ouyfptChr8fMZcl3b29qyUSAMktzegrM1XBRuEUVEVlQ54zpewl
         sCHwLOVJJGpzsmFRjsfVuOFsb0ohNfK283gZi1o/nautK04mv1zt1UpbxhcHf7zFAIXm
         tsnbHiKlGJNJS5urkA+wIlT33oUCG1KeYPclbOT3CZ6JPYJ65xE99OPM9Yoll4p/o1Bn
         8fnIfRNy91JEOtnduc+pG0AnS3VRpbjAJmxe94u3OOeWqQCHcIc5w2kXDqZJex9iUlY1
         Gggw==
X-Gm-Message-State: AOJu0Yx7Q0EjQKKdmaCpW7Jl4+PZAbGKXEPq/5UtX5bUqwa9ZjfM95KR
	18E0KbDjWsskra8UZ1Bo+3Mmehw6NjDt5MdIG408fxmCpMmFJhqP15IS847YEHfWRddIPg==
X-Gm-Gg: AR+sD112QuoPZy3iasNnwDpdp6Ln4Rr0fmoEu879O7mU0P1xPdDPckolLYWjaVGtRDL
	z+6iyypnLrC65s7nvbrvv0E1XH8VzZHSfjwasfEGkB/10xdE1DEEM7EM5y6AEA3yMsGAp0Oun3t
	DU8kKJ05pN9MgkGqRC6vioLrrj+UwFUWCvXIaxvvnK0pltxtOSh9DQQr6ysrLL8j7/rX09lnYJG
	8Ntrb2KB3SWdA3O6dXZXx4GjkPh0yhK1A76Uxi858J6PiCk3pzdzrQ3cvILL+mBxVMkO+VERuqt
	D+/JtuQJApT1A5YeIJ1sDq3vnBdicA+ctwn5OIDGd2vvSHaqsVTkQPfh9BFUIwQJr+d7fJY0efC
	tpwiedihoSWwT8q/TfoZLLOJsQ2GvR4yxEGW8evJL9rXTgm68XXqtkfH7u/wqI3edpxMHQYWoEq
	tK1Nf8PnSF5ZyqKKYxkBTwHjadvUD5BkuEVK/0/LVS0rY2jnZ8Dl80
X-Received: by 2002:a05:6214:500b:b0:8f0:d710:26ba with SMTP id 6a1803df08f44-90a80bb0b74mr29757446d6.31.1786604931729;
        Thu, 13 Aug 2026 00:08:51 -0700 (PDT)
Received: from localhost ([37.19.206.57])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-90a81a9e4aasm8980446d6.37.2026.08.13.00.08.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Aug 2026 00:08:51 -0700 (PDT)
Date: Thu, 13 Aug 2026 10:08:46 +0300
From: Dan Carpenter <error27@gmail.com>
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org
Subject: [bug report] xfs: remove _XBF_LOGRECOVERY
Message-ID: <an1tftfCWcRXJfps@stanley.mountain>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hello Christoph Hellwig,

Commit d80fe85bb2fc ("xfs: remove _XBF_LOGRECOVERY") from Jul 15,
2026, leads to the following Smatch complaint:

    fs/xfs/xfs_buf.c:1066 xfs_buf_ioend_handle_error()
    warn: variable dereferenced before check 'mp->m_log' (see line 1057)

fs/xfs/xfs_buf.c
  1056		 */
  1057		if (xlog_is_shutdown(mp->m_log))
                                     ^^^^^^^^^
This was already dereferenced

  1058			goto out_stale;
  1059	
  1060		xfs_buf_ioerror_alert_ratelimited(bp);
  1061	
  1062		/*
  1063		 * We're not going to bother about retrying this during recovery.
  1064		 * One strike!
  1065		 */
  1066		if (mp->m_log && xlog_in_recovery(mp->m_log)) {
                    ^^^^^^^^^
So probably this check can be removed.

  1067			xfs_force_shutdown(mp, SHUTDOWN_META_IO_ERROR);
  1068			return false;

This email is a free service from the Smatch-CI project [smatch.sf.net].

regards,
dan carpenter

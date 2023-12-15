Received: from mail-oo1-f49.google.com (mail-oo1-f49.google.com [209.85.161.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDC3345BE7
	for <linux-xfs@vger.kernel.org>; Fri, 15 Dec 2023 20:20:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="EYBeaSRg"
Received: by mail-oo1-f49.google.com with SMTP id 006d021491bc7-590bb31ccf5so725462eaf.3
        for <linux-xfs@vger.kernel.org>; Fri, 15 Dec 2023 12:20:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1702671607; x=1703276407; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=9rGPFuIXDoUFunSlYILbcrRj518XphfPDbM4a6b6YIA=;
        b=EYBeaSRgOoVNMzPc5aq/QV311hWLhaU05UoiWd+IlIB0m6iMPOSAOa2Ajlxs6EDyzw
         y947xitUReEVm8ccKRLUFzRush11nBHnqNO+IEfyKLpBHJezfg/meZYgq/bKfhtlF0xv
         n5VMw09rIf1rFk7+NiXr+j816de8VAMpODVbQox/2JAEHBxqGbUsYB4ShpA4Bz1xazGc
         pyGF1ncUgiq72JAL+h1zKYACNtJZ+y6wnLNmFPYTNEmEv5icnkgQ8VTvr95mPW0ce2S/
         IAoU7p1B6QRW3I4urbVxZ5Knlwhpp1SEh2RVNZ0P95SATTS0LO/EWeAwdWZh9n/a+s0w
         GnNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702671607; x=1703276407;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9rGPFuIXDoUFunSlYILbcrRj518XphfPDbM4a6b6YIA=;
        b=u2IIMysjiq9N5bJmZPSDxiLm+nH9qY5HdSJ4mAFrI+yNkfP4lw+ojrpWLT7N7DBvy0
         zYA1nbxPz/+SJD8ksW2Y30mE36aMaX7Zq3wBUhO6UYkaXj9aWa499nWoy4PvLV/tjKxR
         CLPfjk6UQDCSzuvzfzDtDZOHHVoym9NZ/2YkEHJcf6NB4L7HkJew8gBH2mAMorMRzpUT
         oI4xiCFdh2tNo7IsKTqbJnJEi4/AUdHwEEmKdkMBqAA7hsn7k1clp63NEj4VwChIRngy
         /wknPpSsmXvnBjHyxe6OVoCwPDlrrA3Zfxq93yRXvrl+oLHyUFsWWnGTsgmoUW4Dh9Xb
         UNtA==
X-Gm-Message-State: AOJu0YzELG7N7+LlIk+hMI/6KE6njiqBJpegsGAP4BStG+rokr/veHUa
	1khUgoWe7ErEyH8cGt3s+fkq2A==
X-Google-Smtp-Source: AGHT+IGx230ebDzTaPe5+wA9jT2q8gjcSaNK5k9KLEwcTzmsQyVGJ9QGsE1BfY+4/r/FPBrcrk15iQ==
X-Received: by 2002:a05:6358:3106:b0:16e:43a1:687f with SMTP id c6-20020a056358310600b0016e43a1687fmr15327755rwe.4.1702671606930;
        Fri, 15 Dec 2023 12:20:06 -0800 (PST)
Received: from dread.disaster.area (pa49-180-125-5.pa.nsw.optusnet.com.au. [49.180.125.5])
        by smtp.gmail.com with ESMTPSA id n19-20020aa78a53000000b006ce61c9495bsm14420743pfa.10.2023.12.15.12.20.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Dec 2023 12:20:06 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1rEEfD-008mzz-1u;
	Sat, 16 Dec 2023 07:20:03 +1100
Date: Sat, 16 Dec 2023 07:20:03 +1100
From: Dave Chinner <david@fromorbit.com>
To: Wengang Wang <wen.gang.wang@oracle.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	"linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH 0/9] xfs file non-exclusive online defragment
Message-ID: <ZXy08z140/XsCijh@dread.disaster.area>
References: <20231214170530.8664-1-wen.gang.wang@oracle.com>
 <20231214213502.GI361584@frogsfrogsfrogs>
 <ZXvEtvRm1rkT03Sb@dread.disaster.area>
 <97269730-511F-438B-9840-59CAF7997FC2@oracle.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <97269730-511F-438B-9840-59CAF7997FC2@oracle.com>

On Fri, Dec 15, 2023 at 05:07:36PM +0000, Wengang Wang wrote:
> > On Dec 14, 2023, at 7:15 PM, Dave Chinner <david@fromorbit.com> wrote:
> > If we were to implement this as, say, and xfs_spaceman operation
> > then all the user controlled policy bits (like inter chunk delays,
> > chunk sizes, etc) then just becomes command line parameters for the
> > defrag command...
> 
> 
> Ha, the idea from user space is very interesting!
> So far I have the following thoughts:
> 1). If the FICLONERANGE/FALLOC_FL_UNSHARE_RANGE/FALLOC_FL_PUNCH works on a FS without reflink
>      enabled.

Personally, I don't care if reflink is not enabled. It's the default
for new filesystems, and it's cost free for anyone who is not
using reflink so there is no reason for anyone to turn it off.

What I'm saying is "don't compromise the design of the functionality
required just because someone might choose to disable that
functionality".

> 2). What if there is a big hole in the file to be defragmented? Will it cause block allocation and writing blocks with
>     zeroes.

Unshare skips holes.

> 3). In case a big range of the file is good (not much fragmented), the ‘defrag’ on that range is not necessary.

xfs_fsr already deals with this - it uses XFS_IOC_GETBMAPX to scan
the extent list to determine what to defrag, to replicate unwritten
regions and to skip holes. Having to scan the extent list is kinda
expected for a defrag utility

> 4). The use space defrag can’t use a try-lock mode to make IO requests have priorities. I am not sure if this is very important.

As long as the individual operations aren't holding locks for a long
time, I doubt it matters. And you can use ionice to make sure the IO
being issued has background priority in the block scheduler...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

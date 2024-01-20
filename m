Received: from mail-ot1-f54.google.com (mail-ot1-f54.google.com [209.85.210.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA6F839F
	for <linux-xfs@vger.kernel.org>; Sat, 20 Jan 2024 23:58:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705795137; cv=none; b=raY/4Rv1bNybaMk8JvcWpJVdMWgzxAkKXdWt3bQIaXNth2j7vGtIliL2YTo0wp3JMUN1OnxrxHTKJWEU1xOfADNnMM5xZKhX95SoVP6EIaih0hr2INjkb733KxrIiRR6rIu+jd9vkwWraNv/nRBRo8WmX+ronu34Lwa19wDoYB0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705795137; c=relaxed/simple;
	bh=pFLgNS0pXnoRvEG6NvuUSLKqJKembgP8i1vVdk9BxDg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EkSUDM+wi/L81polZ1XZiqF7e++l+YLzsFLPhTrZH/K3BTWpUNO/DzgmqlbIkqaGXq3WzZG1qfI+xXMq5CNPUZMX3JdSeIrM0RX7HvGOIqOyjN0egWaMyF7qwBfxQetZntiwdSLONuIl7FnuALEQlSchoxxAKzSVYYdQFYCaeq0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=tYXa3uqj; arc=none smtp.client-ip=209.85.210.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="tYXa3uqj"
Received: by mail-ot1-f54.google.com with SMTP id 46e09a7af769-6dddc655a60so1519939a34.2
        for <linux-xfs@vger.kernel.org>; Sat, 20 Jan 2024 15:58:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1705795134; x=1706399934; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=x3sBGzY4QaBQtB8jL3G850VWPobojCBmuZjp/uD9B/k=;
        b=tYXa3uqjB1UDZP89mMbVX7ZY7l2xa0KrzsAf5P0F/0YgK6vdNThu2sm+xTa0Rnb3uf
         N9a99BlVQOzLIy9tUBsCOP20TWXYxZNyakzx/e6KQkI3lYWD5sea6+TMiFUrr9zWww3W
         oLdBoCnDiXGSgle2g8EIRNZa4LEoViFRqMl7yz2FOfCsDDrznoSqcrAE5DVaqTjbR3oh
         WGz8xHM+3DtTD7j08QYdntZC/ZCJviGH1Dzgu1oGCu7mcU3FclCMInILn5FNPYJyTyZt
         OmTViBltiYDsjekzlR+tDeI2SwG3TQ7aqTgMvRZ8YgEGiWjUW6bnLUQ3N4S62K3peZOI
         jJSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705795134; x=1706399934;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=x3sBGzY4QaBQtB8jL3G850VWPobojCBmuZjp/uD9B/k=;
        b=SbqKYpjLwDUTLaOeQUrf6E0GTJxt7q3bM0TMEJapdpkxWtR6fJOhFQvM6ho0LLMvJm
         h3yhwtv59KVIkGGQ5cy2YuHxYjFHRXo0bnvfiAQWix1U13ZK4euGUR5L5kB7qDldc0fm
         8f+UXNbPv9JQO0X1xOkjJ7pusDIlWJXvApYd1s2r3Yh6WwNFhE+2+8sl1Gl0HDWHb9Tu
         faA+bwNdQoulQPiP/5KOLhJh7HQsvPXJ3iVVoQBI/B3Nl/+kAFgOMj04Xm2Bss1902nH
         7TJNCJN2xjcu9lGNI26axSa7UJVHXNxpbMOcx05bM2gMmt8V3WzpwBOqXxuV64MsIRxl
         uUxA==
X-Gm-Message-State: AOJu0YwzvBcO4TyOdP2YNxyrQ4Djof+1kkMIiatlBlqKPKhuxkmLyo5z
	ay651OMAKJ9Swv8jN1mdJlJmHBG9wDs+G3oabKnR2ke96MZ4Z9KdjKFtJx/xxC4=
X-Google-Smtp-Source: AGHT+IGjAe/Bq40tcMg4pfVA138wG6vhVIoNDhSIwdV6MluxuZl4pmIeFepyZ/YyDqV8Moz2ScFpuA==
X-Received: by 2002:a05:6830:719e:b0:6dd:e38b:552a with SMTP id el30-20020a056830719e00b006dde38b552amr2947414otb.47.1705795134623;
        Sat, 20 Jan 2024 15:58:54 -0800 (PST)
Received: from dread.disaster.area (pa49-180-249-6.pa.nsw.optusnet.com.au. [49.180.249.6])
        by smtp.gmail.com with ESMTPSA id v14-20020aa7808e000000b006dbc4cb72ebsm3248819pff.201.2024.01.20.15.58.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 20 Jan 2024 15:58:53 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1rRLEf-00D6ZY-2x;
	Sun, 21 Jan 2024 10:58:49 +1100
Date: Sun, 21 Jan 2024 10:58:49 +1100
From: Dave Chinner <david@fromorbit.com>
To: Zorro Lang <zlang@redhat.com>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [xfstests generic/648] 64k directory block size (-n size=65536)
 crash on _xfs_buf_ioapply
Message-ID: <ZaxeOXSb0+jPYCe1@dread.disaster.area>
References: <20231218140134.gql6oecpezvj2e66@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
 <ZainBd2Jz6I0Pgm1@dread.disaster.area>
 <20240119013807.ivgvwe7yxweamg2m@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
 <ZaoiBF9KqyMt3URQ@dread.disaster.area>
 <20240120112600.phkv37z4nx3pj2jn@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240120112600.phkv37z4nx3pj2jn@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>

On Sat, Jan 20, 2024 at 07:26:00PM +0800, Zorro Lang wrote:
> On Fri, Jan 19, 2024 at 06:17:24PM +1100, Dave Chinner wrote:
> > Perhaps a bisect from 6.7 to 6.7+linux-xfs/for-next to identify what
> > fixed it? Nothing in the for-next branch really looks relevant to
> > the problem to me....
> 
> Hi Dave,
> 
> Finally, I got a chance to reproduce this issue on latest upstream mainline
> linux (HEAD=9d64bf433c53) (and linux-xfs) again.
> 
> Looks like some userspace updates hide the issue, but I haven't found out what
> change does that, due to it's a big change about a whole system version. I
> reproduced this issue again by using an old RHEL distro (but the kernel is the newest).
> (I'll try to find out what changes cause that later if it's necessary)
> 
> Anyway, I enabled the "CONFIG_XFS_ASSERT_FATAL=y" and "CONFIG_XFS_DEBUG=y" as
> you suggested. And got the xfs metadump file after it crashed [1] and rebooted.
> 
> Due to g/648 tests on a loopimg in SCRATCH_MNT, so I didn't dump the SCRATCH_DEV,
> but dumped the $SCRATCH_MNT/testfs file, you can get the metadump file from:
> 
> https://drive.google.com/file/d/14q7iRl7vFyrEKvv_Wqqwlue6vHGdIFO1/view?usp=sharing

Ok, I forgot the log on s390 is in big endian format. I don't have a
bigendian machine here, so I can't replay the log to trace it or
find out what disk address the buffer belongs. I can't even use
xfs_logprint to dump the log.

Can you take that metadump, restore it on the s390 machine, and
trace a mount attempt? i.e in one shell run 'trace-cmd record -e
xfs\*' and then in another shell run 'mount testfs.img /mnt/test'
and then after the assert fail terminate the tracing and run
'trace-cmd report > testfs.trace.txt'?

The trace will tell me what buffer was being replayed when the
failure occurred, and from there I can look at the raw dump of the
log and the buffer on disk and go from there...

>  [ 1707.044730] XFS (loop3): Mounting V5 Filesystem 59e2f6ae-ceab-4232-9531-a85417847238
>  [ 1707.061925] XFS (loop3): Starting recovery (logdev: internal)
>  [ 1707.079549] XFS (loop3): Bad dir block magic!

At minimum, this error message will need to be improved to tell us
what buffer failed this check....

-Dave.

-- 
Dave Chinner
david@fromorbit.com

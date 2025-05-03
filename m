Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AFECEBE
	for <linux-xfs@vger.kernel.org>; Sat,  3 May 2025 22:34:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746311699; cv=none; b=bNqOW7dtfHmgM3e24t6rTNJayMurWjoeopgHWs5XMd1/S4ohhhw11QH7mNuJ490C3X6/ZHuVzVCgr4nv3ZurHGNz0rQZogMHmfvvtF8zrL5Yi2qC3fwUV0o6P/lYisnvCIjpcMijPxlgqJ2CI/DPLGsF/+fgsAhWKyV4FEp9i2g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746311699; c=relaxed/simple;
	bh=QcJBsx3zQrrz72fl4hbINHVus9JXDKOWM/LuRtGU1hw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=g4UZuE+7yD2fNU+J2AW8oE1bRDe0NSLmUocvuhCNve8mhVj/SJ5JgIodxCYzHEGXvsYuGz79Tu3nrM5LJnE/jroMeI8Ip6T3a3rbZzPWGCvjfCm84oVOSFkFfwPJbCgirgZQ+C1CraJpzzp6mxOdvm0oljC3T+3Bm3ZrYJusz/8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=MBcoff2f; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="MBcoff2f"
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-22c336fcdaaso38465305ad.3
        for <linux-xfs@vger.kernel.org>; Sat, 03 May 2025 15:34:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1746311696; x=1746916496; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=uExTDiVgDAuuKf4/T4UqKfNg0MetNjVfsz9hfpKpcYA=;
        b=MBcoff2fyBdJDDqSo7ROFa/CaQ75UH1sxbxyCm+bWLQ0O2px4WdHGCV0Heouov5pKZ
         OLozAxvKTITKFaDjjLm2GIkkXuuVGPY+Rl4X9V9HAePEy9M+191HWdg/yIHy2sHSCIBd
         mf6LKYV5DWyZ4yjjKeMBU3kMmk4cgLJgrDpMn1b/ohPEac2fhEkyouEZpIF30SiqUBNe
         JHeNzz9jCMAbBGX3obxtowHGufNgBe406RSXesmCGEWUIX2hbCuTlt5/xEoPF4PHTAiG
         NpQTs31LVTl71Wt9OkhcufivaWpQK6KwHmZwgp3tloM9Mu3mCV/2VBunzEhYKEu2lePi
         D9XA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746311697; x=1746916497;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=uExTDiVgDAuuKf4/T4UqKfNg0MetNjVfsz9hfpKpcYA=;
        b=Pw09iZB13M3G0d6OYisQAfCToje57ZN6qH8/11OVyKXRd00Padvva8gUPVAAZxnVuf
         VVbegokWukbFmtxDdNmomTl03ffmwfJFyphZwMgxUGEnNOhCuYwiJgo4on4aLz5UyOIj
         vOa1kcb17tBzRtq4FTSrA8U3ZruIo3sjsPOlKS9yqveiBnGzBsWTDyla01Q5aA5bCJn1
         IgM98l7vIsM4bGEEwyavyXG6QoIQYnaXFA6tvNmm1rJPq14vIvaqPm5CKEzHKioTJswS
         cZk28AiqQlG/GTyaLEda1D/6I4OhAJTM/0uH3+UnUqcbdhJODlV832oZPZeuECT+pSoZ
         6CxA==
X-Gm-Message-State: AOJu0Yx9Q9alpZAydni9M353htZW/4c13JtoWoHdhaSPTQ4J1N3sr8sJ
	CsnMIJnagTif7adMbmOlVUMHghK386Y9iTLrvYw4HYl7/bhZqJKHcc5d0iHgvmxi4EmiCqxkEFH
	v
X-Gm-Gg: ASbGncs6cHEsB+lWcqa8qvwxwqfzzd7WdtHABnsKGBg/iynU/ELSSq2MAbTNwd8Ia8L
	Yj+9S+zrvaBB0z68w4MMgpepkREwgkjeRlH1gzChBxQqy5iW+GEbGZQiwP7F7Sg5uBtr5OEpV4N
	SoLKpjcCgGDEZJTbY8mnFgvWRtCkf1EXoHvQR4jn1IZmlN3bNcweyrvNEPdrvr4nTKcp8XsT/K8
	CrB4CQExDf9viHaRh+uWufmILf2k6tUrh+VAw7xT02GRp3ICOJl3os90IDAmgGU51D9u0nAKEjE
	TCOnJMsNTGdULwcjwx9Lwu/7bNAfDC2klpctRVMZuOD1SpeQJP8qcEmxh2xgZ9avr+6Hbu8vHYl
	Ixr5SKxcPWBm2QQ==
X-Google-Smtp-Source: AGHT+IFHY4pKipKTJBdqTgH0HFsloC+jZl+55hvOsyM23Zh8Kt21EVMX9btoaJiILh+H+E093FfJBA==
X-Received: by 2002:a17:903:1ac3:b0:227:e6b2:d989 with SMTP id d9443c01a7336-22e1ea8297bmr36086185ad.44.1746311696622;
        Sat, 03 May 2025 15:34:56 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-60-96.pa.nsw.optusnet.com.au. [49.181.60.96])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22e1522a71esm28639575ad.186.2025.05.03.15.34.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 03 May 2025 15:34:56 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.98.2)
	(envelope-from <david@fromorbit.com>)
	id 1uBLRc-0000000GdHH-3pxx;
	Sun, 04 May 2025 08:34:52 +1000
Date: Sun, 4 May 2025 08:34:52 +1000
From: Dave Chinner <david@fromorbit.com>
To: Roy Sigurd Karlsbakk <roy@karlsbakk.net>
Cc: linux-xfs@vger.kernel.org
Subject: Re: XFS complains about data corruption after xfs_repair
Message-ID: <aBaaDGrMdE6p0BiW@dread.disaster.area>
References: <9EA56046-FECD-42C5-AEF6-721A8699A45B@karlsbakk.net>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <9EA56046-FECD-42C5-AEF6-721A8699A45B@karlsbakk.net>

On Sat, May 03, 2025 at 04:01:48AM +0200, Roy Sigurd Karlsbakk wrote:
> Hi all
> 
> I have an XFS filesystem on an LVM LV which resides on a RAID-10 (md) with four Seagate Exos 16TB drives. This has worked well for a long time, but just now, it started complaining. The initial logs were showing a lot of errors and I couldn't access the filesystem, so I gave it a reboot, tha tis, I had to force one. Anyway - it booted up again and looked normal, but still complained. I rebooted to single and found the (non-root) filesystem already mounted and unable to unmount it, I commented it out from fstab and rebooted once more to single. This allowed me to run xfs_repair, although I had to use -L. Regardless, it finished and I re-enabled the filesystem in fstab and rebooted once more. Starting up now, it seems to work, somehow, but ext4 still throws some errors as shown below, that is, "XFS (dm-0): corrupt dinode 43609984, (btree extents)." It seems to be the same dinode each time.
> 
> Isn't an xfs_repair supposed to fix this?
> 
> I'm running Debian Bookworm 12.10, kernel 6.1.0-34-amd64 and xfsprogs 6.1.0 - everything just clean debian.

Can you pull a newer xfsprogs from debian/testing or /unstable or
build the latest versionf rom source and see if the problem
persists?

> [lø. mai 3 03:28:14 2025] XFS (dm-0): corrupt dinode 43609984, (btree extents).
> [lø. mai 3 03:28:14 2025] XFS (dm-0): Metadata corruption detected at xfs_iread_bmbt_block+0x271/0x2d0 [xfs], inode 0x2996f80 xfs_iread_bmbt_block
> [lø. mai 3 03:28:14 2025] XFS (dm-0): Unmount and run xfs_repair
> [lø. mai 3 03:28:14 2025] XFS (dm-0): First 72 bytes of corrupted metadata buffer:
> [lø. mai 3 03:28:14 2025] 00000000: 42 4d 41 33 00 00 00 f8 00 00 00 01 10 26 57 2a BMA3.........&W*
> [lø. mai 3 03:28:14 2025] 00000010: ff ff ff ff ff ff ff ff 00 00 00 06 61 32 b9 58 ............a2.X
> [lø. mai 3 03:28:14 2025] 00000020: 00 00 01 27 00 13 83 80 a4 0c 52 99 b8 45 4b 5b ...'......R..EK[
> [lø. mai 3 03:28:14 2025] 00000030: b6 3e 63 d8 b0 5e 20 5f 00 00 00 00 02 99 6f 80 .>c..^ _......o.
> [lø. mai 3 03:28:14 2025] 00000040: 7f fb a7 f6 00 00 00 00 ........

It is complaining that it is trying to load more extents than the
inode thinks it has allocated in ip->if_nextents.

That means either the btree has too many extents in it, or the inode
extent count is wrong. I can't tell which it might be from the
dump output, so it would be useful to know if xfs-repair is actually
detecting this issue, too.

Can you post the output from xfs_repair? Could you also pull a newer
xfs_reapir from debian/testing or build 6.14 from source and see if
the problem is detected and/or fixed?

-Dave.
-- 
Dave Chinner
david@fromorbit.com

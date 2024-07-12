Received: from mail-pg1-f178.google.com (mail-pg1-f178.google.com [209.85.215.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC69413210B
	for <linux-xfs@vger.kernel.org>; Fri, 12 Jul 2024 23:45:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720827909; cv=none; b=o5jLISFohox6RC37mpHH+FrlLoOaKK3yTub2bfF4xX7nPa038dx3QZNlQ6k2yfZ0ToAlNESQC4woboi3fn3zomEvMpTHxd+akz0GDLz5EOcsmnxY5ws1Mo6ZwG3ParYeii1MNbYgnrHC93QCFFEhSpMDlY9CcCesQ84GIS1K9CI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720827909; c=relaxed/simple;
	bh=h/LZxrwxUqXy9hHal5VrE3B30TUOcWcT3pccI5GYe+M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gMWUbr23lKUpYQtHN+JzbziBJ7hYqjETn+Dv262ble0a5D2IsksA+bTAGNDJJGK68NArd/S/3rQsVoqo7N01sm+6/q/OsRijWiMjq5bKcg8+EGkmU0q85qGueH5GV+Zp0dgNkxstxTE4KdA9uDfDnN/rr1E4O890lcfXqIcZOww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=wBpPTfZv; arc=none smtp.client-ip=209.85.215.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="wBpPTfZv"
Received: by mail-pg1-f178.google.com with SMTP id 41be03b00d2f7-78006198aeeso1617439a12.1
        for <linux-xfs@vger.kernel.org>; Fri, 12 Jul 2024 16:45:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1720827907; x=1721432707; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=eVWW/yo+o+buCpSvXz+qF7lpdbm1tv6lfeVq5aWPiGo=;
        b=wBpPTfZvE/IO2T4qOOXn8dPiHo2CGJVTzU8SbR1UGy4mh7QN+lSo7d/ZfVtAnRCLVO
         GFUT6HeiWLrPqnmloLr5cHYei591815hz41LvFqn0TAGODGgrrvDlMoMwcD6LKIBGvb3
         y5Mcgqy510Q6Khj1e0z8D4AyC9aCA9YqZ3V6+QffMOfJOCENlVwmCjs3h3tOMTCsRmK9
         20IPvn1SH35HeDY/s+TvZ2sTRl6aFEX7dGQ+7+kpQkvf5lcKHO7+MDbdtADGUBPc+pj/
         4NTLEnz8gpF8cb0921U73oBIT0lLGhbuwvueRi7fY3btwpMTzwZGtbAa9IRu444Y4FQe
         /nDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720827907; x=1721432707;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=eVWW/yo+o+buCpSvXz+qF7lpdbm1tv6lfeVq5aWPiGo=;
        b=MksLxAwXZ3b+N5fnPAtSERAdke7LvBdGFZdCF89gk9rsadUgcmKHH86xEDyP39ycxo
         ii0WDTw2kM+WkQNMnFOaPSQEGF25pWNj9KUVUkZBY4O9cGZL8IrBdF4b+gL9pbS2TRIH
         mPkqDRDEumaIELzkfHxpzDXmylsuBSCSVm0Ua+JgiGd6M0JpoN05EEAwR65raF3BHO2O
         L1Bh+16dlPXAVDQwprv+X088O4C6VZe56BU/dYam9i6ylzTQXoCktNJuCY4GZgQBPbXZ
         oQqL6/1vIGuC1l85n6f13n9c51KZt0A/R2D1lDrMPMpZMeDoB1te4YlKbqgAXCa5OwzB
         9T7w==
X-Forwarded-Encrypted: i=1; AJvYcCV0wManATUSs9RWYQ+ppioNE/GPssCRWd/FRrJMRLia5SI9pxXjoSz8E6Jzm/RthowapB44+T07su5QdJ+6qr951tJrLtV/5Xp1
X-Gm-Message-State: AOJu0YwE8O/DgZYLSC3VfSaOYh5fZk7xieLR5HJ6tRtKOyFZP+TNlgXE
	JRy6a/gxksvU+fCe3ml6FKN13xXljD0w8YknljXNFol/PtCOIomc/lLvronrAHc=
X-Google-Smtp-Source: AGHT+IGWisA19bn2YoMInNJz/sJ5PJTqPKkg3TXIW5l7SdIQvRdDtZbh1uY+chVkqYDosHhx6rxBDw==
X-Received: by 2002:a05:6a20:734b:b0:1c2:8c0c:e60e with SMTP id adf61e73a8af0-1c3becfaf24mr6608825637.15.1720827907218;
        Fri, 12 Jul 2024 16:45:07 -0700 (PDT)
Received: from dread.disaster.area (pa49-179-32-121.pa.nsw.optusnet.com.au. [49.179.32.121])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-70b7eb9c97fsm97002b3a.9.2024.07.12.16.45.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Jul 2024 16:45:06 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1sSPwl-00DksW-2o;
	Sat, 13 Jul 2024 09:45:03 +1000
Date: Sat, 13 Jul 2024 09:45:03 +1000
From: Dave Chinner <david@fromorbit.com>
To: Dragan =?utf-8?Q?Milivojevi=C4=87?= <galileo@pkm-inc.com>
Cc: Paul Menzel <pmenzel@molgen.mpg.de>, linux-raid@vger.kernel.org,
	linux-nfs@vger.kernel.org, linux-block@vger.kernel.org,
	linux-xfs@vger.kernel.org, it+linux-raid@molgen.mpg.de
Subject: Re: How to debug intermittent increasing md/inflight but no disk
 activity?
Message-ID: <ZpG///ZaN9KfPPcf@dread.disaster.area>
References: <4a706b9c-5c47-4e51-87fc-9a1c012d89ba@molgen.mpg.de>
 <Zo8VXAy5jTavSIO8@dread.disaster.area>
 <7c300510-bab8-4389-adba-c3219a11578d@pkm-inc.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <7c300510-bab8-4389-adba-c3219a11578d@pkm-inc.com>

On Fri, Jul 12, 2024 at 05:54:05AM +0200, Dragan Milivojević wrote:
> On 11/07/2024 01:12, Dave Chinner wrote:
> > Probably not a lot you can do short of reconfiguring your RAID6
> > storage devices to handle small IOs better. However, in general,
> > RAID6 /always sucks/ for small IOs, and the only way to fix this
> > problem is to use high performance SSDs to give you a massive excess
> > of write bandwidth to burn on write amplification....
> RAID5/6 has the same issues with NVME drives.
> Major issue is the bitmap.

That's irrelevant to the problem being discussed. The OP is
reporting stalls due to the bursty incoming workload vastly
outpacing the rate of draining of storage device. the above comment
is not about how close to "raw performace" the MD device gets on
NVMe SSDs - it's about how much faster it is for the given workload
than HDDs.

i.e. waht matters is the relative performance differential, and
according to you numbers below, it is at least two orders of
magnitude. That would make a 100s stall into a 1s stall, and that
would largely make the OP's problems go away....

> 5 disk NVMe RAID5, 64K chunk
> 
> Test                   BW         IOPS
> bitmap internal 64M    700KiB/s   174
> bitmap internal 128M   702KiB/s   175
> bitmap internal 512M   1142KiB/s  285
> bitmap internal 1024M  40.4MiB/s  10.3k
> bitmap internal 2G     66.5MiB/s  17.0k
> bitmap external 64M    67.8MiB/s  17.3k
> bitmap external 1024M  76.5MiB/s  19.6k
> bitmap none            80.6MiB/s  20.6k
> Single disk 1K         54.1MiB/s  55.4k
> Single disk 4K         269MiB/s   68.8k
> 
> Tested with fio --filename=/dev/md/raid5 --direct=1 --rw=randwrite
> --bs=4k --ioengine=libaio --iodepth=1 --runtime=60 --numjobs=1
> --group_reporting --time_based --name=Raid5

Oh, you're only testing a single depth block aligned async direct IO
random write to the block device. The problem case that was reported
was unaligned, synchronous buffered IO to multiple files through the
the filesystem page cache (i.e. RMW at the page cache level as well
as the MD device) at IO depths of up to 64 with periodic fsyncs
thrown into the mix. 

So the OP's workload was not only doing synchronous buffered writes,
they also triggered a lot of dependent synchronous random read IO to
go with the async write IOs issued by fsyncs and page cache
writeback.

If you were to simulate all that, I would expect that the difference
between HDDs and NVMe SSDs to be much greater than just 2 orders of
magnitude.

-Dave.
-- 
Dave Chinner
david@fromorbit.com

Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF7FD23C9
	for <linux-xfs@vger.kernel.org>; Tue, 26 Dec 2023 20:36:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="gi/TtOTA"
Received: by mail-pj1-f43.google.com with SMTP id 98e67ed59e1d1-28bc870c540so3548319a91.2
        for <linux-xfs@vger.kernel.org>; Tue, 26 Dec 2023 12:36:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1703622965; x=1704227765; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=CP+fgy3DlnC7I1w6Ho1Ct0NN9LxQpuWYkk7Ncyl6fas=;
        b=gi/TtOTA2ngaXvmVWp3uauiKtlQJCcylvkJXZ3yxp8KY3ABxBGDMQag4rbl6HTxT4R
         v9weljUz4efR//g5NfNwSA4JU/Uq004KP0Bv6MlNz5sJZdTSUpJQUIbn9uc6M+K4n8Qp
         Ai87m5/zyV/5EV+CQO6fFtP5fhWu/jCRT7y0BN9A/ufckxY22ZW265A4S3xZQxy5BnKI
         8tl8bsI7A9hFn7ZXXYwiTEtz23SZMbYIdvitrElO7rg8jSWnGqDij7mOwBoAYg7B8kTc
         klxqIYe+UurJuvlaf+bW9vKt9YquMTfOqYMOvWP/3KFBbSsVXhVcKOE7+AQyJIO1wQEg
         1yRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1703622965; x=1704227765;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CP+fgy3DlnC7I1w6Ho1Ct0NN9LxQpuWYkk7Ncyl6fas=;
        b=edJxe6DOU0rj34E0ZpUub5sb4MmRLeosX+DqyTeC5FhdshNkUMjzNuQvjoQyjLvv2i
         DF9QZkAb9fZfODSs6bRs9p3r5gBlsPuWmwIUQuULKWU1c6dbx7ITHMTnlavJ5ZF0nyQg
         9bjlWqjsIVRGq0Sl3+B6VzcNh35+UbuVOpYr/B/9KA5BhKHi7OMRHCe2f2LI/ixmVTIb
         sRG4mX64/EmMvOnHHImRPQSGrf1iWx41kdnDXyESfD+n6fJglDR8neubDpSEjnk1J9OR
         Ux/Pay0cjqETcnt5P3Q86dRvjS0T4YS0V1jFrAj3L5ba/oL2MsWAlmcRkpgtD9cuHGbo
         nT1w==
X-Gm-Message-State: AOJu0Ywon0py+G3auZSjEs6f+J+sFXt2iVQC/FOk3aDYS64Nbrh2gwE1
	YvLf8mI48oHfIvKRSkwwiz59SmwbndqPpg==
X-Google-Smtp-Source: AGHT+IHn/Mhhq+rmhETUsCrz2Dd8dBE234+1hC5FZ4r5JNy6ltbGS+gMfszsE831TBvTmInUIGbT/A==
X-Received: by 2002:a17:90a:7186:b0:28c:d9b:5983 with SMTP id i6-20020a17090a718600b0028c0d9b5983mr3336393pjk.48.1703622964980;
        Tue, 26 Dec 2023 12:36:04 -0800 (PST)
Received: from dread.disaster.area (pa49-180-249-6.pa.nsw.optusnet.com.au. [49.180.249.6])
        by smtp.gmail.com with ESMTPSA id t13-20020a17090b018d00b0028c7f8b5918sm1717083pjs.56.2023.12.26.12.36.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Dec 2023 12:36:04 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1rIE9g-0026OS-2t;
	Wed, 27 Dec 2023 07:36:00 +1100
Date: Wed, 27 Dec 2023 07:36:00 +1100
From: Dave Chinner <david@fromorbit.com>
To: Phillip Ferentinos <phillip.jf@gmail.com>
Cc: linux-xfs@vger.kernel.org
Subject: Re: Metadata corruption detected, fatal error -- couldn't map inode,
 err = 117
Message-ID: <ZYs5MFJ4kc+0saVC@dread.disaster.area>
References: <CACf8WVvuBpDwMdTor_oGobAKG6ELyUMmm4-HAu--eTfZqF5+Yg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACf8WVvuBpDwMdTor_oGobAKG6ELyUMmm4-HAu--eTfZqF5+Yg@mail.gmail.com>

On Thu, Dec 21, 2023 at 08:05:43PM -0600, Phillip Ferentinos wrote:
> Hello,
> 
> Looking for opinions on recovering a filesystem that does not
> successfully repair from xfs_repair.

What version of xfs_repair?

> On the first xfs_repair, I was
> prompted to mount the disk to replay the log which I did successfully.
> I created an image of the disk with ddrescue and am attempting to
> recover the data. Unfortunately, I do not have a recent backup of this
> disk.

There is lots of random damage all over the filesystem. What caused
this damage to occur? I generally only see this sort of widespread
damage when RAID devices (hardware or software) go bad...

Keep in mind that regardless of whether xfs_repair returns the
filesystem to a consistent state, the data in the filesystem is
still going to be badly corrupted. If you don't have backups, then
there's a high probability of significant data loss here....

> The final output of xfs_repair is:
> 
> Phase 5 - rebuild AG headers and trees...
>         - reset superblock...
> Phase 6 - check inode connectivity...
>         - resetting contents of realtime bitmap and summary inodes
>         - traversing filesystem ...
> rebuilding directory inode 12955326179
> Metadata corruption detected at 0x46fa05, inode 0x38983bd88 dinode

Can you run 'gdb xfs_repair' and run the command 'l *0x46fa05' to
dump the line of code that the error was detected at? You probably
need the distro debug package for xfsprogs installed to do this.

> fatal error -- couldn't map inode 15192014216, err = 117
> 
> The full log is:
> https://raw.githubusercontent.com/phillipjf/xfs_debug/main/xfs_repair_1.log

That's messy.

> Based on another discussion (https://narkive.com/4dDxIees.10), I've
> included the specific inode:
> https://raw.githubusercontent.com/phillipjf/xfs_debug/main/xfs_db_01.log

Nothing obviously wrong with that inode in the image file - it's a
directory inode in node format that looks to be internally
consistent.  But that inode has been processed earlier in the repair
process, so maybe it's bad in memory as a result of trying to fix
some other problem. Very hard to say given how much other stuff is
broken and is getting either trashed, re-initialised or repaired up
to that point....

> I also cannot create a metadump due to the following issue:
> https://raw.githubusercontent.com/phillipjf/xfs_debug/main/xfs_metadump_01.log.

No surprise, metadump has to traverse the metadata in order to dump
it, and if the metadata is corrupt then the traversals can fail
leading to a failed dump. The more badly damaged the filesystem is,
the more likely a metadump failure is.

-Dave.
-- 
Dave Chinner
david@fromorbit.com

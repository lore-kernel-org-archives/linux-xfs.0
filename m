Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3BF7FCD343C
	for <linux-xfs@archiver.kernel.org>; Tue, 19 Sep 2023 05:51:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231128AbjISFve (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 19 Sep 2023 01:51:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230513AbjISFvd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 19 Sep 2023 01:51:33 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4CC5FC
        for <linux-xfs@vger.kernel.org>; Mon, 18 Sep 2023 22:51:27 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id d9443c01a7336-1bf6ea270b2so39680425ad.0
        for <linux-xfs@vger.kernel.org>; Mon, 18 Sep 2023 22:51:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1695102687; x=1695707487; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=nV0EYWI8tvp/cEXKxNbM7kh696XH8foB3amsQbKYZis=;
        b=slddgMGvGI2aYmuFzVm1RanTUY/Q3Uni326Fc4MXT2e3E496MnblF1YpEWtelZ1dEG
         rmIK2lEqlxmmDypPuLoWgH9syIKPZOtsPGTuK++fIdEoA2Cmzz+v+mw6y+v/ERCAna70
         YSe0j6G/t2tdN+xdszyvSDE6Fpm1kJTMUfqZkzeSvqeKfihJkXp2HY3em4PCNMPgpeCY
         FTfqprG3hsoAVCfxkMf7RIcsoA0YQhIFEuvm9UiDhU3yue7WDFhcz/8R1wezf5BtDfjZ
         sYCCHJvpOWWItgiO+N6ipjWQfiybTLWnRy3I2TvSE3tsfMyRlJGibwEAR0uUUEb+r/1g
         KTow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695102687; x=1695707487;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nV0EYWI8tvp/cEXKxNbM7kh696XH8foB3amsQbKYZis=;
        b=g1vudAwJ+hxei+wWJV1oYmbjyes+RC2Jb2iRslB/0KBo0EeDcdGfG/Jr3OwV+/7lwJ
         Mei5l+IRZNJuzkFJa1Jvg7uWgBetkkzzJ5+OBDqK+5Q2UwLFboT/h1b73HFvAp1C6jxt
         7n6ZZxj78mIqqKoazq1hbGZftuc/C+nBpMYjT0dUF3e+iTUIN6hzoG9mJXWNb+5UKmRQ
         68IOaZ6CYR82YidiuY8FJ5h+pfyd90SgAw2QSeg2sifqL7jIJIm0PwUfs4QKg39RuTT2
         XElHle5mrzVtXj1ilqOzrKBTwCguExRKYqleUZoe5EghE/UN/mk6lYlGJgyICt0DV5pv
         4zNw==
X-Gm-Message-State: AOJu0YyV5JGCye2ljZRC/FEaxUajEtXxxORSkXS816i2VrdHMT74Ddu2
        aEmJv9Zpq+m5Ia5cdDCjFLKPfA==
X-Google-Smtp-Source: AGHT+IERXVnGNNp60R8H4+EnaYv9MWW2lFWZR8krg890dfrNgzGKwbxVRefGwplEoxU5oHKu2NpMtQ==
X-Received: by 2002:a17:902:9303:b0:1c3:a1a8:969a with SMTP id bc3-20020a170902930300b001c3a1a8969amr9280140plb.8.1695102687007;
        Mon, 18 Sep 2023 22:51:27 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-20-59.pa.nsw.optusnet.com.au. [49.180.20.59])
        by smtp.gmail.com with ESMTPSA id j1-20020a170902da8100b001c3cbedbc47sm4974854plx.6.2023.09.18.22.51.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Sep 2023 22:51:26 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
        (envelope-from <david@fromorbit.com>)
        id 1qiTds-002fFP-0Y;
        Tue, 19 Sep 2023 15:51:24 +1000
Date:   Tue, 19 Sep 2023 15:51:24 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Catherine Hoang <catherine.hoang@oracle.com>
Cc:     "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
        "Darrick J. Wong" <djwong@kernel.org>
Subject: Re: proposal: enhance 'cp --reflink' to expose ioctl_ficlonerange
Message-ID: <ZQk23NIAcY0BDpfI@dread.disaster.area>
References: <8911B94D-DD29-4D6E-B5BC-32EAF1866245@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8911B94D-DD29-4D6E-B5BC-32EAF1866245@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Sep 19, 2023 at 02:43:32AM +0000, Catherine Hoang wrote:
> Hi all,
> 
> Darrick and I have been working on designing a new ioctl FICLONERANGE2. The
> following text attempts to explain our needs and reasoning behind this decision. 
> 
> 
> Contents
> --------
> 1. Problem Statement
> 2. Proof of Concept
> 3. Proposed Solution
> 4. User Interface
> 5. Testing Plan
> 
> 
> 1. Problem Statement
> --------------------
> 
> One of our VM cluster management products needs to snapshot KVM image files
> so that they can be restored in case of failure. Snapshotting is done by
> redirecting VM disk writes to a sidecar file and using reflink on the disk
> image, specifically the FICLONE ioctl as used by "cp --reflink". Reflink
> locks the source and destination files while it operates, which means that
> reads from the main vm disk image are blocked, causing the vm to stall. When
> an image file is heavily fragmented, the copy process could take several
> minutes. Some of the vm image files have 50-100 million extent records, and
> duplicating that much metadata locks the file for 30 minutes or more. Having
> activities suspended for such a long time in a cluster node could result in
> node eviction. A node eviction occurs when the cluster manager determines
> that the vm is unresponsive. One of the criteria for determining that a VM
> is unresponsive is the failure of filesystems in the guest to respond for an
> unacceptably long time. In order to solve this problem, we need to provide a
> variant of FICLONE that releases the file locks periodically to allow reads
> to occur as vmbackup runs. The purpose of this feature is to allow vmbackup
> to run without causing downtime.

Interesting problem to have - let me see if I understand it
properly.

Writes are redirected away from the file being cloned, but reads go
directly to the source file being cloned?

But cloning can take a long time, so breaking up the clone operation
into multiple discrete ranges will allow reads through
to the file being cloned with minimal latency. However, you don't
want writes to the source file because that results in the
atomicity of the clone operation being violated and corrupting the
snapshot.

Hence the redirected writes ensure that the file being cloned does
not change from syscall to syscall. This means the time interrupted
clone operation can restart from where it left off and you still get
an consistent image clone for the snapshot.

Did I get that right?


If so, I'm wondering about the general usefulness of this
multi-syscall construct - having to ensure that it isn't written to
between syscalls is quite the constraint.

I wonder if we can do better than that and not need a new syscall;
shared read + clone seems more like an inode extent list access
serialisation problem than anything else...

<thinks for a bit>

Ok. a clone does not change any data in the source file.

Neither do read IO operations.

Hence from a data integrity perspective, there's no reason why read
IO and FICLONE can't run concurrently on the source file.

Writes we still need to block so that the clone is an atomic
point in time image of the file, but reads could be allowed.

The XFS clone implementation takes the IOLOCK_EXCL high up, and
then lower down it iterates one extent doing the sharing operation.
It holds the ILOCK_EXCL while it is modifying the extent in both the
source and destination files, then commits the transaction and drops
the ILOCKs.

OK, so we have fine-grained ILOCK serialisation during the clone for
access/modification to the extent list. Excellent, I think we can
make this work.

So:

1. take IOLOCK_EXCL like we already do on the source and destination
files.

2. Once all the pre work is done, set a "clone in progress" flag on
the in-memory source inode.

3. atomically demote the source inode IOLOCK_EXCL to IOLOCK_SHARED.

4. read IO and the clone serialise access to the extent list via the
ILOCK. We know this works fine, because that's how the extent list
access serialisation for concurrent read and write direct IO works.

5. buffered writes take the IOLOCK_EXCL, so they block until the
clone completes. Same behaviour as right now, all good.

6. direct IO writes need to be modified to check the "clone in
progress" flag after taking the IOLOCK_SHARED. If it is set, we have
to drop the IOLOCK_SHARED and take it IOLOCK_EXCL. This will block
until the clone completes.

7. when the clone completes, we clear the "clone in progress" flag
and drop all the IOLOCKs that are held.

AFAICT, this will give us shared clone vs read and exclusive clone
vs write IO semantics for all clone operations. And if I've
understood the problem statement correctly, this will avoid the
read IO latency problems that long running clone operations cause
without needing a new syscall.

Thoughts?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

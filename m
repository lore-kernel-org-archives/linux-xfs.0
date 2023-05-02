Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA026C77B78
	for <linux-xfs@archiver.kernel.org>; Tue,  2 May 2023 22:03:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229497AbjEBWDF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 2 May 2023 18:03:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbjEBWDE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 2 May 2023 18:03:04 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC834213F
        for <linux-xfs@vger.kernel.org>; Tue,  2 May 2023 15:03:02 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id d2e1a72fcca58-63b70f0b320so4993605b3a.1
        for <linux-xfs@vger.kernel.org>; Tue, 02 May 2023 15:03:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20221208.gappssmtp.com; s=20221208; t=1683064982; x=1685656982;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Gvk5L9q0z3+Cf/cELu8MxyVXSJDMNTnQ7fFNyVE1+9Y=;
        b=kRBF78vaI+7Ht/rGCuqw5v+z6TgQskwUsxHERoIy7/0iOXNi1N0NP0kALGaawJG5IK
         KcdWzIkdbQdF5NyuD+8aPEB5nELhp1sY8FPKNJR2l5/sexNSjtIU1YmgNaI8fk6Tmm62
         lg2lyoc+KB1rG4UUcFSJESd6gsY0OtWfqyGu5dezIY3WSddt/DbHJQONCaujmLYmig2E
         jqC7Td+MNgUv9PglEU5jcl9W156y8984uty/QBHXnUbfScdAA52YcFOI0II25WtgWtSd
         oy3hTvEGsox7MYNmKrXvHqjiKYgYVa+w5rn6DQ6Lgevip7bcdOmDpl6ZPurS2dcBIGT4
         RtMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683064982; x=1685656982;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Gvk5L9q0z3+Cf/cELu8MxyVXSJDMNTnQ7fFNyVE1+9Y=;
        b=iOuziWCzU3BjEz2bGd8CCzjJEYzPCYEcx0AJ4WF5TwzTOIkoo7HEnpO1T1u3u0TJUb
         vlB3Mim50vIUfsAGQfDxWglBoZjw982ZxWQ+fyD4V6w9o5U+axbwCtAxi3AlwhvZMPRV
         4ql0Xx4bp965ErSi3l973eaGw6JtCmkd2T5XB+Xfh7U7/hpnYr6zo+nNiety3AXTKNq1
         e3O2+XiFuXo0ONImqtdMkxyWNQJ6W3JRyXI65XwXD+ichsgBplVGqylVhA9xfYWjtvMH
         BoPcFHIAVfrKoAeEOjzT/T/zKH8eYe0Tw05JX789jHm58/FvptU0oCDbhaFPDC5zIqcW
         mdqw==
X-Gm-Message-State: AC+VfDwI4M8El0Fwv6qvXPbbiksJSH82Bxvjf8rjirWXt8uAockgDVv3
        uo1MG2DqbRT7mLn7yEaWS/edMr5jp3UlfC6Og24=
X-Google-Smtp-Source: ACHHUZ4b/vBtv8fXX7vmCL892FCCunVGuaHF44TTf2rdBSaImtkhGgVCCJfY7vDQYs+BkZmWHEnO5w==
X-Received: by 2002:aa7:88cf:0:b0:63e:fb6d:a1c0 with SMTP id k15-20020aa788cf000000b0063efb6da1c0mr27169009pff.33.1683064982153;
        Tue, 02 May 2023 15:03:02 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-88-204.pa.nsw.optusnet.com.au. [49.181.88.204])
        by smtp.gmail.com with ESMTPSA id i14-20020a655b8e000000b0051f14839bf3sm19258929pgr.34.2023.05.02.15.03.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 May 2023 15:03:01 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1pty5K-00Ac9w-8Z; Wed, 03 May 2023 08:02:58 +1000
Date:   Wed, 3 May 2023 08:02:58 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Mike Pastore <mike@oobak.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: Corruption of in-memory data (0x8) detected at
 xfs_defer_finish_noroll on kernel 6.3
Message-ID: <20230502220258.GA3223426@dread.disaster.area>
References: <CAP_NaWaozOVBoJXtuXTRUWsbmGV4FQUbSPvOPHmuTO7F_FdA4g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAP_NaWaozOVBoJXtuXTRUWsbmGV4FQUbSPvOPHmuTO7F_FdA4g@mail.gmail.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, May 02, 2023 at 02:14:34PM -0500, Mike Pastore wrote:
> Hi folks,
> 
> I was playing around with some blockchain projects yesterday and had
> some curious crashes while syncing blockchain databases on XFS
> filesystems under kernel 6.3.
> 
>   * kernel 6.3.0 and 6.3.1 (ubuntu mainline)
>   * w/ and w/o the discard mount flag
>   * w/ and w/o -m crc=0
>   * ironfish (nodejs) and ergo (jvm)
> 
> The hardware is as follows:
> 
>   * Asus PRIME H670-PLUS D4
>   * Intel Core i5-12400
>   * 32GB DDR4-3200 Non-ECC UDIMM
> 
> In all cases the filesystems were newly-created under kernel 6.3 on an
> LVM2 stripe and mounted with the noatime flag. Here is the output of
> the mkfs.xfs command (after reverting back to 6.2.14—which I realize
> may not be the most helpful thing, but here it is anyway):
> 
> $ sudo lvremove -f vgtethys/ironfish
> $ sudo lvcreate -n ironfish-L 10G -i2 vgtethys /dev/nvme[12]n1p3
>   Using default stripesize 64.00 KiB.
>   Logical volume "ironfish" created.
> $ sudo mkfs.xfs -m crc=0 -m uuid=b4725d43-a12d-42df-981a-346af2809fad
> -s size=4096 /dev/vgtethys/ironfish
> meta-data=/dev/vgtethys/ironfish isize=256    agcount=16, agsize=163824 blks
>          =                       sectsz=4096  attr=2, projid32bit=1
>          =                       crc=0        finobt=0, sparse=0, rmapbt=0
>          =                       reflink=0    bigtime=0 inobtcount=0
> data     =                       bsize=4096   blocks=2621184, imaxpct=25
>          =                       sunit=16     swidth=32 blks

Stripe aligned allocation is enabled. Does the problem go away
when you use mkfs.xfs -d noalign .... ?

> The applications crash with I/O errors. Here's what I see in dmesg:
> 
> May 01 18:56:59 tethys kernel: XFS (dm-28): Internal error bno + len >
> gtbno at line 1908 of file fs/xfs/libxfs/xfs_alloc.c.  Caller
> xfs_free_ag_extent+0x14e/0x950 [xfs]

                        /*                                                       
                         * If this failure happens the request to free this      
                         * space was invalid, it's (partly) already free.        
                         * Very bad.                                             
                         */                                                      
                        if (XFS_IS_CORRUPT(mp, ltbno + ltlen > bno)) {           
                                error = -EFSCORRUPTED;                           
                                goto error0;                                     
                        }                                                        

That failure implies the btree records are corrupt in memory,
possibly due to memory corruption from something outside the XFS
code (e.g. use after free).

> May 01 18:56:59 tethys kernel: CPU: 2 PID: 48657 Comm: node Tainted: P
>           OE      6.3.1-060301-generic #202304302031

The kernel being run has been tainted by out of tree proprietary
drivers (a common source of memory corruption bugs in my
experience). Can you reproduce this problem with an untainted
kernel?

....

> And here's what I see in dmesg after rebooting and attempting to mount
> the filesystem to replay the log:
> 
> May 01 21:34:15 tethys kernel: XFS (dm-35): Metadata corruption
> detected at xfs_inode_buf_verify+0x168/0x190 [xfs], xfs_inode block
> 0x1405a0 xfs_inode_buf_verify
> May 01 21:34:15 tethys kernel: XFS (dm-35): Unmount and run xfs_repair
> May 01 21:34:15 tethys kernel: XFS (dm-35): First 128 bytes of
> corrupted metadata buffer:
> May 01 21:34:15 tethys kernel: 00000000: 5b 40 e2 3a ae 52 a0 7a 17 1d

That's not an inode buffer. It's not recognisable as XFS metadata at
all, which indicates some other problem.

Oh, this was from a test with "mkfs.xfs -m crc=0 ...", right? Please
don't use "-m crc=0" - that format is deprecated partly because it
has unfixable on-disk format recovery issues. One of those issues
manifests as an inode recovery failure because the underlying inode
buffer allocation/init does not get replayed correctly before we
attempt to replay inode changes into the buffer (that has not be
initialised)....

i.e. one of those unfixable issues manifest exactly like the
recovery failure being reported here.

> Blockchain projects tend to generate pathological filesystem loads;
> the sustained random write activity and constant (re)allocations must
> be pushing on some soft spot here.

There was a significant allocator infrastructure rewrite in 6.3. If
running an untainted kernel on an unaligned, CRC enabled filesystem
makes the problems go away, then it rules out known issues with the
rewrite.

Alternatively, if it is reproducable in a short time, you may be
able to bisect the XFS changes that landed between 6.2 and 6.3 to
find which change triggers the problem.

> Reverting to kernel 6.2.14 and
> recreating the filesystems seems to have resolved the issue—so far, at
> least—but obviously this is less than ideal. If someone would be
> willing to provide a targeted listed of desired artifacts I'd be happy
> to boot back into kernel 6.3.1 to reproduce the issue and collect
> them. Alternatively I can try to eliminate some variables (like LVM2,
> potential hardware instabilities, etc.) and provide step-by-step
> directions for reproducing the issue on another machine.

If you can find a minimal reproducer, that would help a lot in
diagnosing the issue.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

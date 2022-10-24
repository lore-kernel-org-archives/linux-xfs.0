Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0508C38A2D
	for <linux-xfs@archiver.kernel.org>; Mon, 24 Oct 2022 05:44:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230077AbiJXFoB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 24 Oct 2022 01:44:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229520AbiJXFoA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 24 Oct 2022 01:44:00 -0400
Received: from mail-oa1-x36.google.com (mail-oa1-x36.google.com [IPv6:2001:4860:4864:20::36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5B0D7B291
        for <linux-xfs@vger.kernel.org>; Sun, 23 Oct 2022 22:43:59 -0700 (PDT)
Received: by mail-oa1-x36.google.com with SMTP id 586e51a60fabf-12c8312131fso10780242fac.4
        for <linux-xfs@vger.kernel.org>; Sun, 23 Oct 2022 22:43:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=NzWkQ3S5PjX5kJ4wIGZV4OjNz+s3GvMcwAnH0+V8NPc=;
        b=I1HAogI9WcOg/l1b+YH+WynE0Ksf+bGK2azho48qHyLMB6PBUKRUT9Q9PkwmYbjy92
         NTX32/r/3q84J9AeHiuQKkE68goNGLas+E7kPeu3CgDHQxO0pmNQ0RU9VF6RIeYyfweo
         1pLR/cq7RvaUzbzup2RWXi5bVChMBdD5rMdJh5Zee40JIFur1brArG/Odi9FsW3UHcMY
         wd1vvP+TWEQN6PJY40bf/PgAO8BEO/BTshqYL76HBPQH90qe8gvQJOfiZ+kuiY112Dn/
         LAAoZlHdZMxPyP3pp2KCZlGWRdc6OZ7rmV1sGzc/hJjAedJOOrHqJI6EJgHg9D1+cZ6Z
         WYAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NzWkQ3S5PjX5kJ4wIGZV4OjNz+s3GvMcwAnH0+V8NPc=;
        b=OQHzeFdY7EUY1/yBKgrkAyuO3nGeP/WcZeI6zPrnGeBpR/LdS20YyLxpPwIALx8SEY
         UZMTVbM0i6ARQ5oEdVSWTsBirSRwwC39dHwWTpDDeb5KztPANks4dGc0cOekJgIRUKh2
         Hg1TYjO7rslCFWNwU/FVDJ4RCmXjdo9eExosHSEpcnmyk0Omv9JL36SjdGW1uXuL4qeY
         MwYEtSobVSNUHwVwoH6k4YBw8Yw0tnH6P6bsVkPEoJxcpTJgNUQMPV02mJTm5i1EUCPl
         gHPR0CnhrnTJWbZOUjS2x+gCNXrgNjM1FaBOIf/BrY881kIMepn/p0bOheTi4GEpzTqY
         WC0w==
X-Gm-Message-State: ACrzQf1ZLnVRGoH2NPR8GVsoKN+taFB+YIZjYFQhw3j041+j2Yf1KoQh
        Lquqql+ycUUeS1WrZSLMwXhEFqB/7YOEPQ==
X-Google-Smtp-Source: AMsMyM7OIevFFE6SJtmxm0ujzBBZsVDUcoWIPyoJleFTTpLeGjV2abt6bwCBDwOiqsiNoZvrXB8p6w==
X-Received: by 2002:a17:90a:5915:b0:20a:d6d5:31bd with SMTP id k21-20020a17090a591500b0020ad6d531bdmr36232275pji.15.1666590228680;
        Sun, 23 Oct 2022 22:43:48 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-106-210.pa.nsw.optusnet.com.au. [49.181.106.210])
        by smtp.gmail.com with ESMTPSA id d9-20020aa797a9000000b0056ba7ce4d5asm2224020pfq.52.2022.10.23.22.43.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 23 Oct 2022 22:43:48 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1omqFV-005iLa-8u; Mon, 24 Oct 2022 16:43:45 +1100
Date:   Mon, 24 Oct 2022 16:43:45 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Long Li <leo.lilong@huawei.com>,
        Dave Chinner <dchinner@redhat.com>,
        Chandan Babu R <chandan.babu@oracle.com>,
        Eric Sandeen <sandeen@redhat.com>,
        Bill O'Donnell <billodo@redhat.com>, linux-xfs@vger.kernel.org,
        yi.zhang@huawei.com, houtao1@huawei.com, guoxuenan@huawei.com
Subject: Re: [PATCH v1] xfs: fix sb write verify for lazysbcount
Message-ID: <20221024054345.GZ3600936@dread.disaster.area>
References: <20221022020345.GA2699923@ceph-admin>
 <Y1NSBMwgUYxhW4PE@magnolia>
 <20221022120125.GA2052581@ceph-admin>
 <20221022211613.GW3600936@dread.disaster.area>
 <Y1YPjkiiN3FyMBfG@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y1YPjkiiN3FyMBfG@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Oct 23, 2022 at 09:07:42PM -0700, Darrick J. Wong wrote:
> On Sun, Oct 23, 2022 at 08:16:13AM +1100, Dave Chinner wrote:
> > On Sat, Oct 22, 2022 at 08:01:25PM +0800, Long Li wrote:
> > > On Fri, Oct 21, 2022 at 07:14:28PM -0700, Darrick J. Wong wrote:
> > > > On Sat, Oct 22, 2022 at 10:03:45AM +0800, Long Li wrote:
> > > > > When lazysbcount is enabled, multiple threads stress test the xfs report
> > > > > the following problems:
> > 
> > We've had lazy sb counters for 15 years and just about every XFS
> > filesystem in production uses them, so providing us with some idea
> > of the scope of the problem and how to reproduce it would be greatly
> > appreciated.
> > 
> > What stress test are you running? What filesystem config does it
> > manifest on (other than lazysbcount=1)?  How long does the stress
> > test run for, and where/why does log recovery get run in this stress
> > test?
> > 
> > > > > XFS (loop0): SB summary counter sanity check failed
> > > > > XFS (loop0): Metadata corruption detected at xfs_sb_write_verify
> > > > > 	     +0x13b/0x460, xfs_sb block 0x0
> > > > > XFS (loop0): Unmount and run xfs_repair
> > > > > XFS (loop0): First 128 bytes of corrupted metadata buffer:
> > > > > 00000000: 58 46 53 42 00 00 10 00 00 00 00 00 00 28 00 00  XFSB.........(..
> > > > > 00000010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
> > > > > 00000020: 69 fb 7c cd 5f dc 44 af 85 74 e0 cc d4 e3 34 5a  i.|._.D..t....4Z
> > > > > 00000030: 00 00 00 00 00 20 00 06 00 00 00 00 00 00 00 80  ..... ..........
> > > > > 00000040: 00 00 00 00 00 00 00 81 00 00 00 00 00 00 00 82  ................
> > > > > 00000050: 00 00 00 01 00 0a 00 00 00 00 00 04 00 00 00 00  ................
> > > > > 00000060: 00 00 0a 00 b4 b5 02 00 02 00 00 08 00 00 00 00  ................
> > > > > 00000070: 00 00 00 00 00 00 00 00 0c 09 09 03 14 00 00 19  ................
> > > > > XFS (loop0): Corruption of in-memory data (0x8) detected at _xfs_buf_ioapply
> > > > > 	+0xe1e/0x10e0 (fs/xfs/xfs_buf.c:1580).  Shutting down filesystem.
> > > > > XFS (loop0): Please unmount the filesystem and rectify the problem(s)
> > > > > XFS (loop0): log mount/recovery failed: error -117
> > > > > XFS (loop0): log mount failed
> > > > > 
> > > > > The cause of the problem is that during the log recovery process, incorrect
> > > > > icount and ifree are recovered from the log and fail to pass the size check
> > > > 
> > > > Are you saying that the log contained a transaction in which ifree >
> > > > icount?
> > > 
> > > Yes, this situation is possible. For example consider the following sequence:
> > > 
> > >  CPU0				    CPU1
> > >  xfs_log_sb			    xfs_trans_unreserve_and_mod_sb
> > >  ----------			    ------------------------------
> > >  percpu_counter_sum(&mp->m_icount)
> > > 				    percpu_counter_add(&mp->m_icount, idelta)
> > > 				    percpu_counter_add_batch(&mp->m_icount,
> > > 						  idelta, XFS_ICOUNT_BATCH)
> > >  percpu_counter_sum(&mp->m_ifree)
> > 
> > What caused the xfs_log_sb() to be called? Very few things
> > actually log the superblock this way at runtime - it's generally
> > only logged directly like this when a feature bit changes during a
> > transaction (rare) or at a synchronisation point when everything
> > else is idle and there's no chance of a race like this occurring...
> > 
> > I can see a couple of routes to this occurring via feature bit
> > modification, but I don't see them being easy to hit or something
> > that would exist for very long in the journal. Hence I'm wondering
> > if there should be runtime protection for xfs_log_sb() to avoid
> > these problems....
> 
> Maybe.  Or perhaps we sample m_i{count,free} until they come up with a
> value that will pass the verifier, and only then log the new values to
> the primary super xfs_buf?

I suspect the simplest thing to do is this:

	mp->m_sb.sb_ifree = min_t(uint64_t, percpu_counter_sum(&mp->m_ifree),
				mp->m_sb.sb.icount);

That way ifree will never be logged as being greater than icount.
Neither icount or ifree will be accurate if we are racing with other
updates, but it will guarantee that what we write to the journal
won't trigger corruption warnings.

-Dave.
-- 
Dave Chinner
david@fromorbit.com

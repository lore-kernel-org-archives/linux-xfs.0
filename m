Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E32CEB64DC
	for <linux-xfs@archiver.kernel.org>; Tue, 11 Jul 2023 23:11:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229963AbjGKXLa (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 11 Jul 2023 19:11:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229548AbjGKXL3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 11 Jul 2023 19:11:29 -0400
Received: from mail-il1-x12b.google.com (mail-il1-x12b.google.com [IPv6:2607:f8b0:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0F40E0
        for <linux-xfs@vger.kernel.org>; Tue, 11 Jul 2023 16:11:28 -0700 (PDT)
Received: by mail-il1-x12b.google.com with SMTP id e9e14a558f8ab-345fcf8951fso22292575ab.1
        for <linux-xfs@vger.kernel.org>; Tue, 11 Jul 2023 16:11:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20221208.gappssmtp.com; s=20221208; t=1689117088; x=1691709088;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=9zHv9U6VdMFObI2cdyXywldeuXz2yxyQHleNm7RHbME=;
        b=YsKO/tRacZ1bMhVM+3AJD8QtIwapS1d7HQkfh2aOUDdDkCg4JXwt6umBeWPh7WoDtT
         B0Y+ZoDN/oeeBXwkYyvfLuXz+tuJpbqJPAjUwSKjlUOuUHuPQ8EIGG8NrXVIuqTCs37e
         yhQ/B6Cu+CEa+5hJHygJN9i8LkmG3l5Yfvo+LXROjPWdu4ykVKAw9qGfZW97dmPnUw2r
         0Z7p2pBK9MyoABOVn70lGuW7MiO85YGI3blu+h95qAKEwSLoPqDWtk2vfzYKET2qTKQL
         g7eYLmyJhtHokpP3iy1hSNUjCTCqczyT9e6rOiiB3tVoW0/5uh3DrkgU0HrHbE5V6ms3
         JDNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689117088; x=1691709088;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9zHv9U6VdMFObI2cdyXywldeuXz2yxyQHleNm7RHbME=;
        b=D2ndpZurJta8iZjTbtMS6ZEC75ck+/I09BDHexOLmaBLtKL7sloWFYxU1y2/rr4X/I
         eJUTVVKA9mJMkovIQ3BQ/rbQIlgHJZ6E37CNnbqBbZhZSN80b7DS3Y4SgKs0MSAAhlYH
         B1wQ6J+mFYn8VJmv2SP1Ml/2T7em3OvCqcfI54BI8SGI7VMa9zK0gGAcs+c2ATuUj5FL
         Fm/VgvwgZ0DKPTjS3yJMqhe74Y549GdNhzr4lgTq/BzDPZMEGw6E+URirO0hHl8h6lQe
         y6j4a1YMZ4Bp+WCU4jZTTrzXoRB15yE5+8Logb9lJo3PA7qppqrlfzr7OFP/wOYI488l
         jHHg==
X-Gm-Message-State: ABy/qLbRKLnqi/jIQey+OcWbLYx/ckl0mDh3+tPjuOhRM1RNT6uTpOAH
        TZMJvI49a9uiYaX0SVO/7Ww0p9OVLlhIX3ngyxs=
X-Google-Smtp-Source: APBJJlG5xCWUOskd3LXrLs1o0cCSkVGwBnhCeNY2FGp31cps94f7OHKmzauyHc1KEdgqNzYZFyanww==
X-Received: by 2002:a92:d185:0:b0:346:5d44:dc1b with SMTP id z5-20020a92d185000000b003465d44dc1bmr8125632ilz.10.1689117088035;
        Tue, 11 Jul 2023 16:11:28 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-246-40.pa.nsw.optusnet.com.au. [49.180.246.40])
        by smtp.gmail.com with ESMTPSA id d3-20020a17090abf8300b002633fa95ac2sm8614541pjs.13.2023.07.11.16.11.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Jul 2023 16:11:27 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
        (envelope-from <david@fromorbit.com>)
        id 1qJMVw-004xzI-1F;
        Wed, 12 Jul 2023 09:11:24 +1000
Date:   Wed, 12 Jul 2023 09:11:24 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Eugene K." <eugene@railglorg.net>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: XFS writing issue
Message-ID: <ZK3hnAdXshfFSYYb@dread.disaster.area>
References: <583703ce-1515-a436-1f34-3386150a03c2@railglorg.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <583703ce-1515-a436-1f34-3386150a03c2@railglorg.net>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jul 11, 2023 at 05:31:13PM +0200, Eugene K. wrote:
> Hello.
> 
> During investigation of flapping performance problem, it was detected that
> once a process writes big amount of data in a row, the filesystem focus on
> this writing and no other process can perform any IO on this filesystem.

What hardware are you testing on? ram, cpus, SSD models, etc.

Also, xfs_info for the filesystem you are testing, output of 'grep .
/proc/sys/vm/*' as well as dumps of 'iostat -dxm 1' and 'vmstat 1'
while you are running the test. Also capture the dmesg output of
'echo w > /proc/sysrq-trigger' and 'cat /proc/meminfo' multiple
times while the test is running.

> We have noticed huge %iowait on software raid1 (mdraid) that runs on 2 SSD
> drives - on every attempt to write more than 1GB.

I would expect "huge" iowait for this workload because the
bandwidth of the pipe is much greater than the bandwidth of your MD
device and so the writes to the fs get throttled in
balance_dirty_pages_ratelimited() once a certain percentage of RAM
is dirtied.

> The issue happens on any server running 6.4.2, 6.4.0, 6.3.3, 6.2.12 kernel.
> Upon investigating and testing it appeared that server IO performance can be
> completely killed with a single command:
> 
> #cat /dev/zero > ./removeme

flat profile from 'perf top -U':

  35.85%  [kernel]  [k] __pv_queued_spin_lock_slowpath
   6.86%  [kernel]  [k] rep_movs_alternative
   5.92%  [kernel]  [k] do_raw_spin_lock
   5.61%  [kernel]  [k] __raw_callee_save___pv_queued_spin_unlock
   2.62%  [kernel]  [k] rep_stos_alternative
   2.25%  [kernel]  [k] do_raw_spin_unlock
   1.77%  [kernel]  [k] __folio_end_writeback
   1.68%  [kernel]  [k] xas_start
   1.60%  [kernel]  [k] xas_descend
   1.46%  [kernel]  [k] __remove_mapping
   1.36%  [kernel]  [k] __folio_start_writeback
   1.05%  [kernel]  [k] __filemap_add_folio
   0.98%  [kernel]  [k] iomap_write_begin
   0.87%  [kernel]  [k] percpu_counter_add_batch
   0.83%  [kernel]  [k] folio_clear_dirty_for_io
   0.82%  [kernel]  [k] get_page_from_freelist  
   0.79%  [kernel]  [k] iomap_write_end         
   0.78%  [kernel]  [k] inode_to_bdi
   0.72%  [kernel]  [k] folio_unlock 
   0.71%  [kernel]  [k] node_dirty_ok
   0.71%  [kernel]  [k] __mod_node_page_state
   0.65%  [kernel]  [k] write_cache_pages
   0.65%  [kernel]  [k] __might_resched        
   0.65%  [kernel]  [k] __mod_lruvec_page_state
   0.64%  [kernel]  [k] iomap_do_writepage
   0.57%  [kernel]  [k] xas_store         
   0.53%  [kernel]  [k] shrink_folio_list
   0.50%  [kernel]  [k] balance_dirty_pages_ratelimited_flags
   0.49%  [kernel]  [k] __mod_memcg_lruvec_state
   0.49%  [kernel]  [k] filemap_dirty_folio
   0.48%  [kernel]  [k] __folio_mark_dirty
   0.48%  [kernel]  [k] __rmqueue_pcplist
   0.48%  [kernel]  [k] __rcu_read_lock         
   0.45%  [kernel]  [k] xas_load             
   0.43%  [kernel]  [k] __mod_zone_page_state
   0.40%  [kernel]  [k] lru_add_fn
   0.39%  [kernel]  [k] __list_del_entry_valid
   0.38%  [kernel]  [k] mod_zone_page_state   
   0.37%  [kernel]  [k] __filemap_remove_folio
   0.36%  [kernel]  [k] node_page_state    
   0.34%  [kernel]  [k] __filemap_get_folio
   0.33%  [kernel]  [k] filemap_get_folios_tag
   0.31%  [kernel]  [k] isolate_lru_folios
   0.30%  [kernel]  [k] folio_end_writeback

Almost nothing XFS there - it's all lock contention in the page
cache.

This smells of mapping tree lock contention. Yup, the callgraph
profile indicates all that lock contention is on the mapping
tree between kswapd (multiple processes) the write process, the
writeback worker and the XFS IO completion worker.

Hmmm - system is definitely slow. Ah - the write to the file fills
all of free memory with page cache pages on the same mapping, then
every memory allocation requires reclaiming memory, and so they go
into direct reclaim and that adds even more lock contention to the
mapping tree lock....

IOWs, this looks like an mapping tree lock contention problem at it's
core. The mapping tree is exposed to unbound concurrency in these
sorts of situations

> assuming the ~/removeme file resides on rootfs and rootfs is XFS.

Doesn't need to be the root fs - I just did it on an XFS filesystem
mounted on /mnt/scratch with a ext3 rootfs

> While running this, the server becomes so unresponsive that after ~15
> seconds it's not even possible to login via ssh!

Direct memory reclaim getting stuck on the mapping lock because it
adds to the contention problem?

> We did reproduce this on every machine with XFS as rootfs running mentioned
> kernels. However, when we converted rootfs from XFS to EXT4(and btrfs), the
> problem disappeared - with the same OS, same kernel binary, same hardware,
> just using ext4 or btrfs instead of xfs.

Experience has taught me that XFS tends to trigger lock contention
problems in generic code sooner than other filesystems. So this
wouldn't be unexpected, but if the cause is really mapping tree lock
contention then XFS is just the canary....

> Note. During the hang and being unresponsive, SSD drives are
> writing data at expected performance. Just all the processes
> except the writing one hang.

Yup, that's definitely expected - everything on the write() and
writeback side is running at full IO speed, it's just that
everything else is thrashing on the mapping tree waiting for IO to
clean pages....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

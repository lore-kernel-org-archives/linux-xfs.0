Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:33786 "EHLO
        mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933023AbcKDC2Y (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 3 Nov 2016 22:28:24 -0400
Received: by mail-pf0-f196.google.com with SMTP id a136so6449991pfa.0
        for <linux-xfs@vger.kernel.org>; Thu, 03 Nov 2016 19:28:24 -0700 (PDT)
Date: Fri, 4 Nov 2016 13:28:07 +1100
From: Nicholas Piggin <npiggin@gmail.com>
Subject: Re: [rfc] larger batches for crc32c
Message-ID: <20161104132807.4cdbb78d@roar.ozlabs.ibm.com>
In-Reply-To: <20161104001248.GD28177@dastard>
References: <20161028031747.68472ac7@roar.ozlabs.ibm.com>
        <20161104001248.GD28177@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Dave Chinner <dchinner@redhat.com>

On Fri, 4 Nov 2016 11:12:48 +1100
Dave Chinner <david@fromorbit.com> wrote:

> On Fri, Oct 28, 2016 at 03:17:47AM +1100, Nicholas Piggin wrote:
> > Hi guys,
> > 
> > We're seeing crc32c_le show up in xfs log checksumming on a MySQL benchmark
> > on powerpc. I could reproduce similar overheads with dbench as well.
> > 
> > 1.11%  mysqld           [kernel.vmlinux]            [k] __crc32c_le
> >         |
> >         ---__crc32c_le
> >            |          
> >             --1.11%--chksum_update
> >                       |          
> >                        --1.11%--crypto_shash_update
> >                                  crc32c
> >                                  xlog_cksum
> >                                  xlog_sync
> >                                  _xfs_log_force_lsn
> >                                  xfs_file_fsync
> >                                  vfs_fsync_range
> >                                  do_fsync
> >                                  sys_fsync
> >                                  system_call
> >                                  0x17738
> >                                  0x17704
> >                                  os_file_flush_func
> >                                  fil_flush
> > 
> > As a rule, it helps the crc implementation if it can operate on as large a
> > chunk as possible (alignment, startup overhead, etc). So I did a quick hack
> > at getting XFS checksumming to feed crc32c() with larger chunks, by setting
> > the existing crc to 0 before running over the entire buffer. Together with
> > some small work on the powerpc crc implementation, crc drops below 0.1%.
> > 
> > I don't know if something like this would be acceptable? It's not pretty,
> > but I didn't see an easier way.  
> 
> Here's an alternative, slightly cleaner patch that optimises the CRC
> update side but leaves the verify side as it is. I've not yet
> decided exactly what is cleanest for the xlog_cksum() call in log
> recovery, but that won't change the performance of the code.  Can
> you give this a run through, Nick?

Hi Dave,

Yeah sorry for the slow response, I've been getting a more realistic
MySQL benchmark setup working (what I had reproduced what appeared to
be the same overhead, but I wanted to get something better to retest
with). So your patch comes at a good time (and thanks for working on
it). I'll see if I can get something running and have results for you
by next week.

Thanks,
Nick

Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wr1-f54.google.com ([209.85.221.54]:45698 "EHLO
        mail-wr1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726714AbeJQQwM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 17 Oct 2018 12:52:12 -0400
Received: by mail-wr1-f54.google.com with SMTP id q5-v6so28708919wrw.12
        for <linux-xfs@vger.kernel.org>; Wed, 17 Oct 2018 01:57:29 -0700 (PDT)
Subject: Re: ENSOPC on a 10% used disk
References: <40c52a7b-2520-8ae4-11d5-ae4b33e1dc29@scylladb.com>
 <20181017084716.GL16896@infradead.org>
From: Avi Kivity <avi@scylladb.com>
Message-ID: <d23ce960-0077-0446-e4dc-875a11b4d29f@scylladb.com>
Date: Wed, 17 Oct 2018 11:57:26 +0300
MIME-Version: 1.0
In-Reply-To: <20181017084716.GL16896@infradead.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org


On 17/10/2018 11.47, Christoph Hellwig wrote:
> On Wed, Oct 17, 2018 at 10:52:48AM +0300, Avi Kivity wrote:
>> I have a user running a 1.7TB filesystem with ~10% usage (as shown by df),
>> getting sporadic ENOSPC errors. The disk is mounted with inode64 and has a
>> relatively small number of large files. The disk is a single-member RAID0
>> array, with 1MB chunk size. There are 32 AGs. Running Linux 4.9.17.
> 4.9.17 is rather old and you'll have a hard time finding someone
> familiar with it..


Yes. I expect my user will agree to upgrade, but I'd like to recommend 
this only if we know there was a real issue and it was resolved, not on 
general principles.


>> Is this a known issue? Would upgrading the kernel help?
> Two things that come to mind:
>
>   - are you sure there is no open fd to the unlinked files?  That would
>     keep the space allocated until the last link is dropped.


"df" would report that space as occupied, no?


I believe a colleague verified there were no deleted files but I'm not 
100% sure.


>   - even once we drop the inode the space only becomes available once
>     the transaction has committed.  We do force the log if we found
>     a busy extent, but there might be some issues.  Try seeing if you
>     hit the xfs_extent_busy_force trace point with your workload.


I'll ask permission to check this and report.


>   - if you have online discard (-o discard) enabled there might be
>     more issues like the above, especially on old kernels.


Online discard is not enabled:


/dev/md0 on /var/lib/scylla type xfs 
(rw,noatime,attr2,inode64,sunit=2048,swidth=2048,noquota)

btw, we've seen fstrim on an old disk (that was likely never trimmed) 
improving its performance by a factor of ~100, so my interest in -o 
discard is re-awakening. Is it good enough now to to run on aio 
workloads (assuming nvme) or is more work needed? My prime concern is to 
avoid io_submit sleeping.

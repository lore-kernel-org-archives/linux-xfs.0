Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 26 Aug 2008 14:33:25 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m7QLXJEs017739
	for <xfs@oss.sgi.com>; Tue, 26 Aug 2008 14:33:20 -0700
Received: from py-out-1112.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4CCEFFC70E6
	for <xfs@oss.sgi.com>; Tue, 26 Aug 2008 14:34:41 -0700 (PDT)
Received: from py-out-1112.google.com (py-out-1112.google.com [64.233.166.177]) by cuda.sgi.com with ESMTP id Y28t5aDDcktrNDj0 for <xfs@oss.sgi.com>; Tue, 26 Aug 2008 14:34:41 -0700 (PDT)
Received: by py-out-1112.google.com with SMTP id f31so1521962pyh.4
        for <xfs@oss.sgi.com>; Tue, 26 Aug 2008 14:34:41 -0700 (PDT)
Message-ID: <6278d2220808261434o15dcbbfbge8138098bf453c0b@mail.gmail.com>
Date: Tue, 26 Aug 2008 22:34:40 +0100
From: "Daniel J Blueman" <daniel.blueman@gmail.com>
Subject: Re: [2.6.27-rc4] XFS i_lock vs i_iolock...
In-Reply-To: <6278d2220808261313ve58a692r38c913356ee135e2@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <6278d2220808221412x28f4ac5dl508884c8030b364a@mail.gmail.com>
	 <20080825010213.GO5706@disturbed> <48B21507.9050708@sgi.com>
	 <20080825035542.GR5706@disturbed> <1219647573.20732.28.camel@twins>
	 <20080825215532.GB28188@lst.de> <20080826024547.GX5706@disturbed>
	 <6278d2220808261313ve58a692r38c913356ee135e2@mail.gmail.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@lst.de>, Peter Zijlstra <peterz@infradead.org>, Lachlan McIlroy <lachlan@sgi.com>, Linux Kernel <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com

On Tue, Aug 26, 2008 at 9:13 PM, Daniel J Blueman
<daniel.blueman@gmail.com> wrote:
> Hi Dave,
>
> On Tue, Aug 26, 2008 at 3:45 AM, Dave Chinner <david@fromorbit.com> wrote:
>> On Mon, Aug 25, 2008 at 11:55:32PM +0200, Christoph Hellwig wrote:
>>> On Mon, Aug 25, 2008 at 08:59:33AM +0200, Peter Zijlstra wrote:
>>> > How can you take two locks in one go? It seems to me you always need to
>>> > take them one after another, and as soon as you do that, you have
>>> > ordering constraints.
>>>
>>> Yes, you would.  Except that in all other places we only have a single
>>> iolock involved, so the ordering of the second iolock and second ilock
>>> don't matter.
>>>
>>> Because of that I think declaring that xfs_lock_two_inodes can just
>>> lock on lock type at a time might be the better solution.
>>
>> Agreed. Patch below.
>>
>> Cheers,
>>
>> Dave.
>> --
>> Dave Chinner
>> david@fromorbit.com
>>
>> XFS: prevent lockdep false positives when locking two inodes
>>
>> If we call xfs_lock_two_inodes() to grab both the iolock and
>> the ilock, then drop the ilocks on both inodes, then grab
>> them again (as xfs_swap_extents() does) then lockdep will
>> report a locking order problem. This is a false positive.
>>
>> To avoid this, disallow xfs_lock_two_inodes() fom locking both
>> inode locks at once - force calers to make two separate calls.
>> This means that nested dropping and regaining of the ilocks
>> will retain the same lockdep subclass and so lockdep will
>> not see anything wrong with this code.
>>
>> Signed-off-by: Dave Chinner <david@fromorbit.com>
>> ---
>>  fs/xfs/xfs_dfrag.c    |    9 ++++++++-
>>  fs/xfs/xfs_vnodeops.c |   10 ++++++++++
>>  2 files changed, 18 insertions(+), 1 deletions(-)
>>
>> diff --git a/fs/xfs/xfs_dfrag.c b/fs/xfs/xfs_dfrag.c
>> index 760f4c5..75b0cd4 100644
>> --- a/fs/xfs/xfs_dfrag.c
>> +++ b/fs/xfs/xfs_dfrag.c
>> @@ -149,7 +149,14 @@ xfs_swap_extents(
>>
>>        sbp = &sxp->sx_stat;
>>
>> -       xfs_lock_two_inodes(ip, tip, lock_flags);
>> +       /*
>> +        * we have to do two separate lock calls here to keep lockdep
>> +        * happy. If we try to get all the locks in one call, lock will
>> +        * report false positives when we drop the ILOCK and regain them
>> +        * below.
>> +        */
>> +       xfs_lock_two_inodes(ip, tip, XFS_IOLOCK_EXCL);
>> +       xfs_lock_two_inodes(ip, tip, XFS_ILOCK_EXCL);
>>        locked = 1;
>>
>>        /* Verify that both files have the same format */
>> diff --git a/fs/xfs/xfs_vnodeops.c b/fs/xfs/xfs_vnodeops.c
>> index f108102..cb1b5fd 100644
>> --- a/fs/xfs/xfs_vnodeops.c
>> +++ b/fs/xfs/xfs_vnodeops.c
>> @@ -1836,6 +1836,12 @@ again:
>>  #endif
>>  }
>>
>> +/*
>> + * xfs_lock_two_inodes() can only be used to lock one type of lock
>> + * at a time - the iolock or the ilock, but not both at once. If
>> + * we lock both at once, lockdep will report false positives saying
>> + * we have violated locking orders.
>> + */
>>  void
>>  xfs_lock_two_inodes(
>>        xfs_inode_t             *ip0,
>> @@ -1846,7 +1852,11 @@ xfs_lock_two_inodes(
>>        int                     attempts = 0;
>>        xfs_log_item_t          *lp;
>>
>> +#ifdef DEBUG
>> +       if (lock_mode & (XFS_IOLOCK_SHARED|XFS_IOLOCK_EXCL))
>> +               ASSERT((lock_mode & (XFS_ILOCK_SHARED|XFS_ILOCK_EXCL)) == 0);
>>        ASSERT(ip0->i_ino != ip1->i_ino);
>> +#endif
>>
>>        if (ip0->i_ino > ip1->i_ino) {
>>                temp = ip0;
>
> Good to get your patch and HCH's ack...thanks!
>
> I'll pursue testing and touchdown in < 24 hrs.

Excellent - confirmed it addresses the lockdep report I was seeing
before and doesn't introduce any regressions.

Thanks,
  Daniel
-- 
Daniel J Blueman

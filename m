Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 18 Sep 2008 15:18:37 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m8IMIY6i024450
	for <xfs@oss.sgi.com>; Thu, 18 Sep 2008 15:18:34 -0700
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 92CA1127C959
	for <xfs@oss.sgi.com>; Thu, 18 Sep 2008 15:20:07 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com with ESMTP id S9XNWb8Hy3NLS3Ox for <xfs@oss.sgi.com>; Thu, 18 Sep 2008 15:20:07 -0700 (PDT)
Message-ID: <63352.131.252.241.230.1221776406.squirrel@sandeen.net>
In-Reply-To: <48D2C97A.1070703@thebarn.com>
References: <48D19A83.4040608@thebarn.com> <48D1CD46.4010104@sgi.com>
    <48D1DCD5.7040502@thebarn.com> <48D218AE.9090400@sgi.com>
    <48D2C97A.1070703@thebarn.com>
Date: Thu, 18 Sep 2008 17:20:06 -0500 (CDT)
Subject: Re: REVIEW: Fix for incore extent corruption.
From: "Eric Sandeen" <sandeen@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain;charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Russell Cattelan <cattelan@thebarn.com>
Cc: lachlan@sgi.com, xfs@oss.sgi.com

Russell Cattelan wrote:
> Lachlan McIlroy wrote:
>> Russell, this fixes xfs_iext_irec_compact_full().  If we don't move
>> all the records from the next page into the current page then we need
>> to update the er_extoff of the modified page as we move the remaining
>> extents up.  Would you mind giving it a go?
>>
>> --- a/fs/xfs/xfs_inode.c    2008-09-18 18:48:46.000000000 +1000
>> +++ b/fs/xfs/xfs_inode.c    2008-09-18 18:57:18.000000000 +1000
>> @@ -4623,6 +4623,7 @@ xfs_iext_irec_compact_full(
>>                     (XFS_LINEAR_EXTS -
>>                         erp_next->er_extcount) *
>>                     sizeof(xfs_bmbt_rec_t));
>> +                erp_next->er_extoff += ext_diff;
>>             }
>>         }
>>
> Cool I'll give it some run through when I done traveling.
>
> I still think compact_full should simply be eliminated since
> it really doesn't help, and it's obviously confusing code.
> Or we should make sure it works and get rid of compact_pages
> since compact_full behaves just like compact_pages when not
> doing partial moves.

I'd agree with that, at least as far as reevaluating this packing stuff -
given the seriousness of the bug when you do hit it, and how rarely it's
ever hit, apparently this chunk of code is almost never run ....

-Eric

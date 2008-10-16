Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 16 Oct 2008 00:18:46 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9G7Iflb010659
	for <xfs@oss.sgi.com>; Thu, 16 Oct 2008 00:18:42 -0700
Received: from ipmail05.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8F7705042CD
	for <xfs@oss.sgi.com>; Thu, 16 Oct 2008 00:20:23 -0700 (PDT)
Received: from ipmail05.adl2.internode.on.net (ipmail05.adl2.internode.on.net [203.16.214.145]) by cuda.sgi.com with ESMTP id TUE0tbEDmJACdjHl for <xfs@oss.sgi.com>; Thu, 16 Oct 2008 00:20:23 -0700 (PDT)
Date: Thu, 16 Oct 2008 18:20:19 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: another problem with latest code drops
Message-ID: <20081016072019.GH25906@disturbed>
References: <48F6A19D.9080900@sgi.com> <20081016060247.GF25906@disturbed> <48F6EF7F.4070008@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48F6EF7F.4070008@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Lachlan McIlroy <lachlan@sgi.com>
Cc: xfs-oss <xfs@oss.sgi.com>

On Thu, Oct 16, 2008 at 05:38:39PM +1000, Lachlan McIlroy wrote:
> Dave Chinner wrote:
>> On Thu, Oct 16, 2008 at 12:06:21PM +1000, Lachlan McIlroy wrote:
>>> fsstress started reporting these errors
>>>
>>> fsstress: check_cwd failure
>>> fsstress: check_cwd failure
>>> fsstress: check_cwd failure
>>> fsstress: check_cwd failure
>>> fsstress: check_cwd failure
>>> ...
....
>> Ah, yes. A shutdown in a directory transaction. Have you applied the
>> fix to the directory block allocation transaction accounting that was one
>> of the last patches I posted?
> Yes, I checked that in yesterday and ran with it overnight.

OK.

>> If so, then there's some other problem in that code that we'll
>> need a reproducable test case to be able to find....
>
> I was running 8 copies of this command:
> fsstress -p 64 -n 10000000 -d /mnt/data/fsstress.$i
>
> I tried it again but this time the system ran out of memory
> and locked up hard.  I couldn't see why though - maybe a memory
> leak.

I just ran up the same load in a UML session. I'd say it's this
slab:

  2482   2481  99%    0.23K    146       17       584K xfs_btree_cur

which is showing a leak. It is slowly growing on my system
and dropping the caches doesn't reduce it's size. At least it's
a place to start looking - somewhere in the new btree code we
seem to be leaking a btree cursor....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

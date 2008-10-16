Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 16 Oct 2008 00:34:36 -0700 (PDT)
Received: from relay.sgi.com (relay1.corp.sgi.com [192.26.58.214])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9G7YX44020425
	for <xfs@oss.sgi.com>; Thu, 16 Oct 2008 00:34:33 -0700
Message-ID: <48F6FCB7.6050905@sgi.com>
Date: Thu, 16 Oct 2008 18:35:03 +1000
From: Lachlan McIlroy <lachlan@sgi.com>
Reply-To: lachlan@sgi.com
MIME-Version: 1.0
Subject: Re: another problem with latest code drops
References: <48F6A19D.9080900@sgi.com> <20081016060247.GF25906@disturbed> <48F6EF7F.4070008@sgi.com> <20081016072019.GH25906@disturbed>
In-Reply-To: <20081016072019.GH25906@disturbed>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Lachlan McIlroy <lachlan@sgi.com>, xfs-oss <xfs@oss.sgi.com>

Dave Chinner wrote:
> On Thu, Oct 16, 2008 at 05:38:39PM +1000, Lachlan McIlroy wrote:
>> Dave Chinner wrote:
>>> On Thu, Oct 16, 2008 at 12:06:21PM +1000, Lachlan McIlroy wrote:
>>>> fsstress started reporting these errors
>>>>
>>>> fsstress: check_cwd failure
>>>> fsstress: check_cwd failure
>>>> fsstress: check_cwd failure
>>>> fsstress: check_cwd failure
>>>> fsstress: check_cwd failure
>>>> ...
> ....
>>> Ah, yes. A shutdown in a directory transaction. Have you applied the
>>> fix to the directory block allocation transaction accounting that was one
>>> of the last patches I posted?
>> Yes, I checked that in yesterday and ran with it overnight.
> 
> OK.
> 
>>> If so, then there's some other problem in that code that we'll
>>> need a reproducable test case to be able to find....
>> I was running 8 copies of this command:
>> fsstress -p 64 -n 10000000 -d /mnt/data/fsstress.$i
>>
>> I tried it again but this time the system ran out of memory
>> and locked up hard.  I couldn't see why though - maybe a memory
>> leak.
> 
> I just ran up the same load in a UML session. I'd say it's this
> slab:
> 
>   2482   2481  99%    0.23K    146       17       584K xfs_btree_cur
> 
> which is showing a leak. It is slowly growing on my system
> and dropping the caches doesn't reduce it's size. At least it's
> a place to start looking - somewhere in the new btree code we
> seem to be leaking a btree cursor....
> 


I'm not seeing a leak in that slab - actually that slab doesn't even
show up.  I am seeing a lot of memory used here though:

116605669 116605669  26%    0.23K 6859157       17  27436628K selinux_inode_security

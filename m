Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 14 May 2007 01:17:13 -0700 (PDT)
Received: from gab.dneg.com (mail.dneg.com [193.203.82.196])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l4E8H4fB026858
	for <xfs@oss.sgi.com>; Mon, 14 May 2007 01:17:06 -0700
Message-ID: <46481AFD.8090109@dneg.com>
Date: Mon, 14 May 2007 09:17:01 +0100
From: Evan Fraser <evan@dneg.com>
MIME-Version: 1.0
Subject: Re: updatedb triggers XFS internal error
References: <46449B2C.30208@dneg.com> <46467FB5.8080301@sandeen.net>
In-Reply-To: <46467FB5.8080301@sandeen.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com

Thanks for your help. 

Cheers, Evan.

Eric Sandeen wrote:
> Evan Fraser wrote:
>> Hello,
>> I'm having a problem with one of my linux servers. whenever updatedb 
>> is run, the following errors occur in the system log.
>>
>> 0x0: c9 00 5a f1 3a 7f 66 be a3 c1 d4 7f e8 1d 6b c9
>> Filesystem "md0": XFS internal error xfs_da_do_buf(2) at line 2271 of 
>> file fs/xfs/xfs_da_btree.c.  Caller 0xffffffff8817957f
>
> This indicates bad metadata magic read from disk.  You'll probably 
> want to run xfs_repair; you can run it with -n to see what it *would* 
> do first, to get an idea of how drastic the repair might be.  
> Repairing 1.4T won't probably be lots of fun, but you've got 
> corruption in there somewhere...
>
> -Eric
>

-- 
evan@dneg.com
Linux Systems Administrator
Double Negative
tel: +44 (0)20 7534 4400 fax: +44 (0)20 7534 4452
77 shaftesbury avenue, w1d 5du, London

Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mBINXKD9031122 for <xfs@oss.sgi.com>; Thu, 18 Dec 2008 17:33:20 -0600
Received: from partygirl.tmr.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3A960175EA48
	for <xfs@oss.sgi.com>; Thu, 18 Dec 2008 15:33:17 -0800 (PST)
Received: from partygirl.tmr.com (mail.tmr.com [64.65.253.246]) by
	cuda.sgi.com with ESMTP id 4iRHAqQEn0nExCBa for
	<xfs@oss.sgi.com>; Thu, 18 Dec 2008 15:33:17 -0800 (PST)
Message-ID: <494ADDBA.6010105@tmr.com>
Date: Thu, 18 Dec 2008 18:33:14 -0500
From: Bill Davidsen <davidsen@tmr.com>
MIME-Version: 1.0
Subject: Re: 12x performance drop on md/linux+sw raid1 due to barriers [xfs]
References: <alpine.DEB.1.10.0812060928030.14215@p34.internal.lan>	<1229225480.16555.152.camel@localhost>	<18757.4606.966139.10342@tree.ty.sabi.co.uk>	<200812141912.59649.Martin@lichtvoll.de>	<18757.33373.744917.457587@tree.ty.sabi.co.uk>
	<494971B2.1000103@tmr.com> <494A07BA.1080008@mailcan.com>
In-Reply-To: <494A07BA.1080008@mailcan.com>
Content-Disposition: inline
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Leon Woestenberg <leonw@mailcan.com>
Cc: Linux RAID <linux-raid@vger.kernel.org>, Peter Grandi <pg_xf2@xf2.for.sabi.co.UK>, Linux XFS <xfs@oss.sgi.com>

Leon Woestenberg wrote:
> Hello all,
>
> Bill Davidsen wrote:
>> Peter Grandi wrote:
>>   
>>> Unfortunately that seems the case.
>>>
>>> The purpose of barriers is to guarantee that relevant data is
>>> known to be on persistent storage (kind of hardware 'fsync').
>>>
>>> In effect write barrier means "tell me when relevant data is on
>>> persistent storage", or less precisely "flush/sync writes now
>>> and tell me when it is done". Properties as to ordering are just
>>> a side effect.
>>>   
>>>     
>>
>> I don't get that sense from the barriers stuff in Documentation, in fact 
>> I think it's essentially a pure ordering thing, I don't even see that it 
>> has an effect of forcing the data to be written to the device, other 
>> than by preventing other writes until the drive writes everything. So we 
>> read the intended use differently.
>>
>> What really bothers me is that there's no obvious need for barriers at 
>> the device level if the file system is just a bit smarter and does it's 
>> own async io (like aio_*), because you can track writes outstanding on a 
>> per-fd basis, so instead of stopping the flow of data to the drive, you 
>> can just block a file descriptor and wait for the count of outstanding 
>> i/o to drop to zero. That provides the order semantics of barriers as 
>> far as I can see, having tirelessly thought about it for ten minutes or 
>> so. Oh, and did something very similar decades ago in a long-gone 
>> mainframe OS.
>>   
> Did that mainframe OS have re-ordering devices? If it did, you'ld 
> still need barriers all the way down:
>
Why? As long as you can tell when all the writes before the barrier are 
physically on the drive (this is on a per fd basis, remember) you don't 
care about the order of physical writes, you serialize either one fd, or 
one thread, or one application, but you don't have to kill performance 
for the rest of the system to the drive. So you can fsync() one fd or 
several, then write another thread. Or you can wait until the 
outstanding write could for a whole process reaches zero. And the 
application satisfies the needs, not the kernel, which reduces impact on 
other applications.
> The drive itself may still re-order writes, thus can cause corruption 
> if halfway the power goes down.
> >From my understanding, disabling write-caches simply forces the drive 
> to operate in-order.
>
If you ordering logic is 'write A, B, and C, then barrier, then write D' 
I don't see that the physical order of A, B, or C matters, as long as 
they are all complete before you write D. That's what I see in the 
barrier description, let previous writes finish.
> Barriers need to travel all the way down to the point where-after 
> everything remains in-order.
> Devices with write-cache enabled will still re-order, but not across 
> barriers (which are implemented as
> either a single cache flush with forced unit access, or a double cache 
> flush around the barrier write).
>
> Whether the data has made it to the drive platters is not really 
> important from a barrier point of view, however,
> iff part of the data made it to the platters, then we want to be sure 
> it was in-order.
>
And you could use a barrier after every write (some DB setups do fsync() 
after each). Perhaps you mean parts like the journal entry before a 
change is made, then the change, then the journal entry for transaction 
complete?
> Because only in this way can we ensure that the data that is on the 
> platters is consistent.

I think we mean the same thing, but I'm not totally sure. As long a 
logical operations are completed in order, the physical writes don't 
matter, because a journal rollback would reset things to consistent anyway.

-- 
Bill Davidsen <davidsen@tmr.com>
  "Woe unto the statesman who makes war without a reason that will still
  be valid when the war is over..." Otto von Bismark 




[[HTML alternate version deleted]]

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n1IMPG7G059147
	for <linux-xfs@oss.sgi.com>; Wed, 18 Feb 2009 16:25:16 -0600
Received: from mx2.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D6F5D1BBCF8F
	for <linux-xfs@oss.sgi.com>; Wed, 18 Feb 2009 14:24:43 -0800 (PST)
Received: from mx2.redhat.com (mx2.redhat.com [66.187.237.31]) by cuda.sgi.com
	with ESMTP id 1QMjHT9lhRIRUgwW for <linux-xfs@oss.sgi.com>;
	Wed, 18 Feb 2009 14:24:43 -0800 (PST)
Message-ID: <499C8A9F.3030303@sandeen.net>
Date: Wed, 18 Feb 2009 16:24:31 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: 12x performance drop on md/linux+sw raid1 due to barriers [xfs]
References: <alpine.DEB.1.10.0812060928030.14215@p34.internal.lan>	<200812141912.59649.Martin@lichtvoll.de>	<18757.33373.744917.457587@tree.ty.sabi.co.uk>	<200812151948.59870.Martin@lichtvoll.de>	<18758.57121.570007.816329@tree.ty.sabi.co.uk>
	<B50173E3-7975-4A71-903A-A76D910CBB3A@mailcan.com>
In-Reply-To: <B50173E3-7975-4A71-903A-A76D910CBB3A@mailcan.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
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
Cc: Linux XFS <linux-xfs@oss.sgi.com>, Peter Grandi <pg_xf2@xf2.for.sabi.co.UK>

Leon Woestenberg wrote:
> Hello,
> 
> On 15 dec 2008, at 23:50, Peter Grandi wrote:
> 
>> [ ... ]
>>
>>>> The purpose of barriers is to guarantee that relevant data is
>>>> known to be on persistent storage (kind of hardware 'fsync').
>>>>
>>> [ ... ] Unfortunately in my understanding none of this is
>>> reflected by Documentation/block/barrier.txt
>> But we are talking about XFS and barriers here. That described
>> just a (flawed, buggy) mechanism to implement those. Consider
>> for example:
>>
>>  http://www.xfs.org/index.php/XFS_FAQ#Write_barrier_support.
>>  http://www.xfs.org/index.php/XFS_FAQ#Q._Should_barriers_be_enabled_with_storage_which_has_a_persistent_write_cache.3F
>>
>> In any case as to the kernel "barrier" mechanism, its
>> description is misleading because it heavily fixates on the
>> ordering issue, which is just a consequence, but yet mentions
>> the far more important "flush/sync" aspect.
>>
>> Still, there is a lot of confusion about barrier support and
>> what it means at which level, as reflected in several online
>> discussions and the different behaviour of different kernel
>> versions.
>>
> The semantics of a barrier are whatever semantics we describe to it.  
> So we can continue to be confused about it.
> 
> I strongly disagree on the ordering issue being a side effect.
> 
> Correct ordering can be proven to be enough to provide transactional  
> correctness, enough to ensure that filesystems can not get corrupted  
> on power down.
> 
> Using barriers to guarantee that (all submitted) write requests  
> (before the barrier) made it to the medium are a stronger predicate.
> 
> The Linux approach and documentation talks about the first type of  
> semantics (which I rather like for them being strong enough and not  
> more).

Agreed.  I'll have a look over those (wiki) faq entries and make sure
they're not confusing cache flushes with ordering requirements.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

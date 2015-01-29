Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id C656C7FA4
	for <xfs@oss.sgi.com>; Thu, 29 Jan 2015 16:15:59 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id B5ECA304064
	for <xfs@oss.sgi.com>; Thu, 29 Jan 2015 14:15:56 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id 7RZFCuh9uUO401Je for <xfs@oss.sgi.com>;
	Thu, 29 Jan 2015 14:15:55 -0800 (PST)
Message-ID: <54CAB11A.7040509@sandeen.net>
Date: Thu, 29 Jan 2015 16:15:54 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: Unable to mount and repair filesystems
References: <D90435AEFF34654AA1122988C66C8678023F0277C9@exchange.tsag.local>
	<54CA9586.1010607@sandeen.net>
	<D90435AEFF34654AA1122988C66C8678023F027956@exchange.tsag.local>
	<54CAAAEC.1080803@sandeen.net>
	<D90435AEFF34654AA1122988C66C8678023F0279AB@exchange.tsag.local>
In-Reply-To: <D90435AEFF34654AA1122988C66C8678023F0279AB@exchange.tsag.local>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Gerard Beekmans <GBeekmans@tsag.net>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On 1/29/15 3:59 PM, Gerard Beekmans wrote:
...

> That gives me this:
> 
> xfs_db> agf 5
> xfs_db> daddr
> current daddr is 5120001
> xfs_db> print
> magicnum = 0
> versionnum = 0

...

so it is completely zeroed out.

>  
>>> xfs_db: cannot init perag data (117). Continuing anyway.
>>> xfs_db> sb 0
>>> xfs_db> p
>>> magicnum = 0x58465342
>>
>> this must not be the one that repair failed on like:
>>
>>> couldn't verify primary superblock - bad magic number !!!
>>
>> because that magicnum is valid.  Did this one also fail to repair?
> 
> How do I know/check/test if "this one" fails to refer? I'm not sure what you're referring to (or what to do with it).

I'm sorry, I meant did this filesystem fail to repair based on a bad
primary superblock?

>>> agcount = 25
>>
>> 25 ags, presumably the fs was grown in the past, but ok...
> 
> Yes, it was. Ran out of space so I increased the size of the logical
> volume then used xfs_grow to increase the filesystem itself. That was
> the whole reason behind using LVM so this growth can be done on a
> live system without requiring repartitioning and such.

> I did read today that growing an XFS is not necessarily something we
> should be doing? Some posts even suggest that LVM and XFS shouldn't
> be mixed together. Not sure how to separate truth from fiction.

It's fine; the downside is for people who think they can start with 1G
and grow to 10T; that's pretty suboptimal.  XFS over LVM is fine.

I'm sure it's not related to this issue (unless it was very recently grown?
Was it grown shortly before the failures?)

Hm, it would have started at 4 AGs by default, and it's the 5th one that
looks bad; maybe that's a clue.  Are agf 6, 7, 8 etc also full of 0s?
  
>> The only thing I can say is that xfs is going to depend on the storage telling
>> the truth about completed IOs...  If the storage told XFS an IO was persistent,
>> but it wasn't, and the storage went poof, bad things can happen.  I don't
>> know the details of your setup, or TBH much about vmware over nfs ... you
>> weren't mounted with -o nobarrier were you?
> 
> No I wasn't mounted with nobarrier unless it is done by default. I
> never specified the option on command line or in /etc/fstab at any
> rate for what that is worth.

ok.  I'm not sure what to tell you at this point; you have at least one
swath of your storage which looks totally zeroed out.  That's not a
failure mode we usually see, and makes me think it's more storage related,
although the "how long ago did you grow this fs?" question might be
related, because the first visible corruption is in the first "new"
post-growth AG...

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

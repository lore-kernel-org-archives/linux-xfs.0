Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 68FBE7FC0
	for <xfs@oss.sgi.com>; Thu, 29 Jan 2015 16:00:03 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 468498F8037
	for <xfs@oss.sgi.com>; Thu, 29 Jan 2015 14:00:03 -0800 (PST)
Received: from smtp.tsag.net (smtp.tsag.net [208.118.68.4]) by cuda.sgi.com
	with ESMTP id K2NWfD3gKahthCll for <xfs@oss.sgi.com>;
	Thu, 29 Jan 2015 14:00:01 -0800 (PST)
From: Gerard Beekmans <GBeekmans@tsag.net>
Subject: RE: Unable to mount and repair filesystems
Date: Thu, 29 Jan 2015 21:59:59 +0000
Message-ID: <D90435AEFF34654AA1122988C66C8678023F0279AB@exchange.tsag.local>
References: <D90435AEFF34654AA1122988C66C8678023F0277C9@exchange.tsag.local>
	<54CA9586.1010607@sandeen.net>
	<D90435AEFF34654AA1122988C66C8678023F027956@exchange.tsag.local>
	<54CAAAEC.1080803@sandeen.net>
In-Reply-To: <54CAAAEC.1080803@sandeen.net>
Content-Language: en-US
MIME-Version: 1.0
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
To: Eric Sandeen <sandeen@sandeen.net>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

> -----Original Message-----
> > # xfs_db /dev/os/opt
> > Metadata corruption detected at block 0x4e2001/0x200
> 
> so at sector 0x4e2001, length 0x200.
> 
> xfs_db> agf 5
> xfs_db> daddr
> current daddr is 5120001
> 
> so it's the 5th AGF which is corrupt.
> 
> you could try:
> 
> xfs_db> agf 5
> xfs_db> print
> 
> to see how it looks.

That gives me this:

xfs_db> agf 5
xfs_db> daddr
current daddr is 5120001
xfs_db> print
magicnum = 0
versionnum = 0
seqno = 0
length = 0
bnoroot = 0
cntroot = 0
bnolevel = 0
cntlevel = 0
flfirst = 0
fllast = 0
flcount = 0
freeblks = 0
longest = 0
btreeblks = 0
uuid = 00000000-0000-0000-0000-000000000000
lsn = 0
crc = 0 (correct)

 
> > xfs_db: cannot init perag data (117). Continuing anyway.
> > xfs_db> sb 0
> > xfs_db> p
> > magicnum = 0x58465342
> 
> this must not be the one that repair failed on like:
> 
> > couldn't verify primary superblock - bad magic number !!!
> 
> because that magicnum is valid.  Did this one also fail to repair?

How do I know/check/test if "this one" fails to refer? I'm not sure what you're referring to (or what to do with it).

> > agcount = 25
> 
> 25 ags, presumably the fs was grown in the past, but ok...

Yes, it was. Ran out of space so I increased the size of the logical volume then used xfs_grow to increase the filesystem itself. That was the whole reason behind using LVM so this growth can be done on a live system without requiring repartitioning and such.

I did read today that growing an XFS is not necessarily something we should be doing? Some posts even suggest that LVM and XFS shouldn't be mixed together. Not sure how to separate truth from fiction.
 
> The only thing I can say is that xfs is going to depend on the storage telling
> the truth about completed IOs...  If the storage told XFS an IO was persistent,
> but it wasn't, and the storage went poof, bad things can happen.  I don't
> know the details of your setup, or TBH much about vmware over nfs ... you
> weren't mounted with -o nobarrier were you?

No I wasn't mounted with nobarrier unless it is done by default. I never specified the option on command line or in /etc/fstab at any rate for what that is worth.

Gerard 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n5SHNANo070838 for <xfs@OSS.SGI.com>; Sun, 28 Jun 2009 12:23:11 -0500
Received: from ty.sabi.co.UK (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3529632A72D
	for <xfs@OSS.SGI.com>; Sun, 28 Jun 2009 10:23:38 -0700 (PDT)
Received: from ty.sabi.co.UK (82-69-39-138.dsl.in-addr.zen.co.uk
	[82.69.39.138]) by cuda.sgi.com with ESMTP id pvfHZCNmNEnthGJW
	for <xfs@OSS.SGI.com>; Sun, 28 Jun 2009 10:23:38 -0700 (PDT)
Received: from from [127.0.0.1] (helo=tree.ty.sabi.co.UK)
	by ty.sabi.co.UK with esmtp(Exim 4.68 #1) id 1MKWAX-0002sa-3g
	for <xfs@OSS.SGI.com>; Sat, 27 Jun 2009 12:34:05 +0100
MIME-Version: 1.0
Message-ID: <19014.920.781178.319110@tree.ty.sabi.co.UK>
Date: Sat, 27 Jun 2009 12:33:44 +0100
Subject: RE: mkfs.xfs created filesystem larger than underlying device
In-Reply-To: <98D6DBD179F61A46AF5C064829A832A0185042D265@erebus.totalmanaged.com>
References: <98D6DBD179F61A46AF5C064829A832A0185042D261@erebus.totalmanaged.com>
	<4A42A7B7.3040403@sandeen.net>
	<98D6DBD179F61A46AF5C064829A832A0185042D265@erebus.totalmanaged.com>
From: pg_xf2@xf2.to.sabi.co.UK (Peter Grandi)
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
To: Linux XFS <xfs@oss.sgi.com>

>> I recently created an XFS filesystem on an x86_64 CentOS 5.3
>> system.[ .. ] It is a somewhat complex configuration of:

>> Areca RAID card with 16 1.5TB drives in a RAID 6 with 1
>> hotspare (100GB volume was created for the OS, the rest was
>> one large volume of ~19TB)
>> I used pvcreate /dev/sdb to create a physical volume for LVM
>> on the 19TB volume.
>> I then used vgcreate to create a volume group of 17.64TB
>> I used lvcreate to create 5 logical volumes, 4x4TB, and 1x1.5TB
>> On top of those logical volumes is drbd (/dev/drbd0-/dev/drbd4)
>> On top of the drbd volumes, I created a volume group of 17.50TB
>> (/dev/drbd0-/dev/drbd4)
>> I created a logical volume of 17.49TB, upon which was created
>> an xfs filesystem with no options (mkfs.xfs mkfs.xfs
>> /dev/Volume1-Rep-Store/Volume1-Replicated -L Replicated)

One of the values of the XFS mailing list is the entertainment
provided by some (many) of the posts. This is one of the best.

> In addition: I experienced significant corruption. I had only
> about 3 files on the XFS filesystem, which was then exported
> via nfs. I ran nfs_stress.sh against it, and my files ended up
> corrupt, and the machine locked up. Ideas?

Even better.

(the purpose of this message is not just to give thanks for the
entertainment, but also perhaps to induce second thoughts about
the wisdom of the setup above, but as a rule people who do this
kind of thing tend to think that they know better)

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

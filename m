Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o1OH9Y82036890 for <xfs@OSS.SGI.com>; Wed, 24 Feb 2010 11:09:35 -0600
Received: from ty.sabi.co.UK (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C3D5B1523A9B
	for <xfs@OSS.SGI.com>; Wed, 24 Feb 2010 09:10:54 -0800 (PST)
Received: from ty.sabi.co.UK (82-69-39-138.dsl.in-addr.zen.co.uk
	[82.69.39.138]) by cuda.sgi.com with ESMTP id L35Gu4yseTlBHj7M
	for <xfs@OSS.SGI.com>; Wed, 24 Feb 2010 09:10:54 -0800 (PST)
Received: from from [127.0.0.1] (helo=tree.ty.sabi.co.uk)
	by ty.sabi.co.UK with esmtp(Exim 4.63 #1) id 1NkKkn-0001bX-Nx
	for <xfs@OSS.SGI.com>; Wed, 24 Feb 2010 17:10:29 +0000
MIME-Version: 1.0
Message-ID: <19333.23937.956036.716@tree.ty.sabi.co.uk>
Date: Wed, 24 Feb 2010 17:10:25 +0000
Subject: Re: xfs_growfs failure....
In-Reply-To: <E51793F9F4FAD54A8C1774933D8E500006B64A2687@sbapexch05>
References: <E51793F9F4FAD54A8C1774933D8E500006B64A2687@sbapexch05>
From: pg_xf2@xf2.for.sabi.co.UK (Peter Grandi)
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

> I am in some difficulty here over a 100TB filesystem

Shrewd idea! Because 'fsck' takes no time and memory, so the
bigger the filesystem the better! ;-).

> that Is now unusable after a xfs_growfs command. [ ... ] 

Wondering how long it took to backup 100TB; but of course doing
a 'grow' is guaranteed to be error free, so there :-).

> attempt to access beyond end of device dm-61: rw=0,
> want=238995038208, limit=215943192576

It looks like the underlying DM logical volume is smaller than
the new size of the filesystem, which is strange as 'xfs_growfs'
is supposed to fetch the size of the underlying block device if
none is specified explicitly on the command line. The different
is about 10% or 10TB, so it is far from trivial.

Looking at the superblock dumps there are some pretty huge
discrepancies, 

  -bash-3.1# xfs_db -r -c 'sb 0' -c p /dev/logfs-sessions/sessions
  magicnum = 0x58465342
  blocksize = 4096
  dblocks = 29874379776
  rblocks = 0
  rextents = 0
  uuid = fc8bdf76-d962-43c1-ae60-b85f378978a6
  logstart = 0
  rootino = 2048
  rbmino = 2049
  rsumino = 2050
  rextsize = 384
  agblocks = 268435328
  agcount = 112
  [ ... ]
  -bash-3.1# xfs_db -r -c 'sb 2' -c p /dev/logfs-sessions/sessions
  magicnum = 0x58465342
  blocksize = 4096
  dblocks = 24111418368
  rblocks = 0
  rextents = 0
  uuid = fc8bdf76-d962-43c1-ae60-b85f378978a6
  logstart = 0
  rootino = 2048
  rbmino = 2049
  rsumino = 2050
  rextsize = 384
  agblocks = 268435328
  agcount = 90
  [ ... ]

The 'dblocks' field is rather different, even if the 'uuid' and
'agblocks' is the same, and 'agcount' is also rather different.
In SB 0 'dblocks' 29874379776 means size 238995038208, which is
value of 'want' above. The products of 'agcount' and 'agblocks'
fit with the sizes.

It looks like that the filesystem was "grown" from ~92TiB to
~114TiB on a storage device that is reported as ~103TiB
long. Again, very strange.

My impression is that not enough history/context has been
provided to enable a good guess at what has happened and how to
undo the consequent damage.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

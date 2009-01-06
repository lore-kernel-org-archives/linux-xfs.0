Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	n06J8TA9006287 for <xfs@oss.sgi.com>; Tue, 6 Jan 2009 13:08:33 -0600
Received: from mx2.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0367517B2D4A
	for <xfs@oss.sgi.com>; Tue,  6 Jan 2009 11:08:28 -0800 (PST)
Received: from mx2.redhat.com (mx2.redhat.com [66.187.237.31]) by cuda.sgi.com
	with ESMTP id GUfHSHgDbOsoIGO8 for <xfs@oss.sgi.com>;
	Tue, 06 Jan 2009 11:08:28 -0800 (PST)
Message-ID: <4963A596.70208@sandeen.net>
Date: Tue, 06 Jan 2009 12:40:22 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: need help to repair XFS partition
References: <b75ef8170901060111l52b9a803uf31dc7baa80df721@mail.gmail.com>	<49638190.3070803@sandeen.net>
	<b75ef8170901061004n75f52cffg7f810a51aca21ff@mail.gmail.com>
In-Reply-To: <b75ef8170901061004n75f52cffg7f810a51aca21ff@mail.gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Gergely Soos <sogerc1@gmail.com>
Cc: xfs@oss.sgi.com

Gergely Soos wrote:
> In my original email there was an attachment that contained the original
> boot sector, but anyway, here comes the hexdump Eric asked for:

Sorry, didn't open the tarfile :)

> 00000000  91 f0 1c 43 90 01 ba bf  f7 ee 29 9a 1e 6c d5 aa
> |.=F0.C..=BA=BF=F7=EE)..l=D5=AA|
> 00000010  11 5a 12 cb 3b 29 cb ff  39 ce 4e d3 95 ec b9 39
> |.Z.=CB;)=CB=FF9=CEN=D3.=EC=B99|

...

> This looks like nothing to me...

I agree... something splattered on the disk it seems.  How far does this
junk go on, I wonder?

> xfs_repair rejects all superblock candidates and exits saying something
> like: Sorry, cannot find valid secondary superblock.
> I'm not sure what a GPT is, but this is an IDE harddisk, I'm using kernel
> 2.6.20 and my xfs partition is /dev/hdd1

GPT is a disk partitioning scheme, and it puts backups at the end of the
disk (IIRC), which sometimes automatically gets restored to the front.
But this does not look like your case.

> Is there any way xfs_repair would accept the superblock as is and move on
> with the repairs?

Well, you want to be sure it matches.  But - go looking through your
disk for "XFSB" and keep track of where the offsets are; you should find
your backup superblocks that way, and we can use xfs_db to get the
values out and perhaps restore your primary.

(you can probably do this on your own, but something like:
# dd if=3D/dev/hdd1 bs=3D4k | hexdump -C | grep XFSB
might do nicely)

xfs_repair should be better at using these by itself.  If you can put
your metadump somewhere that I can get to it, maybe I can look and see
why repair is not succeeding...

-Eric

> Gergely
> =


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

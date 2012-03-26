Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q2QG5enK025402 for <xfs@oss.sgi.com>; Mon, 26 Mar 2012 11:05:40 -0500
Received: from mx0.pronet.com.pl (mx0.pronet.com.pl [193.108.35.26]) by
	cuda.sgi.com with ESMTP id KyAw3ho1CjWQ6PZT for
	<xfs@oss.sgi.com>; Mon, 26 Mar 2012 09:05:37 -0700 (PDT)
Subject: Re: XFS: Assertion failed: bp->b_bn != XFS_BUF_DADDR_NULL, file:
	fs/xfs/xfs_buf.c, line: 598
From: =?UTF-8?Q?Rafa=C5=82?= Kupka <kupson@kupson.net>
In-Reply-To: <1331233817.20679.18.camel@utemp.mieszkanie>
References: <1330539626.7615.73.camel@utemp.mieszkanie>
	<20120302104348.GA22230@infradead.org>
	<1330774627.32457.24.camel@utemp.mieszkanie>
	<20120303114413.GA18748@infradead.org>
	<1330983612.28645.18.camel@utemp.mieszkanie>
	<20120306203020.GG3592@dastard>
	<1331233817.20679.18.camel@utemp.mieszkanie>
Date: Mon, 26 Mar 2012 18:05:25 +0200
Message-ID: <1332777925.14696.194.camel@utemp.mieszkanie>
Mime-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Thu, 2012-03-08 at 20:10 +0100, Rafa=B3 Kupka wrote: =

> On Wed, 2012-03-07 at 07:30 +1100, Dave Chinner wrote:

Hi,

Finally I've captured this event trace. Hope it will help.

> > Also, it might be worthwhile to capture an event trace (e.g. all the
> > xfs_buf events) to see what occurs just before the error is
> > triggered. That might tell us exactl what sequence has occurred
> > leading up to the error.
> =

> I will try to provide this information in a few days.

Kernel version - Linus tree up to:
0e6e847f "xfs: stop using the page cache to back the buffer cache"

It's uniprocessor virtual machine (KVM) with 384 MB RAM.

Full event trace is available at https://gist.github.com/2206109
(sorry for it's *.perl extension, my mistake).

Kernel log entry:
[  495.197571] XFS (vda2): I/O error occurred: meta-data dev vda2 block 0x1=
3d80       ("xfs_trans_read_buf") error 5 buf count 8192
[  495.198283] XFS (vda2): xfs_imap_to_bp: xfs_trans_read_buf() returned er=
ror 5.
[  501.540477] XFS (vda2): I/O error occurred: meta-data dev vda2 block 0x1=
3d80       ("xfs_trans_read_buf") error 5 buf count 8192
[  501.543047] XFS (vda2): xfs_imap_to_bp: xfs_trans_read_buf() returned er=
ror 5.

It's possible that this "I/O error" is caused by memory pressure?

Related trace line:
xfsdump-2498  [000] 24195.782269: xfs_buf_ioerror: dev 254:2 bno 0x13d80 le=
n 0x2000 hold 3 pincount 0 lock 0 error 5 flags READ|TRYLOCK|PAGES caller _=
xfs_buf_ioapply

Events related to "bno 0x13d80":
xfsdump-2498  [000] 24195.782266: xfs_buf_get: dev 254:2 bno 0x13d80 len 0x=
2000 hold 2 pincount 0 lock 0 flags READ|LOCK|DONT_BLOCK caller xfs_buf_read
xfsdump-2498  [000] 24195.782266: xfs_buf_read: dev 254:2 bno 0x13d80 len 0=
x2000 hold 2 pincount 0 lock 0 flags READ|LOCK|DONT_BLOCK caller xfs_trans_=
read_buf
xfsdump-2498  [000] 24195.782267: xfs_buf_iorequest: dev 254:2 bno 0x13d80 =
len 0x2000 hold 2 pincount 0 lock 0 flags READ|TRYLOCK|PAGES caller _xfs_bu=
f_read
xfsdump-2498  [000] 24195.782267: xfs_buf_hold: dev 254:2 bno 0x13d80 len 0=
x2000 hold 2 pincount 0 lock 0 flags READ|TRYLOCK|PAGES caller xfs_buf_iore=
quest
xfsdump-2498  [000] 24195.782269: xfs_buf_ioerror: dev 254:2 bno 0x13d80 le=
n 0x2000 hold 3 pincount 0 lock 0 error 5 flags READ|TRYLOCK|PAGES caller _=
xfs_buf_ioapply
xfsdump-2498  [000] 24195.782270: xfs_buf_rele: dev 254:2 bno 0x13d80 len 0=
x2000 hold 3 pincount 0 lock 0 flags READ|TRYLOCK|PAGES caller xfs_buf_iore=
quest
xfsdump-2498  [000] 24195.782985: xfs_buf_unlock: dev 254:2 bno 0x13d80 len=
 0x2000 hold 2 pincount 0 lock 1 flags READ|TRYLOCK|PAGES caller xfs_buf_re=
lse
xfsdump-2498  [000] 24195.782986: xfs_buf_rele: dev 254:2 bno 0x13d80 len 0=
x2000 hold 2 pincount 0 lock 1 flags READ|TRYLOCK|PAGES caller xfs_trans_re=
ad_buf

Do this data put some light on this issue?

Regards,
Rafa=B3 Kupka

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

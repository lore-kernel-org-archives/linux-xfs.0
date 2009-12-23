Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nBNB7kku226771 for <xfs@oss.sgi.com>; Wed, 23 Dec 2009 05:07:47 -0600
Received: from mail.parknet.co.jp (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 38D61121B3E
	for <xfs@oss.sgi.com>; Wed, 23 Dec 2009 03:08:29 -0800 (PST)
Received: from mail.parknet.co.jp (mail.parknet.co.jp [210.171.160.6]) by
	cuda.sgi.com with ESMTP id jp8bRiVQTZtFVCx3 for
	<xfs@oss.sgi.com>; Wed, 23 Dec 2009 03:08:29 -0800 (PST)
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Subject: Re: [fuse-devel] utimensat fails to update ctime
References: <4B2B156D.9040604@byu.net> <87aaxclr4q.fsf@devron.myhome.or.jp>
	<4B2F7421.10005@byu.net> <4B2F7A95.3010708@byu.net>
	<87hbrkjrk8.fsf@devron.myhome.or.jp> <4B304D04.6040501@byu.net>
	<87d427jscr.fsf@devron.myhome.or.jp> <4B3097C4.3060803@wanadoo.fr>
	<874onjjnln.fsf@devron.myhome.or.jp> <4B30B67A.7080703@wanadoo.fr>
	<87ljgvi1an.fsf@devron.myhome.or.jp> <4B30F0C9.2020702@wanadoo.fr>
	<87my1aevro.fsf@devron.myhome.or.jp> <4B31E63D.5040202@wanadoo.fr>
Date: Wed, 23 Dec 2009 20:08:20 +0900
In-Reply-To: <4B31E63D.5040202@wanadoo.fr> ("Jean-Pierre =?iso-8859-1?Q?An?=
	=?iso-8859-1?Q?dr=E9=22's?= message of
	"Wed, 23 Dec 2009 10:43:25 +0100")
Message-ID: <87my1ane1n.fsf@devron.myhome.or.jp>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
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
To: Jean-Pierre =?iso-8859-1?Q?Andr=E9?= <jean-pierre.andre@wanadoo.fr>
Cc: Eric Blake <ebb9@byu.net>, Miklos Szeredi <miklos@szeredi.hu>, fuse-devel@lists.sourceforge.net, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com, Christoph Hellwig <hch@lst.de>

Jean-Pierre Andr=E9 <jean-pierre.andre@wanadoo.fr> writes:

> Hi,

Hi,

> OGAWA Hirofumi wrote:
>>> I suggest I port Miklos patch to fuse-lite soon,
>>> and delay the low-level case (and microsecond
>>> precision) until January. Does that suit your needs ?
>>>      =

>> Thanks. Sounds good. I'm not using ntfs-3g actually, I just bridged the
>> bug report on lkml to others. Eric?
>
> Attached is a proposed patch for selective update
> of timestamps in ntfs-3g (based on the release
> candidate version ntfs-3g-2009.11.14AC.2).
>
> It includes the backport of Miklos's patch posted
> yesterday to fuse-lite. As a matter of fact fuse-lite
> is needed, because I do not know how to make this
> compile with unpatched fuse.

Thanks for fixing this.
-- =

OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

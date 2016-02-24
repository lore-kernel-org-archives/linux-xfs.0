Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 167C07F58
	for <xfs@oss.sgi.com>; Wed, 24 Feb 2016 07:27:37 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id CBEE030404E
	for <xfs@oss.sgi.com>; Wed, 24 Feb 2016 05:27:30 -0800 (PST)
Received: from c.mx.filmlight.ltd.uk (c.mx.filmlight.ltd.uk [54.76.112.217])
	by cuda.sgi.com with ESMTP id kBWWsyC7w5NBDHbD for
	<xfs@oss.sgi.com>; Wed, 24 Feb 2016 05:10:33 -0800 (PST)
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Subject: Re: Accidental FS corruption: Mapping files to blocks
From: Roger Willcocks <roger@filmlight.ltd.uk>
In-Reply-To: <CADUjHbXfFEVVk661XMEoAOUM+pQs0LdQh3xFVx6_5tsLZP+P2g@mail.gmail.com>
Date: Wed, 24 Feb 2016 13:10:30 +0000
Message-Id: <BFD65E27-0D04-4019-ADDF-8D156E90BB8F@filmlight.ltd.uk>
References: <CADUjHbXfFEVVk661XMEoAOUM+pQs0LdQh3xFVx6_5tsLZP+P2g@mail.gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: quoted-printable
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Paul Cannon <paul.cannon3128@gmail.com>
Cc: Roger Willcocks <roger@filmlight.ltd.uk>, xfs@oss.sgi.com


On 24 Feb 2016, at 03:37, Paul Cannon <paul.cannon3128@gmail.com> wrote:

> I have accidentally damaged my XFS, and need help (and a little prayer). =
The way it happened will provide your daily amusement dose (and hopefully a=
 lesson).
> ...
> * Luckily I have old copy of the original data!
> So I did a rsync -rvn /olddata/ /xfsB
> Nothing! No difference in any data files. I even tried mirrordir, same th=
ing -- nothing, no difference!
> =

> * Here is what I think is going on, and I need help.
> I suspect that the access time of the file/files stored at this location =
are perhaps in another location in inode (does this sound correct? I am a n=
ewbie to XFS). But the data itself has changed at the location.
> =


That seems likely. Try

rsync =97ignore-times

=97
Roger

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

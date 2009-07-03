Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n63EeTKm172234 for <xfs@oss.sgi.com>; Fri, 3 Jul 2009 09:40:30 -0500
Received: from mail-fx0-f209.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1F09B9D6A5C
	for <xfs@oss.sgi.com>; Fri,  3 Jul 2009 07:47:33 -0700 (PDT)
Received: from mail-fx0-f209.google.com (mail-fx0-f209.google.com
	[209.85.220.209]) by cuda.sgi.com with ESMTP id
	SRF1OzJFv5mFEtQZ for <xfs@oss.sgi.com>;
	Fri, 03 Jul 2009 07:47:33 -0700 (PDT)
Received: by fxm5 with SMTP id 5so2068546fxm.20
	for <xfs@oss.sgi.com>; Fri, 03 Jul 2009 07:41:00 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <7778c60e0907030557j357f88e5g4ab3ce0d3377bb41@mail.gmail.com>
References: <7778c60e0907030557j357f88e5g4ab3ce0d3377bb41@mail.gmail.com>
Date: Fri, 3 Jul 2009 17:41:00 +0300
Message-ID: <6efe08af0907030741q3befbfc5m8c208249dd5cad15@mail.gmail.com>
Subject: Re: Clustered version of XFS
From: "Vitaly V. Ch" <vitaly.v.ch@gmail.com>
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
To: tharindu@sentstory.com
Cc: xfs@oss.sgi.com

On Fri, Jul 3, 2009 at 3:57 PM, Tharindu Rukshan
Bamunuarachchi<tharindu@sentstory.com> wrote:
> we are using XFS high speed transaction processing system.
>
> we are very happy with XFS performance compared to ZFS, EXT3, JFS etc.
>
> i have two questions regarding XFS ...
>
> 1. Is there any cluster version of XFS. (e.g. like GFS, Luste, GPFS)

Yes. Your need cxfs.

> 2. I am currently using my root partition as XFS. but i need to modify
> XFS source code and reload module without rebooting machine.
> =A0 =A0Is there anyway to play with XFS source/module while using XFS
> module for mounted file system ....?

Yes. duplicate Your code and use non-reloadable copy for root fs and
reloadable under other name ("my_xfs" for example) for other
partitions.

>
>
> cheers
> __
> tharindu
>

\\wbr Vitaly Chernookiy

> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

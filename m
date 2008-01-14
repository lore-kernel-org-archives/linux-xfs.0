Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 14 Jan 2008 06:31:01 -0800 (PST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m0EEUuAL004067
	for <xfs@oss.sgi.com>; Mon, 14 Jan 2008 06:30:57 -0800
Received: from orchid.cbk.poznan.pl (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id DB06311CC064
	for <xfs@oss.sgi.com>; Mon, 14 Jan 2008 06:31:13 -0800 (PST)
Received: from orchid.cbk.poznan.pl (cbk-gw.man.poznan.pl [150.254.210.225]) by cuda.sgi.com with ESMTP id c1JUkHVdW1IRbPQx for <xfs@oss.sgi.com>; Mon, 14 Jan 2008 06:31:13 -0800 (PST)
Subject: Re: Question related to XFS sync , especially fsync
From: Olaf =?iso-8859-2?Q?Fr=B1czyk?= <olaf@cbk.poznan.pl>
In-Reply-To: <d711080c0801140414n48e47140y88f545eba605eff9@mail.gmail.com>
References: <d711080c0801140414n48e47140y88f545eba605eff9@mail.gmail.com>
Content-Type: text/plain
Date: Mon, 14 Jan 2008 15:32:32 +0100
Message-Id: <1200321152.10994.13.camel@venus.local.navi.pl>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Gopala Krishna <gopalakrishna.n.m@gmail.com>
Cc: xfs@oss.sgi.com

On Mon, 2008-01-14 at 17:44 +0530, Gopala Krishna wrote:
> So I am suspecting, even after calling fsync (which says it would block
> untill it flushes metadata information to disk ), is not really flushing. So
> only during unmount, it flushes metadata and hence I could get dimode
> properly. since after remounting , by reading metadata information , I could
> get mode properly and differentiate directory or regular file, and also it
> is filling magic etc. properly, I feel the data I am reading is right and
> that I could compare with stat system call and ls commands.
The metadata are put in log. So they are on disk. Just not in the place
you expect them to find.
> 
> If I am doing something wrong and no problem with XFS, then I should not get
> mode field properly even after unmount/remount operation.
At remount the log is replayed and the metadata are in the place where
you expect them to be.
> 
> Is there any problem with XFS fsync? Why dimode is getting updated only
> during unmount? why not when I call fsync? Because fsync says it has to
> flush all meta dat to disk before existing.
And it does.
It is not XFS problem. It is your problem ;)

BTW, the GRUB does similiar thing. And many people reported problems
about it.

Regards,

Olaf

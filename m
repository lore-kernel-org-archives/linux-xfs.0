Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 02 Aug 2006 07:36:42 -0700 (PDT)
Received: from out4.smtp.messagingengine.com (out4.smtp.messagingengine.com [66.111.4.28])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k72EaNDW015466
	for <xfs@oss.sgi.com>; Wed, 2 Aug 2006 07:36:29 -0700
Received: from frontend3.internal (frontend3.internal [10.202.2.152])
	by frontend1.messagingengine.com (Postfix) with ESMTP id 4B8A9D93487
	for <xfs@oss.sgi.com>; Wed,  2 Aug 2006 10:35:57 -0400 (EDT)
Message-Id: <1154529360.12604.267468790@webmail.messagingengine.com>
From: "CN" <cnliou9@fastmail.fm>
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="GB2312"
MIME-Version: 1.0
References: <1154433320.2160.267361956@webmail.messagingengine.com>
   <20060801153951.GB17036@linuxathome.me>
Subject: Re: xfs_check refuses to work on readonly fs
In-Reply-To: <20060801153951.GB17036@linuxathome.me>
Date: Wed, 02 Aug 2006 22:36:00 +0800
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Hi! Hedi,

> Based on the info you provided I infer that you're running Linux.

Yes. I forgot to mention this.

> | # init 1
> | # mount -o ro,remount /
> | # mount
> | /dev/hda1 on / type xfs (rw)
> | # xfs_check /dev/hda1
> | xfs_check: /dev/hda1 contains a mounted and writable filesystem
> |
> | xfs_check/xfs_repair are willing to work only when I boot from a disk
> | and check/repair the other unmounted disk.
> |
> | Why "mount" shows (rw) instead of (ro) even "mount -o ro,remount /" is
> | issued?
> 
> Because mount is relying on /etc/mtab which couldn't be updated
> precisely because / was remounted ro.
> 
> You'll need a recent xfsprogs version, at least 2.7.17 IIRC, one
> that uses that uses /proc/mounts instead of /etc/mtab to check
> filesystem status.
> 
> Or you can use a dirty and quick hack
> 
>     - prior to remounting ro, edit /etc/mtab and change the root fs entry
>     from
>     rw to ro.
>     - remount ro
>     - run your xfs_check/xfs_repair in dangerous mode.
> 
> FWIW the safe thing to do after a repair on a mounted root FS is to
> reboot.

I upgraded xfsprogs to 2.8.4 and have tried both approaches you provided
but still have no luck. Only one thing is different: "mount" now reports
"ro" if I edit /etc/mtab as you instructed.

Regards,

CN

-- 
http://www.fastmail.fm - The professional email service

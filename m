Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 16 Feb 2008 02:23:59 -0800 (PST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m1GANq0f016318
	for <xfs@oss.sgi.com>; Sat, 16 Feb 2008 02:23:55 -0800
Received: from fk-out-0910.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 665F65E2E5B
	for <xfs@oss.sgi.com>; Sat, 16 Feb 2008 02:24:16 -0800 (PST)
Received: from fk-out-0910.google.com (fk-out-0910.google.com [209.85.128.191]) by cuda.sgi.com with ESMTP id CMhbIvvFmHqdXOYg for <xfs@oss.sgi.com>; Sat, 16 Feb 2008 02:24:16 -0800 (PST)
Received: by fk-out-0910.google.com with SMTP id 18so1032396fks.4
        for <xfs@oss.sgi.com>; Sat, 16 Feb 2008 02:24:14 -0800 (PST)
Message-ID: <e03b90ae0802160224v600bd94exb2a1007ca7af7b65@mail.gmail.com>
Date: Sat, 16 Feb 2008 02:24:14 -0800
From: "Jeff Breidenbach" <jeff@jab.org>
Subject: Re: tuning, many small files, small blocksize
In-Reply-To: <47B6ACC5.3030605@theendofthetunnel.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <e03b90ae0802152101t2bfa4644kcca5d6329239f9ff@mail.gmail.com>
	 <47B6ACC5.3030605@theendofthetunnel.de>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Hannes Dorbath <light@theendofthetunnel.de>
Cc: xfs@oss.sgi.com

> That's maybe a bit paranoid, but on the other hand it should give good
> parallelism.

Yes, the goal is fast read performance for small files.

> mkfs.xfs -n size=16k -i attr=2 -l lazy-count=1,version=2,size=32m -b
> size=512 /dev/sda
>
> mount -onoatime,logbufs=8,logbsize=256k /dev/sda /mnt/xfs

This is highly appreciated, thank you very much.

> Requires kernel 2.6.23 and xfsprogs 2.9.5. As said, you might want to
> use an external log device.

I'm running vendor a supplied kernel of 2.6.22 and a quick test shows
the unsupported feature is lazy-count. How big a deal is it? Upgrading
the kernel before April is painful but I'll do it if important. Presumably
there's no simple way to migrate a non-lazy xfs filesytem to a lazy one.

PS. I don't know if this affects any parameters, but the biggest directory
will have approximately 1.5 million files. There are a few in the one to two
hundred thousand range, and then very many in the tens of thousands.

Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 18 Feb 2008 20:58:40 -0800 (PST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m1J4wXI3001557
	for <xfs@oss.sgi.com>; Mon, 18 Feb 2008 20:58:34 -0800
Received: from fk-out-0910.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 209BDE5C25A
	for <xfs@oss.sgi.com>; Mon, 18 Feb 2008 20:58:58 -0800 (PST)
Received: from fk-out-0910.google.com (fk-out-0910.google.com [209.85.128.188]) by cuda.sgi.com with ESMTP id 1BjtSsmImHPvT2Jt for <xfs@oss.sgi.com>; Mon, 18 Feb 2008 20:58:58 -0800 (PST)
Received: by fk-out-0910.google.com with SMTP id 18so2129633fks.4
        for <xfs@oss.sgi.com>; Mon, 18 Feb 2008 20:58:57 -0800 (PST)
Message-ID: <e03b90ae0802182058h7a1535c6w749eb46cbe434ef2@mail.gmail.com>
Date: Mon, 18 Feb 2008 20:58:56 -0800
From: "Jeff Breidenbach" <jeff@jab.org>
Subject: Re: tuning, many small files, small blocksize
In-Reply-To: <20080219024924.GB155407@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <e03b90ae0802152101t2bfa4644kcca5d6329239f9ff@mail.gmail.com>
	 <47BA10EC.3090004@tlinx.org> <20080218235103.GW155407@sgi.com>
	 <47BA2AFD.2060409@tlinx.org> <20080219024924.GB155407@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: Linda Walsh <xfs@tlinx.org>, xfs@oss.sgi.com

Wow, this is quite some discussion.

I went with Hannes Dorbath's original suggestion (appended),
and am now several days into copying data onto the filesystem.
It's conceivable to change course at this point, but awkward.
Dave, you suggested biting the bullet and sacrificing capacity.
Are we talking an overwhelming difference in read performance
from random files - e.g. reducing the number of seeks by 2X?

Finally, in answer to Linda's question, I don't forsee any appends
at all. The vast majority of files will be write once, read many. A
small fraction will be re-written, e.g. new contents, same filename.
An utterly insignificant fraction will be deleted.

>mkfs.xfs -n size=16k -i attr=2 -l lazy-count=1,version=2,size=32m \
>-b size=512 /dev/sda
>
>mount -onoatime,logbufs=8,logbsize=256k /dev/sda /mnt/xfs

Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 24 Sep 2008 17:25:59 -0700 (PDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m8P0Pucm032028
	for <xfs@oss.sgi.com>; Wed, 24 Sep 2008 17:25:56 -0700
Received: from ipmail04.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2A0001AE94D1
	for <xfs@oss.sgi.com>; Wed, 24 Sep 2008 17:27:29 -0700 (PDT)
Received: from ipmail04.adl2.internode.on.net (ipmail04.adl2.internode.on.net [203.16.214.57]) by cuda.sgi.com with ESMTP id ze1cU8ptdQKPsJEz for <xfs@oss.sgi.com>; Wed, 24 Sep 2008 17:27:29 -0700 (PDT)
Date: Thu, 25 Sep 2008 10:27:24 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Speed of rm compared to reiserfs (slow)
Message-ID: <20080925002724.GA27997@disturbed>
References: <48D9FDA1.8050701@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <48D9FDA1.8050701@gmail.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: =?iso-8859-1?B?VPZy9ms=?= Edwin <edwintorok@gmail.com>
Cc: xfs@oss.sgi.com

On Wed, Sep 24, 2008 at 11:43:13AM +0300, Török Edwin wrote:
> Hi,
> 
> I am happily using xfs for /var, /usr and /, and I am very pleased with
> the read speed.
> I've just recommended xfs to a friend, and he complained about the speed
> of rm.
> 
> I did a test on my box, and indeed the speed of rm is order of magnitude
> slower compared to reiserfs.
> I already use lazy-count, and noatime/nodiratime. Write barriers are off
> because I run on raid10.
> 
> Is there anything else I can tune to get faster rm speed?

mount -o logbsize=262144 <dev> <mtpt>

> # mount | grep var
> /dev/mapper/vg--all-lv--var on /var type xfs (rw,noatime,nodiratime)

BTW, noatime implies nodiratime - you don't ned to specify both.

> tmpfs                 2.0G   12K  2.0G   1% /lib/init/rw
> udev                   10M  188K  9.9M   2% /dev
> tmpfs                 2.0G     0  2.0G   0% /dev/shm
> /dev/mapper/vg--all-lv--usr
>                       100G  5.3G   95G   6% /usr
> /dev/mapper/vg--all-lv--var
>                       1.3T  230G  1.1T  18% /var

At 1.1T, you probably want to use inode64 for /var. The different
allocation strategy of inode32 can be substantially slower than
inode64.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

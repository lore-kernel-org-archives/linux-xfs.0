Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id D25AF7CA0
	for <xfs@oss.sgi.com>; Fri, 29 Jul 2016 16:50:00 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 53C7CAC002
	for <xfs@oss.sgi.com>; Fri, 29 Jul 2016 14:50:00 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id E1dPpoJJ0qNAT72x for <xfs@oss.sgi.com>;
	Fri, 29 Jul 2016 14:49:57 -0700 (PDT)
Received: from [10.0.0.4] (liberator [10.0.0.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id 91106481F
	for <xfs@oss.sgi.com>; Fri, 29 Jul 2016 16:49:56 -0500 (CDT)
Subject: Re: partition 100% full No space left on device. looks like xfs is
	corrupted or a bug
References: <4278AB9734C1445A8E48635B155149F8@dinulap>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <83306f91-6bc3-258b-19a8-68e60317de43@sandeen.net>
Date: Fri, 29 Jul 2016 16:49:56 -0500
MIME-Version: 1.0
In-Reply-To: <4278AB9734C1445A8E48635B155149F8@dinulap>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

On 7/29/16 4:01 AM, Lista Unx wrote:
> Hello xfs experts,
>  
> I am crawling in the dark from few days and I have no idea how to fix the following problem. On a centos 7 system:
>  
> # uname -a
> Linux 1a 3.10.0-327.el7.x86_64 #1 SMP Thu Nov 19 22:10:57 UTC 2015 x86_64 x86_64 x86_64 GNU/Linux
>  
> df is reporting 100% full of / and du is reporting only 1.7G usage from 50GB available (less than 4%). I want to mention that / is xfs. See below:
>  
> # df -a|grep ^/
> /dev/mapper/centos-root  52403200 52400396      2804 100% /
>                                      ^^^^^^^^^^   ^^^^^^^^^^
> /dev/sda1                  503040   131876    371164  27% /boot
> /dev/mapper/centos-home 210529792    35204 210494588   1% /home
>  
> du is estimating just 1.7G usage of /
> # du -sch /* --exclude=home --exclude=boot

...

> 0       /lib64
> 744K    /luarocks-2.3.0
> 0       /media
> 0       /mnt
> 125M    /openresty-1.9.7.4
> 0       /opt
> 420K    /root
> 49M     /run
> 0       /sbin
> 0       /srv
> 0       /sys
> 0       /tmp
> 1.3G    /usr
> 227M    /var
> 1.7G    total
> [root@localhost ~]#

Can you include full contents of /proc/mounts?

If you have something bind-mounted or similar, it will hide it from "du" traversal.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

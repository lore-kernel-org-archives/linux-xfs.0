Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 13 May 2008 01:30:38 -0700 (PDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m4D8UFNR009690
	for <xfs@oss.sgi.com>; Tue, 13 May 2008 01:30:17 -0700
Received: from ns.unixsol.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7148A169A798
	for <xfs@oss.sgi.com>; Tue, 13 May 2008 01:31:01 -0700 (PDT)
Received: from ns.unixsol.org (ns.unixsol.org [193.110.159.2]) by cuda.sgi.com with ESMTP id qPEIKCpcsxc2xtop for <xfs@oss.sgi.com>; Tue, 13 May 2008 01:31:01 -0700 (PDT)
Message-ID: <482951C3.60600@unixsol.org>
Date: Tue, 13 May 2008 11:30:59 +0300
From: Georgi Chorbadzhiyski <gf@unixsol.org>
MIME-Version: 1.0
Subject: Re: Unneeded kernel threads (xfs, jfs, gfs2)
References: <4828CAC6.3090402@unixsol.org> <48292742.8090409@sgi.com>
In-Reply-To: <48292742.8090409@sgi.com>
Content-Type: text/plain; charset=windows-1251; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Donald Douwsma <donaldd@sgi.com>
Cc: xfs@oss.sgi.com, jfs-discussion@lists.sourceforge.net, cluster-devel@redhat.com, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>

Donald Douwsma mumbled something about, On 5/13/08 8:29 AM:
> Georgi Chorbadzhiyski wrote:
>> Hi guys, I know that not all kernel thread users are converted to
>> start only when needed but the following is little annoying specially
>> when I'm not even using jfs, xfs and gfs2.
>>
>> Look at the ps output from a standard distro 2.6.24.5 kernel after a
>> fresh boot:
> ...
> 
>> Kernel config can be found here:
>>   
>> http://mirrors.unixsol.org/slackware/slackware-12.1/kernels/hugesmp.s/config 
> 
> Your distro is building all of these modules into the kernel.
>     CONFIG_XFS_FS=y
>     CONFIG_JFS_FS=y
>     CONFIG_GFS2_FS=y
> 
> This isnt exactly standard practice, normally they'd be set to =m and only
> used if required to mount a filesystem. You may want to ask the slackware
> people why they chose to do this for their hugexxx.s kernels.

I know that they are compiled in the kernel, but since they
are not used isn't starting their own kthreads kind of
unnecessary? Surely the threads can be started on demand
only when xfs/etc volume is mounted.

-- 
Georgi Chorbadzhiyski
http://georgi.unixsol.org/

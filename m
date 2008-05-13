Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 13 May 2008 01:32:33 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m4D8WLrj010089
	for <xfs@oss.sgi.com>; Tue, 13 May 2008 01:32:22 -0700
Received: from ns.unixsol.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5639F15C4F8
	for <xfs@oss.sgi.com>; Tue, 13 May 2008 01:33:08 -0700 (PDT)
Received: from ns.unixsol.org (ns.unixsol.org [193.110.159.2]) by cuda.sgi.com with ESMTP id Rysk6bEc8cbY9Alc for <xfs@oss.sgi.com>; Tue, 13 May 2008 01:33:08 -0700 (PDT)
Message-ID: <48295240.4030301@unixsol.org>
Date: Tue, 13 May 2008 11:33:04 +0300
From: Georgi Chorbadzhiyski <gf@unixsol.org>
MIME-Version: 1.0
Subject: Re: Unneeded kernel threads (xfs, jfs, gfs2)
References: <4828CAC6.3090402@unixsol.org>	<48292742.8090409@sgi.com> <20080513075107.2edc44d3@olorin>
In-Reply-To: <20080513075107.2edc44d3@olorin>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: FD Cami <francois.cami@free.fr>
Cc: Donald Douwsma <donaldd@sgi.com>, xfs@oss.sgi.com, jfs-discussion@lists.sourceforge.net, cluster-devel@redhat.com, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, volkerdi@slackware.com

FD Cami mumbled something about, On 5/13/08 8:51 AM:
> On Tue, 13 May 2008 15:29:38 +1000
> Donald Douwsma <donaldd@sgi.com> wrote:
> 
>> Georgi Chorbadzhiyski wrote:
>>> Hi guys, I know that not all kernel thread users are converted to
>>> start only when needed but the following is little annoying specially
>>> when I'm not even using jfs, xfs and gfs2.
>>>
>>> Look at the ps output from a standard distro 2.6.24.5 kernel after a
>>> fresh boot:
>> ...
>>
>>> Kernel config can be found here:
>>>   http://mirrors.unixsol.org/slackware/slackware-12.1/kernels/hugesmp.s/config
>>>
>> Your distro is building all of these modules into the kernel.
>> 	CONFIG_XFS_FS=y
>> 	CONFIG_JFS_FS=y
>> 	CONFIG_GFS2_FS=y
>>
>> This isnt exactly standard practice, normally they'd be set to =m and only
>> used if required to mount a filesystem. You may want to ask the slackware
>> people why they chose to do this for their hugexxx.s kernels.
> 
> To be able to use those filesystems on root partitions without requiring
> an initrd. 
> 
> Georgi might be interested to use the generic kernel instead of the huge
> one, it is available there :
> http://mirrors.unixsol.org/slackware/slackware-12.1/slackware/a/kernel-generic-smp-2.6.24.5_smp-i686-2.tgz

I'm well aware of this kernels but I prefer to not use
initrd when possible and still have most of the functionality
available.

-- 
Georgi Chorbadzhiyski
http://georgi.unixsol.org/

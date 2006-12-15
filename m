Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 15 Dec 2006 06:57:51 -0800 (PST)
Received: from sandeen.net (sandeen.net [209.173.210.139])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id kBFEvhqw022241
	for <xfs@oss.sgi.com>; Fri, 15 Dec 2006 06:57:44 -0800
Message-ID: <4582B7B4.9070803@sandeen.net>
Date: Fri, 15 Dec 2006 08:56:52 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: not able to create XFS filesystem
References: <743683.94860.qm@web32704.mail.mud.yahoo.com> <4582AE73.9080409@science-computing.de>
In-Reply-To: <4582AE73.9080409@science-computing.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Alexander Apprich <a.apprich@science-computing.de>
Cc: xfs@oss.sgi.com

Alexander Apprich wrote:
> Hi,
> 
> chandrasekar mahalingam wrote:
>> Hi
>>    my RHEL 4 machine (Linux spea44 2.6.9-42.ELsmp #1
>> SMP Wed Jul 12 23:32:02 EDT 2006 x86_64 x86_64 x86_64
>> GNU/Linux) has the rpm installed for XFS .
>> xorg-x11-xfs-6.8.2-1.EL.13.36 and
>> xorg-x11-libs-6.8.2-1.EL.13.36
>>
> 
> those packages have nothing to do with the XFS filesystem :-)

*nod* that's xwindows.

>> when i try to create a file system using
>>  "mkfs -t xfs /dev/sekarvg/simple1" it says "mkfs.XFS:
>> No such file or directory" . "lsmod|grep -i xfs " does
>> not list xfs .
> 
> AFAIK the XFS filesystem isn't officially supported by
> RedHat. You might get them from someplace else like

It's not officially or unofficially supported.  It's completely not 
supported and not present.  If you really need supported xfs in RHEL 
you'll have to ask Red Hat for that, and I wish you luck.  :)

> http://atrpms.net/dist/el4/

Or http://sandeen.net/rhel4_xfs

that contains a module rpm so you can run xfs in the stock RHEL kernel.

you'll need userspace too, probably simplest to get a recent xfsprogs 
src.rpm from FC6 and the rpmbuild --rebuild xfsprogs-<foo>.src.rpm

The above combination should work well for you.

-Eric

> But the kernel also need to support xfs.
> 
> 
> Hth
> 
> Alex
> 
> 

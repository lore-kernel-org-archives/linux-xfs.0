Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id A07BB7F3F
	for <xfs@oss.sgi.com>; Thu, 27 Feb 2014 13:38:44 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 7CB61304053
	for <xfs@oss.sgi.com>; Thu, 27 Feb 2014 11:38:44 -0800 (PST)
Received: from slmp-550-94.slc.westdc.net (slmp-550-94.slc.westdc.net
	[50.115.112.57]) by cuda.sgi.com with ESMTP id BC7jBc4XwxY98oRp
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 27 Feb 2014 11:38:42 -0800 (PST)
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: XFS on Fedora i686, armv7hl
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <530F548C.9060302@sandeen.net>
Date: Thu, 27 Feb 2014 12:38:39 -0700
Message-Id: <DEA54534-9D7E-4957-9DB6-A402C077C00C@colorremedies.com>
References: <8A28EF88-012E-4036-BDB6-E76B1CC569A7@colorremedies.com>
	<530F548C.9060302@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: arm@lists.fedoraproject.org, Test Fedora <test@lists.fedoraproject.org>, xfs@oss.sgi.com


On Feb 27, 2014, at 8:06 AM, Eric Sandeen <sandeen@sandeen.net> wrote:

> On 2/26/14, 11:37 PM, Chris Murphy wrote:
>> Hi,
>> 
>> Fedora is considering XFS as their default file system. They support
>> three primary architectures: x86_64, i686, and armv7hl.  Do XFS devs
>> have any reservations about XFS as a default file system on either
>> i686, or arm?
> 
> As Dave said, we rely on others to do ARM testing for the most part,
> though I've certainly jumped in and debugged some issues from time
> to time.
> 
> It'd be super if Fedora could run the xfstests test suite on arm
> as part of QE.  I'd be more than happy to help get that started
> if people are interested.

I don't know that Fedora QA has the resources to do this, but I'll cc the Fedora test@ (QA) arm@ lists. If these are highly automatable tests it might be possible, if they have the hardware. More likely I think it's that we need some ARM community folks to look at splitting up some of this work.

I'm not sure yet what concerns the ARM group might have with XFS either as this hasn't been decided, but the Fedora Server product working group is slightly leaning toward XFS by default. Performance and CPU hit wise on x86_64, XFS seems to match up well with ext4 and maybe even a bit better ratio of throughput/CPUtime for booting workload (systemd is parallel!) so if were the same on ARM XFS could work out slightly better for them.


Chris Murphy
_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

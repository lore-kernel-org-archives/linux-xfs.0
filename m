Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 22 Sep 2006 16:20:01 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k8MNJpaG007055
	for <xfs@oss.sgi.com>; Fri, 22 Sep 2006 16:19:51 -0700
Received: from sandeen.net (sandeen.net [209.173.210.139])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E1EEAD110A22
	for <xfs@oss.sgi.com>; Fri, 22 Sep 2006 16:19:12 -0700 (PDT)
Message-ID: <45146F76.3010301@sandeen.net>
Date: Fri, 22 Sep 2006 18:19:18 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH -mm] rescue large xfs preferred iosize from the inode
 diet patch
References: <45131334.6050803@sandeen.net>	<45134472.7080002@sgi.com> <20060922161040.609286fa.akpm@osdl.org>
In-Reply-To: <20060922161040.609286fa.akpm@osdl.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Andrew Morton <akpm@osdl.org>
Cc: Timothy Shimmin <tes@sgi.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, xfs mailing list <xfs@oss.sgi.com>

Andrew Morton wrote:

>> So the fix for this is coming soon (and the fix is different from the
>> one above).
>>
> 
> eh?  Eric's patch is based on -mm, which includes the XFS git tree.  If I
> go and merge the inode-diet patches from -mm, XFS gets broken until you
> guys merge the above mystery patch.  (I prefer to merge the -mm patches
> after all the git trees have gone, but sometimes maintainers dawdle and I
> get bored of waiting).
> 
> Is git://oss.sgi.com:8090/nathans/xfs-2.6 obsolete, or are you hiding stuff
> from me?  ;)
> 
> 
well it's in cvs:

http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_iops.c.diff?r1=text&tr1=1.254&r2=text&tr2=1.253&f=h

but I'm too lazy to check git on a friday evening. :)

Well, sgi-guys, I'll let you sort out which patch you want.  Sorry for not 
checking cvs first!

-Eric

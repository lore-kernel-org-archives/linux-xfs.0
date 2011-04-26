Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p3QLmrSU183970
	for <linux-xfs@oss.sgi.com>; Tue, 26 Apr 2011 16:48:53 -0500
Received: from mail.1-click.hu (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5EC1315C9757
	for <linux-xfs@oss.sgi.com>; Tue, 26 Apr 2011 14:52:24 -0700 (PDT)
Received: from mail.1-click.hu (ns2.netcenter.hu [195.228.155.139]) by
	cuda.sgi.com with ESMTP id NEdvJNYZvuEuMTHl for
	<linux-xfs@oss.sgi.com>; Tue, 26 Apr 2011 14:52:24 -0700 (PDT)
Message-ID: <367BBF55D8CD426888E671F8C7422966@myXP>
From: "Janos Haar" <janos.haar@netcenter.hu>
References: <DFA094D472104424BEA7AA9060DE0D6F@myXP>
	<20110411214238.GE21395@dastard>
	<20110411233705.GA29358@infradead.org>
Subject: Re: 2 question about XFS fragmentation and _fsr: Q2
Date: Tue, 26 Apr 2011 23:49:53 +0200
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@oss.sgi.com


----- Original Message ----- 
From: "Christoph Hellwig" <hch@infradead.org>
To: "Dave Chinner" <david@fromorbit.com>
Cc: "Janos Haar" <janos.haar@netcenter.hu>; <linux-xfs@oss.sgi.com>
Sent: Tuesday, April 12, 2011 1:37 AM
Subject: Re: 2 question about XFS fragmentation and _fsr


> On Tue, Apr 12, 2011 at 07:42:38AM +1000, Dave Chinner wrote:
>> Depends on your samba configuration to how it does writes. If it is
>> conigured to do sync writes then it will have all sorts of
>> fragmentation problems. So without more details about the workload,
>> the kernel that is being used, the fragmentation occurring (xfs_bmap
>> is your friend) and the samba config, there's little that can be
>> suggested here.
>
> Very few people configure Samba to do sync writes, but even without
> that I see files written by Samba heavily fragmented when the systems
> operates under intense memory pressure.  The CIFS protocol has very
> small write sizes, and it seems like they do not always arrive in order.
> If the system is under enough memory pressure to write them out already
> before the previous fragment arrive it can cause very fragmented
> extent maps.  Enabling the "strict allocate" option in newer Samba
> version fixes that problem by doing fallocates in larger chunks, which
> from my observation always happen in order.  The downside is that
> current fallocate in XFS is not designed to be used in a fastpath,
> and thus causes performance degradations during the actual write.

Is there anything what i can do in proc/sys/vm configuration to solve the 
fragment write problem?

Thanks,
Janos 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

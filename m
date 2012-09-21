Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q8LLweCW254571 for <xfs@oss.sgi.com>; Fri, 21 Sep 2012 16:58:40 -0500
Received: from mail.sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com
	with ESMTP id JS1mp92fA33KpflX for <xfs@oss.sgi.com>;
	Fri, 21 Sep 2012 14:59:54 -0700 (PDT)
Message-ID: <505CE359.7020707@sandeen.net>
Date: Fri, 21 Sep 2012 16:59:53 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: RHEL 6.x xfs mount causing panic after forced shutdown
References: <505CE0CA.6090005@slac.stanford.edu>
In-Reply-To: <505CE0CA.6090005@slac.stanford.edu>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Ling Ho <ling@slac.stanford.edu>
Cc: xfs@oss.sgi.com

On 9/21/12 4:48 PM, Ling Ho wrote:
> Hi,
> 
> I am facing a problem when my servers get power cycled by force. When they come up, almost everytime when xfs filesystems are being mounted, I get a system panic.

Hm, you didn't include the panic itself, though.

But bugs for distros like RHEL (or RHS, perhaps) should probably be reported to your Red Hat Support contacts, rather than taken to the upstream mailing list...

-Eric

> It looks like what's described here:
> 
> https://bugzilla.redhat.com/show_bug.cgi?id=657166
> 
> But I am running RHEL 6.2 and 6.3 (2.6.32-279.el6.x86_64)
> 
> This is what my fstab entrys look like:
> 
> LABEL=/brick1                /brick1                 xfs sunit=256,swidth=3328,noatime,nodiratime,logbufs=8,largeio,quota 0 0
> 
> 
> # xfs_info /brick1
> meta-data=/dev/sdb               isize=256    agcount=24, agsize=268435200 blks
>          =                       sectsz=512   attr=2
> data     =                       bsize=4096   blocks=6347161600, imaxpct=5
>          =                       sunit=32     swidth=416 blks
> naming   =version 2              bsize=4096   ascii-ci=0
> log      =internal               bsize=4096   blocks=521728, version=2
>          =                       sectsz=512   sunit=8 blks, lazy-count=1
> realtime =none                   extsz=4096   blocks=0, rtextents=0
> 
> 
> Even if I go to single user mode and try to mount (via the fstab entry), I get the panic. But I can mount it without any option by doing "mount /dev/sdb /brick1".
> 
> Is there any workaround to this?
> 
> Thanks,
> ...
> ling
> 
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

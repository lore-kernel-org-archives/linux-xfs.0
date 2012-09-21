Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q8LLljw6253705 for <xfs@oss.sgi.com>; Fri, 21 Sep 2012 16:47:45 -0500
Received: from nospam3.slac.stanford.edu (nospam3.slac.stanford.edu
	[134.79.18.80]) by cuda.sgi.com with ESMTP id kslka6RRxXYs0wbP
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 21 Sep 2012 14:48:59 -0700 (PDT)
Received: from mailgate04.slac.stanford.edu (mailgate04.slac.stanford.edu
	[134.79.102.8])
	by nospam3.slac.stanford.edu (8.14.4/8.14.4) with ESMTP id
	q8LLmwOD031636
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Fri, 21 Sep 2012 14:48:58 -0700
	(envelope-from ling@slac.stanford.edu)
Received: from [134.79.72.90] (pcds108.slac.stanford.edu [134.79.72.90])
	(Authenticated sender: ling)
	by mailgate04.slac.stanford.edu (Postfix) with ESMTP id 702442E2EDC
	for <xfs@oss.sgi.com>; Fri, 21 Sep 2012 14:48:58 -0700 (PDT)
Message-ID: <505CE0CA.6090005@slac.stanford.edu>
Date: Fri, 21 Sep 2012 14:48:58 -0700
From: Ling Ho <ling@slac.stanford.edu>
MIME-Version: 1.0
Subject: RHEL 6.x xfs mount causing panic after forced shutdown
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
To: xfs@oss.sgi.com

Hi,

I am facing a problem when my servers get power cycled by force. When 
they come up, almost everytime when xfs filesystems are being mounted, I 
get a system panic.

It looks like what's described here:

https://bugzilla.redhat.com/show_bug.cgi?id=657166

But I am running RHEL 6.2 and 6.3 (2.6.32-279.el6.x86_64)

This is what my fstab entrys look like:

LABEL=/brick1                /brick1                 xfs 
sunit=256,swidth=3328,noatime,nodiratime,logbufs=8,largeio,quota 0 0


# xfs_info /brick1
meta-data=/dev/sdb               isize=256    agcount=24, 
agsize=268435200 blks
          =                       sectsz=512   attr=2
data     =                       bsize=4096   blocks=6347161600, imaxpct=5
          =                       sunit=32     swidth=416 blks
naming   =version 2              bsize=4096   ascii-ci=0
log      =internal               bsize=4096   blocks=521728, version=2
          =                       sectsz=512   sunit=8 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0


Even if I go to single user mode and try to mount (via the fstab entry), 
I get the panic. But I can mount it without any option by doing "mount 
/dev/sdb /brick1".

Is there any workaround to this?

Thanks,
...
ling


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

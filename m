Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 26 Sep 2006 07:00:02 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k8QDxtaG017547
	for <xfs@oss.sgi.com>; Tue, 26 Sep 2006 06:59:56 -0700
Received: from tricca.tcs.tulane.edu (tricca.tcs.tulane.edu [129.81.224.27])
	by cuda.sgi.com (Spam Firewall) with ESMTP id CCDB645EC53
	for <xfs@oss.sgi.com>; Tue, 26 Sep 2006 06:59:15 -0700 (PDT)
Message-ID: <45193204.3030500@tulane.edu>
Date: Tue, 26 Sep 2006 08:58:28 -0500
From: Rene Salmon <rsalmon@tulane.edu>
MIME-Version: 1.0
Subject: Re: LVM and XFS cannot set blocksize on block device
References: <45185424.2030707@tulane.edu> <20060926001737.GA10224@tuatara.stupidest.org>
In-Reply-To: <20060926001737.GA10224@tuatara.stupidest.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Chris Wedgwood <cw@f00f.org>
Cc: xfs@oss.sgi.com

Hi,

Thanks for the reply. The "-s size=4096" helped I was able to create
the file system, then mount it and use it.  I did however get a warning 
still about "cannot set blocksize on block device".  Everything seems to 
be working but I am a bit worried about the warning message.  Following 
is the message.  Any ideas if it is safe to ignore this or any way to 
get rid of it?




helix-priv:~ # mkfs.xfs -s size=4096 -f /dev/vg_u00/lv_u00
mkfs.xfs: warning - cannot set blocksize on block device 
/dev/vg_u00/lv_u00: Invalid argument
meta-data=/dev/vg_u00/lv_u00     isize=256    agcount=32, 
agsize=11489280 blks
          =                       sectsz=4096  attr=0
data     =                       bsize=4096   blocks=367656960, imaxpct=25
          =                       sunit=0      swidth=0 blks, unwritten=1
naming   =version 2              bsize=4096
log      =internal log           bsize=4096   blocks=32768, version=2
          =                       sectsz=4096  sunit=1 blks
realtime =none                   extsz=65536  blocks=0, rtextents=0


Thanks
Rene




Chris Wedgwood wrote:
> On Mon, Sep 25, 2006 at 05:11:48PM -0500, Rene Salmon wrote:
> 
>> Warning: the data subvolume sector size 512 is less than the sector size
>> reported by the device (4096).
> 
> does "-s size=4096" help?

-- 
-
--
         Rene Salmon
         Tulane University
         Center for Computational Science
         http://www.ccs.tulane.edu
	rsalmon@tulane.edu
         Tel 504-862-8393
	Tel 504-988-8552
         Fax 504-862-8392

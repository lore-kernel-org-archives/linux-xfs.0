Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qB50U9EF212036 for <xfs@oss.sgi.com>; Tue, 4 Dec 2012 18:30:09 -0600
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id cYSG6D2H4CmScbTs
	for <xfs@oss.sgi.com>; Tue, 04 Dec 2012 16:32:32 -0800 (PST)
Received: from [192.168.100.53] (gffx.hardwarefreak.com [192.168.100.53])
	by greer.hardwarefreak.com (Postfix) with ESMTP id C3D986C10A
	for <xfs@oss.sgi.com>; Tue,  4 Dec 2012 18:32:31 -0600 (CST)
Message-ID: <50BE961B.8030705@hardwarefreak.com>
Date: Tue, 04 Dec 2012 18:32:27 -0600
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: xfsdump INTERRUPT issue
References: <50BAB19F.1010808@hardwarefreak.com>
	<CCE2425A.B0475%jellis@dhnet.us> <20121203213457.GA32450@dastard>
	<3AB03753-4C96-432B-BC52-BBC52B0745B6@gmail.com>
In-Reply-To: <3AB03753-4C96-432B-BC52-BBC52B0745B6@gmail.com>
Reply-To: stan@hardwarefreak.com
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
To: xfs@oss.sgi.com

On 12/3/2012 4:27 PM, Jeffrey Ellis wrote:

xfs_info output and this below is all that is needed at this point.

>> FWIW, this implies that xfsrestore failed. What is the output from
>> xfsrestore? Can you just run xfsdump to a file?

> Can you tell me how to do that and dmesg?

The command you posted

xfsdump -J - /mnt/hr20 | xfsrestore -J - /mnt/fp

pipes the output from xfsdump into xfsrestore.  This error

xfsdump: WARNING: write to stdio failed: 32 (Broken pipe)

tells us something broke while piping into xfsrestore, possibly
xfsrestore itself.  I believe what Dave is asking you is to xfsdump to a
file, then xfsrestore that file.  In two separate operations.  This
should tell us more about where the problem is.

Regarding dmesg information, simply do

~$ dmesg

and copy the output into your email.  It should be a few screen fulls
starting with something like:

Linux version 3.2.6 (root@greer) (gcc version 4.4.5 (Debian 4.4.5-8) )
#1 SMP Mon Feb 20 17:05:10 CST 2012

WRT xfs_info:

~$ cat /etc/mtab
...
/dev/sda6 /home xfs rw 0 0
...

~$ xfs_info /dev/sda6
meta-data=/dev/sda6         isize=256    agcount=4, agsize=6103694 blks
         =                  sectsz=512   attr=2
data     =                  bsize=4096   blocks=24414775, imaxpct=25
         =                  sunit=0      swidth=0 blks
naming   =version 2         bsize=4096   ascii-ci=0
log      =internal          bsize=4096   blocks=11921, version=2
         =                  sectsz=512   sunit=0 blks, lazy-count=0
realtime =none              extsz=4096   blocks=0, rtextents=0


-- 
Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id B53D67F6D
	for <xfs@oss.sgi.com>; Tue,  6 Jan 2015 11:02:17 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id A40D38F8035
	for <xfs@oss.sgi.com>; Tue,  6 Jan 2015 09:02:14 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id 8zpRExtQZkCOPIGm for <xfs@oss.sgi.com>;
	Tue, 06 Jan 2015 09:02:12 -0800 (PST)
Message-ID: <54AC1511.1060908@sandeen.net>
Date: Tue, 06 Jan 2015 11:02:09 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: What is a recommended XFS sector size for hybrid (512e) advanced
	format hard drives?
References: <1806495.BCZcrVVEOf@shtub-cm>
In-Reply-To: <1806495.BCZcrVVEOf@shtub-cm>
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
To: Hillel Lubman <shtetldik@gmail.com>, xfs@oss.sgi.com

On 1/4/15 6:56 PM, Hillel Lubman wrote:
> Hi.


> Can you please clarify what after all is the recommended sector size
> for such drives and why isn't it a default in mkfs.xfs (since
> supposedly defaults are generally recommended optimal settings unless
> you have some special use case).

It is indeed the default.  

[root@sandeen ~]# blockdev --getss --getpbsz /dev/sde
512
4096
[root@sandeen ~]# mkfs.xfs /dev/sde
meta-data=/dev/sde               isize=256    agcount=1, agsize=4097 blks
         =                       sectsz=4096  attr=2, projid32bit=0
data     =                       bsize=4096   blocks=4097, imaxpct=25
         =                       sunit=1      swidth=8 blks
naming   =version 2              bsize=4096   ascii-ci=0
log      =internal log           bsize=4096   blocks=1424, version=2
         =                       sectsz=4096  sunit=1 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0


however, some drives lie about these sizes, and then mkfs.xfs can't know.
Try the blockdev command above to see.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

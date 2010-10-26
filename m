Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o9Q7Nhtl052329 for <xfs@oss.sgi.com>; Tue, 26 Oct 2010 02:23:43 -0500
Received: from server655-han.de-nserver.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D4D5011FA313
	for <xfs@oss.sgi.com>; Tue, 26 Oct 2010 00:40:31 -0700 (PDT)
Received: from server655-han.de-nserver.de (server655-han.de-nserver.de
	[85.158.177.45]) by cuda.sgi.com with ESMTP id iXXtHLrHDnqPvDPt
	for <xfs@oss.sgi.com>; Tue, 26 Oct 2010 00:40:31 -0700 (PDT)
Message-ID: <4CC68249.7050409@profihost.ag>
Date: Tue, 26 Oct 2010 09:24:57 +0200
From: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
MIME-Version: 1.0
Subject: Re: Pid: 8345, comm: rsync Not tainted 2.6.32.22intel #1
References: <4CC67450.9020602@profihost.ag>
	<20101026092205.086c0d89@galadriel.home>
In-Reply-To: <20101026092205.086c0d89@galadriel.home>
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
To: Emmanuel Florac <eflorac@intellique.com>
Cc: xfs@oss.sgi.com

Am 26.10.2010 09:22, schrieb Emmanuel Florac:
> xfs_info /dev/sdc3

Hi here are the details:

root@server361-han:~# xfs_info /dev/sdc3

meta-data=/dev/sdc3              isize=256    agcount=32, 
agsize=40038461 blks
          =                       sectsz=512   attr=0
data     =                       bsize=4096   blocks=1281230752, imaxpct=25
          =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096
log      =internal               bsize=4096   blocks=32768, version=2
          =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0

root@server361-han:~# mount|grep sdc3

/dev/sdc3 on /sdc3 type xfs (rw,noatime,nodiratime,nobarrier,prjquota)
/sdc3/serverbackup on /serverbackup type none (rw,bind)
/sdc3/serverbackup_rootserver on /serverbackup_rootserver type none 
(rw,bind)

Stefan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

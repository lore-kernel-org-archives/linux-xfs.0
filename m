Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o9IKFTw8014451 for <xfs@oss.sgi.com>; Mon, 18 Oct 2010 15:15:29 -0500
Received: from greer.hardwarefreak.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 186C819378F4
	for <xfs@oss.sgi.com>; Mon, 18 Oct 2010 13:16:41 -0700 (PDT)
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id 6NwGWEew1qbbINq8
	for <xfs@oss.sgi.com>; Mon, 18 Oct 2010 13:16:41 -0700 (PDT)
Received: from [192.168.100.53] (gffx.hardwarefreak.com [192.168.100.53])
	by greer.hardwarefreak.com (Postfix) with ESMTP id BF8F86C0D8
	for <xfs@oss.sgi.com>; Mon, 18 Oct 2010 15:16:40 -0500 (CDT)
Message-ID: <4CBCAB28.90708@hardwarefreak.com>
Date: Mon, 18 Oct 2010 15:16:40 -0500
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: cannot defrag volume, fragmentation factor 21.73%
References: <4CBC3910.70806@cape-horn-eng.com>
In-Reply-To: <4CBC3910.70806@cape-horn-eng.com>
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

Richard Ems put forth on 10/18/2010 7:09 AM:

> I ran several times xfs_fsr, but the 21.73% factor stays there.
> There where some busy or modified files on which I started xfs_fsr later
> again, but this ones where small files and the 21.73% is still there.
> 
> Any ideas?

Yes.  The answer is in a thread in last month's archive:
http://oss.sgi.com/pipermail/xfs/2010-September/047003.html

Dave Chinner put forth on 9/11/2010 3:23 AM:

> xfs_db used buffered IO on the block device, which is not coherent
> with the filesystem. If you are using it on an active filesystem,
> then running "echo 1 > /proc/sys/vm/drop_caches" before you run
> xfs_db should make it read from disk at least once....


-- 
Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

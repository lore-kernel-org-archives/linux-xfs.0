Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id B30B97F37
	for <xfs@oss.sgi.com>; Thu, 19 Mar 2015 18:27:34 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 8E78E8F809C
	for <xfs@oss.sgi.com>; Thu, 19 Mar 2015 16:27:34 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	B5Z7mbnd6AxNs7An for <xfs@oss.sgi.com>;
	Thu, 19 Mar 2015 16:27:32 -0700 (PDT)
Date: Fri, 20 Mar 2015 10:18:54 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfs write performance issue
Message-ID: <20150319231854.GL10105@dastard>
References: <8976870.8vOdNBKrI1@xrated>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <8976870.8vOdNBKrI1@xrated>
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
To: Hans-Peter Jansen <hpj@urpla.net>
Cc: xfs@oss.sgi.com

On Thu, Mar 19, 2015 at 06:01:50PM +0100, Hans-Peter Jansen wrote:
> ~# LANG=C xfs_info /dev/sdc1
> meta-data=/dev/sdc1              isize=256    agcount=17, agsize=183105406 
> blks
>          =                       sectsz=512   attr=2, projid32bit=0
>          =                       crc=0        finobt=0
> data     =                       bsize=4096   blocks=2929687287, imaxpct=5
>          =                       sunit=0      swidth=0 blks
> naming   =version 2              bsize=4096   ascii-ci=0 ftype=0
> log      =Intern                 bsize=4096   blocks=32768, version=2
>          =                       sectsz=512   sunit=0 blks, lazy-count=1
> realtime =none                   extsz=4096   blocks=0, rtextents=0
....
> ~# LANG=C dd if=Django_Unchained.mp4 of=/dev/null bs=1M 
> 1305+1 records in
> 1305+1 records out
> 1369162196 bytes (1.4 GB) copied, 3.32714 s, 412 MB/s
> 
> Write performance is disastrous: it's about 1.5 MB/s.
> 
> ~# LANG=C dd if=Django_Unchained.mp4 of=xxx bs=1M 
> 482+0 records in
> 482+0 records out
> 505413632 bytes (505 MB) copied, 368.816 s, 1.4 MB/s

Why did it stop half way through? ENOSPC?

> 1083+0 records in
> 1083+0 records out
> 1135607808 bytes (1.1 GB) copied, 840.072 s, 1.4 MB/s

That's incomplete, too.

> The question is, what could explain these numbers. Bad alignment? Bad stripe 
> size? And what can I do to resolve this - without loosing all my data..

More than likely you've fragmented free space, and so writes
are small random write IO. Output of 'df -h' and:

$ xfs_db -r -c "freesp -s" <dev>

would be instructive.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

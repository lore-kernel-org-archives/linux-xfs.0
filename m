Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q14KHX0L239546 for <xfs@oss.sgi.com>; Sat, 4 Feb 2012 14:17:34 -0600
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 9OnUvT1jbNt52tlW for
	<xfs@oss.sgi.com>; Sat, 04 Feb 2012 12:17:32 -0800 (PST)
Message-ID: <4F2D925A.1070702@redhat.com>
Date: Sat, 04 Feb 2012 14:17:30 -0600
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: Re: sparsify - utility to punch out blocks of 0s in a file
References: <4F2D8F30.3090802@redhat.com> <4F2D90B6.4070008@redhat.com>
In-Reply-To: <4F2D90B6.4070008@redhat.com>
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
To: ext4 development <linux-ext4@vger.kernel.org>, xfs-oss <xfs@oss.sgi.com>

On 2/4/12 2:10 PM, Eric Sandeen wrote:

> Hm but something is weird, right after the punch-out xfs says
> it uses 84K:
> 
> [root@inode sparsify]# du -hc fsfile
> 84K	fsfile
> 84K	total
> 
> but then after an xfs_repair it looks saner:
> # du -hc fsfile
> 4.8M	fsfile
> 4.8M	total
> 
> something to look into I guess... weird.

nvm that's just xfs_repair zeroing the log & reinstating the blocks.
Sorry for the noise - Ok, back to my Saturday.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

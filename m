Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pA3965PU253331 for <xfs@oss.sgi.com>; Thu, 3 Nov 2011 04:06:05 -0500
Received: from song.cn.fujitsu.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 37ED31CDCBCD
	for <xfs@oss.sgi.com>; Thu,  3 Nov 2011 02:06:02 -0700 (PDT)
Received: from song.cn.fujitsu.com (cn.fujitsu.com [222.73.24.84]) by
	cuda.sgi.com with ESMTP id sRKMe4YLRaBMTvFu for
	<xfs@oss.sgi.com>; Thu, 03 Nov 2011 02:06:02 -0700 (PDT)
Message-ID: <4EB24B1B.2030304@cn.fujitsu.com>
Date: Thu, 03 Nov 2011 16:04:43 +0800
From: WuBo <wu.bo@cn.fujitsu.com>
MIME-Version: 1.0
Subject: Re: [PATCH 1/3] xfstests 264: add a copy and reserve test
References: <4EB20505.7070005@cn.fujitsu.com> <4EB205C7.6010906@cn.fujitsu.com>
	<20111103065525.GA6800@infradead.org>
In-Reply-To: <20111103065525.GA6800@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-fsdevel@vger.kernel.org, Linux Btrfs <linux-btrfs@vger.kernel.org>, xfs@oss.sgi.com

On 11/03/2011 02:55 PM, Christoph Hellwig wrote:
> On Thu, Nov 03, 2011 at 11:08:55AM +0800, WuBo wrote:
>> This test is a stress test. It creates a set of threads for coping small files 
>> into disk. I use a 2G disk for test, the ENOSPC arises usually but the disk is 
>> not full under kenerl 3.0 with intel64.
> 
> It seems like you really want to use _scratch_mkfs_sized instead of the
> btrfs-specific resize option and make the test generic.  Also we already
OK, thanks for _scratch_mkfs_sized, It's will make these tests generic.

> have used up these test numbers in the xfstests-dev repository, and I
> will commit another batch of tests today.
I will change my test numbers in next version.

thanks,
wubo

> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

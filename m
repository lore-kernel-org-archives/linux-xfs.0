Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pAG1UTEC102950 for <xfs@oss.sgi.com>; Tue, 15 Nov 2011 19:30:30 -0600
Received: from song.cn.fujitsu.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id F2C768D0B29
	for <xfs@oss.sgi.com>; Tue, 15 Nov 2011 17:30:28 -0800 (PST)
Received: from song.cn.fujitsu.com (cn.fujitsu.com [222.73.24.84]) by
	cuda.sgi.com with ESMTP id Pt0T6DSFhY7Gmg9D for
	<xfs@oss.sgi.com>; Tue, 15 Nov 2011 17:30:28 -0800 (PST)
Message-ID: <4EC31238.3080102@cn.fujitsu.com>
Date: Wed, 16 Nov 2011 09:30:32 +0800
From: WuBo <wu.bo@cn.fujitsu.com>
MIME-Version: 1.0
Subject: Re: [PATCH 2/3] xfstests 265: add a prealloc and reserve test
References: <4EB20505.7070005@cn.fujitsu.com> <4EB205CC.6010509@cn.fujitsu.com>
	<20111115182113.GD29840@sgi.com>
	<20111115190821.GA15331@infradead.org>
In-Reply-To: <20111115190821.GA15331@infradead.org>
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
Cc: linux-fsdevel@vger.kernel.org, Ben Myers <bpm@sgi.com>, Linux Btrfs <linux-btrfs@vger.kernel.org>, xfs@oss.sgi.com

On 11/16/2011 03:08 AM, Christoph Hellwig wrote:
> On Tue, Nov 15, 2011 at 12:21:13PM -0600, Ben Myers wrote:
>> Hi Wu Bo,
>>
>> On Thu, Nov 03, 2011 at 11:09:00AM +0800, WuBo wrote:
>>> This test is for preallocation test. If the disk is full, just with a prealloc
>>> file has some free space that prealloc early. We need to check whether the write
>>> to the free space is success or not.
>>>
>>> Signed-off-by: Wu Bo <Wu.Bo@cn.fujitsu.com>
>>
>> This test is failing for me because I don't have fallocate installed.  I
>> suggest the test could to be changed to check for binaries it uses,
>> possibly the version of those binaries, and then not run unless the
>> right ones are installed.  But the best I can do right now is make a
>> note of it.
> 
> It might be even better to just use the xfs_io falloc command as we
> generally expect an uptodate xfs_io for use with xfstests.

Got it.

thanks,
wubo

> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q5T1e1qE083715 for <xfs@oss.sgi.com>; Thu, 28 Jun 2012 20:40:01 -0500
Received: from song.cn.fujitsu.com (cn.fujitsu.com [222.73.24.84]) by
	cuda.sgi.com with ESMTP id TAh3B85o0Z3Qz0V5 for
	<xfs@oss.sgi.com>; Thu, 28 Jun 2012 18:39:59 -0700 (PDT)
Message-ID: <4FECFE26.2040506@cn.fujitsu.com>
Date: Fri, 29 Jun 2012 09:00:22 +0800
From: Wanlong Gao <gaowanlong@cn.fujitsu.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfs: cleanup the mount options
References: <1340816243-6177-1-git-send-email-gaowanlong@cn.fujitsu.com>
	<20120627174448.GA3278@infradead.org>
	<4FEBAB3B.6020707@cn.fujitsu.com>
	<20120628160156.GC29979@sgi.com> <4FEC8768.8000109@zabbo.net>
In-Reply-To: <4FEC8768.8000109@zabbo.net>
Reply-To: gaowanlong@cn.fujitsu.com
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
To: Zach Brown <zab@zabbo.net>
Cc: Christoph Hellwig <hch@infradead.org>, Ben Myers <bpm@sgi.com>, xfs@oss.sgi.com

On 06/29/2012 12:33 AM, Zach Brown wrote:
> 
>> It's not a strong objection from me, but I do have a preference for keeping the
>> XFS_MOUNT_ prefix to retain context for cscope and grep.  Maybe others feel
>> differently.
> 
> For what it's worth, I agree.  It's really annoying to have cscope
> lookups fail and have to go poking around for things manually.

If you know XFS code, you really needn't cscope lookups on these
easy enough mount options. Don't stick to cscope lookups all the time.
Anyway, omit use xfs_*_opt can make code looks more clearly.

Thanks,
Wanlong Gao


> 
> - z
> 


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

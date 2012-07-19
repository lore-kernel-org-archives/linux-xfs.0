Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q6J30dSp247636 for <xfs@oss.sgi.com>; Wed, 18 Jul 2012 22:00:39 -0500
Received: from acsinet15.oracle.com (acsinet15.oracle.com [141.146.126.227])
	by cuda.sgi.com with ESMTP id ElKZ07hBGiLTtB0F (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 18 Jul 2012 20:00:38 -0700 (PDT)
Message-ID: <50077819.5040406@oracle.com>
Date: Thu, 19 Jul 2012 10:59:37 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfs: Add readpage() check up for mmap file at
	xfs_file_mmap()
References: <5006CC80.3070208@oracle.com>
	<20120718151148.GA17374@infradead.org>
In-Reply-To: <20120718151148.GA17374@infradead.org>
Reply-To: jeff.liu@oracle.com
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
Cc: xfs@oss.sgi.com

On 07/18/2012 11:11 PM, Christoph Hellwig wrote:

> On Wed, Jul 18, 2012 at 10:47:28PM +0800, Jeff Liu wrote:
>> Hello,
>>
>> When studying XFS code, I found xfs_file_mmap() does not check whether a specific file has readpage() or not.
>> Actually, I have no idea of which kind of file does not supply page reading function, but Btrfs/Ext4
>> as well as generic_file_mmap() all do this check at first, do we also need a defense here?
> 
> It's not needed. In generic_file_mmap it might make a little sense as
> any filesystem could use it, but even there's it's questionable because
> ->readpage is the only way to actually supposed mmap when using
> generic_file_mmap.

Now I got it, thanks for the teaching.

Thanks,
-Jeff

> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o53NQRqi185201 for <xfs@oss.sgi.com>; Thu, 3 Jun 2010 18:26:27 -0500
Received: from Ishtar.sc.tlinx.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4CFC2395E57
	for <xfs@oss.sgi.com>; Thu,  3 Jun 2010 16:28:54 -0700 (PDT)
Received: from Ishtar.sc.tlinx.org (ishtar.tlinx.org [173.164.175.65]) by
	cuda.sgi.com with ESMTP id IuJ9T2zEEEBEZxmt for
	<xfs@oss.sgi.com>; Thu, 03 Jun 2010 16:28:54 -0700 (PDT)
Message-ID: <4C083AAD.80906@tlinx.org>
Date: Thu, 03 Jun 2010 16:28:45 -0700
From: "Linda A. Walsh" <xfs@tlinx.org>
MIME-Version: 1.0
Subject: Re: xfsdump -- not enough memory to dump attributes? w/>20G free	--
	how much does it need?
References: <4BF7D787.4020903@tlinx.org> <20100525164244.GB18666@infradead.org>
In-Reply-To: <20100525164244.GB18666@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs-oss <xfs@oss.sgi.com>

FWIF -- upgrading to the latest tool set seems to have caused
these messages to "go away"...


Christoph Hellwig wrote:
> On Sat, May 22, 2010 at 06:09:27AM -0700, Linda A. Walsh wrote:
>> I've seen the problem in the dump below and was wondering what could  
>> possibly cause this -- because
>> shows loads of free memory (>20G)...  how much memory do non-root  
>> attributes take to dump?
> 
> The error comes directly from the libhandle listing routine, which
> is a straight forward wrapper around the kernel syscall in current
> xfsprogs.
> 
> What xfsprogs version are you using?  I noticed your xfsdump is
> rather old, so making sure you have recent XFS userspace and
> possibly also the kernel would help debugging this.
> 
> Also can you check using strace if the ENOMEM comes directly from
> the attr_list_by_handle ioctl?
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

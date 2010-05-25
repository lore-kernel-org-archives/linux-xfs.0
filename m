Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o4PGeNHC012147 for <xfs@oss.sgi.com>; Tue, 25 May 2010 11:40:23 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7D4B51DFBBB5
	for <xfs@oss.sgi.com>; Tue, 25 May 2010 09:42:46 -0700 (PDT)
Received: from bombadil.infradead.org ([18.85.46.34]) by cuda.sgi.com with
	ESMTP id iDA1oyAB6OWerYhI for <xfs@oss.sgi.com>;
	Tue, 25 May 2010 09:42:46 -0700 (PDT)
Date: Tue, 25 May 2010 12:42:44 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: xfsdump -- not enough memory to dump attributes? w/>20G free
	-- how much does it need?
Message-ID: <20100525164244.GB18666@infradead.org>
References: <4BF7D787.4020903@tlinx.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4BF7D787.4020903@tlinx.org>
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
To: "Linda A. Walsh" <xfs@tlinx.org>
Cc: xfs-oss <xfs@oss.sgi.com>

On Sat, May 22, 2010 at 06:09:27AM -0700, Linda A. Walsh wrote:
> I've seen the problem in the dump below and was wondering what could  
> possibly cause this -- because
> shows loads of free memory (>20G)...  how much memory do non-root  
> attributes take to dump?

The error comes directly from the libhandle listing routine, which
is a straight forward wrapper around the kernel syscall in current
xfsprogs.

What xfsprogs version are you using?  I noticed your xfsdump is
rather old, so making sure you have recent XFS userspace and
possibly also the kernel would help debugging this.

Also can you check using strace if the ENOMEM comes directly from
the attr_list_by_handle ioctl?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

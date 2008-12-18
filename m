Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mBIL1isO018061 for <xfs@oss.sgi.com>; Thu, 18 Dec 2008 15:01:44 -0600
Received: from ag-out-0708.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id EB695324AC
	for <xfs@oss.sgi.com>; Thu, 18 Dec 2008 13:01:42 -0800 (PST)
Received: from ag-out-0708.google.com (ag-out-0708.google.com [72.14.246.249])
	by cuda.sgi.com with ESMTP id RiCOYGy34IoWl61j for
	<xfs@oss.sgi.com>; Thu, 18 Dec 2008 13:01:42 -0800 (PST)
Received: by ag-out-0708.google.com with SMTP id 31so426926agc.5
	for <xfs@oss.sgi.com>; Thu, 18 Dec 2008 13:01:42 -0800 (PST)
Message-ID: <494ABA11.2050205@ankitjain.org>
Date: Fri, 19 Dec 2008 02:31:05 +0530
From: Ankit Jain <me@ankitjain.org>
MIME-Version: 1.0
Subject: Re: [PATCH][RFC] fs: Add new pre-allocation ioctls to vfs for
	compatibility with legacy xfs ioctls
References: <49460F88.2080408@ankitjain.org>
	<20081217202815.GE8791@wotan.suse.de>
In-Reply-To: <20081217202815.GE8791@wotan.suse.de>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
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
To: Mark Fasheh <mfasheh@suse.com>
Cc: linux-kernel@vger.kernel.org, joel.becker@oracle.com, Christoph Hellwig <hch@infradead.org>, xfs-masters@oss.sgi.com, Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com, ocfs2-devel@oss.oracle.com

Mark Fasheh wrote:
> On Mon, Dec 15, 2008 at 01:34:24PM +0530, Ankit Jain wrote:
>> 2. Should the corresponding ioctls be removed from ocfs2?
> 
> Well, a small amount of the code in fs/ocfs2/ioctl.c can certainly go away.
> Shouldn't we be talking about doing the same for xfs too?

Reading the code a bit, my understanding is that as compat_ioctl is also
supported and that just delegates to ioctl (ocfs2_ioctl), so we can't
remove the *_RESVSP* handling.
Same goes for xfs also.

Does that sound fair or did I not understand it correctly?

-Ankit

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

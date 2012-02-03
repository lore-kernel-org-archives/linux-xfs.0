Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q13GAkVq140299 for <xfs@oss.sgi.com>; Fri, 3 Feb 2012 10:10:47 -0600
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id zGZbP8N92wymCmyD for
	<xfs@oss.sgi.com>; Fri, 03 Feb 2012 08:10:45 -0800 (PST)
Message-ID: <4F2C0700.2030306@redhat.com>
Date: Fri, 03 Feb 2012 10:10:40 -0600
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfs_io: deprecate the "-F" foreign flag
References: <4F2AC948.1050909@redhat.com>
	<20120203150443.GA28301@infradead.org>
In-Reply-To: <20120203150443.GA28301@infradead.org>
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
Cc: xfs-oss <xfs@oss.sgi.com>

On 2/3/12 9:04 AM, Christoph Hellwig wrote:
> On Thu, Feb 02, 2012 at 11:35:04AM -0600, Eric Sandeen wrote:
>> There's no real reason to force the user to specify "-F" for non-xfs
>> files, when we can just test for that after it's opened.
>>
>> * Remove the -F flag from usage() & man pages, but still accept it.
>> * Set IO_FOREIGN when we open the file, if the fd tests as non-xfs.
> 
> Looks good. We probably should kill the IO_FOREIGN eventually too, but
> let's do the user facing part first.

How would you want to handle non-xfs filesystems in the xfs-specific
commands?  Do the fd test each time?
 
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>


Thanks, I'll merge it.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

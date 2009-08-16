Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n7GD0pT7252209 for <xfs@oss.sgi.com>; Sun, 16 Aug 2009 08:01:02 -0500
Received: from mail.rtr.ca (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id CC8C93D3B82
	for <xfs@oss.sgi.com>; Sun, 16 Aug 2009 06:01:08 -0700 (PDT)
Received: from mail.rtr.ca (rtr.ca [76.10.145.34]) by cuda.sgi.com with ESMTP
	id LByjjo7t2TjCNJzb for <xfs@oss.sgi.com>;
	Sun, 16 Aug 2009 06:01:08 -0700 (PDT)
Message-ID: <4A8802F3.6010908@rtr.ca>
Date: Sun, 16 Aug 2009 09:00:35 -0400
From: Mark Lord <liml@rtr.ca>
MIME-Version: 1.0
Subject: Re: [PATCH, RFC] xfs: batched discard support
References: <20090816004705.GA7347@infradead.org> <4A876255.10606@rtr.ca>
	<4A876CA9.20906@rtr.ca> <20090816022500.GA12392@infradead.org>
In-Reply-To: <20090816022500.GA12392@infradead.org>
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
Cc: linux-fsdevel@vger.kernel.org, jens.axboe@oracle.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, xfs@oss.sgi.com

Christoph Hellwig wrote:
> On Sat, Aug 15, 2009 at 10:19:21PM -0400, Mark Lord wrote:
>> Mark Lord wrote:
>>> Christoph Hellwig wrote:
>> ..
>>>> Mark, any chance to try it?  Just create an XFS filesystem, age it a
>>>> bit and then call the attached little trim.c program on the mountmoint
>>>> (or any file inside the filesystem for that matter)
>>> ..
>>>
>>> Looking at it now.  Thanks, Christoph!
>> ..
>>
>> Fails to work on 64-bit kernel w/ 32-bit userspace (no compat ioctl).
>> Rebuilding with 32-bit kernel now..
> 
> The actual ioctl is compatible, just add the
> 
> 	case XFS_IOC_TRIM:
> 		return xfs_ioc_trim(mp, arg);
> 
> to xfs_file_compat_ioctl().  I'll add this to the next spin of the patch.
..

Okay, this gives me ENOSYS now --> discard/trim support is missing from
the lower layers.

What other patches do I need to make this work?

The latest from Matthew's discard tree (May 2009) don't appear to be sufficient,
even after updating them for 2.6.31-rc6.

???

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

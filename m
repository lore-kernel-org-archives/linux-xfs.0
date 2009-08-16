Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n7G2nmIr221309 for <xfs@oss.sgi.com>; Sat, 15 Aug 2009 21:49:58 -0500
Received: from mail.rtr.ca (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C8EB61D598CC
	for <xfs@oss.sgi.com>; Sat, 15 Aug 2009 19:50:15 -0700 (PDT)
Received: from mail.rtr.ca (rtr.ca [76.10.145.34]) by cuda.sgi.com with ESMTP
	id VDHFTGv5pskiffNU for <xfs@oss.sgi.com>;
	Sat, 15 Aug 2009 19:50:15 -0700 (PDT)
Message-ID: <4A8773C4.6030409@rtr.ca>
Date: Sat, 15 Aug 2009 22:49:40 -0400
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

Peachy.  Rebuilding again now..

Don't wait up for this .. I'll finish it on Sunday.  Bedtime.  :)

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

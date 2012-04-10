Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q3AHHZca185895 for <xfs@oss.sgi.com>; Tue, 10 Apr 2012 12:17:36 -0500
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 8B6JzNWkOHL0jXyc for
	<xfs@oss.sgi.com>; Tue, 10 Apr 2012 10:17:34 -0700 (PDT)
Message-ID: <4F845242.1070300@redhat.com>
Date: Tue, 10 Apr 2012 10:31:14 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: Re: [PATCH] set freed perag structures to NULL to avoid mount failure
	oops
References: <4F7DF263.6060802@redhat.com> <20120410071204.GO18323@dastard>
In-Reply-To: <20120410071204.GO18323@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs-oss <xfs@oss.sgi.com>

On 4/10/12 2:12 AM, Dave Chinner wrote:
> On Thu, Apr 05, 2012 at 12:28:35PM -0700, Eric Sandeen wrote:

...

>>  	kmem_free(pag);
>> +	pag = NULL;
>>  }
> 
> As it is, I don't quite understand what setting a local variable to
> NULL is supposed to acheive here - the perag structure has been
> removed from the radix tree and zeroing a local variable doesn't do
> anything globally visible...

er, right.  Ok.

> What is more likely is that the log mount failure path is not
> flushing the buftarg correctly before tearing down the perag
> structures. Indeed, a log mount failure (and a perag data
> intialisation failure) will simply tear down the perag structures
> without waiting for cached buffers to be flushed in xfs_mountfs(),
> so that is going to the root cause of this problem. i.e. we need
> xfs_flush_buftarg() calls in the mountfs error handling path....

Ok, makes sense.

-Eric

> Cheers,
> 
> Dave.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

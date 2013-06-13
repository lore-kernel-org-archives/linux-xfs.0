Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id EAC9F7F56
	for <xfs@oss.sgi.com>; Wed, 12 Jun 2013 19:48:46 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id D98A38F8049
	for <xfs@oss.sgi.com>; Wed, 12 Jun 2013 17:48:43 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	IoaAPGMcj5to1m7g for <xfs@oss.sgi.com>;
	Wed, 12 Jun 2013 17:48:42 -0700 (PDT)
Date: Thu, 13 Jun 2013 10:48:40 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Questions about XFS
Message-ID: <20130613004840.GZ29338@dastard>
References: <loom.20130611T112155-970@post.gmane.org>
	<51B72D3D.5010206@redhat.com>
	<CAO9HMNGjdikgX+_434aGVJ2NAJ0hxDNLo+Vsa46GH3psXr4sKQ@mail.gmail.com>
	<1371025611.7096.10.camel@acme>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1371025611.7096.10.camel@acme>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Roger Oberholtzer <roger@opq.se>
Cc: xfs@oss.sgi.com

On Wed, Jun 12, 2013 at 10:26:51AM +0200, Roger Oberholtzer wrote:
> On Tue, 2013-06-11 at 11:12 -0500, Steve Bergman wrote: 
> > Are you saying that with XFS there is no periodic
> > flushing mechanism at all? And that unless there's an
> > fsync/fdatasync/sync or the memory needs to be reclaimed, that it can
> > sit in the page cache forever?
> 
> I read the later responses to this and they seemed to say that the data
> in the page cache should be written to the disk periodically. I am not
> meaning to hijack the thread. I just have a question directly related to
> this point.
> 
> I have an application that is streaming data to an XFS disk at a
> sustained 25 MB/sec. This is well below what the hardware supports. The
> application does fopen/fwrite/fclose (no active flushing or syncing).

fadvise(DONTNEED)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

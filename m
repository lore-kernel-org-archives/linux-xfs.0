Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q8QNxja9011735 for <xfs@oss.sgi.com>; Wed, 26 Sep 2012 18:59:45 -0500
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	AoY6wvjwEjpqMEFq for <xfs@oss.sgi.com>;
	Wed, 26 Sep 2012 17:01:03 -0700 (PDT)
Date: Thu, 27 Sep 2012 10:01:01 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfsprog: remove duplicate vector memalign from xfs_io
Message-ID: <20120927000101.GB15236@dastard>
References: <20120925142414.660506845@sgi.com>
	<20120925142421.398175185@sgi.com> <20120926220434.GG13214@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120926220434.GG13214@sgi.com>
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
To: Ben Myers <bpm@sgi.com>
Cc: Mark Tinguely <tinguely@sgi.com>, xfs@oss.sgi.com

On Wed, Sep 26, 2012 at 05:04:34PM -0500, Ben Myers wrote:
> On Tue, Sep 25, 2012 at 09:24:15AM -0500, Mark Tinguely wrote:
> > The vector feature of xfs_io uses its own memory buffer in the iov structure
> > and does not use the buffer entry. Remove the duplicate memalign.
> 
> Looks to me that there is a usage of buffer in __dump_buffer.  However,
> I suspect there shouldn't be.  I suggest (untested,ymmv,ianal,etc):
> 
> :!quilt di
> Index: xfsprogs/io/pread.c
> ===================================================================
> --- xfsprogs.orig/io/pread.c
> +++ xfsprogs/io/pread.c
> @@ -130,7 +130,7 @@ __dump_buffer(
>         int             i, j;
>         char            *p;
>  
> -       for (i = 0, p = (char *)buffer; i < len; i += 16) {
> +       for (i = 0, p = (char *)buf; i < len; i += 16) {
>                 char    *s = p;
>  
>                 printf("%08llx:  ", (unsigned long long)offset + i);

Can you post that as a proper patch?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 797CE7F75
	for <xfs@oss.sgi.com>; Thu, 11 Sep 2014 10:20:21 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 4ABE78F8033
	for <xfs@oss.sgi.com>; Thu, 11 Sep 2014 08:20:18 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id BNzBbiL5CUDIz561 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 11 Sep 2014 08:20:17 -0700 (PDT)
Date: Thu, 11 Sep 2014 11:20:13 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH v2 0/5] clean up collapse range and handle post-eof
	delalloc
Message-ID: <20140911152012.GB54638@bfoster.bfoster>
References: <1410355231-50495-1-git-send-email-bfoster@redhat.com>
	<20140911044243.GA10111@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140911044243.GA10111@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Thu, Sep 11, 2014 at 02:42:43PM +1000, Dave Chinner wrote:
> On Wed, Sep 10, 2014 at 09:20:26AM -0400, Brian Foster wrote:
> > Hi all,
> > 
> > Here's v2 of the collapse clean up. We refactor a bit more via the
> > insertion of patch 3, otherwise it's similar to v1. This will see some
> > continued testing, but it survived ~500m fsx operations overnight.
> > 
> > Brian
> 
> I'm not sure about the invalidation patch now. On a 1k block size
> filesystem, generic/127 fails with:
> 
>     +ltp/fsx -q -l 262144 -o 65536 -S 191110531 -N 100000 -R -W fsx_std_nommap
>     +collapse range: 1000 to 3000
>     +do_collapse_range: fallocate: Device or resource busy
> 
> which indicates we had an invalidation failure. This is probably
> exposing some other bug, but I haven't had time to look into it yet
> so I don't know.
> 

Yeah, I can reproduce this as well, thanks. I think you're referring to
the xfs_free_file_space() patch (5/5)..? FWIW, I don't see the problem
without that patch, so it appears that the full pagecache truncate is
still covering up a problem somewhere. I'll try to dig into it...

Brian

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

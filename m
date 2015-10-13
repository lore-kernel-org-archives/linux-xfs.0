Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 6816D7F37
	for <xfs@oss.sgi.com>; Tue, 13 Oct 2015 16:25:14 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 489548F8035
	for <xfs@oss.sgi.com>; Tue, 13 Oct 2015 14:25:11 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	V0EwK5M923uOGNy4 for <xfs@oss.sgi.com>;
	Tue, 13 Oct 2015 14:25:09 -0700 (PDT)
Date: Wed, 14 Oct 2015 08:24:54 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: randconfig build error with next-20151013, in
	fs/xfs/libxfs/xfs_alloc.c
Message-ID: <20151013212454.GJ31326@dastard>
References: <CA+r1Zhg0y-47JuzOMANcXykyU=No-TEBksLnnT-g0OsTKwazRQ@mail.gmail.com>
	<20151013204119.GI31326@dastard>
	<CA+r1ZhiKiVja7vm5F-mmtq3xVm4gufGW1fFuF6FD7RpU17T6PA@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CA+r1ZhiKiVja7vm5F-mmtq3xVm4gufGW1fFuF6FD7RpU17T6PA@mail.gmail.com>
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
To: Jim Davis <jim.epost@gmail.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next <linux-next@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com

On Tue, Oct 13, 2015 at 02:08:28PM -0700, Jim Davis wrote:
> On Tue, Oct 13, 2015 at 1:41 PM, Dave Chinner <david@fromorbit.com> wrote:
> > On Tue, Oct 13, 2015 at 09:41:25AM -0700, Jim Davis wrote:
> >> Building with the attached random configuration file,
> >>
> >> fs/built-in.o: In function `xfs_free_ag_extent':
> >> /home/jim/linux-next/fs/xfs/libxfs/xfs_alloc.c:1813: undefined
> >> reference to `xfsstats'
> >
> > Please test the patch below.
> 
> Looks good!  Thanks.
> 
> Tested-by: Jim Davis <jim.epost@gmail.com>

Thanks for testing it quickly, Jim.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

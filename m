Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 628387CA0
	for <xfs@oss.sgi.com>; Mon, 22 Aug 2016 14:17:50 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 33AF4304032
	for <xfs@oss.sgi.com>; Mon, 22 Aug 2016 12:17:47 -0700 (PDT)
Received: from mout02.posteo.de (mout02.posteo.de [185.67.36.66]) by
	cuda.sgi.com with ESMTP id CkV5kLbM59MuqLwP (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 22 Aug 2016 12:17:44 -0700 (PDT)
Received: from submission (posteo.de [89.146.220.130])
	by mout02.posteo.de (Postfix) with ESMTPS id 77B6620ADC
	for <xfs@oss.sgi.com>; Mon, 22 Aug 2016 21:17:42 +0200 (CEST)
Date: Mon, 22 Aug 2016 21:16:03 +0200
From: Felix Janda <felix.janda@posteo.de>
Subject: Re: [PATCHv2 xfsprogs 00/14] Convert from off64_t to off_t
Message-ID: <20160822191603.GA3227@nyan>
References: <cover.1471107858.git.felix.janda@posteo.de>
	<20160822030953.GS19025@dastard> <20160822070601.GA1205@nyan>
	<20160822115101.GV19025@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160822115101.GV19025@dastard>
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

Dave Chinner wrote:
> On Mon, Aug 22, 2016 at 09:06:01AM +0200, Felix Janda wrote:
> > Dave Chinner wrote:
> > > Felix, can you check how you are sending these patches? The last two
> > > sets of patches you've sent have not threaded in the correct order
> > > (they thread in a random order) which means I have to manually
> > > reorder the patch set to get it to apply in the correct order via
> > > git am....
> > 
> > I am sorry for that. Should I resend the patch series?
> 
> No, I've re-ordered it appropriately.

Ok. Anyway thanks for drawing my attention to the ordering issues. (I
was not quite aware that git am does not take the patch numbers in the
subject into account.)

Felix

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

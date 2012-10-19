Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q9JEahnw261593 for <xfs@oss.sgi.com>; Fri, 19 Oct 2012 09:36:43 -0500
Received: from e06smtp10.uk.ibm.com (e06smtp10.uk.ibm.com [195.75.94.106]) by
	cuda.sgi.com with ESMTP id C4YpqUgSPGH8NNe0 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 19 Oct 2012 07:38:21 -0700 (PDT)
Received: from /spool/local
	by e06smtp10.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use
	Only! Violators will be prosecuted
	for <xfs@oss.sgi.com> from <schwidefsky@de.ibm.com>;
	Fri, 19 Oct 2012 15:38:19 +0100
Received: from d06av06.portsmouth.uk.ibm.com (d06av06.portsmouth.uk.ibm.com
	[9.149.37.217])
	by b06cxnps4076.portsmouth.uk.ibm.com (8.13.8/8.13.8/NCO v10.0) with
	ESMTP id q9JEcAeI50331708
	for <xfs@oss.sgi.com>; Fri, 19 Oct 2012 14:38:10 GMT
Received: from d06av06.portsmouth.uk.ibm.com (loopback [127.0.0.1])
	by d06av06.portsmouth.uk.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with
	ESMTP id q9JEcGgk018122
	for <xfs@oss.sgi.com>; Fri, 19 Oct 2012 08:38:16 -0600
Date: Fri, 19 Oct 2012 16:38:14 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: Re: [PATCH] mm: Fix XFS oops due to dirty pages without buffers on
	s390
Message-ID: <20121019163814.55b3590e@mschwide>
In-Reply-To: <alpine.LSU.2.00.1210091600450.30446@eggly.anvils>
References: <1349108796-32161-1-git-send-email-jack@suse.cz>
	<alpine.LSU.2.00.1210082029190.2237@eggly.anvils>
	<20121009101822.79bdcb65@mschwide>
	<alpine.LSU.2.00.1210091600450.30446@eggly.anvils>
Mime-Version: 1.0
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
To: Hugh Dickins <hughd@google.com>
Cc: linux-s390@vger.kernel.org, Jan Kara <jack@suse.cz>, LKML <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com, linux-mm@kvack.org, Mel Gorman <mgorman@suse.de>

On Tue, 9 Oct 2012 16:21:24 -0700 (PDT)
Hugh Dickins <hughd@google.com> wrote:

> > 
> > I am seriously tempted to switch to pure software dirty bits by using
> > page protection for writable but clean pages. The worry is the number of
> > additional protection faults we would get. But as we do software dirty
> > bit tracking for the most part anyway this might not be as bad as it
> > used to be.  
> 
> That's exactly the same reason why tmpfs opts out of dirty tracking, fear
> of unnecessary extra faults.  Anomalous as s390 is here, tmpfs is being
> anomalous too, and I'd be a hypocrite to push for you to make that change.

I tested the waters with the software dirty bit idea. Using kernel compile
as test case I got these numbers:

disk backing, swdirty: 10,023,870 minor-faults 18 major-faults
disk backing, hwdirty: 10,023,829 minor-faults 21 major-faults                          

tmpfs backing, swdirty: 10,019,552 minor-faults 49 major-faults
tmpfs backing, hwdirty: 10,032,909 minor-faults 81 major-faults

That does not look bad at all. One test I found that shows an effect is
lat_mmap from LMBench:

disk backing, hwdirty: 30,894 minor-faults 0 major-faults
disk backing, swdirty: 30,894 minor-faults 0 major-faults

tmpfs backing, hwdirty: 22,574 minor-faults 0 major-faults
tmpfs backing, swdirty: 36,652 minor-faults 0 major-faults 

The runtime between the hwdirty vs. the swdirty setup is very similar,
encouraging enough for me to ask our performance team to run a larger test.

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

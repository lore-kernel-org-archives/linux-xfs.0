Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q9B7fa86062895 for <xfs@oss.sgi.com>; Thu, 11 Oct 2012 02:41:36 -0500
Received: from e06smtp12.uk.ibm.com (e06smtp12.uk.ibm.com [195.75.94.108]) by
	cuda.sgi.com with ESMTP id tFbIsUHEZ8Edow94 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 11 Oct 2012 00:43:07 -0700 (PDT)
Received: from /spool/local
	by e06smtp12.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use
	Only! Violators will be prosecuted
	for <xfs@oss.sgi.com> from <schwidefsky@de.ibm.com>;
	Thu, 11 Oct 2012 08:43:05 +0100
Received: from d06av04.portsmouth.uk.ibm.com (d06av04.portsmouth.uk.ibm.com
	[9.149.37.216])
	by b06cxnps3075.portsmouth.uk.ibm.com (8.13.8/8.13.8/NCO v10.0) with
	ESMTP id q9B7grw138010958
	for <xfs@oss.sgi.com>; Thu, 11 Oct 2012 07:42:53 GMT
Received: from d06av04.portsmouth.uk.ibm.com (loopback [127.0.0.1])
	by d06av04.portsmouth.uk.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with
	ESMTP id q9B7gxuZ007078
	for <xfs@oss.sgi.com>; Thu, 11 Oct 2012 01:43:00 -0600
Date: Thu, 11 Oct 2012 09:42:57 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: Re: [PATCH] mm: Fix XFS oops due to dirty pages without buffers on
	s390
Message-ID: <20121011094257.61a9a460@mschwide>
In-Reply-To: <alpine.LSU.2.00.1210101402310.1939@eggly.anvils>
References: <1349108796-32161-1-git-send-email-jack@suse.cz>
	<alpine.LSU.2.00.1210082029190.2237@eggly.anvils>
	<20121009162107.GE15790@quack.suse.cz>
	<alpine.LSU.2.00.1210091824390.30802@eggly.anvils>
	<20121010085524.GA32581@quack.suse.cz>
	<alpine.LSU.2.00.1210101402310.1939@eggly.anvils>
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

On Wed, 10 Oct 2012 14:28:32 -0700 (PDT)
Hugh Dickins <hughd@google.com> wrote:

> But perhaps these machines aren't much into heavy swapping.  Now, 
> if Martin would send me a nice little zSeries netbook for Xmas,
> I could then test that end of it myself ;)

Are you sure about that? The electricity cost alone for such a beast
is quite high ;-)

> I've just arrived at the conclusion that page migration does _not_
> have a problem with transferring the dirty storage key: I had been
> thinking that your testing might stumble on that issue, and need a
> further patch, but I'll explain in other mail why now I think not.

That is good to know, one problem less on the list.

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 506657F3F
	for <xfs@oss.sgi.com>; Fri,  6 Dec 2013 13:36:00 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 2CA9C304048
	for <xfs@oss.sgi.com>; Fri,  6 Dec 2013 11:35:57 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.9])
	by cuda.sgi.com with ESMTP id wAiqYeBGpNuDTdrB (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 06 Dec 2013 11:35:55 -0800 (PST)
Date: Fri, 6 Dec 2013 11:35:53 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [OOPS, 3.13-rc2] null ptr in dio_complete()
Message-ID: <20131206193553.GA23395@infradead.org>
References: <20131203215940.GX10988@dastard> <20131204015837.GJ10988@dastard>
	<20131205222220.5d7f4a48@tom-ThinkPad-T410>
	<20131205212651.GP10988@dastard> <20131205231612.GQ10988@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131205231612.GQ10988@dastard>
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

On Fri, Dec 06, 2013 at 10:16:12AM +1100, Dave Chinner wrote:
> Ok, this looks like it is working correctly. The read/write io stats
> are now working properly, too. Thanks for finding the problem
> quickly!

Btw, I've hit it a few times as well now after the XFS tree got rebased.

Maybe we should move the tree forward to -rc3 ASAP?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

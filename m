Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 559717CBF
	for <xfs@oss.sgi.com>; Sun, 10 Mar 2013 17:11:53 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 41B8A8F8035
	for <xfs@oss.sgi.com>; Sun, 10 Mar 2013 15:11:50 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	P2Wt8OTRbFORYiU0 for <xfs@oss.sgi.com>;
	Sun, 10 Mar 2013 15:11:48 -0700 (PDT)
Date: Mon, 11 Mar 2013 09:11:45 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS filesystem corruption
Message-ID: <20130310221145.GJ23616@dastard>
References: <CAPcwv6wZJSBtgF-L6KNSn6N6Y+wUZJFXdbcg+zYRwoaB2sDdjw@mail.gmail.com>
	<51380FD3.5010302@hardwarefreak.com>
	<CAPcwv6yAHAsmwgROs12gRtCbqTXBvTPrx8F-e4kYab2YApsobg@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAPcwv6yAHAsmwgROs12gRtCbqTXBvTPrx8F-e4kYab2YApsobg@mail.gmail.com>
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
To: Julien FERRERO <jferrero06@gmail.com>
Cc: stan@hardwarefreak.com, xfs@oss.sgi.com

On Thu, Mar 07, 2013 at 02:04:32PM +0100, Julien FERRERO wrote:
> > It may be unrelated to your corruption, problem but I'm curious why you
> > are specifying a 32MB log section instead of letting mkfs.xfs make the
> > log size decision.
> 
> I honestly don' know, the rebuild script was written 8 years ago by an
> engineer that since left the company.
> 
> Is 32MB a short log space for a 1.5 TB of data ?

Depends on your workload.

And to tell the truth, the tiny log is probably the only reason that
your filesystems have gone this long without corruption, as the
small size will force frequent log writes and hence issue cache
flushes regularly....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

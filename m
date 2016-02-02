Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 586C77CB1
	for <xfs@oss.sgi.com>; Tue,  2 Feb 2016 10:42:44 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id D65B2AC007
	for <xfs@oss.sgi.com>; Tue,  2 Feb 2016 08:42:40 -0800 (PST)
Received: from newverein.lst.de (verein.lst.de [213.95.11.211]) by
	cuda.sgi.com with ESMTP id HyQtwyWoTbtDqajh (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 02 Feb 2016 08:42:38 -0800 (PST)
Date: Tue, 2 Feb 2016 17:42:37 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: Re: stop using ioends for direct write completions
Message-ID: <20160202164237.GA25436@lst.de>
References: <1452766237-2314-1-git-send-email-hch@lst.de>
	<20160128131656.GB14876@infradead.org>
	<20160129141232.GA43184@bfoster.bfoster>
	<20160202112046.GB28777@lst.de>
	<20160202153117.GB1853@bfoster.bfoster>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160202153117.GB1853@bfoster.bfoster>
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
To: Brian Foster <bfoster@redhat.com>
Cc: darrick.wong@oracle.com, xfs@oss.sgi.com

On Tue, Feb 02, 2016 at 10:31:18AM -0500, Brian Foster wrote:
> FWIW, I don't see any such review comments against the three versions of
> the "DIO needs an ioend for writes" patch I have in my mailbox, but I
> easily could have missed something..? But if there wasn't time, then
> fair enough.

I'll have to look at the mailboxes, but I remember Dave sending this
out and complaining.

> I'm just looking for context. I don't have much of an opinion on which
> approach is used here. If it simplifies COW, then that seems good enough
> reason to me to take this approach. I'm pointing this out more because
> this code seems to have been rewritten the last couple of times we
> needed to fix something, which makes backports particularly annoying.
> The two patches above were associated with a broader enhancement and a
> bug fix (respectively) as a sort of justification, whereas this post had
> a much more vague purpose from what I could tell, and therefore why I at
> least hadn't taken the time to review it.
> 
> If COW is the primary motivator, perhaps we can bundle it with that
> work?

The prime motivator is to:

 (1) avoid a pointless memory allocation
 (2) avoid a pointless context switch
 (3) avoid pointless code complexity

COW is just another case where these show up.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

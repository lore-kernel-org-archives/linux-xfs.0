Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 538517F51
	for <xfs@oss.sgi.com>; Fri,  9 May 2014 02:21:58 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 59E158F8039
	for <xfs@oss.sgi.com>; Fri,  9 May 2014 00:21:55 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.9])
	by cuda.sgi.com with ESMTP id F7tarbTOoKd7MBZs (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 09 May 2014 00:21:53 -0700 (PDT)
Date: Fri, 9 May 2014 00:21:51 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFC] libxfs kernel infrastructure (was [XFS updates] XFS
	development tree branch, xfs-libxfs-in-kernel-RFC, created.
	xfs-for-linus-3.15-rc2-52-g6579dd8)
Message-ID: <20140509072151.GA7635@infradead.org>
References: <20140506071855.F152E7FBC@oss.sgi.com>
	<20140506075905.GA5421@dastard>
	<20140507144822.GA4061@bfoster.bfoster>
	<20140507224755.GR5421@dastard> <20140508011256.GS5421@dastard>
	<20140508120228.GA47272@bfoster.bfoster>
	<20140508125405.GA8096@infradead.org>
	<20140508134520.GC47272@bfoster.bfoster>
	<20140508212120.GE26353@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140508212120.GE26353@dastard>
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
Cc: Christoph Hellwig <hch@infradead.org>, Brian Foster <bfoster@redhat.com>, xfs@oss.sgi.com

On Fri, May 09, 2014 at 07:21:20AM +1000, Dave Chinner wrote:
> I haven't looked at that, but I'm assuming that it is just a
> 
> -include libxfs/Makefile
> 
> directive rather than using:
> 
> obj-y += libxfs/
> 
> If that's all it takes, then I'll rebase the patch on that....


The -include line could work, but I'd rather do it like we did in
the old days and have a single makefile.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

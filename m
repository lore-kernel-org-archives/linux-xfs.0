Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id DA8DD29E05
	for <xfs@oss.sgi.com>; Tue,  8 Mar 2016 01:02:13 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id A978D8F8035
	for <xfs@oss.sgi.com>; Mon,  7 Mar 2016 23:02:10 -0800 (PST)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id DjLp6OKqAzYccRTA (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 07 Mar 2016 23:02:09 -0800 (PST)
Date: Mon, 7 Mar 2016 23:02:08 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 6/6] xfs: pad xfs_attr_leaf_name_remote to avoid tripping
	on m68k
Message-ID: <20160308070208.GB30440@infradead.org>
References: <1457300990-18300-1-git-send-email-david@fromorbit.com>
	<1457300990-18300-7-git-send-email-david@fromorbit.com>
	<20160307162858.GE19784@infradead.org>
	<20160308035648.GV30721@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160308035648.GV30721@dastard>
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
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Tue, Mar 08, 2016 at 02:56:48PM +1100, Dave Chinner wrote:
> > I think using a small fixed size array as a variable sized array
> > is not a good idea, especially with increasinly "smart" optimizing
> > compilers.  I'd rather take this structure out the size checking,
> > and then move it to a C99 VLA instead of the size 1 hack in the long
> > run.
> 
> I don't have the time right now to do this, so I'm just going to
> drop it - I'd guess the overlap between m68k and XFS users is so
> close to zero that it just doesn't matter.  I'll just drop this
> patch for now.

I'll send you a patch for it.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 616EB7F3F
	for <xfs@oss.sgi.com>; Tue, 11 Mar 2014 11:48:25 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 56DE88F807A
	for <xfs@oss.sgi.com>; Tue, 11 Mar 2014 09:48:22 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.9])
	by cuda.sgi.com with ESMTP id WyL0D1yb6wrx3YwT (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 11 Mar 2014 09:48:20 -0700 (PDT)
Date: Tue, 11 Mar 2014 09:48:16 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Multi-CPU harmless lockdep on x86 while copying data
Message-ID: <20140311164816.GA15676@infradead.org>
References: <531BD8B9.1090400@gmail.com> <20140310025523.GV6851@dastard>
	<20140310103716.GA1431@infradead.org>
	<20140310111253.GA4801@infradead.org>
	<20140310205118.GX6851@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140310205118.GX6851@dastard>
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
Cc: "Michael L. Semon" <mlsemon35@gmail.com>, xfs-oss <xfs@oss.sgi.com>

On Tue, Mar 11, 2014 at 07:51:18AM +1100, Dave Chinner wrote:
> Yeah, b) seems like the way to simplify it - the filestreams code
> really only needs to track the parent/ag relationship rather than
> the child/parent relationship if there is a reliable way of
> determining the parent from the child.
> 
> What do we do with hardlinked files in this case? I'm happy to say
> "too bad" for these files mainly because the filestream allocator is
> aimed at associating multiple file creations together, so hard links
> really don't matter AFAICT...

We could flatly refuse filesystems for files with i_nlink > 1, or just
grab the first parent we get at.  Refusing seems like the better
alternative to me.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

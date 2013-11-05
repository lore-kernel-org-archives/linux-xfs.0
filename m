Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id ED26D7F8E
	for <xfs@oss.sgi.com>; Tue,  5 Nov 2013 03:05:47 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 9416FAC002
	for <xfs@oss.sgi.com>; Tue,  5 Nov 2013 01:05:44 -0800 (PST)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id jParny7Dlob6bG72 (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 05 Nov 2013 01:05:38 -0800 (PST)
Date: Tue, 5 Nov 2013 01:05:38 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 25/30 V2] libxfs: fix root inode handling inconsistencies
Message-ID: <20131105090538.GA6114@infradead.org>
References: <1383107481-28937-1-git-send-email-david@fromorbit.com>
	<1383107481-28937-26-git-send-email-david@fromorbit.com>
	<20131030102318.GA31519@infradead.org>
	<20131030215940.GH6188@dastard> <20131031041343.GK6188@dastard>
	<20131031150024.GP22359@infradead.org>
	<20131031220438.GP4446@dastard>
	<20131101130316.GB14898@infradead.org>
	<20131104232242.GS6188@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131104232242.GS6188@dastard>
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

On Tue, Nov 05, 2013 at 10:22:42AM +1100, Dave Chinner wrote:
> > xfs_initialize_perag_data does the following:
> > 
> >  - read in AGI/AGF.  This is something we lazily do whenever we need it
> >    anyway, so no one should rely on it.
> >  - update the in-core superblock global counters.  Seems like the old
> >    xfs_check relies on this and still needs an equivalent if we care
> >    enough.  No one else seems to care.
> 
> So you are suggesting that I move that initialisation to the
> xfs_check code rather than just doing it in the mount code? Or
> something else?

That seems to be the sanest option if it works out.  Otherwise we'd need
to keep a flag to let libxfs do it.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

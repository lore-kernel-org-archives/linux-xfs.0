Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 11EAC7CA1
	for <xfs@oss.sgi.com>; Thu,  3 Mar 2016 19:36:46 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id D9184304039
	for <xfs@oss.sgi.com>; Thu,  3 Mar 2016 17:36:42 -0800 (PST)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id P2faBFUcn2uWrIgg (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 03 Mar 2016 17:36:41 -0800 (PST)
Date: Thu, 3 Mar 2016 17:36:10 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: block allocations for the refcount btree
Message-ID: <20160304013610.GA27792@birch.djwong.org>
References: <20160210214058.GN14668@dastard>
	<20160212191046.GA28421@infradead.org>
	<20160301181809.GC27973@birch.djwong.org>
	<20160301204013.GA23128@infradead.org>
	<20160302052411.GB1902@birch.djwong.org>
	<20160302095932.GA9141@infradead.org>
	<20160302164102.GA20109@birch.djwong.org>
	<20160302165704.GA31438@infradead.org>
	<20160302212101.GF27973@birch.djwong.org>
	<20160303140556.GA26825@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160303140556.GA26825@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Thu, Mar 03, 2016 at 06:05:56AM -0800, Christoph Hellwig wrote:
> On Wed, Mar 02, 2016 at 01:21:01PM -0800, Darrick J. Wong wrote:
> > Ok.  I think the problem is that making changes to the refcount btree eats
> > up our entire reservation in certain cases.  Can you try the following bandaid?
> > This should give us enough room to handle splitting the btree at both ends
> > of a range that we're refcount-changing.
> 
> This seems to work in general.  I ran into one log related hang when
> running -g auto on nfs, but it's not been reproducible so far.

It still breaks on 1k block filesystems, which confirms my suspicions that
we really need to have enough space in the reservation to handle the worst
case that every block in a n-block truncation has a separate refcountbt
record. :( :(

(Or break up our truncation activities, I suppose...)

--D

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

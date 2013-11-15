Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 79F367F7B
	for <xfs@oss.sgi.com>; Fri, 15 Nov 2013 08:28:20 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 462058F8064
	for <xfs@oss.sgi.com>; Fri, 15 Nov 2013 06:28:20 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id ifg5zeURrhTPxiZB for
	<xfs@oss.sgi.com>; Fri, 15 Nov 2013 06:28:19 -0800 (PST)
Subject: Re: [Cluster-devel] [PATCH 0/6] list: introduce
	list_last_entry_or_null()
From: Steven Whitehouse <swhiteho@redhat.com>
In-Reply-To: <20131115141100.GA17659@infradead.org>
References: <5285A33C.4040808@oracle.com>
	<20131115141100.GA17659@infradead.org>
Date: Fri, 15 Nov 2013 14:26:53 +0000
Message-ID: <1384525613.2747.60.camel@menhir>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: jfs-discussion@lists.sourceforge.net, jiri@resnulli.us, gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, "xfs@oss.sgi.com" <xfs@oss.sgi.com>, cluster-devel@redhat.com, Jeff Liu <jeff.liu@oracle.com>, linux-mtd@lists.infradead.org, oleg@redhat.com, akpm@linux-foundation.org

Hi,

On Fri, 2013-11-15 at 06:11 -0800, Christoph Hellwig wrote:
> On Fri, Nov 15, 2013 at 12:29:48PM +0800, Jeff Liu wrote:
> > Hi Folks,
> > 
> > This patch is trying to introduce a new list helper to retrieve the
> > last entry or return NULL if the list is empty corresponding to it,
> > which is inspired by Jiri Pirko's list_first_entry_or_null().
> 
> How did we end up with the stupid _or_null prefix there?  I think the
> functionality is useful, but the naming is way to verbose, especially
> given that a list_first_entry or list_last_entry that optimizes away
> that one check doesn't seem useful.
> 
> Instead of encoding detailed semantics in the name a good kerneldoc
> comment is way better.
> 

Also, in two of the cases (patch 3 and patch 6) we don't want NULL in
the case that the list is empty, and instead want another pointer which,
after the patches, requires an extra "if". Now I suspect that the
optimizer will sort that out (I've not checked) so its probably not too
big an issue. However, if instead of returning NULL for list empty, we
had an extra argument to the function, then it could return whatever
pointer was required for each case, whether NULL or otherwise,

Steve.


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

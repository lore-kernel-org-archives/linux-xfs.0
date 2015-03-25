Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 765187F50
	for <xfs@oss.sgi.com>; Wed, 25 Mar 2015 12:59:18 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id DA8A6AC003
	for <xfs@oss.sgi.com>; Wed, 25 Mar 2015 10:59:17 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id zQbuX4ueP0H5IlBq (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 25 Mar 2015 10:59:15 -0700 (PDT)
Date: Wed, 25 Mar 2015 10:59:12 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 0/2] xfs: avoid overflow of attr3 leaf block headers with
	64k blocks
Message-ID: <20150325175912.GI24608@birch.djwong.org>
References: <1424811024-24839-1-git-send-email-bfoster@redhat.com>
	<20150325165636.GA3436@laptop.bfoster>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150325165636.GA3436@laptop.bfoster>
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
Cc: xfs@oss.sgi.com

On Wed, Mar 25, 2015 at 12:56:36PM -0400, Brian Foster wrote:
> On Tue, Feb 24, 2015 at 03:50:22PM -0500, Brian Foster wrote:
> > Hi all,
> > 
> > As it turns out, some of the leaf block codepaths other than xattr
> > addition look like they wouldn't work properly with an unaligned
> > firstused value as demonstrated in my previous patch:
> > 
> > http://oss.sgi.com/archives/xfs/2015-02/msg00479.html
> > 
> > Here's an alternate approach that handles the overflow in the header
> > conversion functions. It passes the basic tests so far, but more testing
> > is needed to make sure I've made valid assumptions. Thoughts?
> > 
> > FWIW, another approach could be to leak the last few bytes of the blocks
> > (e.g., max firstused at the last valid aligned offset and update freemap
> > size accordingly)...
> > 
> 
> ping?

Looks reasonable enough to me...

--D

> 
> > Brian
> > 
> > Brian Foster (2):
> >   xfs: pass attr geometry to attr leaf header conversion functions
> >   xfs: use larger in-core attr firstused field and detect overflow
> > 
> >  fs/xfs/libxfs/xfs_attr_leaf.c | 99 +++++++++++++++++++++++++++++--------------
> >  fs/xfs/libxfs/xfs_attr_leaf.h |  6 ++-
> >  fs/xfs/libxfs/xfs_da_format.h |  8 +++-
> >  fs/xfs/xfs_attr_inactive.c    |  3 +-
> >  fs/xfs/xfs_attr_list.c        |  9 ++--
> >  5 files changed, 86 insertions(+), 39 deletions(-)
> > 
> > -- 
> > 1.9.3
> > 
> > _______________________________________________
> > xfs mailing list
> > xfs@oss.sgi.com
> > http://oss.sgi.com/mailman/listinfo/xfs
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 12FB37F47
	for <xfs@oss.sgi.com>; Mon, 26 Oct 2015 16:34:01 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 9162EAC004
	for <xfs@oss.sgi.com>; Mon, 26 Oct 2015 14:33:57 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	kE1Zy98KQs1fZoQU for <xfs@oss.sgi.com>;
	Mon, 26 Oct 2015 14:33:54 -0700 (PDT)
Date: Tue, 27 Oct 2015 08:32:28 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Inconsistencies with trusted.SGI_ACL_{FILE,DEFAULT}
Message-ID: <20151026213228.GI8773@dastard>
References: <CAHc6FU5gS4BA+iTRHo1oHJMVHkLs4aa0eYd5T1ftLC9biRaxrg@mail.gmail.com>
	<20151024125659.GA8095@bfoster.bfoster>
	<CAHc6FU6eVn=KpKvhD2N8hvAgdFQVdBHHS9tUgaVQJf5wnipY=g@mail.gmail.com>
	<20151024152254.GA22232@bfoster.bfoster>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20151024152254.GA22232@bfoster.bfoster>
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
Cc: Andreas Gruenbacher <agruenba@redhat.com>, xfs@oss.sgi.com

On Sat, Oct 24, 2015 at 11:22:55AM -0400, Brian Foster wrote:
> On Sat, Oct 24, 2015 at 03:58:04PM +0200, Andreas Gruenbacher wrote:
> > On Sat, Oct 24, 2015 at 2:57 PM, Brian Foster <bfoster@redhat.com> wrote:
> > > An alternative could be to just disallow setting these xattrs directly.
> > 
> > Probably not because that would cause applications to fail in
> > unexpected new ways.
> > 
> 
> I suppose a backup/restore application might want to set these, but I'm
> not aware of any other sane usage given they're in a filesystem specific
> format at this point. We'd probably have to take a look at xfsdump, see
> how it handles this, then see if there's a clean way to run through
> necessary acl bits if we're called via setxattr().

xfsrestore restores all the xattrs via setxattr(). It does not care
what they contain, it just restores them with the appropriate
namespace flags (ATTR_ROOT, ATTR_SECURE or 0) that they had when
read by xfsdump. So we cannot disable this functionality without
breaking dump/restore.

Really, I'm struggling to understand what the problem is with XFS
doing translation to it's own special xattr names for ACLs
underneath the posix layer. Yes, there's a caching issue when
someone directly manipulates the underlying xattr, but you need root
to shoot yourself in the foot that way, and that is easily
solveable.

What other problems are there?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

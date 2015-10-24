Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id CF9F67F56
	for <xfs@oss.sgi.com>; Sat, 24 Oct 2015 10:36:21 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 60094AC003
	for <xfs@oss.sgi.com>; Sat, 24 Oct 2015 08:36:18 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 49j9hNSZlkGtiIEZ (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Sat, 24 Oct 2015 08:36:16 -0700 (PDT)
Received: from int-mx10.intmail.prod.int.phx2.redhat.com
	(int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (Postfix) with ESMTPS id 368FEC0AF785
	for <xfs@oss.sgi.com>; Sat, 24 Oct 2015 15:36:16 +0000 (UTC)
Date: Sat, 24 Oct 2015 11:36:14 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: Inconsistencies with trusted.SGI_ACL_{FILE,DEFAULT}
Message-ID: <20151024153612.GB22232@bfoster.bfoster>
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
To: Andreas Gruenbacher <agruenba@redhat.com>
Cc: xfs@oss.sgi.com

On Sat, Oct 24, 2015 at 11:22:55AM -0400, Brian Foster wrote:
> On Sat, Oct 24, 2015 at 03:58:04PM +0200, Andreas Gruenbacher wrote:
> > On Sat, Oct 24, 2015 at 2:57 PM, Brian Foster <bfoster@redhat.com> wrote:
> > > On Fri, Oct 23, 2015 at 03:52:54PM +0200, Andreas Gruenbacher wrote:
...
> > That won't update the file mode when setting a SGI_ACL_* attribute.
> > 
> 
> Hmm, perhaps this is not sufficient if the mode has to be updated as
> well. I suppose we could try to do that as well in this path, but that
> implies verification of the data (already in on-disk format) as well.
> There's nothing stopping somebody from doing 'setattr -n
> trusted.SGI_FILE_ACCESS -v 0 <file>,' after all. The previous patch
> wasn't really intended to address that.
> 
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
> 

FWIW, the counter argument to this might be that since these are exposed
in filesystem specific format, the bug is that they are exposed in the
first place and any backup app that wants to support ACLs should do so
using appropriate APIs. That implies we would hide the internal xattrs
and disallow setting them directly.

I'm not sure what the right answer is tbh (or if the xattr exposure is
something more than historical accident). I'd have to think about it a
bit. Perhaps Dave or others have some thoughts as well...

Brian

> Brian
> 
> > Thanks,
> > Andreas
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

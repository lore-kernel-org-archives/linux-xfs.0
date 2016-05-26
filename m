Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id B52247CA0
	for <xfs@oss.sgi.com>; Thu, 26 May 2016 17:57:25 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 3F58EAC007
	for <xfs@oss.sgi.com>; Thu, 26 May 2016 15:57:25 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	WWziQKFOPrLVRGgf for <xfs@oss.sgi.com>;
	Thu, 26 May 2016 15:57:18 -0700 (PDT)
Date: Fri, 27 May 2016 08:57:16 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 09/15] fs: iomap based fiemap implementation
Message-ID: <20160526225716.GP21200@dastard>
References: <1462783638-4968-1-git-send-email-hch@lst.de>
	<1462783638-4968-10-git-send-email-hch@lst.de>
	<1651455378.10041082.1464034166002.JavaMail.zimbra@redhat.com>
	<20160524131058.GA21094@lst.de>
	<1391795572.11287486.1464286797723.JavaMail.zimbra@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1391795572.11287486.1464286797723.JavaMail.zimbra@redhat.com>
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
To: Bob Peterson <rpeterso@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, vishal l verma <vishal.l.verma@intel.com>, Christoph Hellwig <hch@lst.de>, xfs@oss.sgi.com

On Thu, May 26, 2016 at 02:19:57PM -0400, Bob Peterson wrote:
> ----- Original Message -----
> | On Mon, May 23, 2016 at 04:09:26PM -0400, Bob Peterson wrote:
> | > I've been looking at this again. Where are the calls to the fs-specific
> | > bits
> | > for fiemap?
> | 
> | In the iomap_ops structure passed to iomap_fiemap.
> | 
> | > It looks like iomap_fiemap calls iomap_apply, which calls
> | > iomap_fiemap_actor, but that doesn't call any ops->iomap_get_iomap or
> | > similar.
> | > It calls the iomap_begin (which BTW has a comment that says "Execute a
> | > iomap
> | > write" which is probably wrong and should be more generic, as for cases
> | > like
> | > fiemap) and it calls iomap_end. But it never calls an fs-specific actor
> | > anywhere. Am I missing something? My earlier version passed in the actor
> | > function, as per Dave Chinner's request, but yours doesn't.
> | 
> | The iomap_begin callback is where you do the mapping.  the iomap_end
> | callback does any required cleanup, which in case of GFS2 probably
> | would be dropping the cluster lock protecting the mapping.
> | 
> 
> Okay, got it. So a couple things:
> 
> 1. I verified that the vfs bits of the patch set work properly for GFS2
>    using a modified iomap-based fiemap. And it's fast.
> 2. I'm not sure I like the fact that instead of begin->main->end it is
>    essentially begin->end with begin doing all the work.  It works, and
>    it's better than we have today. But I'd prefer either renaming the
>    first function from "iomap_begin" to something that indicates it's
>    more than just a precursor to the actual function?

<shrug> Same can be said for the existing write_begin/end interface
we have for block mapping right now. I suppose iomap_prepare/finish
or iomap_get/put might be more obvious. Pink or purple? :P

>    Or else split it
>    into begin->main->end? I was kinda hoping to pass in the iomap_actor
>    somehow.

Can you explain what for? What are you wanting to put in the fiemap
that you can't pass though the iomap as a map flag?

>    It's not a tragic loss, but the way I've got the gfs2
>    function coded, the begin function does: locking plus the main
>    functionality, and all the fiemap_end function basically does is unlock.

Yup, that's pretty much how it was been intended to work.

> 4. I don't suppose you could split this patch set up so that the vfs
>    bits are independent, so someone like Al Viro could grab them
>    rather than getting pulled along size the xfs-specific bits?
>    (Which is essentially what I've done for GFS2; I did not drag in
>    all the xfs bits).

Once the merge window is over and the VFS bits are stable and
reviewed, I'll put the code into two branches in the XFS tree - the
first will just have the VFS iomap bits and the second will contain
the XFS bits. Once committed, they'll be stable branches, so you
should be able to merge it into the GFS2 tree and work from there.
The duplication of the branch in different trees will resolve
automatically when Linux pulls the trees. That way I can carry the
XFS changes in the XFS tree, and you don't have to see any of them
in the GFS2 tree...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

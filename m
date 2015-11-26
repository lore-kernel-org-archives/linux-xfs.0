Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id C4AF77F37
	for <xfs@oss.sgi.com>; Thu, 26 Nov 2015 05:31:04 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 3D3D2AC001
	for <xfs@oss.sgi.com>; Thu, 26 Nov 2015 03:31:01 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id SQdrgQaCAHyyEJOf (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 26 Nov 2015 03:30:59 -0800 (PST)
Received: from int-mx14.intmail.prod.int.phx2.redhat.com
	(int-mx14.intmail.prod.int.phx2.redhat.com [10.5.11.27])
	by mx1.redhat.com (Postfix) with ESMTPS id 103248E241
	for <xfs@oss.sgi.com>; Thu, 26 Nov 2015 11:30:59 +0000 (UTC)
Date: Thu, 26 Nov 2015 12:30:55 +0100
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH 1/2] xfs_io: implement 'inode' command V4
Message-ID: <20151126113052.GA15663@redhat.com>
References: <1447663404-7857-1-git-send-email-cmaiolino@redhat.com>
	<1447663404-7857-2-git-send-email-cmaiolino@redhat.com>
	<20151119132722.GA13055@bfoster.bfoster>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20151119132722.GA13055@bfoster.bfoster>
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

Hi Brian,

> 
> Well, the code looks Ok to me but the design still seems overdone IMO. I
> have no major objection if this goes in as is (with one exception noted
> below), but IMO we should take the approach somewhat discussed in the v3
> review.

First of all, thanks for reviewing the patch again, I took some time to reply
because I was waiting for any other comments and had a few other things to do.

> 
> In particular, define an actual default behavior for the command to
> return the largest inode number (or return 1/0 for "ability to mount w/
> inode32" as Dave suggested). For example, kill both of the -l and -s
> flags and just return 1/0 by default. Define a single verbose (-v) flag
> to print the combined inode number and size. This mode can be
> implemented as the body of the inode_f() function. If -n is specified,
> basically do what the current version does. Just my .02.
> 

I agree with you here and tbh, I don't really think a -v flag is really needed,
although it can certainly facilitate the usage of the xfs_io -c "inode".
Checking for the size of the inode returned against UINT32_MAX is not that hard
anyway, but I think keeping a very simple return value for the command might be
the best approach.

I'm going to re-write it and send a V5 today including a review of your comment
below.

thanks again for the review

> >  io/open.c | 151 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
> >  1 file changed, 151 insertions(+)
> > 
> > diff --git a/io/open.c b/io/open.c
> > index ac5a5e0..2fc8aab 100644
> > --- a/io/open.c
> > +++ b/io/open.c
> ...
> > +	if (ret_lsize || ret_largest) {
> > +
> > +		bulkreq.lastip = &last;
> > +		bulkreq.icount = 1024; /* User-defined maybe!? */
> > +		bulkreq.ubuffer = &igroup;
> > +		bulkreq.ocount = &count;
> > +
> > +		for (;;) {
> > +
> > +			if (xfsctl(file->name, file->fd, XFS_IOC_FSINUMBERS,
> > +					&bulkreq)) {
> > +				perror("XFS_IOC_FSINUMBERS");
> > +				exitcode = 1;
> > +				return 0;
> > +			}
> > +
> > +			if (count == 0)
> > +				break;
> > +
> > +			lastgrp = count;
> > +		}
> > +
> > +		lastgrp--;
> > +		igrp_rec = igroup[lastgrp];
> 
> IIRC the point of igrp_rec was to save off the last record so it could
> be used directly after the loop without need for the count (because it
> could be 0). Here we use a separate lastgrp count to protect against the
> 0 case, yet still do the record copy after the loop... what's the point
> of that?
> 
> Brian
> 
> > +		lastino = igrp_rec.xi_startino +
> > +			  xfs_highbit64(igrp_rec.xi_allocmask);
> > +
> > +		if (ret_lsize)
> > +			printf (_("Largest inode size: %d\n"),
> > +				lastino > XFS_MAXINUMBER_32 ? 64 : 32);
> > +		else
> > +			printf(_("Largest inode: %llu\n"), lastino);
> > +
> > +		return 0;
> > +	}
> > +
> > +	return command_usage(&inode_cmd);
> > +}
> > +
> >  void
> >  open_init(void)
> >  {
> > @@ -815,6 +955,16 @@ open_init(void)
> >  		_("get/set preferred extent size (in bytes) for the open file");
> >  	extsize_cmd.help = extsize_help;
> >  
> > +	inode_cmd.name = "inode";
> > +	inode_cmd.cfunc = inode_f;
> > +	inode_cmd.args = _("[-s | -l | -n] [num]");
> > +	inode_cmd.argmin = 1;
> > +	inode_cmd.argmax = 2;
> > +	inode_cmd.flags = CMD_NOMAP_OK;
> > +	inode_cmd.oneline =
> > +		_("Query inode number usage in the filesystem");
> > +	inode_cmd.help = inode_help;
> > +
> >  	add_command(&open_cmd);
> >  	add_command(&stat_cmd);
> >  	add_command(&close_cmd);
> > @@ -822,4 +972,5 @@ open_init(void)
> >  	add_command(&chproj_cmd);
> >  	add_command(&lsproj_cmd);
> >  	add_command(&extsize_cmd);
> > +	add_command(&inode_cmd);
> >  }
> > -- 
> > 2.4.3
> > 
> > _______________________________________________
> > xfs mailing list
> > xfs@oss.sgi.com
> > http://oss.sgi.com/mailman/listinfo/xfs

-- 
Carlos

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

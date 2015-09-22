Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id DA1397F56
	for <xfs@oss.sgi.com>; Tue, 22 Sep 2015 07:22:42 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id BAABA304048
	for <xfs@oss.sgi.com>; Tue, 22 Sep 2015 05:22:42 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id fgCSZDU13aVEnql5 (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 22 Sep 2015 05:22:41 -0700 (PDT)
Date: Tue, 22 Sep 2015 08:22:39 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH] xfs_io: Implement inodes64 command
Message-ID: <20150922122238.GA46026@bfoster.bfoster>
References: <1442825768-5793-1-git-send-email-cmaiolino@redhat.com>
	<20150921220832.GB19114@dastard>
	<20150922075432.GC26699@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150922075432.GC26699@redhat.com>
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
To: Dave Chinner <david@fromorbit.com>, xfs@oss.sgi.com

On Tue, Sep 22, 2015 at 09:54:32AM +0200, Carlos Maiolino wrote:
> On Tue, Sep 22, 2015 at 08:08:32AM +1000, Dave Chinner wrote:
> > On Mon, Sep 21, 2015 at 10:56:08AM +0200, Carlos Maiolino wrote:
...
> > > +
> > > +	bulkreq.lastip = &last;
> > > +	bulkreq.icount = 1;
> > > +	bulkreq.ubuffer = &igroup;
> > > +	bulkreq.ocount = &count;
> > > +
> > > +	if (!xfsctl(file->name, file->fd, XFS_IOC_FSINUMBERS, &bulkreq)) {
> > > +		if (count > 0) {
> > > +			printf("Filesystem does have 64bit inodes\n");
> > > +			return 0;
> > > +		} else {
> > > +			printf("Filesystem does not have 64bit inodes\n");
> > > +			return 0;
> > > +		}
> > > +	}
> > > +	perror("xfsctl(XFS_IOC_FSINUMBERS)");
> > 
> > I'd do this the other way around:
> > 
> > 	if (xfsctl(file->name, file->fd, XFS_IOC_FSINUMBERS, &bulkreq)) {
> > 		perror("XFS_IOC_FSINUMBERS");
> > 		exitcode = 1;
> > 		return 0;
> > 	}
> > 
> > 	if (count > 0)
> > 		printf("Filesystem does have 64bit inodes\n");
> > 	else
> > 		printf("Filesystem does not have 64bit inodes\n");
> > 	return 0;
> > 
> > is sufficient, xfsctl is a one line wrapper around ioctl().
> >
> 
> Ok, I'll change this, but, just a matter of curiosity, what are the technical
> reasons to write the conditional this way, instead of the way I wrote first?
> Just to avoid entering the conditional?
> 

Not to speak for Dave, but I had the same thought just skimming through
the patch. I don't think it's a technical reason so much as a style one.
The further the function is grown, the easier it is to see that this
kind of flow is not the most friendly thing. E.g.:

	ret = do_stuff();
	if (!ret) {
		...
		ret = do_more_stuff();
		if (!ret) {
			...
		}
	}

In other words, the common execution path of the function starts to flow
"inward" rather than the natural top-down flow of the function:

	ret = do_stuff();
	if (ret)
		handle_err;

	ret = do_more_stuff();
	if (ret)
		handle_err;
	...

The latter tends to be easier to follow, easier to review the error
handling cases, probably avoids indentation problems down the road, etc.
The function as it is right now is simple and so this probably isn't a
big deal, but I suspect seeing the latter form so frequently in all of
our other code is probably what causes something like the former to
stand out (even in a simple/harmless example). Just my .02. :)

Brian

>  
> > > @@ -815,6 +847,12 @@ open_init(void)
> > >  		_("get/set preferred extent size (in bytes) for the open file");
> > >  	extsize_cmd.help = extsize_help;
> > >  
> > > +	inodes64_cmd.name = "inodes64";
> > > +	inodes64_cmd.cfunc = inodes64_f;
> > > +	inodes64_cmd.flags = CMD_NOMAP_OK;
> > > +	inodes64_cmd.oneline =
> > > +		_("Checks if filesyste contais 64bit inodes");
> >                                     ^^^     ^^ 64 bit
> > 
> > "inodes64" could be improved as a command name. e.g:
> > 
> > oneline = _("Query inode number usage in the filesystem")
> > 
> > And could do a little more to help users work out what the
> > problematic inode is. e.g:
> > 
> > Long help:
> > 
> > Inode_numbers [-s|-l] [num]
> > 
> > 	[-s]	returns the physical size of the largest inode
> > 		number in the filesystem (32 bit of 64 bit)
> > 	[-l]	returns the largest inode number in the filesystem
> > 	[-n]	returns the next inode number after [num]
> > 	[num]	returns whether the inode number exists
> > 
> > i.e. if you want 32 bit inodes in the fs, you can use [-n num] to
> > iterate all the inode numbers above 32 bits in size...
> > 
> 
> Ok, np
> 
> > Cheers,
> > 
> > Dave.
> > -- 
> > Dave Chinner
> > david@fromorbit.com
> > 
> > _______________________________________________
> > xfs mailing list
> > xfs@oss.sgi.com
> > http://oss.sgi.com/mailman/listinfo/xfs
> 
> -- 
> Carlos
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

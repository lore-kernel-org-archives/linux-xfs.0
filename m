Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 25F8C7F37
	for <xfs@oss.sgi.com>; Fri,  9 Oct 2015 07:36:21 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 079AB8F8049
	for <xfs@oss.sgi.com>; Fri,  9 Oct 2015 05:36:17 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id jBinLP2wieQHVBFG (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 09 Oct 2015 05:36:16 -0700 (PDT)
Received: from int-mx09.intmail.prod.int.phx2.redhat.com
	(int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (Postfix) with ESMTPS id 0169C91E9D
	for <xfs@oss.sgi.com>; Fri,  9 Oct 2015 12:36:15 +0000 (UTC)
Received: from bfoster.bfoster (dhcp-41-179.bos.redhat.com [10.18.41.179])
	by int-mx09.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id t99CaF6g020312
	for <xfs@oss.sgi.com>; Fri, 9 Oct 2015 08:36:15 -0400
Date: Fri, 9 Oct 2015 08:36:14 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 3/3] xfs_io: implement inode '-n' and [num] argument
Message-ID: <20151009123613.GA27982@bfoster.bfoster>
References: <1443186467-20110-1-git-send-email-cmaiolino@redhat.com>
	<1443186467-20110-4-git-send-email-cmaiolino@redhat.com>
	<20151006170055.GD63205@bfoster.bfoster>
	<20151009083313.GA28373@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20151009083313.GA28373@redhat.com>
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
To: xfs@oss.sgi.com

On Fri, Oct 09, 2015 at 10:33:13AM +0200, Carlos Maiolino wrote:
> On Tue, Oct 06, 2015 at 01:00:56PM -0400, Brian Foster wrote:
> > On Fri, Sep 25, 2015 at 03:07:47PM +0200, Carlos Maiolino wrote:
> > > "-n [num]" argument, will return to the user the next inode valid on the filesystem
> > > after [num].
> > > 
> > > Using [num] exclusive, will test if the inode [num] is a valid inode in the
> > > filesystem or not.
> > > 
> > > Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
> > > ---
> > >  io/open.c | 84 +++++++++++++++++++++++++++++++++++++++++++++++++++++++--------
> > >  1 file changed, 74 insertions(+), 10 deletions(-)
> > > 
> > > diff --git a/io/open.c b/io/open.c
> > > index 57ff0bf..9f68de0 100644
> > > --- a/io/open.c
> > > +++ b/io/open.c
...
> > >  
> > > +	if ((optind < argc) && !(ret_next || ret_lsize || ret_largest)) {
> > > +		ret_isvalid = 1;
> > > +		userino = strtoull(argv[optind], &p, 10);
> > > +	}
> > 
> > So this appears to be the default behavior (validate whether an inode
> > exists). Perhaps this functionality should come first since that's the
> > core behavior for the command.
> > 
> 
> Hmm, I don't think so, I need getopt() to setup optind for this.
> 

I don't see how that matters. That code can stay in the first patch. I'm
just saying patch 1 should probably implement the core/default
functionality, and obviously whatever supporting code is necessary to
make that happen. For example, that could mean that the above
ret_isvalid = 1 block goes away, the code executes in this mode by
default, and the subsequent patches implement alternate branches as
necessary to alter behavior.

In other words, the (pseudo)code can start off looking like this:

	userino = ...;

	...

	bulkreq = ...
	xfsctl(..., XFS_IOC_FSBULKSTAT_SINGLE, ...);
	printf("Valid inode: ...");
	return 0;

... then patch 2 comes along an adds a next option:

	int cmd = XFS_IOC_FSBULKSTAT_SINGLE;

	while (getopt() = ...) {
		if (next)
			cmd = XFS_IOC_FSBULKSTAT;
	}
	userino = ...;

	...

	bulkreq = ...
	xfsctl(..., cmd, ...);
	printf("%s inode: ...", next ? "Next" : "Valid", ...);
	return 0;

... and so on. Patch 3 comes along and adds more command line options
and an alternate FSNUMBERS branch before the bulkstat xfsctl(). That
branch ends with a return 0, so there's no need to put the core
mechanism bits above into an 'if (ret_isvalid).'

The alternative is to just squash everything to one patch, which is
probably reasonable too. I still think the end result can be simplified
and reduced to something like the above though.

> > > +
> > > +	if (userino)
> > > +		if (*p != '\0') {
> > > +			printf("[num] must be a valid number\n");
> > > +			exitcode = 1;
> > > +			return 0;
> > > +		}
> > > +
> > >  	if (ret_lsize || ret_largest) {
> > > +
> > > +		bulkreq.lastip = &last;
> > > +		bulkreq.icount = 1024; /* User-defined maybe!? */
> > > +		bulkreq.ubuffer = &igroup;
> > > +		bulkreq.ocount = &count;
> > > +
> > >  		for (;;) {
> > >  			if (xfsctl(file->name, file->fd, XFS_IOC_FSINUMBERS,
> > >  					&bulkreq)) {
> > > @@ -806,7 +831,7 @@ inode_f(
> > >  				exitcode = 1;
> > >  				return 0;
> > >  			}
> > > -			if (count < XFS_INODES_PER_CHUNK && count > 0)
> > > +			if (count < 1024 && count > 0)
> > >  				lastgrp = count;
> > 
> > Ok, that sort of addresses my question on patch 1. I guess this is a
> > record count rather than an inode count as well. In that case, what
> > happens if the fs has an exact multiple of 1024 inode records?
> > 
> Yes, it's a record count, each record contains a single inode chunk.
> regarding the exactly multiple of 1024 chunks, AFAIK it will fit all the 1024
> records in a single array, which is exactly the size of the array I'm using
> here, and, next call to xfsctl, will return a 0 records count, making the look
> to exit.
> 

Ok, that's what I would expect up to that point. To be more clear, when
is lastgrp ever set? Further, what happens if xfsctl() somewhere down
the road decides to memset(..., 0, ...) bulkreq.ubuffer (for example)
when count is set to 0?

For example, here's a quick experiment on an fs with precisely 1024
inode records:

# ./io/xfs_io -c "inode -l" /mnt/
Largest inode: 1070
# find /mnt/ -inum 1070 -print
#

Oops! :) After adding a few more records:

# ./io/xfs_io -c "inode -l" /mnt/
Largest inode: 971014
# find /mnt/ -inum 971014 -print
/mnt/tmp/128
#

> > BTW, I think this should probably be set correctly when it is introduced
> > rather than set to a value and changed in a subsequent patch.
> 
> Yes, I just forgot to change this in the first patch, see my comment in patch 1.
> 
> > 
> > >  			if (!count)
> > >  				break;
> > > @@ -822,8 +847,47 @@ inode_f(
> > >  		else
> > >  			printf(_("Largest inode: %llu\n"), lastino);
> > >  
> > > +		return 0;
> > > +	}
> > > +
> > > +	/* Setup bulkreq for -n or [num] only */
> > > +	last = userino;
> > > +	bulkreq.lastip = &last;
> > > +	bulkreq.icount = 1;
> > > +	bulkreq.ubuffer = &bstat;
> > > +	bulkreq.ocount = &count;
> > > +
> > > +	if (ret_next) {
> > > +		if (xfsctl(file->name, file->fd, XFS_IOC_FSBULKSTAT, &bulkreq)) {
> > > +			if (errno == EINVAL)
> > > +				printf("Invalid or non-existent inode\n");
> > > +			else
> > > +				perror("XFS_IOC_FSBULKSTAT");
> > > +			exitcode = 1;
> > > +			return 0;
> > > +		}
> > > +
> > > +		if (!bstat.bs_ino) {
> > > +			printf("There are no further inodes in the filesystem\n");
> > > +			return 0;
> > > +		}
> > 
> > The above should technically check the output count rather than the
> > inode number, right?
> > 
> If I use the inode count, I can get an 'allocated but free' inode, which is not
> the intention here.
>  

I don't think bulkstat returns unused (but allocated) inodes. Most of
the inode information would be invalid/undefined. Indeed, from
xfs_bulkstat_ag_ichunk():

                /* Skip if this inode is free */
                if (XFS_INOBT_MASK(chunkidx) & irbp->ir_free)
                        continue;

Brian

> > > +
> > > +		printf("Next inode: %llu\n", bstat.bs_ino);
> > > +		return 0;
> > >  	}
> > >  
> > > +	if (ret_isvalid) {
> > > +		if (xfsctl(file->name, file->fd, XFS_IOC_FSBULKSTAT_SINGLE, &bulkreq)) {
> > > +			if (errno == EINVAL) {
> > > +				printf("Invalid or non-existent inode number\n");
> > 
> > Is EINVAL returned in the non-existent case or ENOENT?
> >
> 
> I'll check this inside kernel, but I'm not sure if there is any distinction. If
> the inode passed to xfsctl is incalid, EINVAL will be returned.
> 
>  
> > Brian
> > 
> > > +			} else
> > > +				perror("XFS_IOC_FSBULKSTAT_SINGLE");
> > > +			exitcode = 1;
> > > +			return 0;
> > > +		}
> > > +		printf("Valid inode: %llu\n", bstat.bs_ino);
> > > +		return 0;
> > > +	}
> > >  
> > >  	return 0;
> > >  }
> > > @@ -895,9 +959,9 @@ open_init(void)
> > >  
> > >  	inode_cmd.name = "inode";
> > >  	inode_cmd.cfunc = inode_f;
> > > -	inode_cmd.args = _("[-s | -l]");
> > > +	inode_cmd.args = _("[-s | -l | -n] [num]");
> > >  	inode_cmd.argmin = 1;
> > > -	inode_cmd.argmax = 1;
> > > +	inode_cmd.argmax = 2;
> > >  	inode_cmd.flags = CMD_NOMAP_OK;
> > >  	inode_cmd.oneline =
> > >  		_("Query inode number usage in the filesystem");
> > > -- 
> > > 2.4.3
> > > 
> > > _______________________________________________
> > > xfs mailing list
> > > xfs@oss.sgi.com
> > > http://oss.sgi.com/mailman/listinfo/xfs
> 
> -- 
> Carlos

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 198787F50
	for <xfs@oss.sgi.com>; Mon, 22 Feb 2016 04:25:48 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id D097730407F
	for <xfs@oss.sgi.com>; Mon, 22 Feb 2016 02:25:41 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id s5TAf4OPIkQwBECC (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 22 Feb 2016 02:25:34 -0800 (PST)
Received: from int-mx11.intmail.prod.int.phx2.redhat.com
	(int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (Postfix) with ESMTPS id 6E7F91831
	for <xfs@oss.sgi.com>; Mon, 22 Feb 2016 10:25:33 +0000 (UTC)
Date: Mon, 22 Feb 2016 11:25:30 +0100
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH] xfs_io: implement 'inode' command V6
Message-ID: <20160222102530.GA3060@redhat.com>
References: <1455814159-14191-1-git-send-email-cmaiolino@redhat.com>
	<20160219175508.GD27263@bfoster.bfoster>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160219175508.GD27263@bfoster.bfoster>
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

Hey,

> > +	if (optind < argc) {
> > +
> > +		if (ret_next) {
> > +			cmd = XFS_IOC_FSBULKSTAT;
> > +		} else {
> > +			if (argc > 2)
> > +				return command_usage(&inode_cmd);
> 
> FYI, this means one can't do the following:
> 
>   xfs_io -c "inode -v 123" <mnt>
> 
> Otherwise it looks good to me:
> 
> Reviewed-by: Brian Foster <bfoster@redhat.com>
> 
Thanks, I'm not sure how I didn't notice this, I thought I had tested all
options with verbose mode.

I believe I can fix this with this:

-                       if (argc > 2)
+                       if (argc > 2 && !verbose)

I must check the amount of arguments, so nobody can pass 2 inode numbers. Bu I
believe with this change I can fix it.

I'm testing it right now, and will send a patch with this change after I test
all the remaining options.

Cheers
> > +			else
> > +				cmd = XFS_IOC_FSBULKSTAT_SINGLE;
> > +		}
> > +
> > +		userino = strtoull(argv[optind], &p, 10);
> > +		if ((*p != '\0')) {
> > +			printf(_("[num] must be a numeric value\n"));
> > +			exitcode = 1;
> > +			return 0;
> > +		}
> > +
> > +		bulkreq.lastip = &userino;
> > +		bulkreq.icount = 1;
> > +		bulkreq.ubuffer = &bstat;
> > +		bulkreq.ocount = &count;
> > +
> > +		if (xfsctl(file->name, file->fd, cmd, &bulkreq)) {
> > +			if (errno == EINVAL) {
> > +				if (!ret_next)
> > +					printf("0\n");
> > +			} else {
> > +				perror("xfsctl");
> > +			}
> > +			exitcode = 1;
> > +			return 0;
> > +		}
> > +
> > +		if (ret_next)
> > +			userino = bstat.bs_ino;
> > +
> > +		if (verbose)
> > +			printf("%llu:%d\n",
> > +			       userino,
> > +			       userino > XFS_MAXINUMBER_32 ? 64 : 32);
> > +		else
> > +			/* Inode in use */
> > +			printf("%llu\n", userino);
> > +		return 0;
> > +
> > +	/* -n option must not be used stand alone */
> > +	} else if (ret_next) {
> > +		return command_usage(&inode_cmd);
> > +	}
> > +
> > +	bulkreq.lastip = &last;
> > +	bulkreq.icount = 1024; /* User-defined maybe!? */
> > +	bulkreq.ubuffer = &igroup;
> > +	bulkreq.ocount = &count;
> > +
> > +	for (;;) {
> > +		if (xfsctl(file->name, file->fd, XFS_IOC_FSINUMBERS,
> > +				&bulkreq)) {
> > +			perror("XFS_IOC_FSINUMBERS");
> > +			exitcode = 1;
> > +			return 0;
> > +		}
> > +
> > +		if (count == 0)
> > +			break;
> > +
> > +		lastgrp = count;
> > +	}
> > +
> > +	lastgrp--;
> > +	lastino = igroup[lastgrp].xi_startino +
> > +		  xfs_highbit64(igroup[lastgrp].xi_allocmask);
> > +
> > +	if (verbose)
> > +		printf("%llu:%d\n", lastino,
> > +			lastino > XFS_MAXINUMBER_32 ? 64 : 32);
> > +	else
> > +		printf("%d\n", lastino > XFS_MAXINUMBER_32 ? 1 : 0);
> > +
> > +	return 0;
> > +}
> > +
> >  void
> >  open_init(void)
> >  {
> > @@ -815,6 +954,16 @@ open_init(void)
> >  		_("get/set preferred extent size (in bytes) for the open file");
> >  	extsize_cmd.help = extsize_help;
> >  
> > +	inode_cmd.name = "inode";
> > +	inode_cmd.cfunc = inode_f;
> > +	inode_cmd.args = _("[-n | -v] [num]");
> > +	inode_cmd.argmin = 0;
> > +	inode_cmd.argmax = 2;
> > +	inode_cmd.flags = CMD_NOMAP_OK;
> > +	inode_cmd.oneline =
> > +		_("Query inode number usage in the filesystem");
> > +	inode_cmd.help = inode_help;
> > +
> >  	add_command(&open_cmd);
> >  	add_command(&stat_cmd);
> >  	add_command(&close_cmd);
> > @@ -822,4 +971,5 @@ open_init(void)
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

Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 174157F37
	for <xfs@oss.sgi.com>; Fri, 18 Sep 2015 09:21:29 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 83EB9AC007
	for <xfs@oss.sgi.com>; Fri, 18 Sep 2015 07:21:25 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id lP2oCCXtGbbZpdzF (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 18 Sep 2015 07:21:22 -0700 (PDT)
Date: Fri, 18 Sep 2015 16:21:17 +0200
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [RFC PATCH] xfs_io: Implement inodes64 command
Message-ID: <20150918142117.GA20717@redhat.com>
References: <1442499846-10470-1-git-send-email-cmaiolino@redhat.com>
	<55FAF212.2010308@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <55FAF212.2010308@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com

On Thu, Sep 17, 2015 at 12:02:10PM -0500, Eric Sandeen wrote:
> (oops, resending to list not just Carlos)
> 
> On 9/17/15 9:24 AM, Carlos Maiolino wrote:
> > This command aims to implement an easy way to check a filesystem for the
> > existence of 64bit inodes.
> >
> > Based on XFS_IOC_FSINUMBERS, and starting with a lastip = 0xffffffff
> > instead of 0.
> >
> > For now, it just returns a string saying there is or there is no 64bit inodes
> > in the filesystem, but, I was wondering if it might not be better to just return
> > 0 or 1, so it can be used inside scripts to check for that. Or maybe an argument
> > to chose between an integer output or a string verbose output.
> >
> > Also, I was wondering if might be useful to, besides return the existence of
> > 64bit inodes, also inform if there is any 64bit inodes allocated in the groups
> > or not. Although, this will need the tool to walk through all the inode groups
> > checking for allocated inodes or not, instead of just stop at the first 64bit
> > inode found.
> 
> I'm not sure what you mean here - list the groups which contain them?
> Any group above the one where the first 64 bit inode is found will also
> have 64-bit inodes, (unless they have no inodes at all) - so I don't see
> the value, but maybe I'm missing something.
> 

Inodes are allocated in 'clusters', you might have a 64-bit inodes cluster
allocated, but not in use at all, the  xfs_inogrp_t.xi_allocmask field will show
which inodes from that cluster is allocated or not, so, I was wondering if the
information that "64bit inodes were created" is enough, of if would be useful to
say that '64bits inodes were created and are/aren't in use'.


> > Also, I'm still not sure if 'inodes64' is a good name for the command, I was
> > also thinking about something like 'chk64inos' but 'inodes64' was the best and
> > easy to be remembered I could find.
> 
> Eh, seems reasonable to me.  Not super, but I can't think of anything much
> better. 
> 
> > Comments are appreciated 
> 
> Below...
> 
> > Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
> > ---
> >  io/open.c | 39 +++++++++++++++++++++++++++++++++++++++
> >  1 file changed, 39 insertions(+)
> >
> > diff --git a/io/open.c b/io/open.c
> > index ac5a5e0..3a98fdf 100644
> > --- a/io/open.c
> > +++ b/io/open.c
> > @@ -44,6 +44,7 @@ static cmdinfo_t statfs_cmd;
> >  static cmdinfo_t chproj_cmd;
> >  static cmdinfo_t lsproj_cmd;
> >  static cmdinfo_t extsize_cmd;
> > +static cmdinfo_t inodes64_cmd;
> >  static prid_t prid;
> >  static long extsize;
> >  
> > @@ -750,6 +751,37 @@ statfs_f(
> >  	return 0;
> >  }
> >  
> > +static int
> > +inodes64_f(
> > +	  int			argc,
> > +	  char			**argv)
> > +{
> > +	int			i;
> > +	__s32			count;
> > +	__u64			last = 0xffffffff;
> 
> might be good to use XFS_MAXINUMBER_32 here
> 

Good, I didn't know about this flag :)

> > +	xfs_inogrp_t		igroup[64];
> 
> why 64?  wouldn't one suffice?
> 

well, 64 is the default size of the inode chunks (or clusters, whatever we call
it), so we can get a whole inode cluster at a time.


> > +	xfs_fsop_bulkreq_t	bulkreq;
> > +
> > +	/* Setup bulkreq structure */
> > +	bulkreq.lastip = &last;
> > +	bulkreq.icount = 64;
> > +	bulkreq.ubuffer = &igroup;
> > +	bulkreq.ocount = &count;
> > +
> > +	while (xfsctl(file->name, file->fd, XFS_IOC_FSINUMBERS, &bulkreq) == 0) {
> > +		if (count > 0) {
> > +			printf("Filesystem does have 64bit inodes\n");
> > +			return 0;
> > +		} else {
> > +			printf("Filesystem does not have 64bit inodes\n");
> > +			return 0;
> > +		}
> > +	}
> 
> I'm also not sure what the "while" is for, here.
> 
> If you start at XFS_MAXINUMBER_32, won't a single call either
> give you count = 1 or count = 0?
> 

Probably you are right. I used the while() keeping in mind the possibility to
return the status of all 64bit inodes existing in the filesystem, also, I had
this question:

"What if the inode XFS_MAXINUMBER_32 does not exist, but bigger inodes do? Like
in different, bigger AGs?"

I was considering that each call using XFS_IOC_FSINUMBERS, will return only the
inodes in the same allocation group, and another xfsctl call was needed to
continue in the following ones. But I really don't know from where I took it,
probably misinterpreting the xfsctl manpage :)

I should have read the kernel implementation before writing it :)

So, yes, you're right, just a single xfsctl call here will return the next valid
inode bigger than 0xffffffff.

while{} needed only if we want to keep track of the status of the remaining
ones, which, IMHO is not the goal of this command.



> > +	perror("xfsctl(XFS_IOC_FSINUMBERS)");
> > +	exitcode = 1;
> > +	return 0;
> > +}
> > +
> >  void
> >  open_init(void)
> >  {
> > @@ -815,6 +847,12 @@ open_init(void)
> >  		_("get/set preferred extent size (in bytes) for the open file");
> >  	extsize_cmd.help = extsize_help;
> >  
> > +	inodes64_cmd.name = "inodes64";
> > +	inodes64_cmd.cfunc = inodes64_f;
> > +	inodes64_cmd.flags = CMD_NOMAP_OK;
> > +	inodes64_cmd.oneline =
> > +		_("Checks if filesyste contais 64bit inodes");
> 
> "if filesystem contains"
> 

Typo, sorry 

> > +
> >  	add_command(&open_cmd);
> >  	add_command(&stat_cmd);
> >  	add_command(&close_cmd);
> > @@ -822,4 +860,5 @@ open_init(void)
> >  	add_command(&chproj_cmd);
> >  	add_command(&lsproj_cmd);
> >  	add_command(&extsize_cmd);
> > +	add_command(&inodes64_cmd);
> >  }
> 
> needs xfs_io manpage updates too, and possibly an xfstest test case?
> 
> -Eric

Will do, this was just an RFC to get comments about it. I wasn't willing to
write a manpage entry without even know if people agreed with the command name,
or even with the idea :)

Thanks for the comments, much appreciated.

> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

-- 
Carlos

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

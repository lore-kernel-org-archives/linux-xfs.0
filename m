Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 274FD7F3F
	for <xfs@oss.sgi.com>; Tue, 11 Mar 2014 08:55:50 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id E335E304059
	for <xfs@oss.sgi.com>; Tue, 11 Mar 2014 06:55:49 -0700 (PDT)
Received: from mail-qc0-f170.google.com (mail-qc0-f170.google.com
	[209.85.216.170]) by cuda.sgi.com with ESMTP id
	Rpw1AtCATcxDfJxJ (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Tue, 11 Mar 2014 06:55:48 -0700 (PDT)
Received: by mail-qc0-f170.google.com with SMTP id e9so9466366qcy.15
	for <xfs@oss.sgi.com>; Tue, 11 Mar 2014 06:55:46 -0700 (PDT)
Message-ID: <1394546142.27741.7.camel@archie>
Subject: Re: [PATCH v2] xfsdump: Fix memory and fd leak in invutil/stobj.c
From: Boris Ranto <ranto.boris@gmail.com>
Date: Tue, 11 Mar 2014 14:55:42 +0100
In-Reply-To: <20140307184812.GA19284@laptop.bfoster>
References: <1394203962-17080-1-git-send-email-ranto.boris@gmail.com>
	<20140307184812.GA19284@laptop.bfoster>
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
To: Brian Foster <bfoster@redhat.com>
Cc: Boris Ranto <branto@redhat.com>, xfs@oss.sgi.com

On Fri, 2014-03-07 at 13:48 -0500, Brian Foster wrote:
> On Fri, Mar 07, 2014 at 03:52:42PM +0100, Boris Ranto wrote:
> > The function open_stobj duplicates its argument, upon successful
> > duplication, the fstat is called. If the fstat command fails then
> > the memory for the duplicated string is leaked. Fix this by moving
> > the string duplication after the fstat call. This is ok because
> > the fstat call does not use the duplicated string.
> > 
> > Brian Foster noticed that the function also leaks a file descriptor
> > in case the file cannot be fstated. Fixing that, too.
> > 
> > Signed-off-by: Boris Ranto <ranto.boris@gmail.com>
> > ---
> >  invutil/stobj.c | 13 +++++++------
> >  1 file changed, 7 insertions(+), 6 deletions(-)
> > 
> > diff --git a/invutil/stobj.c b/invutil/stobj.c
> > index 428b419..a74ba0f 100644
> > --- a/invutil/stobj.c
> > +++ b/invutil/stobj.c
> > @@ -578,23 +578,24 @@ open_stobj(char *StObjFileName)
> >  	return fd;
> >      }
> >  
> > -    name = strdup(StObjFileName);
> > -    if(name == NULL) {
> > -	fprintf(stderr, "%s: internal memory error: strdup stobj_name\n", g_programName);
> > -	exit(1);
> > -    }
> > -
> >      read_n_bytes(fd, &cnt, sizeof(invt_sescounter_t), StObjFileName);
> >      lseek( fd, 0, SEEK_SET );
> >      errno = 0;
> >      if (fstat(fd, &sb) < 0) {
> >  	fprintf(stderr, "Could not get stat info on %s\n", StObjFileName);
> >  	perror("fstat");
> > +	close(fd);
> >  	return -1;
> >      }
> >      size = sb.st_size;
> >      mapaddr = mmap_n_bytes(fd, size, BOOL_FALSE, StObjFileName);
> >  
> > +    name = strdup(StObjFileName);
> > +    if(name == NULL) {
> > +	fprintf(stderr, "%s: internal memory error: strdup stobj_name\n", g_programName);
> > +	exit(1);
> > +    }
> > +
> >      return add_stobj(name, fd, size, mapaddr, (invt_sescounter_t *)mapaddr);
> >  }
> >  
> 
> The remaining failure cases all appear to exit(), including those in
> add_stobj(). Looks good to me, thanks for making that fix...
> 
> Reviewed-by: Brian Foster <bfoster@redhat.com>
> 

No problem, thanks for the review. And yes, I've also looked at the
remaining cases and did not update them because they all just exited.

Boris

> > -- 
> > 1.9.0
> > 
> > _______________________________________________
> > xfs mailing list
> > xfs@oss.sgi.com
> > http://oss.sgi.com/mailman/listinfo/xfs


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

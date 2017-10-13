Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:54538 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753258AbdJMNbI (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 13 Oct 2017 09:31:08 -0400
Date: Fri, 13 Oct 2017 09:31:06 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH] xfs_io: report io error for pwrite -W and -w
Message-ID: <20171013133106.GD44461@bfoster.bfoster>
References: <20171012204949.8225-1-bo.li.liu@oracle.com>
 <20171012220245.GM7122@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171012220245.GM7122@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Liu Bo <bo.li.liu@oracle.com>, linux-xfs@vger.kernel.org

On Thu, Oct 12, 2017 at 03:02:45PM -0700, Darrick J. Wong wrote:
> On Thu, Oct 12, 2017 at 02:49:49PM -0600, Liu Bo wrote:
> > When IO error occurs, xfs_io -c "pwrite -W/w" doesn't report errors
> > while xfs_io -c "pwrite" -c "fsync" does.
> > 
> > This changes "pwrite -W/w" to report errors when it should.
> > 
> > Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
> > ---
> >  io/pwrite.c | 16 ++++++++++++----
> >  1 file changed, 12 insertions(+), 4 deletions(-)
> > 
> > diff --git a/io/pwrite.c b/io/pwrite.c
> > index 1c5dfca..71bcccc 100644
> > --- a/io/pwrite.c
> > +++ b/io/pwrite.c
> > @@ -379,11 +379,18 @@ pwrite_f(
> >  	}
> >  	if (c < 0)
> >  		goto done;
> > -	if (Wflag)
> > -		fsync(file->fd);
> > -	if (wflag)
> > -		fdatasync(file->fd);
> > +	if (Wflag) {
> > +		if (fsync(file->fd) < 0) {
> > +			perror("fsync");
> > +			goto done;
> > +		}
> > +	}
> > +	if (wflag) {
> > +		if (fdatasync(file->fd) < 0) {
> > +			perror("fdatasync");
> 
> Ok.
> 
> > +			goto done;
> 
> So this is a new behavior -- previously we'd print the timing info even
> if the f{data,}sync call fails.  I don't know that the timing matters if
> we fail to guarantee the data is on stable storage, but does anyone else
> have opinions?
> 

Seems like an Ok change to me. The manpage says that the f[data]sync()
call is included in the timing results, which implies that you'd
probably want to know if it outright failed. If you didn't want to time
the sync, then I'd think you wouldn't use -w.

Brian

> --D
> 
> > +		}
> > +	}
> >  	if (qflag)
> >  		goto done;
> >  	gettimeofday(&t2, NULL);
> > -- 
> > 2.9.4
> > 
> > @@ -390,0 +397,0 @@
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:55264 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727103AbfCOC4r (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 14 Mar 2019 22:56:47 -0400
Date: Thu, 14 Mar 2019 19:56:38 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 07/36] xfs_io: actually check copy file range helper
 return values
Message-ID: <20190315025638.GD4929@magnolia>
References: <155259742281.31886.17157720770696604377.stgit@magnolia>
 <155259746648.31886.15984241616376190830.stgit@magnolia>
 <53e2bd63-6bd1-648a-d9dd-020b42565e6d@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53e2bd63-6bd1-648a-d9dd-020b42565e6d@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: linux-xfs@vger.kernel.org, Anna Schumaker <Anna.Schumaker@Netapp.com>, Christoph Hellwig <hch@lst.de>

On Thu, Mar 14, 2019 at 09:12:11PM -0500, Eric Sandeen wrote:
> On 3/14/19 4:04 PM, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > We need to check the return value of copy_src_filesize and
> > copy_dst_truncate because either could return -1 due to fstat/ftruncate
> > failure.
> > 
> > Fixes: 628e112afdd98c5 ("xfs_io: implement 'copy_range' command")
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > Reviewed-by: Anna Schumaker <Anna.Schumaker@Netapp.com>
> > Reviewed-by: Christoph Hellwig <hch@lst.de>
> 
> I see this has reviews already, but I'm not conviced 1 is the right
> return on error.
> 
> i.e. the error condition just prior returns 0:
> 
>         fd = openfile(argv[optind], NULL, IO_READONLY, 0, NULL);
>         if (fd < 0)
>                 return 0;
> 
> but OTOH if copy_file_range_cmd() fails we return nonzero.  Argh.
> 
> Is there a rhyme or reason here that I'm missing?  Is it broken now
> so just do a coinflip on the new return for now?

Pretty much. :(

I don't really care if you change the return value, I just thought it
was bad form not to check the syscall/helper return values at all.

--D

> 
> > ---
> >  io/copy_file_range.c |   17 +++++++++++++++--
> >  1 file changed, 15 insertions(+), 2 deletions(-)
> > 
> > 
> > diff --git a/io/copy_file_range.c b/io/copy_file_range.c
> > index 4e2969c9..d069e5bb 100644
> > --- a/io/copy_file_range.c
> > +++ b/io/copy_file_range.c
> > @@ -120,11 +120,24 @@ copy_range_f(int argc, char **argv)
> >  		return 0;
> >  
> >  	if (src == 0 && dst == 0 && len == 0) {
> > -		len = copy_src_filesize(fd);
> > -		copy_dst_truncate();
> > +		off64_t	sz;
> > +
> > +		sz = copy_src_filesize(fd);
> > +		if (sz < 0 || (unsigned long long)sz > SIZE_MAX) {
> > +			ret = 1;
> > +			goto out;
> > +		}
> > +		len = sz;
> > +
> > +		ret = copy_dst_truncate();
> > +		if (ret < 0) {
> > +			ret = 1;
> > +			goto out;
> > +		}
> >  	}
> >  
> >  	ret = copy_file_range_cmd(fd, &src, &dst, len);
> > +out:
> >  	close(fd);
> >  	return ret;
> >  }
> > 

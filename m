Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 02B497F37
	for <xfs@oss.sgi.com>; Thu, 19 Mar 2015 15:03:20 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id DFCA28F8073
	for <xfs@oss.sgi.com>; Thu, 19 Mar 2015 13:03:16 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id GIOLQlGMAjG7oexP (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 19 Mar 2015 13:03:15 -0700 (PDT)
Date: Thu, 19 Mar 2015 13:03:10 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] xfs_repair: don't abort on bad directory leaf crc during
	leaf check
Message-ID: <20150319200310.GE24608@birch.djwong.org>
References: <20150318232239.GB24608@birch.djwong.org>
	<20150319182854.GJ11669@laptop.bfoster>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150319182854.GJ11669@laptop.bfoster>
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

On Thu, Mar 19, 2015 at 02:28:54PM -0400, Brian Foster wrote:
> On Wed, Mar 18, 2015 at 04:22:39PM -0700, Darrick J. Wong wrote:
> > longform_dir2_check_leaf() checks a directory leaf block to help
> > decide if we need to rebuild the directory.  If the verifier fails
> > with a CRC or corrupt structure error, rebuild the directory instead
> > of aborting.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  repair/phase6.c |    7 ++++++-
> >  1 file changed, 6 insertions(+), 1 deletion(-)
> > 
> > diff --git a/repair/phase6.c b/repair/phase6.c
> > index 1728609..c09b394 100644
> > --- a/repair/phase6.c
> > +++ b/repair/phase6.c
> > @@ -1951,7 +1951,12 @@ longform_dir2_check_leaf(
> >  	da_bno = mp->m_dirleafblk;
> >  	error = dir_read_buf(ip, da_bno, -1, &bp, &xfs_dir3_leaf1_buf_ops,
> >  			     &fixit);
> > -	if (error) {
> > +	if (error == EFSBADCRC || error == EFSCORRUPTED || fixit) {
> > +		do_warn(
> > +	_("leaf block %u for directory inode %" PRIu64 " bad CRC\n"),
> > +			da_bno, ip->i_ino);
> > +		return 1;
> > +	} else if (error) {
> 
> I don't think we'll ever see EFSBADCRC from this codepath (that appears
> to be the purpose of 'fixit'). Looking at it further, it's self
> documenting and robust against changes in the read codepath, so seems
> pretty good to me:

We won't ever see it with the current paths; I threw in the EFSBADCRC to make
it clear that it's looking for "disk is ok but the contents may be junk" =>
rebuild structure.

Though now that I think about it, maybe that message should read:
"leaf block X for directory inode Y corrupt"
since at least in theory we could hit EFSCORRUPTED on a non-CRC FS.

--D

> 
> Reviewed-by: Brian Foster <bfoster@redhat.com>
> 
> >  		do_error(
> >  	_("can't read block %u for directory inode %" PRIu64 ", error %d\n"),
> >  			da_bno, ip->i_ino, error);
> > 
> > _______________________________________________
> > xfs mailing list
> > xfs@oss.sgi.com
> > http://oss.sgi.com/mailman/listinfo/xfs
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

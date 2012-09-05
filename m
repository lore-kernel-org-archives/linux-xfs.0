Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q856mnnF258180 for <xfs@oss.sgi.com>; Wed, 5 Sep 2012 01:48:49 -0500
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	K5UVu4YQDtCTaHvZ for <xfs@oss.sgi.com>;
	Tue, 04 Sep 2012 23:49:46 -0700 (PDT)
Date: Wed, 5 Sep 2012 16:49:44 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [RFC PATCH 3/4] xfs: add FREE_EOFBLOCKS ioctl
Message-ID: <20120905064944.GH15292@dastard>
References: <1346097111-4476-1-git-send-email-bfoster@redhat.com>
	<1346097111-4476-4-git-send-email-bfoster@redhat.com>
	<20120903051742.GS15292@dastard> <50460BDB.40806@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <50460BDB.40806@redhat.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Brian Foster <bfoster@redhat.com>
Cc: xfs@oss.sgi.com

On Tue, Sep 04, 2012 at 10:10:35AM -0400, Brian Foster wrote:
> On 09/03/2012 01:17 AM, Dave Chinner wrote:
> > On Mon, Aug 27, 2012 at 03:51:50PM -0400, Brian Foster wrote:
> >> The XFS_IOC_FREE_EOFBLOCKS ioctl allows users to invoke an EOFBLOCKS
> >> scan. The xfs_eofblocks structure is defined to support the command
> >> parameters (quota type/id and minimum file size).
> >>
> >> Signed-off-by: Brian Foster <bfoster@redhat.com>
> >> ---
> >>  fs/xfs/xfs_fs.h       |   10 ++++++++++
> >>  fs/xfs/xfs_ioctl.c    |   25 +++++++++++++++++++++++++
> >>  fs/xfs/xfs_quota.h    |    1 +
> >>  fs/xfs/xfs_quotaops.c |    2 +-
> >>  4 files changed, 37 insertions(+), 1 deletions(-)
> >>
> >> diff --git a/fs/xfs/xfs_fs.h b/fs/xfs/xfs_fs.h
> >> index c13fed8..6f93db9 100644
> >> --- a/fs/xfs/xfs_fs.h
> >> +++ b/fs/xfs/xfs_fs.h
> >> @@ -339,6 +339,15 @@ typedef struct xfs_error_injection {
> >>  
> >>  
> >>  /*
> >> + * Speculative preallocation trimming.
> >> + */
> >> +typedef struct xfs_eofblocks {
> >> +	__u32		id;		/* quota id */
> >> +	__u32		qtype;		/* quota type */
> >> +	__u64		min_file_size;	/* minimum file size */
> >> +} xfs_eofblocks_t;
> > 
> > No typedefs.
> > 
> 
> This is something I see throughout the code that I haven't quite
> followed (i.e., using the _t typedefs vs. not). Is the general consensus
> to move away from typedefs when possible?

Yes. The Irix code that XFS came from was full of typedefs - part
of it was to try to strictly type check things that were the same
storage size or on-disk vs in-memory. We've got other ways of doing
that better (e.g. the endian checking sparse does), and typedefs
are generally frowned upon in the main kernel code because they
often obfuscate the code rather than improve it, so we're
removing them as we modify code or write new code.

> >> +
> >> +		/*
> >> +		 * TODO: The filtering code currently uses the id in the inode.
> >> +		 * Therefore, I don't think it really matters whether the
> >> +		 * particular quota type is enabled (and the dquot is attached).
> >> +		 *
> >> +		 * Alternatively, we could filter by dquot type. This would
> >> +		 * mean we might have to make sure dquot's are attached during
> >> +		 * the scan and that the particular quota type is enabled. I'm
> >> +		 * not sure that this buys us anything.
> >> +		 */
> > 
> > If quota is not enabled, then a request to free blocks determined by
> > a quota ID is invalid and should be rejected. It's a user API - what
> > is and isn't supported needs to be written down in black and white
> > (i.e. in the xfsctl man page).
> > 
> 
> Ok. I was thinking that we could support the ability to scan by uid/gid
> regardless of whether quota is enabled, but perhaps there's no purpose
> to that if a quota isn't enabled.

I can't really think of a use case for doing this. Making the API
more expansive in future if someone needs this can be done - it's
removing stuff that is really hard to do. Hence, don't add it if it
is not going to be used immediately. :)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

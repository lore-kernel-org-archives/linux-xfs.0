Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 59FC629DF5
	for <xfs@oss.sgi.com>; Wed, 28 Oct 2015 06:51:45 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 2F40A8F8035
	for <xfs@oss.sgi.com>; Wed, 28 Oct 2015 04:51:42 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id QrpHXnTO4E2XVWy2 (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 28 Oct 2015 04:51:40 -0700 (PDT)
Date: Wed, 28 Oct 2015 07:51:39 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 0/8] xfsdump: Ouchie! My bleeding eyes!
Message-ID: <20151028115138.GB50552@bfoster.bfoster>
References: <1444959901-31319-1-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1444959901-31319-1-git-send-email-david@fromorbit.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Fri, Oct 16, 2015 at 12:44:53PM +1100, Dave Chinner wrote:
> Hi folks,
> 
> Turns out that changes to exported XFS headers in xfsprogs v4.2.0
> broke the xfsdump build. the XFS dump build was implicitly including
> the platform definitions calculated for the xfsprogs build and so
> removing them from the xfsprogs headers made xfsdump very unhappy.
> 
...
> 
> So, now the code base is a little bit cleaner, a lot less dependent
> on the xfsprogs header files, compiles cleanly on xfsprogs 3.2.x and
> 4.x releases, can easily have asserts build in or excluded (distro
> packages need to use "export DEBUG=-DNDEBUG" to exclude asserts),
> passes xfstests with asserts enabled and disabled, and best of all
> the source code is a little less eye-bleedy.
> 
> I really don't expect anyone to review this closely - it's *huge*
> chunk of boring search/replace change:
> 
>  94 files changed, 2929 insertions(+), 2652 deletions(-)
> 
> but I would like people to comment on/ack the approach I've taken
> here. If nobody objects/cares, I'll then do a 3.1.6 release early
> next week....
> 

I sent some comments on patch 1, otherwise the rest looks reasonable to
me on a quick pass through. The only thing I noticed is that the series
introduced a handful of whitespace problems. I didn't go and track them
into the individual patches, but here's the full output from my patch
import:

Applying: cleanup: get rid of ASSERT
/home/bfoster/repos/xfsdump/.git/rebase-apply/patch:3725: space before tab in indent.
        assert( namebuf );
/home/bfoster/repos/xfsdump/.git/rebase-apply/patch:5656: trailing whitespace.
        assert ( ent != NULL );
/home/bfoster/repos/xfsdump/.git/rebase-apply/patch:5855: trailing whitespace.
        assert ( ent != NULL );
warning: 3 lines add whitespace errors.
Applying: build: don't rely on xfs/xfs.h to include necessary headers
Applying: cleanup: kill intgen_t
/home/bfoster/repos/xfsdump/.git/rebase-apply/patch:2018: trailing whitespace.
static int
/home/bfoster/repos/xfsdump/.git/rebase-apply/patch:3295: space before tab in indent.
                                                int fsfd,
/home/bfoster/repos/xfsdump/.git/rebase-apply/patch:6044: trailing whitespace.
                        int namebuflen;
warning: 3 lines add whitespace errors.
Applying: cleanup: kill u_int*_t types
/home/bfoster/repos/xfsdump/.git/rebase-apply/patch:255: trailing whitespace.
static uint32_t erase_and_verify( drive_t *drivep );
/home/bfoster/repos/xfsdump/.git/rebase-apply/patch:1372: trailing whitespace.
        uint             s_max_nstreams;/* number of media streams in
/home/bfoster/repos/xfsdump/.git/rebase-apply/patch:1461: trailing whitespace.
DEBUG_displayallsessions( int fd, invt_seshdr_t *hdr, uint ref,
/home/bfoster/repos/xfsdump/.git/rebase-apply/patch:1816: trailing whitespace.
        uint16_t d_sum;
warning: 4 lines add whitespace errors.
Applying: cleanup: define a local xfs_ino_t
Applying: cleanup: use system uuid.h headers
Applying: cleanup: move fold_t out of util.h
/home/bfoster/repos/xfsdump/.git/rebase-apply/patch:85: trailing whitespace.
/* flg definitions for preemptchk
warning: 1 line adds whitespace errors.
Applying: cleanup: Kill unnecessary xfs includes

Brian

> -Dave.
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

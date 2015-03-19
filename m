Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 856867F37
	for <xfs@oss.sgi.com>; Thu, 19 Mar 2015 12:54:35 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 62142304039
	for <xfs@oss.sgi.com>; Thu, 19 Mar 2015 10:54:35 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id MH9ATg572ECPt70m (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 19 Mar 2015 10:54:34 -0700 (PDT)
Date: Thu, 19 Mar 2015 13:54:31 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 12/13] xfs_repair: don't clear . or .. in process_dir2_data
Message-ID: <20150319175431.GG11669@laptop.bfoster>
References: <1426624395-8258-1-git-send-email-sandeen@redhat.com>
	<1426624395-8258-13-git-send-email-sandeen@redhat.com>
	<20150319164716.GE11669@laptop.bfoster>
	<550B0777.10108@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <550B0777.10108@sandeen.net>
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
Cc: Eric Sandeen <sandeen@redhat.com>, xfs@oss.sgi.com

On Thu, Mar 19, 2015 at 12:29:27PM -0500, Eric Sandeen wrote:
> On 3/19/15 11:47 AM, Brian Foster wrote:
> > On Tue, Mar 17, 2015 at 03:33:14PM -0500, Eric Sandeen wrote:
> >> process_dir2_data() has special . and .. processing; it is able
> >> to correct these inodes, so there is no reason to clear them.
> >>
> >> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> >> ---
> >>  repair/dir2.c |   12 ++++++++++++
> >>  1 files changed, 12 insertions(+), 0 deletions(-)
> >>
> >> diff --git a/repair/dir2.c b/repair/dir2.c
> >> index 9e6c67d..3acf71c 100644
> >> --- a/repair/dir2.c
> >> +++ b/repair/dir2.c
> >> @@ -1331,6 +1331,18 @@ _("entry at block %u offset %" PRIdPTR " in directory inode %" PRIu64
> >>  				dep->namelen = 1;
> >>  			clearino = 1;
> >>  		}
> >> +
> >> +		/*
> >> +		 * We have a special dot & dotdot fixer-upper below which can
> >> +		 * sort out the proper inode number, so don't clear it.
> >> +		 */
> >> +		if ((dep->namelen == 1 && dep->name[0] == '.') ||
> >> +		    (dep->namelen == 2 &&
> >> +		     dep->name[0] == '.' && dep->name[1] == '.')) {
> >> +			clearino = 0;
> >> +			clearreason = NULL;
> >> +		}
> >> +		    
> > 
> > Whitespace damage on the blank line above.
> > 
> > Seems Ok, but the question I have is what happens if the dot or dotdot
> > namelen was bogus? 
> 
> If namelen is 1 and name[0] is '.', or
> if namelen is 2 and name[0] is '.' and name[1] is '..'
> 
> then how can that the len be bogus?  The test is for the name being
> either precisely '.' or '..' and nothing else, right?
> 

Ah, yeah I see. So it would be cleared in that case.

Note that just above if namelen == 0 we set it to 1. Would we have the
opposite problem for hidden files with bogus namelen (i.e., not clear
entries that we should)?

Brian

> -Eric
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

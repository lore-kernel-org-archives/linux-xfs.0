Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id CDCD77F54
	for <xfs@oss.sgi.com>; Fri, 30 Aug 2013 13:49:38 -0500 (CDT)
Date: Fri, 30 Aug 2013 13:49:38 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH] xfs: check correct status variable for
	xfs_inobt_get_rec() call
Message-ID: <20130830184938.GH1935@sgi.com>
References: <1377638145-18800-1-git-send-email-bfoster@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1377638145-18800-1-git-send-email-bfoster@redhat.com>
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

On Tue, Aug 27, 2013 at 05:15:45PM -0400, Brian Foster wrote:
> The call to xfs_inobt_get_rec() in xfs_dialloc_ag() passes 'j' as
> the output status variable. The immediately following
> XFS_WANT_CORRUPTED_GOTO() checks the value of 'i,' which is from
> the previous lookup call and has already been checked. Fix the
> corruption check to use 'j.'
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>

Applied.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 4FCE67CBF
	for <xfs@oss.sgi.com>; Mon,  5 Aug 2013 17:28:12 -0500 (CDT)
Date: Mon, 5 Aug 2013 17:28:11 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH 12/12] xfs: don't emit v5 superblock warnings on write
Message-ID: <20130805222811.GI3111@sgi.com>
References: <1370564771-4929-1-git-send-email-david@fromorbit.com>
	<1370607901-11538-1-git-send-email-david@fromorbit.com>
	<1370607901-11538-13-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1370607901-11538-13-git-send-email-david@fromorbit.com>
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

On Fri, Jun 07, 2013 at 10:25:01PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> We write the superblock every 30s or so which results in the
> verifier being called. Right now that results in this output
> every 30s:
> 
> XFS (vda): Version 5 superblock detected. This kernel has EXPERIMENTAL support enabled!
> Use of these features in this kernel is at your own risk!
> 
> And spamming the logs.
> 
> We don't need to check for whether we support v5 superblocks or
> whether there are feature bits we don't support set as these are
> only relevant when we first mount the filesytem. i.e. on superblock
> read. Hence for the write verification we can just skip all the
> checks (and hence verbose output) altogether.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Goes with commit 34510185abeaa5be9b178a41c0a03d30aec3db7e
Reviewed-by: Ben Myers <bpm@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

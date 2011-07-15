Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6FFdtPZ209918 for <xfs@oss.sgi.com>; Fri, 15 Jul 2011 10:39:55 -0500
Subject: Re: [PATCH v3] xfstests: Improve test 219 to work with different
	filesystems
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <1309363480-22268-1-git-send-email-jack@suse.cz>
References: <1309363480-22268-1-git-send-email-jack@suse.cz>
Date: Fri, 15 Jul 2011 10:39:14 -0500
Message-ID: <1310744354.2921.20.camel@doink>
MIME-Version: 1.0
Reply-To: aelder@sgi.com
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
To: Jan Kara <jack@suse.cz>
Cc: xfs@oss.sgi.com

On Wed, 2011-06-29 at 18:04 +0200, Jan Kara wrote:
> Different filesystems account different amount of metadata in quota. Thus it is
> impractical to check for a particular amount of space occupied by a file
> because there is no right value. Change the test to verify whether the amount
> of space is between the expected amount of space and the expected amount +5%.
> The number of files is checked exactly as previously.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>

Looks good.  After verifying it (at least on XFS), I
will commit this for you.

Reviewed-by: Alex Elder <aelder@sgi.com>


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

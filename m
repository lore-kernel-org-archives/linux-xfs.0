Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p8TEcF7x198031 for <xfs@oss.sgi.com>; Thu, 29 Sep 2011 09:38:15 -0500
Subject: Re: [PATCH v2] xfsdump: handle dump files with checksum bug
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <1317156572-11897-1-git-send-email-wkendall@sgi.com>
References: <1317156572-11897-1-git-send-email-wkendall@sgi.com>
Date: Thu, 29 Sep 2011 09:38:10 -0500
Message-ID: <1317307090.3049.3.camel@doink>
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
To: Bill Kendall <wkendall@sgi.com>
Cc: xfs@oss.sgi.com

On Tue, 2011-09-27 at 15:49 -0500, Bill Kendall wrote:
> xfsdump previously contained a bug in the code which generated
> a checksum on the header for extended attributes. This bug
> was recently fixed, but a new xfsrestore will fail if it
> encounters an old dump file which had checksums enabled. (This
> is unlikely since checksums have just recently been enabled in
> the build, and the above-mentioned bug was fixed at the same time.)
> 
> This patch uses a new flag in an extattrhdr_t to indicate a
> checksum is present. If this is set, the checksum is validated.
> If instead the old checksum flag is set, a warning is issued saying
> the header could not be validated, and xfsrestore will assume the
> header is valid.
> 
> Note that with this change a new dump cannot be restored with an
> old restore which has checksums enabled. But as I mentioned, old
> restores do not have checksums enabled.
> 
> Signed-off-by: Bill Kendall <wkendall@sgi.com>

Looks good.

Reviewed-by: Alex Elder <aelder@sgi.com>


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p7P4xWfM159526 for <xfs@oss.sgi.com>; Wed, 24 Aug 2011 23:59:32 -0500
Date: Thu, 25 Aug 2011 00:59:29 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/3] xfsprogs: xfs_quota: return real-time used data as
	intended
Message-ID: <20110825045929.GB23901@infradead.org>
References: <1314222823-24101-1-git-send-email-aelder@sgi.com>
	<adcfe5e08d1c060ea95a8aa43e1abade24957dd0.1314222483.git.aelder@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <adcfe5e08d1c060ea95a8aa43e1abade24957dd0.1314222483.git.aelder@sgi.com>
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
To: Alex Elder <aelder@sgi.com>
Cc: xfs@oss.sgi.com

On Wed, Aug 24, 2011 at 04:53:41PM -0500, Alex Elder wrote:
> In projects_free_space_data() the real-time used space consumption
> is never set.  Instead, that value is returned in the field that
> should hold the quota limit.
> 
> Found by inspection.  Never seen/noticed because we currently don't
> support quotas when a filesystem has a realtime volume.

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

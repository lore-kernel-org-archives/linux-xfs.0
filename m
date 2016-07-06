Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 001907CFD
	for <xfs@oss.sgi.com>; Wed,  6 Jul 2016 04:20:03 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 6C2A5AC003
	for <xfs@oss.sgi.com>; Wed,  6 Jul 2016 02:19:59 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	vFTce3IrIDKWu7as for <xfs@oss.sgi.com>;
	Wed, 06 Jul 2016 02:19:56 -0700 (PDT)
Date: Wed, 6 Jul 2016 19:19:53 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] nfsd: allow SCSI layout support without Block layout
Message-ID: <20160706091953.GD12670@dastard>
References: <74871b1ce0d09b21fb67c1b2176695cc1c19169e.1467624319.git.bcodding@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <74871b1ce0d09b21fb67c1b2176695cc1c19169e.1467624319.git.bcodding@redhat.com>
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
To: Benjamin Coddington <bcodding@redhat.com>
Cc: bfields@fieldses.org, Christoph Hellwig <hch@lst.de>, xfs@oss.sgi.com

On Tue, Jul 05, 2016 at 09:48:47PM -0400, Benjamin Coddington wrote:
> We shouldn't have to configure both NFSD_BLOCKLAYOUT and NFSD_SCSILAYOUT if
> all we want are SCSI layouts on the server, so define the xfs export
> operations for either configuration.
> 
> Signed-off-by: Benjamin Coddington <bcodding@redhat.com>

I don't really like exploding config option dependencies into
subsystems that aren't actually related to the config options.
It's confusing enough laready that we've got XFS code dependent on
PNFSD config options without adding more to it. Instead, I'd
suggest this should be resolved in the kconfig files. i.e. make
CONFIG_NFSD_SCSILAYOUT=y select CONFIG_NFSD_BLOCKLAYOUT to resolve
the config dependency at config time.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

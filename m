Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 30 May 2007 10:32:17 -0700 (PDT)
Received: from smtp104.sbc.mail.re2.yahoo.com (smtp104.sbc.mail.re2.yahoo.com [68.142.229.101])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l4UHWBWt010414
	for <xfs@oss.sgi.com>; Wed, 30 May 2007 10:32:13 -0700
Date: Wed, 30 May 2007 10:05:30 -0700
From: Chris Wedgwood <cw@f00f.org>
Subject: Re: [patch 1/3] Fix XFS_IOC_FSGEOMETRY_V1 in compat mode
Message-ID: <20070530170530.GA4197@tuatara.stupidest.org>
References: <20070530125954.706423971@suse.cz> <20070530143043.216024061@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070530143043.216024061@suse.cz>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Michal Marek <mmarek@suse.cz>
Cc: xfs@oss.sgi.com, linux-kernel@vger.kernel.org

On Wed, May 30, 2007 at 02:59:55PM +0200, Michal Marek wrote:

> +typedef struct xfs_fsop_geom_v132 {

wouldn't xfs_fsop_geom_v1_32
                         ^

> +	__u32		blocksize;	/* filesystem (data) block size */

[...]

> +	__u32		dirblocksize;	/* directory block size, bytes	*/
> +} __attribute__((packed)) xfs_fsop_geom_v132_t;

and xfs_fsop_geom_v1_32_t
                    ^

read better there?

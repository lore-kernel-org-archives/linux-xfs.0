Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail01.adl2.internode.on.net ([150.101.137.133]:22579 "EHLO
        ipmail01.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752918AbeFHWSi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 8 Jun 2018 18:18:38 -0400
Date: Sat, 9 Jun 2018 08:18:34 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v5 4/4] mkfs.xfs: add configuration file parsing support
 using our own parser
Message-ID: <20180608221833.GB10363@dastard>
References: <20180607235533.20391-1-mcgrof@kernel.org>
 <20180607235533.20391-5-mcgrof@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180607235533.20391-5-mcgrof@kernel.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Luis R. Rodriguez" <mcgrof@kernel.org>
Cc: sandeen@sandeen.net, linux-xfs@vger.kernel.org, darrick.wong@oracle.com, jack@suse.com, jeffm@suse.com, okurz@suse.com, lpechacek@suse.com, jtulak@redhat.com

Just because Eric questioned this on IRC:

On Thu, Jun 07, 2018 at 04:55:33PM -0700, Luis R. Rodriguez wrote:
> -	/* copy new defaults into CLI parsing structure */
> +	/*
> +	 * Pull config line options from command line
> +	 */
> +	while ((c = getopt(argc, argv, "b:c:d:i:l:L:m:n:KNp:qr:s:CfV")) != EOF) {

	opterr = 0;
	while ((c = getopt(argc, argv, "c:")) != EOF) {

And then reset opterr = 1 when optind gets reset so it warns about
unknown options again.

It's in the man page!

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

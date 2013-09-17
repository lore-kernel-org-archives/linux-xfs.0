Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 1AF8A7F4E
	for <xfs@oss.sgi.com>; Tue, 17 Sep 2013 16:29:22 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id ECC0E30405F
	for <xfs@oss.sgi.com>; Tue, 17 Sep 2013 14:29:21 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	Cdh6phk3m5p0eeo6 for <xfs@oss.sgi.com>;
	Tue, 17 Sep 2013 14:29:20 -0700 (PDT)
Date: Wed, 18 Sep 2013 07:29:17 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfstests: xfs directory unbalance assert test
Message-ID: <20130917212917.GK19103@dastard>
References: <20130917145946.124195107@sgi.com>
	<20130917145959.333796933@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130917145959.333796933@sgi.com>
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
To: Mark Tinguely <tinguely@sgi.com>
Cc: xfs@oss.sgi.com

On Tue, Sep 17, 2013 at 09:59:47AM -0500, Mark Tinguely wrote:
> +# Fill the filesystem.
> +FSSTRESS_ARGS="-z -s 1378390208 -fsymlink=1 -n7500000 -p4 -d $SCRATCH_MNT"
> +$FSSTRESS_PROG $FSSTRESS_ARGS >> $seqres.full 2>&1
> +
> +cd $SCRATCH_MNT >> $seqres.full 2>&1
> +sync
> +# A debug XFS may assert in the remove due to a directory bug.
> +rm -rf *

Wouldn't this be better:

sync
rm -rf $SCRATCH_MNT/*

Remember, xfstests runs as root and so having a "rm -rf *" anywhere
in a test is a disaster just waiting to happen....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

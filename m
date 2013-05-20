Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 6E5DB7F37
	for <xfs@oss.sgi.com>; Mon, 20 May 2013 06:30:54 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 08AB1AC003
	for <xfs@oss.sgi.com>; Mon, 20 May 2013 04:30:50 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	vwAOSBOHYNCUnV9Z for <xfs@oss.sgi.com>;
	Mon, 20 May 2013 04:30:49 -0700 (PDT)
Date: Mon, 20 May 2013 21:30:45 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfstests comma separated group names
Message-ID: <20130520113045.GB24543@dastard>
References: <CANW9uytRpGXcd9x=HWMEoFvd3_9G98CN_Tv3YacTtd1h+Gq=4g@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CANW9uytRpGXcd9x=HWMEoFvd3_9G98CN_Tv3YacTtd1h+Gq=4g@mail.gmail.com>
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
To: Itaru Kitayama <itaru.kitayama@gmail.com>
Cc: xfs@oss.sgi.com

On Mon, May 20, 2013 at 05:29:29PM +0900, Itaru Kitayama wrote:
> This patch lets the -g option take multiple group names.
> 
> Signed-off-By: Itaru Kitayama <itaru.kitayama@gmail.com>

You can already run multiple test groups by specifying multiple -g
options. e.g:

# check -g rw -g attr

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

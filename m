Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 63D797F4C
	for <xfs@oss.sgi.com>; Sun, 26 May 2013 18:13:34 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 0F6B9AC001
	for <xfs@oss.sgi.com>; Sun, 26 May 2013 16:13:30 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	M6tQBJMs7lgsiShx for <xfs@oss.sgi.com>;
	Sun, 26 May 2013 16:13:29 -0700 (PDT)
Date: Mon, 27 May 2013 09:13:00 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfstests: cleanup the codes related to h_chksum
Message-ID: <20130526231300.GP24543@dastard>
References: <1369523732-10649-1-git-send-email-zwu.kernel@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1369523732-10649-1-git-send-email-zwu.kernel@gmail.com>
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
To: zwu.kernel@gmail.com
Cc: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>, xfs@oss.sgi.com

On Sun, May 26, 2013 at 07:15:32AM +0800, zwu.kernel@gmail.com wrote:
> From: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
> 
>   Since h_chksum field has gone away, we should cleanup the related codes
> 
>     [CC]    loggen
> loggen.c: In function 'loggen_unmount':
> loggen.c:137:9: error: 'xlog_rec_header_t' has no member named 'h_chksum'
> loggen.c: In function 'loggen_empty':
> loggen.c:205:9: error: 'xlog_rec_header_t' has no member named 'h_chksum'
> 
> Signed-off-by: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>

Looks fine.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

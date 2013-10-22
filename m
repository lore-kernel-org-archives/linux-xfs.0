Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 3AC207F50
	for <xfs@oss.sgi.com>; Tue, 22 Oct 2013 18:26:33 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 21D3730408C
	for <xfs@oss.sgi.com>; Tue, 22 Oct 2013 16:26:33 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	nQkt4MEwWo9XDmnh for <xfs@oss.sgi.com>;
	Tue, 22 Oct 2013 16:26:31 -0700 (PDT)
Date: Wed, 23 Oct 2013 10:26:29 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v3 4/4] xfsprog: add mkfs.xfs sb v4 support for dirent
	filetype field
Message-ID: <20131022232629.GI2797@dastard>
References: <20131017152804.204045257@sgi.com>
	<20131017152955.689963160@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131017152955.689963160@sgi.com>
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

On Thu, Oct 17, 2013 at 10:28:08AM -0500, Mark Tinguely wrote:
> Add directory inode type feature to mkfs.xfs and its manual page.
> 
> In sb v4, "mkfs.xfs -n ftype=1" turns on the feature.
> 
> The feature is automatically turned on for "-m crc=1", but reject
> the use of the "-n ftype=0|1" with the "-m crc=1" option.
> 
> Signed-off-by: Mark Tinguely <tinguely@sgi.com>

Looks OK now.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

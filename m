Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 959D729E04
	for <xfs@oss.sgi.com>; Mon, 18 Nov 2013 16:26:56 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 83956304039
	for <xfs@oss.sgi.com>; Mon, 18 Nov 2013 14:26:53 -0800 (PST)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	jSMqE3sIy3BkuGYd for <xfs@oss.sgi.com>;
	Mon, 18 Nov 2013 14:26:51 -0800 (PST)
Date: Tue, 19 Nov 2013 09:26:47 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH V2] xfsprogs: suggest "-d" option for repair of RO mount
Message-ID: <20131118222647.GV6188@dastard>
References: <528261AD.50501@redhat.com>
 <528A39FD.5090109@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <528A39FD.5090109@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Eric Sandeen <sandeen@redhat.com>, xfs-oss <xfs@oss.sgi.com>

On Mon, Nov 18, 2013 at 10:02:05AM -0600, Eric Sandeen wrote:
> We can offer the suggestion of a "-d" repair, if we're
> in single-user mode with i.e. the root fs mounted readonly.
> 
> This change suggests -d to repair any RO mounted fs.
> 
> e2fsck allows this, and users are used to being able to
> do it in single-user mode.  A separate patch will recommend
> a reboot after repair completes.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> 
> V2: Now with more danger!

Exciting! Looks good.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

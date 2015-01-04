Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 739D77F51
	for <xfs@oss.sgi.com>; Sun,  4 Jan 2015 16:47:56 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 4573E8F8033
	for <xfs@oss.sgi.com>; Sun,  4 Jan 2015 14:47:53 -0800 (PST)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	0BR3Lv0k5qhccDHX for <xfs@oss.sgi.com>;
	Sun, 04 Jan 2015 14:47:46 -0800 (PST)
Date: Mon, 5 Jan 2015 09:47:43 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [3.18.1] Lockdep detected a potential deadlock
Message-ID: <20150104224743.GO24183@dastard>
References: <54A80E66.3050803@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <54A80E66.3050803@gmail.com>
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
To: "Alexander E. Patrakov" <patrakov@gmail.com>
Cc: xfs@oss.sgi.com

On Sat, Jan 03, 2015 at 08:44:38PM +0500, Alexander E. Patrakov wrote:
> Hello.
> 
> In my dmesg, I found a warning about a potential deadlock, and xfs
> is mentioned there. The dmesg is attached. Could you please look?

http://oss.sgi.com/archives/xfs/2014-10/msg00319.html

The VFS splice locking architecture is broken - nothing we can do
about that in XFS....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

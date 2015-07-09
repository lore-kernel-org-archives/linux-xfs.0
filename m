Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 0D9107F37
	for <xfs@oss.sgi.com>; Wed,  8 Jul 2015 20:58:31 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id D878D304043
	for <xfs@oss.sgi.com>; Wed,  8 Jul 2015 18:58:30 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	QzPAqdNGi8xpQ8ob for <xfs@oss.sgi.com>;
	Wed, 08 Jul 2015 18:58:28 -0700 (PDT)
Date: Thu, 9 Jul 2015 11:58:25 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Possible memory allocation deadlock in kmem_alloc and hung task
	in xfs_log_commit_cil and xlog_cil_push
Message-ID: <20150709015825.GG3902@dastard>
References: <CA+eFSM30A1V7j4CYJOyLSN7V7REHt0hrxteU1dVRw4HQZLmuxw@mail.gmail.com>
	<20150707233743.GZ7943@dastard>
	<CA+eFSM2mSSW-BtP5-ArHREPu9sRRO3=J8acWJ-h_iZHfLPnhiw@mail.gmail.com>
	<559D2E52.2070900@unitedstack.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <559D2E52.2070900@unitedstack.com>
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
To: juncheng bai <baijuncheng@unitedstack.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, Gavin Guo <gavin.guo@canonical.com>, xfs@oss.sgi.com

On Wed, Jul 08, 2015 at 10:06:10PM +0800, juncheng bai wrote:
> Hi, All
> 
> As far as I know, the patch b3f03bac8132207a20286d5602eda64500c19724
> solves one case which big directory size.
> 
> I am not very familiar with xfs, but I think why can't we use vmalloc
> when kmalloc fails?

Because vmalloc space is greatly limited on 32 bit machines and
hence we can't just use vmalloc blindly in these situations.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

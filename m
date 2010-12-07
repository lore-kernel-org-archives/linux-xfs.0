Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oB7MCxTa232191 for <xfs@oss.sgi.com>; Tue, 7 Dec 2010 16:12:59 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 479BA1CA2F15
	for <xfs@oss.sgi.com>; Tue,  7 Dec 2010 14:14:46 -0800 (PST)
Received: from mail.internode.on.net (bld-mail12.adl6.internode.on.net
	[150.101.137.97]) by cuda.sgi.com with ESMTP id
	ZLHrCStwSBJbsx1F for <xfs@oss.sgi.com>;
	Tue, 07 Dec 2010 14:14:46 -0800 (PST)
Date: Wed, 8 Dec 2010 09:14:43 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfs_count_page_state inside kswapd
Message-ID: <20101207221443.GB29333@dastard>
References: <AANLkTi=2WUJGyf-_moOMKWsR1F29a48LgpziXaLNLtxz@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <AANLkTi=2WUJGyf-_moOMKWsR1F29a48LgpziXaLNLtxz@mail.gmail.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Tharindu Rukshan Bamunuarachchi <btharindu@gmail.com>
Cc: xfs@oss.sgi.com

On Tue, Dec 07, 2010 at 06:26:52PM +0530, Tharindu Rukshan Bamunuarachchi wrote:
> Dear All,
> 
> We got following oops in one of our SLES 11 server. This occurred inside
> swapd and we running our server swap turned off..
> 
> Could this be memory corruption or possible old bug in code ?

No idea - the SLES11 kernel is lots of non-standard stuff in it
compared to mainline (e.g. the XFS code has DMAPI support) and you
are running a kernel with Novell supported kernel modules loaded
(all the IB stuff). Your best bet is to contact your SLES support
representative to see if they know of such a problem...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

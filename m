Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mB55iNSx015791 for <xfs@oss.sgi.com>; Thu, 4 Dec 2008 23:44:24 -0600
Message-ID: <4938BFAE.5090504@sgi.com>
Date: Fri, 05 Dec 2008 16:44:14 +1100
From: Timothy Shimmin <tes@sgi.com>
MIME-Version: 1.0
Subject: Re: Device loses barrier support
References: <Pine.LNX.4.64.0812040009340.15169@hs20-bc2-1.build.redhat.com>	<20081204100050.GN6703@one.firstfloor.org>	<Pine.LNX.4.64.0812040836480.6118@hs20-bc2-1.build.redhat.com>	<20081204142015.GQ6703@one.firstfloor.org>	<Pine.LNX.4.64.0812040913510.6118@hs20-bc2-1.build.redhat.com>
	<20081204145810.GR6703@one.firstfloor.org>
In-Reply-To: <20081204145810.GR6703@one.firstfloor.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
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
To: Andi Kleen <andi@firstfloor.org>
Cc: Andi Kleen <andi-suse@firstfloor.org>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, Mikulas Patocka <mpatocka@redhat.com>, Alasdair G Kergon <agk@redhat.com>, Milan Broz <mbroz@redhat.com>

Andi Kleen wrote:
> The write block with barrier bit varies, jbd/gfs2 do it synchronously
> too and xfs does it asynchronously (with io done callbacks), but
> in both cases they handle an EOPNOTSUPP comming out in the final
> io done.
> 
Yes, XFS handles it, however,
it doesn't look like we currently propagate the EOPNOTSUPP
up to where we test it (not set for b_error).
Patch disscussed recently on xfs list to rectify this.

--Tim

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

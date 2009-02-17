Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n1HIj6D4241854 for <xfs@oss.sgi.com>; Tue, 17 Feb 2009 12:45:06 -0600
Received: from mx2.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2E6ED1956FF0
	for <xfs@oss.sgi.com>; Tue, 17 Feb 2009 10:44:31 -0800 (PST)
Received: from mx2.redhat.com (mx2.redhat.com [66.187.237.31]) by cuda.sgi.com
	with ESMTP id 0GuGy54rsgeXUx08 for <xfs@oss.sgi.com>;
	Tue, 17 Feb 2009 10:44:31 -0800 (PST)
Message-ID: <499AF2DF.3060101@sandeen.net>
Date: Tue, 17 Feb 2009 11:24:47 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: xfs problems (possibly after upgrading from linux kernel 2.6.27.10
	to .14)
References: <499ACE6C.4060304@aei.mpg.de>
In-Reply-To: <499ACE6C.4060304@aei.mpg.de>
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
To: Carsten Aulbert <carsten.aulbert@aei.mpg.de>
Cc: linux-kernel@vger.kernel.org, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

Carsten Aulbert wrote:
> Hi all,
> 
> within the past few days we hit many XFS internal errors like these. Are these
> errors known (and possibly already fixed)? I checked the commits till 
> 2.6.27.17 and there does not seem anything related to this.
> 
> Do you need more information or can I send these nodes into a re-install?
> 
> Cheers
> 
> Carsten
> 
> PS: Please CC me, as I'm currently not on this list.

It'd be worth running xfs_repair on one of these nodes, I think, to see
if you're encountering on-disk corruption, which is what this looks like.

Anything funky about your storage?  Any IO/storage issues before this?
Does going back to .10 make it go away?

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

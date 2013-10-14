Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 45CDE7F37
	for <xfs@oss.sgi.com>; Mon, 14 Oct 2013 16:17:08 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 34E798F8035
	for <xfs@oss.sgi.com>; Mon, 14 Oct 2013 14:17:05 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	50IabFZCBDfV4gLz for <xfs@oss.sgi.com>;
	Mon, 14 Oct 2013 14:17:01 -0700 (PDT)
Date: Tue, 15 Oct 2013 08:16:59 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: projid32bit=1 default in xfsprogs-3.2.0
Message-ID: <20131014211659.GI5663@dastard>
References: <525C1C15.7020204@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <525C1C15.7020204@sandeen.net>
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
Cc: xfs-oss <xfs@oss.sgi.com>

On Mon, Oct 14, 2013 at 11:30:13AM -0500, Eric Sandeen wrote:
> The commit:
> 
> f3edb66a mkfs.xfs: validate options for CRCs up front.
> 
> unintentionally (?) defaulted to projid32bit=1 for all filesystems
> at mkfs time.

It wasn't unintentional, I just forgot to document it.

> Support for 32 bit project IDs has been present since kernel v2.6.37.

Right, so taking the usual approach to these things, all the
distro's now ship kernels that support 32 bit project IDs, so there
is no reason for mkfs.xfs in a new xfsprogs release not to set it
by default.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

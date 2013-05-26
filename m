Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 949CE7F37
	for <xfs@oss.sgi.com>; Sun, 26 May 2013 18:11:28 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 83D928F8033
	for <xfs@oss.sgi.com>; Sun, 26 May 2013 16:11:25 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	NYN6GDMUMfY7wv1O for <xfs@oss.sgi.com>;
	Sun, 26 May 2013 16:11:24 -0700 (PDT)
Date: Mon, 27 May 2013 09:11:22 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfsprogs: is it one issue?
Message-ID: <20130526231122.GO24543@dastard>
References: <CAEH94LjnVn-uD6cfwOcChC4wq1PppcD8BN30F93SD=YjdTbbuw@mail.gmail.com>
	<51A1144A.4020600@gmail.com>
	<CAEH94LgWQcjSMenoT3a81pLWbw2pEYWpKFyGwoxAvDX2FTwbXA@mail.gmail.com>
	<CAEH94Lj4_8PBbhdD2f-ZFG=NxgS2uBkGUfaQvct71H4X7giPZA@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAEH94Lj4_8PBbhdD2f-ZFG=NxgS2uBkGUfaQvct71H4X7giPZA@mail.gmail.com>
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
To: Zhi Yong Wu <zwu.kernel@gmail.com>
Cc: "Michael L. Semon" <mlsemon35@gmail.com>, xfs@oss.sgi.com

On Sun, May 26, 2013 at 07:11:03AM +0800, Zhi Yong Wu wrote:
> I remove the lines related to h_chksum, then it can work well, so i
> guess that i should send out one patch to fix it.

While it will make the code in loggen work the same (it just writes
0 to the field but the buffer is already zeroed) as it does now,
it doesn't necessarily mean it works correctly. The current kernels
validate the CRC and throw warnings if the CRC isn't correct, and
CRC enabled kernels will simply refuse to mount.

As it is, my test systems don't build loggen because
HAVE_XLOG_ASSIGN_LSN isn't set by configure. It only gets set if
there's an xfs/libxfs.h header file found in an include path. My
guess is that you've run 'make install-qa' in the xfsprogs package
at some time in the past, and that's why loggen is trying to be
built.

So Michael's quick hack to remove it just to make it compile at this
point is probably appropriate...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

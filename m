Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id F07487F3F
	for <xfs@oss.sgi.com>; Sun, 27 Apr 2014 11:07:06 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id D20C5304032
	for <xfs@oss.sgi.com>; Sun, 27 Apr 2014 09:07:03 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id Bh4cipuOY13mHBB2 for <xfs@oss.sgi.com>;
	Sun, 27 Apr 2014 09:07:01 -0700 (PDT)
Message-ID: <535D2B26.4010702@sandeen.net>
Date: Sun, 27 Apr 2014 11:07:02 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: How to find the inodes in XFS
References: <CACyNnZMtP87y6VHum+J4xKEZqaYp2YERVnt3YuaCmeiZBmMTzQ@mail.gmail.com>	<5359912A.70603@sandeen.net>	<CACyNnZPV89C87DggE4fiJX+_r3zh1hKhcX3ExmXRzpLLhWJ6CQ@mail.gmail.com>	<535AE19D.8@sandeen.net>	<CACyNnZPzJGCQf5FYm+Oqkw5U3Ggm8wQd5LKC5Jnwiyksa-K1OA@mail.gmail.com>
	<CACyNnZMgSYdC+-=M6hYarAAUEZexc=HwD4Tn2AnO2DP=vGN6Hw@mail.gmail.com>
In-Reply-To: <CACyNnZMgSYdC+-=M6hYarAAUEZexc=HwD4Tn2AnO2DP=vGN6Hw@mail.gmail.com>
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
To: Felipe Monteiro de Carvalho <felipemonteiro.carvalho@gmail.com>
Cc: xfs@oss.sgi.com

On 4/27/14, 10:53 AM, Felipe Monteiro de Carvalho wrote:
> Maybe my flaw is that to get the disk position I simply multiply the
> block number by the size of a block ... I tryed to use
> XFS_FSB_TO_DADDR instead but it gives 64 for block nr 8, which doesn't
> make much sense, I'd expect 0x8000

if you have 4k blocks, filesystem block #8 is at 32k, or 64 512-byte
"daddrs" so that is correct.  A "DADDR" is in 512-byte units.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

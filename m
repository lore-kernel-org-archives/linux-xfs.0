Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 3C9B47F51
	for <xfs@oss.sgi.com>; Mon,  3 Nov 2014 14:39:51 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 288D18F8033
	for <xfs@oss.sgi.com>; Mon,  3 Nov 2014 12:39:50 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id xnV1bnYQ0OePuHUG for <xfs@oss.sgi.com>;
	Mon, 03 Nov 2014 12:39:49 -0800 (PST)
Message-ID: <5457E813.6030606@sandeen.net>
Date: Mon, 03 Nov 2014 14:39:47 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: clone of filesystem across network preserving ionodes
References: <8688BD11DAC0574AA90295127E9E9F4AC047F1CA@exchangewes8.wesad.wesleyan.edu>
In-Reply-To: <8688BD11DAC0574AA90295127E9E9F4AC047F1CA@exchangewes8.wesad.wesleyan.edu>
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
To: "Meij, Henk" <hmeij@wesleyan.edu>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On 11/3/14 2:35 PM, Meij, Henk wrote:
> What is the best practice way to get the contents from server1 to
> server2 identical disk array partitions and preserve the ionode
> information using xfs tools or non-xfs tools?

Just FWIW: inode, not ionode.  :)

> xfsdump/xfsrestore appear to not preserve this or I can not find the
> obvious setting.

> xfs_copy would, per documentation, but can I get from server1 to
> server2?

xfs_copy makes an identical image, yes.

You could xfs_copy from disk to a file on server1, transfer the file,
then xfs_copy from file to disk on server2.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

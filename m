Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id AB0917F56
	for <xfs@oss.sgi.com>; Mon,  3 Nov 2014 15:10:17 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 34F788F8033
	for <xfs@oss.sgi.com>; Mon,  3 Nov 2014 13:10:14 -0800 (PST)
Received: from internal-smtp3.wesleyan.edu (internal-smtp3.wesleyan.edu
	[129.133.6.182]) by cuda.sgi.com with ESMTP id fVBoiSOJtHHVDXoC
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 03 Nov 2014 13:10:12 -0800 (PST)
From: "Meij, Henk" <hmeij@wesleyan.edu>
Subject: RE: clone of filesystem across network preserving ionodes
Date: Mon, 3 Nov 2014 21:10:10 +0000
Message-ID: <8688BD11DAC0574AA90295127E9E9F4AC047F22D@exchangewes8.wesad.wesleyan.edu>
References: <8688BD11DAC0574AA90295127E9E9F4AC047F1CA@exchangewes8.wesad.wesleyan.edu>,
	<5457E813.6030606@sandeen.net>
In-Reply-To: <5457E813.6030606@sandeen.net>
Content-Language: en-US
MIME-Version: 1.0
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
To: Eric Sandeen <sandeen@sandeen.net>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

inodes, yes, yes.  I tried xfs_copy but ran into a problem. server1 and server2 each have 4x28T partitions and on server1 writing the file to one empty partition mounted never finishes, hangs at 90%...presumably because it runs out of space (file size == sdbx). there is no "skip empty inodes" option and perhaps there can't be...and I have nothing larger. I guess I could attempt making sdb4 slightly larger by reducing sdb1-3.

Thanks,
-Henk

________________________________________
From: Eric Sandeen [sandeen@sandeen.net]
Sent: Monday, November 03, 2014 3:39 PM
To: Meij, Henk; xfs@oss.sgi.com
Subject: Re: clone of filesystem across network preserving ionodes

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

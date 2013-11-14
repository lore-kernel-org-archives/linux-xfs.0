Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 1FE8A7F50
	for <xfs@oss.sgi.com>; Thu, 14 Nov 2013 12:04:16 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id ABA01AC009
	for <xfs@oss.sgi.com>; Thu, 14 Nov 2013 10:04:12 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id ssIFSN2AYMTS0W71 for <xfs@oss.sgi.com>;
	Thu, 14 Nov 2013 10:04:11 -0800 (PST)
Message-ID: <52851099.2050707@sandeen.net>
Date: Thu, 14 Nov 2013 12:04:09 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: xfs_repair
References: <CAD5ewrp2X_CyffUt6KUCd9bRE-BJ9_Q2OmZuzPv+d1VBf09OyA@mail.gmail.com>
In-Reply-To: <CAD5ewrp2X_CyffUt6KUCd9bRE-BJ9_Q2OmZuzPv+d1VBf09OyA@mail.gmail.com>
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
To: Roman Hlynovskiy <roman.hlynovskiy@gmail.com>, xfs@oss.sgi.com

On 11/14/13, 11:51 AM, Roman Hlynovskiy wrote:
> hello, after a server crush we are trying to get back access to data on another server.
> 
> out setup is the following:
> 4 disks in md-array, lvm over it and xfs
> 
> xfs_check just stops with 'out of memory error'

xfs_check is deprecated & doesn't scale; don't bother.
Use xfs_repair -n if you want a readonly check.

> xfs_repair after a long list of complains says:
> 
> corrupt dinode 2473604576, extent total = 1, nblocks = 0.  This is a bug.
> Please capture the filesystem metadata with xfs_metadump and
> report it to xfs@oss.sgi.com <mailto:xfs@oss.sgi.com>.
> cache_node_purge: refcount was 1, not zero (node=0xb43ab688)
> 
> fatal error -- 117 - couldn't iget disconnected inode

Are you using latest xfsprogs?

> I captured this metadata file, but it's 2GB size.
> is there a chance to fix the fs?

how big is it if you compress it?

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

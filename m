Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id D861929DF8
	for <xfs@oss.sgi.com>; Fri, 13 Dec 2013 07:33:17 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id C53C5304059
	for <xfs@oss.sgi.com>; Fri, 13 Dec 2013 05:33:11 -0800 (PST)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id p2zrGFIremQhRQMi (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 13 Dec 2013 05:32:43 -0800 (PST)
Message-ID: <52AB0C59.4070904@oracle.com>
Date: Fri, 13 Dec 2013 21:32:09 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfs: return ENOSPC when trying to set more ACLs than
	XFS_ACL_MAX_ENTRIES
References: <52921D12.7040104@oracle.com>
	<5292C557.9020008@sandeen.net>	<5292D8AB.5080003@oracle.com>
	<20131211193622.GG1935@sgi.com>
	<20131213130432.GB22594@infradead.org>
In-Reply-To: <20131213130432.GB22594@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>, Ben Myers <bpm@sgi.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On 12/13 2013 21:04 PM, Christoph Hellwig wrote:
> On Wed, Dec 11, 2013 at 01:36:22PM -0600, Ben Myers wrote:
>>>> (I guess looking at ext4, it uses ENOSPC for some similar constraints,
>>>> so maybe three is precedent for this)
>>> Btrfs also uses ENOSPC, but JFS would return something like "Argument list too long"
>>> in this case.
> 
> I think ENOSPC is a really bad idea in this case, but I also think we
> should make sure Linux filesystems behave unfiformly.
> 
> Jeff, can you write a summary of the errors returned by all common
> filesystems and post it to -fsdevel for comment?  We should have a
> common error for this, and I'd be a happier man if it weren't ENOSPC,
> but that's secondary.
Yep, let me gather up those info...

Thanks,
-Jeff

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

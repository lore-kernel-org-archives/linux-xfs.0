Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id ED70A7F92
	for <xfs@oss.sgi.com>; Fri, 16 Oct 2015 11:29:26 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id BDCAE304032
	for <xfs@oss.sgi.com>; Fri, 16 Oct 2015 09:29:23 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id LuJBdAEdlTpiI2lF for <xfs@oss.sgi.com>;
	Fri, 16 Oct 2015 09:29:20 -0700 (PDT)
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.4])
	(using TLSv1.2 with cipher DHE-RSA-AES128-SHA (128/128 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id 3804E63BCF80
	for <xfs@oss.sgi.com>; Fri, 16 Oct 2015 11:29:20 -0500 (CDT)
Subject: Re: Error in `xfs_repair': double free or corruption
References: <trinity-74aaa980-3667-4c6d-9e1e-60f3f70dc888-1445005584585@3capp-gmx-bs54>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <562125DF.3050006@sandeen.net>
Date: Fri, 16 Oct 2015 11:29:19 -0500
MIME-Version: 1.0
In-Reply-To: <trinity-74aaa980-3667-4c6d-9e1e-60f3f70dc888-1445005584585@3capp-gmx-bs54>
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
To: xfs@oss.sgi.com



On 10/16/15 9:26 AM, Dragon wrote:
> Hello Emmanuel,
> 
> kernel version is 3.16-0.bpo.2-amd64 and xfsprogs in version 3.2.1
> from stable. the question is if xfs_repair can repair a raid which
> has missed a disk with over 240gb bad blocks.

Well, we shouldn't hit that "double free or corruption" bug.  But you
have an old xfsprogs, so the suggestion of using something up to date
is a good one.

As for "can xfs_repair repair a raid which is missing a disk with 240g
of bad blocks?" -

xfs_repair cannot make something out of nothing; it should always end
up with a filesystem which has consistent metadata, but that might be
the result of throwing away a lot of un-fixable things.

All too often I see people try to use xfs_repair on a raid which is
in bad shape; not properly reassembled, etc, and that's only going to
make things worse.  You must get your storage into the best shape you
can, first, and then xfs_repair will do its best to create consistency,
but it cannot recreate lost (meta)data, in general.

Running xfs_repair -n, or creating a metadump image, and running a full
repair on that as a test, is often a good idea before you commit to
changes on your original filesystem.

-Eric

> gretings
> 
> 
>     Hello,
>     i have a problem after repaired a degraded Softare Raid6. System is
>     Debian Jessi and Root and Boot are on Raid1, and Data on Raid6 on md2
>     which miss one Disk. The mainproblem was a missing Disk because of
>     badblocks which i cloned and exchanged agains a new one. After that i
>     could successfully rebuild the raid (md2), while now only one disk is
>     midding. But i recognised that xfs reports inode problems. Therefor i
>     run xfs_repair on the raid device md2, but get message "Error in
>     &#96;xfs_repair': double free or corruption" What can i do the fix
>     this? thx 
> 
> 
> You didn't provide enough information (kernel and xfs-progs version at
> the very least) but you should use the latest version of xfs_repair, the
> one included in Debian is probably quite old. Here's one new:
> 
> http://update.intellique.com/pub/xfs_repair-4.2.0.gz
> 
> Or if you like it better in debian form:
> http://update.intellique.com/repository/pool/storiq3/unstable/amd64/xfsprogs_4.2.0+1_amd64.deb
> 
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

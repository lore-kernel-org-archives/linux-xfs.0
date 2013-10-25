Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id B9ACA7F3F
	for <xfs@oss.sgi.com>; Fri, 25 Oct 2013 10:12:52 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 51D15AC014
	for <xfs@oss.sgi.com>; Fri, 25 Oct 2013 08:12:49 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id yubwb5pTLfDZc1Vo for <xfs@oss.sgi.com>;
	Fri, 25 Oct 2013 08:12:48 -0700 (PDT)
Message-ID: <526A8A6E.4050402@sandeen.net>
Date: Fri, 25 Oct 2013 10:12:46 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: Aw: Re: xfs_repair segfaulting in phase 3
References: <trinity-9e6d7620-812f-48a7-9a7e-3098368ff59a-1376307533158@3capp-gmx-bs36>,
	<52273823.6050704@sandeen.net>
	<trinity-561a8e56-e327-4695-b591-ab534badbca2-1382700222681@3capp-gmx-bs25>
In-Reply-To: <trinity-561a8e56-e327-4695-b591-ab534badbca2-1382700222681@3capp-gmx-bs25>
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
To: Jan Yves Brueckner <jyb@gmx.com>
Cc: xfs@oss.sgi.com

On 10/25/13 6:23 AM, Jan Yves Brueckner wrote:
> Thanks a lot for taking care, 
>  
> I just teted with 3.2 alpha1 and had these results:
>  
> corrupt block 21 in directory inode 39869938
>         will junk block
> xfs_dir3_data_read_verify: XFS_CORRUPTION_ERROR
> corrupt block 34 in directory inode 39869938
>         will junk block
> xfs_dir3_data_read_verify: XFS_CORRUPTION_ERROR
> corrupt block 35 in directory inode 39869938
>         will junk block
> xfs_dir3_data_read_verify: XFS_CORRUPTION_ERROR
> corrupt block 51 in directory inode 39869938
>         will junk block
> xfs_da3_node_read_verify: XFS_CORRUPTION_ERROR
> Segmentation fault
>  
>  
> Should I go on with git latest?

Hm, trying to remember which "3 patches" I referred to.  ;)

This one:

commit 44dae5e6804408b4123a916a2738b73e21d8c61e
Author: Eric Sandeen <sandeen@sandeen.net>
Date:   Thu Sep 12 20:56:36 2013 +0000

    xfs_repair: test for bad level in dir2 node

is indeed committed post 3.2.0-alpha1.

Let me try to remember what the other two were, and where
they're at.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

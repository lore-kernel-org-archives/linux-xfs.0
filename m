Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p5GG8O2l045297
	for <linux-xfs@oss.sgi.com>; Thu, 16 Jun 2011 11:08:25 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0048E11E3DB1
	for <linux-xfs@oss.sgi.com>; Thu, 16 Jun 2011 09:08:23 -0700 (PDT)
Received: from mail.sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com
	with ESMTP id Nnr7kR9r1qL2rd4m for <linux-xfs@oss.sgi.com>;
	Thu, 16 Jun 2011 09:08:23 -0700 (PDT)
Message-ID: <4DFA2A76.6000104@sandeen.net>
Date: Thu, 16 Jun 2011 11:08:22 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: sparse file handling bug in XFS
References: <081DDE43F61F3D43929A181B477DCA95639B561F@MSXAOA6.twosigma.com>
In-Reply-To: <081DDE43F61F3D43929A181B477DCA95639B561F@MSXAOA6.twosigma.com>
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
To: Sean Noonan <Sean.Noonan@twosigma.com>
Cc: "'linux-xfs@oss.sgi.com'" <linux-xfs@oss.sgi.com>, Martin Bligh <Martin.Bligh@twosigma.com>, Stephen Degler <Stephen.Degler@twosigma.com>, Ian Baum <Ian.Baum@twosigma.com>, Trammell Hudson <Trammell.Hudson@twosigma.com>

On 6/16/11 9:49 AM, Sean Noonan wrote:
> Sparse files do not stay sparse.
> Here's the simplest test case I've got so far.  I don't think it can get much simpler than this.
> 
> This did not exist in 2.6.36.  It appeared by 2.6.38-rc8.  It continued into 2.6.38.2.  It continues to exist on 3.0.0-rc3.
> 
> # for x in gogo xfs; do date | dd of=sparse-file bs=1k seek=4096; stat sparse-file; done

Funky; if we do xfs_bmap, it shows the right nr of blocks allocated:

# for x in gogo xfs; do date | dd of=sparse-file bs=1k seek=4096; stat sparse-file | grep Blocks; xfs_bmap -v sparse-file; done
  Size: 4194333   	Blocks: 8          IO Block: 4096   regular file
sparse-file:
 EXT: FILE-OFFSET      BLOCK-RANGE          AG AG-OFFSET            TOTAL
   0: [0..8191]:       hole                                          8192
   1: [8192..8199]:    450475168..450475175  2 (18736320..18736327)     8

  Size: 4194333   	Blocks: 8192       IO Block: 4096   regular file
sparse-file:
 EXT: FILE-OFFSET      BLOCK-RANGE          AG AG-OFFSET            TOTAL
   0: [0..8191]:       hole                                          8192
   1: [8192..8199]:    459367952..459367959  2 (27629104..27629111)     8


And if we unmount & remount it's right again:

# stat sparse-file | grep Blocks
  Size: 4194333   	Blocks: 8          IO Block: 4096   regular file

so they do remain sparse, but stat tells us the wrong thing.  I think it has
to do with the count of delayed blocks but I'll try to look into it.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

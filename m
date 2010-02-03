Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o13Kj5gN243633 for <xfs@oss.sgi.com>; Wed, 3 Feb 2010 14:45:05 -0600
Received: from mx1.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 979CA137607E
	for <xfs@oss.sgi.com>; Wed,  3 Feb 2010 12:46:13 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id T5cn1SmYeds8yBoN for
	<xfs@oss.sgi.com>; Wed, 03 Feb 2010 12:46:13 -0800 (PST)
Message-ID: <4B69E093.6000105@sandeen.net>
Date: Wed, 03 Feb 2010 14:46:11 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: State of XFS on ARM
References: <13bb8ce11002011924h611099feh4955eedcc6e588a6@mail.gmail.com>	<20100202112300.GA23809@infradead.org>	<13bb8ce11002021819l7e17dac4n5f58a9887a16fae2@mail.gmail.com>
	<13bb8ce11002031234t4b02b199g5b8dfd65ea48aa13@mail.gmail.com>
In-Reply-To: <13bb8ce11002031234t4b02b199g5b8dfd65ea48aa13@mail.gmail.com>
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
To: Daniel Goller <morfic@gmail.com>
Cc: xfs@oss.sgi.com

Daniel Goller wrote:
> Any particular stress test you can suggest, to use once i try git for
> xfs on this Marvell box?
> To try to help bringing up issues faster than through normal use of this box?

Run it through the xfstests suite:

http://git.kernel.org/?p=fs/xfs/xfstests-dev.git;a=summary

(I have a sheevaplug too, thanks to some nice folks @Marvell, and
I really need to get regular qa going on it in return... have been
too busy so far) :(

There's a readme in the tree, but basically just create a local.config like:

#        - setenv TEST_DEV "device containing TEST PARTITION"
#        - setenv TEST_DIR "mount point of TEST PARTITION"
#        - setenv SCRATCH_DEV "device containing SCRATCH PARTITION"
#        - setenv SCRATCH_MNT "mount point for SCRATCH PARTITION"

TEST_DEV=/dev/sdb1
TEST_DIR=/mnt/test
SCRATCH_DEV=/dev/sdb3
SCRATCH_MNT=/mnt/scratch

mkfs.xfs $TEST_DEV, and then run

#./check -g auto

-Eric

> Thanks in advance for any suggestions,
> 
> Daniel
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 302857F37
	for <xfs@oss.sgi.com>; Mon, 19 Oct 2015 06:16:44 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 1EE2E8F8033
	for <xfs@oss.sgi.com>; Mon, 19 Oct 2015 04:16:41 -0700 (PDT)
Received: from mout.gmx.net (mout.gmx.net [212.227.17.21]) by cuda.sgi.com
	with ESMTP id MrwvEi5IPHyYUKHA (version=TLSv1.2
	cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 19 Oct 2015 04:16:38 -0700 (PDT)
MIME-Version: 1.0
Message-ID: <trinity-37d434c7-060c-479b-a714-1c2346854711-1445253395574@3capp-gmx-bs59>
From: Dragon <Sunghost@gmx.de>
Subject: Re: Error in `xfs_repair': double free or corruption
Date: Mon, 19 Oct 2015 13:16:35 +0200
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

Hi Eric,
in meanwhile i upgraded my debian wheezy to stretch which has the latest xfsprogs 4.2 on bord. i had repaired the filesytem, but lost 10Gb of files. ok better than all.

so all is "fine" and i will now do next steps to get some data back.

thx
sunny

On 10/16/15 9:26 AM, Dragon wrote:

    Hello Emmanuel,

    kernel version is 3.16-0.bpo.2-amd64 and xfsprogs in version 3.2.1
    from stable. the question is if xfs_repair can repair a raid which
    has missed a disk with over 240gb bad blocks.


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

    gretings


        Hello,
        i have a problem after repaired a degraded Softare Raid6. System is
        Debian Jessi and Root and Boot are on Raid1, and Data on Raid6 on md2
        which miss one Disk. The mainproblem was a missing Disk because of
        badblocks which i cloned and exchanged agains a new one. After that i
        could successfully rebuild the raid (md2), while now only one disk is
        midding. But i recognised that xfs reports inode problems. Therefor i
        run xfs_repair on the raid device md2, but get message "Error in
        &#96;xfs_repair': double free or corruption" What can i do the fix
        this? thx 


    You didn't provide enough information (kernel and xfs-progs version at
    the very least) but you should use the latest version of xfs_repair, the
    one included in Debian is probably quite old. Here's one new:

    http://update.intellique.com/pub/xfs_repair-4.2.0.gz

    Or if you like it better in debian form:
    http://update.intellique.com/repository/pool/storiq3/unstable/amd64/xfsprogs_4.2.0+1_amd64.deb



_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

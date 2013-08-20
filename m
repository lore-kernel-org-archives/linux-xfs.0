Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 609E57FCB
	for <xfs@oss.sgi.com>; Tue, 20 Aug 2013 09:29:18 -0500 (CDT)
Message-ID: <52137D3D.8060205@sgi.com>
Date: Tue, 20 Aug 2013 09:29:17 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 51/50] xfs: add xfs sb v4 support for dirent filetype field
References: <1376304611-22994-1-git-send-email-david@fromorbit.com>
	<20130819201940.516942026@sgi.com> <5212AA1D.3000809@sandeen.net>
In-Reply-To: <5212AA1D.3000809@sandeen.net>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com

On 08/19/13 18:28, Eric Sandeen wrote:
> On 8/19/13 3:19 PM, Mark Tinguely wrote:
>
> <an attachment that doesn't show up on reply, moving d_type support to v4 superblocks ;)>
>
> Thanks, Mark!
>
> Has you been able to test this at all?

There is no test for this feature. Yes I did my version of testing. 
First adding each type of inode type and verifying it. Then fsstress 
testing using the same seed for sb v4+feature, v4 plain, v5+feature. The 
resulting directory and checked with xfs_db. fsstress was chosen because 
how it manipulate directory items.

>
> I do still owe a promised xfstest - but for that, we'll need at least mkfs
> &  xfs_repair support.
>

Dave made changes so that xfs_repair will run (find the correct 
directory items) but the feature verification and repairs has not been 
done, so technically this is an incomplete feature.

> Did you patch up mkfs to do basic tests of your kernelspace patch?

yes. to the directory area in mkfs per suggestion.

The tests run the same on the v5 and v4 - ummm, it is the same directory 
code. see above.

>
> Talking to Dave, he reminds me of a few things this needs, if it's
> going to be complete&  compatible on V4:
>
> * mkfs.xfs commandline option support&  manpage updates

yes

> * xfs_db support (including version friendly-text output)

yes, xfsprogs v4/v5 uses the same directory code, Dave's patches support 
xfs_db. It works for v4/v5.


> * XFS_IOC_FSGEOM support so that xfs_info can report the difference
> * xfs_repair needs to know that it's a valid feature on V4

okay, it will run xfs_repair to the same level as v5. AND ...As pointed 
out, there is no xfs_repair support to verify/correct the feature in v5 
and therefore v4 - (again it is the same directory code). As is, this 
feature is incomplete. That could keep the kernel portion from moving 
forward.

> Some of that may overlap w/ things still needed on V5, but some is unique
> to allowing it on V4.
>
> Mark, do you plan to do some of those unique-to-V4 parts, too?

Yes.

>
> As an aside: I would support getting this feature onto V4 superblocks,
> after we have confidence that all the bits are done, tested, and robust.
>
> I still would really like to see it go forward in parallel on V5, and
> not be blocked by the extra work needed for proper V4 integration.
>

understood - now documented.  Hi Linus.

This feature uses shared directory code. It has to be turned on using a 
mkfs to be used. No one will accidentally get this feature.

The feature and implementation are good. The directory code is common - 
the feature added changes to that directory code. If the implementation 
is bad it will trash the v4/v5 directories the same - no matter if the 
feature is turned on or off. If you are so afraid of the common code may 
break any directories, then this feature should be held back for more 
testing.

All that I insist is this nice feature be added to the mainstream 
filesystem at the same time as the experimental filesystem. There is NO 
TECHNICAL reason that this feature is not supported mainstream filesystem.

I repeat, if you have technical concerns for the feature's 
implementation and its impact on v4 filesystems because it uses common 
directory code, then it should be held back for more testing.

> Thanks,
> -Eric

--Mark.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

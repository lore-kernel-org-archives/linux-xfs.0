Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id C915F7F4E
	for <xfs@oss.sgi.com>; Sun,  7 Dec 2014 16:42:15 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id B738B8F8035
	for <xfs@oss.sgi.com>; Sun,  7 Dec 2014 14:42:15 -0800 (PST)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	66SkvKhXH1fsAhpi for <xfs@oss.sgi.com>;
	Sun, 07 Dec 2014 14:42:10 -0800 (PST)
Date: Mon, 8 Dec 2014 09:42:07 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Meeting
Message-ID: <20141207224207.GX9561@dastard>
References: <CAFhuFEd3eVhKy1Jg7qL-ycw4XHnAd16kkstpOhOUpwVsAPN5mw@mail.gmail.com>
	<CAJAKVEHs=FczXUnAYfhbdav1o6JONmD7y0Kgc1xUo1t9g3=63Q@mail.gmail.com>
	<CAJAKVEFk5oc98gqF8CnGzz7Vsat-i=0da+aYwJh-EGX8eX9sgw@mail.gmail.com>
	<CAFhuFEc+mbGqZtDVY_wT99dd=FPUKDKZkHN3FYaBgzaVEb=q_A@mail.gmail.com>
	<CAJAKVEFD0PuFW0eF_Csk1oQJnzZ2eYW=pywHFKJb-ArroRq_cA@mail.gmail.com>
	<CAJAKVEE2Lu=MReV9fdg0L4OvWAymJJv9qteNDm_1oHyNNcdKVw@mail.gmail.com>
	<CAF3jHnqRp9HCuXcgv7SBE=kNJ036GysLAx+dgL6v2V_jN2Nrng@mail.gmail.com>
	<CAJAKVEEAAaf-sA+jbTr8A_HAUMcToo6Esd8ithPvE4tY4TW2NA@mail.gmail.com>
	<20141201043155.GH16151@dastard>
	<CAJAKVEETXGiaNKwG=kfDWPoBRqJ0MyjhJLyyPTsMA53oGhQiBQ@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAJAKVEETXGiaNKwG=kfDWPoBRqJ0MyjhJLyyPTsMA53oGhQiBQ@mail.gmail.com>
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
To: Somdeep Dey <somdeepdey10@gmail.com>
Cc: xfs@oss.sgi.com

On Sun, Dec 07, 2014 at 05:27:16PM +0530, Somdeep Dey wrote:
> Hi,
> 
> Good to hear about the progress related to rmap. We'll continue
> working here on our side.
> 
> As we mentioned previously, we've familiarized ourselves
> with the fiemap interface and developed an understanding
> of how the ioctl works.
> 
> We also went through different discussions on the mailing
> list related to fiemap, as well as obtained the latest patches.
> 
> While working on the rmap, would it be possible for you to
> give us some essential details about the required fiemap
> interface, so that we can obtain a clearer understanding of
>  what we are required to do.

Turn FS_IOC_FIEMAPFS into an XFS specific ioctl that uses the fiemap
plumbing. Here's the original kernel patch that I wrote that
implemented FS_IOC_FIEMAPFS. This was the original fiemap extension
patches:

http://oss.sgi.com/archives/xfs/2012-10/msg00363.html

And I mentioned that it needed to be converted to FS_IOC_FIEMAPFS
due to review suggesting that it should be separate from file based
fiemap commands. I never posted those patches; I just forward ported
them to a current 3.18-rc7+for-next XFS tree and pushed them to the
fiemapfs fiemapfs branch in my kernel tree at:

git://git.kernel.org/pub/scm/linux/kernel/git/dgc/linux-xfs.git

The original xfs_spaceman tool that I wrote to call the fiemap
interface and make use of it is here:

http://oss.sgi.com/archives/xfs/2012-10/msg00366.html

I just updated it to the 3.2.2 code base and pushed it to the
spaceman branch in this tree:

git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git

This code mostly works:

$ uname -a
Linux test4 3.18.0-rc7-dgc+ #629 SMP Mon Dec 8 09:20:09 EST 2014 x86_64 GNU/Linux
$ sudo xfs_spaceman -V
xfs_spaceman version 3.2.2
$ sudo xfs_db -V
xfs_db version 3.2.2
$ sudo xfs_db -r -c "freesp" /dev/vdc
   from      to extents  blocks    pct
      1       1    2018    2018   0.00
      2       3      23      64   0.00
4194304 8388607      64 536595213   0.40
134217728 268435455     500 133680330088  99.60
$ sudo xfs_spaceman -c "freesp" /mnt/scratch
   from      to extents  blocks    pct
      1       1      18      18   0.00
      2       3      23      64   0.00
4194304 8388607      64 536595213   0.40
134217728 268435455     500 133680330088  99.60
$

It looks like FS_IOC_FIEMAPFS isn't accounting blocks in teh AGFL
(4 per AG, and there are 500 AGs in that filesystem), so that
will need to be added to the kernel code that iterates the free
space.

Christoph has (more recently) suggested that this should be
implemented as an XFS specific ioctl (XFS_IOC_FIEMAPFS) that makes
use of all the existing fiemap infrastructure to implement it. That
means we can review it and push it as we need, and that makes the
process much simpler.

This means the kernel patches need to change - the ioctl
infrastructure for XFS_IOC_FIEMAPFS needs to be added to
fs/xfs/xfs_ioctl.c and the new ioctl definition and flags added to
fs/xfs/xfs_fs.h rather than to include/linux/....  i.e. the first
patch needs to be reworked to do this. It can also call the
xfs_fs_fiemapfs() function implemented in the second patch directly
rather than through an operations vector.

The change to the userspace code should just be to use the new ioctl
definition and flags, as the rest of the code is unchanged. I
strongly suggest that you work on the kernel patches to get the API
and ioctl code correct ASAP so we can get this into the tree ASAP;
that will make your life easier if you don't have to run patched
kernels just to test everything you are doing in userspace. Not to
mention having the code already committed upstream will look really
good in your final reports. :)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

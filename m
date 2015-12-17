Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 904537CBF
	for <xfs@oss.sgi.com>; Wed, 16 Dec 2015 21:27:10 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 04F12AC005
	for <xfs@oss.sgi.com>; Wed, 16 Dec 2015 19:27:09 -0800 (PST)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id fYjK3Pu7hYABZk8g (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 16 Dec 2015 19:27:07 -0800 (PST)
Date: Wed, 16 Dec 2015 19:26:52 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: Ideas on unified real-ro mount option across all filesystems
Message-ID: <20151217032652.GD10582@birch.djwong.org>
References: <567212DA.8050808@cn.fujitsu.com>
 <567228EF.80007@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <567228EF.80007@redhat.com>
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
To: Eric Sandeen <sandeen@redhat.com>
Cc: fsdevel <linux-fsdevel@vger.kernel.org>, Qu Wenruo <quwenruo@cn.fujitsu.com>, linux-ext4@vger.kernel.org, btrfs <linux-btrfs@vger.kernel.org>, xfs@oss.sgi.com

On Wed, Dec 16, 2015 at 09:15:59PM -0600, Eric Sandeen wrote:
> <xfs list address fixed>
> 
> On 12/16/15 7:41 PM, Qu Wenruo wrote:
> > Hi,
> > 
> > In a recent btrfs patch, it is going to add a mount option to disable
> > log replay for btrfs, just like "norecovery" for ext4/xfs.
> > 
> > But in the discussion on the mount option name and use case, it seems
> > better to have an unified and fs independent mount option alias for
> > real RO mount
> > 
> > Reasons:
> > 1) Some file system may have already used [no]"recovery" mount option
> >    In fact, btrfs has already used "recovery" mount option.
> >    Using "norecovery" mount option will be quite confusing for btrfs.
> 
> Too bad btrfs picked those semantics when "norecovery" has existed on
> other filesystems for quite some time with a different meaning... :(
> 
> > 2) More straight forward mount option
> >    Currently, to get real RO mount, for ext4/xfs, user must use -o
> >    ro,norecovery.
> >    Just ro won't ensure real RO, and norecovery can't be used alone.
> >    If we have a simple alias, it would be much better for user to use.
> >    (it maybe done just in user space mount)
> 
> mount(8) simply says:
> 
>        ro     Mount the filesystem read-only.
> 
> and mount(2) is no more illustrative:
> 
>        MS_RDONLY
>               Mount file system read-only.
> 
> kernel code is no help, either:
> 
> #define MS_RDONLY        1      /* Mount read-only */
> 
> They say nothing about what, exactly, "read-only" means.  But since at least
> the early ext3 days, it means that you cannot write through the filesystem, not
> that the filesystem will leave the block device unmodified when it mounts.
> 
> I have always interpreted it as simply "no user changes to the filesystem,"
> and that is clearly what the vfs does with the flag...

That ("-o ro means no user changes") has always been my understanding too.  You
/want/ the FS to replay the journal on an RO mount so that regular FS operation
picks up the committed transactions.

--D

> 
> >    Not to mention some fs (yeah, btrfs again) doesn't have "norecovery"
> >    but "nologreplay".
> 
> well, again, btrfs picked unfortunate semantics, given the precedent set
> by other filesystems.
> 
> f2fs, ext4, gfs2, nilfs2, and xfs all support "norecovery" - xfs since
> forever, ext4 & f2fs since 2009, etc.
> 
> > 3) A lot of user even don't now mount ro can still modify device
> >    Yes, I didn't know this point until I checked the log replay code of
> >    btrfs.
> >    Adding such mount option alias may raise some attention of users.
> 
> Given that nothing in the documentation implies that the block device itself
> must remain unchanged on a read-only mount, I don't see any problem which
> needs fixing.  MS_RDONLY rejects user IO; that's all.
> 
> If you want to be sure your block device rejects all IO for forensics or
> what have you, I'd suggest # blockdev --setro /dev/whatever prior to mount,
> and take it out of the filesystem's control.  Or better yet, making an
> image and not touching the original.
> 
> -Eric
> 
> > Any ideas about this?
> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

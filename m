Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A1A9C433E6
	for <linux-xfs@archiver.kernel.org>; Wed, 10 Mar 2021 19:54:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3677961585
	for <linux-xfs@archiver.kernel.org>; Wed, 10 Mar 2021 19:54:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232613AbhCJTyW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 10 Mar 2021 14:54:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:51906 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232329AbhCJTyH (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 10 Mar 2021 14:54:07 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id AA4C864FBB;
        Wed, 10 Mar 2021 19:54:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615406046;
        bh=9kLo77JBJI9kCfzBhWR91rZrE2XVXJdUOf69U8dPZsw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=kkek0cFJbuuISWER1+yYg7qVOmMcn+mEZLCs5DOX94WrnJD8aziaPyngXNS4ksLft
         l4iwDRODHfthWoF02hZYSfxqeYMXroDRN+Lo3eHNVWbV9rj2F6rcmnZg3Re0gDveVz
         l3Xa91+6uws3iO+JkyUgZHaVzRBn9mdRjiDFV7zZONRh/qp1p2F76WeKgDCLr79T17
         PZShbR04iSZFWkgu1KiOJaxYWqJkT/IoTErAl5qMZd1easp0Z6Mg+0JUFTmqWbuMmE
         wcls+qS2Vtzwqs+gW41/rIkLKNGRiJi1Za+T/bmcg8Ysj8QCERaR2P+mGTIBpY0RF6
         lxvjz/fSHwYkA==
Date:   Wed, 10 Mar 2021 11:54:03 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Allison Henderson <allison.henderson@oracle.com>
Cc:     Chandan Babu R <chandanrlinux@gmail.com>, fstests@vger.kernel.org,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH V6 03/13] common/xfs: Add helper to obtain fsxattr field
 value
Message-ID: <20210310195403.GE3419940@magnolia>
References: <20210309050124.23797-1-chandanrlinux@gmail.com>
 <20210309050124.23797-4-chandanrlinux@gmail.com>
 <148ab249-be7a-2686-7995-a256e34f292a@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <148ab249-be7a-2686-7995-a256e34f292a@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Mar 09, 2021 at 11:13:17PM -0700, Allison Henderson wrote:
> 
> 
> On 3/8/21 10:01 PM, Chandan Babu R wrote:
> > This commit adds a helper function to obtain the value of a particular field
> > of an inode's fsxattr fields.
> > 
> > Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
> > ---
> >   common/xfs | 9 +++++++++
> >   1 file changed, 9 insertions(+)
> > 
> > diff --git a/common/xfs b/common/xfs
> > index 26ae21b9..130b3232 100644
> > --- a/common/xfs
> > +++ b/common/xfs
> > @@ -194,6 +194,15 @@ _xfs_get_file_block_size()
> >   	$XFS_INFO_PROG "$path" | grep realtime | sed -e 's/^.*extsz=\([0-9]*\).*$/\1/g'
> >   }
> > +_xfs_get_fsxattr()
> > +{
> > +	local field="$1"
> > +	local path="$2"
> > +
> > +	local value=$($XFS_IO_PROG -c "stat" "$path" | grep "$field")
> > +	echo ${value##fsxattr.${field} = }
> > +}
> > +
> In fiddling with the commands here, I think I may have noticed a bug.  I
> think you want to grep whole words only, or you may mistakenly match sub
> words. Example:
> 
> root@garnet:/home/achender/work_area# field="extsize "
> root@garnet:/home/achender/work_area# xfs_io -c "stat" /mnt/scratch/test |
> grep "$field"
> fsxattr.extsize = 0
> fsxattr.cowextsize = 0
> 
> I think if you add the -w to the grep that fixes it:
> root@garnet:/home/achender/work_area# xfs_io -c "stat" /mnt/scratch/test |
> grep -w "$field"

Hey, that's a neat trick I didn't know about!

Oooh and it even exists in both busybox /and/ gnu grep! :)

/me madly goes digging through his shell scripts

<and that was the last we heard from djwong>

--D

> fsxattr.extsize = 0
> 
> I think that's what you meant to do right?
> 
> Allison
> 
> >   # xfs_check script is planned to be deprecated. But, we want to
> >   # be able to invoke "xfs_check" behavior in xfstests in order to
> >   # maintain the current verification levels.
> > 
> 

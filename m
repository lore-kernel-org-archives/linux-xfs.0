Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C686C3A5A7
	for <linux-xfs@archiver.kernel.org>; Fri,  2 Dec 2022 02:23:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231518AbiLBCXQ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 1 Dec 2022 21:23:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230070AbiLBCXO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 1 Dec 2022 21:23:14 -0500
Received: from out30-57.freemail.mail.aliyun.com (out30-57.freemail.mail.aliyun.com [115.124.30.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 068C7B955C;
        Thu,  1 Dec 2022 18:23:12 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R121e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046049;MF=hsiangkao@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0VWAhKHX_1669947788;
Received: from B-P7TQMD6M-0146.local(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0VWAhKHX_1669947788)
          by smtp.aliyun-inc.com;
          Fri, 02 Dec 2022 10:23:10 +0800
Date:   Fri, 2 Dec 2022 10:23:07 +0800
From:   Gao Xiang <hsiangkao@linux.alibaba.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     fstests <fstests@vger.kernel.org>, linux-xfs@vger.kernel.org,
        Ziyang Zhang <ZiyangZhang@linux.alibaba.com>
Subject: Re: [PATCH] common/populate: Ensure that S_IFDIR.FMT_BTREE is in
 btree format
Message-ID: <Y4lhi+5nJNl0diaj@B-P7TQMD6M-0146.local>
Mail-Followup-To: "Darrick J. Wong" <djwong@kernel.org>,
        fstests <fstests@vger.kernel.org>, linux-xfs@vger.kernel.org,
        Ziyang Zhang <ZiyangZhang@linux.alibaba.com>
References: <20221201081208.40147-1-hsiangkao@linux.alibaba.com>
 <Y4jNzE5YJ3wFtsaz@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Y4jNzE5YJ3wFtsaz@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Darrick,

On Thu, Dec 01, 2022 at 07:52:44AM -0800, Darrick J. Wong wrote:
> On Thu, Dec 01, 2022 at 04:12:08PM +0800, Gao Xiang wrote:
> > Sometimes "$((128 * dblksz / 40))" dirents cannot make sure that
> > S_IFDIR.FMT_BTREE could become btree format for its DATA fork.
> > 
> > Actually we just observed it can fail after apply our inode
> > extent-to-btree workaround. The root cause is that the kernel may be
> > too good at allocating consecutive blocks so that the data fork is
> > still in extents format.
> > 
> > Therefore instead of using a fixed number, let's make sure the number
> > of extents is large enough than (inode size - inode core size) /
> > sizeof(xfs_bmbt_rec_t).
> > 
> > Suggested-by: "Darrick J. Wong" <djwong@kernel.org>
> > Cc: Ziyang Zhang <ZiyangZhang@linux.alibaba.com>
> > Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
> > ---
> >  common/populate | 22 +++++++++++++++++++++-
> >  1 file changed, 21 insertions(+), 1 deletion(-)
> > 
> > diff --git a/common/populate b/common/populate
> > index 6e004997..e179a300 100644
> > --- a/common/populate
> > +++ b/common/populate
> > @@ -71,6 +71,25 @@ __populate_create_dir() {
> >  	done
> >  }
> >  
> > +# Create a large directory and ensure that it's a btree format
> > +__populate_create_btree_dir() {
> 
> Since this encodes behavior specific to xfs, this ought to be called
> 
> __populate_xfs_create_btree_dir
> 
> or something like that.
> 
> > +	name="$1"
> > +	isize="$2"
> 
> These ought to be local variables, e.g.
> 
> 	local name="$1"
> 	local isize="$2"
> 
> So that they don't pollute the global name scope.  Yay bash.
> 
> > +
> > +	mkdir -p "${name}"
> > +	d=0
> > +	while true; do
> > +		creat=mkdir
> > +		test "$((d % 20))" -eq 0 && creat=touch
> > +		$creat "${name}/$(printf "%.08d" "$d")"
> > +		if [ "$((d % 40))" -eq 0 ]; then
> > +			nexts="$($XFS_IO_PROG -c "stat" $name | grep 'fsxattr.nextents' | sed -e 's/^.*nextents = //g' -e 's/\([0-9]*\).*$/\1/g')"
> 
> _xfs_get_fsxattr...
> 
> > +			[ "$nexts" -gt "$(((isize - 176) / 16))" ] && break
> 
> Only need to calculate this once if you declare this at the top:
> 
> 	# We need enough extents to guarantee that the data fork is in
> 	# btree format.  Cycling the mount to use xfs_db is too slow, so
> 	# watch for when the extent count exceeds the space after the
> 	# inode core.
> 	local max_nextents="$(((isize - 176) / 16))"
> 
> and then you can do:
> 
> 			[[ $nexts -gt $max_nextents ]] && break
> 
> Also not a fan of hardcoding 176 around fstests, but I don't know how
> we'd detect that at all.
> 
> # Number of bytes reserved for only the inode record, excluding the
> # immediate fork areas.
> _xfs_inode_core_bytes()
> {
> 	echo 176
> }
> 
> I guess?  Or extract it from tests/xfs/122.out?

Thanks for your comments.

I guess hard-coded 176 in _xfs_inode_core_bytes() is fine for now
(It seems a bit weird to extract a number from a test expected result..)

Otherwise I agree with your comments.  I will ask Ziyang to follow your
comments and send out v2.

Thanks,
Gao Xiang

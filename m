Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E044C352A1
	for <linux-xfs@archiver.kernel.org>; Wed,  7 Dec 2022 02:12:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229842AbiLGCMG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 6 Dec 2022 21:12:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229988AbiLGCL4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 6 Dec 2022 21:11:56 -0500
Received: from out30-45.freemail.mail.aliyun.com (out30-45.freemail.mail.aliyun.com [115.124.30.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F17B45A06;
        Tue,  6 Dec 2022 18:11:53 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R231e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046049;MF=hsiangkao@linux.alibaba.com;NM=0;PH=DS;RN=5;SR=0;TI=SMTPD_---0VWj.5MH_1670379109;
Received: from B-P7TQMD6M-0146.local(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0VWj.5MH_1670379109)
          by smtp.aliyun-inc.com;
          Wed, 07 Dec 2022 10:11:51 +0800
Date:   Wed, 7 Dec 2022 10:11:49 +0800
From:   Gao Xiang <hsiangkao@linux.alibaba.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     "Darrick J. Wong" <djwong@kernel.org>,
        fstests <fstests@vger.kernel.org>, linux-xfs@vger.kernel.org,
        Ziyang Zhang <ZiyangZhang@linux.alibaba.com>
Subject: Re: [PATCH] common/populate: Ensure that S_IFDIR.FMT_BTREE is in
 btree format
Message-ID: <Y4/2ZUIm2MKs6UID@B-P7TQMD6M-0146.local>
Mail-Followup-To: Dave Chinner <david@fromorbit.com>,
        "Darrick J. Wong" <djwong@kernel.org>,
        fstests <fstests@vger.kernel.org>, linux-xfs@vger.kernel.org,
        Ziyang Zhang <ZiyangZhang@linux.alibaba.com>
References: <20221201081208.40147-1-hsiangkao@linux.alibaba.com>
 <Y4jNzE5YJ3wFtsaz@magnolia>
 <Y4lhi+5nJNl0diaj@B-P7TQMD6M-0146.local>
 <20221206233417.GF2703033@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20221206233417.GF2703033@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Dave,

On Wed, Dec 07, 2022 at 10:34:17AM +1100, Dave Chinner wrote:
> On Fri, Dec 02, 2022 at 10:23:07AM +0800, Gao Xiang wrote:
> > Hi Darrick,
> > 
> > On Thu, Dec 01, 2022 at 07:52:44AM -0800, Darrick J. Wong wrote:
> > > On Thu, Dec 01, 2022 at 04:12:08PM +0800, Gao Xiang wrote:
> > > > Sometimes "$((128 * dblksz / 40))" dirents cannot make sure that
> > > > S_IFDIR.FMT_BTREE could become btree format for its DATA fork.
> > > > 
> > > > Actually we just observed it can fail after apply our inode
> > > > extent-to-btree workaround. The root cause is that the kernel may be
> > > > too good at allocating consecutive blocks so that the data fork is
> > > > still in extents format.
> > > > 
> > > > Therefore instead of using a fixed number, let's make sure the number
> > > > of extents is large enough than (inode size - inode core size) /
> > > > sizeof(xfs_bmbt_rec_t).
> > > > 
> > > > Suggested-by: "Darrick J. Wong" <djwong@kernel.org>
> > > > Cc: Ziyang Zhang <ZiyangZhang@linux.alibaba.com>
> > > > Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
> > > > ---
> > > >  common/populate | 22 +++++++++++++++++++++-
> > > >  1 file changed, 21 insertions(+), 1 deletion(-)
> > > > 
> > > > diff --git a/common/populate b/common/populate
> > > > index 6e004997..e179a300 100644
> > > > --- a/common/populate
> > > > +++ b/common/populate
> > > > @@ -71,6 +71,25 @@ __populate_create_dir() {
> > > >  	done
> > > >  }
> > > >  
> > > > +# Create a large directory and ensure that it's a btree format
> > > > +__populate_create_btree_dir() {
> > > 
> > > Since this encodes behavior specific to xfs, this ought to be called
> > > 
> > > __populate_xfs_create_btree_dir
> > > 
> > > or something like that.
> > > 
> > > > +	name="$1"
> > > > +	isize="$2"
> > > 
> > > These ought to be local variables, e.g.
> > > 
> > > 	local name="$1"
> > > 	local isize="$2"
> > > 
> > > So that they don't pollute the global name scope.  Yay bash.
> > > 
> > > > +
> > > > +	mkdir -p "${name}"
> > > > +	d=0
> > > > +	while true; do
> > > > +		creat=mkdir
> > > > +		test "$((d % 20))" -eq 0 && creat=touch
> > > > +		$creat "${name}/$(printf "%.08d" "$d")"
> > > > +		if [ "$((d % 40))" -eq 0 ]; then
> > > > +			nexts="$($XFS_IO_PROG -c "stat" $name | grep 'fsxattr.nextents' | sed -e 's/^.*nextents = //g' -e 's/\([0-9]*\).*$/\1/g')"
> > > 
> > > _xfs_get_fsxattr...
> 
> The grep/sed expression is also overly complex - it can easily be
> replaced with just this:
> 
> 	nexts=`$XFS_IO_PROG -c "stat" $name | sed -ne 's/^fsxattr.nextents = //p'
> 
> The "-n" option to sed suppresses the printing of the stream
> (pattern space) to the output as it processes the input, which gets
> rid of the need for using grep to suppress non-matching input. The "p"
> suffix to the search string forces matched patterns to be printed to
> the output.
> 
> This results in only matched, substituted pattern spaces to be
> printed, avoiding the need for grep and multiple sed regexes to be
> matched to strip the text down to just the integer string.

I just copied it from another reference at that time as a copy-and-paste
engineer.. Also note that Ziyang's new patch already use
_xfs_get_fsxattr to get this field.

> 
> > > > +			[ "$nexts" -gt "$(((isize - 176) / 16))" ] && break
> > > 
> > > Only need to calculate this once if you declare this at the top:
> > > 
> > > 	# We need enough extents to guarantee that the data fork is in
> > > 	# btree format.  Cycling the mount to use xfs_db is too slow, so
> > > 	# watch for when the extent count exceeds the space after the
> > > 	# inode core.
> > > 	local max_nextents="$(((isize - 176) / 16))"
> > > 
> > > and then you can do:
> > > 
> > > 			[[ $nexts -gt $max_nextents ]] && break
> > > 
> > > Also not a fan of hardcoding 176 around fstests, but I don't know how
> > > we'd detect that at all.
> > > 
> > > # Number of bytes reserved for only the inode record, excluding the
> > > # immediate fork areas.
> > > _xfs_inode_core_bytes()
> > > {
> > > 	echo 176
> > > }
> > > 
> > > I guess?  Or extract it from tests/xfs/122.out?
> > 
> > Thanks for your comments.
> > 
> > I guess hard-coded 176 in _xfs_inode_core_bytes() is fine for now
> > (It seems a bit weird to extract a number from a test expected result..)
> 
> Which is wrong when testing a v4 filesystem - in that case the inode
> core size is 96 bytes and so max extents may be larger on v4
> filesystems than v5 filesystems....

Do we really care v4 fs for now since it's deprecated?... Darrick once also 
suggested using (isize / 16) but it seems it could take unnecessary time to
prepare.. Or we could just use (isize - 96) / 16 to keep v4 work.

Thanks,
Gao Xiang


> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com

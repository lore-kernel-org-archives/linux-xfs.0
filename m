Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50E52C352A1
	for <linux-xfs@archiver.kernel.org>; Tue,  6 Dec 2022 23:34:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229719AbiLFXeX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 6 Dec 2022 18:34:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229548AbiLFXeW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 6 Dec 2022 18:34:22 -0500
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B094D3AC3D
        for <linux-xfs@vger.kernel.org>; Tue,  6 Dec 2022 15:34:21 -0800 (PST)
Received: by mail-pl1-x633.google.com with SMTP id d3so15462018plr.10
        for <linux-xfs@vger.kernel.org>; Tue, 06 Dec 2022 15:34:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=I4Wbn5pZkcHLpPWnJuY5BTJQNj1XiKhXd++b0f6Ro7w=;
        b=JeimpRI7znFP1YiQoRbB2Q/EBFoKwHiCvqe8qB196/jKgNrwjboAZMyCS9KGg47IbK
         MUtT6FamseWbcWlPh1JCt8DyVkvTuLzHanPdfUvE+ErXzIKZZyTJI4/zQXFmWPfKpacg
         WrhXi7ZPc5PnzlOOuc14t9e0WW0rTpRw9wbqsVn+S6LFr74e60f/cDchQOu1kGytEs89
         IWzZo6vHIG4NznxfnAHMqwvPUcXj/rrnMHbAkjJv7+wPLW/dzZZBL3TU704RijReD4gt
         RNCLvlWk2JjuFw4QIs8GbDg2aKSpkc5LUdXLbvCIn2DokSOVNh5cSBH6oBN/TiL/sLus
         6xZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=I4Wbn5pZkcHLpPWnJuY5BTJQNj1XiKhXd++b0f6Ro7w=;
        b=EkMW6k3x6MiMHM15lMyrU5h7NZUve1AmKH8RZe48KDL0IajHwlwKzfqMbvzsfSC87J
         hOegllbr+rdG/0lVaRgflVyhG8ruKqFXFfvUDdNNgBjBViEeOdZiA/+nrtxMsRhib77k
         pWc18TKt18KJc7GT7rI16HHjbxhpO4JAY2P7ZDOgtLi0HOyLehj/eTJnFp7k7/QUmheI
         41ZsXxePdNY8lq/KIYvdt1wYgWIC2Bcq+VNpQ2GqReWhscMeku043PZvMnlytfu76UfJ
         xKCRhpoa+KRgNdpspgT2NZZaGGmLE578Jmr33juOioaX2oiJb0/sydqJiEs6bwhYTHqW
         vIlA==
X-Gm-Message-State: ANoB5pnGOMpBfDP+koRx2xMCY+HXcZ7519VFXelS40uSWMWv4V3Kx9Fp
        6Bs9cXaB8f/0DjsKNjB0ZAT06Q==
X-Google-Smtp-Source: AA0mqf5nyhkMfn0nGQtc66dJeFMg06Teq2W46crMLxJenvoHXJ6GNXAJKxn8q9AVaHFizDzScEGRKA==
X-Received: by 2002:a17:903:22c4:b0:171:5092:4d12 with SMTP id y4-20020a17090322c400b0017150924d12mr73603982plg.107.1670369661190;
        Tue, 06 Dec 2022 15:34:21 -0800 (PST)
Received: from dread.disaster.area (pa49-181-138-158.pa.nsw.optusnet.com.au. [49.181.138.158])
        by smtp.gmail.com with ESMTPSA id b18-20020a621b12000000b0057709fd0fccsm3782112pfb.153.2022.12.06.15.34.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Dec 2022 15:34:20 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1p2hS5-005N9k-CT; Wed, 07 Dec 2022 10:34:17 +1100
Date:   Wed, 7 Dec 2022 10:34:17 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>,
        fstests <fstests@vger.kernel.org>, linux-xfs@vger.kernel.org,
        Ziyang Zhang <ZiyangZhang@linux.alibaba.com>
Subject: Re: [PATCH] common/populate: Ensure that S_IFDIR.FMT_BTREE is in
 btree format
Message-ID: <20221206233417.GF2703033@dread.disaster.area>
References: <20221201081208.40147-1-hsiangkao@linux.alibaba.com>
 <Y4jNzE5YJ3wFtsaz@magnolia>
 <Y4lhi+5nJNl0diaj@B-P7TQMD6M-0146.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y4lhi+5nJNl0diaj@B-P7TQMD6M-0146.local>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Dec 02, 2022 at 10:23:07AM +0800, Gao Xiang wrote:
> Hi Darrick,
> 
> On Thu, Dec 01, 2022 at 07:52:44AM -0800, Darrick J. Wong wrote:
> > On Thu, Dec 01, 2022 at 04:12:08PM +0800, Gao Xiang wrote:
> > > Sometimes "$((128 * dblksz / 40))" dirents cannot make sure that
> > > S_IFDIR.FMT_BTREE could become btree format for its DATA fork.
> > > 
> > > Actually we just observed it can fail after apply our inode
> > > extent-to-btree workaround. The root cause is that the kernel may be
> > > too good at allocating consecutive blocks so that the data fork is
> > > still in extents format.
> > > 
> > > Therefore instead of using a fixed number, let's make sure the number
> > > of extents is large enough than (inode size - inode core size) /
> > > sizeof(xfs_bmbt_rec_t).
> > > 
> > > Suggested-by: "Darrick J. Wong" <djwong@kernel.org>
> > > Cc: Ziyang Zhang <ZiyangZhang@linux.alibaba.com>
> > > Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
> > > ---
> > >  common/populate | 22 +++++++++++++++++++++-
> > >  1 file changed, 21 insertions(+), 1 deletion(-)
> > > 
> > > diff --git a/common/populate b/common/populate
> > > index 6e004997..e179a300 100644
> > > --- a/common/populate
> > > +++ b/common/populate
> > > @@ -71,6 +71,25 @@ __populate_create_dir() {
> > >  	done
> > >  }
> > >  
> > > +# Create a large directory and ensure that it's a btree format
> > > +__populate_create_btree_dir() {
> > 
> > Since this encodes behavior specific to xfs, this ought to be called
> > 
> > __populate_xfs_create_btree_dir
> > 
> > or something like that.
> > 
> > > +	name="$1"
> > > +	isize="$2"
> > 
> > These ought to be local variables, e.g.
> > 
> > 	local name="$1"
> > 	local isize="$2"
> > 
> > So that they don't pollute the global name scope.  Yay bash.
> > 
> > > +
> > > +	mkdir -p "${name}"
> > > +	d=0
> > > +	while true; do
> > > +		creat=mkdir
> > > +		test "$((d % 20))" -eq 0 && creat=touch
> > > +		$creat "${name}/$(printf "%.08d" "$d")"
> > > +		if [ "$((d % 40))" -eq 0 ]; then
> > > +			nexts="$($XFS_IO_PROG -c "stat" $name | grep 'fsxattr.nextents' | sed -e 's/^.*nextents = //g' -e 's/\([0-9]*\).*$/\1/g')"
> > 
> > _xfs_get_fsxattr...

The grep/sed expression is also overly complex - it can easily be
replaced with just this:

	nexts=`$XFS_IO_PROG -c "stat" $name | sed -ne 's/^fsxattr.nextents = //p'

The "-n" option to sed suppresses the printing of the stream
(pattern space) to the output as it processes the input, which gets
rid of the need for using grep to suppress non-matching input. The "p"
suffix to the search string forces matched patterns to be printed to
the output.

This results in only matched, substituted pattern spaces to be
printed, avoiding the need for grep and multiple sed regexes to be
matched to strip the text down to just the integer string.

> > > +			[ "$nexts" -gt "$(((isize - 176) / 16))" ] && break
> > 
> > Only need to calculate this once if you declare this at the top:
> > 
> > 	# We need enough extents to guarantee that the data fork is in
> > 	# btree format.  Cycling the mount to use xfs_db is too slow, so
> > 	# watch for when the extent count exceeds the space after the
> > 	# inode core.
> > 	local max_nextents="$(((isize - 176) / 16))"
> > 
> > and then you can do:
> > 
> > 			[[ $nexts -gt $max_nextents ]] && break
> > 
> > Also not a fan of hardcoding 176 around fstests, but I don't know how
> > we'd detect that at all.
> > 
> > # Number of bytes reserved for only the inode record, excluding the
> > # immediate fork areas.
> > _xfs_inode_core_bytes()
> > {
> > 	echo 176
> > }
> > 
> > I guess?  Or extract it from tests/xfs/122.out?
> 
> Thanks for your comments.
> 
> I guess hard-coded 176 in _xfs_inode_core_bytes() is fine for now
> (It seems a bit weird to extract a number from a test expected result..)

Which is wrong when testing a v4 filesystem - in that case the inode
core size is 96 bytes and so max extents may be larger on v4
filesystems than v5 filesystems....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

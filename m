Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38F9DC433EF
	for <linux-xfs@archiver.kernel.org>; Sun, 17 Apr 2022 14:42:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234234AbiDQOo6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 17 Apr 2022 10:44:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229496AbiDQOo6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 17 Apr 2022 10:44:58 -0400
Received: from out20-15.mail.aliyun.com (out20-15.mail.aliyun.com [115.124.20.15])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 995A8DF0C;
        Sun, 17 Apr 2022 07:42:20 -0700 (PDT)
X-Alimail-AntiSpam: AC=CONTINUE;BC=0.07437606|-1;CH=green;DM=|CONTINUE|false|;DS=CONTINUE|ham_alarm|0.0195173-0.00256377-0.977919;FP=0|0|0|0|0|-1|-1|-1;HT=ay29a033018047199;MF=guan@eryu.me;NM=1;PH=DS;RN=4;RT=4;SR=0;TI=SMTPD_---.NSMzImJ_1650206536;
Received: from localhost(mailfrom:guan@eryu.me fp:SMTPD_---.NSMzImJ_1650206536)
          by smtp.aliyun-inc.com(33.37.67.126);
          Sun, 17 Apr 2022 22:42:16 +0800
Date:   Sun, 17 Apr 2022 22:42:15 +0800
From:   Eryu Guan <guan@eryu.me>
To:     zlang@redhat.com
Cc:     djwong@kernel.org, fstests@vger.kernel.org,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH v1.1 3/3] xfs/216: handle larger log sizes
Message-ID: <YlwnR1SvEiNussG3@desktop>
References: <164971769710.170109.8985299417765876269.stgit@magnolia>
 <164971771391.170109.16368399851366024102.stgit@magnolia>
 <20220415150458.GB17025@magnolia>
 <20220416133518.sxow73joph3f7h7v@zlang-mailbox>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220416133518.sxow73joph3f7h7v@zlang-mailbox>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Apr 16, 2022 at 09:35:18PM +0800, Zorro Lang wrote:
> On Fri, Apr 15, 2022 at 08:04:58AM -0700, Darrick J. Wong wrote:
> > mkfs will soon refuse to format a log smaller than 64MB, so update this
> > test to reflect the new log sizing calculations.
> > 
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > ---
> >  tests/xfs/216             |   19 +++++++++++++++++++
> >  tests/xfs/216.out.64mblog |   10 ++++++++++
> >  tests/xfs/216.out.classic |    0 
> >  3 files changed, 29 insertions(+)
> >  create mode 100644 tests/xfs/216.out.64mblog
> >  rename tests/xfs/{216.out => 216.out.classic} (100%)
> > 
> > diff --git a/tests/xfs/216 b/tests/xfs/216
> > index c3697db7..ebae8979 100755
> > --- a/tests/xfs/216
> > +++ b/tests/xfs/216
> > @@ -29,6 +29,23 @@ $MKFS_XFS_PROG 2>&1 | grep -q rmapbt && \
> >  $MKFS_XFS_PROG 2>&1 | grep -q reflink && \
> >  	loop_mkfs_opts="$loop_mkfs_opts -m reflink=0"
> >  
> > +# Decide which golden output file we're using.  Starting with mkfs.xfs 5.15,
> > +# the default minimum log size was raised to 64MB for all cases, so we detect
> > +# that by test-formatting with a 512M filesystem.  This is a little handwavy,
> > +# but it's the best we can do.
> > +choose_golden_output() {
> > +	local seqfull=$1
> > +	local file=$2
> > +
> > +	if $MKFS_XFS_PROG -f -b size=4096 -l version=2 \
> > +			-d name=$file,size=512m $loop_mkfs_opts | \
> > +			grep -q 'log.*blocks=16384'; then
> > +		ln -f -s $seqfull.out.64mblog $seqfull.out
> > +	else
> > +		ln -f -s $seqfull.out.classic $seqfull.out
> > +	fi
> 
> Actually there's a old common function in common/rc named _link_out_file(),
> xfstests generally use it to deal with multiple .out files. It would be
> better to keep in step with common helpers, but your "ln" command
> isn't wrong :)

I added tests/xfs/216.cfg file and updated test to use
_link_out_file_named().

> 
> Reviewed-by: Zorro Lang <zlang@redhat.com>

Thanks!
Eryu

> 
> > +}
> > +
> >  _do_mkfs()
> >  {
> >  	for i in $*; do
> > @@ -43,6 +60,8 @@ _do_mkfs()
> >  # make large holey file
> >  $XFS_IO_PROG -f -c "truncate 256g" $LOOP_DEV
> >  
> > +choose_golden_output $0 $LOOP_DEV
> > +
> >  #make loopback mount dir
> >  mkdir $LOOP_MNT
> >  
> > diff --git a/tests/xfs/216.out.64mblog b/tests/xfs/216.out.64mblog
> > new file mode 100644
> > index 00000000..3c12085f
> > --- /dev/null
> > +++ b/tests/xfs/216.out.64mblog
> > @@ -0,0 +1,10 @@
> > +QA output created by 216
> > +fssize=1g log      =internal log           bsize=4096   blocks=16384, version=2
> > +fssize=2g log      =internal log           bsize=4096   blocks=16384, version=2
> > +fssize=4g log      =internal log           bsize=4096   blocks=16384, version=2
> > +fssize=8g log      =internal log           bsize=4096   blocks=16384, version=2
> > +fssize=16g log      =internal log           bsize=4096   blocks=16384, version=2
> > +fssize=32g log      =internal log           bsize=4096   blocks=16384, version=2
> > +fssize=64g log      =internal log           bsize=4096   blocks=16384, version=2
> > +fssize=128g log      =internal log           bsize=4096   blocks=16384, version=2
> > +fssize=256g log      =internal log           bsize=4096   blocks=32768, version=2
> > diff --git a/tests/xfs/216.out b/tests/xfs/216.out.classic
> > similarity index 100%
> > rename from tests/xfs/216.out
> > rename to tests/xfs/216.out.classic
> > 

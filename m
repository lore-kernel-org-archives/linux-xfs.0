Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29974ECAAD8
	for <linux-xfs@archiver.kernel.org>; Tue, 30 Aug 2022 14:59:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229601AbiH3O7w (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 30 Aug 2022 10:59:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229881AbiH3O7v (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 30 Aug 2022 10:59:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 425B5D58;
        Tue, 30 Aug 2022 07:59:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DCFDA61585;
        Tue, 30 Aug 2022 14:59:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FACAC433D7;
        Tue, 30 Aug 2022 14:59:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661871588;
        bh=pE1Jfog/ZlUdaRhT3QYQFwJkuh3qBEqMh9XymKyhEa8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=fhbzTOaQ4kOfKb+T63FL3QTCsbNlPvf3RhssFu3OOCJKyJctxQbDepP1LgR43Y2/s
         IgWyL5zC5ZVDz+WbVodO4wXKcqVr0JB6GbbrrX+0DFwkPi7p99kXIaBHw/0Jnz+1xE
         URo7mPz34OzFb0txNzenlXzOz5lA5t6hYSHk5NyS4MjXu/iR8CQoSSVldd7I3EySEn
         PYRtL0Lk0c8m3gzy5S+2vMUqPTbhzzCdoQDsznRnfTnIuBtJxvn7pW+vb/SkgYppvO
         G6Mbcbu4lstBcGqxIjJmJfnUH+eXMdAhYboCf2/DJnE9fnUluZU4p4zpkEMv7ESaZa
         7qSPXGpxrWX+A==
Date:   Tue, 30 Aug 2022 07:59:47 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Zorro Lang <zlang@redhat.com>
Cc:     Murphy Zhou <jencce.kernel@gmail.com>, fstests@vger.kernel.org,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH v3 4/4] xfs/144: remove testing root dir inode in AG 1
Message-ID: <Yw4l44ySWqhCe7dB@magnolia>
References: <20220830044433.1719246-1-jencce.kernel@gmail.com>
 <20220830044433.1719246-5-jencce.kernel@gmail.com>
 <20220830074936.eprwzg4auxtlhsom@zlang-mailbox>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220830074936.eprwzg4auxtlhsom@zlang-mailbox>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Aug 30, 2022 at 03:49:36PM +0800, Zorro Lang wrote:
> On Tue, Aug 30, 2022 at 12:44:33PM +0800, Murphy Zhou wrote:
> > Since this xfsprogs commit
> >   1b580a773 mkfs: don't let internal logs bump the root dir inode chunk to AG 1
> > this operation is not allowed.
> > 
> > Signed-off-by: Murphy Zhou <jencce.kernel@gmail.com>
> > ---
> >  tests/xfs/144 | 10 +---------
> >  1 file changed, 1 insertion(+), 9 deletions(-)
> > 
> > diff --git a/tests/xfs/144 b/tests/xfs/144
> > index 706aff61..3f80d0ee 100755
> > --- a/tests/xfs/144
> > +++ b/tests/xfs/144
> > @@ -17,9 +17,6 @@ _begin_fstest auto mkfs
> >  _supported_fs xfs
> >  _require_test
> >  
> > -# The last testcase creates a (sparse) fs image with a 2GB log, so we need
> > -# 3GB to avoid failing the mkfs due to ENOSPC.
> > -_require_fs_space $TEST_DIR $((3 * 1048576))
> >  echo Silence is golden
> >  
> >  testfile=$TEST_DIR/a
> > @@ -36,7 +33,7 @@ test_format() {
> >  }
> >  
> >  # First we try various small filesystems and stripe sizes.
> > -for M in `seq 298 302` `seq 490 520`; do
> > +for M in `seq 1024 1030` ; do
> 
> Can `seq 1024 1030` replace `seq 298 302` `seq 490 520`? I don't know how
> Darrick choose these numbers, better to ask the original authoer of this
> case. Others looks reasonable for me.

Those sequences were a result of Eric prying broken edge-cases out of
the original patch series, so I wired them up in the test.

> Thanks,
> Zorro
> 
> >  	for S in `seq 32 4 64`; do
> >  		test_format "M=$M S=$S" -dsu=${S}k,sw=1,size=${M}m -N
> >  	done
> > @@ -45,11 +42,6 @@ done
> >  # log end rounded beyond EOAG due to stripe unit
> >  test_format "log end beyond eoag" -d agcount=3200,size=6366g -d su=256k,sw=4 -N
> >  
> > -# Log so large it pushes the root dir into AG 1.  We can't use -N for the mkfs
> > -# because this check only occurs after the root directory has been allocated,
> > -# which mkfs -N doesn't do.
> > -test_format "log pushes rootdir into AG 1" -d agcount=3200,size=6366g -lagnum=0

Also, why remove this bit?  Surely we ought to keep it just in case
someone accidentally breaks the mkfs code again?

--D

> >  # success, all done
> >  status=0
> >  exit
> > -- 
> > 2.31.1
> > 
> 

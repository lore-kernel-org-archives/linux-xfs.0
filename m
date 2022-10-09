Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BCE47C4332F
	for <linux-xfs@archiver.kernel.org>; Sun,  9 Oct 2022 02:19:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229527AbiJICT4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 8 Oct 2022 22:19:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229565AbiJICTz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 8 Oct 2022 22:19:55 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7644F12D28
        for <linux-xfs@vger.kernel.org>; Sat,  8 Oct 2022 19:19:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1665281986;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=rxoiurSBmKUy59nBgR59gGZGspdR4aNbaNhIrhn715U=;
        b=Eu35kPyMaJ2exS8E/vLPwQCK3iaXGS/U04hYXx/2bxVNJ21MltaSa2U2x1bt6F4beijWOw
        Ziey1tyDkLu+vQkH8c0lYJncTxsS5AYYY5DWjmmO47d3Bd4LQP5BE/zaxDxDMO9ctqCqSZ
        HCkHAZfWnIDMjn1Gc92ldtoGOHaLshU=
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com
 [209.85.216.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-124-RghHET7xPVarAWxd1UTtOQ-1; Sat, 08 Oct 2022 22:19:45 -0400
X-MC-Unique: RghHET7xPVarAWxd1UTtOQ-1
Received: by mail-pj1-f72.google.com with SMTP id pa16-20020a17090b265000b0020a71040b4cso3839179pjb.6
        for <linux-xfs@vger.kernel.org>; Sat, 08 Oct 2022 19:19:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rxoiurSBmKUy59nBgR59gGZGspdR4aNbaNhIrhn715U=;
        b=wk/qPsujUy4OOcBDxGWzcWDl9wIvIHx8rHDQWASMZtMD7LiAx34rZp1h2VjlQ80X0g
         ZAfOaTY/Bokz+Zg0f9xXnkdOVgoOvKborExAAM6UBghCCCh1xrywqWcbpXtujfbeIuQX
         pymD925v+7KNciwuh9GGYr6BNZ2z0XckiE8rW03t3fNl8pa1ukTXZ1L2WHsUkUkx5qQ0
         6mG1o+Dr6+j04HtCmE6DfxqNQbdLPC3/U9zxqo8cE8KpYdrmF5twWTME2VEKRqqzbSFa
         QVGvMJhJzxSTLNSwC4teEOw9GxjMgPDQmEucR7i86w/BadYdlUxfb9q0KHXQsfcF7HmZ
         OJBg==
X-Gm-Message-State: ACrzQf3K2ZeWcOLsy44V29/fa2KC2h9RaQLJwKeT71b8irab4qnEVDSy
        HkHhTKHpqVu0xzz0VSs8bIxyY+45LoHDRqtoTGyhVWUB8mWVORV2/80XMJGvj+Q8T1EDimBWLrd
        URBeSjLSmRl6Yeost8hUL
X-Received: by 2002:a17:903:40d1:b0:17f:4e94:b747 with SMTP id t17-20020a17090340d100b0017f4e94b747mr12115556pld.44.1665281984149;
        Sat, 08 Oct 2022 19:19:44 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM5J3r4Je4s0yOEAVxt0ZvuWVWptSxWdLJazXG+/Hvz22V1m2El+md2mQV3JkC5kKK6VbAh7sg==
X-Received: by 2002:a17:903:40d1:b0:17f:4e94:b747 with SMTP id t17-20020a17090340d100b0017f4e94b747mr12115532pld.44.1665281983783;
        Sat, 08 Oct 2022 19:19:43 -0700 (PDT)
Received: from zlang-mailbox ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id w18-20020a170902c79200b00174be817124sm3929136pla.221.2022.10.08.19.19.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 08 Oct 2022 19:19:43 -0700 (PDT)
Date:   Sun, 9 Oct 2022 10:19:39 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 4/6] xfs/128: try to force file allocation behavior
Message-ID: <20221009021939.yiuzvrdbcscafdg4@zlang-mailbox>
References: <166500903290.886939.12532028548655386973.stgit@magnolia>
 <166500905541.886939.4232929527218167462.stgit@magnolia>
 <20221008111102.mb25fytm5yilkefr@zlang-mailbox>
 <Y0G5b7wZXIupRYDs@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y0G5b7wZXIupRYDs@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Oct 08, 2022 at 10:54:55AM -0700, Darrick J. Wong wrote:
> On Sat, Oct 08, 2022 at 07:11:02PM +0800, Zorro Lang wrote:
> > On Wed, Oct 05, 2022 at 03:30:55PM -0700, Darrick J. Wong wrote:
> > > From: Darrick J. Wong <djwong@kernel.org>
> > > 
> > > Over the years, I've noticed that this test occasionally fails when I've
> > > programmed the allocator to hand out the minimum amount of space with
> > > each allocation or if extent size hints are enabled:
> > > 
> > > --- /tmp/fstests/tests/xfs/128.out      2022-09-01 15:09:11.506679341 -0700
> > > +++ /var/tmp/fstests/xfs/128.out.bad    2022-10-04 17:32:50.992000000 -0700
> > > @@ -20,7 +21,9 @@
> > >  56ed2f712c91e035adeeb26ed105a982  SCRATCH_MNT/test-128/file3
> > >  b81534f439aac5c34ce3ed60a03eba70  SCRATCH_MNT/test-128/file4
> > >  Check files
> > >  free blocks after creating some reflink copies is in range
> > >  free blocks after CoW some reflink copies is in range
> > > -free blocks after defragging all reflink copies is in range
> > > -free blocks after all tests is in range
> > > +free blocks after defragging all reflink copies has value of 8620027
> > > +free blocks after defragging all reflink copies is NOT in range 8651819 .. 8652139
> > > +free blocks after all tests has value of 8620027
> > > +free blocks after all tests is NOT in range 8651867 .. 8652187
> > > 
> > > It turns out that under the right circumstances, the _pwrite_byte at the
> > > start of this test will end up allocating two extents to file1.  This
> > > almost never happens when delalloc is enabled or when the extent size is
> > > large, and is more prone to happening if the extent size is > 1FSB but
> > > small, the allocator hands out small allocations, or if writeback shoots
> > > down pages in random order.
> > > 
> > > When file1 gets more than 1 extent, problems start to happen.  The free
> > > space accounting checks at the end of the test assume that file1 and
> > > file4 still share the same space at the end of the test.  This
> > > definitely happens if file1 gets one extent (since fsr ignores
> > > single-extent files), but if there's more than 1, fsr will try to
> > > defragment it.  If fsr succeeds in copying the file contents to a temp
> > > file with fewer extents than the source file, it will switch the
> > > contents, but unsharing the contents in the process.  This cause the
> > > free space to be lower than expected, and the test fails.
> > > 
> > > Resolve this situation by preallocating space beforehand to try to set
> > > up file1 with a single space extent.  If the test fails and we got more
> > > than one extent, note that in the output.
> > > 
> > > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > > ---
> > 
> > Good to me,
> > Reviewed-by: Zorro Lang <zlang@redhat.com>
> > 
> > >  tests/xfs/128 |   34 ++++++++++++++++++++++++++++++----
> > >  1 file changed, 30 insertions(+), 4 deletions(-)
> > > 
> > > 
> > > diff --git a/tests/xfs/128 b/tests/xfs/128
> > > index db5d9a60db..2d2975115e 100755
> > > --- a/tests/xfs/128
> > > +++ b/tests/xfs/128
> > > @@ -34,7 +34,20 @@ margin=160
> > >  blksz=65536
> > >  real_blksz="$(_get_block_size $testdir)"
> > >  blksz_factor=$((blksz / real_blksz))
> > > +
> > > +# The expected free space numbers in this test require file1 and file4 to share
> > > +# the same blocks at the end of the test.  Therefore, we need the allocator to
> > > +# give file1 a single extent at the start of the test so that fsr will not be
> > > +# tempted to "defragment" a multi-extent file1 or file4.  Defragmenting really
> > > +# means rewriting the file, and if that succeeds on either file, we'll have
> > > +# unshared the space and there will be too little free space.  Therefore,
> > > +# preallocate space to try to produce a single extent.
> > > +$XFS_IO_PROG -f -c "falloc 0 $((blks * blksz))" $testdir/file1 >> $seqres.full
> > >  _pwrite_byte 0x61 0 $((blks * blksz)) $testdir/file1 >> $seqres.full
> > > +sync
> > > +
> > > +nextents=$($XFS_IO_PROG -c 'stat' $testdir/file1 | grep 'fsxattr.nextents' | awk '{print $3}')
> > > +
> > >  _cp_reflink $testdir/file1 $testdir/file2
> > >  _cp_reflink $testdir/file2 $testdir/file3
> > >  _cp_reflink $testdir/file3 $testdir/file4
> > > @@ -106,10 +119,23 @@ test $c14 = $c24 || echo "File4 changed by defrag"
> > >  
> > >  #echo $free_blocks0 $free_blocks1 $free_blocks2 $free_blocks3
> > >  
> > > -_within_tolerance "free blocks after creating some reflink copies" $free_blocks1 $((free_blocks0 - (blks * blksz_factor) )) $margin -v
> > > -_within_tolerance "free blocks after CoW some reflink copies" $free_blocks2 $((free_blocks1 - 2)) $margin -v
> > > -_within_tolerance "free blocks after defragging all reflink copies" $free_blocks3 $((free_blocks2 - (blks * 2 * blksz_factor))) $margin -v
> > > -_within_tolerance "free blocks after all tests" $free_blocks3 $((free_blocks0 - (blks * 3 * blksz_factor))) $margin -v
> > > +freesp_bad=0
> > > +
> > > +_within_tolerance "free blocks after creating some reflink copies" \
> > > +	$free_blocks1 $((free_blocks0 - (blks * blksz_factor) )) $margin -v || freesp_bad=1
> > > +
> > > +_within_tolerance "free blocks after CoW some reflink copies" \
> > > +	$free_blocks2 $((free_blocks1 - 2)) $margin -v || freesp_bad=1
> > > +
> > > +_within_tolerance "free blocks after defragging all reflink copies" \
> > > +	$free_blocks3 $((free_blocks2 - (blks * 2 * blksz_factor))) $margin -v || freesp_bad=1
> > > +
> > > +_within_tolerance "free blocks after all tests" \
> > > +	$free_blocks3 $((free_blocks0 - (blks * 3 * blksz_factor))) $margin -v || freesp_bad=1
> > > +
> > > +if [ $freesp_bad -ne 0 ] && [ $nextents -gt 0 ]; then
> 
> If you decide to commit this, could you change ^^^ this to -gt 1, please?

Sure, done :)

> 
> --D
> 
> > > +	echo "free space checks probably failed because file1 nextents was $nextents"
> > > +fi
> > >  
> > >  # success, all done
> > >  status=0
> > > 
> > 
> 


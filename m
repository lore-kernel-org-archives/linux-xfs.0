Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F35D4C43334
	for <linux-xfs@archiver.kernel.org>; Wed, 13 Jul 2022 17:52:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229782AbiGMRwM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 13 Jul 2022 13:52:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229517AbiGMRwL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 13 Jul 2022 13:52:11 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 328F12D1C1
        for <linux-xfs@vger.kernel.org>; Wed, 13 Jul 2022 10:52:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657734728;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=nKZTDUcrbtjuNJpnUuXGp9oPcl9nD5B2QM/SKKL8nLE=;
        b=IWpoLul+aEYxG/SURHGjWZL6USSqUJSj8R2HiYaygq+RZwynfC7SiozqQLzRqwns4zGeaH
        fKAjDS24T/SPzgnhKyoxKZlQhHgYWNZksui9hXLA5aDavIKUBu6Iyy2aRehp17CJxwE4yh
        CRvIhHCBrTTO+SKXCGCGZHgWJa6t5Jk=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-274-_cC_0SV0PwyvWuuZYjj8Yw-1; Wed, 13 Jul 2022 13:52:07 -0400
X-MC-Unique: _cC_0SV0PwyvWuuZYjj8Yw-1
Received: by mail-qv1-f72.google.com with SMTP id p6-20020a0c8c86000000b004731e63c75bso4194135qvb.10
        for <linux-xfs@vger.kernel.org>; Wed, 13 Jul 2022 10:52:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=nKZTDUcrbtjuNJpnUuXGp9oPcl9nD5B2QM/SKKL8nLE=;
        b=cam+o0IPRPYhh4isk7Xf+2cslMaB9dQXbLcvSRGCLch3XE1zseQn4Uac//GgG6UE6Y
         BjBt1NasdI9IU8oBCyKa8Cmi+Xyv+E7OKCVmEUwU+4AbLardovsDGFuY+JVOclkbli4J
         k4J19KhhLgvNNAoMfOFwFDAS2OwnVQV6gKLr3/VlGME/ZfPivUpMrUaQ9f/ZVbTNFKx5
         rr8i5oRa9YKsDOEpc/5GtS2iGt8fsM/rZ5kN//zyAHloMR82UqeNLFko41vlXTJRAzzg
         iI/0Lr6uCXWgdscjc71oL8DPxfvaE+AFLkF5hTt2wc4OfacZ73eDxvM1pEcp5LKlIoPl
         cXBQ==
X-Gm-Message-State: AJIora8WhhuTOsVXLBBtDQ5LTG1TMDb73YeDckqCmY6cv6FzpBKCvCMM
        yaW7S7I7DMfM4Y+g5Ic8QVUbEa9faJY/9TWmDR8TAo+fvvkTiTlZD5SFpybiTpTujYV2XM4tSKB
        zixyvanGEe+sWXFdmy8Mo
X-Received: by 2002:a05:622a:188:b0:31e:cdfc:5dca with SMTP id s8-20020a05622a018800b0031ecdfc5dcamr2341524qtw.111.1657734726436;
        Wed, 13 Jul 2022 10:52:06 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1unqQX3V8YOdLFw8RQUJHi8rPR0VdqfRGs7e6Ar3bDXMEoV1Is86VSu9cCoFn3lsLJR+MjliA==
X-Received: by 2002:a05:622a:188:b0:31e:cdfc:5dca with SMTP id s8-20020a05622a018800b0031ecdfc5dcamr2341505qtw.111.1657734726171;
        Wed, 13 Jul 2022 10:52:06 -0700 (PDT)
Received: from zlang-mailbox ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id k11-20020a05620a0b8b00b006b25570d1c2sm11350412qkh.12.2022.07.13.10.52.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Jul 2022 10:52:05 -0700 (PDT)
Date:   Thu, 14 Jul 2022 01:51:59 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, tytso@mit.edu,
        leah.rumancik@gmail.com
Subject: Re: [PATCH 6/8] punch: skip fpunch tests when op length not
 congruent with file allocation unit
Message-ID: <20220713175159.j2xyf5lnxac77jb6@zlang-mailbox>
References: <165767379401.869123.10167117467658302048.stgit@magnolia>
 <165767382771.869123.12118961152998727124.stgit@magnolia>
 <20220713170426.n5kwuvplsdlabr5l@zlang-mailbox>
 <Ys8B0X7iMetn/0Pf@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Ys8B0X7iMetn/0Pf@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jul 13, 2022 at 10:33:05AM -0700, Darrick J. Wong wrote:
> On Thu, Jul 14, 2022 at 01:04:26AM +0800, Zorro Lang wrote:
> > On Tue, Jul 12, 2022 at 05:57:07PM -0700, Darrick J. Wong wrote:
> > > From: Darrick J. Wong <djwong@kernel.org>
> > > 
> > > Skip the generic fpunch tests on a file when the file's allocation unit
> > > size is not congruent with the proposed testing operations.
> > > 
> > > This can be the case when we're testing reflink and fallocate on the XFS
> > > realtime device.  For those configurations, the file allocation unit is
> > > a realtime extent, which can be any integer multiple of the block size.
> > > If the request length isn't an exact multiple of the allocation unit
> > > size, reflink and fallocate will fail due to alignment issues, so
> > > there's no point in running these tests.
> > > 
> > > Assuming this edgecase configuration of an edgecase feature is
> > > vanishingly rare, let's just _notrun the tests instead of rewriting a
> > > ton of tests to do their integrity checking by hand.
> > > 
> > > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > > ---
> > >  common/punch |    1 +
> > >  1 file changed, 1 insertion(+)
> > > 
> > > 
> > > diff --git a/common/punch b/common/punch
> > > index 4d16b898..7560edf8 100644
> > > --- a/common/punch
> > > +++ b/common/punch
> > > @@ -250,6 +250,7 @@ _test_generic_punch()
> > >  	_8k="$((multiple * 8))k"
> > >  	_12k="$((multiple * 12))k"
> > >  	_20k="$((multiple * 20))k"
> > > +	_require_congruent_file_oplen $TEST_DIR $((multiple * 4096))
> > 
> > Should the $TEST_DIR be $testfile, or $(dirname $testfile) ?
> 
> Ah, right, that ought to be $(dirname $testfile), thanks for catching
> that.  I guess I didn't catch that because all the current callers pass
> in $TEST_DIR/<somefile>, which is functionally the same, but a landmine
> nonetheless.

Yeah, I checked all cases which call _test_generic_punch(), they all use
$TEST_DIR. In this patchset (e.g. patch 2/8) you sometimes use $testdir
for _require_congruent_file_oplen, sometimes use $TEST_DIR or $SCRATCH_MNT
directly (even there's $testdir too), although they're not wrong :)

This patchset really touch many cases, they looks good mostly, but to avoid
bringing in regressions, I have to give them more tests before merging. And
welcome more reviewing from others :)

Thanks,
Zorro

> 
> --D
> 
> > >  
> > >  	# initial test state must be defined, otherwise the first test can fail
> > >  	# due ot stale file state left from previous tests.
> > > 
> > 
> 


Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE45FC433FE
	for <linux-xfs@archiver.kernel.org>; Thu,  6 Jan 2022 02:14:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344640AbiAFCOv (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 5 Jan 2022 21:14:51 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:49825 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1344590AbiAFCOt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 5 Jan 2022 21:14:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1641435288;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=fpilRAELkTYshRvM1TKA4gs3hMC4IL7G7fCKIGY67JA=;
        b=IHk/0AZ0EinrKMZPAvfwVofjdJ4fsOln/xlydsDLZ98K9kh75JhMiQ+9JLh74kzD2Qj3Es
        rBsSgESowrCLllvdfA0MayErlvEvuJBb1e3tDHVuHnu2GjxY93lhxWMzmxYu211bh/+0wp
        OOJv0BJHRsuo86d0cyOAh5HWklEpfT4=
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com
 [209.85.214.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-639-00nsamEFMaGUv-Ozd5ZSIQ-1; Wed, 05 Jan 2022 21:14:47 -0500
X-MC-Unique: 00nsamEFMaGUv-Ozd5ZSIQ-1
Received: by mail-pl1-f198.google.com with SMTP id u5-20020a17090341c500b00148cb956f5fso422912ple.17
        for <linux-xfs@vger.kernel.org>; Wed, 05 Jan 2022 18:14:46 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to;
        bh=fpilRAELkTYshRvM1TKA4gs3hMC4IL7G7fCKIGY67JA=;
        b=oOnC+aHxDaVQVzJ42NXM520fvMsnP+abuyx1W+w3x8edhMqTJ0+AEM+wrPPZFMRHKS
         xpOtgq0P/zFXDrixvFLoPkwY1OoxrB7DJIBWsmuKr95ourmcsH1mVEI5wK4wjJv01jY0
         Bf4tiSCwiud/6EwYqpLYf5I04jCOWUF7p4Dc03HT89+X5SAWWV/0qvicFAn3vaWqx+Fc
         P7b5BaJs4mqGftQzvYnlU55LbzyxDwIGL1qnVXboZMAITmb1wdg9OfZUhcA05TQ9jC4k
         6TzE7z4+qYX//iJUdH8CBdU/4Je7JDWFCjYcGV6oGxraOe5Gt7oirBF8ARjBXPcNDbUU
         eGPw==
X-Gm-Message-State: AOAM530avJ3koqNnN25cl6j8qVnUMJ43NDhlvsFc1D7upEOEF++2fCCZ
        Vhi/IAiTZFvTK2WHvlaP0g7sZJzKjvRHQ9VWzFnJ6Iwcv0mgjLJRuGFhoAVWJvsvRNCErwk70kD
        PdSUOrTNwnpLU4J4hrp8b
X-Received: by 2002:a63:b914:: with SMTP id z20mr50969636pge.496.1641435285907;
        Wed, 05 Jan 2022 18:14:45 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwHT1lIKdJE5529qcsXWW4ywSwMBscFPhXvLzEkivxrXb+uofcS4PvpK3mjucmiYkk/3KLdXg==
X-Received: by 2002:a63:b914:: with SMTP id z20mr50969620pge.496.1641435285545;
        Wed, 05 Jan 2022 18:14:45 -0800 (PST)
Received: from zlang-mailbox ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id y126sm352487pfy.40.2022.01.05.18.14.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Jan 2022 18:14:45 -0800 (PST)
Date:   Thu, 6 Jan 2022 10:14:41 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Eryu Guan <guaneryu@gmail.com>, fstests@vger.kernel.org,
        xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs/014: try a few times to create speculative
 preallocations
Message-ID: <20220106021441.dcdcvfi6i376tlpr@zlang-mailbox>
Mail-Followup-To: "Darrick J. Wong" <djwong@kernel.org>,
        Eryu Guan <guaneryu@gmail.com>, fstests@vger.kernel.org,
        xfs <linux-xfs@vger.kernel.org>
References: <20220104020417.GB31566@magnolia>
 <20220105161905.jaobft32wosjy3fv@zlang-mailbox>
 <20220105190957.GJ656707@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220105190957.GJ656707@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jan 05, 2022 at 11:09:57AM -0800, Darrick J. Wong wrote:
> On Thu, Jan 06, 2022 at 12:19:05AM +0800, Zorro Lang wrote:
> > On Mon, Jan 03, 2022 at 06:04:17PM -0800, Darrick J. Wong wrote:
> > > From: Darrick J. Wong <djwong@kernel.org>
> > > 
> > > This test checks that speculative file preallocations are transferred to
> > > threads writing other files when space is low.  Since we have background
> > > threads to clear those preallocations, it's possible that the test
> > > program might not get a speculative preallocation on the first try.
> > > 
> > > This problem has become more pronounced since the introduction of
> > > background inode inactivation since userspace no longer has direct
> > > control over the timing of file blocks being released from unlinked
> > > files.  As a result, the author has seen an increase in sporadic
> > > warnings from this test about speculative preallocations not appearing.
> > > 
> > > Therefore, modify the function to try up to five times to create the
> > > speculative preallocation before emitting warnings that then cause
> > > golden output failures.
> > > 
> > > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > > ---
> > >  tests/xfs/014 |   41 +++++++++++++++++++++++++----------------
> > >  1 file changed, 25 insertions(+), 16 deletions(-)
> > > 
> > > diff --git a/tests/xfs/014 b/tests/xfs/014
> > > index a605b359..1f0ebac3 100755
> > > --- a/tests/xfs/014
> > > +++ b/tests/xfs/014
> > > @@ -33,27 +33,36 @@ _cleanup()
> > >  # failure.
> > >  _spec_prealloc_file()
> > >  {
> > > -	file=$1
> > > +	local file=$1
> > > +	local prealloc_size=0
> > > +	local i=0
> > >  
> > > -	rm -f $file
> > > +	# Now that we have background garbage collection processes that can be
> > > +	# triggered by low space/quota conditions, it's possible that we won't
> > > +	# succeed in creating a speculative preallocation on the first try.
> > > +	for ((tries = 0; tries < 5 && prealloc_size == 0; tries++)); do
> > > +		rm -f $file
> > >  
> > > -	# a few file extending open-write-close cycles should be enough to
> > > -	# trigger the fs to retain preallocation. write 256k in 32k intervals to
> > > -	# be sure
> > > -	for i in $(seq 0 32768 262144); do
> > > -		$XFS_IO_PROG -f -c "pwrite $i 32k" $file >> $seqres.full
> > > +		# a few file extending open-write-close cycles should be enough
> > > +		# to trigger the fs to retain preallocation. write 256k in 32k
> > > +		# intervals to be sure
> > > +		for i in $(seq 0 32768 262144); do
> > > +			$XFS_IO_PROG -f -c "pwrite $i 32k" $file >> $seqres.full
> > > +		done
> > > +
> > > +		# write a 4k aligned amount of data to keep the calculations
> > > +		# simple
> > > +		$XFS_IO_PROG -c "pwrite 0 128m" $file >> $seqres.full
> > > +
> > > +		size=`_get_filesize $file`
> > > +		blocks=`stat -c "%b" $file`
> > > +		blocksize=`stat -c "%B" $file`
> > > +
> > > +		prealloc_size=$((blocks * blocksize - size))
> > 
> > So we only try same pwrite operations 5 times, and only check the prealloc_size after 5
> > times done? Should we break from this loop once prealloc_size > 0?
> 
> The second clause of the for loop tests for that, does it not?

Oh, yes, sorry I missed the "&& prealloc_size == 0", I thought you just gave it 5 tries :)
So this patch is good to me.

Reviewed-by: Zorro Lang <zlang@redhat.com>

> 
> --D
> 
> > 
> > Thanks,
> > Zorro
> > 
> > >  	done
> > >  
> > > -	# write a 4k aligned amount of data to keep the calculations simple
> > > -	$XFS_IO_PROG -c "pwrite 0 128m" $file >> $seqres.full
> > > -
> > > -	size=`_get_filesize $file`
> > > -	blocks=`stat -c "%b" $file`
> > > -	blocksize=`stat -c "%B" $file`
> > > -
> > > -	prealloc_size=$((blocks * blocksize - size))
> > >  	if [ $prealloc_size -eq 0 ]; then
> > > -		echo "Warning: No speculative preallocation for $file." \
> > > +		echo "Warning: No speculative preallocation for $file after $tries iterations." \
> > >  			"Check use of the allocsize= mount option."
> > >  	fi
> > >  
> > > 
> > 
> 


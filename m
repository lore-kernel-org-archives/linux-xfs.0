Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B65AC61DA4
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Feb 2023 14:58:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229674AbjBPO64 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Feb 2023 09:58:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229704AbjBPO64 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Feb 2023 09:58:56 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB82A4C3EE
        for <linux-xfs@vger.kernel.org>; Thu, 16 Feb 2023 06:57:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1676559447;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=QdEdZZH1sp+EoGk6EFxFzqSvhRlpyVozLomptTXre8o=;
        b=Wdk6Ll3L0SfT9PFHsv9F28b1JYg3+C9CF146dZqmZ9pGLZvZmrOsbnaZYLAhOicifUvHfa
        5fgLW05PfblLDMzsDpG8eqLA/AnKlomg2XuGxW0U+D2lAtVQED/FKGLenZjDeCaAAsfWMD
        sRMB1+KjpdYO4z1Xb9JOJQ+K5TWMbT0=
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com
 [209.85.215.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-646-8stXZAg2PliTNeRfqpI41Q-1; Thu, 16 Feb 2023 09:57:26 -0500
X-MC-Unique: 8stXZAg2PliTNeRfqpI41Q-1
Received: by mail-pg1-f197.google.com with SMTP id o19-20020a63fb13000000b004fb5e56e652so920205pgh.9
        for <linux-xfs@vger.kernel.org>; Thu, 16 Feb 2023 06:57:25 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QdEdZZH1sp+EoGk6EFxFzqSvhRlpyVozLomptTXre8o=;
        b=UNKDf8hgGln88bSkygd7he99HSB5dkne1K+vK3zuYV1GBKQUsGq0Ev61JzybN7c+RR
         DUXzX6F7n+1TECTVno6bdD04U8VtsrGntdsreiodrLhT5d7qtjlV1dNwmU2ZnNtW10jR
         u8OqKV2fjF956Sza+RlXqsENvXhk9FnnZ1mcWSTPsq9hJwcu+wOowjKg66oMOLoTSG/G
         d5yQ0chcZBlISkr2bwzcxhafw7TN9gD9ywhIu/oPGr9vDFdAEXSxD/ogCINk3SCuL6vH
         IWL5Zhn5ZHLUfMJ5Ygcl3D2v+Zd8aiB//HchpT+w1wLgJPDC9IY6BfIPHDYRwLVQVJEa
         tOzg==
X-Gm-Message-State: AO0yUKUu5KYtmrjYDVk0M6SIIsQzvLl6JxqW1SccBxW8vguPVeTAg4zJ
        m339HaT5c9dG6UwS2TfyD20Vx1Epzcf29eM2G/QKzLeRGj1h6es7o38RFTJBusN8qJNbRvd6Wlm
        TtzbZP5xojZLyFai4JBPq/tgzX7TERWM=
X-Received: by 2002:a17:90a:35d:b0:233:c301:32c5 with SMTP id 29-20020a17090a035d00b00233c30132c5mr7215410pjf.45.1676559444721;
        Thu, 16 Feb 2023 06:57:24 -0800 (PST)
X-Google-Smtp-Source: AK7set9tn96Fk8+3ASn8R6UyKXaaBHqm2+NYuqL46X1BoAISw5l+77hCYvYvSDjLI16eCroqpDGQCw==
X-Received: by 2002:a17:90a:35d:b0:233:c301:32c5 with SMTP id 29-20020a17090a035d00b00233c30132c5mr7215391pjf.45.1676559444365;
        Thu, 16 Feb 2023 06:57:24 -0800 (PST)
Received: from zlang-mailbox ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id o18-20020a17090ac09200b00233e8a83853sm1316094pjs.34.2023.02.16.06.57.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Feb 2023 06:57:23 -0800 (PST)
Date:   Thu, 16 Feb 2023 22:57:19 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 1/1] fuzzy: use FORCE_REBUILD over injecting force_repair
Message-ID: <20230216145719.2e45h7czgbuxc7mh@zlang-mailbox>
References: <167243874952.722591.1496636246267309523.stgit@magnolia>
 <167243874964.722591.9199494099572054329.stgit@magnolia>
 <20230214080007.i7m5hzlcmthd6ka3@zlang-mailbox>
 <Y+vQbNSkDoxsxU1i@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y+vQbNSkDoxsxU1i@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Feb 14, 2023 at 10:18:20AM -0800, Darrick J. Wong wrote:
> On Tue, Feb 14, 2023 at 04:00:07PM +0800, Zorro Lang wrote:
> > On Fri, Dec 30, 2022 at 02:19:09PM -0800, Darrick J. Wong wrote:
> > > From: Darrick J. Wong <djwong@kernel.org>
> > > 
> > > For stress testing online repair, try to use the FORCE_REBUILD ioctl
> > > flag over the error injection knobs whenever possible because the knobs
> > > are very noisy and are not always available.
> > > 
> > > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > > ---
> > >  common/fuzzy |   34 +++++++++++++++++++++++++++++++---
> > >  1 file changed, 31 insertions(+), 3 deletions(-)
> > > 
> > > 
> > > diff --git a/common/fuzzy b/common/fuzzy
> > > index f7f660bc31..14f7fdf03c 100644
> > > --- a/common/fuzzy
> > > +++ b/common/fuzzy
> > > @@ -398,6 +398,9 @@ __stress_one_scrub_loop() {
> > >  
> > >  	local xfs_io_args=()
> > >  	for arg in "$@"; do
> > > +		if [ -n "$SCRUBSTRESS_USE_FORCE_REBUILD" ]; then
> > > +			arg="$(echo "$arg" | sed -e 's/^repair/repair -R/g')"
> > > +		fi
> > >  		if echo "$arg" | grep -q -w '%agno%'; then
> > >  			# Substitute the AG number
> > >  			for ((agno = 0; agno < agcount; agno++)); do
> > > @@ -695,13 +698,21 @@ _require_xfs_stress_scrub() {
> > >  		_notrun 'xfs scrub stress test requires common/filter'
> > >  }
> > >  
> > > +# Make sure that we can force repairs either by error injection or passing
> > > +# FORCE_REBUILD via ioctl.
> > > +__require_xfs_stress_force_rebuild() {
> > > +	local output="$($XFS_IO_PROG -x -c 'repair -R probe' $SCRATCH_MNT 2>&1)"
> > > +	test -z "$output" && return
> > > +	_require_xfs_io_error_injection "force_repair"
> > > +}
> > > +
> > >  # Make sure we have everything we need to run stress and online repair
> > >  _require_xfs_stress_online_repair() {
> > >  	_require_xfs_stress_scrub
> > >  	_require_xfs_io_command "repair"
> > >  	command -v _require_xfs_io_error_injection &>/dev/null || \
> > >  		_notrun 'xfs repair stress test requires common/inject'
> > > -	_require_xfs_io_error_injection "force_repair"
> > > +	__require_xfs_stress_force_rebuild
> > >  	_require_freeze
> > >  }
> > >  
> > > @@ -783,7 +794,11 @@ __stress_scrub_check_commands() {
> > >  	esac
> > >  
> > >  	for arg in "$@"; do
> > > -		local cooked_arg="$(echo "$arg" | sed -e "s/%agno%/0/g")"
> > > +		local cooked_arg="$arg"
> > > +		if [ -n "$SCRUBSTRESS_USE_FORCE_REBUILD" ]; then
> > > +			cooked_arg="$(echo "$cooked_arg" | sed -e 's/^repair/repair -R/g')"
> > > +		fi
> > > +		cooked_arg="$(echo "$cooked_arg" | sed -e "s/%agno%/0/g")"
> > >  		testio=`$XFS_IO_PROG -x -c "$cooked_arg" "$cooked_tgt" 2>&1`
> > >  		echo $testio | grep -q "Unknown type" && \
> > >  			_notrun "xfs_io scrub subcommand support is missing"
> > > @@ -943,10 +958,23 @@ _scratch_xfs_stress_scrub() {
> > >  	echo "Loop finished at $(date)" >> $seqres.full
> > >  }
> > >  
> > > +# Decide if we're going to force repairs either by error injection or passing
> > > +# FORCE_REBUILD via ioctl.
> > > +__scratch_xfs_stress_setup_force_rebuild() {
> > > +	local output="$($XFS_IO_PROG -x -c 'repair -R probe' $SCRATCH_MNT 2>&1)"
> > > +
> > > +	if [ -z "$output" ]; then
> > > +		export SCRUBSTRESS_USE_FORCE_REBUILD=1
> > 
> > Do you need to use this parameter ^^ in another child process? Is the "export"
> > necessary?
> 
> Nope, it's not required.

OK, others looks good to me, will merge this patch without that "export".

Reviewed-by: Zorro Lang <zlang@redhat.com>

> 
> --D
> 
> > Thanks,
> > Zorro
> > 
> > > +		return
> > > +	fi
> > > +
> > > +	$XFS_IO_PROG -x -c 'inject force_repair' $SCRATCH_MNT
> > > +}
> > > +
> > >  # Start online repair, freeze, and fsstress in background looping processes,
> > >  # and wait for 30*TIME_FACTOR seconds to see if the filesystem goes down.
> > >  # Same requirements and arguments as _scratch_xfs_stress_scrub.
> > >  _scratch_xfs_stress_online_repair() {
> > > -	$XFS_IO_PROG -x -c 'inject force_repair' $SCRATCH_MNT
> > > +	__scratch_xfs_stress_setup_force_rebuild
> > >  	XFS_SCRUB_FORCE_REPAIR=1 _scratch_xfs_stress_scrub "$@"
> > >  }
> > > 
> > 
> 


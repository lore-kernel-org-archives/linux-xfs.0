Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1986AC4320E
	for <linux-xfs@archiver.kernel.org>; Mon,  2 Aug 2021 22:13:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F2CBE60724
	for <linux-xfs@archiver.kernel.org>; Mon,  2 Aug 2021 22:13:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233032AbhHBWOE (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 2 Aug 2021 18:14:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:60516 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232594AbhHBWOD (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 2 Aug 2021 18:14:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B6C1560EBC;
        Mon,  2 Aug 2021 22:13:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627942433;
        bh=2zR9Pwz9eeErn2uwEyYrKf55NoJxQB+/eWsNG3Nm2q0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Ber45PyHS3S7wmFDrKR74UhTkSiryFBmLbr5nPhaT8nP1j5ur7XmbB9LiZGnyI15d
         5absG9CsUgiCFAXOFIbkesvyqlDhxCQuogVFZc4FTrqbWCE1U/KeWpcT54oR8Dk3ek
         IfeZOQeHWiPhUZ9pHTuue4Eva7m9nh8HaWQI4Mg+aslrXTlZZyvxWGTSKsylGE6LN/
         6c3MbI3d3QwigOWh9kax0XVOqWSGlgRembJmAoWg70R1rNYzDKvAraUG901JKky3bX
         OZIIg168O29RMRv8mES9K1pA14zztla75mngyZzEz2Qey+eQ0RKH99cQvf6p0up0It
         dAyYyQHp3j3Ng==
Date:   Mon, 2 Aug 2021 15:13:53 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Eryu Guan <guan@eryu.me>
Cc:     guaneryu@gmail.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org
Subject: Re: [PATCH 2/4] check: don't leave the scratch filesystem mounted
 after _notrun
Message-ID: <20210802221353.GI3601466@magnolia>
References: <162743097757.3427426.8734776553736535870.stgit@magnolia>
 <162743098874.3427426.3383033227839715899.stgit@magnolia>
 <YQabVTp2WOh2VjIn@desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YQabVTp2WOh2VjIn@desktop>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Aug 01, 2021 at 09:02:13PM +0800, Eryu Guan wrote:
> On Tue, Jul 27, 2021 at 05:09:48PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Unmount the scratch filesystem if a test decides to _notrun itself
> > because _try_wipe_scratch_devs will not be able to wipe the scratch
> > device prior to the next test run.  We don't want to let scratch state
> > from one test leak into subsequent tests if we can help it.
> > 
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > ---
> >  check |    5 +++++
> >  1 file changed, 5 insertions(+)
> > 
> > 
> > diff --git a/check b/check
> > index bb7e030c..5d71b74c 100755
> > --- a/check
> > +++ b/check
> > @@ -871,6 +871,11 @@ function run_section()
> >  			notrun="$notrun $seqnum"
> >  			n_notrun=`expr $n_notrun + 1`
> >  			tc_status="notrun"
> > +
> > +			# Unmount the scratch fs so that we can wipe the scratch
> > +			# dev state prior to the next test run.
> > +			_scratch_unmount 2> /dev/null
> > +			rm -f ${RESULT_DIR}/require_scratch*
> 
> I think _notrun has removed $RESULT_DIR/require_scratch* already, and we
> could remove above line. I'll remove it on commit.

Ok, thanks!

--D

> 
> Thanks,
> Eryu
> 
> >  			continue;
> >  		fi
> >  

Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38B01C43381
	for <linux-xfs@archiver.kernel.org>; Fri, 15 Jan 2021 00:40:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0615023AC2
	for <linux-xfs@archiver.kernel.org>; Fri, 15 Jan 2021 00:40:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731418AbhAOAkN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 14 Jan 2021 19:40:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:49990 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731392AbhAOAkI (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 14 Jan 2021 19:40:08 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3F3D223A5E;
        Fri, 15 Jan 2021 00:39:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610671167;
        bh=FpNYRjh/pq5wh5A71F1m4fK2a0n0689CHrop+no5hig=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=gIGAGAT6TSFOSuUj+aPAAC7XomypxWp+AqoW1pn0vvjV53qmrzC1Khyu0piN/vfC1
         iTU4sxXApRkxIab633xYTEQE29/CE7QmMX9+1nz1OrQmxTeeatphO4qdQ+QM/af4xE
         ywsMBxB9qg/4tsFtV1YVVPk64zWbwwmwe4K4gXT2vmSTvLwBb/uCbAj3HodM+9lyBM
         aMhICLv1p6caDELhV7QH7FzePBUBytnp7OVDdnKA8T06faFDTfr02C/OWC4cKLnUk0
         RwUR98NI6/2GLQA7d8zak2YtDMk4ICsL5u5BAT+G0C2956puBy6KAUuWyiviPokeAi
         jJAUckAVAOEkA==
Date:   Thu, 14 Jan 2021 16:39:26 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     John 'Warthog9' Hawley <warthog9@kernel.org>
Cc:     "Darrick J. Wong" <djwong@kernel.org>, postmaster@vger.kernel.org,
        xfs <linux-xfs@vger.kernel.org>
Subject: Re: Undelivered Mail Returned to Sender
Message-ID: <20210115003926.GH1164248@magnolia>
References: <20210114204233.4E53323AFC@mail.kernel.org>
 <20210114210253.GE1164248@magnolia>
 <87455a93-7f61-d056-df10-9d574303f875@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87455a93-7f61-d056-df10-9d574303f875@kernel.org>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

[cc linux-xfs so that I don't get accused of sending private replies to
patch submissions]

On Thu, Jan 14, 2021 at 01:20:46PM -0800, John 'Warthog9' Hawley wrote:
> So I'm not sure how this isn't self explanatory: the message tripped the
> bayesian spam filter used on vger.

Yes, the fact that a bayesian spam filter was tripped is obvious, but
the question is, what sort of training data was put into the bayesian
filter such that it tripped?  And what has that model internalized?

> The ascii armoured gpg key is likely what tripped it up as that just
> looks like a big blob of data to the filter, likely similar to a base64
> encoded block and it decided that it was likely spam as a result.

There we go ^^^, that's the kind of insight I was looking for.  I'm a bit
surprised that it triggered on my *reply*, seeing as it let the original
through:

https://lore.kernel.org/linux-xfs/20210114183747.2507-2-bastiangermann@fishpost.de/T/#u

> Just because it was sent through kernel.org doesn't bypass the spam
> filter.
> 
> As the bounce suggests, if you save the message and send it to us as an
> attachment we can use it to help train the filter so it doesn't trigger
> on that in the future.

OK, I'll resend the message as an attachment....

--D

> - John 'Warthog9' Hawley
> 
> On 1/14/21 1:02 PM, Darrick J. Wong wrote:
> > Um, hi.  I sent this message through kernel.org; why does that get
> > bounced by vger?  "Bayes statistical bogofilter" doesn't help diagnose
> > this...
> > 
> > --D
> > 
> > On Thu, Jan 14, 2021 at 08:42:33PM +0000, Mail Delivery System wrote:
> >> This is the mail system at host mail.kernel.org.
> >>
> >> I'm sorry to have to inform you that your message could not
> >> be delivered to one or more recipients. It's attached below.
> >>
> >> For further assistance, please send mail to postmaster.
> >>
> >> If you do so, please include this problem report. You can
> >> delete your own text from the attached returned message.
> >>
> >>                    The mail system
> >>
> >> <linux-xfs@vger.kernel.org>: host vger.kernel.org[23.128.96.18] said: 550 5.7.1
> >>     Content-Policy accept-into-freezer-1 msg: Bayes Statistical Bogofilter
> >>     considers this message SPAM.  BF:<S 1>  In case you disagree, send the
> >>     ENTIRE message plus this error message to <postmaster@vger.kernel.org> ;
> >>     S1726461AbhANUmc (in reply to end of DATA command)
> > 
> >> Reporting-MTA: dns; mail.kernel.org
> >> X-Postfix-Queue-ID: BCE3A23A9D
> >> X-Postfix-Sender: rfc822; djwong@kernel.org
> >> Arrival-Date: Thu, 14 Jan 2021 20:41:51 +0000 (UTC)
> >>
> >> Final-Recipient: rfc822; linux-xfs@vger.kernel.org
> >> Original-Recipient: rfc822;linux-xfs@vger.kernel.org
> >> Action: failed
> >> Status: 5.7.1
> >> Remote-MTA: dns; vger.kernel.org
> >> Diagnostic-Code: smtp; 550 5.7.1 Content-Policy accept-into-freezer-1 msg:
> >>     Bayes Statistical Bogofilter considers this message SPAM.  BF:<S 1>  In
> >>     case you disagree, send the ENTIRE message plus this error message to
> >>     <postmaster@vger.kernel.org> ; S1726461AbhANUmc
> > 
> >> Date: Thu, 14 Jan 2021 12:41:51 -0800
> >> From: "Darrick J. Wong" <djwong@kernel.org>
> >> To: Bastian Germann <bastiangermann@fishpost.de>
> >> Cc: linux-xfs@vger.kernel.org
> >> Subject: Re: [PATCH 1/6] debian: cryptographically verify upstream tarball
> >>
> >> On Thu, Jan 14, 2021 at 07:37:42PM +0100, Bastian Germann wrote:
> >>> Debian's uscan utility can verify a downloaded tarball. As the
> >>> uncompressed tarball is signed, the decompress rule has to be applied.
> >>
> >> Er.... whose key is below?  Eric Sandeen's, I guess?
> >>
> >> (Please state where this keyblock came from in the commit message...)
> >>
> >> --D

<the rest of the message is snipped>

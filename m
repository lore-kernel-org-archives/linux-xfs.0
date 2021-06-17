Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B81A1C48BE5
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Jun 2021 00:02:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9EABD613B9
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Jun 2021 00:02:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231176AbhFQAEQ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 16 Jun 2021 20:04:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:55910 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230481AbhFQAEP (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 16 Jun 2021 20:04:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 21BC761351;
        Thu, 17 Jun 2021 00:02:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623888129;
        bh=O58XgtaaCnHtwpyvd6cc2YsvEKu9fSJlv0TRaUcE2oc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=JBoSvlzf+dzEwAhMGp7s2mdV4uciqd2V2AogKsfaz148erfFo65e8v9FOlvU0e565
         R1KVnEEJvbUcfrLub8iPkRQwx26mhfk6srYly2KcQJQVjszIqKSoM6+D9Ucq61EfA0
         W754bna0kyjK3Nr0Cf6VPO4U2AIl6iZvAHG5qBaFWwDWorKCRShFVDckMxPGVF4tQb
         xcKjafP5UlABokZpStJRAppqmY5sy2V4w6ycB5CWqfD4OfecsbUzx1NT+Z2cKiGMrb
         ELooc7URoCuK0W6gn6tgQ/BFYo/MMx/FWCGOG6hY+GBrprYU09otVVWtpYPdKIvTYM
         T3HFSFF+ocSVg==
Date:   Wed, 16 Jun 2021 17:02:08 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     guaneryu@gmail.com, Chandan Babu R <chandanrlinux@gmail.com>,
        Allison Henderson <allison.henderson@oracle.com>,
        linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me,
        amir73il@gmail.com
Subject: Re: [PATCH 03/13] fstests: refactor test boilerplate code
Message-ID: <20210617000208.GG158209@locust>
References: <162370433910.3800603.9623820748404628250.stgit@locust>
 <162370435585.3800603.509157515145342966.stgit@locust>
 <YMpjZGaR9IKfzGax@sol.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YMpjZGaR9IKfzGax@sol.localdomain>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jun 16, 2021 at 01:47:32PM -0700, Eric Biggers wrote:
> On Mon, Jun 14, 2021 at 01:59:15PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Create two new helper functions to deal with boilerplate test code:
> > 
> > A helper function to set the seq and seqnum variables.  We will expand
> > on this in the next patch so that fstests can autogenerate group files
> > from now on.
> > 
> > A helper function to register cleanup code that will run if the test
> > exits or trips over a standard range of signals.
> > 
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>
> > Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
> 
> Looks good:
> 
> Reviewed-by: Eric Biggers <ebiggers@google.com>
> 
> A couple nits below:
> 
> > +# Standard cleanup function.  Individual tests should override this.
> > +_cleanup()
> > +{
> > +	cd /
> > +	rm -r -f $tmp.*
> > +}
> 
> It should say "can override this", not "should override this".

Fixed.

> > +# Initialize the global seq, seqres, here, tmp, and status variables to their
> > +# defaults.  Group memberships are the only arguments to this helper.
> > +_begin_fstest()
> > +{
> 
> This function does more than what the comment says.  It should say something
> more along the lines of "Prepare for executing a fstest by initializing some
> global variables, registering a default cleanup function, importing helper
> functions, and removing $seqres.full.  This must be passed the list of groups to
> which the test belongs."

Ok, I'll change that.

# Prepare to run a fstest by initializing the global seq, seqres, here,
# tmp, and status variables to their defaults, importing common
# functions, registering a cleanup function, and removing the
# $seqres.full file.
#
# The list of group memberships for this test (e.g. auto quick rw) must
# be passed as arguments to this helper.  It is not necessary to name
# this test explicitly as a member of the 'all' group.

--D

> 
> - Eric

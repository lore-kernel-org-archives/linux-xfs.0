Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F163DC433E0
	for <linux-xfs@archiver.kernel.org>; Tue, 16 Mar 2021 15:37:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A8A85650EB
	for <linux-xfs@archiver.kernel.org>; Tue, 16 Mar 2021 15:37:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229901AbhCPPga (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 16 Mar 2021 11:36:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:46046 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231319AbhCPPgG (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 16 Mar 2021 11:36:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 194D6650EB;
        Tue, 16 Mar 2021 15:36:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615908965;
        bh=mHIfCXVj4cvLw7QWuHk2DGaJUxchGlVq7sLfVH56oaY=;
        h=Date:From:To:Subject:References:In-Reply-To:From;
        b=GhUpcHYP/Sz3o2XGz4Vw7wasDvDFUJB1qXEEy/r75qQur2PMxUGh09mvyP+JQkk1e
         ZogAWrKUxl+TAq7L7gTDC4oPLj2Vvmul7XXlz7wKtKioNE/oJ1zEk2Bn6SJozSwzuj
         blUO+dTqHARpCJ0ydJ/XoyrChTbjZJfIHcrNm/qYBDALnEFMjjo5laqacdx//hHy85
         c+eJIJHvJ2ndvq/Ea0delOcsCKBZpumAYJ08k/Eb785c1Vmf29ze+c/BLn679oUKao
         u6RfRxL2N1OEqFiwG4bjgrE2PvnCqfXhXPwEv4x8TR8ijaVceGk9embtUBDDGltroU
         ua4dTIJgePvfA==
Date:   Tue, 16 Mar 2021 08:36:04 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Eric Sandeen <sandeen@sandeen.net>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs_logprint: Fix buffer overflow printing quotaoff
Message-ID: <20210316153604.GH22100@magnolia>
References: <20210316090400.35180-1-cmaiolino@redhat.com>
 <0a4f390e-53d2-7be9-fc6b-6064f4f8249b@sandeen.net>
 <20210316141044.4myelroxkotnq57h@andromeda.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210316141044.4myelroxkotnq57h@andromeda.lan>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Mar 16, 2021 at 03:10:44PM +0100, Carlos Maiolino wrote:
> On Tue, Mar 16, 2021 at 08:45:20AM -0500, Eric Sandeen wrote:
> > On 3/16/21 4:04 AM, Carlos Maiolino wrote:
> > > xlog_recover_print_quotaoff() was using a static buffer to aggregate
> > > quota option strings to be printed at the end. The buffer size was
> > > miscalculated and when printing all 3 flags, a buffer overflow occurs
> > > crashing xfs_logprint, like:
> > > 
> > > QOFF: cnt:1 total:1 a:0x560530ff3bb0 len:160
> > > *** buffer overflow detected ***: terminated
> > > Aborted (core dumped)
> > > 
> > > Fix this by removing the static buffer and using printf() directly to
> > > print each flag. 
> > 
> > Yeah, that makes sense. Not sure why it was using a static buffer,
> > unless I was missing something?
> > 
> > > Also add a trailling space before each flag, so they
> > 
> > "trailing space before?" :) I can fix that up on commit.
> 
> Maybe I slipped into my words here... The current printed format, did something
> like this:
> 
> type: USER QUOTAGROUP QUOTAPROJECT QUOTA
> 
> I just added a space before each flag string, to print like this:
> 
> type: USER QUOTA GROUP QUOTA PROJECT QUOTA

Any reason we can't just shorten this to "type: USER GROUP PUOTA" ?

--D

> 
> 
> > >  	if (qoff_f->qf_flags & XFS_UQUOTA_ACCT)
> > > -		strcat(str, "USER QUOTA");
> > > +		printf(" USER QUOTA");
> 			^ here (an in the remaining ones)
> 
> > >  	if (qoff_f->qf_flags & XFS_GQUOTA_ACCT)
> > > -		strcat(str, "GROUP QUOTA");
> > > +		printf(" GROUP QUOTA");
> > >  	if (qoff_f->qf_flags & XFS_PQUOTA_ACCT)
> > > -		strcat(str, "PROJECT QUOTA");
> > > -	printf(_("\tQUOTAOFF: #regs:%d   type:%s\n"),
> > > -	       qoff_f->qf_size, str);
> > > +		printf(" PROJECT QUOTA");
> > 
> > Seems like a clean solution, thanks.
> > 
> > Reviewed-by: Eric Sandeen <sandeen@redhat.com>
> > 
> > > +	printf("\n");
> > >  }
> > >  
> > >  STATIC void
> > > 
> > 
> 
> -- 
> Carlos
> 

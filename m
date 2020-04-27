Return-Path: <SRS0=n/sd=6L=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1478EC4CECC
	for <linux-xfs@archiver.kernel.org>; Mon, 27 Apr 2020 18:36:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E888A20B1F
	for <linux-xfs@archiver.kernel.org>; Mon, 27 Apr 2020 18:36:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1588012593;
	bh=4yeOpdjOcM2uN050wdKefgY2OBgaSb4yMnUi7uul+W0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=OZ0X9S3Lwmw7Z8qcclmKt9M4OtjyEYagGZI2dO7XvRfu09TWjAECcPtIoGV2v1v+i
	 IN+UOx05p/IAZqnZY7yBqcZUUELXF5dYEKQuG31HOgL8KPKOMTBMNsV+Mi79PkOVn8
	 BnDRq8lMHtxRRt/n5ALz+7+0bEsYug2ckmNCrWq8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726223AbgD0Sgc (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 27 Apr 2020 14:36:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:50930 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725995AbgD0Sgc (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 27 Apr 2020 14:36:32 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 15BB7205C9;
        Mon, 27 Apr 2020 18:36:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588012591;
        bh=4yeOpdjOcM2uN050wdKefgY2OBgaSb4yMnUi7uul+W0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=H7bCoGTr/tECOY3qgcnHq/ocLAWoZIXkwN70/+6lyh3D6MNRzf+Pzupd4xvJhqeGR
         qOk52AEITmb8R7rPaeRk7HkZzuwd3eTc2C4xSA03QFva/jne/qd9gG57rYLi8ypQEn
         hDKYf5BfKz7uCETo7/ZFtbOsH1FwpzKqMRK2z+E8=
Date:   Mon, 27 Apr 2020 20:36:29 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Joe Perches <joe@perches.com>
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Kate Stewart <kstewart@linuxfoundation.org>,
        Nishad Kamdar <nishadkamdar@gmail.com>,
        Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
        <u.kleine-koenig@pengutronix.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] xfs: Use the correct style for SPDX License Identifier
Message-ID: <20200427183629.GA20158@kroah.com>
References: <20200425133504.GA11354@nishad>
 <20200427155617.GY6749@magnolia>
 <20200427172959.GB3936841@kroah.com>
 <515362d10c06567f35f0d5b7c3f2e121769fb04b.camel@perches.com>
 <20200427174611.GA4035548@kroah.com>
 <791a97d5d4dfd11af533a0bbd6ae27d1a2d479ee.camel@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <791a97d5d4dfd11af533a0bbd6ae27d1a2d479ee.camel@perches.com>
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Apr 27, 2020 at 11:01:38AM -0700, Joe Perches wrote:
> On Mon, 2020-04-27 at 19:46 +0200, Greg Kroah-Hartman wrote:
> > On Mon, Apr 27, 2020 at 10:41:58AM -0700, Joe Perches wrote:
> > > On Mon, 2020-04-27 at 19:29 +0200, Greg Kroah-Hartman wrote:
> > > > On Mon, Apr 27, 2020 at 08:56:18AM -0700, Darrick J. Wong wrote:
> > > > > On Sat, Apr 25, 2020 at 07:05:09PM +0530, Nishad Kamdar wrote:
> > > > > > This patch corrects the SPDX License Identifier style in
> > > > > > header files related to XFS File System support.
> > > > > > For C header files Documentation/process/license-rules.rst
> > > > > > mandates C-like comments (opposed to C source files where
> > > > > > C++ style should be used).
> > > > > > 
> > > > > > Changes made by using a script provided by Joe Perches here:
> > > > > > https://lkml.org/lkml/2019/2/7/46.
> > > []
> > > > > > diff --git a/fs/xfs/libxfs/xfs_ag_resv.h b/fs/xfs/libxfs/xfs_ag_resv.h
> > > []
> > > > > > @@ -1,4 +1,4 @@
> > > > > > -// SPDX-License-Identifier: GPL-2.0+
> > > > > > +/* SPDX-License-Identifier: GPL-2.0+ */
> > > > > 
> > > > > I thought we were supposed to use 'GPL-2.0-or-newer' because 'GPL-2.0+'
> > > > > is deprecated in some newer version of the SPDX standard?
> > > > > 
> > > > > <shrug>
> > > > 
> > > > The kernel follows the "older" SPDX standard, but will accept either,
> > > > it's up to the author.  It is all documented in LICENSES/ if people
> > > > really want to make sure.
> > > 
> > > I think the kernel should prefer the "newer" SPDX standard
> > > for any/all changes to these lines.
> > > ---
> > >  LICENSES/preferred/GPL-2.0 | 8 ++++----
> > >  1 file changed, 4 insertions(+), 4 deletions(-)
> > > 
> > > diff --git a/LICENSES/preferred/GPL-2.0 b/LICENSES/preferred/GPL-2.0
> > > index ff0812..c50f93 100644
> > > --- a/LICENSES/preferred/GPL-2.0
> > > +++ b/LICENSES/preferred/GPL-2.0
> > > @@ -8,13 +8,13 @@ Usage-Guide:
> > >    tag/value pairs into a comment according to the placement
> > >    guidelines in the licensing rules documentation.
> > >    For 'GNU General Public License (GPL) version 2 only' use:
> > > -    SPDX-License-Identifier: GPL-2.0
> > > -  or
> > >      SPDX-License-Identifier: GPL-2.0-only
> > > +  or the deprecated alternative
> > > +    SPDX-License-Identifier: GPL-2.0
> > >    For 'GNU General Public License (GPL) version 2 or any later version' use:
> > > -    SPDX-License-Identifier: GPL-2.0+
> > > -  or
> > >      SPDX-License-Identifier: GPL-2.0-or-later
> > > +  or the deprecated alternative
> > > +    SPDX-License-Identifier: GPL-2.0+
> > >  License-Text:
> > 
> > At the moment, I do not, as the current ones are not "depreciated" at
> > all.
> 
> https://spdx.org/licenses/
> 
> shows the GPL-2.0 and GPL-2.0+ as deprecated.
> 
> https://spdx.org/licenses/GPL-2.0.html
> https://spdx.org/licenses/GPL-2.0+.html
> 

Again, we are not using the "new" version of the SPDX specification just
yet.  We started out using one specific version, let's get the whole
kernel converted first before worrying about trying to keep up with
their newer releases please.  We still have a ways to go...

thanks,

greg k-h

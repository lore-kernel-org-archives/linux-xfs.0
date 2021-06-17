Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5CF1C48BE8
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Jun 2021 00:11:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8272C613BF
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Jun 2021 00:11:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234660AbhFQANP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 16 Jun 2021 20:13:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:56866 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234895AbhFQANP (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 16 Jun 2021 20:13:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 430CE613BD;
        Thu, 17 Jun 2021 00:11:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623888668;
        bh=nhg+Fy1fIiG3Vno1vgDqYmHtLHajvRjl9dqzcLq4ZoU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=j/M90DsaReYLA6aCxeuNmOEt8BCo58FjJJ9uI8dHsBTXF/7q7pvaMxXrLqi7EDMbF
         GGkPJk4VLkjyzHnHMlHVbAiq/YIbpWE8y8OGhG1avlu/4GoDuMGQZ2jnp8MYHNJMSZ
         jigNAn23W8K36Iyrf7gCFG91dKrKptbeE905Ea+tabuvsSS2M1fL/wIj1SuWe1gU3B
         /Sg5/cv+hHmUMBHwoqs6EhFPweIHYRVRvI9Uc/8hgrsouigfD7zy20FaWhtFAY7R0d
         D49ykgWMI7RCGj1NcPaVQvFMG8jIC4Wp4cpBUUMqwt8/al2XVx7dcZmqgbkcrSQ7Lt
         1JizA3YcpBddw==
Date:   Wed, 16 Jun 2021 17:11:07 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     guaneryu@gmail.com,
        Allison Henderson <allison.henderson@oracle.com>,
        Chandan Babu R <chandanrlinux@gmail.com>,
        linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me,
        amir73il@gmail.com
Subject: Re: [PATCH 13/13] misc: update documentation to reflect
 auto-generated group files
Message-ID: <20210617001107.GJ158209@locust>
References: <162370433910.3800603.9623820748404628250.stgit@locust>
 <162370441083.3800603.11964136184573090396.stgit@locust>
 <YMpmdsFuRqwBfatu@sol.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YMpmdsFuRqwBfatu@sol.localdomain>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jun 16, 2021 at 02:00:38PM -0700, Eric Biggers wrote:
> On Mon, Jun 14, 2021 at 02:00:10PM -0700, Darrick J. Wong wrote:
> > +     6. Test group membership: Each test can be associated with any number
> > +	of groups for convenient selection of subsets of tests.  Test names
> > +	can be any sequence of non-whitespace characters.
> 
> I think this should be "Test group names", not "Test names"?

Or "group names".  Will change.

--D

> 
> - Eric

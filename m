Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95E59C48BE5
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Jun 2021 00:06:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 67E26613B9
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Jun 2021 00:06:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234827AbhFQAIi (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 16 Jun 2021 20:08:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:56136 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230481AbhFQAIi (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 16 Jun 2021 20:08:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 36EE461351;
        Thu, 17 Jun 2021 00:06:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623888391;
        bh=h4eYAyCs6Wocwd9pcOzR8bDdeMjK44jaEV2t/lBoxwA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=dNWSe858C8VpsYcH4qMKpJ/aA0RJWX2GwYmiknxuqjIABEfPd0RHIqnNUhqE41j2r
         XExlrf8DJu57Dp4Tq+NWueEBDGitMK8Xorvg4nhE46XxegAtXvAqRsBlBx9bshd5mF
         3Qv5+R5QOUdLp2rrAyPhEMvMkxAcuchqSfJaWm9oMnjEtZIrGNXfTDyzysv0idcrMM
         y49WSajM2h6OQgmB2vmBPgc4or5NeSI0kwBCjayxtD4FgR6Z4d2yEQZs4Oxfe10Tju
         HJb0Rb0VR7AGGldWrRRDKLkmFovKIGFGpQBztPodJhMUjvSL2MlVFtk/7Ka1IyKBCJ
         OQq+aS56eSpGw==
Date:   Wed, 16 Jun 2021 17:06:30 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     guaneryu@gmail.com, Chandan Babu R <chandanrlinux@gmail.com>,
        Allison Henderson <allison.henderson@oracle.com>,
        linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me,
        amir73il@gmail.com, ebiggers@kernel.org
Subject: Re: [PATCH 06/13] fstests: clean up open-coded golden output
Message-ID: <20210617000630.GH158209@locust>
References: <162370433910.3800603.9623820748404628250.stgit@locust>
 <162370437228.3800603.4686985475787987320.stgit@locust>
 <YMmQBb2twYKhZZpm@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YMmQBb2twYKhZZpm@infradead.org>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jun 16, 2021 at 06:45:41AM +0100, Christoph Hellwig wrote:
> On Mon, Jun 14, 2021 at 01:59:32PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Fix the handful of tests that open-coded 'QA output created by XXX'.
> > 
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>
> > Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
> 
> Shouldn't this go before the mass conversion?

Yeah, I suppose it should to avoid breaking bisects.

--D

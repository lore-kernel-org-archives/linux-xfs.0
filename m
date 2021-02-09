Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02D46C433E6
	for <linux-xfs@archiver.kernel.org>; Tue,  9 Feb 2021 16:49:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A931964E9D
	for <linux-xfs@archiver.kernel.org>; Tue,  9 Feb 2021 16:49:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233109AbhBIQtk (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 9 Feb 2021 11:49:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:46708 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233201AbhBIQrx (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 9 Feb 2021 11:47:53 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BFB3864DDF;
        Tue,  9 Feb 2021 16:47:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612889232;
        bh=n/RKj5veL71RYXb3Nd//bvlSYle78EHXRHc6z9/NsuA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=UJIvc9HoyhKfWuw560bQwIesULlAlvZKc+XNOFmgngFGwIvu3A5klzhg4hF11d1tx
         cut2wniAbzlpZ2WMpaZxrngzwhb9OjeZbaa7J9318uBGMZWJOI0zvLskQRgbz+tdQ3
         ZnUp/m5YndsEXyCo4RmhtRBG7Yw1DxVCPv2NrwoqVPQwMCt4Oc2qb4KFLj/AVzSi0E
         LXAVX/h+zxv+YnoJ8polW6AU2SrZyaa3Piv1K0b5qRB7RYBdgNkyV412kMZ+lDpimU
         lAJGvIFdGRfonLKowu/5622vnoFo1tqfTLL6jqoZJF65TlREXhIBqXQU1lpHSUQRwy
         el/wkKQZEMnDQ==
Date:   Tue, 9 Feb 2021 08:47:13 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org,
        bfoster@redhat.com
Subject: Re: [PATCH 08/10] xfs_repair: allow setting the needsrepair flag
Message-ID: <20210209164713.GE7190@magnolia>
References: <161284380403.3057868.11153586180065627226.stgit@magnolia>
 <161284384955.3057868.8076509276356847362.stgit@magnolia>
 <20210209091534.GH1718132@infradead.org>
 <f52ff4e2-16c3-89dd-30aa-a29f56cd29d1@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f52ff4e2-16c3-89dd-30aa-a29f56cd29d1@sandeen.net>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Feb 09, 2021 at 08:41:34AM -0600, Eric Sandeen wrote:
> 
> 
> On 2/9/21 3:15 AM, Christoph Hellwig wrote:
> > On Mon, Feb 08, 2021 at 08:10:49PM -0800, Darrick J. Wong wrote:
> >> From: Darrick J. Wong <djwong@kernel.org>
> >>
> >> Quietly set up the ability to tell xfs_repair to set NEEDSREPAIR at
> >> program start and (presumably) clear it by the end of the run.  This
> >> code isn't terribly useful to users; it's mainly here so that fstests
> >> can exercise the functionality.
> > 
> > What does the quietly above mean?
> 
> I think it means "don't document it in the man page, this is a secret
> for XFS developers and testers"

Yep.  I'll add the following to the commit message:

"We don't document this flag in the manual pages at all because repair
clears needsrepair at exit, which means the knobs only exist for fstests
to exercise the functionality."

--D

> 
> > Otherwise this looks good:
> > 
> > Reviewed-by: Christoph Hellwig <hch@lst.de>
> > 

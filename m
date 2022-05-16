Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA4B4C433F5
	for <linux-xfs@archiver.kernel.org>; Mon, 16 May 2022 16:22:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240443AbiEPQWH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 16 May 2022 12:22:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238917AbiEPQWG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 16 May 2022 12:22:06 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 261AF39168
        for <linux-xfs@vger.kernel.org>; Mon, 16 May 2022 09:22:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D3D9AB81255
        for <linux-xfs@vger.kernel.org>; Mon, 16 May 2022 16:22:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88782C385AA;
        Mon, 16 May 2022 16:22:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652718122;
        bh=HHbNSSRPkgAMZyy+KsGOGRjsME8YENsPof3YkqdtSec=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ieKrrO5IJQGP/GlKXZFwAy0PCu7YYp9PfUmOMSHm61SvQX4DeBomAeWzz2kSHYvIB
         wBr58g92Yh6Ebv/WB9doV/w3kD2iid/BMlxj7IIeFTuX8+Xs2X1ejplBB1EkAx6/Nz
         1XiNB26muXsMJpwc0HWbXBbVlWTrd9nUnntLNVvkZuUFQDp8y0+URJmmMVpb4VVNAm
         ohVD4C+u/K7KwfrIDwyeiHcaFf1yG01AfTK1ypxbTj2SR5Rdm/3gnmnel5WzwyUBCJ
         TCvCaaJlx97lQ+kmJQixRb69IqQ/cxCXOPVU0q/tfi4ERtHHncSUuuDiXvxvl9vrzb
         yHUW4stJuNxzg==
Date:   Mon, 16 May 2022 09:22:02 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Raghav Sharma <raghavself28@gmail.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [QUESTION] xfs version 5 new features
Message-ID: <YoJ6Ko+m7Jx1Cxdg@magnolia>
References: <CAGthhtKXimFugYicqrDEc_bjzPh8n=Ue96YO9VRJOQoD4A_ycA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGthhtKXimFugYicqrDEc_bjzPh8n=Ue96YO9VRJOQoD4A_ycA@mail.gmail.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, May 16, 2022 at 05:04:57PM +0530, Raghav Sharma wrote:
> Hello!
> 
> I am working with the Haiku organization for adding xfs support for HaikuOS.
> We currently have xfs version 4 read support, I want to extend it to
> xfs version 5.
> 
> What are new features introduced in xfs V5?
> 
> Does "xfs_filesystem_structure" pdf documentation contain all
> necessary fields for V5?

That depends on where you're getting the pdf from.  There are many
copies floating around on the internet.

--D

> I don't know if this mailing list is the right place to ask for help
> on this topic, so do let me know about it.
> 
> Thanks
> Raghav

Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 132D9C7EE25
	for <linux-xfs@archiver.kernel.org>; Wed,  7 Jun 2023 18:34:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232036AbjFGSe2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 7 Jun 2023 14:34:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231585AbjFGSe2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 7 Jun 2023 14:34:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 116141FDD;
        Wed,  7 Jun 2023 11:34:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5877763BEF;
        Wed,  7 Jun 2023 18:34:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41A4AC433D2;
        Wed,  7 Jun 2023 18:34:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1686162862;
        bh=wibCSTFfuKeaqu/7sRGcwdBPEappPNaGpZmYNgTkiro=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=GcYp5XUmiu8Z8mhdUDbNKSfU+mQqP1idZ+QSmihrpYPhbHhyNnxr7Ne3A6VPhR0qD
         fP5wDAWhvv+g7BSOysIPVImbhEtThW3QymXJOZFqgGmP61R91g07p7/VDn9ozrnUA8
         7fZKCRwWGpdKxeYAF1glGMXJnRG3L44vlGqhHrEU=
Date:   Wed, 7 Jun 2023 20:34:20 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Sasha Levin <sashal@kernel.org>,
        Leah Rumancik <leah.rumancik@gmail.com>,
        Chandan Babu R <chandan.babu@oracle.com>,
        "Darrick J . Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org,
        stable@vger.kernel.org, Dave Chinner <dchinner@redhat.com>,
        Dave Chinner <david@fromorbit.com>,
        Danila Chernetsov <listdansp@mail.ru>
Subject: Re: [PATCH 6.1] xfs: verify buffer contents when we skip log replay
Message-ID: <2023060708-paver-foe-ed80@gregkh>
References: <20230605075258.308475-1-amir73il@gmail.com>
 <2023060730-ultimate-triceps-7bea@gregkh>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2023060730-ultimate-triceps-7bea@gregkh>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jun 07, 2023 at 07:53:54PM +0200, Greg Kroah-Hartman wrote:
> On Mon, Jun 05, 2023 at 10:52:58AM +0300, Amir Goldstein wrote:
> > From: "Darrick J. Wong" <djwong@kernel.org>
> > 
> > commit 22ed903eee23a5b174e240f1cdfa9acf393a5210 upstream.
> 
> What about 6.3.y?  I can't take a patch for 6.1.y only without it being
> in a newer kernel at the same time, right?

Ah, it's simple enough, I added it to 6.3.y for now as well, thanks.

greg k-h

Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE129C77B7A
	for <linux-xfs@archiver.kernel.org>; Wed,  7 Jun 2023 17:54:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231420AbjFGRyK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 7 Jun 2023 13:54:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231839AbjFGRyE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 7 Jun 2023 13:54:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3A0A1FC2;
        Wed,  7 Jun 2023 10:54:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 52FBD63F95;
        Wed,  7 Jun 2023 17:54:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AF99C433D2;
        Wed,  7 Jun 2023 17:54:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1686160442;
        bh=YFGlyfWVwMOZcZEByUpLtH5BeR+scGjqb1eZaoyANJ8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=hPM8yKhC1BJa4MZOUmsI7z3wySyuvOv0kMtECUL0zRempqpb39r+Cwm6BKov6il6H
         sj9Ym6vF3wd7LI4zlomYn6ant2pkDRA3o+dGti6dXwHR7luGVrhjxllqxKmAzJNe47
         WmJ8qqTimOzA+J/16CF6rDqKSQ7bXGUKUym0zTo8=
Date:   Wed, 7 Jun 2023 19:53:54 +0200
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
Message-ID: <2023060730-ultimate-triceps-7bea@gregkh>
References: <20230605075258.308475-1-amir73il@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230605075258.308475-1-amir73il@gmail.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jun 05, 2023 at 10:52:58AM +0300, Amir Goldstein wrote:
> From: "Darrick J. Wong" <djwong@kernel.org>
> 
> commit 22ed903eee23a5b174e240f1cdfa9acf393a5210 upstream.

What about 6.3.y?  I can't take a patch for 6.1.y only without it being
in a newer kernel at the same time, right?

thanks,

greg k-h

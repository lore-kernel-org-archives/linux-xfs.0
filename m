Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D17C7C83005
	for <linux-xfs@archiver.kernel.org>; Wed,  7 Jun 2023 09:11:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239871AbjFGJLi (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 7 Jun 2023 05:11:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239859AbjFGJLD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 7 Jun 2023 05:11:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18949211B
        for <linux-xfs@vger.kernel.org>; Wed,  7 Jun 2023 02:10:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A1AFA63CC2
        for <linux-xfs@vger.kernel.org>; Wed,  7 Jun 2023 09:10:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8916C433EF;
        Wed,  7 Jun 2023 09:10:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1686129003;
        bh=/iTecrZoV/sy7TW9+QMtRsOdJ8GqtHregRPLzIz4jos=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=kTkxPBJLJ4mrdDxSwB/7z7FVhNlXvCw1WGpkVT9Ak9Axi6SYAVs5ixvZO+/obhaaj
         g2jMUrpv8A8HHxROT145VUO2UPANeQlWSioYwY2LR5URvFKkotkWDQKgLta9lryGvD
         SbDKgCHN622qi4Q5pr9JFoSZok153BmrZO9Gm1PqM/pvuxMJXjXVFFvGidcUuMiwT5
         lVQ1U0SQP8VEtzk6bN62RyxYO1XlXq6KpnJSj3uU6lmkkS/jE4GZMOJpPzai2sxlA6
         SVjWq74uuLWID+OhT/2NzsoollIVWzKJ3n6uIuJHVAyRNFhS5ncHFQJONzcLKXVTQF
         i6SjUZvG1/vUw==
Date:   Wed, 7 Jun 2023 10:09:58 +0100
From:   Lee Jones <lee@kernel.org>
To:     Leah Rumancik <lrumancik@google.com>
Cc:     Amir Goldstein <amir73il@gmail.com>,
        "Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org,
        Dave Chinner <david@fromorbit.com>, chandan.babu@oracle.com
Subject: Re: [PATCH] xfs: verify buffer contents when we skip log replay
Message-ID: <20230607090958.GC1930705@google.com>
References: <20230411233159.GH360895@frogsfrogsfrogs>
 <20230601130351.GA1787684@google.com>
 <20230601151146.GH16865@frogsfrogsfrogs>
 <CAOQ4uxh5m9VHnq0JG9BeAjAXyRdYy0fi9NwJVgWvH2tD7f9mLA@mail.gmail.com>
 <CAMxqPXVrsy0MMzt0e6cKZmBmLox3xJcjXu8yd-THzEUdDD=HGw@mail.gmail.com>
 <20230606165651.GB1930705@google.com>
 <CAMxqPXWLnJvJXRV5_dAq6huWdFdvLCw9qJs8ZHeb8mdL1WLCTA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAMxqPXWLnJvJXRV5_dAq6huWdFdvLCw9qJs8ZHeb8mdL1WLCTA@mail.gmail.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, 06 Jun 2023, Leah Rumancik wrote:

> Hi Lee,
> 
> I've started testing on this patch, hoping to have it out in a few
> days. Currently, we try to get things into 5.10 (Amir) and 5.4
> (Chandan) as well.

Super, thank you Leah.

-- 
Lee Jones [李琼斯]

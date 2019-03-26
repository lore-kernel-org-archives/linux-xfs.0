Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-ed1-f68.google.com ([209.85.208.68]:39251 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730625AbfCZJd2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 26 Mar 2019 05:33:28 -0400
Received: by mail-ed1-f68.google.com with SMTP id p20so9634332eds.6
        for <linux-xfs@vger.kernel.org>; Tue, 26 Mar 2019 02:33:26 -0700 (PDT)
MIME-Version: 1.0
From: Gavin Will <gavin.will@epicgames.com>
Date: Tue, 26 Mar 2019 09:33:15 +0000
Message-ID: <CAHgt1ikzuxR3yVU_gpAvO44fR=04AaNn3h4FGeLA+Hin9OnZRA@mail.gmail.com>
Subject: Re: [PATCH] writeback: fix range_cyclic writeback vs writepages deadlock
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: david@fromorbit.com
Cc: akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org

Hi

We believe we have seen this deadlock issue on our XFS system and
currently are trying the patch (aware of the disclaimer that it may
not be production ready). However trying to repo this issue is very
hard. I was interested in Dave Chinner saying that he had seen a
repeatable deadlock and hoped that meant that there was either a
process or method that could provoke this situation from happening.
Currently we see this deadlock happen about once every 1-2 months and
hence trying to speed the iteration up.

Regards
Gavin Will

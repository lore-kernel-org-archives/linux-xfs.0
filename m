Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-io0-f177.google.com ([209.85.223.177]:41223 "EHLO
        mail-io0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756299AbeDXH0W (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 24 Apr 2018 03:26:22 -0400
Received: by mail-io0-f177.google.com with SMTP id o7-v6so19694491iob.8
        for <linux-xfs@vger.kernel.org>; Tue, 24 Apr 2018 00:26:22 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20180423153447.GI43600@bfoster.bfoster>
References: <CA+1g8semVirCEfbQRNt8h-Cj7NV7p1FYP76XLjH4vVMVU7F=aw@mail.gmail.com>
 <20180423143605.GH43600@bfoster.bfoster> <CA+1g8seTYOgERkM=dnDZFDX3QZQ1w6pMGOw1HVC-tdQxVON=vA@mail.gmail.com>
 <20180423153447.GI43600@bfoster.bfoster>
From: Andrea del Monaco <andrea.delmonaco@clustervision.com>
Date: Tue, 24 Apr 2018 09:25:41 +0200
Message-ID: <CA+1g8segDPZo821caCX73ARLa3Ly9_u6O9iseqoE3b+LntqSLw@mail.gmail.com>
Subject: Re: XFS and Memory allocation
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Hi Brian,

I've been tunining some kernel parameters here and there. Seems that the
reclaim_zone set to 1 has had a positive impact - or at least, the
number of errors reduced drastically.

Do you now if and when will it be available?
I am very tempted to get the packages from Fedora repos (Which seems
to be available there), but you know, it might get messy.

I guess that in order to reduce the extent counts of the files, would
mean re-create the FS. Wouldn't it?

Regards,

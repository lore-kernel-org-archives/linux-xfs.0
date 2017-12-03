Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34584 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752438AbdLCXHF (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sun, 3 Dec 2017 18:07:05 -0500
Date: Mon, 4 Dec 2017 00:07:02 +0100
From: "Luis R. Rodriguez" <mcgrof@kernel.org>
Subject: Re: [PATCH] treewide: remove duplicate includes
Message-ID: <20171203230702.GT729@wotan.suse.de>
References: <1512337779-16842-1-git-send-email-pravin.shedge4linux@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1512337779-16842-1-git-send-email-pravin.shedge4linux@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Pravin Shedge <pravin.shedge4linux@gmail.com>
Cc: gregkh@linuxfoundation.org, davem@davemloft.net, sstabellini@kernel.org, x86@kernel.org, mchehab@kernel.org, linux-xfs@vger.kernel.org, mcgrof@kernel.org, ast@kernel.org, shuah@kernel.org, namhyung@kernel.org, mhiramat@kernel.org, linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, devel@driverdev.osuosl.org, linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org

On Mon, Dec 04, 2017 at 03:19:39AM +0530, Pravin Shedge wrote:
> These duplicate includes have been found with scripts/checkincludes.pl but
> they have been removed manually to avoid removing false positives.
> 
> Unit Testing:
> 
> - build successful
> - LTP testsuite passes.
> - checkpatch.pl passes

Can you get 0day to test it?

  Luis

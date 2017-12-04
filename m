Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57536 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750812AbdLDHh4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 4 Dec 2017 02:37:56 -0500
Date: Mon, 4 Dec 2017 08:38:02 +0100
From: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] treewide: remove duplicate includes
Message-ID: <20171204073802.GD19596@kroah.com>
References: <1512337779-16842-1-git-send-email-pravin.shedge4linux@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1512337779-16842-1-git-send-email-pravin.shedge4linux@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Pravin Shedge <pravin.shedge4linux@gmail.com>
Cc: davem@davemloft.net, sstabellini@kernel.org, x86@kernel.org, mchehab@kernel.org, linux-xfs@vger.kernel.org, mcgrof@kernel.org, ast@kernel.org, shuah@kernel.org, namhyung@kernel.org, mhiramat@kernel.org, linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, devel@driverdev.osuosl.org, linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org

On Mon, Dec 04, 2017 at 03:19:39AM +0530, Pravin Shedge wrote:
> These duplicate includes have been found with scripts/checkincludes.pl but
> they have been removed manually to avoid removing false positives.
> 
> Unit Testing:
> 
> - build successful
> - LTP testsuite passes.
> - checkpatch.pl passes
> 
> Signed-off-by: Pravin Shedge <pravin.shedge4linux@gmail.com>

Please break this up per-subsystem, like any other cleanup patch, and
send it out that way.  As it is, no one can take such a patch.

thanks,

greg k-h

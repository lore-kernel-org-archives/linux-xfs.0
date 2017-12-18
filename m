Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.free-electrons.com ([62.4.15.54]:37135 "EHLO
        mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933147AbdLRWPX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 18 Dec 2017 17:15:23 -0500
Date: Mon, 18 Dec 2017 23:15:11 +0100
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Subject: Re: [trivial PATCH] treewide: Align function definition open/close
 braces
Message-ID: <20171218221511.GH15162@piout.net>
References: <1513556924.31581.51.camel@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1513556924.31581.51.camel@perches.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Joe Perches <joe@perches.com>
Cc: Jiri Kosina <trivial@kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>, linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org, amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org, MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org, netdev@vger.kernel.org, linux-wireless@vger.kernel.org, acpi4asus-user@lists.sourceforge.net, platform-driver-x86@vger.kernel.org, linux-rtc@vger.kernel.org, linux-fsdevel@vger.kernel.org, ocfs2-devel@oss.oracle.com, linux-xfs@vger.kernel.org, linux-audit@redhat.com, alsa-devel@alsa-project.org, linuxppc-dev <linuxppc-dev@lists.ozlabs.org>

On 17/12/2017 at 16:28:44 -0800, Joe Perches wrote:
> Some functions definitions have either the initial open brace and/or
> the closing brace outside of column 1.
> 
> Move those braces to column 1.
> 
> This allows various function analyzers like gnu complexity to work
> properly for these modified functions.
> 
> Miscellanea:
> 
> o Remove extra trailing ; and blank line from xfs_agf_verify
> 
> Signed-off-by: Joe Perches <joe@perches.com>

For RTC:

Acked-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>


-- 
Alexandre Belloni, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com

Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from lb1-smtp-cloud9.xs4all.net ([194.109.24.22]:40921 "EHLO
        lb1-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752450AbeAXIpc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 24 Jan 2018 03:45:32 -0500
Message-ID: <1516783522.2230.6.camel@tiscali.nl>
Subject: Re: [PATCH v6 05/99] xarray: Add definition of struct xarray
From: Paul Bolle <pebolle@tiscali.nl>
Date: Wed, 24 Jan 2018 09:45:22 +0100
In-Reply-To: <20180117202203.19756-6-willy@infradead.org>
References: <20180117202203.19756-1-willy@infradead.org>
         <20180117202203.19756-6-willy@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Matthew Wilcox <willy@infradead.org>
Cc: Matthew Wilcox <mawilcox@microsoft.com>, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, linux-nilfs@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-xfs@vger.kernel.org, linux-usb@vger.kernel.org, Bjorn Andersson <bjorn.andersson@linaro.org>, Stefano Stabellini <sstabellini@kernel.org>, iommu@lists.linux-foundation.org, linux-remoteproc@vger.kernel.org, linux-s390@vger.kernel.org, intel-gfx@lists.freedesktop.org, cgroups@vger.kernel.org, linux-sh@vger.kernel.org, David Howells <dhowells@redhat.com>, linux-kernel@vger.kernel.org

Mathhew,

Just a minor question.

On Wed, 2018-01-17 at 12:20 -0800, Matthew Wilcox wrote:
> This is a direct replacement for struct radix_tree_root.  Some of the
> struct members have changed name; convert those, and use a #define so
> that radix_tree users continue to work without change.
> 
> Signed-off-by: Matthew Wilcox <mawilcox@microsoft.com>

> --- a/include/linux/xarray.h
> +++ b/include/linux/xarray.h
> @@ -10,6 +10,8 @@
>   */
>  
>  #include <linux/bug.h>
> +#include <linux/compiler.h>
> +#include <linux/kconfig.h>

The top Makefile includes linux/kconfig.h globally. (See the odd USERINCLUDE
variable, which is actually part of the LINUXINCLUDE variable, but split off
to make things confusing.)

Why do you need to include linux/kconfig.h here?

>  #include <linux/spinlock.h>
>  #include <linux/types.h>

Thanks,


Paul Bolle

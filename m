Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mga07.intel.com ([134.134.136.100]:43206 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752226AbdECJNt (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 3 May 2017 05:13:49 -0400
Message-ID: <1493802823.4154.3.camel@linux.intel.com>
Subject: Re: [RFC][PATCH] linux/uuid.h: hoist uuid_is_null() helper from
 libnvdimm
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Date: Wed, 03 May 2017 12:13:43 +0300
In-Reply-To: <1493756363-5113-1-git-send-email-amir73il@gmail.com>
References: <1493756363-5113-1-git-send-email-amir73il@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Amir Goldstein <amir73il@gmail.com>, Christoph Hellwig <hch@lst.de>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Mimi Zohar <zohar@linux.vnet.ibm.com>, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, Richard Weinberger <richard@nod.at>, "Darrick J . Wong" <darrick.wong@oracle.com>, Mark Fasheh <mfasheh@versity.com>, Al Viro <viro@zeniv.linux.org.uk>, linux-xfs@vger.kernel.org, linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>, David Howells <dhowells@redhat.com>

On Tue, 2017-05-02 at 23:19 +0300, Amir Goldstein wrote:
> We need a helper for VFS to check if struct super_block field s_uuid
> was filled by the filesystem, before consumers can use it.
> 
> The libnvdimm code already has a private helper to check if uuid is
> null
> and the helper name is not using a private namespace prefix, which
> prevents us from using the same helper name as a common function.
> 

Hmm...
Have you checked my branch here:
https://bitbucket.org/andy-shev/linux/branch/topic%2Fuuid
?

Probably not.
I have number of patches to make UUID API used kernel wide.

...including helpers for null UUID check:
https://bitbucket.org/andy-shev/linux/commits/79029ebe2c32830f82effc0f0b
62cce2b6eb7fdb?at=topic/uuid

> Hoist the libnvdimm helper as an inline helper to linux/uuid.h.
> 
> Suggested-by: Christoph Hellwig <hch@lst.de>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> Cc: David Howells <dhowells@redhat.com>
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> ---
>  drivers/nvdimm/btt_devs.c | 8 +-------
>  include/linux/uuid.h      | 7 +++++++
>  2 files changed, 8 insertions(+), 7 deletions(-)
> 
> Christoph,
> 
> Following your suggestion to provide a helper for checking if
> filesystem
> had filled sb->s_uuid, here is a patch to add that helper.
> 
> I considered hoisting xfs's uuid_is_nil() helper and uuid_t to uuid.h,
> but
> that would have been more painful, so just moved this simple helper
> instead.
> We can continue debating which implementation is better, but that
> would be
> futile...
> 
> If in the future xfs uuid table code is going to be moved to VFS, we
> should
> probably move variants of the xfs/uuid.c functions to lib/uuid.c if
> those
> variants don't already exist.
> 
> CC'ing the maintainers of clearcache and EVM/IMA to see if this helper
> should be added (as sanity?) to their code before accessing sb-
> >s_uuid.
> 
> I truely hope that EVM/IMA signatures do not expect xfs/ubifs to keep
> exporting null s_uuid, because if they do, then starting to export
> s_uuid
> for xfs/ubifs may require a new config/mkfs/mount option and that
> would
> be a shame.
> 
> Cheers,
> Amir.
> 
> diff --git a/drivers/nvdimm/btt_devs.c b/drivers/nvdimm/btt_devs.c
> index 97dd292..d0fcda2 100644
> --- a/drivers/nvdimm/btt_devs.c
> +++ b/drivers/nvdimm/btt_devs.c
> @@ -17,6 +17,7 @@
>  #include <linux/slab.h>
>  #include <linux/fs.h>
>  #include <linux/mm.h>
> +#include <linux/uuid.h>
>  #include "nd-core.h"
>  #include "btt.h"
>  #include "nd.h"
> @@ -222,13 +223,6 @@ struct device *nd_btt_create(struct nd_region
> *nd_region)
>  	return dev;
>  }
>  
> -static bool uuid_is_null(u8 *uuid)
> -{
> -	static const u8 null_uuid[16];
> -
> -	return (memcmp(uuid, null_uuid, 16) == 0);
> -}
> -
>  /**
>   * nd_btt_arena_is_valid - check if the metadata layout is valid
>   * @nd_btt:	device with BTT geometry and backing device info
> diff --git a/include/linux/uuid.h b/include/linux/uuid.h
> index 4dff73a..d3f8656 100644
> --- a/include/linux/uuid.h
> +++ b/include/linux/uuid.h
> @@ -58,6 +58,13 @@ static inline int uuid_be_cmp(const uuid_be u1,
> const uuid_be u2)
>  	return memcmp(&u1, &u2, sizeof(uuid_be));
>  }
>  
> +static inline bool uuid_is_null(u8 *uuid)
> +{
> +	static const u8 null_uuid[16];
> +
> +	return (memcmp(uuid, null_uuid, 16) == 0);
> +}
> +
>  void generate_random_uuid(unsigned char uuid[16]);
>  
>  extern void uuid_le_gen(uuid_le *u);

-- 
Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Intel Finland Oy

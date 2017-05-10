Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-oi0-f43.google.com ([209.85.218.43]:34532 "EHLO
        mail-oi0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751985AbdEJTPw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 10 May 2017 15:15:52 -0400
MIME-Version: 1.0
In-Reply-To: <20170510180214.16852-4-hch@lst.de>
References: <20170510180214.16852-1-hch@lst.de> <20170510180214.16852-4-hch@lst.de>
From: Amir Goldstein <amir73il@gmail.com>
Date: Wed, 10 May 2017 22:15:51 +0300
Message-ID: <CAOQ4uxjSpCgM=RK5jXkuY5HmseQT2EKh_huntvK2ADKBuNqi4A@mail.gmail.com>
Subject: Re: [PATCH 03/16] uuid: rename uuid types
Content-Type: text/plain; charset=UTF-8
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Shaohua Li <shli@kernel.org>, Dan Williams <dan.j.williams@intel.com>, David Howells <dhowells@redhat.com>, Steven Whitehouse <swhiteho@redhat.com>, Mimi Zohar <zohar@linux.vnet.ibm.com>, linux-xfs <linux-xfs@vger.kernel.org>, linux-raid@vger.kernel.org, linux-nvdimm@lists.01.org, linux-kernel <linux-kernel@vger.kernel.org>

On Wed, May 10, 2017 at 9:02 PM, Christoph Hellwig <hch@lst.de> wrote:
> Our "little endian" UUID really is a Wintel GUID, so rename it and its
> helpers such (guid_t).  The big endian UUID is the only true one, so
> give it the name uuid_t.  The uuid_le and uuid_be names are retained for,
> but will hopefully go away soon.
>
> Also remove the existing typedef in XFS that's now been superceeded by
> the generic type name.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> [andy: also updated the UUID_LE/UUID_BE macros including fallout]
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> ---
[...]

>
> -static inline int uuid_le_cmp(const uuid_le u1, const uuid_le u2)
> +static inline int guid_cmp(const guid_t u1, const guid_t u2)
>  {
> -       return memcmp(&u1, &u2, sizeof(uuid_le));
> +       return memcmp(&u1, &u2, sizeof(guid_t));
>  }
>
> -static inline int uuid_be_cmp(const uuid_be u1, const uuid_be u2)
> +static inline int uuid_cmp(const uuid_t u1, const uuid_t u2)
>  {
> -       return memcmp(&u1, &u2, sizeof(uuid_be));
> +       return memcmp(&u1, &u2, sizeof(uuid_t));
>  }
>


I think we should use this opportunity to change these to (uuid_t *, uuid_t *)
which is more in line with the rest of the helpers including the new helpers
hoisted from xfs.

[...]

> +/* backwards compatibility, don't use in new code */
> +#define uuid_le_cmp(u1, u2)    guid_cmp(u1, u2)
> +#define uuid_be_cmp(u1, u2)    uuid_cmp(u1, u2)

Therefore:
#define uuid_le_cmp(u1, u2)    guid_cmp(&(u1), &(u2))
#define uuid_be_cmp(u1, u2)    uuid_cmp(&(u1), &(u2))

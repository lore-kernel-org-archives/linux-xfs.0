Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from smtprelay0053.hostedemail.com ([216.40.44.53]:49077 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1753495AbdERHNA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 18 May 2017 03:13:00 -0400
Message-ID: <1495091565.31562.28.camel@perches.com>
Subject: Re: [PATCH 03/23] uuid: remove uuid_be defintions from the uapi
 header
From: Joe Perches <joe@perches.com>
Date: Thu, 18 May 2017 00:12:45 -0700
In-Reply-To: <20170518062705.25902-4-hch@lst.de>
References: <20170518062705.25902-1-hch@lst.de>
         <20170518062705.25902-4-hch@lst.de>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>, Andy Shevchenko <andriy.shevchenko@linux.intel.com>, Amir Goldstein <amir73il@gmail.com>, linux-fsdevel@vger.kernel.org
Cc: Shaohua Li <shli@kernel.org>, Dan Williams <dan.j.williams@intel.com>, David Howells <dhowells@redhat.com>, Steven Whitehouse <swhiteho@redhat.com>, Mimi Zohar <zohar@linux.vnet.ibm.com>, linux-xfs@vger.kernel.org, linux-raid@vger.kernel.org, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org

On Thu, 2017-05-18 at 08:26 +0200, Christoph Hellwig wrote:
> We don't use uuid_be and the UUID_BE constants in any uapi headers, so make
> them private to the kernel.

On the assumption that no user program uses them?
Is that a safe assumption?

> diff --git a/include/uapi/linux/uuid.h b/include/uapi/linux/uuid.h
> index 3738e5fb6a4d..0099756c4bac 100644
> --- a/include/uapi/linux/uuid.h
> +++ b/include/uapi/linux/uuid.h
> @@ -24,10 +24,6 @@ typedef struct {
>  	__u8 b[16];
>  } uuid_le;
>  
> -typedef struct {
> -	__u8 b[16];
> -} uuid_be;
> -
>  #define UUID_LE(a, b, c, d0, d1, d2, d3, d4, d5, d6, d7)		\
>  ((uuid_le)								\
>  {{ (a) & 0xff, ((a) >> 8) & 0xff, ((a) >> 16) & 0xff, ((a) >> 24) & 0xff, \
> @@ -35,20 +31,8 @@ typedef struct {
>     (c) & 0xff, ((c) >> 8) & 0xff,					\
>     (d0), (d1), (d2), (d3), (d4), (d5), (d6), (d7) }})
>  
> -#define UUID_BE(a, b, c, d0, d1, d2, d3, d4, d5, d6, d7)		\
> -((uuid_be)								\
> -{{ ((a) >> 24) & 0xff, ((a) >> 16) & 0xff, ((a) >> 8) & 0xff, (a) & 0xff, \
> -   ((b) >> 8) & 0xff, (b) & 0xff,					\
> -   ((c) >> 8) & 0xff, (c) & 0xff,					\
> -   (d0), (d1), (d2), (d3), (d4), (d5), (d6), (d7) }})
> -
>  #define NULL_UUID_LE							\
>  	UUID_LE(0x00000000, 0x0000, 0x0000, 0x00, 0x00, 0x00, 0x00,	\
>  		0x00, 0x00, 0x00, 0x00)
>  
> -#define NULL_UUID_BE							\
> -	UUID_BE(0x00000000, 0x0000, 0x0000, 0x00, 0x00, 0x00, 0x00,	\
> -		0x00, 0x00, 0x00, 0x00)
> -
> -
>  #endif /* _UAPI_LINUX_UUID_H_ */

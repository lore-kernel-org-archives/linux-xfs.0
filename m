Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:52370 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751736AbcLLNtT (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 12 Dec 2016 08:49:19 -0500
Subject: Re: [PATCH 1/1] Fixed to codestyle
References: <987271481540010@web27o.yandex.ru>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <66c68b88-e338-1d9a-b9dd-b8d858ebf349@sandeen.net>
Date: Mon, 12 Dec 2016 07:49:18 -0600
MIME-Version: 1.0
In-Reply-To: <987271481540010@web27o.yandex.ru>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Ozgur Karatas <okaratas@member.fsf.org>, david@fromorbit.com
Cc: linux-xfs@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>

On 12/12/16 4:53 AM, Ozgur Karatas wrote:
> 
> Hello,
> 
> I have error to use uuid and I think the functions should be used when -i'm eye-catching- "(* uuid)".
> I tested it.
> 
> Regards,
> 
> Signed-off-by: Ozgur Karatas <okaratas@member.fsf.org>

NAK

This doesn't fix code style at all; there is no need and no
precedence for i.e. (*uuid) in function arguments in the xfs code,
and you have broken indentation in the loop within the function.

Thanks,
-Eric

> ---
> diff --git a/fs/xfs/uuid.c b/fs/xfs/uuid.c
> index b83f76b..cd8bc8e 100644
> --- a/fs/xfs/uuid.c
> +++ b/fs/xfs/uuid.c
> @@ -33,7 +33,7 @@ typedef struct {
>   * it just something that's needed for user-level file handles.
>   */
>  void
> -uuid_getnodeuniq(uuid_t *uuid, int fsid [2])
> +uuid_getnodeuniq(uuid_t (*uuid), int fsid [2])
>  {
>  	xfs_uu_t *uup = (xfs_uu_t *)uuid;
>  
> @@ -51,8 +51,8 @@ uuid_is_nil(uuid_t *uuid)
>  	if (uuid == NULL)
>  		return 0;
>  	/* implied check of version number here... */
> -	for (i = 0; i < sizeof *uuid; i++)
> -		if (*cp++) return 0;	/* not nil */
> +	for (i = 0; i < sizeof (*uuid); i++) 
> +	if (*cp++) return 0;	/* not nil */
>  	return 1;	/* is nil */
>  }
> 

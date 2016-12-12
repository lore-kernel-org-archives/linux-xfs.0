Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from forward4h.cmail.yandex.net ([87.250.230.101]:49584 "EHLO
        forward4h.cmail.yandex.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752306AbcLLUbP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 12 Dec 2016 15:31:15 -0500
From: Ozgur Karatas <okaratas@member.fsf.org>
In-Reply-To: <1481566450.1764.23.camel@perches.com>
References: <987271481540010@web27o.yandex.ru>
         <66c68b88-e338-1d9a-b9dd-b8d858ebf349@sandeen.net> <1481566450.1764.23.camel@perches.com>
Subject: Re: [PATCH 1/1] Fixed to codestyle
MIME-Version: 1.0
Message-Id: <795201481574671@web3j.yandex.ru>
Date: Mon, 12 Dec 2016 22:31:11 +0200
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=utf-8
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Joe Perches <joe@perches.com>, Eric Sandeen <sandeen@sandeen.net>, "david@fromorbit.com" <david@fromorbit.com>
Cc: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>

12.12.2016, 20:14, "Joe Perches" <joe@perches.com>:
> On Mon, 2016-12-12 at 07:49 -0600, Eric Sandeen wrote:
>>  On 12/12/16 4:53 AM, Ozgur Karatas wrote:
>>  >
>>  > Hello,
>>  >
>>  > I have error to use uuid and I think the functions should be used when -i'm eye-catching- "(* uuid)".
>>  > I tested it.
>>  >
>>  > Regards,
>>  >
>>  > Signed-off-by: Ozgur Karatas <okaratas@member.fsf.org>
>>
>>  NAK
>>
>>  This doesn't fix code style at all; there is no need and no
>>  precedence for i.e. (*uuid) in function arguments in the xfs code,
>>  and you have broken indentation in the loop within the function.
>
> Perhaps better would be to convert the xfs uuid_t typedef
> to the include/uapi/linux/uuid.h appropriate struct and
> maybe use a comparison to NULL_UUID_<type>

Dear Joe;
Firstly, I have studied and so I thought it was correct to use it as (* uuid) in this regard Mr. Eric corrected me and he is explanatory to me.

fs/xfs/uuid.c:21: WARNING: do not add new typedefs
fs/xfs/uuid.c:36: ERROR: space prohibited before open square bracket '['
fs/xfs/uuid.c:54: WARNING: sizeof *uuid should be sizeof(*uuid)
fs/xfs/uuid.c:55: ERROR: trailing statements should be on next line
total: 2 errors, 2 warnings, 63 lines checked

>>  > diff --git a/fs/xfs/uuid.c b/fs/xfs/uuid.c
>
>
>>  > @@ -33,7 +33,7 @@ typedef struct {
>>  > * it just something that's needed for user-level file handles.
>>  > */
>>  > void
>>  > -uuid_getnodeuniq(uuid_t *uuid, int fsid [2])
>>  > +uuid_getnodeuniq(uuid_t (*uuid), int fsid [2])
>
> And to amplify Eric's comment:
>
> that bit is confusing as it makes uuid look
> like a function pointer.
>
>>  > {
>>  > xfs_uu_t *uup = (xfs_uu_t *)uuid;
>>  >
>>  > @@ -51,8 +51,8 @@ uuid_is_nil(uuid_t *uuid)
>>  > if (uuid == NULL)
>>  > return 0;
>>  > /* implied check of version number here... */
>>  > - for (i = 0; i < sizeof *uuid; i++)
>>  > - if (*cp++) return 0; /* not nil */
>>  > + for (i = 0; i < sizeof (*uuid); i++)
>>  > + if (*cp++) return 0; /* not nil */
>
> There shouldn't be a space after sizeof.

You can see below:
fs/xfs/uuid.c:54: WARNING: sizeof *uuid should be sizeof(*uuid)
Regards,

Ozgur

>>  > return 1; /* is nil */
>>  > }
>>  >

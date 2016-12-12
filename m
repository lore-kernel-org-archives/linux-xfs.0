Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from forward3h.cmail.yandex.net ([87.250.230.18]:34927 "EHLO
        forward3h.cmail.yandex.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752818AbcLLUeF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 12 Dec 2016 15:34:05 -0500
From: Ozgur Karatas <okaratas@member.fsf.org>
In-Reply-To: <50420874-ffde-283f-f2e7-cb2ebbec1b84@sandeen.net>
References: <987271481540010@web27o.yandex.ru>
         <66c68b88-e338-1d9a-b9dd-b8d858ebf349@sandeen.net>
         <1481566450.1764.23.camel@perches.com> <50420874-ffde-283f-f2e7-cb2ebbec1b84@sandeen.net>
Subject: Re: [PATCH 1/1] Fixed to codestyle
MIME-Version: 1.0
Message-Id: <737751481574841@web26j.yandex.ru>
Date: Mon, 12 Dec 2016 22:34:01 +0200
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=utf-8
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>, Joe Perches <joe@perches.com>, "david@fromorbit.com" <david@fromorbit.com>
Cc: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>

12.12.2016, 20:35, "Eric Sandeen" <sandeen@sandeen.net>:
> On 12/12/16 12:14 PM, Joe Perches wrote:
>>  On Mon, 2016-12-12 at 07:49 -0600, Eric Sandeen wrote:
>>>  On 12/12/16 4:53 AM, Ozgur Karatas wrote:
>>>>  Hello,
>>>>
>>>>  I have error to use uuid and I think the functions should be used when -i'm eye-catching- "(* uuid)".
>>>>  I tested it.
>>>>
>>>>  Regards,
>>>>
>>>>  Signed-off-by: Ozgur Karatas <okaratas@member.fsf.org>
>>>
>>>  NAK
>>>
>>>  This doesn't fix code style at all; there is no need and no
>>>  precedence for i.e. (*uuid) in function arguments in the xfs code,
>>>  and you have broken indentation in the loop within the function.
>>
>>  Perhaps better would be to convert the xfs uuid_t typedef
>>  to the include/uapi/linux/uuid.h appropriate struct and
>>  maybe use a comparison to NULL_UUID_<type>
>>
>>>>  diff --git a/fs/xfs/uuid.c b/fs/xfs/uuid.c
>>  []
>>>>  @@ -33,7 +33,7 @@ typedef struct {
>>>>    * it just something that's needed for user-level file handles.
>>>>    */
>>>>   void
>>>>  -uuid_getnodeuniq(uuid_t *uuid, int fsid [2])
>>>>  +uuid_getnodeuniq(uuid_t (*uuid), int fsid [2])
>>
>>  And to amplify Eric's comment:
>>
>>  that bit is confusing as it makes uuid look
>>  like a function pointer.
>>
>>>>   {
>>>>           xfs_uu_t *uup = (xfs_uu_t *)uuid;
>>>>
>>>>  @@ -51,8 +51,8 @@ uuid_is_nil(uuid_t *uuid)
>>>>           if (uuid == NULL)
>>>>                   return 0;
>>>>           /* implied check of version number here... */
>>>>  - for (i = 0; i < sizeof *uuid; i++)
>>>>  - if (*cp++) return 0; /* not nil */
>>>>  + for (i = 0; i < sizeof (*uuid); i++)
>>>>  + if (*cp++) return 0; /* not nil */
>>
>>  There shouldn't be a space after sizeof.
>
> and the "if" /should/ be indented under the for loop, because
> it is within the loop...
>
> I suppose simply:
>
> - for (i = 0; i < sizeof *uuid; i++)
> + for (i = 0; i < sizeof(*uuid); i++)
>
> would be fine on its own, though, because that is a bit
> unusual/inconsistent. I'll admit that I didn't spot
> that change as I scanned over the unnecessary & incorrect parts
> of the first patch. :)
>
> thanks,
> -Eric

Dear Eric;

Can you tell me the true code style? should use to (* uuid)? 
I'm learn to new and I'm newbies :)

Sorry,

Regards

Ozgur

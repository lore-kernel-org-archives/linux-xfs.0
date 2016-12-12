Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:46054 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752946AbcLLSf3 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 12 Dec 2016 13:35:29 -0500
Subject: Re: [PATCH 1/1] Fixed to codestyle
References: <987271481540010@web27o.yandex.ru>
 <66c68b88-e338-1d9a-b9dd-b8d858ebf349@sandeen.net>
 <1481566450.1764.23.camel@perches.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <50420874-ffde-283f-f2e7-cb2ebbec1b84@sandeen.net>
Date: Mon, 12 Dec 2016 12:35:28 -0600
MIME-Version: 1.0
In-Reply-To: <1481566450.1764.23.camel@perches.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Joe Perches <joe@perches.com>, Ozgur Karatas <okaratas@member.fsf.org>, david@fromorbit.com
Cc: linux-xfs@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>



On 12/12/16 12:14 PM, Joe Perches wrote:
> On Mon, 2016-12-12 at 07:49 -0600, Eric Sandeen wrote:
>> On 12/12/16 4:53 AM, Ozgur Karatas wrote:
>>>
>>> Hello,
>>>
>>> I have error to use uuid and I think the functions should be used when -i'm eye-catching- "(* uuid)".
>>> I tested it.
>>>
>>> Regards,
>>>
>>> Signed-off-by: Ozgur Karatas <okaratas@member.fsf.org>
>>
>> NAK
>>
>> This doesn't fix code style at all; there is no need and no
>> precedence for i.e. (*uuid) in function arguments in the xfs code,
>> and you have broken indentation in the loop within the function.
> 
> Perhaps better would be to convert the xfs uuid_t typedef
> to the include/uapi/linux/uuid.h appropriate struct and
> maybe use a comparison to NULL_UUID_<type>
> 
>>> diff --git a/fs/xfs/uuid.c b/fs/xfs/uuid.c
> []
>>> @@ -33,7 +33,7 @@ typedef struct {
>>>   * it just something that's needed for user-level file handles.
>>>   */
>>>  void
>>> -uuid_getnodeuniq(uuid_t *uuid, int fsid [2])
>>> +uuid_getnodeuniq(uuid_t (*uuid), int fsid [2])
> 
> And to amplify Eric's comment:
> 
> that bit is confusing as it makes uuid look
> like a function pointer.
> 
>>>  {
>>>  	xfs_uu_t *uup = (xfs_uu_t *)uuid;
>>>  
>>> @@ -51,8 +51,8 @@ uuid_is_nil(uuid_t *uuid)
>>>  	if (uuid == NULL)
>>>  		return 0;
>>>  	/* implied check of version number here... */
>>> -	for (i = 0; i < sizeof *uuid; i++)
>>> -		if (*cp++) return 0;	/* not nil */
>>> +	for (i = 0; i < sizeof (*uuid); i++) 
>>> +	if (*cp++) return 0;	/* not nil */
> 
> There shouldn't be a space after sizeof.

and the "if" /should/ be indented under the for loop, because
it is within the loop...

I suppose simply:

-	for (i = 0; i < sizeof *uuid; i++)
+	for (i = 0; i < sizeof(*uuid); i++) 

would be fine on its own, though, because that is a bit
unusual/inconsistent.  I'll admit that I didn't spot
that change as I scanned over the unnecessary & incorrect parts
of the first patch. :)

thanks,
-Eric

>>>  	return 1;	/* is nil */
>>>  }
>>>
> 

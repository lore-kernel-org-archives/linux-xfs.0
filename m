Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:45922 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751975AbdJ0QYx (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 27 Oct 2017 12:24:53 -0400
Subject: Re: [PATCH 10/10] misc: fix ubsan warnings
References: <150905608689.28563.9670731739870415773.stgit@magnolia>
 <150905615569.28563.17233201567221670601.stgit@magnolia>
 <046b0083-1065-c5cf-28ed-765e316383c9@sandeen.net>
 <20171027161433.GH5483@magnolia>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <a70d6f9a-cee6-1d06-6637-cea07feefae7@sandeen.net>
Date: Fri, 27 Oct 2017 11:24:52 -0500
MIME-Version: 1.0
In-Reply-To: <20171027161433.GH5483@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: sandeen@redhat.com, linux-xfs@vger.kernel.org

On 10/27/17 11:14 AM, Darrick J. Wong wrote:
> On Fri, Oct 27, 2017 at 08:48:07AM -0500, Eric Sandeen wrote:

...

>>> diff --git a/include/command.h b/include/command.h
>>> index fb3f5c7..59eab96 100644
>>> --- a/include/command.h
>>> +++ b/include/command.h
>>> @@ -25,7 +25,7 @@
>>>   * not iterate the command args function callout and so can be used
>>>   * for functions like "help" that should only ever be run once.
>>>   */
>>> -#define CMD_FLAG_ONESHOT	(1<<31)
>>> +#define CMD_FLAG_ONESHOT	(1U<<31)
>>>  #define CMD_FLAG_FOREIGN_OK	(1<<30)	/* command not restricted to XFS */
>>>  #define CMD_FLAG_LIBRARY	(1<<29)	/* command provided by libxcmd */
>>
>> What complained about this?  cmd flags is a signed int, right, so why is
>> this a problem?  (And why are we only using the top 3 bits?  And let's just do 1U
>> on every flag if it's really needed, but why is it needed?  I must be missing
>> something.)
> 
> I think the complaint is that "1" is signed int, and ubsan doesn't like
> us shifting a value bit into the sign bit.

Oh right, duh.

> But yeah, I suppose if we 'U'ize one of them we could do it for all.
> 
> (Though really, why not start with the lower bits?)

Heh, so:

io/init.h:

#define CMD_NOFILE_OK   (1<<0)  /* command doesn't need an open file    */
#define CMD_NOMAP_OK    (1<<1)  /* command doesn't need a mapped region */
#define CMD_FOREIGN_OK  CMD_FLAG_FOREIGN_OK

include/command.h:

#define CMD_FLAG_ONESHOT        (1<<31)
#define CMD_FLAG_FOREIGN_OK     (1<<30) /* command not restricted to XFS */
#define CMD_FLAG_LIBRARY        (1<<29) /* command provided by libxcmd */

What could possibly go wrong?

-Eric

Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:42232 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934322AbeFLXPl (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 12 Jun 2018 19:15:41 -0400
Subject: Re: [PATCH 2/7] mkfs: move mkfs.xfs.8 to an .in file
References: <1528831883-21879-1-git-send-email-sandeen@sandeen.net>
 <1528831883-21879-3-git-send-email-sandeen@sandeen.net>
 <c48879de-0704-8da8-da35-7b5a10fd0339@sandeen.net>
 <20180612221027.GO22045@magnolia>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <799b8223-afec-88c4-7de9-cf1132c30121@sandeen.net>
Date: Tue, 12 Jun 2018 18:15:40 -0500
MIME-Version: 1.0
In-Reply-To: <20180612221027.GO22045@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org



On 6/12/18 5:10 PM, Darrick J. Wong wrote:
> On Tue, Jun 12, 2018 at 02:45:40PM -0500, Eric Sandeen wrote:
>> On 6/12/18 2:31 PM, Eric Sandeen wrote:
>>> Simple move with no changes, next patch will parameterize @sysconfdir@
>>>
>>> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
>>> Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
>>> ---
>>>  man/man8/Makefile      |    8 +-
> 
> /me thinks this ought to go in the next patch, since that's where the
> parameterization gets used.
>

well the makefile still needs to transmogrify mkfs.xfs.8.in to mkfs.xfs.8,
and replacing all (nonexistent) instances of @sysconfdir@ via sed /will/
do that ;)

yeah I thought about making it a mv but TBH that didn't seem worth the effort
for no net change in behavior.

-Eric

>>>  man/man8/mkfs.xfs.8    | 1015 ------------------------------------------------
>>>  man/man8/mkfs.xfs.8.in | 1015 ++++++++++++++++++++++++++++++++++++++++++++++++
>>>  3 files changed, 1022 insertions(+), 1016 deletions(-)
>>>  delete mode 100644 man/man8/mkfs.xfs.8
>>>  create mode 100644 man/man8/mkfs.xfs.8.in
>>
>> Well crud the point of mv-with-no-changes was to make git detect the
>> rename :/
> 
> Works for me, at least I don't have to go dig out your changes. :)
> 
> With that one thing moved,
> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
> 
> --D
> 
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

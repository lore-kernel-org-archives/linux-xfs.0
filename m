Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n3LFlb2V135933 for <xfs@oss.sgi.com>; Tue, 21 Apr 2009 10:47:37 -0500
Received: from estes.americas.sgi.com (estes.americas.sgi.com [128.162.236.10])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 41EA78F8078
	for <xfs@oss.sgi.com>; Tue, 21 Apr 2009 08:47:31 -0700 (PDT)
Message-Id: <3296B35F-1364-4E7B-856B-041AF746BFFC@sgi.com>
From: Felix Blyakher <felixb@sgi.com>
In-Reply-To: <20090419181410.GS3709@josefsipek.net>
Mime-Version: 1.0 (Apple Message framework v926)
Subject: Re: [PATCH] xfs: add more checks to superblock validation
Date: Tue, 21 Apr 2009 10:47:30 -0500
References: <1240002765-20279-1-git-send-email-felixb@sgi.com>
	<20090418050544.GQ3709@josefsipek.net>
	<81FBAD0F-AE2A-4780-BC8B-135C4CCE8D3A@sgi.com>
	<20090419181410.GS3709@josefsipek.net>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"; DelSp="yes"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Josef 'Jeff' Sipek <jeffpc@josefsipek.net>
Cc: xfs@oss.sgi.com


On Apr 19, 2009, at 1:14 PM, Josef 'Jeff' Sipek wrote:

> On Sun, Apr 19, 2009 at 11:39:20AM -0500, Felix Blyakher wrote:
>>
>> On Apr 18, 2009, at 12:05 AM, Josef 'Jeff' Sipek wrote:
>>
>>> On Fri, Apr 17, 2009 at 04:12:45PM -0500, Felix Blyakher wrote:
>>>> From: Olaf Weber <olaf@sgi.com>
>>>>
>>>> There had been reports where xfs filesystem was randomly
>>>> corrupted with fsfuzzer, and xfs failed to handle it
>>>> gracefully. This patch fixes couple of reported problem
>>>> by providing additional checks in the superblock
>>>> validation routine.
>>>>
>>>> Signed-off-by: Felix Blyakher <felixb@sgi.com>
>>>
>>> Since this patch is from Olaf, shouldn't he have a s-o-b line as  
>>> well?
>>
>> I was following the guidelines from the SubmittingPatches:
>>
>> The "from" line must be the very first line in the message body,
>> and has the form:
>>
>>        From: Original Author <author@example.com>
>>
>> The "from" line specifies who will be credited as the author of the
>> patch in the permanent changelog.  If the "from" line is missing,
>> then the "From:" line from the email header will be used to determine
>> the patch author in the changelog.
>>
>>
>> So, is "From:" enough here, or "Signed-off-by" is needed as well?
>
> The From line determines author-ship. If this is Olaf's patch, then  
> the From
> is right. My understanding is that s-o-b is intended as a "I didn't do
> anything stupid (e.g., incorporate licensed code, etc.) while  
> working on
> this patch/handling this patch."

That what I did before creating (from the proposed changes)
and submitting the patch (and making sure the author get the
credit).

> This makes me believe that the author
> should include a s-o-b line as well.
>
> So, for example, whenever _I_ send a patch that I authored, I have  
> both a
>> From and a s-o-b.

That seems redundant based on the following excerpt from the
SubmittingPatches:

If the "from" line is missing,
then the "From:" line from the email header will be used to determine
the patch author in the changelog.

>>  If someone picks it up (e.g., akpm), he'd add his s-o-b,
> so when he resends it, it'd have my from, my s-o-b, and his s-o-b.  
> As far as
> I know, other kernel folks do the same.

That's definitely not usual case for submitting the patch on
somebody else behalf, but I found the following entry in the log:

commit 55643171de7ba429fbf2cb72fb1f2c6f2df0dcf3
Author: Ashwin Ganti <ashwin.ganti@gmail.com>
Date:   Tue Feb 24 19:48:44 2009 -0800

     Staging: add p9auth driver

     This is a driver that adds Plan 9 style capability device
     implementation.

     From: Ashwin Ganti <ashwin.ganti@gmail.com>
     Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>


But at the end, I don't mind to follow any established
guidelines here. Just need clarifications.

Felix

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

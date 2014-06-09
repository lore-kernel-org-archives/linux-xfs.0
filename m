Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 3B6047F55
	for <xfs@oss.sgi.com>; Mon,  9 Jun 2014 09:29:34 -0500 (CDT)
Message-ID: <5395C4CA.6010206@sgi.com>
Date: Mon, 09 Jun 2014 09:29:30 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 1/3] xfs_fsr: ensure the line we read from leftofffile
	is null terminated
References: <53922B49.1050005@redhat.com> <53922C8E.3050700@sandeen.net>
	<20140609130235.GA31319@bfoster.bfoster>
	<5395BE32.3080204@sandeen.net>
In-Reply-To: <5395BE32.3080204@sandeen.net>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Eric Sandeen <sandeen@redhat.com>, Brian Foster <bfoster@redhat.com>, xfs-oss <xfs@oss.sgi.com>

On 06/09/14 09:01, Eric Sandeen wrote:
> On 6/9/14, 8:02 AM, Brian Foster wrote:
>> On Fri, Jun 06, 2014 at 04:03:10PM -0500, Eric Sandeen wrote:
>>> Ensure that the string we read from leftofffile is NULL
>>> terminated; the buffer gets passed to strchr(), so
>>> it's important that we ensure it ends with NULL.
>>>
>>> Signed-off-by: Eric Sandeen<sandeen@redhat.com>
>>> ---
>>>
>>> diff --git a/fsr/xfs_fsr.c b/fsr/xfs_fsr.c
>>> index 3818f02..94d235c 100644
>>> --- a/fsr/xfs_fsr.c
>>> +++ b/fsr/xfs_fsr.c
>>> @@ -554,6 +554,8 @@ fsrallfs(char *mtab, int howlong, char *leftofffile)
>>>   			fsrprintf(_("could not read %s, starting with %s\n"),
>>>   				leftofffile, *fs->dev);
>>>   		} else {
>>> +			/* Ensure the buffer we read is null terminated */
>>> +			buf[SMBUFSZ-1] = '\0';
>>
>> Maybe just initialize the buffer..?
>
> and then read no more than SMBUFSZ-1... I dunno, 6 one way, half a dozen
> the other?

I like my bike shed pained red with white and blue swirlies. :)

The strings should be NULL terminated for the string ops. It makes more 
sense to NULL one byte than 1024. If the full SMBUFSZ bytes are desired, 
then bump the array for the NULL byte.

--Mark.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

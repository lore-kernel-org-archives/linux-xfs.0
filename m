Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 2EBF77F37
	for <xfs@oss.sgi.com>; Thu, 13 Nov 2014 14:45:57 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id C0C42AC002
	for <xfs@oss.sgi.com>; Thu, 13 Nov 2014 12:45:53 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id AhBVYBBeMx67zOzW for <xfs@oss.sgi.com>;
	Thu, 13 Nov 2014 12:45:52 -0800 (PST)
Message-ID: <5465187D.3060308@sandeen.net>
Date: Thu, 13 Nov 2014 14:45:49 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] xfsrestore: fix string corruption in shrink()
References: <20141113191510.176392492@sgi.com> <54650970.7010902@sandeen.net>
	<54650CE1.3050706@sgi.com>
In-Reply-To: <54650CE1.3050706@sgi.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Mark Tinguely <tinguely@sgi.com>
Cc: xfs@oss.sgi.com

On 11/13/14 1:56 PM, Mark Tinguely wrote:
> On 11/13/14 13:41, Eric Sandeen wrote:
>> On 11/13/14 1:14 PM, Mark Tinguely wrote:
>>> Linux strcpy() corrupts the output string when the input
>>
>> Not Linux strcpy in particular; per C99:
>>
>>> The strcpy function copies the string pointed to by s2
>>> (including the terminating null character) into the array
>>> pointed to by s1. If copying takes place between objects
>>> that overlap, the behavior is undefined.
>>                  ^^^^^^^^^^^^^^^^^^^^^^^^^
>>
>>> and output strings overlap. The shrink() function in xfsrestore
>>> uses an overlapping strcpy() to remove special characters when
>>> processing an interactive command line. The resultant command
>>> will fail.
>>>
>>> examples:
>>>   ->  cd "AOGC exome chip core genotyping"
>>> AOGC exome chp  core genotyping not found
>>>   ->  cd "t t"
>>> tt not found
>>>
>>> Fix my manually moving the characters in the array.
>>>
>>> Signed-off-by: Mark Tinguely<tinguely@sgi.com>
>>> ---
>>>   restore/tree.c |   14 +++++++++++++-   
>>>   1 file changed, 13 insertions(+), 1 deletion(-)
>>>
>>> Index: b/restore/tree.c
>>> ===================================================================
>>> --- a/restore/tree.c
>>> +++ b/restore/tree.c
>>> @@ -4857,7 +4857,19 @@ distance_to_space( char *s, char *l )
>>>   static void
>>>   shrink( char *s, size_t cnt )
>>>   {
>>> -    strcpy( s, s + cnt );
>>> +    /*
>>> +     * Linux strcpy corrupts the string if the src and dst overlap.
>>> +     * Manually copy the entries to the left.
>>> +     *
>>> +     * Since the liter array is mostly nulls, shrink is not moving
>>
>> what is the "liter array?"  Ah well.  Context.  ;)
>>
>>> +     * the array left as intended. Does not seem to be many embedded
>>> +     * processing characters, so leaving it for now
>>> +     */
>>> +    char *m = s + cnt;
>>> +    while (*m != '\0')
>>> +        *s++ = *m++;
>>> +    /* NULL the last character of the string */
>>> +    *s = '\0';
>>>   }
>>
>> Would this be any less manual?
>>
>>      size_t n = strlen(s+cnt) + 1; /* 1 for terminating NULL */
>>
>>      memmove(s, s + cnt, n);
>>
>> because memmove is ok with overlaps.
>>
>> -Eric
>>
> 
> I thought of that but if we are doing a strlen() might as well just copy it while you are walking the string.

Ok, fair enough.  I think mine is clearer to dummies like me, but *shrug.*

I'd also prefer that the comment say "overlapping strcpy is undefined"
rather than poking fun at Linux. ;)  And the rest of the comment doesn't
really help me understand what's going on.  "liter?"  "embedded processing
characters?"  I have no idea what that means when I'm reading this function,
which simply moves part of a string around, so I'd rather have either a
description of what it does & doesn't do at the
top, or leave out those seemingly random details.

But it fixes a bug, and those are nitpicks you can fix, or not, I suppose,
though I really would prefer a clearer comment so future readers have some
clue, and don't end up more confused than when they started reading it. ;)

Anyway, for the fix itself,

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> --Mark.
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

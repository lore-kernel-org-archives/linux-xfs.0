Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 352D47F37
	for <xfs@oss.sgi.com>; Thu, 13 Nov 2014 15:57:30 -0600 (CST)
Message-ID: <54652949.7090506@sgi.com>
Date: Thu, 13 Nov 2014 15:57:29 -0600
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfsrestore: fix string corruption in shrink()
References: <20141113191510.176392492@sgi.com> <54650970.7010902@sandeen.net>
	<54650CE1.3050706@sgi.com> <5465187D.3060308@sandeen.net>
In-Reply-To: <5465187D.3060308@sandeen.net>
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
Cc: xfs@oss.sgi.com

On 11/13/14 14:45, Eric Sandeen wrote:
> On 11/13/14 1:56 PM, Mark Tinguely wrote:
>> On 11/13/14 13:41, Eric Sandeen wrote:
>>> On 11/13/14 1:14 PM, Mark Tinguely wrote:
>>>> Linux strcpy() corrupts the output string when the input
>>>
>>> Not Linux strcpy in particular; per C99:
>>>
>>>> The strcpy function copies the string pointed to by s2
>>>> (including the terminating null character) into the array
>>>> pointed to by s1. If copying takes place between objects
>>>> that overlap, the behavior is undefined.
>>>                   ^^^^^^^^^^^^^^^^^^^^^^^^^
>>>
>>>> and output strings overlap. The shrink() function in xfsrestore
>>>> uses an overlapping strcpy() to remove special characters when
>>>> processing an interactive command line. The resultant command
>>>> will fail.
>>>>
>>>> examples:
>>>>    ->   cd "AOGC exome chip core genotyping"
>>>> AOGC exome chp  core genotyping not found
>>>>    ->   cd "t t"
>>>> tt not found
>>>>
>>>> Fix my manually moving the characters in the array.
>>>>
>>>> Signed-off-by: Mark Tinguely<tinguely@sgi.com>
>>>> ---
>>>>    restore/tree.c |   14 +++++++++++++-
>>>>    1 file changed, 13 insertions(+), 1 deletion(-)

>> I thought of that but if we are doing a strlen() might as well just copy it while you are walking the string.
>
> Ok, fair enough.  I think mine is clearer to dummies like me, but *shrug.*
>
> I'd also prefer that the comment say "overlapping strcpy is undefined"
> rather than poking fun at Linux. ;)  And the rest of the comment doesn't
> really help me understand what's going on.  "liter?"  "embedded processing
> characters?"  I have no idea what that means when I'm reading this function,
> which simply moves part of a string around, so I'd rather have either a
> description of what it does & doesn't do at the
> top, or leave out those seemingly random details.
>
> But it fixes a bug, and those are nitpicks you can fix, or not, I suppose,
> though I really would prefer a clearer comment so future readers have some
> clue, and don't end up more confused than when they started reading it. ;)
>
> Anyway, for the fix itself,
>
> Reviewed-by: Eric Sandeen<sandeen@redhat.com>

No offense to Linux intended.

liter is an array of mostly NULL characters that calls this function. 
The contents of the array seems at odds with how this function operates. 
The comment was mostly for my future self so I don't have to relearn 
what is going on here. I do not mind it removed from the community code.

--Mark.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

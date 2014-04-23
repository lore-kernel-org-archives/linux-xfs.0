Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id C3DEA7F3F
	for <xfs@oss.sgi.com>; Tue, 22 Apr 2014 22:05:07 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 66F63AC00A
	for <xfs@oss.sgi.com>; Tue, 22 Apr 2014 20:05:04 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id ZGGpZTJgLq8PZsYA for <xfs@oss.sgi.com>;
	Tue, 22 Apr 2014 20:04:59 -0700 (PDT)
Message-ID: <53572DDA.8080302@sandeen.net>
Date: Tue, 22 Apr 2014 22:04:58 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] xfs: remote attribute overwrite causes transaction overrun
References: <1398149949-11324-1-git-send-email-david@fromorbit.com>	<535659F7.4060702@oracle.com>
	<20140422234628.GN18672@dastard> <20140423000042.GO18672@dastard>
In-Reply-To: <20140423000042.GO18672@dastard>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>, Jeff Liu <jeff.liu@oracle.com>
Cc: xfs@oss.sgi.com

On 4/22/14, 7:00 PM, Dave Chinner wrote:
> On Wed, Apr 23, 2014 at 09:46:28AM +1000, Dave Chinner wrote:
>> On Tue, Apr 22, 2014 at 08:00:55PM +0800, Jeff Liu wrote:
>>>
>>> On 04/22 2014 14:59 PM, Dave Chinner wrote:

...
  =

>>>> +	/* remote value might be different size to the buffer supplied. */
>>>> +	if (args->rmtvaluelen =3D args->valuelen)
>>> 			     ^^^
>>> Here is a typo...
>>
>> Oh, well spotted.
>>
>> But, hold on a minute, shouldn't gcc be catching those sorts of
>> typos?
>>
>> /me groans
>>
>> $ gcc t.c
>> $ gcc -Wall t.c
>> t.c: In function =BFmain=BF:
>> t.c:10:2: warning: suggest parentheses around assignment used as truth v=
alue [-Wparentheses]
>>   if (foo =3D bar)
>>   ^
>> $
>>
>> Only if -Wparentheses is specified.
>>
>> Why the hell are we suppressing useful warnings on the kernel build?
> =

> Hmmm - looks like I missed the output of the warning when I built
> against 3.15-rc2 because it was a rebuild the world and there's tons
> of output when that happens...
> =

> <sigh>
> =

> Time to add ccflags-y +=3D -Werror to the makefile....

Probably only under a couple specific arches...?  How are we for i.e.
stupid printf format warnings about long vs. longlong on 32/64 arches...?

Or maybe you can -Werror, -Wno$FOO?

-Eric
 =

> Cheers,
> =

> Dave.
> =


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

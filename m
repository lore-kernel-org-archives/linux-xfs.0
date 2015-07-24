Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 781757F83
	for <xfs@oss.sgi.com>; Fri, 24 Jul 2015 09:44:08 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 561358F8065
	for <xfs@oss.sgi.com>; Fri, 24 Jul 2015 07:44:05 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id GQJGfuRsGut0D9p5 for <xfs@oss.sgi.com>;
	Fri, 24 Jul 2015 07:44:03 -0700 (PDT)
Message-ID: <55B24F32.4080505@sandeen.net>
Date: Fri, 24 Jul 2015 09:44:02 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: XFS File system in trouble
References: <03864DDC681E664EBF5D47682BE7D7CF0D3574DF@USADCWVEMBX07.corp.global.level3.com>	<55AA5FCE.4080702@sandeen.net>	<03864DDC681E664EBF5D47682BE7D7CF0D358740@USADCWVEMBX07.corp.global.level3.com>	<CAN3tLtJuk3LKHtxvbXATBR7bjr2e=GTX-fgs-jQniuxqRXjeoA@mail.gmail.com>	<55AAF73A.4040903@mygrande.net>
	<20150719232754.GS7943@dastard>	<55ACA615.10501@mygrande.net>
	<55B05CF5.8050204@sandeen.net> <55B241FC.8020207@mygrande.net>
In-Reply-To: <55B241FC.8020207@mygrande.net>
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
To: Leslie Rhorer <lrhorer@mygrande.net>, Dave Chinner <david@fromorbit.com>
Cc: Kris Rusocki <kszysiu@braxis.org>, "Rhorer,
	Leslie" <Leslie.Rhorer@level3.com>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On 7/24/15 8:47 AM, Leslie Rhorer wrote:
> On 7/22/2015 10:18 PM, Eric Sandeen wrote:
>> On 7/20/15 2:41 AM, Leslie Rhorer wrote:
>>> On 7/19/2015 6:27 PM, Dave Chinner wrote:
>>>> On Sat, Jul 18, 2015 at 08:02:50PM -0500, Leslie Rhorer wrote:
>>>>>
>>>>>      I found the problem with md5sum (and probably nfs, as well).  One
>>>>> of the memory modules in the server was bad.  The problem with XFS
>>>>> persists.  Every time tar tried to create the directory:
>>>>
>>>> Now you need to run xfs_repair.
>>>
>>> I do that every time the array implodes. It makes no difference. It
>>> never mentions cleaning the structure tar says needs cleaning, and
>>> the next time I run tar on that file, the filesystem craters.
>>>
>>
>> What.
>> Did.
>> xfs_repair.
>> Say.
> 
> Look.
> At.
> My.
> First.
> E-mail.

Your first email contains only a narrative about repair:

"Xfs_repair completes, usually with no errors found, or sometimes one or two errors."

But we don't know what those one or two errors are.

Your second email shows the output of one instance of a completely clean repair.

Then you found out that you had bad memory, and Dave asked you to run repair again,
having fixed that hardware issue.

You said it "never mentions cleaning the structure tar says needs cleaning"

What I am asking you is for the full repair output now, so we can see what it
*did* say, rather than an interpreted narrative about what it did not say.

Stating "repair found no errors" would also be helpful.  Your reply above implies
that maybe it did find errors, but not ones you felt were related.  I'd simply like
to know the details, so we can continue to try to resolve your problem.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

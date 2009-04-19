Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n3JIEGbY002550 for <xfs@oss.sgi.com>; Sun, 19 Apr 2009 13:14:16 -0500
Received: from josefsipek.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 886DD2253BD
	for <xfs@oss.sgi.com>; Sun, 19 Apr 2009 11:14:10 -0700 (PDT)
Received: from josefsipek.net (josefsipek.net [141.211.133.196]) by
	cuda.sgi.com with ESMTP id rEvFVXNamoyyf1xv for
	<xfs@oss.sgi.com>; Sun, 19 Apr 2009 11:14:10 -0700 (PDT)
Date: Sun, 19 Apr 2009 14:14:10 -0400
From: "Josef 'Jeff' Sipek" <jeffpc@josefsipek.net>
Subject: Re: [PATCH] xfs: add more checks to superblock validation
Message-ID: <20090419181410.GS3709@josefsipek.net>
References: <1240002765-20279-1-git-send-email-felixb@sgi.com>
	<20090418050544.GQ3709@josefsipek.net>
	<81FBAD0F-AE2A-4780-BC8B-135C4CCE8D3A@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <81FBAD0F-AE2A-4780-BC8B-135C4CCE8D3A@sgi.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Felix Blyakher <felixb@sgi.com>
Cc: xfs@oss.sgi.com

On Sun, Apr 19, 2009 at 11:39:20AM -0500, Felix Blyakher wrote:
>
> On Apr 18, 2009, at 12:05 AM, Josef 'Jeff' Sipek wrote:
>
>> On Fri, Apr 17, 2009 at 04:12:45PM -0500, Felix Blyakher wrote:
>>> From: Olaf Weber <olaf@sgi.com>
>>>
>>> There had been reports where xfs filesystem was randomly
>>> corrupted with fsfuzzer, and xfs failed to handle it
>>> gracefully. This patch fixes couple of reported problem
>>> by providing additional checks in the superblock
>>> validation routine.
>>>
>>> Signed-off-by: Felix Blyakher <felixb@sgi.com>
>>
>> Since this patch is from Olaf, shouldn't he have a s-o-b line as well?
>
> I was following the guidelines from the SubmittingPatches:
>
> The "from" line must be the very first line in the message body,
> and has the form:
>
>         From: Original Author <author@example.com>
>
> The "from" line specifies who will be credited as the author of the
> patch in the permanent changelog.  If the "from" line is missing,
> then the "From:" line from the email header will be used to determine
> the patch author in the changelog.
>
>
> So, is "From:" enough here, or "Signed-off-by" is needed as well?

The From line determines author-ship. If this is Olaf's patch, then the From
is right. My understanding is that s-o-b is intended as a "I didn't do
anything stupid (e.g., incorporate licensed code, etc.) while working on
this patch/handling this patch." This makes me believe that the author
should include a s-o-b line as well.

So, for example, whenever _I_ send a patch that I authored, I have both a
>From and a s-o-b. If someone picks it up (e.g., akpm), he'd add his s-o-b,
so when he resends it, it'd have my from, my s-o-b, and his s-o-b. As far as
I know, other kernel folks do the same.

Jeff.

-- 
My public GPG key can be found at
http://www.josefsipek.net/gpg/public-0xC7958FFE.txt

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n3JGdTk0260387 for <xfs@oss.sgi.com>; Sun, 19 Apr 2009 11:39:30 -0500
Received: from estes.americas.sgi.com (estes.americas.sgi.com [128.162.236.10])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 8F430AC005
	for <xfs@oss.sgi.com>; Sun, 19 Apr 2009 09:39:22 -0700 (PDT)
Message-Id: <81FBAD0F-AE2A-4780-BC8B-135C4CCE8D3A@sgi.com>
From: Felix Blyakher <felixb@sgi.com>
In-Reply-To: <20090418050544.GQ3709@josefsipek.net>
Mime-Version: 1.0 (Apple Message framework v930.3)
Subject: Re: [PATCH] xfs: add more checks to superblock validation
Date: Sun, 19 Apr 2009 11:39:20 -0500
References: <1240002765-20279-1-git-send-email-felixb@sgi.com>
	<20090418050544.GQ3709@josefsipek.net>
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


On Apr 18, 2009, at 12:05 AM, Josef 'Jeff' Sipek wrote:

> On Fri, Apr 17, 2009 at 04:12:45PM -0500, Felix Blyakher wrote:
>> From: Olaf Weber <olaf@sgi.com>
>>
>> There had been reports where xfs filesystem was randomly
>> corrupted with fsfuzzer, and xfs failed to handle it
>> gracefully. This patch fixes couple of reported problem
>> by providing additional checks in the superblock
>> validation routine.
>>
>> Signed-off-by: Felix Blyakher <felixb@sgi.com>
>
> Since this patch is from Olaf, shouldn't he have a s-o-b line as well?

I was following the guidelines from the SubmittingPatches:

The "from" line must be the very first line in the message body,
and has the form:

         From: Original Author <author@example.com>

The "from" line specifies who will be credited as the author of the
patch in the permanent changelog.  If the "from" line is missing,
then the "From:" line from the email header will be used to determine
the patch author in the changelog.


So, is "From:" enough here, or "Signed-off-by" is needed as well?

Felix

> I'm not really familiar with this part of the code...but it looks  
> fine to
> me.
>
> Josef 'Jeff' Sipek.
>
> -- 
> Fact: 29.6% of all statistics are generated randomly.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

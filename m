Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n6UFbb9f082214 for <xfs@oss.sgi.com>; Thu, 30 Jul 2009 10:37:37 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 13C91396891
	for <xfs@oss.sgi.com>; Thu, 30 Jul 2009 08:38:24 -0700 (PDT)
Received: from mail.sandeen.net (sandeen.net [209.173.210.139]) by
	cuda.sgi.com with ESMTP id 1NmKD92EvpMWFEiW for
	<xfs@oss.sgi.com>; Thu, 30 Jul 2009 08:38:24 -0700 (PDT)
Message-ID: <4A71BE6F.4030609@sandeen.net>
Date: Thu, 30 Jul 2009 10:38:23 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] xfstests: actually hook up 198, make it generic
References: <4A708FF7.5@sandeen.net> <20090730152756.GB27914@infradead.org>
In-Reply-To: <20090730152756.GB27914@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs mailing list <xfs@oss.sgi.com>

Christoph Hellwig wrote:
> On Wed, Jul 29, 2009 at 01:07:51PM -0500, Eric Sandeen wrote:
>> Not entirely sure how I managed this, but 198 was not in groups
>> so was never run - and wasn't in the makefile, so was never built.
>> Oops.
>>
>> Fix that up, make it a generic test, and move it to the
>> aio-dio-regress subdir.
> 
> Hah, great one.

yeah, I rock!  :/

>>  # This should actually run on anything that supports O_DIRECT + AIO...
>> -_supported_fs xfs
>> +_supported_fs generic
> 
> maybe also remove that comment now that it's generic.

Ok, sure.

>> --- /dev/null
>> +++ b/src/aio-dio-regress/aiodio_sparse2.c
>> @@ -0,0 +1,384 @@
>> +/* gcc -g -Wall -O2 aiodio_sparse.c -o aiodio_sparse -laio */
>> +
>> +/*
>> + * From http://developer.osdl.org/daniel/AIO/TESTS/aiodio_sparse.c
>> + * With patch from https://bugzilla.redhat.com/attachment.cgi?id=142124
>> + * (Bug https://bugzilla.redhat.com/show_bug.cgi?id=217098)
>> + */
> 
> Did we manage to get a proper copyright / license statement for this
> one.

hadn't looked into it; I'll  ping Daniel McNeil who seems to be the
original author ...?

But I'll fix it and worry about the copyright later, since it's already
in ...

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

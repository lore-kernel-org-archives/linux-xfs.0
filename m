Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 778957FE6
	for <linux-xfs@oss.sgi.com>; Wed, 21 Aug 2013 10:28:47 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 644FE3040A4
	for <linux-xfs@oss.sgi.com>; Wed, 21 Aug 2013 08:28:44 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id hHhCU8ZWCOyrFYim for <linux-xfs@oss.sgi.com>;
	Wed, 21 Aug 2013 08:28:43 -0700 (PDT)
Message-ID: <5214DCAA.9090703@sandeen.net>
Date: Wed, 21 Aug 2013 10:28:42 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] xfs_repair: add prototype for alloc_ex_data()
References: <5213F849.7080308@redhat.com> <5214CE82.3040707@sgi.com>
In-Reply-To: <5214CE82.3040707@sgi.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: quoted-printable
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Mark Tinguely <tinguely@sgi.com>
Cc: "'linux-xfs@oss.sgi.com'" <linux-xfs@oss.sgi.com>, Eric Sandeen <sandeen@redhat.com>

On 8/21/13 9:28 AM, Mark Tinguely wrote:
> On 08/20/13 18:14, Eric Sandeen wrote:
>> 3ac87fbf xfsprogs: fix inode crash in xfs_repair
>>
>> un-static'd alloc_ex_data and used it in phase6.c,
>> but didn't put a prototype in a header, so:
>>
>>   phase6.c: In function =91mk_orphanage=92:
>>   phase6.c:943: warning: implicit declaration of function =91alloc_ex_da=
ta=92
>>
>> Fix it...
>>
>> Signed-off-by: Eric Sandeen<sandeen@redhat.com>
>> ---
> =

> =

> Thanks and sorry. I knew it and hoped to get it in before it got committe=
d.

Eh, it happens.

Minor demerit for Rich for not catching it before commit, either ;)

-Eric (who has never, NEVER made a mistake like that)

> =

> --Mark.
> =

> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
> =


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

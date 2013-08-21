Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 525E97FDB
	for <linux-xfs@oss.sgi.com>; Wed, 21 Aug 2013 12:13:31 -0500 (CDT)
Message-ID: <5214F569.9020605@sgi.com>
Date: Wed, 21 Aug 2013 12:14:17 -0500
From: Rich Johnston <rjohnston@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfs_repair: add prototype for alloc_ex_data()
References: <5213F849.7080308@redhat.com> <5214CE82.3040707@sgi.com>
	<5214DCAA.9090703@sandeen.net>
In-Reply-To: <5214DCAA.9090703@sandeen.net>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="windows-1252"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@sandeen.net>
Cc: "'linux-xfs@oss.sgi.com'" <linux-xfs@oss.sgi.com>, Eric Sandeen <sandeen@redhat.com>, Mark Tinguely <tinguely@sgi.com>

On 08/21/2013 10:28 AM, Eric Sandeen wrote:
> On 8/21/13 9:28 AM, Mark Tinguely wrote:
>> On 08/20/13 18:14, Eric Sandeen wrote:
>>> 3ac87fbf xfsprogs: fix inode crash in xfs_repair
>>>
>>> un-static'd alloc_ex_data and used it in phase6.c,
>>> but didn't put a prototype in a header, so:
>>>
>>>    phase6.c: In function =91mk_orphanage=92:
>>>    phase6.c:943: warning: implicit declaration of function =91alloc_ex_=
data=92
>>>
>>> Fix it...
>>>
>>> Signed-off-by: Eric Sandeen<sandeen@redhat.com>
>>> ---
>>
>>
>> Thanks and sorry. I knew it and hoped to get it in before it got committ=
ed.
>
> Eh, it happens.
>
> Minor demerit for Rich for not catching it before commit, either ;)

***rjohnston: hides head in shame and vows to improve

>
> -Eric (who has never, NEVER made a mistake like that)
>
>>
>> --Mark.
>>
>> _______________________________________________
>> xfs mailing list
>> xfs@oss.sgi.com
>> http://oss.sgi.com/mailman/listinfo/xfs
>>
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

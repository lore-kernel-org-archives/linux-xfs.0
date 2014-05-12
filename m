Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 97DD429DFA
	for <xfs@oss.sgi.com>; Mon, 12 May 2014 12:52:30 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 7D7DA8F8039
	for <xfs@oss.sgi.com>; Mon, 12 May 2014 10:52:27 -0700 (PDT)
Received: from b.mx.filmlight.ltd.uk (b.mx.filmlight.ltd.uk [77.107.81.251])
	by cuda.sgi.com with SMTP id fdfzAZK0EEYZ2DJO for
	<xfs@oss.sgi.com>; Mon, 12 May 2014 10:52:25 -0700 (PDT)
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: 'delete' parameter in xfs_ialloc.h
From: Roger Willcocks <roger@filmlight.ltd.uk>
In-Reply-To: <5370E964.50805@sandeen.net>
Date: Mon, 12 May 2014 18:52:25 +0100
Message-Id: <949AF4F7-F45E-49EF-AE32-D2A6F1FE6338@filmlight.ltd.uk>
References: <1399908138.4857.28.camel@montana.filmlight.ltd.uk>
	<5370E964.50805@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Roger Willcocks <roger@filmlight.ltd.uk>, xfs@oss.sgi.com


On 12 May 2014, at 16:31, Eric Sandeen <sandeen@sandeen.net> wrote:

> On 5/12/14, 10:22 AM, Roger Willcocks wrote:
>> Hi folks,
>> =

>> I have to fix this up every time I update xfsprogs -
>> =

>> The 'delete' parameter in xfsprogs/include/xfs_ialloc.c:xfs_difree(...)
>> causes a compile error if the header's included in C++ code (even with
>> 'extern "C"') -
>> =

>> xfs_ialloc.h:102: error: expected =91,=92 or =91...=92 before =91delete=
=92
>> =

>> (gcc 4.4.7)
>> =

>> It would be handy if the parameter name could be commented out or
>> changed in the header.
>> =

> =

> Send a patch?  Would need to hit kernel code too.
> =

> -Eric
> =


Okay, two near-identical patches, one for xfsprogs and one for xfs follow.

--
Roger

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

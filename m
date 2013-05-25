Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 423107F37
	for <xfs@oss.sgi.com>; Sat, 25 May 2013 18:11:08 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 2F0998F8033
	for <xfs@oss.sgi.com>; Sat, 25 May 2013 16:11:05 -0700 (PDT)
Received: from mail-qe0-f47.google.com (mail-qe0-f47.google.com
	[209.85.128.47]) by cuda.sgi.com with ESMTP id IYroXUh2Bir2YCbs
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Sat, 25 May 2013 16:11:04 -0700 (PDT)
Received: by mail-qe0-f47.google.com with SMTP id f6so2312740qej.34
	for <xfs@oss.sgi.com>; Sat, 25 May 2013 16:11:03 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAEH94LgWQcjSMenoT3a81pLWbw2pEYWpKFyGwoxAvDX2FTwbXA@mail.gmail.com>
References: <CAEH94LjnVn-uD6cfwOcChC4wq1PppcD8BN30F93SD=YjdTbbuw@mail.gmail.com>
	<51A1144A.4020600@gmail.com>
	<CAEH94LgWQcjSMenoT3a81pLWbw2pEYWpKFyGwoxAvDX2FTwbXA@mail.gmail.com>
Date: Sun, 26 May 2013 07:11:03 +0800
Message-ID: <CAEH94Lj4_8PBbhdD2f-ZFG=NxgS2uBkGUfaQvct71H4X7giPZA@mail.gmail.com>
Subject: Re: xfsprogs: is it one issue?
From: Zhi Yong Wu <zwu.kernel@gmail.com>
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
To: "Michael L. Semon" <mlsemon35@gmail.com>
Cc: xfs@oss.sgi.com

I remove the lines related to h_chksum, then it can work well, so i
guess that i should send out one patch to fix it.

On Sun, May 26, 2013 at 6:57 AM, Zhi Yong Wu <zwu.kernel@gmail.com> wrote:
> Yes, now xfsprogs can be compiled and installed well, but xfstests is
> still failed to build.
>
> [root@f15 xfstests]# make
> loggen.c: In function 'loggen_unmount':
> loggen.c:137:9: error: 'xlog_rec_header_t' has no member named 'h_chksum'
> loggen.c: In function 'loggen_empty':
> loggen.c:205:9: error: 'xlog_rec_header_t' has no member named 'h_chksum'
> gmake[3]: *** [loggen] Error 1
> gmake[2]: *** [src] Error 2
> make[1]: *** [default] Error 2
> make: *** [default] Error 2
>
>
>
> On Sun, May 26, 2013 at 3:43 AM, Michael L. Semon <mlsemon35@gmail.com> w=
rote:
>> On 05/25/2013 12:29 PM, Zhi Yong Wu wrote:
>>>
>>> HI,
>>>
>>> Did anyone hit this issue?
>>>
>>> [root@f15 xfsprogs]# make
>>> Building include
>>> Building libxfs
>>>      [TEST]    CRC32
>>> In file included from ../include/libxfs.h:584:0,
>>>                   from crc32.c:36:
>>> ../include/xfs/xfs_ialloc.h:75:2: error: unknown type name =91umode_t=
=92
>>> gmake[2]: *** [crc32selftest] Error 1
>>> gmake[1]: *** [libxfs] Error 2
>>> make: *** [default] Error 2
>>>
>>>
>>> --
>>> Regards,
>>>
>>> Zhi Yong Wu
>>
>>
>> Yes.  I've been getting around it by inserting the following in one of t=
he
>> two files above, perhaps in xfs_ialloc.h...
>>
>> typedef unsigned short umode_t;
>>
>> It's something in the private kernel headers that doesn't get exported to
>> the public headers by `make headers_install` from the kernel build...at
>> least not for the 3.9 kernel series and later, maybe 3.8 as well.  Howev=
er,
>> I've been told that umode_t is in the Debian 2.6 kernel headers.  The ma=
in
>> questions here are 1) when did umode_t go away? and 2) what is the proper
>> solution?  I use slackware-current, which is unaltered in many places wh=
ere
>> other distros would add extra tweaks, so it may not be a good reference
>> distribution in this case.
>>
>> If you mention your distribution and have an idea of which kernel version
>> made the headers in /usr/include/linux, it might help the pros here come=
 up
>> with a solutio...or at least tell the people in charge of the public hea=
ders
>> that they might export umode_t.
>>
>> Thanks!
>>
>> Michael
>
>
>
> --
> Regards,
>
> Zhi Yong Wu



-- =

Regards,

Zhi Yong Wu

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

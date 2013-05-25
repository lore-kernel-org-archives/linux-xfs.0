Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id BBA8D7F37
	for <xfs@oss.sgi.com>; Sat, 25 May 2013 17:46:34 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 4C642AC002
	for <xfs@oss.sgi.com>; Sat, 25 May 2013 15:46:31 -0700 (PDT)
Received: from mail-qa0-f52.google.com (mail-qa0-f52.google.com
	[209.85.216.52]) by cuda.sgi.com with ESMTP id VCPFFPvyNihY4DEC
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Sat, 25 May 2013 15:46:30 -0700 (PDT)
Received: by mail-qa0-f52.google.com with SMTP id bv4so471825qab.4
	for <xfs@oss.sgi.com>; Sat, 25 May 2013 15:46:29 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <51A1280D.701@sandeen.net>
References: <CAEH94LjnVn-uD6cfwOcChC4wq1PppcD8BN30F93SD=YjdTbbuw@mail.gmail.com>
	<51A1280D.701@sandeen.net>
Date: Sun, 26 May 2013 06:46:29 +0800
Message-ID: <CAEH94LiXSSDG8aMjBhVjcApAMewz4X3zX=48tz+xTxepF8HbGQ@mail.gmail.com>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com

HI,

xfsprogs should be latest, Last year i tried it, and it worked well,
and today pull the latest one and want to replay with it, but fail.
below are the logs on two different boxes:

[root@f15 xfsprogs]# git describe
v3.1.11-8-g8e78288
[root@f15 xfsprogs]# uname -r
3.6.6-rc1+

Also i also tried this on another box:
[root@f17 xfsprogs]# git describe
v3.1.11-8-g8e78288
[root@f17 xfsprogs]# uname -r
3.9.0-rc1+


On Sun, May 26, 2013 at 5:07 AM, Eric Sandeen <sandeen@sandeen.net> wrote:
> On 5/25/13 11:29 AM, Zhi Yong Wu wrote:
>> HI,
>>
>> Did anyone hit this issue?
>>
>> [root@f15 xfsprogs]# make
>> Building include
>> Building libxfs
>>     [TEST]    CRC32
>> In file included from ../include/libxfs.h:584:0,
>>                  from crc32.c:36:
>> ../include/xfs/xfs_ialloc.h:75:2: error: unknown type name =91umode_t=92
>> gmake[2]: *** [crc32selftest] Error 1
>> gmake[1]: *** [libxfs] Error 2
>> make: *** [default] Error 2
>
> For starters, which version of xfsprogs?  And what version of kernel head=
ers?
>
> -Eric
>



-- =

Regards,

Zhi Yong Wu

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

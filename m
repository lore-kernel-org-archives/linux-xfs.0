Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id A63CC7F3F
	for <xfs@oss.sgi.com>; Mon,  7 Jul 2014 03:06:13 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 6DAA38F8033
	for <xfs@oss.sgi.com>; Mon,  7 Jul 2014 01:06:09 -0700 (PDT)
Received: from mail-qg0-f51.google.com (mail-qg0-f51.google.com
	[209.85.192.51]) by cuda.sgi.com with ESMTP id C52hyca0e2OjGfmf
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 07 Jul 2014 01:06:07 -0700 (PDT)
Received: by mail-qg0-f51.google.com with SMTP id z60so3314863qgd.38
	for <xfs@oss.sgi.com>; Mon, 07 Jul 2014 01:06:06 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20140706235701.GQ9508@dastard>
References: <CAA85NCjXU7rK8C4AcQ4Tnxowx5MFBUyAoLW_nuwmKyOFL-_PgQ@mail.gmail.com>
	<20140706235701.GQ9508@dastard>
Date: Mon, 7 Jul 2014 09:59:53 +0200
Message-ID: <CAA85NChTveO_GSJAK9veDH65d0hLhPpxkKhsxKmgBj=AA3mspQ@mail.gmail.com>
Subject: Re: Data loss XFS with RT kernel on Debian.
From: Jan de Kruyf <jan.de.kruyf@gmail.com>
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
To: xfs@oss.sgi.com

I tend to agree with Dave that is is an RT problem, however just for your info:

Kernel 3.2 (the stock Debian kernel) works in both versions, the plain
vanilla and the RT.
On Debugging this prob: will it be helpful for any of the parties
involved if I rig up a serial link and try to get a stacktrace of all
processes with SysRq ? Does that also give kernel processes? Cause Top
tells me nothing.
( I am a bit fresh to this but willing to try)

Cheers

j.


On Mon, Jul 7, 2014 at 1:57 AM, Dave Chinner <david@fromorbit.com> wrote:
> On Sat, Jul 05, 2014 at 02:41:06PM +0200, Jan de Kruyf wrote:
>> Hallo,
>>
>> While doing a reasonably high density job like rsynching a subdirectory
>> from one place to another, or tarring it to a pipe and untarring it at the
>> other end, I note that the cpu usage goes practically to 100% and when I
>> after 5 minutes or so I reset the computer the writing has not finished at
>> all.
>> However on the stock Debian kernel it works without a problem.
>
> Which says that it's a RT kernel problem, not an XFS issue. There
> have been other recent reports of issues with RT kernels, and they
> have proven to be core RT kernel bugs, not filesystem issues. I'd
> suggest that you are likely to be seeing the same RT issues....
>
> Cheers,
>
> Dave.
> --
> Dave Chinner
> david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 24 Jul 2007 16:43:04 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l6ONgvbm002329
	for <linux-xfs@oss.sgi.com>; Tue, 24 Jul 2007 16:43:00 -0700
Message-ID: <46A68F01.5090707@sgi.com>
Date: Wed, 25 Jul 2007 09:45:05 +1000
From: Vlad Apostolov <vapo@sgi.com>
MIME-Version: 1.0
Subject: Re: XFS capacity leak with dmapi
References: <b062d32b0707111442r5050ce96w6ce75df451741f0@mail.gmail.com>	 <469569CC.1010904@sgi.com> <b062d32b0707111643n940b3abp4ff3d57fa3499f72@mail.gmail.com>
In-Reply-To: <b062d32b0707111643n940b3abp4ff3d57fa3499f72@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: linux-xfs@oss.sgi.com
Cc: John Groves <John@Groves.net>

Hi John,

I finally found time to look at this issue. I couldn't see
an obvious reason for it by code inspection and next I tried to
reproduce the problem. I ran this script for a night:

emu:/mnt/scratch1/test # cat ./test_invis_wr
#! /bin/sh

for i in `seq 1 $1`;
do
        echo loop $i
        stat -f /mnt/scratch1
        for file in `seq 1 $2`;
        do
                xfs_io -f -c "truncate 10485760" $file
                ./write_invis -l 10485760 $file
        done
        for file in `seq 1 $2`;
        do
                rm $file
        done
        stat -f /mnt/scratch1
done

and I couldn't reproduce the problem. I am runing 2.6.22 kernel with
the latest XFS/DMAPI. The write_invis utility is from the oss xfs_cmds
source tree here:
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfstests/dmapi/src/common/cmd/write_invis.c?rev=1.11

Could you please provide more details about your test configuration
and a script that reproduces the problem.

Regards,
Vlad

John Groves wrote:
> Thanks Vlad!  I'll watch the list for info...and bug you after a 
> polite interval if nothing becomes apparent.
>
> Cheers,
> John
>
> ---------- Forwarded message ----------
> From: * Vlad Apostolov* <vapo@sgi.com <mailto:vapo@sgi.com>>
> Date: Jul 11, 2007 6:37 PM
> Subject: Re: XFS capacity leak with dmapi
> To: John Groves <John@groves.net <mailto:John@groves.net> >
> Cc: linux-xfs@oss.sgi.com <mailto:linux-xfs@oss.sgi.com>
>
> John Groves wrote:
> > Vlad, I've tried to send this via linux-xfs, but for some reason my
> > posts aren't going through (although I receive messages from it every
> > day).  Any ideas on this?
> >
> > We have an application that uses DMAPI, and we've been chasing an XFS
> > filesystem capacity leak for a week or two.  Here is the scenario:
> >
> > In some cases we initially create sparse files - normal open with
> > O_CREAT and than an ftruncate to the desired size.
> >
> > If we subsequently fill the files via dm_write_invis(), and then
> > remove/unlink the files, XFS does not appear to free up the capacity
> > that was allocated when the file was made non-sparse via
> > dm_write_invis().  Repeating this sequence enough times results in a
> > full filesystem.
> >
> > If we use write() to fill the file (after creating it as sparse),
> > remove/unlink appears to work properly, and capacity does not appear
> > to be leaked.  We've seen this on several test systems; the current
> > one is 2.6.22-rc4, which I think is current as to the SGI cvs tree (or
> > very nearly so).
> >
> > Can anybody shed light on this?
> >
> > Thanks,
> > John Groves
> Hi John,
>
> I will investigate this problem but at the moment I can't immediately jump
> on it. I am copying the email to linux-xfs list in case if someone could
> answer it straightaway.
>
> Regards,
> Vlad
>

Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 07 Dec 2006 19:00:34 -0800 (PST)
Received: from evaldomino.Falconstor.com (mail1.falconstor.com [216.223.47.230])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id kB830OaG009515
	for <xfs@oss.sgi.com>; Thu, 7 Dec 2006 19:00:26 -0800
Message-ID: <4578D4DE.1090400@falconstor.com>
Date: Thu, 07 Dec 2006 21:58:38 -0500
From: "Geir A. Myrestrand" <geir.myrestrand@falconstor.com>
Reply-To: geir.myrestrand@falconstor.com
MIME-Version: 1.0
Subject: Re: New CentOS4/RHEL4-compatible xfs module rpms
References: <4560AB84.9060200@sandeen.net> <45784E71.4080605@falconstor.com> <457854CB.5030507@sandeen.net> <45785ABC.20208@falconstor.com> <20061207232641.GP33919298@melbourne.sgi.com>
In-Reply-To: <20061207232641.GP33919298@melbourne.sgi.com>
Content-Type: multipart/mixed;
 boundary="------------060405040607010202040606"
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

This is a multi-part message in MIME format.
--------------060405040607010202040606
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1; format=flowed

David Chinner wrote:
> On Thu, Dec 07, 2006 at 01:17:32PM -0500, Geir A. Myrestrand wrote:
>>> Geir A. Myrestrand wrote:
>>>
>>>> However, I run into issues with xfs_freeze as it often locks up when I 
>>>> try to freeze a file system where there is I/O activity. Sometimes it 
>>>> happen on the first xfs_freeze invocation to freeze the file system, 
>>>> other times I have to unfreeze and then it happens on the second time I 
>>>> freeze. xfs_freeze never returns when this happens.
>>>>
>>>> Looks like xfs_io get stuck --see partial output from `ps auxf`:
>>>>
>>>> strace -ff -o freeze.txt xfs_freeze -f /mnt/xfs
>>>>  \_ /bin/sh -f /usr/sbin/xfs_freeze -f /mnt/xfs
>>>>      \_ /usr/sbin/xfs_io -r -p xfs_freeze -x -c freeze /mnt/xfs
>>>>
>>>> Anyone else encountering this issue?
> 
> Yes, and I fixed it about a 2 weeks ago. It's an ABBA deadlock between
> lookup of multiple, already dirty, metadata buffers and synchronous buftarg
> flushing (that occurs when trying to freeze a filesystem)
> 
> <sigh>

That is awesome news, mate!  :-)

> The problem is that during a freeze, the filesystem may
> still be doing stuff - like flushing delalloc data buffers -
> in the background and hence we can be trying to lock buffers
> that were on the delwri list at the same time.  Hence we can
> get ABBA deadlocks between threads doing allocation and the
> buftarg flush (freeze) thread.

That sounds like an accurate description of my test environment. I bet 
this is the issue...

> Fix it by skipping locked (and pinned) buffers as we traverse the
> delwri buffer list.

Good to know that you're one step ahead!

> And the diff was:
> 
> http://oss.sgi.com/cgi-bin/cvsweb.cgi/linux-2.6-xfs/fs/xfs/linux-2.6/xfs_buf.c.diff?r1=1.229;r2=1.230

Excellent. I will try this tomorrow (it's late in the evening here in 
New York now). I'll let you know how it works out.

Thanks!


-- 

Geir A. Myrestrand

--------------060405040607010202040606
Content-Transfer-Encoding: 7bit
Content-Type: text/x-vcard; charset=utf-8;
 name="geir.myrestrand.vcf"
Content-Disposition: attachment;
 filename="geir.myrestrand.vcf"

begin:vcard
fn:Geir A. Myrestrand
n:Myrestrand;Geir A.
org:FalconStor Software, Inc.
adr:Suite 2S01;;2 Huntington Quadrangle;Melville;NY;11747;U.S.A.
email;internet:geir.myrestrand@falconstor.com
title:Senior Software Engineer
tel;work:(631) 773-5842
tel;cell:(631) 747-5049
note;quoted-printable:Skype: gmyrestrand=0D=0A=
	MSN Messenger: gmyrestrand@hotmail.com=0D=0A=
	
x-mozilla-html:FALSE
url:http://www.falconstor.com
version:2.1
end:vcard


--------------060405040607010202040606--

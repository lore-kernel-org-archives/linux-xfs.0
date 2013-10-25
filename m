Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 309997F3F
	for <xfs@oss.sgi.com>; Fri, 25 Oct 2013 09:57:57 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 0C385304048
	for <xfs@oss.sgi.com>; Fri, 25 Oct 2013 07:57:56 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id TFYpM9Q1deRI3wSt for <xfs@oss.sgi.com>;
	Fri, 25 Oct 2013 07:57:56 -0700 (PDT)
Message-ID: <526A86F2.9070400@sandeen.net>
Date: Fri, 25 Oct 2013 09:57:54 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: Questions about XFS
References: <CAD+1EGPG1G9Q8kwaSUjxVjvx73UByLb3G0rmUbgJr+zD-CnjEw@mail.gmail.com>
	<20131025164255.46d2829c@harpe.intellique.com>
In-Reply-To: <20131025164255.46d2829c@harpe.intellique.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Emmanuel Florac <eflorac@intellique.com>, harryxiyou <harryxiyou@gmail.com>
Cc: xfs@oss.sgi.com

On 10/25/13 9:42 AM, Emmanuel Florac wrote:
> Le Fri, 25 Oct 2013 22:28:10 +0800
> harryxiyou <harryxiyou@gmail.com> =E9crivait:
> =

>> 1, How to install XFS on Linux OS, I should do like below, right?
>>    a, Download latest Linux Kernel Source Codes.
>>    b, Compile the Linux Kernel and select XFS feature when I do the
>> configuration (make menuconfig).
> =

> No, XFS is supported by all Linux distributions out of the box. To use
> XFS, you may eventually need to install the xfs-progs package.
> =

>  =

>> 2, Does XFS support real-time feature after I install it on Linux
>> Kernel? And how to use real-time feature on Linux Kernel.
>>
> =

> Yes. What do you want to do with realtime XFS?
> =


well, yes and no.  It supports the "realtime subvolume" which is
not really technically "realtime."  It does have a more deterministic
allocator, but it doesn't have GRIO (Guaranteed Realtime I/O) like =

IRIX does.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

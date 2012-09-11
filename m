Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q8BGaZDi121554 for <xfs@oss.sgi.com>; Tue, 11 Sep 2012 11:36:35 -0500
Received: from mail-oa0-f53.google.com (mail-oa0-f53.google.com
	[209.85.219.53]) by cuda.sgi.com with ESMTP id soC9LdHlgB4FNXC1
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 11 Sep 2012 09:37:39 -0700 (PDT)
Received: by oagi18 with SMTP id i18so434137oag.26
	for <xfs@oss.sgi.com>; Tue, 11 Sep 2012 09:37:38 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20120726083242.GA2877@dastard>
References: <20120717052621.GB23387@dastard>
	<50061CEA.4070609@hardwarefreak.com>
	<CAAxjCEwgDKLF=RY0aCCNTMsc1oefXWfyHKh+morYB9zVUrnH-A@mail.gmail.com>
	<50066115.7070807@hardwarefreak.com>
	<CAAxjCExFUJOKaD-LMPfZvCrS34V1VHgtrhgvPP0jZ3Hm1YV=6g@mail.gmail.com>
	<50068EC5.5020704@hardwarefreak.com>
	<CAAxjCEy2Yj=XWctNg2gACbFy81aTu70YJ13Ee8G6-E3Tqvvs7g@mail.gmail.com>
	<CAAxjCEzF3nTFoedyKf1o5Nv4yPUJkgvC8nCJcx_2dDx8xqWtWA@mail.gmail.com>
	<50077A34.5070304@hardwarefreak.com>
	<CAAxjCEy=N9ceAA5V6bnrcMc3961gs-Z2NgNyenPJ+gjE2mYUXQ@mail.gmail.com>
	<20120726083242.GA2877@dastard>
Date: Tue, 11 Sep 2012 18:37:38 +0200
Message-ID: <CAAxjCEy7_1b1vqiC-Ru9JmUawv1TK9JkVLjwJeR6f1js+j60kQ@mail.gmail.com>
Subject: Re: A little RAID experiment
From: Stefan Ring <stefanrin@gmail.com>
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
To: Linux fs XFS <xfs@oss.sgi.com>

On Thu, Jul 26, 2012, Dave Chinner <david@fromorbit.com> wrote:
>> 10001
>> 20001
>> 30001
>> 40001
>> 10002
>> 20002
>> 30002
>> 40002
>> 10003
>> 20003
>> ...
>
> That's the problem you should have reported.

I did, but then I got bashed for using RAID 5/6 and about the
specifics of hardware and everything, which shouldn't even matter, but
I let myself get dragged into this discussion.

Anyway, in the meantime I had a closer look at the actual block trace,
and it looks a bit different than the way I interpreted it at first.
It sends runs of 30-50 writes with holes in them, like so:

2, 4-5, 7, 10-12, 14, 16-17

and so on. These holes seem to be caused by the free space
fragmentation. Every once in a while -- somewhat frequently, after 30
or so blocks, as mentioned -- it switches to another allocation group.
If these blocks were contiguous, then the elevator should be able to
merge them, but the tiny holes make this impossible. So I guess
there's nothing that can be substantially improved here. The frequent
ag switches are a bit difficult for the controller to handle, but
different controllers struggle under different work loads, and there's
nothing that can be done about that. I noticed just today that the HP
SmartArray controllers handle truly random writes better than the
MegaRAID variety that I praised so much in my postings.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

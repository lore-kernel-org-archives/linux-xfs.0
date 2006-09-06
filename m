Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 05 Sep 2006 20:00:41 -0700 (PDT)
Received: from wx-out-0506.google.com (wx-out-0506.google.com [66.249.82.231])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k862unDW030410
	for <linux-xfs@oss.sgi.com>; Tue, 5 Sep 2006 20:00:31 -0700
Received: by wx-out-0506.google.com with SMTP id h29so2401279wxd
        for <linux-xfs@oss.sgi.com>; Tue, 05 Sep 2006 19:56:10 -0700 (PDT)
Message-ID: <2260b150609051853w1286eda7ve59a5df2c7e0ae1c@mail.gmail.com>
Date: Wed, 6 Sep 2006 11:53:10 +1000
From: "Chris Seufert" <seufert@gmail.com>
Subject: Re: XFS Journal on md device
In-Reply-To: <44FE28A8.5000803@oss.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <2260b150609051640y288629cbtcbc133d05b2b40dd@mail.gmail.com>
	 <44FE28A8.5000803@oss.sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: "linux-xfs@oss.sgi.com" <linux-xfs@oss.sgi.com>

unable to stop /dev/md3, right before it does the powering off
/dev/sda /dev/sdb etc...

I believe its from the init scripts for md. Its only there for a sec,
so im not completely sure of the message.

However on reboot xfs does a journal rebuild/repair. and the md does a
re-sync of the md device.

On 9/6/06, linux-xfs@oss.sgi.com <linux-xfs@oss.sgi.com> wrote:
> Chris Seufert wrote:
> > Hey,
> >
> > I currently have a 2.1Tb xfs partition, sitting on a hardware SATA raid
> > card.
> >
> > However i also have 2 hdd's (for OS etc) in software raid1, with a md
> > device for the xfs log file. Its a 100mb RAID1 (under /dev/md4), now
> > when i halt/reboot the box, even after the xfs partition is unmounted
> > (as part of the shutdown sequence as normal on debian etch) the
> > /dev/md4 device cant be cleanly stopped.
>
> What sorts of related error messages do you get on shutdown?  (both from the
> initscripts & the kernel?)
>
> -Eric
>

Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id BC8227F37
	for <xfs@oss.sgi.com>; Tue, 26 Feb 2013 17:25:18 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 24DF8AC00B
	for <xfs@oss.sgi.com>; Tue, 26 Feb 2013 15:25:18 -0800 (PST)
Received: from mail-wi0-f177.google.com (mail-wi0-f177.google.com
	[209.85.212.177]) by cuda.sgi.com with ESMTP id
	4CIhWelYnaMFlpAm (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Tue, 26 Feb 2013 15:25:16 -0800 (PST)
Received: by mail-wi0-f177.google.com with SMTP id hm14so5343649wib.4
	for <xfs@oss.sgi.com>; Tue, 26 Feb 2013 15:25:15 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <512D3856.5050305@sandeen.net>
References: <CA+AKrqBQ=VG0oVsai+agywDKRgO9cG9AvT6mCTSZxKO3Si5Aiw@mail.gmail.com>
	<512D3856.5050305@sandeen.net>
Date: Tue, 26 Feb 2013 17:25:15 -0600
Message-ID: <CA+AKrqC+6nXuCxdY08MBLsjv1fOPJ6=1ruTHsfGqxosQmCi_jQ@mail.gmail.com>
Subject: Re: Read corruption on ARM
From: Jason Detring <detringj@gmail.com>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com

On 2/26/13, Eric Sandeen <sandeen@sandeen.net> wrote:
> On 2/26/13 3:58 PM, Jason Detring wrote:
>> Here's the kicker:  All this seems to happen only if xfs.ko is
>> crosscompiled with GCC 4.6 or 4.7.
>
> urk!  That is a kicker.
>
>> A module (just the module, the rest of kernel can be built with
>> anything) compiled with
>> cross-GCC 4.4.1, 4.5.4, or curiously 4.8 (20130224) has no issue at all.
>> I've kept an old 2009 Sourcery G++ (4.4.1) Lite toolchain around just
>> for building kernels.
>> I'd really like to retire it, but I'm a little afraid this is going to
>> recur in newer compilers.
>
> Maybe you can provide an xfs.ko built with each (for the same kernel)
> with debug info, and we can compare the disassembly?

OK, will do this evening when I can get things cleaned up a bit.


> Enabling the trace_xfs_da_btree_corrupt tracepoint might yield more
> info, can you do that?
>
> I think it's:
>
> # trace-cmd -e xfs_da_btree_corrupt &
> # <do your dir read>
> # fg
> # ^C (ctrl-c trace-cmd)
> # trace-cmd report
>
> We might get more info about the buffer in question that way.

I'll give it a go, but it might take me a while to get back to you.
I'm not familiar with that tool, and it looks like it's not part of my
base install.

> -Eric

Jason

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

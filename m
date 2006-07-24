Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 24 Jul 2006 03:23:34 -0700 (PDT)
Received: from nf-out-0910.google.com (nf-out-0910.google.com [64.233.182.187])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k6OANLDW002156
	for <xfs@oss.sgi.com>; Mon, 24 Jul 2006 03:23:22 -0700
Received: by nf-out-0910.google.com with SMTP id a27so1474121nfc
        for <xfs@oss.sgi.com>; Mon, 24 Jul 2006 03:22:55 -0700 (PDT)
Message-ID: <68559cef0607240322x6be3a38fp8bd03b20caf2a06a@mail.gmail.com>
Date: Mon, 24 Jul 2006 12:22:55 +0200
From: "Luca Maranzano" <liuk001@gmail.com>
Subject: Re: Page allocation failure writing to an XFS volume via NFS on CentOS 4.3
In-Reply-To: <20060721161326.GE12347@tuatara.stupidest.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <68559cef0607210519q9f382c6n7104bef9cf9716f3@mail.gmail.com>
	 <20060721161326.GE12347@tuatara.stupidest.org>
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Hi Crhis,

thank you for your reply.

I've verified and it seems that nothing should be so piggy to make the
server out of memory.
The server is essentially an NFS Server and there are no memory hog
running besides standard services.
/proc/meminfo:
MemTotal:      1035832 kB
MemFree:         12568 kB
Buffers:         10468 kB
Cached:         968336 kB
SwapCached:       4716 kB
Active:          19064 kB
Inactive:       967740 kB
HighTotal:      131048 kB
HighFree:          952 kB
LowTotal:       904784 kB
LowFree:         11616 kB
SwapTotal:     1052248 kB
SwapFree:      1041744 kB
Dirty:               0 kB
Writeback:           0 kB
Mapped:          13588 kB
Slab:            25124 kB
Committed_AS:    52516 kB
PageTables:        832 kB
VmallocTotal:   106488 kB
VmallocUsed:      5528 kB
VmallocChunk:    94392 kB
HugePages_Total:     0
HugePages_Free:      0
Hugepagesize:     4096 kB

It seems that there is always a big memory "cached" ( > 900 MB) which
could be reclaimed by the kernel as needed, so I'd exclude the memory
exhaustion issue.

Besides in the last 2 days during the backups via NFS of some machines
we have more than 600 messages lines like this from the Kernel:
XFS: possible memory allocation deadlock in kmem_alloc (mode:0x2d0)

Doing some search I've found Bug 410
(http://oss.sgi.com/bugzilla/show_bug.cgi?id=410) but it seems to
affect only 64bit kernel and 2.6.11, while I've a 32 bit Xeon 2.8 Ghz
with kernel 2.6.9.

The 1GB of DRAM is adequate to my setup in your opinion?

TIA.
Regards,
Luca


On 7/21/06, Chris Wedgwood <cw@f00f.org> wrote:
> On Fri, Jul 21, 2006 at 02:19:34PM +0200, Luca Maranzano wrote:
>
> > kswapd0: page allocation failure. order:0, mode:0xd0
>
> you're out of memory, see what's being so piggy
>

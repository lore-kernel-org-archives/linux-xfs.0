Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 02 Jul 2007 03:58:12 -0700 (PDT)
Received: from wa-out-1112.google.com (wa-out-1112.google.com [209.85.146.182])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l62Aw6tL011017
	for <xfs@oss.sgi.com>; Mon, 2 Jul 2007 03:58:08 -0700
Received: by wa-out-1112.google.com with SMTP id k22so2278439waf
        for <xfs@oss.sgi.com>; Mon, 02 Jul 2007 03:58:08 -0700 (PDT)
Message-ID: <4688D9F2.6020000@gmail.com>
Date: Mon, 02 Jul 2007 19:56:50 +0900
From: Tejun Heo <htejun@gmail.com>
MIME-Version: 1.0
Subject: Re: [linux-lvm] 2.6.22-rc5 XFS fails after hibernate/resume
References: <46744065.6060605@dgreaves.com> <4674645F.5000906@gmail.com> <46751D37.5020608@dgreaves.com> <4676390E.6010202@dgreaves.com> <20070618145007.GE85884050@sgi.com> <4676D97E.4000403@dgreaves.com> <4677A0C7.4000306@dgreaves.com> <4677A596.7090404@gmail.com> <4677E496.3080506@dgreaves.com> <4678DF56.1020903@gmail.com> <467ABE25.7060303@dgreaves.com> <4684C0DD.4080702@dgreaves.com>
In-Reply-To: <4684C0DD.4080702@dgreaves.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Greaves <david@dgreaves.com>
Cc: David Chinner <dgc@sgi.com>, David Robinson <zxvdr.au@gmail.com>, LVM general discussion and development <linux-lvm@redhat.com>, "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com, linux-pm <linux-pm@lists.osdl.org>, LinuxRaid <linux-raid@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>

David Greaves wrote:
>> Tejun Heo wrote:
>>> It's really weird tho.  The PHY RDY status changed events are coming
>>> from the device which is NOT used while resuming
> 
> There is an obvious problem there though Tejun (the errors even when sda
> isn't involved in the OS boot) - can I start another thread about that
> issue/bug later? I need to reshuffle partitions so I'd rather get the
> hibernate working first and then go back to it if that's OK?

Yeah, sure.  The problem is that we don't know whether or how those two
are related.  It would be great if there's a way to verify memory image
read from hibernation is intact.  Rafael, any ideas?

Thanks.

-- 
tejun

Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 17 Feb 2008 10:29:55 -0800 (PST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m1HITiab012615
	for <xfs@oss.sgi.com>; Sun, 17 Feb 2008 10:29:47 -0800
Received: from fg-out-1718.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9BC67E45101
	for <xfs@oss.sgi.com>; Sun, 17 Feb 2008 10:30:09 -0800 (PST)
Received: from fg-out-1718.google.com (fg-out-1718.google.com [72.14.220.153]) by cuda.sgi.com with ESMTP id XEppljF61khwuGuj for <xfs@oss.sgi.com>; Sun, 17 Feb 2008 10:30:09 -0800 (PST)
Received: by fg-out-1718.google.com with SMTP id e12so1090586fga.8
        for <xfs@oss.sgi.com>; Sun, 17 Feb 2008 10:30:08 -0800 (PST)
Message-ID: <47B863A9.5070206@gmail.com>
Date: Sun, 17 Feb 2008 18:41:13 +0200
From: =?ISO-8859-1?Q?T=F6r=F6k_Edwin?= <edwintorok@gmail.com>
MIME-Version: 1.0
Subject: xfsaild causing 30+ wakeups/s on an idle system since 2.6.25-rcX
Content-Type: multipart/mixed;
 boundary="------------030908040306020509010605"
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, Arjan van de Ven <arjan@linux.intel.com>

This is a multi-part message in MIME format.
--------------030908040306020509010605
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Hi,

xfsaild is causing many wakeups, a quick investigation shows
xfsaild_push is always
returning 30 msecs timeout value.

This is on an idle system, running only gnome, and gnome-terminal.

I suggest changing the timeout logic in xfsaild to be more power
consumption friendly.

See below my original report to the powerTOP mailing list.

Best regards,
--Edwin

--------------030908040306020509010605
Content-Type: message/rfc822;
 name="Re: new offender in 2.6.25-git: xfsaild.eml"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline;
 filename="Re: new offender in 2.6.25-git: xfsaild.eml"

Delivered-To: edwintorok@gmail.com
Received: by 10.143.122.5 with SMTP id z5cs139388wfm;
        Sun, 17 Feb 2008 08:09:47 -0800 (PST)
Received: by 10.140.82.38 with SMTP id f38mr3238281rvb.30.1203264587861;
        Sun, 17 Feb 2008 08:09:47 -0800 (PST)
Return-Path: <arjan@linux.intel.com>
Received: from orsmga101.jf.intel.com (mga06.intel.com [134.134.136.21])
        by mx.google.com with ESMTP id f28si7517524rvb.35.2008.02.17.08.09.47;
        Sun, 17 Feb 2008 08:09:47 -0800 (PST)
Received-SPF: pass (google.com: domain of arjan@linux.intel.com designates 134.134.136.21 as permitted sender) client-ip=134.134.136.21;
Authentication-Results: mx.google.com; spf=pass (google.com: domain of arjan@linux.intel.com designates 134.134.136.21 as permitted sender) smtp.mail=arjan@linux.intel.com
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga101.jf.intel.com with ESMTP; 17 Feb 2008 08:09:47 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,366,1199692800";
   d="scan'208";a="258320829"
Received: from jf-86862470-dhcp-client.jf.intel.com (HELO [134.134.36.112]) ([134.134.36.112])
  by orsmga002.jf.intel.com with ESMTP; 17 Feb 2008 08:09:47 -0800
Message-ID: <47B85C22.3070504@linux.intel.com>
Date: Sun, 17 Feb 2008 08:09:06 -0800
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Thunderbird 1.5.0.14 (Windows/20071210)
MIME-Version: 1.0
To: =?ISO-8859-1?Q?T=F6r=F6k_Edwin?= <edwintorok@gmail.com>
CC: power@bughost.org
Subject: Re: new offender in 2.6.25-git: xfsaild
References: <47B5D405.409@gmail.com> <47B8538F.7060209@gmail.com>
In-Reply-To: <47B8538F.7060209@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit

Török Edwin wrote:
> Török Edwin wrote:
>> Hi,
>>
>> On latest -git of 2.6.25 I am getting lots of wakeups from xfsaild.
>>   23.5% ( 33.3)           xfsaild : schedule_timeout (process_timeout)
>>   
> 
> [Should I Cc: xfs mailing list / lkml on this?]
> 
> The problem seems to be with the timeout logic in xfsaild_push, which
> can return 3 timeout values (msecs): 1000, 10, 20, 30.
> I inserted a marker and attached a probe function, schedule_timeout
> always got called with 9 jiffies (which is 30 msecs, I have HZ=300).
> 
> Changing xfs_trans_ail.c:270 from "tout += 20" to "tout = 1000", made
> xfsaild only do 1 wakeup/s instead of 33!
> 
> For some reason xfs_aild always thinks it has work (I/O) to do, and
> never chooses the 1000 msec sleep value.
> 

sounds like an XFS bug... worth reporting to the xfs/lkml folks for sure.


--------------030908040306020509010605--

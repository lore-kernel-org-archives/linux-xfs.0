Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 10 May 2007 14:54:32 -0700 (PDT)
Received: from mail.goop.org (gw.goop.org [64.81.55.164])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l4ALsRfB014138
	for <xfs@oss.sgi.com>; Thu, 10 May 2007 14:54:29 -0700
Message-ID: <46439491.9010604@goop.org>
Date: Thu, 10 May 2007 14:54:25 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
MIME-Version: 1.0
Subject: Re: 2.6.21-git10/11: files getting truncated on xfs? or maybe an
 nlink problem?
References: <4642389E.4080804@goop.org> <20070509231643.GM85884050@sgi.com> <4642598E.3000607@goop.org> <20070510000119.GO85884050@sgi.com> <46426194.3040403@goop.org> <46439185.5060207@redhat.com> <464392B4.3070009@goop.org> <464393E1.3050705@redhat.com>
In-Reply-To: <464393E1.3050705@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Chuck Ebbert <cebbert@redhat.com>
Cc: David Chinner <dgc@sgi.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Matt Mackall <mpm@selenic.com>, xfs@oss.sgi.com

Chuck Ebbert wrote:
> Jeremy Fitzhardinge wrote:
>   
>> Chuck Ebbert wrote:
>>     
>>> What CPU architecture is this happening on? Not i686 with PAE by
>>> any chance?
>>>       
>> Yes.  Why?
>>     
>
> I have a bug report where NFS files are corrupted only with PAE clients.
> Corruption is at the end of the (newly untarred) files. Doesn't happen
> without PAE.
>   

Hm, suggestive, but I'm not convinced.  Two differences to this situation:

   1. Immediately after the clone ("untar"), the contents are completely
      OK; it's only after a umount/mount cycle to problems appear
   2. There's no corruption as such; the files are just too short.  And
      it seems they're at a previously OK length, not some random size.

    J

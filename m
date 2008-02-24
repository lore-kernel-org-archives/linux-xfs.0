Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 24 Feb 2008 02:06:35 -0800 (PST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m1OA6Txk007251
	for <xfs@oss.sgi.com>; Sun, 24 Feb 2008 02:06:30 -0800
Received: from fg-out-1718.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5BD3860F77C
	for <xfs@oss.sgi.com>; Sun, 24 Feb 2008 02:06:54 -0800 (PST)
Received: from fg-out-1718.google.com (fg-out-1718.google.com [72.14.220.157]) by cuda.sgi.com with ESMTP id jZMB46L8qH4LIaFz for <xfs@oss.sgi.com>; Sun, 24 Feb 2008 02:06:54 -0800 (PST)
Received: by fg-out-1718.google.com with SMTP id e12so790679fga.8
        for <xfs@oss.sgi.com>; Sun, 24 Feb 2008 02:06:53 -0800 (PST)
Message-ID: <47C141B9.7050001@gmail.com>
Date: Sun, 24 Feb 2008 11:06:49 +0100
From: Jiri Slaby <jirislaby@gmail.com>
MIME-Version: 1.0
Subject: Re: getting uninterruptible sleep processes after upgrade from 2.6.20.20
 to 2.6.24.2
References: <47B892B9.7060205@allied-internet.ag>	<alpine.DEB.1.00.0802172133470.6469@sheep.housecafe.de>	<47B89DC6.4070906@allied-internet.ag> <20080217125407.5b76a052@laptopd505.fenrus.org> <47BD5B30.103@allied-internet.ag> <47BD7958.5080203@gmail.com> <47BD7E7F.2030603@allied-internet.ag>
In-Reply-To: <47BD7E7F.2030603@allied-internet.ag>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Stefan Priebe - allied internet ag <s.priebe@allied-internet.ag>
Cc: Arjan van de Ven <arjan@infradead.org>, Christian Kujau <lists@nerdbynature.de>, LKML <linux-kernel@vger.kernel.org>, xfs-masters@oss.sgi.com, xfs@oss.sgi.com, Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org

Ccing xfs team

On 02/21/2008 02:37 PM, Stefan Priebe - allied internet ag wrote:
> Hello!
> 
> I'm using XFS. dmesg -s32000 does not help - no more output. In messages 
> there is also no relevant output. Other than what I've posted here:
> http://lkml.org/lkml/2008/2/21/76

http://lkml.org/lkml/2008/2/21/86

Some kind of borkage in readdir, probably either in xfs or vfs?

> Sorry but i cannot recompile the kernel on all machines again - another 
> downtime is not possible at the moment.
> 
> Stefan
> 
> Jiri Slaby schrieb:
>> Stefan Priebe - allied internet ag napsal(a):
>>> Hello!
>>>
>>> I've done the (echo t > /proc/sysrq-trigger) now but i'm not able to get
>>> the whole output via dmesg.
>>>
>>> Here is what i get:
>>> # dmesg
>>> 3.432124]  [<c0165a11>] do_select+0x390/0x46e
>>> [272363.432226]  [<c0166107>] __pollwait+0x0/0xcf
>>> [272363.432319]  [<c0115d90>] default_wake_function+0x0/0x8
>>
>> dmesg ring buffer is too small to fit this in. Please repeat it once 
>> again
>> with bigger ringbuffer (dmesg -s if you have this chosen in your 
>> kernel) or
>> post /var/log/meassages output of all processes. I see only waiters in
>> readdir, not seeing who could block them.
>>
>> Which filesystem did you run du on?

Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 18 Jul 2006 04:07:34 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id k6IB4vDW002649
	for <linux-xfs@oss.sgi.com>; Tue, 18 Jul 2006 04:07:13 -0700
Message-ID: <44BCC01F.2020802@melbourne.sgi.com>
Date: Tue, 18 Jul 2006 21:03:59 +1000
From: David Chatterton <chatz@melbourne.sgi.com>
Reply-To: chatz@melbourne.sgi.com
MIME-Version: 1.0
Subject: Re: oops with CentOS 4.3 / xfs / nfsd
References: <1153214961.6793.15.camel@x41ade>
In-Reply-To: <1153214961.6793.15.camel@x41ade>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Andrew Elwell <andrewe@epcc.ed.ac.uk>
Cc: linux-xfs@oss.sgi.com, maciej@epcc.ed.ac.uk

Andrew,

I may be completely wrong, but the error message suggests to me that you
are exceeding the 4KB stack.

If you can see an archive of this list, also see Nathan's reply to
"Bad page state in process 'nfsd' with xfs", but i'm not sure which
2.6 kernel he is referring to where our stack usage was reduced.

David


Andrew Elwell wrote:
> Hi Folks,
> 
> We've migrated some of our storage servers to CentOS 4.3 and are seeing
> lockups. It *could* be hardware I know, and I'm scheduling downtime to
> run memtest86+ ASAP.
> 
> Overview:
> 2* LPFC HBA's connecting to our SAN, 
> dm setup for multipath to see 4*1.6TB trays
> each tray as a PV in lvm2 sanvg
> xfs on a 3T lv
> NFS exported out as /export/work 
> 
> using the 2.6.9-34 centosplus SMP kernel (3GHz P4 with hyperthreading
> enabled)
> 
> what we normally (~once a day) is simply
> 
> do_IRQ: stack overflow: 416
>  [<c0107a27>]
> 
> on the console and nothing else. (needs a cold reboot)
> 
> Having installed netdump (nice tool btw) we got a different error
> yesterday that looks xfs / nfsd related...
> 
> (attached)
> 
> any help in progressing this would be much appreciated - 
> 
> Andrew
> 

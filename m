Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 26 Nov 2006 06:32:31 -0800 (PST)
Received: from sandeen.net (sandeen.net [209.173.210.139])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id kAQEWLaG017943
	for <xfs@oss.sgi.com>; Sun, 26 Nov 2006 06:32:22 -0800
Message-ID: <4569A541.3030600@sandeen.net>
Date: Sun, 26 Nov 2006 08:31:29 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: 2.6.19-rc6 : Spontaneous reboots, stack overflows - seems to
 implicate xfs, scsi, networking, SMP
References: <9a8748490611211551v2ebe88fel2bcf25af004c338a@mail.gmail.com>	 <9a8748490611220458w4d94d953v21f7a29a9f1bdb72@mail.gmail.com>	 <20061123011809.GY37654165@melbourne.sgi.com>	 <20061122.201013.112290046.davem@davemloft.net>	 <20061123043543.GI3078@ftp.linux.org.uk> <1164269545.31358.771.camel@laptopd505.fenrus.org>
In-Reply-To: <1164269545.31358.771.camel@laptopd505.fenrus.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Arjan van de Ven <arjan@infradead.org>
Cc: Al Viro <viro@ftp.linux.org.uk>, David Miller <davem@davemloft.net>, dgc@sgi.com, jesper.juhl@gmail.com, chatz@melbourne.sgi.com, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, xfs-masters@oss.sgi.com, netdev@vger.kernel.org, linux-scsi@vger.kernel.org

Arjan van de Ven wrote:
> On Thu, 2006-11-23 at 04:35 +0000, Al Viro wrote:
>>> I would even say 10 function calls deep to allocate file blocks
>>> is overkill, but 22 it just astronomically bad.
>> Especially since a large part is due to cxfs...
>> -
> 
> it's a bit sad to see XFS this crippled in linux due to an external,
> proprietary module ;(
> 

I understand that cxfs is a bit of a whipping-boy, but the stacks in 
question in this thread really don't have much if anything to do with 
the filesystem layering in xfs.  They are deep callchains & large 
functions in core xfs code, it seems.

-Eric

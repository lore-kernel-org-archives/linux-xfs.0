Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 13 Nov 2006 16:29:35 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id kAE0TOaG017321
	for <xfs@oss.sgi.com>; Mon, 13 Nov 2006 16:29:26 -0800
Received: from [134.14.55.100] (cxfsmac10.melbourne.sgi.com [134.14.55.100])
	by snort.melbourne.sgi.com (SGI-8.12.5/8.12.5) with ESMTP id kAE0SU7Y33889313;
	Tue, 14 Nov 2006 11:28:31 +1100 (AEDT)
In-Reply-To: <20061114002536.GA7846@tuatara.stupidest.org>
References: <1163381602.11914.10.camel@localhost.localdomain> <965ECEF2-971D-46A1-B3F2-C6C1860C9ED8@sgi.com> <1163390942.14517.12.camel@localhost.localdomain> <12275452-56ED-4921-899F-EFF1C05B251A@sgi.com> <1163395250.14517.38.camel@localhost.localdomain> <950D2C3E-11AE-4805-9286-65ECD880272D@sgi.com> <20061114002536.GA7846@tuatara.stupidest.org>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <21DB0765-9CB9-4831-A099-A75C49696E28@sgi.com>
Content-Transfer-Encoding: 7bit
From: Sam Vaughan <sjv@sgi.com>
Subject: Re: XFS_IOC_RESVSP64 versus XFS_IOC_ALLOCSP64 with multiple threads
Date: Tue, 14 Nov 2006 11:31:15 +1100
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Chris Wedgwood <cw@f00f.org>
Cc: Stewart Smith <stewart@mysql.com>, xfs@oss.sgi.com

On 14/11/2006, at 11:25 AM, Chris Wedgwood wrote:

> On Tue, Nov 14, 2006 at 11:04:17AM +1100, Sam Vaughan wrote:
>
>> Those extents are curiously uniform, all 32kB in size.
>
> O_SYNC writes?

I'm assuming from Stuart's original email that these files weren't  
written out with write(), but instead pre-allocated using allocsp:

> So, this would lead me to try XFS_IOC_ALLOCSP64 - which doesn't  
> have the
> "unwritten extents" warning that RESVSP64 does. However, with the two
> processes writing the files out, I get heavy fragmentation. Even  
> with a
> RESVSP followed by ALLOCSP I get the same result.

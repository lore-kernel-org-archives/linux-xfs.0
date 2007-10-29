Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 29 Oct 2007 03:43:41 -0700 (PDT)
Received: from postoffice.aconex.com (mail.app.aconex.com [203.89.192.138])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with ESMTP id l9TAhXC6031931
	for <xfs@oss.sgi.com>; Mon, 29 Oct 2007 03:43:37 -0700
Message-ID: <41805.192.168.3.1.1193654641.squirrel@mail.aconex.com>
In-Reply-To: <20071029085502.GI995458@sgi.com>
References: <20071029075657.GA84369978@melbourne.sgi.com>
    <20071029085502.GI995458@sgi.com>
Date: Mon, 29 Oct 2007 21:44:01 +1100 (EST)
Subject: Re: Default mount options (that suck less).
From: nscott@aconex.com
MIME-Version: 1.0
Content-Type: text/plain;charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Niv Sardi <xaiki@sgi.com>, David Chinner <dgc@sgi.com>
Cc: xfs@oss.sgi.com

> On Mon, Oct 29, 2007 at 06:56:57PM +1100, Niv Sardi wrote:
>> Hello,
>>
>> XFS's default mount options are in most cases sub-optimal, we should try
>
> Mkfs options ;)
>
>> to have more sensible defaults, so far I'm following some quick
>> dave-powered
>> recomendations:
>>
>> - version 2 logs
>> - attr2
>> - lazy superblock counters
>> - less allocation groups for single disk configs
>

Version 2 inodes should always be created by default (there are both
userspace and kernel changes required for that).

cheers.

--
Nathan

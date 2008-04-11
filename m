Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 11 Apr 2008 09:13:32 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m3BGDMdK021380
	for <xfs@oss.sgi.com>; Fri, 11 Apr 2008 09:13:23 -0700
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0307D781813
	for <xfs@oss.sgi.com>; Fri, 11 Apr 2008 09:14:01 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com with ESMTP id xNwOxXke3xNBJ0Dc for <xfs@oss.sgi.com>; Fri, 11 Apr 2008 09:14:01 -0700 (PDT)
Message-ID: <47FF8E2A.30900@sandeen.net>
Date: Fri, 11 Apr 2008 11:13:30 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH V2] remove CONFIG_XFS_SECURITY
References: <47819E47.4030906@sandeen.net> <47BB7774.5080401@sandeen.net> <47F985BA.7060100@sgi.com> <47FF781D.2020006@sandeen.net> <20080411160448.GA26929@infradead.org>
In-Reply-To: <20080411160448.GA26929@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: Timothy Shimmin <tes@sgi.com>, xfs-oss <xfs@oss.sgi.com>

Christoph Hellwig wrote:
>> +#define XFS_SECURITY_STRING	"security attributes, "
> 
> This one should just be killed completely, as it's not an optional
> feature anymore.
> 

My only concern is that if people are used to seeing it, they'll assume
that somehow xfs now doesn't support it now, or was built without it, or ...

*shrug*

-Eric

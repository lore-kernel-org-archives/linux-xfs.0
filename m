Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 21 Oct 2008 06:21:10 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9LDL68f021855
	for <xfs@oss.sgi.com>; Tue, 21 Oct 2008 06:21:06 -0700
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2AAEA10C10E0
	for <xfs@oss.sgi.com>; Tue, 21 Oct 2008 06:22:51 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com with ESMTP id An3j2LDe9Gq0sy0D for <xfs@oss.sgi.com>; Tue, 21 Oct 2008 06:22:51 -0700 (PDT)
Message-ID: <48FDD7AA.5050006@sandeen.net>
Date: Tue, 21 Oct 2008 08:22:50 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH 1/2, RFC] convert xfs_getbmap to take formatter	functions
References: <48FD0503.3090203@sandeen.net> <20081021080737.GA4193@infradead.org>
In-Reply-To: <20081021080737.GA4193@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs mailing list <xfs@oss.sgi.com>

Christoph Hellwig wrote:
> On Mon, Oct 20, 2008 at 05:24:03PM -0500, Eric Sandeen wrote:
...

>>  /*
>> - * Fcntl interface to xfs_bmapi.
>> + * ioctl interface to xfs_bmapi.
>>   */
> 
>>  /*
>> - * Fcntl interface to xfs_bmapi.
>> + * ioctl interface to xfs_bmapi.
>>   */
> 
> Well, it will be for fiemap, too.  And the comment doesn't make much
> sense either.  Either remove it completely or replace it by something
> that makes sense.
> 

well aren't XFS_IOC_GETBMAP(X) and fiemap _both_ ioctl interfaces to
xfs_bmapi?

-Eric

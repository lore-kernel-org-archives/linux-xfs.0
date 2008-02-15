Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 15 Feb 2008 08:23:59 -0800 (PST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m1FGNtx4017323
	for <xfs@oss.sgi.com>; Fri, 15 Feb 2008 08:23:56 -0800
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D07E3E28B60
	for <xfs@oss.sgi.com>; Fri, 15 Feb 2008 08:24:19 -0800 (PST)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com with ESMTP id jKf69w4R7docCIsh for <xfs@oss.sgi.com>; Fri, 15 Feb 2008 08:24:19 -0800 (PST)
Message-ID: <47B5BC8F.2090102@sandeen.net>
Date: Fri, 15 Feb 2008 10:23:43 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH 1/1] XFS: replace *_IDELETE with *_IKEEP
References: <47B3B6AE.4030505@sandeen.net> <1202975139-10546-1-git-send-email-jeffpc@josefsipek.net> <20080215161902.GA32398@infradead.org>
In-Reply-To: <20080215161902.GA32398@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: Josef 'Jeff' Sipek <jeffpc@josefsipek.net>, xfs@oss.sgi.com

Christoph Hellwig wrote:
> On Thu, Feb 14, 2008 at 02:45:39AM -0500, Josef 'Jeff' Sipek wrote:
>> Change the *_IDELETE flags to *_IKEEP, and flip the logic as necessary.
>>
>> This completely eliminates the no-no-no-idelete madness.
>>
>> Additionally, "ikeep" or "noikeep" is always displayed in /proc/mounts
>> option string. This should help clear up any confusion about what the
>> current mode is.
> 
> Looks fine to me, and I think the changed display in /proc/<pid>/mounts
> is fine aswell.
> 

IMHO if we want to display defaults, then we should probably change it
so that all defaults are displayed, and not make noikeep special in this
respect.  (oh, and "noquota" is already there, too)

Doesn't matter much to me either way but it should be consistent across
all options, I think.

-Eric

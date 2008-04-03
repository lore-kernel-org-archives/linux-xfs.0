Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 03 Apr 2008 16:26:19 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m33NQA9O021312
	for <xfs@oss.sgi.com>; Thu, 3 Apr 2008 16:26:11 -0700
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 56EB190A5FB
	for <xfs@oss.sgi.com>; Thu,  3 Apr 2008 11:11:44 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com with ESMTP id d5jD2g562W7ZAuU9 for <xfs@oss.sgi.com>; Thu, 03 Apr 2008 11:11:44 -0700 (PDT)
Message-ID: <47F51DDE.8070501@sandeen.net>
Date: Thu, 03 Apr 2008 13:11:42 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH 5/7] XFS: Unicode case-insensitive lookup implementation
References: <20080402062508.017738664@chook.melbourne.sgi.com> <20080402062709.011126702@chook.melbourne.sgi.com> <20080403171450.GB22385@infradead.org> <20080403172400.GC22812@samba1>
In-Reply-To: <20080403172400.GC22812@samba1>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Jeremy Allison <jra@samba.org>
Cc: Christoph Hellwig <hch@infradead.org>, Barry Naujok <bnaujok@sgi.com>, xfs@oss.sgi.com, linux-fsdevel@vger.kernel.org

Jeremy Allison wrote:
> On Thu, Apr 03, 2008 at 01:14:50PM -0400, Christoph Hellwig wrote:
>> Validating file names is not the filesystem job.  In fact it's utterly
>> stupid, a unix filename is a sequence of bytes without special meaning
>> except for ., .., / and \0
> 
> This patch will be extremely useful for users who are serving
> Windows clients using Samba. It allow admins to turn off the
> userspace case insensitivity we have to emulate and be a significant
> speed increase.

I'd like to see the numbers... Simo tested an earlier version of this
patch, and it was not faster.... Jeremy, what would be a representative
test setup to use?

Thanks,
-Eric

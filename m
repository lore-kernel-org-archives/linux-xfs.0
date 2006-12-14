Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 14 Dec 2006 10:20:00 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [66.187.233.31])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id kBEIJqqw018105
	for <xfs@oss.sgi.com>; Thu, 14 Dec 2006 10:19:53 -0800
Message-ID: <4581958F.6070208@sandeen.net>
Date: Thu, 14 Dec 2006 12:18:55 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] use vfs-defined file attribute flags
References: <45819221.70502@sandeen.net> <20061214181500.GA13856@infradead.org>
In-Reply-To: <20061214181500.GA13856@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

Christoph Hellwig wrote:
>> -#define LINUX_XFLAG_SYNC	0x00000008 /* Synchronous updates */
>> -#define LINUX_XFLAG_IMMUTABLE	0x00000010 /* Immutable file */
>> -#define LINUX_XFLAG_APPEND	0x00000020 /* writes to file may only append */
>> -#define LINUX_XFLAG_NODUMP	0x00000040 /* do not dump file */
>> -#define LINUX_XFLAG_NOATIME	0x00000080 /* do not update atime */
>> +#define LINUX_XFLAG_SYNC	FS_SYNC_FL	/* Synchronous updates */
>> +#define LINUX_XFLAG_IMMUTABLE	FS_IMMUTABLE_FL	/* Immutable file */
>> +#define LINUX_XFLAG_APPEND	FS_APPEND_FL	/* writes may only append */
>> +#define LINUX_XFLAG_NODUMP	FS_NODUMP_FL	/* do not dump file */
>> +#define LINUX_XFLAG_NOATIME	FS_NOATIME_FL	/* do not update atime */
> 
> Just kill the defines completly and use the FS_ flags.

that probably would be better, I thought of that after I sent it. :)

*shrug* whichever.  It's heresy to suggest less indirection in xfs ;-)

-Eric

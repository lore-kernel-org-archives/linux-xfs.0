Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 25 Oct 2008 13:28:53 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9PKSlkD031363
	for <xfs@oss.sgi.com>; Sat, 25 Oct 2008 13:28:47 -0700
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A4A85546B6C
	for <xfs@oss.sgi.com>; Sat, 25 Oct 2008 13:28:47 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com with ESMTP id 0XPfjlr1iUyNnMrm for <xfs@oss.sgi.com>; Sat, 25 Oct 2008 13:28:47 -0700 (PDT)
Message-ID: <4903817E.5040006@sandeen.net>
Date: Sat, 25 Oct 2008 15:28:46 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH 1/2 v2] convert xfs_getbmap to take formatter functions
References: <49031E81.7040807@sandeen.net> <49032017.6070408@sandeen.net> <20081025202743.GH28002@infradead.org>
In-Reply-To: <20081025202743.GH28002@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs-oss <xfs@oss.sgi.com>

Christoph Hellwig wrote:
>> +int xfs_getbmapx_format(void __user **ap, struct getbmapx *bmv, int *filled)
>> +{
>> +	*filled = 0;
>> +	if (copy_to_user(*ap, bmv, sizeof(struct getbmapx)))
>> +		return XFS_ERROR(EFAULT);
>> +
>> +	*ap += sizeof(struct getbmapx);
>> +	*filled = 1;
>> +	return 0;
>> +}
>> +
>> +int xfs_getbmap_format(void __user **ap, struct getbmapx *bmv, int *filled)
>> +{
>> +	*filled = 0;
>> +	/* copy only getbmap portion (not getbmapx) */
>> +	if (copy_to_user(*ap, bmv, sizeof(struct getbmap)))
>> +		return XFS_ERROR(EFAULT);
>> +
>> +	*ap += sizeof(struct getbmap);
>> +	*filled = 1;
>> +	return 0;
>> +}
> 
> Probably makes sense to have these two helpers in xfs_ioctl.c, where
> they are used, similar to how fiemap is implemented.
> 

Ok, that makes sense.  Will change that & the other suggestions.

(I did run sparse once, but made changes after that and forgot to re-run...)

-Eric

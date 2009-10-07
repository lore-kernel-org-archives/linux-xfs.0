Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n973sOR5157694 for <xfs@oss.sgi.com>; Tue, 6 Oct 2009 22:54:25 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D1D09121E7ED
	for <xfs@oss.sgi.com>; Tue,  6 Oct 2009 20:55:49 -0700 (PDT)
Received: from mail.sandeen.net (sandeen.net [209.173.210.139]) by
	cuda.sgi.com with ESMTP id 9JAZHsqSbEwNVeWM for
	<xfs@oss.sgi.com>; Tue, 06 Oct 2009 20:55:49 -0700 (PDT)
Message-ID: <4ACC1144.5090504@sandeen.net>
Date: Tue, 06 Oct 2009 22:55:48 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] mkfs: add discard support
References: <1157959921.9631254878431584.JavaMail.root@mail-au.aconex.com>
In-Reply-To: <1157959921.9631254878431584.JavaMail.root@mail-au.aconex.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Nathan Scott <nscott@aconex.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

Nathan Scott wrote:
> ----- "Christoph Hellwig" <hch@infradead.org> wrote:
> 
>>> It might be a bit cleaner to add this in with the existing
>> platform-
>>> specific code in libxfs/linux.c (or perhaps
>> include/platform_defs.h)
>>> with wrappers for the other platforms, rather than putting it
>> directly
>>> in mkfs like this?  repair may want to use this someday too, I
>> guess.
>>
>> How about this one?
>>
> 
> Looks good to me.
> 
> cheers.
> 

looks good to me too, thanks.

need to get that vertex flashed w/ trim support some day...

-eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

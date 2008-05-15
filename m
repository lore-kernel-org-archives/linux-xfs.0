Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 14 May 2008 22:13:24 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m4F5D2Gm013176
	for <xfs@oss.sgi.com>; Wed, 14 May 2008 22:13:05 -0700
Date: Thu, 15 May 2008 15:14:54 +1000
Subject: Re: [PATCH 3/4] XFS: Return case-insensitive match for dentry cache
From: "Barry Naujok" <bnaujok@sgi.com>
Content-Type: text/plain; format=flowed; delsp=yes; charset=utf-8
MIME-Version: 1.0
References: <20080513075749.477238845@chook.melbourne.sgi.com> <20080513080152.911303131@chook.melbourne.sgi.com> <20080513085724.GC21919@infradead.org> <op.ua4wa7t03jf8g2@pc-bnaujok.melbourne.sgi.com> <20080515045700.GA4328@infradead.org>
Message-ID: <op.ua6ji4r93jf8g2@pc-bnaujok.melbourne.sgi.com>
In-Reply-To: <20080515045700.GA4328@infradead.org>
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com, linux-fsdevel@vger.kernel.org, aia21@cantab.net

On Thu, 15 May 2008 14:57:00 +1000, Christoph Hellwig <hch@infradead.org>  
wrote:

> On Wed, May 14, 2008 at 05:55:45PM +1000, Barry Naujok wrote:
>> Not quite sure if this is the right test, but I did 1000 creates on
>> a brand new filesystem with and without ci on my SATA drive, both
>> sustained almost 600 creates per second.
>>
>> I believe creates would be the worst case scenario for not adding
>> negative dentries?
>
> No, negative dentries shouldn't have any effect on that.  negative
> entries help to optimize away lookups.  E.g. thing of the PATH variable
> and say your shell is not in the first directory listed there.  Having
> a negative dentry for it means that you don't have to do a lookup in
> the first directories everytime someone wants to use the shell.

Ah, that makes more sense. I did a test of a million lookups to a
non-existant file in a short-form directory (dual 1.6G opteron):

CI = 4.6s
non-CI = 3.7s

And a directory with 10000 files:

CI = 10.3s
non-CI = 3.9s

Barry.

Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 15 May 2008 17:30:22 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m4G0TxXq026889
	for <xfs@oss.sgi.com>; Thu, 15 May 2008 17:30:01 -0700
Date: Fri, 16 May 2008 10:30:37 +1000
Subject: Re: [PATCH 3/4] XFS: Return case-insensitive match for dentry cache
From: "Barry Naujok" <bnaujok@sgi.com>
Content-Type: text/plain; format=flowed; delsp=yes; charset=utf-8
MIME-Version: 1.0
References: <20080513075749.477238845@chook.melbourne.sgi.com> <20080513080152.911303131@chook.melbourne.sgi.com> <20080513085724.GC21919@infradead.org> <op.ua4wa7t03jf8g2@pc-bnaujok.melbourne.sgi.com> <20080515045700.GA4328@infradead.org> <op.ua6ji4r93jf8g2@pc-bnaujok.melbourne.sgi.com> <DCB15FFF-F942-47BD-B8FB-38AADC24B9D6@cam.ac.uk> <20080515141121.GA14198@infradead.org>
Content-Transfer-Encoding: 7bit
Message-ID: <op.ua701bha3jf8g2@pc-bnaujok.melbourne.sgi.com>
In-Reply-To: <20080515141121.GA14198@infradead.org>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>, Anton Altaparmakov <aia21@cam.ac.uk>
Cc: xfs@oss.sgi.com, linux-fsdevel <linux-fsdevel@vger.kernel.org>

On Fri, 16 May 2008 00:11:21 +1000, Christoph Hellwig <hch@infradead.org>  
wrote:

> On Thu, May 15, 2008 at 02:43:44PM +0100, Anton Altaparmakov wrote:
>> Yes, and you can get the performance back if you allow negative  
>> dentries to
>> be created.  You just have to make sure that every time a directory  
>> entry
>> is created in directory X, all negative dentries which are children of
>> directory X are thrown away.
>
> We might even be able to optimize this a little by calling d_compare on
> each alias to see if it hashes down to the same one down in the fs.

So, I gather from this comment is that the CI FS implementation overrides
d_compare but not d_hash, and the CI purge function will behave differently
if d_compare is overridden or not? If overridden, use it as per your
suggestion and if not (due to oversight or unexpected problems), purge
all negative children?

Barry.

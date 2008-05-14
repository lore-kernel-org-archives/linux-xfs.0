Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 14 May 2008 00:51:11 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m4E7onvB028763
	for <xfs@oss.sgi.com>; Wed, 14 May 2008 00:50:52 -0700
Date: Wed, 14 May 2008 17:55:45 +1000
Subject: Re: [PATCH 3/4] XFS: Return case-insensitive match for dentry cache
From: "Barry Naujok" <bnaujok@sgi.com>
Content-Type: text/plain; format=flowed; delsp=yes; charset=utf-8
MIME-Version: 1.0
References: <20080513075749.477238845@chook.melbourne.sgi.com> <20080513080152.911303131@chook.melbourne.sgi.com> <20080513085724.GC21919@infradead.org>
Content-Transfer-Encoding: 7bit
Message-ID: <op.ua4wa7t03jf8g2@pc-bnaujok.melbourne.sgi.com>
In-Reply-To: <20080513085724.GC21919@infradead.org>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com, linux-fsdevel@vger.kernel.org, aia21@cantab.net

On Tue, 13 May 2008 18:57:24 +1000, Christoph Hellwig <hch@infradead.org>  
wrote:

> First please Cc Anton on this as he wrote the original version of
> what's now d_add_ci, I suspect he might have some useful comments.
>
>
> On Tue, May 13, 2008 at 05:57:52PM +1000, Barry Naujok wrote:
>> Another unusual interaction with the dcache is not storing
>> negative dentries like other filesystems doing a d_add(dentry, NULL)
>> when an ENOENT is returned. During the VFS lookup, if a dentry
>> returned has no inode, dput is called and ENOENT is returned.
>> By not doing a d_add, this actually removes it completely from
>> the dcache to be reused.
>
> That is a way to implement this correctly, but I suspect not creating
> negative dentries will degrade performance quite badly on some
> workloads.  Then again CI is useful only for samba serving where the
> namecache on the client side should mitigate that effect.

Not quite sure if this is the right test, but I did 1000 creates on
a brand new filesystem with and without ci on my SATA drive, both
sustained almost 600 creates per second.

I believe creates would be the worst case scenario for not adding
negative dentries?

> We'd probably be better off long-term implementing Anton's earlier
> suggestion to have a routine that purges all ci aliased negative
> dentries on a successfull lookup.

Barry.

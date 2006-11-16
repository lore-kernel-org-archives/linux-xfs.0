Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 16 Nov 2006 14:04:07 -0800 (PST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id kAGM3xaG019803
	for <xfs@oss.sgi.com>; Thu, 16 Nov 2006 14:04:00 -0800
Message-ID: <455CDBA5.5070809@agami.com>
Date: Thu, 16 Nov 2006 13:44:05 -0800
From: Shailendra Tripathi <stripathi@agami.com>
MIME-Version: 1.0
Subject: Re: [PATCH][RFC][resend] potential NULL pointer deref in XFS on failed
 mount
References: <200611162218.26945.jesper.juhl@gmail.com>	 <455CD6C8.5030907@agami.com> <9a8748490611161343x44e759acs9b70247c84452ba5@mail.gmail.com>
In-Reply-To: <9a8748490611161343x44e759acs9b70247c84452ba5@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Jesper Juhl <jesper.juhl@gmail.com>
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com, xfs-masters@oss.sgi.com, nathans@sgi.com, Andrew Morton <akpm@osdl.org>

Jesper Juhl wrote:

> The reason I want to fix it in the freeing function is that many other
> functions in the kernel that free resources are safe to call with NULL
> pointers and this would make xfs_free_buftarg() follow that
> convention.  This would perhaps also allow for some cleanups in other
> places that call the function since then there's no longer a need for
> explicit NULL checks any more (haven't checked if there's anything to
> gain there though).
> I don't think the function call overhead matters much since this is in
> a case of a failed mount, so it should happen very rarely.
>
I agree with you.  However, cleanup functions should(/must?) check for  
NULL etc and
in this case it is already doing so for other cases. So, perhaps not 
required. Just a different viewpoint.
Your choice.

>> void
>> xfs_unmountfs_close(xfs_mount_t *mp, struct cred *cr)
>> {
>>        if (mp->m_logdev_targp && (mp->m_logdev_targp != 
>> mp->m_ddev_targp))
>>                 xfs_free_buftarg(mp->m_logdev_targp, 1);
>>         if (mp->m_rtdev_targp)
>>                 xfs_free_buftarg(mp->m_rtdev_targp, 1);
>>         xfs_free_buftarg(mp->m_ddev_targp, 0);
>> }
>>
>
>

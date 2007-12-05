Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 04 Dec 2007 18:31:35 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with SMTP id lB52VOVU018143
	for <xfs@oss.sgi.com>; Tue, 4 Dec 2007 18:31:30 -0800
Message-ID: <47560DA4.4090605@sgi.com>
Date: Wed, 05 Dec 2007 13:32:04 +1100
From: Lachlan McIlroy <lachlan@sgi.com>
Reply-To: lachlan@sgi.com
MIME-Version: 1.0
Subject: Re: Fix xfs_ichgtime mainline breakage.
References: <20071203074345.GW119954183@sgi.com>
In-Reply-To: <20071203074345.GW119954183@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

Looks good Dave.  Thanks for catching that.

David Chinner wrote:
> Folks,
> 
> Just noticed with the mainline merge (2.6.24-rc3) to xfs-dev that
> xfs_ichgtime + xfs_ichgtime_fast are broken.
> 
>         if (!(inode->i_state & I_SYNC))
> 		mark_inode_dirty_sync(inode);
> 
> that check used to be against I_LOCK, which was arguably broken,
> but this one will mean newly created files are not put on the dirty
> list and hence not written back by pdflush.
> 
> Patch to fix this attached.
> 
> Cheers,
> 
> Dave.

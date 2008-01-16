Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 15 Jan 2008 16:51:09 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m0G0orwD023453
	for <xfs@oss.sgi.com>; Tue, 15 Jan 2008 16:50:57 -0800
Date: Wed, 16 Jan 2008 11:51:21 +1100
Subject: Re: [REVIEW] Refactor xfs_repair's process_dinode_int
From: "Barry Naujok" <bnaujok@sgi.com>
Content-Type: text/plain; format=flowed; delsp=yes; charset=utf-8
MIME-Version: 1.0
References: <4782B72D.8070208@agami.com> <47833C0F.6070206@agami.com> <op.t4m0r1an3jf8g2@pc-bnaujok.melbourne.sgi.com> <478D1899.9080201@agami.com>
Content-Transfer-Encoding: 7bit
Message-ID: <op.t4zzbvbs3jf8g2@pc-bnaujok.melbourne.sgi.com>
In-Reply-To: <478D1899.9080201@agami.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Chandan Talukdar <chandan@agami.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Wed, 16 Jan 2008 07:33:29 +1100, Chandan Talukdar <chandan@agami.com>  
wrote:

> Hi Barry,
>
> - In process_misc_ino_types(), dino->di_core.di_size is being accessed  
> without being converted to machine format.  The check is being performed  
> against 0; so, it should be fine.  But for better code readability, I  
> guess it should be accessed through be64_to_cpu().

Yeah... sort of in two-minds about this one.

> - In change_dinode_fmt(), it might be worthwhile to add an ASSERT  
> against someone passing a value greater than 16 bit for 'new_fmt'.

Good idea.

> - In process_inode_attr_fork(), di_anextents should be accessed using  
> be16_to_cpu as it is a 16 bit quantity.
>
> - In process_dinode_int() line 2691, dinoc->di_extsize should be  
> accessed using be32_to_cpu().

Good pickup on these, thanks :)

> - In process_dinode_int(), we should be checking for 'dblkmap' not being  
> NULL before freeing it.  There are a few error conditions which can  
> cause the control to go to 'clear_bad_out' with dblkmap being NULL.

freeing a NULL is valid, from the man page:

free() frees the memory space pointed to by ptr, which must have been
returned by a previous call to malloc(), calloc() or realloc(). Otherwise,
or if free(ptr) has already been called before, undefined behaviour occurs.
  >>> If ptr is NULL, no operation is performed. <<<

> Thanks,
> Chandan

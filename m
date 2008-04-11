Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 11 Apr 2008 01:39:05 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m3B8cfw8018645
	for <xfs@oss.sgi.com>; Fri, 11 Apr 2008 01:38:44 -0700
Subject: Re: [PATCH 2/2] simplify xfs_lock_for_rename
From: "Barry Naujok" <bnaujok@sgi.com>
Content-Type: text/plain; format=flowed; delsp=yes; charset=utf-8
MIME-Version: 1.0
References: <20080410184413.GB6771@lst.de> <op.t9fi87c93jf8g2@pc-bnaujok.melbourne.sgi.com> <20080411073730.GA9236@lst.de>
Date: Fri, 11 Apr 2008 18:40:53 +1000
Message-ID: <op.t9fuef1t3jf8g2@pc-bnaujok.melbourne.sgi.com>
In-Reply-To: <20080411073730.GA9236@lst.de>
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: xfs@oss.sgi.com

On Fri, 11 Apr 2008 17:37:30 +1000, Christoph Hellwig <hch@lst.de> wrote:

>>
>> It seems that do_rename() in namei.c calls lookup_hash/__lookup_hash
>> which does an inode->i_op->lookup() to get the dentry. This will do
>> the xfs_lookup anyway, taking a refernence if the target exists.
>>
>> 	error = do_path_lookup(newdfd, newname, LOOKUP_PARENT, &newnd);
>> 	...
>> 	new_dentry = lookup_hash(&newnd);
>> 	...
>> 	error = vfs_rename(old_dir->d_inode, old_dentry,
>> 				   new_dir->d_inode, new_dentry);
>>
>> Therefore, target_ip/ipp2 is already known then when xfs_rename/
>> xfs_lock_for_rename is called.
>
> You're right.  Back to the drawing board to make rename even simpler.
> None of the other patches I sent yesterday depends on this one so they
> can go in independently.  And I'd especially like to see the lookup one
> before lookup gets more complicated again for CI support.

I've already applied your patches to my workarea. Certainly makes my
CI code simpler.

Barry.

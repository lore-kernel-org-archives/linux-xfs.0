Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:42876 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727586AbfEQVAa (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 17 May 2019 17:00:30 -0400
Subject: Re: [PATCH 1/3] libxfs: rename shared kernel functions from libxfs_
 to xfs_
References: <8fc2eb9e-78c4-df39-3b8f-9109720ab680@redhat.com>
 <bef9aa18-a9b1-4743-342d-b6f77c26b67b@redhat.com>
 <13df8c28-a75f-e029-51af-422d84cdf423@oracle.com>
From: Eric Sandeen <sandeen@redhat.com>
Message-ID: <4df43ea8-2dbc-9020-ee0e-08af912d2890@redhat.com>
Date: Fri, 17 May 2019 16:00:29 -0500
MIME-Version: 1.0
In-Reply-To: <13df8c28-a75f-e029-51af-422d84cdf423@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Allison Collins <allison.henderson@oracle.com>, linux-xfs <linux-xfs@vger.kernel.org>

On 5/17/19 3:49 PM, Allison Collins wrote:
> 
> 
> On 5/16/19 10:43 AM, Eric Sandeen wrote:
>> The libxfs_* function namespace has gotten a bit confused and
>> muddled; the general idea is that functions called from userspace
>> utilities should use the libxfs_* namespace.  In many cases
>> we use #defines to define xfs_* namespace to libxfs_*; in other
>> cases we have explicitly defined libxfs_* functions which are clear
>> counterparts or even clones of kernel libxfs/* functions.
>>
>> For any function definitions within libxfs/* which match kernel
>> names, give them standard xfs_* names to further reduce differnces
>> between userspace and kernel libxfs/* code.
>>
>> Then add #defines to libxfs_* for any functions which are needed
>> by utilities, as is done with other core functionality.
>>
>> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
>> ---
>>
>> diff --git a/include/libxfs.h b/include/libxfs.h
>> index 230bc3e8..ceebccdc 100644
>> --- a/include/libxfs.h
>> +++ b/include/libxfs.h
>> @@ -151,7 +151,7 @@ extern int    libxfs_log_header(char *, uuid_t *, int, int, int, xfs_lsn_t,
>>     /* Shared utility routines */
>>   -extern int    libxfs_alloc_file_space (struct xfs_inode *, xfs_off_t,
>> +extern int    xfs_alloc_file_space (struct xfs_inode *, xfs_off_t,
>>                   xfs_off_t, int, int);
>>     /* XXX: this is messy and needs fixing */
>> diff --git a/include/xfs_inode.h b/include/xfs_inode.h
>> index 88b58ac3..3e7e80ea 100644
>> --- a/include/xfs_inode.h
>> +++ b/include/xfs_inode.h
>> @@ -139,21 +139,21 @@ typedef struct cred {
>>       gid_t    cr_gid;
>>   } cred_t;
>>   -extern int    libxfs_inode_alloc (struct xfs_trans **, struct xfs_inode *,
>> +extern int    xfs_inode_alloc (struct xfs_trans **, struct xfs_inode *,
>>                   mode_t, nlink_t, xfs_dev_t, struct cred *,
>>                   struct fsxattr *, struct xfs_inode **);
>> -extern void    libxfs_trans_inode_alloc_buf (struct xfs_trans *,
>> +extern void    xfs_trans_inode_alloc_buf (struct xfs_trans *,
>>                   struct xfs_buf *);
>>   -extern void    libxfs_trans_ichgtime(struct xfs_trans *,
>> +extern void    xfs_trans_ichgtime(struct xfs_trans *,
>>                   struct xfs_inode *, int);
>> -extern int    libxfs_iflush_int (struct xfs_inode *, struct xfs_buf *);
>> +extern int    xfs_iflush_int (struct xfs_inode *, struct xfs_buf *);
>>     /* Inode Cache Interfaces */
>> -extern bool    libxfs_inode_verify_forks(struct xfs_inode *ip);
>> -extern int    libxfs_iget(struct xfs_mount *, struct xfs_trans *, xfs_ino_t,
>> +extern bool    xfs_inode_verify_forks(struct xfs_inode *ip);
>> +extern int    xfs_iget(struct xfs_mount *, struct xfs_trans *, xfs_ino_t,
>>                   uint, struct xfs_inode **,
>>                   struct xfs_ifork_ops *);
>> -extern void    libxfs_irele(struct xfs_inode *ip);
>> +extern void    xfs_irele(struct xfs_inode *ip);
>>     #endif /* __XFS_INODE_H__ */
>> diff --git a/include/xfs_trans.h b/include/xfs_trans.h
>> index 10b74538..d32acc9e 100644
>> --- a/include/xfs_trans.h
>> +++ b/include/xfs_trans.h
>> @@ -75,46 +75,46 @@ typedef struct xfs_trans {
>>   void    xfs_trans_init(struct xfs_mount *);
>>   int    xfs_trans_roll(struct xfs_trans **);
>>   -int    libxfs_trans_alloc(struct xfs_mount *mp, struct xfs_trans_res *resp,
>> +int    xfs_trans_alloc(struct xfs_mount *mp, struct xfs_trans_res *resp,
>>                  uint blocks, uint rtextents, uint flags,
>>                  struct xfs_trans **tpp);
>>   int    libxfs_trans_alloc_rollable(struct xfs_mount *mp, uint blocks,
>>                       struct xfs_trans **tpp);
> 
> Did you mean to rename libxfs_trans_alloc_rollable too?  I notice the function name is changed later down in the patch.

Not sure - it's not actually a kernel-matching function, it should
probably get moved to util.c or something, since it's
userspace-specific.

But yeah, I guess the way I handled it is a little inconsistent,
probably saved by the #define.  :)

-Eric

> I think the rest of it looks pretty straight forward though.
> 
> Allison

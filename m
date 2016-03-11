Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id B9FE77CA3
	for <xfs@oss.sgi.com>; Fri, 11 Mar 2016 11:03:21 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 45B86AC005
	for <xfs@oss.sgi.com>; Fri, 11 Mar 2016 09:03:18 -0800 (PST)
Received: from mail-vk0-f47.google.com (mail-vk0-f47.google.com
	[209.85.213.47]) by cuda.sgi.com with ESMTP id yhkzmZeSr7MG7T6w
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Fri, 11 Mar 2016 09:03:12 -0800 (PST)
Received: by mail-vk0-f47.google.com with SMTP id e185so141318103vkb.1
	for <xfs@oss.sgi.com>; Fri, 11 Mar 2016 09:03:12 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20160311141701.GE14808@infradead.org>
References: <1456733847-17982-1-git-send-email-agruenba@redhat.com>
	<1456733847-17982-19-git-send-email-agruenba@redhat.com>
	<20160311141701.GE14808@infradead.org>
Date: Fri, 11 Mar 2016 18:03:11 +0100
Message-ID: <CAHc6FU7gH54C-hfV8VQzgpYv=PYNvpA9dc8stgVf2_khF7dUdg@mail.gmail.com>
Subject: Re: [PATCH v18 18/22] richacl: xattr mapping functions
From: Andreas Gruenbacher <agruenba@redhat.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-cifs@vger.kernel.org, Linux NFS Mailing List <linux-nfs@vger.kernel.org>, Theodore Ts'o <tytso@mit.edu>, Linux API <linux-api@vger.kernel.org>, Trond Myklebust <trond.myklebust@primarydata.com>, LKML <linux-kernel@vger.kernel.org>, XFS Developers <xfs@oss.sgi.com>, "J. Bruce Fields" <bfields@fieldses.org>, Andreas Dilger <adilger.kernel@dilger.ca>, Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Jeff Layton <jlayton@poochiereds.net>, linux-ext4 <linux-ext4@vger.kernel.org>, Anna Schumaker <anna.schumaker@netapp.com>

On Fri, Mar 11, 2016 at 3:17 PM, Christoph Hellwig <hch@infradead.org> wrote:
>> +#include <linux/richacl_xattr.h>
>> +
>> +MODULE_LICENSE("GPL");
>
> what's the point given that the code isn't even modolar?

A leftover, removed now.

>> +static void
>> +fix_xattr_from_user(const char *kname, void *kvalue, size_t size)
>> +{
>> +     if (strncmp(kname, XATTR_SYSTEM_PREFIX, XATTR_SYSTEM_PREFIX_LEN))
>> +             return;
>> +     kname += XATTR_SYSTEM_PREFIX_LEN;
>> +     if (!strcmp(kname, XATTR_POSIX_ACL_ACCESS) ||
>> +         !strcmp(kname, XATTR_POSIX_ACL_DEFAULT))
>> +             posix_acl_fix_xattr_from_user(kvalue, size);
>> +}
>>
>>  /*
>>   * Extended attribute SET operations
>> @@ -329,9 +339,7 @@ setxattr(struct dentry *d, const char __user *name, const void __user *value,
>>                       error = -EFAULT;
>>                       goto out;
>>               }
>> -             if ((strcmp(kname, XATTR_NAME_POSIX_ACL_ACCESS) == 0) ||
>> -                 (strcmp(kname, XATTR_NAME_POSIX_ACL_DEFAULT) == 0))
>> -                     posix_acl_fix_xattr_from_user(kvalue, size);
>> +             fix_xattr_from_user(kname, kvalue, size);
>>       }
>>
>>       error = vfs_setxattr(d, kname, kvalue, size, flags);
>> @@ -396,6 +404,17 @@ SYSCALL_DEFINE5(fsetxattr, int, fd, const char __user *, name,
>>       return error;
>>  }
>>
>> +static void
>> +fix_xattr_to_user(const char *kname, void *kvalue, size_t size)
>> +{
>> +     if (strncmp(kname, XATTR_SYSTEM_PREFIX, XATTR_SYSTEM_PREFIX_LEN))
>> +             return;
>> +     kname += XATTR_SYSTEM_PREFIX_LEN;
>> +     if (!strcmp(kname, XATTR_POSIX_ACL_ACCESS) ||
>> +         !strcmp(kname, XATTR_POSIX_ACL_DEFAULT))
>> +             posix_acl_fix_xattr_to_user(kvalue, size);
>> +}
>> +
>>  /*
>>   * Extended attribute GET operations
>>   */
>> @@ -426,9 +445,7 @@ getxattr(struct dentry *d, const char __user *name, void __user *value,
>>
>>       error = vfs_getxattr(d, kname, kvalue, size);
>>       if (error > 0) {
>> -             if ((strcmp(kname, XATTR_NAME_POSIX_ACL_ACCESS) == 0) ||
>> -                 (strcmp(kname, XATTR_NAME_POSIX_ACL_DEFAULT) == 0))
>> -                     posix_acl_fix_xattr_to_user(kvalue, size);
>> +             fix_xattr_to_user(kname, kvalue, size);
>
> I don't see how this is related to the rest of the patch.

Indeed, this is unrelated now. I'll split it off.

>> +++ b/include/linux/richacl_xattr.h
>
> What's the point in splitting this from the richacl.h header?
>
> Same for the uapi versions.
>
>> +struct richacl_xattr {
>> +     unsigned char   a_version;
>> +     unsigned char   a_flags;
>
> Explicit __u8 for uapi headers, please.

Okay.

Thanks,
Andreas

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

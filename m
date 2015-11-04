Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id E69127FDB
	for <xfs@oss.sgi.com>; Wed,  4 Nov 2015 15:54:55 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id D69B130404E
	for <xfs@oss.sgi.com>; Wed,  4 Nov 2015 13:54:52 -0800 (PST)
Received: from mail-lb0-f180.google.com (mail-lb0-f180.google.com
	[209.85.217.180]) by cuda.sgi.com with ESMTP id
	HvE8NB6mA9G9YZjm (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 04 Nov 2015 13:54:50 -0800 (PST)
Received: by lbbes7 with SMTP id es7so22457521lbb.2
	for <xfs@oss.sgi.com>; Wed, 04 Nov 2015 13:54:49 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <D235953B-3EAF-4B00-AC07-4420B85E9E9E@dilger.ca>
References: <1446563847-14005-1-git-send-email-agruenba@redhat.com>
	<1446563847-14005-11-git-send-email-agruenba@redhat.com>
	<D235953B-3EAF-4B00-AC07-4420B85E9E9E@dilger.ca>
Date: Wed, 4 Nov 2015 22:54:48 +0100
Message-ID: <CAHc6FU6rryA3B=fV1jP9LsRAJdPTh9ze7fGYdpE-DZ6TmsPjug@mail.gmail.com>
Subject: Re: [PATCH v13 10/51] vfs: Cache base_acl objects in inodes
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
To: Andreas Dilger <adilger@dilger.ca>
Cc: linux-cifs@vger.kernel.org, Linux NFS Mailing List <linux-nfs@vger.kernel.org>, Theodore Ts'o <tytso@mit.edu>, Linux API <linux-api@vger.kernel.org>, Trond Myklebust <trond.myklebust@primarydata.com>, LKML <linux-kernel@vger.kernel.org>, XFS Developers <xfs@oss.sgi.com>, "J. Bruce Fields" <bfields@fieldses.org>, Andreas Dilger <adilger.kernel@dilger.ca>, Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Jeff Layton <jlayton@poochiereds.net>, linux-ext4 <linux-ext4@vger.kernel.org>, Anna Schumaker <anna.schumaker@netapp.com>

Andreas,

On Tue, Nov 3, 2015 at 11:29 PM, Andreas Dilger <adilger@dilger.ca> wrote:
> On Nov 3, 2015, at 8:16 AM, Andreas Gruenbacher <agruenba@redhat.com> wrote:
>>
>> POSIX ACLs and richacls are both objects allocated by kmalloc() with a
>> reference count which are freed by kfree_rcu().  An inode can either
>> cache an access and a default POSIX ACL, or a richacl (richacls do not
>> have default acls).  To allow an inode to cache either of the two kinds
>> of acls, introduce a new base_acl type and convert i_acl and
>> i_default_acl to that type. In most cases, the vfs then doesn't have to
>> care which kind of acl an inode caches (if any).
>
> For new wrapper functions like this better to name them as "NOUN_VERB" so
> rather than "VERB_NOUN" so that related functions sort together, like
> base_acl_init(), base_acl_get(), base_acl_put(), base_acl_refcount(), etc.

That's better, yes. I agree with all your comments and I've changed
things accordingly.

>> @@ -270,7 +270,7 @@ static struct posix_acl *f2fs_acl_clone(const struct posix_acl *acl,
>>                               sizeof(struct posix_acl_entry);
>>               clone = kmemdup(acl, size, flags);
>>               if (clone)
>> -                     atomic_set(&clone->a_refcount, 1);
>> +                     atomic_set(&clone->a_base.ba_refcount, 1);
>
> This should be base_acl_init() since this should also reset the RCU state
> if it was just copied from "acl" above.

Yes. The rcu_head doesn't need initializing or resetting though.

>  That wouldn't be quite correct if
> there are other fields added to struct base_acl that don't need to be
> initialized when it is copied, so possibly base_acl_reinit() would be better
> here and below if that will be the case in the near future (I haven't looked
> through the whole patch series yet).

We won't need a base_acl_reinit() function for now.

>> @@ -25,9 +25,9 @@ struct posix_acl **acl_by_type(struct inode *inode, int type)
>> {
>>       switch (type) {
>>       case ACL_TYPE_ACCESS:
>> -             return &inode->i_acl;
>> +             return (struct posix_acl **)&inode->i_acl;
>>       case ACL_TYPE_DEFAULT:
>> -             return &inode->i_default_acl;
>> +             return (struct posix_acl **)&inode->i_default_acl;
>
> This would be better to use container_of() to unwrap struct base_acl from
> struct posix_acl.  That avoids the hard requirement (which isn't documented
> anywhere) that base_acl needs to be the first member of struct posix_acl.
>
> I was originally going to write that you should add a comment that base_acl
> needs to be the first member of both richacl and posix_acl, but container_of()
> is both cleaner and safer.
>
> Looking further down, that IS actually needed due to the way kfree is used on
> the base_acl pointer, but using container_of() is still cleaner and safer
> than directly casting double pointers (which some compilers and static
> analysis tools will be unhappy with).

Well, we would end up with &container_of() here which doesn't work and
doesn't make sense, either. Let me change acl_by_type to return a
base_acl ** to clean this up.

>> @@ -576,6 +576,12 @@ static inline void mapping_allow_writable(struct address_space *mapping)
>> #define i_size_ordered_init(inode) do { } while (0)
>> #endif
>>
>> +struct base_acl {
>> +     union {
>> +             atomic_t ba_refcount;
>> +             struct rcu_head ba_rcu;
>> +     };
>> +};
>> struct posix_acl;
>
> Is this forward declaration of struct posix_acl even needed anymore after
> the change below?  There shouldn't be references to the struct in the common
> code anymore (at least not by the end of the patch series.

The get_acl and set_acl inode operations expect struct posix_acl to be declared.

> Hmm, using the base_acl pointer as the pointer to kfree means that the
> base_acl structure DOES need to be the first one in both struct posix_acl
> and struct richacl, so that needs to be commented at each structure so
> it doesn't accidentally break in the future.

Yes. I've added comments; there are also BUILD_BUG_ON() asserts in
posix_acl_release and richacl_put.

>> @@ -57,7 +57,7 @@ static inline struct richacl *
>> richacl_get(struct richacl *acl)
>> {
>>       if (acl)
>> -             atomic_inc(&acl->a_refcount);
>> +             atomic_inc(&acl->a_base.ba_refcount);
>>       return acl;
>
> This should also use base_acl_get() for consistency. That said, where is
> the call to base_acl_put() in the richacl code?
> Also, where is the change to struct richacl?  It looks like this patch would
> not be able to compile by itself.

Ah, a little problem in how the patches are split. I've fixed it. This
code doesn't get pulled into the build because nothing requires
CONFIG_FS_RICHACL at that point; that's why I didn't notice.

Thanks,
Andreas

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

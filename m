Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 0FC4B7CA2
	for <xfs@oss.sgi.com>; Thu, 14 Jul 2016 17:38:35 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 74F51AC003
	for <xfs@oss.sgi.com>; Thu, 14 Jul 2016 15:38:34 -0700 (PDT)
Received: from mail-vk0-f47.google.com (mail-vk0-f47.google.com
	[209.85.213.47]) by cuda.sgi.com with ESMTP id KAC2u6ktpnzCggdJ
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Thu, 14 Jul 2016 15:38:32 -0700 (PDT)
Received: by mail-vk0-f47.google.com with SMTP id x130so132075816vkc.0
	for <xfs@oss.sgi.com>; Thu, 14 Jul 2016 15:38:32 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1468325634.7798.24.camel@redhat.com>
References: <1467294433-3222-1-git-send-email-agruenba@redhat.com>
	<1467294433-3222-21-git-send-email-agruenba@redhat.com>
	<1468325634.7798.24.camel@redhat.com>
From: Andreas Gruenbacher <agruenba@redhat.com>
Date: Thu, 14 Jul 2016 22:59:16 +0200
Message-ID: <CAHc6FU6+NpXZTMCub6XydBbHw_LVz8aPh8whZ9HwDoTbxjqLBw@mail.gmail.com>
Subject: Re: [PATCH v23 20/22] vfs: Add richacl permission checking
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
To: Jeff Layton <jlayton@redhat.com>
Cc: "J. Bruce Fields" <bfields@fieldses.org>, Linux NFS Mailing List <linux-nfs@vger.kernel.org>, Theodore Ts'o <tytso@mit.edu>, linux-cifs@vger.kernel.org, Linux API <linux-api@vger.kernel.org>, Trond Myklebust <trond.myklebust@primarydata.com>, LKML <linux-kernel@vger.kernel.org>, XFS Developers <xfs@oss.sgi.com>, Christoph Hellwig <hch@infradead.org>, Andreas Dilger <adilger.kernel@dilger.ca>, Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-ext4 <linux-ext4@vger.kernel.org>, Anna Schumaker <anna.schumaker@netapp.com>

On Tue, Jul 12, 2016 at 2:13 PM, Jeff Layton <jlayton@redhat.com> wrote:
> On Thu, 2016-06-30 at 15:47 +0200, Andreas Gruenbacher wrote:
>> Hook the richacl permission checking function into the vfs.
>>
>> Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
>> ---
>>  fs/namei.c | 54 ++++++++++++++++++++++++++++++++++++++++++++++++++++--
>>  1 file changed, 52 insertions(+), 2 deletions(-)
>>
>> diff --git a/fs/namei.c b/fs/namei.c
>> index 7a822d0..48c9958 100644
>> --- a/fs/namei.c
>> +++ b/fs/namei.c
>> @@ -34,6 +34,7 @@
>>  #include
>>  #include
>>  #include
>> +#include
>>  #include
>>  #include
>>  #include
>> @@ -256,7 +257,43 @@ void putname(struct filename *name)
>>               __putname(name);
>>  }
>>
>> -static int check_acl(struct inode *inode, int mask)
>> +static int check_richacl(struct inode *inode, int mask)
>> +{
>> +#ifdef CONFIG_FS_RICHACL
>> +     if (mask & MAY_NOT_BLOCK) {
>> +             struct base_acl *base_acl;
>> +
>> +             base_acl = rcu_dereference(inode->i_acl);
>> +             if (!base_acl)
>> +                     goto no_acl;
>> +             /* no ->get_richacl() calls in RCU mode... */
>> +             if (is_uncached_acl(base_acl))
>> +                     return -ECHILD;
>> +             return richacl_permission(inode, richacl(base_acl),
>> +                                       mask & ~MAY_NOT_BLOCK);
>> +     } else {
>> +             struct richacl *acl;
>> +
>> +             acl = get_richacl(inode);
>> +             if (IS_ERR(acl))
>> +                     return PTR_ERR(acl);
>> +             if (acl) {
>> +                     int error = richacl_permission(inode, acl, mask);
>> +                     richacl_put(acl);
>> +                     return error;
>> +             }
>> +     }
>> +no_acl:
>> +#endif
>
> nit: Can you move the above to a static inline or something that becomes a noop when the config var is turned off?

We could move check_richacl into richacl.c and check_posix_acl into
posix_acl.c. Given that those functions are currently only called once
in namei.c, that's a very small improvement at most though.

>> +     if (mask & (MAY_DELETE_SELF | MAY_TAKE_OWNERSHIP |
>> +                 MAY_CHMOD | MAY_SET_TIMES)) {
>> +             /* File permission bits cannot grant this. */
>> +             return -EACCES;
>> +     }
>> +     return -EAGAIN;
>> +}
>> +
>> +static int check_posix_acl(struct inode *inode, int mask)
>>  {
>>  #ifdef CONFIG_FS_POSIX_ACL
>>       if (mask & MAY_NOT_BLOCK) {
>> @@ -294,11 +331,24 @@ static int acl_permission_check(struct inode *inode, int mask)
>>  {
>>       unsigned int mode = inode->i_mode;
>>
>> +     /*
>> +      * With POSIX ACLs, the (mode & S_IRWXU) bits exactly match the owner
>> +      * permissions, and we can skip checking posix acls for the owner.
>> +      * With richacls, the owner may be granted fewer permissions than the
>> +      * mode bits seem to suggest (for example, append but not write), and
>> +      * we always need to check the richacl.
>> +      */
>> +
>> +     if (IS_RICHACL(inode)) {
>> +             int error = check_richacl(inode, mask);
>> +             if (error != -EAGAIN)
>> +                     return error;
>> +     }
>>       if (likely(uid_eq(current_fsuid(), inode->i_uid)))
>>               mode >>= 6;
>>       else {
>>               if (IS_POSIXACL(inode) && (mode & S_IRWXG)) {
>> -                     int error = check_acl(inode, mask);
>> +                     int error = check_posix_acl(inode, mask);
>>                       if (error != -EAGAIN)
>>                               return error;
>>               }
>
> Looks fine other than the nit above:
>
> Reviewed-by: Jeff Layton <jlayton@redhat.com>

Thanks,
Andreas

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

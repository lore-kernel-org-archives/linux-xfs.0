Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 8E3D67F5D
	for <xfs@oss.sgi.com>; Sat,  7 Nov 2015 14:47:36 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 5E4EF8F8049
	for <xfs@oss.sgi.com>; Sat,  7 Nov 2015 12:47:36 -0800 (PST)
Received: from mail-lb0-f173.google.com (mail-lb0-f173.google.com
	[209.85.217.173]) by cuda.sgi.com with ESMTP id
	zwVqcq7MNW7PrYBo (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Sat, 07 Nov 2015 12:47:30 -0800 (PST)
Received: by lbbkw15 with SMTP id kw15so71622945lbb.0
	for <xfs@oss.sgi.com>; Sat, 07 Nov 2015 12:47:29 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <8C966D9B-A46D-47EC-BD4B-20E2F9B42555@dilger.ca>
References: <1446723580-3747-1-git-send-email-agruenba@redhat.com>
	<1446723580-3747-4-git-send-email-agruenba@redhat.com>
	<8C966D9B-A46D-47EC-BD4B-20E2F9B42555@dilger.ca>
Date: Sat, 7 Nov 2015 21:47:28 +0100
Message-ID: <CAHc6FU7h5JLPfiB=fx=k0yjCAp+ujy3bY0XbMz3rR--1uo=5AQ@mail.gmail.com>
Subject: Re: [PATCH v14 03/22] vfs: Add MAY_DELETE_SELF and MAY_DELETE_CHILD
	permission flags
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

On Fri, Nov 6, 2015 at 10:26 PM, Andreas Dilger <adilger@dilger.ca> wrote:
> On Nov 5, 2015, at 4:39 AM, Andreas Gruenbacher <agruenba@redhat.com> wrote:
>>
>> Normally, deleting a file requires MAY_WRITE access to the parent
>> directory.  With richacls, a file may be deleted with MAY_DELETE_CHILD access
>> to the parent directory or with MAY_DELETE_SELF access to the file.
>>
>> To support that, pass the MAY_DELETE_CHILD mask flag to inode_permission()
>> when checking for delete access inside a directory, and MAY_DELETE_SELF
>> when checking for delete access to a file itelf.
>>
>> The MAY_DELETE_SELF permission overrides the sticky directory check.
>>
>> Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
>> Reviewed-by: J. Bruce Fields <bfields@redhat.com>
>> ---
>> fs/namei.c         | 21 ++++++++++++---------
>> include/linux/fs.h |  2 ++
>> 2 files changed, 14 insertions(+), 9 deletions(-)
>>
>> diff --git a/fs/namei.c b/fs/namei.c
>> index 0259392..2eab19e 100644
>> --- a/fs/namei.c
>> +++ b/fs/namei.c
>> @@ -453,9 +453,9 @@ static int sb_permission(struct super_block *sb, struct inode *inode, int mask)
>>  * this, letting us set arbitrary permissions for filesystem access without
>>  * changing the "normal" UIDs which are used for other things.
>>  *
>> - * MAY_WRITE must be set in @mask whenever MAY_APPEND, MAY_CREATE_FILE, or
>> - * MAY_CREATE_DIR are set.  That way, file systems that don't support these
>> - * permissions will check for MAY_WRITE instead.
>> + * MAY_WRITE must be set in @mask whenever MAY_APPEND, MAY_CREATE_FILE,
>> + * MAY_CREATE_DIR, or MAY_DELETE_CHILD are set.  That way, file systems that
>> + * don't support these permissions will check for MAY_WRITE instead.
>>  */
>> int inode_permission(struct inode *inode, int mask)
>> {
>> @@ -2555,7 +2555,7 @@ static int may_delete(struct inode *dir, struct dentry *victim,
>>                     bool isdir, bool replace)
>> {
>>       struct inode *inode = d_backing_inode(victim);
>> -     int error, mask = MAY_WRITE | MAY_EXEC;
>> +     int error, mask = MAY_EXEC;
>>
>>       if (d_is_negative(victim))
>>               return -ENOENT;
>> @@ -2565,15 +2565,18 @@ static int may_delete(struct inode *dir, struct dentry *victim,
>>       audit_inode_child(dir, victim, AUDIT_TYPE_CHILD_DELETE);
>>
>>       if (replace)
>> -             mask |= isdir ? MAY_CREATE_DIR : MAY_CREATE_FILE;
>> -     error = inode_permission(dir, mask);
>> +             mask |= MAY_WRITE | (isdir ? MAY_CREATE_DIR : MAY_CREATE_FILE);
>> +     error = inode_permission(dir, mask | MAY_WRITE | MAY_DELETE_CHILD);
>> +     if (!error && check_sticky(dir, inode))
>> +             error = -EPERM;
>> +     if (error && IS_RICHACL(inode) &&
>> +         inode_permission(inode, MAY_DELETE_SELF) == 0)
>> +             error = 0;
>
> This looks like a serious bug, as it is overriding other errors returned
> from inode_permission() such as -EROFS from sb_permission() or even from
> generic_permission->acl_permission_check().  Clearing the error returned
> by an earlier check doesn't seem safe, only new errors should be added.

See further below ...

> The call to inode_permission(inode) is also duplicating the sb_permission()
> check from inode_permission(dir), so at most should be __inode_permission().

This could be optimized, but that would make the code harder to read.
I don't think it really matters: this only affects file with the
MAY_DELETE_SELF permission, and sb_permissions is really cheap anyway.

> It looks like this would be correct if you check MAY_DELETE_SELF together
> with check_sticky():
>
>         if (!error && check_sticky(dir, inode) &&
>             !__inode_permission(inode, MAY_DELETE_SELF))
>                 error = -EPERM;

Nope, this version would deny users with MAY_DELETE_SELF access to a
file and MAY_EXEC access to the directory the right to delete the file
because @error would already be set then.

You are right that the check for MAY_DELETE_SELF overrides too much
here though; we need an additional inode_permission(dir, ...) check in
there.

I've pushed a fixed version here that I will do some more testing on
before reposting:

  git://git.kernel.org/pub/scm/linux/kernel/git/agruen/linux-richacl.git
richacl-wip

> I ommitted the IS_RICHACL() check here, since that should probably be in
> __inode_permission() when MAY_DELETE_SELF is passed?

The IS_RICHACL() check is indeed done in inode_permission ->
__inode_permission -> do_inode_permission -> generic_permission ->
acl_permission_check. I've duplicated that check here to avoid slowing
down may_delete in the common case where the filesystem doesn't
support richacls.

Thanks,
Andreas

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

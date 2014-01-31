Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id CD3727F77
	for <xfs@oss.sgi.com>; Fri, 31 Jan 2014 07:39:34 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 6C9C9AC003
	for <xfs@oss.sgi.com>; Fri, 31 Jan 2014 05:39:31 -0800 (PST)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id Bf7DmpRQDYoNGwWw (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 31 Jan 2014 05:39:29 -0800 (PST)
Message-ID: <52EBA783.1080801@oracle.com>
Date: Fri, 31 Jan 2014 21:39:15 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: Re: Extended attributes limit in Linux
References: <CAMN6oR=a0G6O-3CVVkTwhYKavJTa543U3MLezCM8KW1ASZcPnA@mail.gmail.com>	<52EB64DC.4020603@oracle.com>
	<1391165083.4275.7.camel@ubuntu>	<52EB960D.607@oracle.com>
	<1391172723.4275.11.camel@ubuntu>
In-Reply-To: <1391172723.4275.11.camel@ubuntu>
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
To: Vyacheslav Dubeyko <slava@dubeyko.com>
Cc: Sun_Blood <sblood@gmail.com>, xfs@oss.sgi.com


On 01/31 2014 20:52 PM, Vyacheslav Dubeyko wrote:
> On Fri, 2014-01-31 at 20:24 +0800, Jeff Liu wrote:
>> On 01/31 2014 18:44 PM, Vyacheslav Dubeyko wrote:
>>> On Fri, 2014-01-31 at 16:54 +0800, Jeff Liu wrote:
>>>> Hello,
>>>>
>>>> On 01/31 2014 15:40 PM, Sun_Blood wrote:
>>>>> Hello,
>>>>>
>>>>> If I understands it correctly XFS don't have a limit to the size of
>>>>> extended attributes(EA) but Linux impose a limit at 64k.
>>>>> What I am trying to do is build a backup server that our Apple computers
>>>>> will use together with rsync to backup files to. The problem I face is
>>>>> that Apple HFS+ don't have a limit to EA so it has files with more then
>>>>> 64k of EA in it.
>>>
>>> Technical Note TN1150:
>>> "In an HFS Plus B-tree, the node size is determined by a field
>>> (nodeSize) in the header node. The node size must be a power from 512
>>> through 32,768."
>>>
>>> So, as minimum, xattrs unable to be a larger than node size.
>>>
>>> But xattrs' size has limitation anyway:
>>>
>>> https://github.com/darwin-on-arm/xnu/blob/master/bsd/hfs/hfs.h#L849
>>>
>>> /* Maximum extended attribute size supported for all extended attributes except
>>> * resource fork and finder info.
>>> */
>>> #define HFS_XATTR_MAXSIZE (128 * 1024)
>>>
>>> So, I need to check and correct slightly HFS+ xattrs support code.
>>> Because, I used 3082 bytes limitation value.
>>
>> I just verified above limits on Mac OS X, that's true.
>>
>> sh-3.2# a=`perl -e 'print "A"x131072'`
>> sh-3.2# xattr -w user.comment ${a} xattr_test
>>
>> sh-3.2# a=`perl -e 'print "A"x131073'`
>> sh-3.2# xattr -w user.comment ${a} xattr_test
>> xattr: [Errno 7] Argument list too long: 'xattr'
>>
>> Hence, that would be a problem to preserve EA with large value size on Linux.
>>
> 
> I checked the same under Mac OS X 10.6.8 (Snow Leopard). And I have
> failed on 3803 bytes size of xattr. So, I suppose that you have Mac OS X
> Lion. And EAs is larger under Lion yet.
> 
> What version of Mac OS X have you?
> 
Yup, Mountain Lion v10.8.4 :)

FYI, there have a couple of things regarding HFSPlus+xattr+acl on Linux might be
deserved to discuss together.

We once have a discussion about the errno in case of hit the limits of ACLs, which
could be referred to:
http://www.spinics.net/lists/linux-fsdevel/msg71125.html

HFSPlus return ENOMEM in this case, but it should be E2BIG as per Dave's comments.
I worked out a patch series includes HFSPlus, but not yet posted for some reasons.

Also, it seems to me we'd better consolidate the errno for EA as well, that is to
say, it's better to fix the return error to be consistent with VFS interface in case
of the given EA name/value length is larger than the specified limits.

Would you like to take a look at the following two patches?

Thanks,
-Jeff


From: Jie Liu <jeff.liu@oracle.com>
Subject: [PATCH 7/12] HFSPlus: return -E2BIG if hit the maximum size of ACLs

Return -E2BIG rather than -ENOMEM if hit the maximum size of ACLs, because
of the former errno is consistent with the VFS interface.

Signed-off-by: Jie Liu <jeff.liu@oracle.com>
---
 fs/hfsplus/posix_acl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/hfsplus/posix_acl.c b/fs/hfsplus/posix_acl.c
index b609cc1..2f2788d 100644
--- a/fs/hfsplus/posix_acl.c
+++ b/fs/hfsplus/posix_acl.c
@@ -92,7 +92,7 @@ static int hfsplus_set_posix_acl(struct inode *inode,
 	if (acl) {
 		size = posix_acl_xattr_size(acl->a_count);
 		if (unlikely(size > HFSPLUS_MAX_INLINE_DATA_SIZE))
-			return -ENOMEM;
+			return -E2BIG;
 		value = (char *)hfsplus_alloc_attr_entry();
 		if (unlikely(!value))
 			return -ENOMEM;
-- 
1.8.3.2


From: Jie Liu <jeff.liu@oracle.com>
Subject: [PATCH 8/12] HFSPlus: return -ERANGE if xattr name size is larger than HFSPLUS_ATTR_MAX_STRLEN

Return -ERANGE rather than -EOPNOTSUPP if the length of xattr name is
larger than HFSPLUS_ATTR_MAX_STRLEN, because of the former errno is
consistent with the VFS interface.

Signed-off-by: Jie Liu <jeff.liu@oracle.com>
---
 fs/hfsplus/xattr.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/hfsplus/xattr.c b/fs/hfsplus/xattr.c
index 3c6136f..1ca58be 100644
--- a/fs/hfsplus/xattr.c
+++ b/fs/hfsplus/xattr.c
@@ -919,7 +919,7 @@ static int hfsplus_osx_getxattr(struct dentry *dentry, const char *name,
 		return -EINVAL;
 
 	if (len > HFSPLUS_ATTR_MAX_STRLEN)
-		return -EOPNOTSUPP;
+		return -ERANGE;
 
 	strcpy(xattr_name, XATTR_MAC_OSX_PREFIX);
 	strcpy(xattr_name + XATTR_MAC_OSX_PREFIX_LEN, name);
@@ -938,7 +938,7 @@ static int hfsplus_osx_setxattr(struct dentry *dentry, const char *name,
 		return -EINVAL;
 
 	if (len > HFSPLUS_ATTR_MAX_STRLEN)
-		return -EOPNOTSUPP;
+		return -ERANGE;
 
 	strcpy(xattr_name, XATTR_MAC_OSX_PREFIX);
 	strcpy(xattr_name + XATTR_MAC_OSX_PREFIX_LEN, name);
-- 
1.8.3.2


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

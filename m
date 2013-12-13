Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id BA3B37F4E
	for <xfs@oss.sgi.com>; Fri, 13 Dec 2013 11:32:57 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id A07588F8065
	for <xfs@oss.sgi.com>; Fri, 13 Dec 2013 09:32:54 -0800 (PST)
Received: from mail-ob0-f177.google.com (mail-ob0-f177.google.com
	[209.85.214.177]) by cuda.sgi.com with ESMTP id
	bwl5GfVoT4k3WTKE (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Fri, 13 Dec 2013 09:32:11 -0800 (PST)
Received: by mail-ob0-f177.google.com with SMTP id vb8so2267782obc.22
	for <xfs@oss.sgi.com>; Fri, 13 Dec 2013 09:32:09 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20131213163916.GG20803@infradead.org>
References: <1386944873-16796-1-git-send-email-zwu.kernel@gmail.com>
	<1386944873-16796-5-git-send-email-zwu.kernel@gmail.com>
	<20131213163916.GG20803@infradead.org>
Date: Sat, 14 Dec 2013 01:32:08 +0800
Message-ID: <CAEH94LiFgi8kjFAtBe=2OsVr=4NEXijJN5w-d1H8+ifzcfoTOw@mail.gmail.com>
Subject: Re: [PATCH 4/5] xfs: add a new method xfs_vn_tmpfile()
From: Zhi Yong Wu <zwu.kernel@gmail.com>
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
Cc: "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>, linux-kernel mlist <linux-kernel@vger.kernel.org>, xfstests <xfs@oss.sgi.com>

On Sat, Dec 14, 2013 at 12:39 AM, Christoph Hellwig <hch@infradead.org> wrote:
> On Fri, Dec 13, 2013 at 10:27:52PM +0800, Zhi Yong Wu wrote:
>> From: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
>>
>> Add a new O_TMPFILE method to VFS inteface.
>> For more info, please refer to:
>>   http://oss.sgi.com/archives/xfs/2013-08/msg00336.html
>>
>> Signed-off-by: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
>> ---
>>  fs/xfs/xfs_iops.c |   22 ++++++++++++++++++++++
>>  1 files changed, 22 insertions(+), 0 deletions(-)
>>
>> diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
>> index eb55be5..b57cd89 100644
>> --- a/fs/xfs/xfs_iops.c
>> +++ b/fs/xfs/xfs_iops.c
>> @@ -39,6 +39,7 @@
>>  #include "xfs_da_btree.h"
>>  #include "xfs_dir2_priv.h"
>>  #include "xfs_dinode.h"
>> +#include "xfs_trans_space.h"
>>
>>  #include <linux/capability.h>
>>  #include <linux/xattr.h>
>> @@ -1051,6 +1052,25 @@ xfs_vn_fiemap(
>>       return 0;
>>  }
>>
>> +STATIC int
>> +xfs_vn_tmpfile(
>> +     struct inode    *dir,
>> +     struct dentry   *dentry,
>> +     umode_t         mode)
>> +{
>> +     struct xfs_inode *ip = NULL;
>> +     int             error;
>> +
>> +     error = xfs_create_tmpfile(XFS_I(dir), XFS_I(dir)->i_mount,
>
> No need to pass in the mount point here, the client can get it easily.
>
>> +                             mode, 0, &ip);
>
> Also no need for an always-zero argument.
Fixed, thanks.
>
>> +     if (error)
>> +             return -error;
>> +
>> +     d_instantiate(dentry, VFS_I(ip));
>
> Shouldn't this be a call to d_tmpfile() instead?
Yes, then it need to be called in xfs_create_tmpfile() just before
xfs_iunlink() is called.
>
> Also I'd suggest mergin this into the previous patch, so that we have
> one that actually adds O_TMPFILE support, and once place to write a nice
Merged them, thanks.
> good changelog.



-- 
Regards,

Zhi Yong Wu

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

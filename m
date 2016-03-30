Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id C2F1F7CAE
	for <xfs@oss.sgi.com>; Wed, 30 Mar 2016 17:11:17 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 91B3630404E
	for <xfs@oss.sgi.com>; Wed, 30 Mar 2016 15:11:17 -0700 (PDT)
Received: from mail-vk0-f46.google.com (mail-vk0-f46.google.com
	[209.85.213.46]) by cuda.sgi.com with ESMTP id EIH8zvK0JuQQ9GCO
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Wed, 30 Mar 2016 15:11:15 -0700 (PDT)
Received: by mail-vk0-f46.google.com with SMTP id e185so79987280vkb.1
	for <xfs@oss.sgi.com>; Wed, 30 Mar 2016 15:11:15 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20160330204119.GA8032@mguzik>
References: <1459348507-20406-1-git-send-email-mguzik@redhat.com>
	<20160330202655.GH30721@dastard> <20160330204119.GA8032@mguzik>
Date: Thu, 31 Mar 2016 00:11:14 +0200
Message-ID: <CAHc6FU6TbMdPta82aKcOa-z-tzqRdhYXB1i4z7=9dvZ=iqS3TQ@mail.gmail.com>
Subject: Re: [PATCH] xfs: fix a memory leak in xfs_get_acl on error
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
To: Mateusz Guzik <mguzik@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, XFS Developers <xfs@oss.sgi.com>

On Wed, Mar 30, 2016 at 10:41 PM, Mateusz Guzik <mguzik@redhat.com> wrote:
> On Thu, Mar 31, 2016 at 07:26:55AM +1100, Dave Chinner wrote:
>> On Wed, Mar 30, 2016 at 04:35:07PM +0200, Mateusz Guzik wrote:
>> > Signed-off-by: Mateusz Guzik <mguzik@redhat.com>
>> > ---
>> >  fs/xfs/xfs_acl.c | 3 ++-
>> >  1 file changed, 2 insertions(+), 1 deletion(-)
>> >
>> > diff --git a/fs/xfs/xfs_acl.c b/fs/xfs/xfs_acl.c
>> > index 2dad2b5..ce10c4c 100644
>> > --- a/fs/xfs/xfs_acl.c
>> > +++ b/fs/xfs/xfs_acl.c
>> > @@ -162,10 +162,11 @@ xfs_get_acl(struct inode *inode, int type)
>> >              */
>> >             if (error != -ENOATTR)
>> >                     acl = ERR_PTR(error);
>> > -           return acl;
>> > +           goto out;
>> >     }
>> >
>> >     acl = xfs_acl_from_disk(xfs_acl, len, XFS_ACL_MAX_ENTRIES(ip->i_mount));
>> > +out:
>> >     kmem_free(xfs_acl);
>> >     return acl;
>> >  }
>>
>> Hi Mateusz,
>>
>> It looks like we've already fixed this problem - can you check
>> 4.6-rc1 and if the leak is still there post an updated patch?
>>
>
> The patch which introuced the bug is not present in 4.6-rc1.

The patch is on the work.acl branch of
git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs.git.

Thanks,
Andreas

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

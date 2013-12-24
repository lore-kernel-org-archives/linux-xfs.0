Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 980A329DF8
	for <xfs@oss.sgi.com>; Mon, 23 Dec 2013 19:58:07 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 8CE99304053
	for <xfs@oss.sgi.com>; Mon, 23 Dec 2013 17:58:04 -0800 (PST)
Received: from mail-oa0-f47.google.com (mail-oa0-f47.google.com
	[209.85.219.47]) by cuda.sgi.com with ESMTP id 7EC8qVhdCdD3EljL
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 23 Dec 2013 17:58:03 -0800 (PST)
Received: by mail-oa0-f47.google.com with SMTP id k1so6408569oag.34
	for <xfs@oss.sgi.com>; Mon, 23 Dec 2013 17:58:02 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20131224005506.GL3220@dastard>
References: <1387326161-24530-1-git-send-email-zwu.kernel@gmail.com>
	<1387326161-24530-3-git-send-email-zwu.kernel@gmail.com>
	<20131224005506.GL3220@dastard>
Date: Tue, 24 Dec 2013 09:58:02 +0800
Message-ID: <CAEH94LjS9c==qtoMvWr=tiut+aFQF++3RnNU2+0Hzyj=SVWAdQ@mail.gmail.com>
Subject: Re: [PATCH v2 2/3] xfs: add O_TMPFILE support
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
To: Dave Chinner <david@fromorbit.com>, Christoph Hellwig <hch@infradead.org>
Cc: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>, xfstests <xfs@oss.sgi.com>

On Tue, Dec 24, 2013 at 8:55 AM, Dave Chinner <david@fromorbit.com> wrote:
> On Wed, Dec 18, 2013 at 08:22:40AM +0800, Zhi Yong Wu wrote:
>> From: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
>>
>> Add two functions xfs_create_tmpfile() and xfs_vn_tmpfile()
>> to support O_TMPFILE file creation.
>>
>> In contrast to xfs_create(), xfs_create_tmpfile() has a different
>> log reservation to the regular file creation because there is no
>> directory modification, and doesn't check if an entry can be added
>> to the directory, but the reservation quotas is required appropriately,
>> and finally its inode is added to the unlinked list.
>>
>> xfs_vn_tmpfile() add one O_TMPFILE method to VFS interface and directly
>> invoke xfs_create_tmpfile().
>
> There's minor stuff I could ask you to change, but I think this is
> good enough for initial support of O_TMPFILE.
>
> Reviewed-by: Dave Chinner <dchinner@redhat.com>
Great, thanks a lot for your amazing Chrismas gift. Dave and
Christoph, Merry Chrismas!

>
> --
> Dave Chinner
> david@fromorbit.com



-- 
Regards,

Zhi Yong Wu

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

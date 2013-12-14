Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id AABF67F52
	for <xfs@oss.sgi.com>; Sat, 14 Dec 2013 05:44:04 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 86DB18F8050
	for <xfs@oss.sgi.com>; Sat, 14 Dec 2013 03:44:01 -0800 (PST)
Received: from mail-ob0-f174.google.com (mail-ob0-f174.google.com
	[209.85.214.174]) by cuda.sgi.com with ESMTP id
	nmruq4BsVAVjg6bo (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Sat, 14 Dec 2013 03:44:00 -0800 (PST)
Received: by mail-ob0-f174.google.com with SMTP id wn1so3038688obc.5
	for <xfs@oss.sgi.com>; Sat, 14 Dec 2013 03:43:59 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <52AC3EF1.6090106@oracle.com>
References: <1386944873-16796-1-git-send-email-zwu.kernel@gmail.com>
	<1386944873-16796-2-git-send-email-zwu.kernel@gmail.com>
	<20131213163211.GD20803@infradead.org>
	<52AC3EF1.6090106@oracle.com>
Date: Sat, 14 Dec 2013 19:43:59 +0800
Message-ID: <CAEH94LiiFjDM9GT6ncGYuQmC+T-6w-r1_svuqGZ43Bsd9Zt64w@mail.gmail.com>
Subject: Re: [PATCH 1/5] xfs: factor prid related codes into
	xfs_get_initial_prid()
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
To: Jeff Liu <jeff.liu@oracle.com>
Cc: Christoph Hellwig <hch@infradead.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>, linux-kernel mlist <linux-kernel@vger.kernel.org>, xfstests <xfs@oss.sgi.com>

On Sat, Dec 14, 2013 at 7:20 PM, Jeff Liu <jeff.liu@oracle.com> wrote:
> On 12/14 2013 00:32 AM, Christoph Hellwig wrote:
>>> +static inline prid_t xfs_get_initial_prid(struct xfs_inode *dp)
>>> +{
>>> +    if (dp->i_d.di_flags & XFS_DIFLAG_PROJINHERIT)
>>> +            return xfs_get_projid(dp);
>>> +    else
>>> +            return XFS_PROJID_DEFAULT;
>>> +}
>>
>> You could skip the else here.
> Except that, I'd suggest we move this helper to proper header file with
> further refactoring in xfs_symlink(), and it could be a separate patch.
Good point, will apply it, thanks.

>
> Thanks,
> -Jeff



-- 
Regards,

Zhi Yong Wu

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

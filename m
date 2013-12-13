Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 187C77F4E
	for <xfs@oss.sgi.com>; Fri, 13 Dec 2013 11:36:58 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id F1FFC8F8049
	for <xfs@oss.sgi.com>; Fri, 13 Dec 2013 09:36:54 -0800 (PST)
Received: from mail-oa0-f48.google.com (mail-oa0-f48.google.com
	[209.85.219.48]) by cuda.sgi.com with ESMTP id yHBWFKyivLxIX4xC
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 13 Dec 2013 09:36:48 -0800 (PST)
Received: by mail-oa0-f48.google.com with SMTP id l6so2398160oag.21
	for <xfs@oss.sgi.com>; Fri, 13 Dec 2013 09:36:47 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20131213164154.GH20803@infradead.org>
References: <1386944873-16796-1-git-send-email-zwu.kernel@gmail.com>
	<1386944873-16796-6-git-send-email-zwu.kernel@gmail.com>
	<20131213164154.GH20803@infradead.org>
Date: Sat, 14 Dec 2013 01:36:47 +0800
Message-ID: <CAEH94LimS8mUCFwmnVi876mG9GB7DWsqG9p1O=R41XJ3-u1NQg@mail.gmail.com>
Subject: Re: [PATCH 5/5] xfs: allow linkat() on O_TMPFILE files
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

On Sat, Dec 14, 2013 at 12:41 AM, Christoph Hellwig <hch@infradead.org> wrote:
> On Fri, Dec 13, 2013 at 10:27:53PM +0800, Zhi Yong Wu wrote:
>> From: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
>>
>> Enable O_TMPFILE support in linkat().
>> For more info, please refer to:
>>   http://oss.sgi.com/archives/xfs/2013-08/msg00341.html
>
> Generall you should provide all reasonable information in the changelog
> instead of linking to it.
will apply this, thanks.
>
>> +     if (sip->i_d.di_nlink == 0)
>> +             tres = &M_RES(mp)->tr_link_tmpfile;
>> +     else
>> +             tres = &M_RES(mp)->tr_link;
>
> As mentioned before I think Dave wanted you to always use the same
> reservation, but I'll leave that discussion to him.
If as you said, when some tons of regular files are created, it won't
waste some disk space? e.g. some files want to reserve some space, but
get NOSPACE due to other files reserving additional space?

>
>> +/* For creating a link to an O_TMPFILE inode, except modifying
>> + * those metadata for regular inode, we still need to remove an inode
>> + * from unlinked list at first. That is,  we can modify:
>> + *    the agi hash list and counters: sector size
>> + *    the on disk inode before ours in the agi hash list: inode cluster size
>> + */
>
> We always have an emptry content
Done, thanks.
>
> /*
>
> line at the beginning of comments in XFS and the Linux kernel in
> general.
>



-- 
Regards,

Zhi Yong Wu

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

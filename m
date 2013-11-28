Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id BB0E97F4E
	for <xfs@oss.sgi.com>; Wed, 27 Nov 2013 20:37:31 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 4FAC5AC001
	for <xfs@oss.sgi.com>; Wed, 27 Nov 2013 18:37:31 -0800 (PST)
Received: from mail-ob0-f182.google.com (mail-ob0-f182.google.com
	[209.85.214.182]) by cuda.sgi.com with ESMTP id
	J9yPesg06qeIFoTk (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Wed, 27 Nov 2013 18:37:30 -0800 (PST)
Received: by mail-ob0-f182.google.com with SMTP id wp4so8293696obc.13
	for <xfs@oss.sgi.com>; Wed, 27 Nov 2013 18:37:29 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20131125135149.GD30189@infradead.org>
References: <1385379154-3802-1-git-send-email-zwu.kernel@gmail.com>
	<1385379154-3802-5-git-send-email-zwu.kernel@gmail.com>
	<20131125135149.GD30189@infradead.org>
Date: Thu, 28 Nov 2013 10:37:29 +0800
Message-ID: <CAEH94LiiRgQGzf+YGy23SJDhHJ_1grC3kniLqXDdUQFJ09McTA@mail.gmail.com>
Subject: Re: [RFC PATCH 4/4] xfs: allow linkat() on O_TMPFILE files
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
Cc: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>, xfstests <xfs@oss.sgi.com>

On Mon, Nov 25, 2013 at 9:51 PM, Christoph Hellwig <hch@infradead.org> wrote:
>> -     ASSERT(ip->i_d.di_nlink > 0);
>> +     if ((VFS_I(ip)->i_nlink == 0) &&
>> +         !(VFS_I(ip)->i_state & I_LINKABLE))
>> +             ASSERT(ip->i_d.di_nlink > 0);
>
>         ASSERT(ip->i_d.di_nlink > 0 || (VFS_I(ip)->i_state & I_LINKABLE));
This is wrong, and it should be
          ASSERT(ip->i_d.di_nlink > 0 || !(VFS_I(ip)->i_state & I_LINKABLE));

>
>> @@ -1498,7 +1503,14 @@ xfs_link(
>>       tp = xfs_trans_alloc(mp, XFS_TRANS_LINK);
>>       cancel_flags = XFS_TRANS_RELEASE_LOG_RES;
>>       resblks = XFS_LINK_SPACE_RES(mp, target_name->len);
>> -     error = xfs_trans_reserve(tp, &M_RES(mp)->tr_link, resblks, 0);
>> +
>> +     if ((VFS_I(sip)->i_nlink == 0) &&
>> +         (VFS_I(sip)->i_state & I_LINKABLE))
>> +             tres = &M_RES(mp)->tr_link_tmpfile;
>> +     else
>> +             tres = &M_RES(mp)->tr_link;
>
> Just check i_nlink, and for consistency it might make sense to just use
> the xfs_inode one.  The VFS already made sure we don't inodes with
but struct xfs_inode has no stuff similar to i_nlink....

> I_LINKABLE and a zero link count.
No, pls see the chunk of code:
int vfs_link(struct dentry *old_dentry, struct inode *dir, struct
dentry *new_dentry)
{
...
    /* Make sure we don't allow creating hardlink to an unlinked file */
    if (inode->i_nlink == 0 && !(inode->i_state & I_LINKABLE))
        error =  -ENOENT;
    else if (max_links && inode->i_nlink >= max_links)
        error = -EMLINK;
    else
        error = dir->i_op->link(old_dentry, dir, new_dentry);

    if (!error && (inode->i_state & I_LINKABLE)) {
        spin_lock(&inode->i_lock);
        inode->i_state &= ~I_LINKABLE;
        spin_unlock(&inode->i_lock);
    }
...
}

When xfs_link() is called, I_LINKABLE flag isn't cleared.

>
>> +     if ((VFS_I(sip)->i_nlink == 0) &&
>> +         (VFS_I(sip)->i_state & I_LINKABLE)) {
>
> Same here.
>



-- 
Regards,

Zhi Yong Wu

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

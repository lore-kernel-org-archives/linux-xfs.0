Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-oi0-f67.google.com ([209.85.218.67]:33993 "EHLO
        mail-oi0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753090AbdAJHy2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 10 Jan 2017 02:54:28 -0500
Received: by mail-oi0-f67.google.com with SMTP id 3so68483881oih.1
        for <linux-xfs@vger.kernel.org>; Mon, 09 Jan 2017 23:54:28 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20170109211749.GC14038@birch.djwong.org>
References: <1483967189-27313-1-git-send-email-amir73il@gmail.com>
 <1483967189-27313-2-git-send-email-amir73il@gmail.com> <20170109155158.GA19396@infradead.org>
 <CAOQ4uxi4AWSN89MtZH6f0B9aC_AMmC6bxbUCAh9LMU4G+Z9U1A@mail.gmail.com> <20170109211749.GC14038@birch.djwong.org>
From: Amir Goldstein <amir73il@gmail.com>
Date: Tue, 10 Jan 2017 09:54:27 +0200
Message-ID: <CAOQ4uxj7A+upJXkjC5ysxtKnqWwYJxcWhWy=u3i=rnCxhptx2g@mail.gmail.com>
Subject: Re: [PATCH v6 1/3] xfs: fix the size of xfs_mode_to_ftype table
Content-Type: text/plain; charset=UTF-8
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Christoph Hellwig <hch@infradead.org>, Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org

On Mon, Jan 9, 2017 at 11:17 PM, Darrick J. Wong
<darrick.wong@oracle.com> wrote:
> On Mon, Jan 09, 2017 at 07:21:25PM +0200, Amir Goldstein wrote:
>> On Mon, Jan 9, 2017 at 5:51 PM, Christoph Hellwig <hch@infradead.org> wrote:
>> > On Mon, Jan 09, 2017 at 03:06:27PM +0200, Amir Goldstein wrote:
>> >> Fix the size of the xfs_mode_to_ftype conversion table,
>> >> which was too small to handle an invalid value of mode=S_IFMT.
>> >>
>> >> Use a convenience macro S_DT(mode) to convert from
>> >> mode to dirent file type and change the name of the table
>> >> to xfs_dtype_to_ftype to correctly describe its index values.
>> >
>> > This looks like an awful lot of magic.  Would a switch statement
>> > generate so much worse code?
>>
>> I doubt it really matters that much, so it's down to a matter of taste.
>> I personally like the existing map table better than switch if anyone cares ;-)
>> but I think that the strongest argument in favor of the existing code
>> is that it works, so no reason to change it.
>> IMHO, this minor fix and cleanup do not justify switching the code over to
>> switch statement.
>
> I can't feed a garbage index to a switch statement and have it fly
> off the end of an array; plus we can throw asserts in a default: case.
>

I think we are in agreement that ASSERT for malformed on-disk data
is a bad idea, as patch 2 demonstrates, and that we are better off
returning -EFSCORRUPTED is such cases.

OK, so just that we are all clear on what I think you are suggesting:

1. retire xfs_mode_to_ftype[] table
2. create helper xfs_mode_to_ftype() that uses a switch statement
    and returns XFS_DIR3_FT_UNKNOWN for invalid modes
3. change xfs_dentry_to_name() to return -EFSCORRUPTED for unknown ftype
    and check return value on call sites where mode come from disk
    (e.g. xfs_generic_create(), xfs_vn_link(), xfs_vn_rename())
4. convert call sites xfs_dentry_to_name(n,d,0) (e.g.
xfs_cleanup_inode()) to use
    a helper xfs_dentry_to_name_unknown(n,d) which sets ftype to unknown
    instead of calling xfs_mode_to_ftype()
5. in xfs_dinode_verify(), sanity check that di_mode is a valid ftype

Should I cook this patch?

Amir.

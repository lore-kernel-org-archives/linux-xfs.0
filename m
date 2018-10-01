Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-ed1-f44.google.com ([209.85.208.44]:43616 "EHLO
        mail-ed1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729480AbeJAVyQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 1 Oct 2018 17:54:16 -0400
MIME-Version: 1.0
References: <CA+1E3rLXPwzfO3ro49ZVg7RfpYon5YDB6Y_zqu60ivpgn4wenw@mail.gmail.com>
 <2a92fff4-d005-835a-3bd7-a328b008857f@gmx.com>
In-Reply-To: <2a92fff4-d005-835a-3bd7-a328b008857f@gmx.com>
From: Joshi <joshiiitr@gmail.com>
Date: Mon, 1 Oct 2018 20:45:45 +0530
Message-ID: <CA+1E3rJmoeVGhokE0phbH1kv_+izT0W14ZijWnjVbU0PPqRwOg@mail.gmail.com>
Subject: Re: cross-fs copy support
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: quwenruo.btrfs@gmx.com
Cc: linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org

Sorry if my post was not clear enough. I picked the term "cross-fs"
from the implementation of vfs_copy_file_range.
Below snippet, inside vfs_copy_file_range -
1578         /* this could be relaxed once a method supports cross-fs copie=
s */
1579         if (inode_in->i_sb !=3D inode_out->i_sb)
1580                 return -EXDEV;

And I was not trying reflink for copy, rather I just used example code
for copy_file_range syscall -
http://man7.org/linux/man-pages/man2/copy_file_range.2.html
This code creates a new file first, and later issues "copy_file_range"
for copying. I was trying this sort of copy among files residing on
btrfs, ext4, and xfs.
Although vfs_copy_file_range internally uses clone_file_range (which
would be true for btrfs and xfs).
On Mon, Oct 1, 2018 at 8:18 PM Qu Wenruo <quwenruo.btrfs@gmx.com> wrote:
>
>
>
> On 2018/10/1 =E4=B8=8B=E5=8D=8810:32, Joshi wrote:
> > I was wondering about the cross-fs copy through copy_file_range.
>
> The term "cross-fs" looks pretty confusing.
>
> If you mean "cross-subvolume", then it should work without problem in btr=
fs.
>
> If you mean reflink across two different file systems (not matter the
> same fs type or not).
> Then it's impossible to work.
>
> Reflink (clone_file_range) works by inserting data pointers into the
> filesystem other than really copying the data.
> Thus if the source is outside of the fs, it's really impossible to work,
> as the source pointer/data is completely out of control of the dest fs.
>
> > It seems current implement has below check, that disables such copy.
> >
> > 1577         /* this could be relaxed once a method supports cross-fs c=
opies */
> > 1578         if (inode_in->i_sb !=3D inode_out->i_sb)
> > 1579                 return -EXDEV;
> >
> > May I know what are the thoughts behind disabling cross-fs copy?
> > Code has the comment "once a method supports", but that leaves me
> > wondering exactly what 'method' is expected, and from whom.
> >
> > I disabled the check, and copy across volumes seemed to work fine. At
> > least for a single file (1G size), with no data mismatch, and faster
> > speed than regular copy.
>
> Please provide the steps or script about how you did the reflink, in
> case I misunderstand your "cross-fs" definition.
>
> And just in case you're really doing cross filesystem reflink, please
> also run "btrfs check" on both fs.
>
> Thanks,
> Qu
>
>


--=20
Joshi

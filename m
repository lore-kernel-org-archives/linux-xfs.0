Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-lf1-f65.google.com ([209.85.167.65]:35844 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726828AbeJ1XVl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 28 Oct 2018 19:21:41 -0400
Received: by mail-lf1-f65.google.com with SMTP id h192so4155620lfg.3
        for <linux-xfs@vger.kernel.org>; Sun, 28 Oct 2018 07:36:52 -0700 (PDT)
MIME-Version: 1.0
References: <20181026201943.24131-1-stefanrin@gmail.com> <3e653734-6470-3160-58e8-5bdf866dbd87@sandeen.net>
 <5228ed5f-b238-1596-a829-6bf482da7e2b@sandeen.net> <CAAxjCExbUX1hDDV_0yK5Uu1eGf3aC8XT0CN-eL66+9GNDtdRVg@mail.gmail.com>
In-Reply-To: <CAAxjCExbUX1hDDV_0yK5Uu1eGf3aC8XT0CN-eL66+9GNDtdRVg@mail.gmail.com>
From: Stefan Ring <stefanrin@gmail.com>
Date: Sun, 28 Oct 2018 15:36:41 +0100
Message-ID: <CAAxjCEyu9e4=umUMzxXZvDFHABwO6NVwihZbV2+gdwWJC8NkCQ@mail.gmail.com>
Subject: Re: [PATCH 0/5] v4 Try to squash metadump data leaks
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: linux-xfs@vger.kernel.org

On Sun, Oct 28, 2018 at 1:38 PM Stefan Ring <stefanrin@gmail.com> wrote:
>
> On Sat, Oct 27, 2018 at 1:33 AM Eric Sandeen <sandeen@sandeen.net> wrote:
> >
> > Also, here's an old script I had lying around to test metadump.  It's hacky, sorry.
> >
> > Things to watch out for... it looks for an "fsstress" binary from xfstests, so adjust that path.
> > It freezes and unfreezes the test filesystem, if your mount fails it'll freeze
> > the fs you're on.  ;)  There may be other rough spots.
> >
> > It also runs the xfs_metadump/xfs_db in your path; you could change that to a
> > local ./xfs_metadump to run db/xfs_db from a git tree instead for testing
> > w/o make install.
> >
> > Right now this is detecting some corruption induced by metadump/mdrestore
> > with your full patchset in place, FWIW.
> >
> > Sorry I didn't send this sooner, kinda forgot I had it.  really should turn it into an xfstest.
>
> Thanks! The corruption is caused by the last patch in the series. So
> dev inodes can have attribute forks. I will have to zap the data and
> the attr area separately.

Ok, this is a better replacement for the fifth patch (copy/pasted into
in-browser e-mail editor, might have broken formatting).

Apparently the dev's inode contents are xfs_dev_t, and the rest of the
data fork can be cleared. The attribute fork is handled later in
process_inode.

--- a/db/metadump.c
+++ b/db/metadump.c
@@ -2270,6 +2270,25 @@ process_inode_data(
        return 1;
 }

+static int
+process_dev_inode(
+       xfs_dinode_t            *dip)
+{
+       if (XFS_DFORK_NEXTENTS(dip, XFS_DATA_FORK)) {
+               if (show_warnings)
+                       print_warning("inode %llu has unexpected extents",
+                                     (unsigned long long)cur_ino);
+               return 0;
+       } else {
+               if (zero_stale_data) {
+                       unsigned int size = sizeof(xfs_dev_t);
+                       memset(XFS_DFORK_DPTR(dip) + size, 0,
+                                       XFS_DFORK_DSIZE(dip, mp) - size);
+               }
+               return 1;
+       }
+}
+
 /*
  * when we process the inode, we may change the data in the data and/or
  * attribute fork if they are in short form and we are obfuscating names.
@@ -2322,7 +2341,10 @@ process_inode(
                case S_IFREG:
                        success = process_inode_data(dip, TYP_DATA);
                        break;
-               default: ;
+               default:
+                       success = process_dev_inode(dip);
+                       need_new_crc = 1;
+                       break;
        }
        nametable_clear();

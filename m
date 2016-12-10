Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:33954 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751194AbcLJIEm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 10 Dec 2016 03:04:42 -0500
Received: by mail-wm0-f67.google.com with SMTP id g23so1038077wme.1
        for <linux-xfs@vger.kernel.org>; Sat, 10 Dec 2016 00:04:41 -0800 (PST)
MIME-Version: 1.0
From: Amir Goldstein <amir73il@gmail.com>
Date: Sat, 10 Dec 2016 10:04:39 +0200
Message-ID: <CAOQ4uxi_x+7Kc3P_xMr4O3DUKK7uhkfoUoyQsp7PYnxJaeLzcw@mail.gmail.com>
Subject: [RFC] Preparing for XFS reflink D-day
Content-Type: text/plain; charset=UTF-8
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org

Dave,

I would like to have some system's storage pre-formatted
with rmapbt and reflink support without allowing reflink until
the day comes where the feature is declared stable.

I realize that rmapbt/reflink features are declared unstable and
bugs could certainly be lurking without doing any reflinks at all.
However, I estimate the the class of bugs introduces by heavily
reflinked file systems is going to take more time to tame.

Considering these options for said systems:
1. kernel v4.8.y or v4.9.y and mkfs.xfs -m rmapbt=1
2. kernel v4.9.y and mkfs.xfs -m rmapbt=1
3. kernel v4.9.y and mkfs.xfs -m rmapbt=1,reflink=1
    and new mount option -onoreflink
4. kernel v4.9.y and mkfs.xfs -m rmapbt=1,reflinkbt=1
    (separate rocomapt features reflinkbt from reflink)

Options 1-2 would require adding support in xfs_admin to
enable reflink on an existing fs (by cloning the bmbt).

Option 3 would require adding a simple noreflink
mount option to disable reflink related ops.

Option 4 requires changing mkfs.xfs before 4.9 release
and possibly setting recompat feature reflink on first file
reflink. There are several precedents to this sort of  "set
on first use" feature in ext4, not sure if there are any in xfs.

The benefit of having this functionality is that others,
like me, could provide more testing for the refcount<=1
use case. I myself intend to test refcount>1 as well, but
the goal of getting recount<=1 ready for production is
higher priority.

Another benefit from option #4 is that you may be able
to declare rmapbt=1,reflinkbt=1 stable and/or default
mkfs options prior to declaring reflink=1 stable.

Which, if any, of the options above would you be willing
to endorse?

Darrick,

I seem to recall you taking about enabling reflink on existing
fs sometime before, but I could not find that reference.
I suppose you had an idea of how this should be done?

Amir.


* D-Day of course stands for Darrick's-day ;-)

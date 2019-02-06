Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-ot1-f46.google.com ([209.85.210.46]:44940 "EHLO
        mail-ot1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726879AbfBFVNK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 6 Feb 2019 16:13:10 -0500
Received: by mail-ot1-f46.google.com with SMTP id e24so5243191otp.11
        for <linux-xfs@vger.kernel.org>; Wed, 06 Feb 2019 13:13:10 -0800 (PST)
MIME-Version: 1.0
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 6 Feb 2019 13:12:59 -0800
Message-ID: <CAPcyv4jyCDJTpGZB6qVX7_FiaxJfDzWA1cw8dfPjHM2j3j3yqQ@mail.gmail.com>
Subject: [LSF/MM TOPIC] The end of the DAX experiment
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: lsf-pc@lists.linux-foundation.org
Cc: linux-nvdimm <linux-nvdimm@lists.01.org>, linux-xfs <linux-xfs@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-ext4 <linux-ext4@vger.kernel.org>

Before people get too excited this isn't a proposal to kill DAX. The
topic proposal is a discussion to resolve lingering open questions
that currently motivate ext4 and xfs to scream "EXPERIMENTAL" when the
current DAX facilities are enabled. The are 2 primary concerns to
resolve. Enumerate the remaining features/fixes, and identify a path
to implement it all without regressing any existing application use
cases.

An enumeration of remaining projects follows, please expand this list
if I missed something:

* "DAX" has no specific meaning by itself, users have 2 use cases for
"DAX" capabilities: userspace cache management via MAP_SYNC, and page
cache avoidance where the latter aspect of DAX has no current api to
discover / use it. The project is to supplement MAP_SYNC with a
MAP_DIRECT facility and MADV_SYNC / MADV_DIRECT to indicate the same
dynamically via madvise. Similar to O_DIRECT, MAP_DIRECT would be an
application hint to avoid / minimiize page cache usage, but no strict
guarantee like what MAP_SYNC provides.

* Resolve all "if (dax) goto fail;" patterns in the kernel. Outside of
longterm-GUP (a topic in its own right) the projects here are
XFS-reflink and XFS-realtime-device support. DAX+reflink effectively
requires a given physical page to be mapped into two different inodes
at different (page->index) offsets. The challenge is to support
DAX-reflink without violating any existing application visible
semantics, the operating assumption / strawman to debate is that
experimental status is not blanket permission to go change existing
semantics in backwards incompatible ways.

* Deprecate, but not remove, the DAX mount option. Too many flows
depend on the option so it will never go away, but the facility is too
coarse. Provide an option to enable MAP_SYNC and
more-likely-to-do-something-useful-MAP_DIRECT on a per-directory
basis. The current proposal is to allow this property to only be
toggled while the directory is empty to avoid the complications of
racing page invalidation with new DAX mappings.


Secondary projects, i.e. important but I would submit are not in the
critical path to removing the "experimental" designation:
* Filesystem-integrated badblock management. Hook up the media error
notifications from libnvdimm to the filesystem to allow for operations
like "list files with media errors" and "enumerate bad file offsets on
a granulatiy smaller than a page". Another consideration along these
lines is to integrate machine-check-handling and dynamic error
notification into a filesystem interface. I've heard complaints that
the sigaction() based mechanism to receive BUS_MCEERR_* information,
while sufficient for the "System RAM" use case, is not precise enough
for the "Persistent Memory / DAX" use case where errors are repairable
and sub-page error information is useful.

* Userfaultfd for file-backed mappings and DAX


Ideally all the usual DAX, persistent memory, and GUP suspects could
be in the room to discuss this:
* Jan Kara
* Dave Chinner
* Christoph Hellwig
* Jeff Moyer
* Johannes Thumshirn
* Matthew Wilcox
* John Hubbard
* J=C3=A9r=C3=B4me Glisse
* MM folks for the reflink vs 'struct page' vs Xarray considerations

Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:52621 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1758616AbdEWLKM (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 23 May 2017 07:10:12 -0400
Date: Tue, 23 May 2017 13:10:07 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] vfs: freeze filesystems just prior to reboot
Message-ID: <20170523111007.GH1230@quack2.suse.cz>
References: <20170519002032.GA21202@birch.djwong.org>
 <1495202431.1896310.982081664.066926F8@webmail.messagingengine.com>
 <20170519152734.qd4lf32e7wst4jdh@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170519152734.qd4lf32e7wst4jdh@thunk.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Theodore Ts'o <tytso@mit.edu>
Cc: Colin Walters <walters@verbum.org>, "Darrick J. Wong" <darrick.wong@oracle.com>, xfs <linux-xfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-ext4 <linux-ext4@vger.kernel.org>

On Fri 19-05-17 11:27:34, Ted Tso wrote:
> The other thing that would be useful is if grub2 would actually be
> able to replay the file system journal --- but given that grub2 is
> GPLv3, and both ext4 and xfs are GPLv2-only, and given that past
> attempts of teams attempting to do clean room reimplementations of
> complex code bases for licensing reasons only (cough, make_ext4fs,
> *cough*) have not necessarily turned out well, I'm at least not going
> to hold my breath.

Boot loader really should *not* write to the filesystem. Firstly, it would
have to be completely separate codebase running under very different
constraints (real mode, no real memory management, etc) so there's no easy
way to share the code with any other userspace libraries and thus the code
will be inherently buggy. Secondly, think of stuff like suspend to disk -
if someone touches the filesystem in any way under the hands of suspended
kernel, file system corruption is very likely to follow sooner or later.
Just last year, I've spent couple of interesting days hunting down ext4
corruption on s390 only to find out that the boot procedure(*) there ended
up replaying the journal under suspended kernel...

(*) Just for the ones interested in mainframe woes: s390 in SLES doesn't
use grub to parse the filesystem (as it is too difficult to access some
storage types from the boot loader AFAIU) so it uses "first-stage" Linux
kernel to mount the root filesystem, finds proper kernel image there and
then kexecs into it...

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

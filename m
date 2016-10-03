Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx3-phx2.redhat.com ([209.132.183.24]:45258 "EHLO
        mx3-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751989AbcJCRtf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 3 Oct 2016 13:49:35 -0400
Date: Mon, 3 Oct 2016 13:49:25 -0400 (EDT)
From: CAI Qian <caiqian@redhat.com>
Message-ID: <1937480340.100083.1475516965286.JavaMail.zimbra@redhat.com>
In-Reply-To: <20161003013737.GR19539@ZenIV.linux.org.uk>
References: <CA+55aFxrqCng2Qxasc9pyMrKUGFjo==fEaFT1vkH9Lncte3RgQ@mail.gmail.com> <20160917082007.GA6489@ZenIV.linux.org.uk> <20160917190023.GA8039@ZenIV.linux.org.uk> <20160923190032.GA25771@ZenIV.linux.org.uk> <2131586457.763354.1475242373422.JavaMail.zimbra@redhat.com> <1415238593.811146.1475257337058.JavaMail.zimbra@redhat.com> <774397084.821469.1475260403929.JavaMail.zimbra@redhat.com> <20161003013737.GR19539@ZenIV.linux.org.uk>
Subject: Re: [RFC][CFT] splice_read reworked
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Dave Chinner <david@fromorbit.com>, linux-xfs <linux-xfs@vger.kernel.org>, xfs@oss.sgi.com, Jens Axboe <axboe@kernel.dk>, Nick Piggin <npiggin@gmail.com>, linux-fsdevel@vger.kernel.org



----- Original Message -----
> From: "Al Viro" <viro@ZenIV.linux.org.uk>
> To: "CAI Qian" <caiqian@redhat.com>
> Cc: "Linus Torvalds" <torvalds@linux-foundation.org>, "Dave Chinner" <david@fromorbit.com>, "linux-xfs"
> <linux-xfs@vger.kernel.org>, xfs@oss.sgi.com, "Jens Axboe" <axboe@kernel.dk>, "Nick Piggin" <npiggin@gmail.com>,
> linux-fsdevel@vger.kernel.org
> Sent: Sunday, October 2, 2016 9:37:37 PM
> Subject: Re: [RFC][CFT] splice_read reworked
> 
> On Fri, Sep 30, 2016 at 02:33:23PM -0400, CAI Qian wrote:
> 
> OK, the immeditate trigger is
> 	* sendfile() from something that uses seq_read to a regular file.
> Does sb_start_write() around the call of do_splice_direct() (as always),
> which ends up calling default_file_splice_read() (again, as usual), which
> ends up calling ->read() of the source, i.e. seq_read().  No changes there.
>  
> 	* sb_start_write() can be called under ->i_mutex.  The latter is
> on overlayfs inode, the former is done to upper layer in that overlayfs.
> Nothing new, again.
> 
> 	* ->i_mutex can be taken under ->cred_guard_mutex.  Yes, it can -
> in open_exec().  Again, no changes.
> 
> 	* ->cred_guard_mutex can be taken in ->show() of a seq_file,
> namely /proc/*/auxv...  Argh, ->cred_guard_mutex whack-a-mole strikes
> again...
> 
> OK, I think essentially the same warning had been triggerable since _way_
> back.  All changes around splice have no effect on it.
> 
> Look: to get a deadlock we need
> 	(1) sendfile from /proc/<pid>/auxv to a regular file on upper layer of
> overlayfs requesting not to freeze the target.
> 	(2) attempt to freeze it blocking until (1) is done.
> 	(3) directory modification on overlayfs trying to request not to freeze
> the upper layer and blocking until (2) is done.
> 	(4) execve() in <pid> holding ->cred_guard_mutex, trying to open
> something in overlayfs and getting blocked on directory lock, held by (3).
> 
> Now (1) gets around to reading from /proc/<pid>/auxv, which blocks on
> ->cred_guard_mutex.  Mentioning of seq_read itself holding locks is
> irrelevant;
> what matters is that ->read() grabs ->cred_guard_mutex.
> 
> We used to have similar problems in /proc/*/environ and /proc/*/mem; looks
> like /proc/*/environ needs to get the treatment similar to e268337dfe26 and
> b409e578d9a4.
> 
You are right. This is also reproducible on v4.8 mainline.
    CAI Qian

Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:56582 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S935074AbcI0QfZ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 27 Sep 2016 12:35:25 -0400
Subject: Re: Clarification required about xfs_metadump and xfs_mdrestore
References: <CAOSFFyjWR4ASud5aSoYTJKweWA244oMwT9_LRSzwnr0Qftg7Eg@mail.gmail.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <c68bb26d-f296-1280-5d66-c53afe18191d@sandeen.net>
Date: Tue, 27 Sep 2016 11:35:23 -0500
MIME-Version: 1.0
In-Reply-To: <CAOSFFyjWR4ASud5aSoYTJKweWA244oMwT9_LRSzwnr0Qftg7Eg@mail.gmail.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: xfs@oss.sgi.com, linux-xfs <linux-xfs@vger.kernel.org>

On 9/27/16 8:49 AM, murali krishna wrote:
> Hi All,
> 
> Got your email id from Nathan Scott. 
> 
> Could you please clarify the reasons behind stating below statement in
> xfs_metadump man page.
> 
> /xfs_metadump should not be used for any purposes other than for
>        debugging and reporting filesystem problems
> /
> Man page: http://man7.org/linux/man-pages/man8/xfs_metadump.8.html <http://man7.org/linux/man-pages/man8/xfs_metadump.8.html>

Well, that's the only thing it's designed and tested for.

> I am trying to encrypt my existing xfs drive (/dev/sda2) and would
> like to backup metadata using xfs_metadump and restore it back using
> xfs_mdrestore after encrypting my drive. In order to retain entire
> contents of my realtime partition (/dev/sda1), I need to perform this
> step.

I don't know what mechanism you plan to use for encryption, but this
sounds like a recipe for disaster.  Offhand I can't think of any existing
block device encryption method for which this would work.

> Can I use xfs_metadump to backup meta-data of xfs  and restore it back successfully ?

Probably, but we did not design it or test it for that.

> Why xfs_metadump should be specifically used as debugging tool ? Please clarify ?

Because that's what it's designed for.

You /could/ use a big wrench as a hammer, and you /might/ get the nail
in, or you might smash your fingers, bend the nail, damage the piece of
wood, or any other number of unexpected failures from using the wrong
tool for the job...  ;)

-Eric

> Thanks in Advance,
> Murali
> 
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
> 

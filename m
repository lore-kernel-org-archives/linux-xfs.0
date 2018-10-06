Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from smarthost03c.mail.zen.net.uk ([212.23.1.22]:48960 "EHLO
        smarthost03c.mail.zen.net.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725815AbeJFWcI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 6 Oct 2018 18:32:08 -0400
Date: Sat, 6 Oct 2018 16:28:22 +0100
From: Dave Howorth <dave@howorth.org.uk>
Subject: Re: XFS mount problem
Message-ID: <20181006162822.6c9abd75@acer-suse.lan>
In-Reply-To: <93a3ae91-b69a-a8a6-f196-c539333e3027@sandeen.net>
References: <20181006140317.148fe46d@acer-suse.lan>
        <93a3ae91-b69a-a8a6-f196-c539333e3027@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: linux-xfs@vger.kernel.org

On Sat, 6 Oct 2018 09:22:37 -0500
Eric Sandeen <sandeen@sandeen.net> wrote:

Thanks for your reply, Eric.

> The log is dirty as expected.  But at least xfs_repair thinks it is an
> xfs filesystem, and it looks intact.
> 
> Try 
> 
> # mount /dev/dm-3 /srv/live-tv 

Hmm, that worked. Thanks. I'm not sure why that worked when my attempt
failed, although I do see in dmesg:

 [  467.743699] SGI XFS with ACLs, security attributes, no debug enabled
 [  467.744733] XFS (dm-3): unknown mount option [noacl].

So is that also the reason it failed at boot? I'm surprised because
that would seem to imply it's never been mounted using the information
in /etc/fstab before. I suppose it is possible because I only created
the filesystem a little while ago. Good news if so, since I can resume
mounting by label.

> and if that fails, type "dmesg" to show the kernel message, look
> towards the end to see what it thinks went wrong.

> Look at the end of "dmesg" output when mount fails.
> 
> -Eric

Thanks again, Dave

PS What's the list etiquette here about replies? I use claws and both
Reply and Reply-List would send my reply just to Eric, so I did
Reply-All. I just did a quick search for list etiquette for the list
but didn't see anything obvious.

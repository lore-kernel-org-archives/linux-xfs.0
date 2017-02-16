Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:36028 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752649AbdBPI5q (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 16 Feb 2017 03:57:46 -0500
Date: Thu, 16 Feb 2017 09:57:44 +0100
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: XFS doesn't auto mount on boot when /etc/fstab entry has fs type
 set to auto
Message-ID: <20170216085744.ahpphwbqh6o3rp3o@eorzea.usersys.redhat.com>
References: <CADWLRhrhPD9sPpXPFPx8BvsjwDc4nJFasTC8bRr+5rd3c48xxg@mail.gmail.com>
 <20170215122745.nmwkmcqo23ecfr53@eorzea.usersys.redhat.com>
 <CADWLRhoFdQUS-XjLj5R3JxjBnkXLN-TAjqCMBZDJWW36SOkWFw@mail.gmail.com>
 <CADWLRhpnnjCV=vigJPBAzJi8d5YLkgUXd=dn_iBakVic1UAPvw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CADWLRhpnnjCV=vigJPBAzJi8d5YLkgUXd=dn_iBakVic1UAPvw@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Vaibhaw Pandey <vaibhaw@scalegrid.io>
Cc: linux-xfs@vger.kernel.org

Hi,

On Thu, Feb 16, 2017 at 12:42:43PM +0530, Vaibhaw Pandey wrote:
> Sorry to chime in again but I was wondering if it makes sense to just
> add "xfs" to /etc/filesystems during installation of the package
> itself? It is visible in the /proc/filesystems once it is installed
> anyways. I have posed this question to the xfs@oss.sgi.com mailing
> list as well.
>
Just FYI, xfs@oss.sgi.org is no more, we have moved to vger, so, no one will
actually reply you there, always use linux-xfs@vger.kernel.org

Regarding your question, that is still a question not for XFS, /etc/filesystems
file doesn't belong to any xfs package, so we can't touch it, setting
/etc/filesystems is responsibility for another software, which, I *think* is
distro dependent.
 
Maybe it don't take too long by now, once many distros started to use XFS as
their default FS, but that might be a good idea to open a bug against the distro
you are using.

> On Thu, Feb 16, 2017 at 8:37 AM, Vaibhaw Pandey <vaibhaw@scalegrid.io> wrote:
> > Carlos,
> >
> > Thanks a lot for replying. :)
> >
> > I should have read the mount man page more carefully: By adding "xfs"
> > to /etc/filesystems, the /etc/fstab entry even with an auto started
> > working fine.
> >

Particularly I have never thought about adding something there because I always
use 'xfs' in fstab.

> > blkid always had an entry for the volume in question but that didn't
> > make a difference in this case:
> > $ sudo blkid
> > /dev/xvda1: LABEL="/" UUID="ebbf1f1c-fb71-40aa-93a3-056b455e5127" TYPE="ext4"
> > /dev/xvdb: UUID="bf4be26c-1c1c-40fc-b5cf-b9048dcc61b6" TYPE="xfs"
> >
> >
> >> Anyway, if you have the logs from your system when it tries to mount the
> >> partition maybe it give us some clue of what is happening.
> >
> > It was the complete lack of logs in dmesg or /var/log/messages about a
> > failure to mount is what confused me on why this was failing.

These logs won't appear in dmesg, this is the kernel log, what you should look
for is for `mount` logs. You are using systemd I suspect, if I am correct, you
will see such logs using `journalctl` command.

> > successful mount logs but an unsuccessful one doesn't. I think I will
> > ask a mount expert for help on this.
> >

Hope it have helped,

Cheers
-- 
Carlos

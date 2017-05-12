Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([217.72.192.74]:51264 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932922AbdELQZC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 12 May 2017 12:25:02 -0400
From: Hans-Peter Jansen <hpj@urpla.net>
Subject: Re: permanent XFS volume corruption
Date: Fri, 12 May 2017 18:23:48 +0200
Message-ID: <1734059.x4Ie82qtds@xrated>
In-Reply-To: <5915EEA7020000780015958E@prv-mh.provo.novell.com>
References: <591493D00200007800158EA3@prv-mh.provo.novell.com>
 <23c75521-a65b-d105-f274-3d1aba09e6ae@sandeen.net>
 <5915EEA7020000780015958E@prv-mh.provo.novell.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jan Beulich <JBeulich@suse.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, linux-xfs@vger.kernel.org

On Freitag, 12. Mai 2017 09:19:35 Jan Beulich wrote:
> >>> On 12.05.17 at 17:04, <sandeen@sandeen.net> wrote:
> > However:
> > 
> > With further testing I see that xfs_repair v3.1.8 /does not/
> > entirely fix the fs; if I run 3.1.8 and then run upstream repair, it
> > finds and fixes more bad flags on inode 764 (lib/xenstored/tdb) that 3.1.8
> > didn't touch.  The verifiers in an upstream kernel may keep tripping
> > over that until newer repair fixes it...
> 
> Well, I can see if I can build those newer tools for myself (would
> largely depend on how easy/difficult they are to configure/make,
> and whether there's a testsuite that I can run them over before
> allowing them to touch live data); I don't expect newer tools to
> be available for the distro I'm running.

Pretty sure, you're running some SuSE derivative. Building the xfstools 
usually is pretty simple with OBS, I do that all the time for unsupported 
distros:

	https://build.opensuse.org/project/show/home:frispete:tools

If BS wouldn't be down at the moment, I could look, if xfstests run as well, 
but since you have a backup of course, the risk of damaging your system with  
newer xfstools is pretty low. It saved my ass a couple of times...

Good luck,
Pete

who notoriously runs outphased SuSE versions (e.g. 9.3 on my PBX)


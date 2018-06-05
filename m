Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wr0-f193.google.com ([209.85.128.193]:35948 "EHLO
        mail-wr0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751464AbeFEI3V (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 5 Jun 2018 04:29:21 -0400
Received: by mail-wr0-f193.google.com with SMTP id f16-v6so1397486wrm.3
        for <linux-xfs@vger.kernel.org>; Tue, 05 Jun 2018 01:29:21 -0700 (PDT)
Date: Tue, 5 Jun 2018 10:29:17 +0200
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: Strange XFS problem
Message-ID: <20180605082917.azuql22j5wnb7wof@odin.usersys.redhat.com>
References: <e462d333d2089a7c3c59e7584fa83f720365fa46.camel@quantentunnel.de>
 <0ae6d0d5984dcd9c703720bdf41b6da1333267b0.camel@quantentunnel.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <0ae6d0d5984dcd9c703720bdf41b6da1333267b0.camel@quantentunnel.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Thorsten Hufnagel <Mondsuechtig@quantentunnel.de>
Cc: linux-xfs@vger.kernel.org

On Sun, Jun 03, 2018 at 04:32:24AM +0200, Thorsten Hufnagel wrote:
> I just Got it.
> 
> The issue seemed to got fixed with 4.16.0-rc1.
> 
> Downloading / compiling / using the 4.16.1 version solved my issue.
> 
> Sorry for bothering,
> 
> Thorsten
> 
> 
Good it worked out, but:

> > "
> > mount: /mnt/test: Falscher Dateisystemtyp, ungültige Optionen, der
> > Superblock von /dev/md2 ist beschädigt, fehlende Kodierungsseite oder
> > ein anderer Fehler.
> > "

> > 
> > And "xfs_repair -L" results in 
> > 
> > "
> > Phase 1 - Superblock finden und überprüfen...
> >         - Berichts-Prozess in Abständen von 15 Minutes
> > Phase 2 - ein internes Protokoll benutzen
> >         - Null-Protokoll...

Please at least translate the message to english before posting it to the list

Me and several other developers on the list doesn't speak a single word in
German, and going to the .po files to find the translation is too time
consuming.

Cheers.


> > Log inconsistent or not a log (last==0, first!=1)
> > empty log check failed
> > zero_log: cannot find log head/tail (xlog_find_tail=22)
> > "
> > 
> > Sounds linke some kind of "Hen-egg" problem.
> > 
> > Is there any change to get the XFS file sytem back running without
> > recreating the filesystem?
> > 
> > Kernel:
> > 
> > "
> > uname -r
> > 4.16.12-1-default
> > "
> > 
> > Distribution: "Opensuse - Tumbleween"
> > 
> > XFS tools: "xfs_repair Version 4.15.1"
> > 
> > Thank you in advance,
> > Kind regards,
> > 
> > Thorsten Hufnagel
> > 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Carlos

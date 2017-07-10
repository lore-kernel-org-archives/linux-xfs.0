Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:46254 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754428AbdGJQvx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 10 Jul 2017 12:51:53 -0400
Date: Mon, 10 Jul 2017 09:51:41 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: XFS hang - 4.4.73 longterm
Message-ID: <20170710165141.GK4103@magnolia>
References: <12EF8D94C6F8734FB2FF37B9FBEDD173010E02746C@EXCHANGE.collogia.de>
 <20170706002436.GA5068@magnolia>
 <12EF8D94C6F8734FB2FF37B9FBEDD173010E027537@EXCHANGE.collogia.de>
 <20170707034713.GD4103@magnolia>
 <12EF8D94C6F8734FB2FF37B9FBEDD173010E0284F8@EXCHANGE.collogia.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <12EF8D94C6F8734FB2FF37B9FBEDD173010E0284F8@EXCHANGE.collogia.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Markus Stockhausen <stockhausen@collogia.de>
Cc: "'linux-xfs@vger.kernel.org'" <linux-xfs@vger.kernel.org>

On Sun, Jul 09, 2017 at 05:01:25PM +0000, Markus Stockhausen wrote:
> > -----Ursprüngliche Nachricht-----
> > Von: Darrick J. Wong [mailto:darrick.wong@oracle.com] 
> > Gesendet: Freitag, 7. Juli 2017 05:47
> > An: Markus Stockhausen
> > Cc: 'linux-xfs@vger.kernel.org'
> > Betreff: Re: XFS hang - 4.4.73 longterm
> >
> > > > ...
> > > > This is the known deadlock in SEEK_HOLE/SEEK_DATA; I have patches queued to fix it in 4.13, as soon as the dust settles and I send the pull req.
> > > 
> > > Short, precise, frightening.
> > > 
> > > Can you advise what will the best option to avoid that error. 
> > > First things that come to my mind would be:
> > > 
> > > - get back to original 3.10 stable kernel from CentOS Distro
> > > - lower NFS mount version
> > > - Maybe remove some single patch that introduced the error?
> >
> > Unfortunately, SEEK_HOLE (and the deadlocky code) go all the way back to the beginning of SEEK_HOLE support, so I don't know that 
> > there's a good workaround for this.  There's not really a way to shut off support for it, either, that doesn't involve gross code surgery.
> 
> Not good news. Finally I disabled SEEK support in nfsd by partially
> reverting 3.18 patch 24bab491220faa446d94 "NFSD: Implement SEEK".
> While before NFS/XFS crashed with active VM snapshots and heavy disk
> writes after minutes it now runs for 2 days of intensive testing
> without errors.
> 
> At least now I have full discard support in side VMs (via hole
> punching of disk files).

I'd advise you to set an extent size hint to reduce fragmentation, the
same as we tell everyone else. :)

I'd also advise you not to punch too many holes in the VM files because
that increases extent map overhead.  There's also an unfortunate design
problem in the in-memory extent map -- all the extents have to fit in a
single chunk of memory -- and punching a lot of small holes when memory
is tight can lead to allocation failures.

(Even after we fix that problem I'd still advise against punching a lot
of small holes purely due to the overhead that creates.)

> I'm not familiar with SEEK_HOLE/SEEK_data feature. Do you see negative
> impact if disabling these? In contrast to falling back to NFS 4
> without seek + discard support.

Well, whatever program was using SEEK_{HOLE,DATA} to skip sparse holes
in the files will likely revert to a much slower "read the whole file
looking for block aligned zeroes" algorithm... assuming that was why it
was doing that in the first place.

FWIW I just sent off the 4.13 merge request with the SEEK_HOLE fixes,
though they depend on iomap, which (iirc) wasn't added to the vfs until
4.8 or so.

--D

> 
> Markus 

> ****************************************************************************
> Diese E-Mail enth??lt vertrauliche und/oder rechtlich gesch??tzte
> Informationen. Wenn Sie nicht der richtige Adressat sind oder diese E-Mail
> irrt??mlich erhalten haben, informieren Sie bitte sofort den Absender und
> vernichten Sie diese Mail. Das unerlaubte Kopieren sowie die unbefugte
> Weitergabe dieser Mail ist nicht gestattet.
> 
> ??ber das Internet versandte E-Mails k??nnen unter fremden Namen erstellt oder
> manipuliert werden. Deshalb ist diese als E-Mail verschickte Nachricht keine
> rechtsverbindliche Willenserkl??rung.
> 
> Collogia
> Unternehmensberatung AG
> Ubierring 11
> D-50678 K??ln
> 
> Vorstand:
> Kadir Akin
> Dr. Michael H??hnerbach
> 
> Vorsitzender des Aufsichtsrates:
> Hans Kristian Langva
> 
> Registergericht: Amtsgericht K??ln
> Registernummer: HRB 52 497
> 
> This e-mail may contain confidential and/or privileged information. If you
> are not the intended recipient (or have received this e-mail in error)
> please notify the sender immediately and destroy this e-mail. Any
> unauthorized copying, disclosure or distribution of the material in this
> e-mail is strictly forbidden.
> 
> e-mails sent over the internet may have been written under a wrong name or
> been manipulated. That is why this message sent as an e-mail is not a
> legally binding declaration of intention.
> 
> Collogia
> Unternehmensberatung AG
> Ubierring 11
> D-50678 K??ln
> 
> executive board:
> Kadir Akin
> Dr. Michael H??hnerbach
> 
> President of the supervisory board:
> Hans Kristian Langva
> 
> Registry office: district court Cologne
> Register number: HRB 52 497
> 
> ****************************************************************************

